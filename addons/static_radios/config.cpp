#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {"TFAR_Module_staticRadio"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Modules_F",
            "tfar_core",
            "3DEN"
        };
        Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

#include "CfgVehicles.hpp"
