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

class Cfg3DEN {
    class Attributes {
        class slider;
        class tfar_static_radios_volumeSlider: slider {//Thanks to Baermitumlaut making Arma great again.
            attributeLoad = "params [""_ctrlGroup""]; private _slider = _ctrlGroup controlsGroupCtrl 100; private _edit = _ctrlGroup controlsGroupCtrl 101; _slider sliderSetPosition _value; _edit ctrlSetText ([_value, 1, 1] call CBA_fnc_formatNumber); ";
            attributeSave = "params [""_ctrlGroup""]; sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
            onLoad = "params [""_ctrlGroup""]; private _slider = _ctrlGroup controlsGroupCtrl 100; private _edit = _ctrlGroup controlsGroupCtrl 101; _slider sliderSetRange [1, 50]; _slider ctrlAddEventHandler [""SliderPosChanged"", { params [""_slider""]; private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101; private _value = sliderPosition _slider;  _edit ctrlSetText ([_value, 1, 1] call CBA_fnc_formatNumber); }]; _edit ctrlAddEventHandler [""KillFocus"", { params [""_edit""]; private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100; private _value = ((parseNumber ctrlText _edit) min 50) max 1; _slider sliderSetPosition _value; _edit ctrlSetText str _value; }];";
        };
    };
};



#include "CfgVehicles.hpp"
