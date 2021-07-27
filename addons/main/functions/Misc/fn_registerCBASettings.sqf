// Register CBA settings
[
    "JIB_RM_enableEventHandlers",
    "CHECKBOX",
    [
        "Mod enabled",
        "Master switch to enable mod. If below conditions met, received markers become local."
    ],
    "Restrict Markers",
    true,
    1,
    nil,
    false
] call CBA_fnc_addSetting;
[
    "JIB_RM_restrictBriefing", // Global variable name
    "CHECKBOX",                // Type
    [
        "Restrict markers during briefing",
        "If enabled, markers during briefing (map screen) only share to nearby players."
    ],                         // Title (or [title, tooltip])
    "Restrict Markers",        // Category (or [category, subcategory])
    true,                      // Value info (depends on type)
    1,                         // Global
    nil,                       // Code when changed (_this = new value)
    false                      // Need mission restart
] call CBA_fnc_addSetting;
[
    "JIB_RM_restrictMission",
    "CHECKBOX",
    [
        "Restrict markers during mission",
        "If enabled, markers during mission only share to nearby players."
    ],
    "Restrict Markers",
    true,
    1,
    nil,
    false
] call CBA_fnc_addSetting;
[
    "JIB_RM_shareDistance",
    "SLIDER",
    [
        "Distance to share markers",
        "Max distance to share markers to nearby players (default: 7)."
    ],
    "Restrict Markers",
    [0, 30, 7, 1],
    1,
    nil,
    false
] call CBA_fnc_addSetting;
