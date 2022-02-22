params ["_logic", "_units", "_isActivated"];
if (!_isActivated) exitWith {};
if (!isServer) exitWith {};
if (not isNil "jibrm_restrictmarkers_didRegister") exitWith {
    deleteVehicle _logic;
    false;
};
if (isNil "jibrm_restrictmarkers_shareEnabled") then {
    jibrm_restrictmarkers_shareEnabled = true;
    publicVariable "jibrm_restrictmarkers_shareEnabled";
};
#define DEFAULT_SHARE_DISTANCE 7
#define LOCAL_TAG "jibrm_restrictmarkers_local"

[[], {
    if (!hasInterface) exitWith {};
    if (isNil "jibrm_markers_shareDistance") then {
        jibrm_markers_shareDistance = DEFAULT_SHARE_DISTANCE;
    };
    addMissionEventHandler [
        "MarkerCreated",
        {
            if (jibrm_restrictmarkers_shareEnabled) exitWith {};
            params ["_marker", "_channelNumber", "_owner", "_local"];
            // systemChat format [
            //     "Marker created: %1, channel: %2, owner: %3, local: %4",
            //     _marker, _channelNumber, _owner, _local
            // ];

            // Don't process scripted markers
            if (_marker find "_USER_DEFINED" == -1) exitWith {};
            // Break infinite loop
            if (_marker find LOCAL_TAG > -1) exitWith {};
            // Delete global marker so JIP don't get it later
            if (_local) then {
                [_marker] spawn {
                    params ["_marker"];
                    uiSleep 1;
                    deleteMarker _marker;
                };
            };

            if (
                alive player
                    && player distance _owner <= jibrm_markers_shareDistance
            ) then {
                // Schedule to fix crash
                [_marker, _owner] spawn {
                    params ["_marker", "_owner"];

                    // Wait for ACE to maybe set direction
                    _marker setMarkerAlphaLocal 0;
                    uiSleep 0.25;

                    private _markerChannel = markerChannel _marker;
                    private _markerColor = markerColor _marker;
                    private _markerDir = markerDir _marker;
                    private _markerPolyline = markerPolyline _marker;
                    private _markerPos = markerPos _marker;
                    private _markerText = markerText _marker;
                    private _markerType = markerType _marker;
                    deleteMarkerLocal _marker; // Must be scheduled

                    private _localMarker = createMarkerLocal [
                        format [
                            "%1 %2 %3",
                            _marker,    // Enable user interaction
                            LOCAL_TAG,  // Break infinite loop
                            clientOwner // Unique so other player can't delete
                        ],
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
                    _localMarker setMarkerTextLocal _markerText;
                    // _localMarker setMarkerTextLocal format [
                    //     "LOCAL %1", _markerText
                    // ];
                    _localMarker setMarkerTypeLocal _markerType;
                };
            } else {
                // Schedule to fix crash
                [_marker] spawn {
                    params ["_marker"];
                    deleteMarkerLocal _marker;
                };
            };
        }
    ];

    addMissionEventHandler [
        "MarkerDeleted",
        {
            params ["_marker", "_local"];
            // systemChat format [
            //     "Marker deleted: %1, local: %2",
            //     _marker, _local
            // ];

            if (_marker find LOCAL_TAG > -1) then {
                private _markerBase =
                    (_marker regexFind ["(.*) [0-9]+"]) # 0 # 1 # 0;
                [[player, _markerBase], {
                    params ["_owner", "_markerBase"];
                    if (
                        jibrm_restrictmarkers_shareEnabled
                            || (alive player
                                && (
                                    player distance _owner
                                        <= jibrm_markers_shareDistance))
                    ) then {
                        private _marker =
                            format ["%1 %2", _markerBase, clientOwner];
                        deleteMarkerLocal _marker;
                    };
                }] remoteExec ["spawn", 0, true];
            };
        }
    ];
}] remoteExec ["spawn", 0, true];

jibrm_restrictmarkers_didRegister = true;
deleteVehicle _logic;
true;
