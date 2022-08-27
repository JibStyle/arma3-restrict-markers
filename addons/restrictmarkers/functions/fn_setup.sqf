// Register event handlers on all clients
if (!isServer) exitWith {};

// PUBLIC INTERFACE
//
// These variables can be set to control the behavior of this addon.
//
// NOTE: If modifying these variables, you must call `publicVariable`
// to broadcast their new values to all clients.

// Master switch to enable the mod.
//
// Can be toggled mid mission as needed (eg. around briefing).
jib_restrictmarkers_enabled = true;

// Distance restricted markers should share.
//
// Think of this as how far away you would be able to see another
// player's map in real life.
jib_restrictmarkers_shareDistance = 7;

// PRIVATE IMPLEMENTATION
//
// Everything below here is considered private.

// Magic tag for identifying processed markers
jib_restrictmarkers_magicTag = "jib_restrictmarkers_local";

// Stamp a marker string with owner ID and magic tag.
//
// The owner ID is used to make each client's local marker unique,
// and the magic tag is used to prevent inifinite recursion in the
// event handlers. This function can be used to re-stamp a marker
// with a different client ID.
jib_restrictmarkers_stampMarker = {
    params ["_marker", "_ownerID"];

    // Strip magic tag and owner ID (if any) to get base marker.
    //
    // Regex compiled every time. Hopefully won't impact performance
    // noticeably. Will only occur when players interact with markers
    // which shouldn't be too frequent.
    private _baseMarker = _marker regexReplace [
        format [
            " %1 [0-9]+",
            jib_restrictmarkers_magicTag
        ],
        ""
    ];

    // (Re)-Stamp marker with magic tag and specified owner ID
    format [
        "%1 %2 %3",
        _baseMarker,
        jib_restrictmarkers_magicTag,
        _ownerID
    ];
};

// Check if a marker is stamped
jib_restrictmarkers_isMarkerStamped = {
    params ["_marker"];
    _marker find jib_restrictmarkers_magicTag > -1;
};

// Check if a marker is player created (ie not via a script)
jib_restrictmarkers_isMarkerPlayerCreated = {
    params ["_marker"];
    _marker find "_USER_DEFINED" > -1;
};

// Check if a marker event should be shared
jib_restrictmarkers_canShare = {
    params [
        "_owner" // Unit (a player) that created the marker
    ];
    (
        player distance _owner <= jib_restrictmarkers_shareDistance
            && alive player
    )
        || !jib_restrictmarkers_enabled;
};

// Replace marker with a local instance
//
// The local marker name includes a tag so we can break an infinite
// loop of processing (the local marker triggers the markerCreated
// event handler recursively).
//
// NOTE: This function must be spawned to avoid a crash.
jib_restrictmarkers_processMarker = {
    params ["_marker", "_owner"];

    // Wait for ACE to maybe set direction
    _marker setMarkerAlphaLocal 0;
    uiSleep 0.25;

    private _markerChannel = markerChannel _marker;
    private _markerColor = markerColor _marker;
    private _markerDir = markerDir _marker;
    private _markerPolyline = markerPolyline _marker;
    private _markerPos = markerPos _marker;
    private _markerSize = markerSize _marker;
    private _markerText = markerText _marker;
    private _markerType = markerType _marker;

    // Delete global marker so JIP don't get it later.
    [_marker] spawn {
        params ["_marker"];

        // Move marker out of the way
        _marker setMarkerPosLocal [-1000, -1000];

        // Give some time for network sync
        uiSleep 5;

        deleteMarker _marker;
    };

    private _localMarker = createMarkerLocal [
        // Marker name is important.
        //
        // Including text from original name enables user
        // interaction. Stamping with magic tag allows EH to break
        // infinite loop. Stamping with local client ID makes it
        // unique so it doesn't get deleted when other players delete
        // their version of the marker.
        [_marker, clientOwner] call jib_restrictmarkers_stampMarker,
        _markerPos,
        _markerChannel,
        _owner
    ];
    _localMarker setMarkerColorLocal _markerColor;
    if (count _markerPolyline >= 4) then {
        // [x1, y1, x2, y2, ..., xn, yn]
        _localMarker setMarkerPolylineLocal _markerPolyline;
    };
    _localMarker setMarkerDirLocal _markerDir;
    _localMarker setMarkerSizeLocal _markerSize;
    _localMarker setMarkerTextLocal _markerText;
    // _localMarker setMarkerTextLocal format [
    //     "LOCAL %1", _markerText
    // ];
    _localMarker setMarkerTypeLocal _markerType;
};
// Discard (delete locally) a marker
//
// NOTE: This function must be spawned to avoid a crash.
jib_restrictmarkers_discardMarker = {
    params ["_marker"];
    deleteMarkerLocal _marker;
};

// Handle the markerCreated event
//
// The event fires for all created markers, including script created
// and player created. When processing a player created marker, we
// create a local marker which triggers this event recursively, so we
// must detect that case and avoid infinite recursion.
jib_restrictmarkers_markerCreated = {
    params [
        "_marker",
        "_channelNumber",
        "_owner",
        "_local"
    ];

    // If share enabled then revert to vanilla behavior
    if (!jib_restrictmarkers_enabled) exitWith {};

    // Only process player created markers
    if (
        [_marker] call jib_restrictmarkers_isMarkerPlayerCreated
            == false
    ) exitWith {};

    // Break infinite loop
    if (
        [_marker] call jib_restrictmarkers_isMarkerStamped
    ) exitWith {};

    // Filter if marker can be shared
    if (
        [_owner] call jib_restrictmarkers_canShare
    ) then {
        // Process the marker
        [_marker, _owner] spawn jib_restrictmarkers_processMarker;
    } else {
        // Discard the marker
        [_marker] spawn jib_restrictmarkers_discardMarker;
    };
};

// Handle stamped marker deletion event
jib_restrictmarkers_stampedMarkerDeleted = {
    params [
        "_owner", // Unit (a player) that deleted the marker
        "_marker" // Stamped marker string
    ];

    if (
        [_owner] call jib_restrictmarkers_canShare
    ) then {
        deleteMarkerLocal (
            // Re-stamp with own client ID before deleting
            [
                _marker,
                clientOwner
            ] call jib_restrictmarkers_stampMarker
        );
    };
};

// Handle the markerDeleted event
jib_restrictmarkers_markerDeleted = {
    params ["_marker", "_local"];

    // Only handle stamped markers
    if (
        [_marker] call jib_restrictmarkers_isMarkerStamped == false
    ) exitWith {};

    // Broadcast to all clients.
    //
    // When a player deletes a stamped marker, the "markerDeleted"
    // event doesn't fire on other clients because stamped markers
    // are local. As a workaround, the client of the player deleting
    // the stamped marker spawns a method on all client via
    // `remoteExec`.
    [player, _marker] remoteExec [
        "jib_restrictmarkers_stampedMarkerDeleted",
        0,
        true
    ];
};

// Register the event handlers for processing markers
jib_restrictmarkers_registerEventHandlers = {
    if (!hasInterface) exitWith {};
    addMissionEventHandler [
        "MarkerCreated",
        jib_restrictmarkers_markerCreated
    ];
    addMissionEventHandler [
        "MarkerDeleted",
        jib_restrictmarkers_markerDeleted
    ];
};

// Publish variables and functions
publicVariable "jib_restrictmarkers_enabled";
publicVariable "jib_restrictmarkers_shareDistance";
publicVariable "jib_restrictmarkers_magicTag";
publicVariable "jib_restrictmarkers_stampMarker";
publicVariable "jib_restrictmarkers_isMarkerStamped";
publicVariable "jib_restrictmarkers_isMarkerPlayerCreated";
publicVariable "jib_restrictmarkers_canShare";
publicVariable "jib_restrictmarkers_processMarker";
publicVariable "jib_restrictmarkers_discardMarker";
publicVariable "jib_restrictmarkers_markerCreated";
publicVariable "jib_restrictmarkers_stampedMarkerDeleted";
publicVariable "jib_restrictmarkers_markerDeleted";
publicVariable "jib_restrictmarkers_registerEventHandlers";

// Register on all clients
[] remoteExec ["jib_restrictmarkers_registerEventHandlers", 0, true];
