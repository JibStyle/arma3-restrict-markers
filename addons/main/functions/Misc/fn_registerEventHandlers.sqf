// Register mission event handlers
JIB_RM_phase = "BRIEFING";
addMissionEventHandler [
    "PreloadFinished",
    {
        JIB_RM_phase = "MISSION";
    }
];
addMissionEventHandler [
    "MarkerCreated",
    {
        if (!JIB_RM_enableEventHandlers) exitWith {};
        _this call JIB_RM_fnc_markerCreated;
    }
];
addMissionEventHandler [
    "MarkerUpdated",
    {
        if (!JIB_RM_enableEventHandlers) exitWith {};
        _this call JIB_RM_fnc_markerUpdated;
    }
];
addMissionEventHandler [
    "MarkerDeleted",
    {
        if (!JIB_RM_enableEventHandlers) exitWith {};
        _this call JIB_RM_fnc_markerDeleted;
    }
];
