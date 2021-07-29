// Register mission event handlers
jibrm_main_phase = "BRIEFING";
addMissionEventHandler [
    "PreloadFinished",
    {
        jibrm_main_phase = "MISSION";
    }
];
addMissionEventHandler [
    "MarkerCreated",
    {
        if (!jibrm_main_enableEventHandlers) exitWith {};
        _this call jibrm_main_fnc_markerCreated;
    }
];
addMissionEventHandler [
    "MarkerUpdated",
    {
        if (!jibrm_main_enableEventHandlers) exitWith {};
        _this call jibrm_main_fnc_markerUpdated;
    }
];
addMissionEventHandler [
    "MarkerDeleted",
    {
        if (!jibrm_main_enableEventHandlers) exitWith {};
        _this call jibrm_main_fnc_markerDeleted;
    }
];
