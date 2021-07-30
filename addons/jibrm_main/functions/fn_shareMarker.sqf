// Check if marker allowed
params [
    _phase,            // "BRIEFING" or "MISSION"
    _restrictBriefing, // Restrict briefing
    _restrictMission,  // Restrict mission
    _distance,         // Distance to owner
    _maxDistance       // Max allowed distance
];
if (_phase == "BRIEFING") then {
    if (_restrictBriefing) then {
        _distance <= _maxDistance;
    } else {
        true;
    };
} else {
    if (_restrictMission) then {
        _distance <= _maxDistance;
    } else {
        true;
    };
};
