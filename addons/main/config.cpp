class CfgPatches {
    class jib_marker {
        name = "Restrict Markers";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_marker_moduleDisable",
            "jib_marker_moduleEnable",
        };
    };
};

class CfgFunctions {
    class jib_marker {
        class jib_marker {
            file = "x\jib_marker\addons\main";
            class marker { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_marker: NO_CATEGORY { displayName = "Restrict Markers"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_marker_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_marker";
    };
    class jib_marker_moduleDisable: jib_marker_module {
        scopeCurator=2;
        displayName = "Disable Restrict Markers";
        function = "jib_marker_moduleDisable";
    };
    class jib_marker_moduleEnable: jib_marker_module {
        scopeCurator=2;
        displayName = "Enable Restrict Markers";
        function = "jib_marker_moduleEnable";
    };
};
