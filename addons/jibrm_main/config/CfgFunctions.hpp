class CfgFunctions {
    class jibrm_main {
        class jibrm_main {
            file = "jibrm_main\functions";
            requiredAddons[] = {"cba_settings"};

            class registerCBASettings {};
            class registerEventHandlers {
                postInit = 1;
            };
            class markerCreated {};
            class markerUpdated {};
            class markerDeleted {};
            class shareMarker {};
        };
    };
};
