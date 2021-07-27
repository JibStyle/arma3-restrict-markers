params ["_marker", "_channelNumber", "_owner", "_local"];
systemChat format [
    "Marker: %1, channel: %2, owner: %3, local: %4",
    _marker, _channelNumber, _owner, _local
];

if (
    _marker find "_USER_DEFINED" == -1 // Scripted marker
        || _local                      // Break infinite loop
) exitWith {}; // Avoid processing some markers

if (
    [
        JIB_RM_phase,
        JIB_RM_restrictBriefing,
        JIB_RM_restrictMission,
        player distance _owner,
        JIB_RM_shareDistance
    ] call JIB_RM_fnc_shareMarker
) then {
    // Schedule to fix crash
    [_marker, _owner] spawn {
        params ["_marker", "_owner"];

        // Wait for ACE to maybe set direction
        _marker setMarkerAlphaLocal 0;
        uiSleep 0.25;

        _markerChannel = markerChannel _marker;
        _markerColor = markerColor _marker;
        _markerDir = markerDir _marker;
        _markerPolyline = markerPolyline _marker;
        _markerPos = markerPos _marker;
        _markerText = markerText _marker;
        _markerType = markerType _marker;
        deleteMarkerLocal _marker; // Must be scheduled

        _localMarker = createMarkerLocal [
            // format ["%1 JIB_RM %2", _marker, getPlayerID player],
            format ["JIB_RM %1", _marker],
            _markerPos,
            _markerChannel,
            _owner
        ];
        _localMarker setMarkerColorLocal _markerColor;
        if (count _markerPolyline >= 4) then { // [x1, y1, x2, y2, ..., xn, yn]
            _localMarker setMarkerPolylineLocal _markerPolyline;
        };
        _localMarker setMarkerDirLocal _markerDir;
        _localMarker setMarkerTextLocal _markerText;
        _localMarker setMarkerTypeLocal _markerType;
    };
} else {
    // Schedule to fix crash
    [_marker] spawn {
        params ["_marker"];
        deleteMarkerLocal _marker;
    };
};
