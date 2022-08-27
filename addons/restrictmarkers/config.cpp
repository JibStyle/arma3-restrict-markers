class CfgPatches {
    class jib_restrictmarkers {
        name = "Restrict Markers";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_restrictmarkers_disable",
            "jib_restrictmarkers_enable",
        };
    };
};

class CfgFunctions {
    class jib_restrictmarkers {
        class jib_restrictmarkers {
            file = "x\jib_restrictmarkers\addons\restrictmarkers\functions";
            class setup {
                recompile = 1;
                postInit = 1;
            };
            class disable {
                recompile = 1;
            };
            class enable {
                recompile = 1;
            };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_restrictmarkers: NO_CATEGORY {
        displayName = "Restrict Markers";
    };
};

class CfgVehicles
{
    class Module_F;
    class jib_restrictmarkers_disable: Module_F {
        scope=2;
        scopeCurator=2;
        category = "jib_restrictmarkers";
        displayName = "Disable Restrict Markers";
        function = "jib_restrictmarkers_fnc_disable";
    };
    class jib_restrictmarkers_enable: Module_F {
        scope=2;
        scopeCurator=2;
        category = "jib_restrictmarkers";
        displayName = "Enable Restrict Markers";
        function = "jib_restrictmarkers_fnc_enable";
    };
};
