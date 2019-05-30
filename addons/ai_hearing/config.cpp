#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {""};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Modules_F",
            "tfar_core"
        };
        Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
        VERSION_CONFIG;
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_PreInit));
    };
};
