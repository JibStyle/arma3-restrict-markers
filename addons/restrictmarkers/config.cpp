class CfgPatches {
    class jibrm_restrictmarkers {
        name = "Restrict Markers";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jibrm_restrictmarkers_registerEH",
            "jibrm_restrictmarkers_disableSharing",
            "jibrm_restrictmarkers_enableSharing",
        };
    };
};

class CfgFunctions {
    class jibrm_restrictmarkers {
        class jibrm_restrictmarkers {
            file = "x\jibrm\addons\restrictmarkers\functions";
            class registerEH {
                recompile = 1;
                postInit = 1;
            };
            class disableSharing {
                recompile = 1;
            };
            class enableSharing {
                recompile = 1;
            };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jibrm_restrictmarkers: NO_CATEGORY {
        displayName = "Restrict Markers";
    };
};

class CfgVehicles
{
    class Module_F;
    class jibrm_restrictmarkers_disableSharing: Module_F {
        scope=2;
        scopeCurator=2;
        category = "jibrm_restrictmarkers";
        displayName = "Disable Sharing";
        function = "jibrm_restrictmarkers_fnc_disableSharing";
    };
    class jibrm_restrictmarkers_enableSharing: Module_F {
        scope=2;
        scopeCurator=2;
        category = "jibrm_restrictmarkers";
        displayName = "Enable Sharing";
        function = "jibrm_restrictmarkers_fnc_enableSharing";
    };
};
