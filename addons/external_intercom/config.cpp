#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = "TFAR - Intercom Phone";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "tfar_core"
        };
        author = ECSTRING(core,AUTHORS);
        server_api = SERVER_API_VERSION;
        VERSION_CONFIG;
    };
};

class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
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

class CfgUIGrids { //Thanks ACE guys!
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_TFAR_External_Intercom_Phone[] = {
                        {
                            "0.80 * safezoneW + safezoneX",
                            "0.9 * safezoneH + safezoneY",
                            "(4 * (1.5 * (((safezoneW / safezoneH) min 1.2) / 50)))",
                            "(4 * (1.8 * (((safezoneW / safezoneH) min 1.2) / 50)))"
                        },
                        "(1 * (((safezoneW / safezoneH) min 1.2) / 50))",
                        "(1 * (((safezoneW / safezoneH) min 1.2) / 50))"
                    };
                };
            };
        };
        class Variables {
            class grid_TFAR_External_Intercom_Phone{
                displayName = CSTRING(EXTERNAL_INTERCOM_PHONE_INDICATOR);
                description = CSTRING(EXTERNAL_INTERCOM_PHONE_INDICATOR);
                preview = QPATHTOF(ui\tfar_external_intercom_phone.paa);
                saveToProfile[] = {0,1,2,3};
                canResize = 1;
            };
        };
    };
};

#include "RscTitles.hpp"
#include "CfgVehicles.hpp"
