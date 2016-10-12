class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
        disableModuload = true;
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
        disableModuload = true;
    };
};

class Extended_DisplayLoad_EventHandlers { //From commy2
    class RscDisplayArsenal {
        //Actually gets called after units backpack was already replaced
        TFAR_ArsenalOpened = "'PreOpen' call TFAR_fnc_onArsenal";
    };
};

class RscListBox;
class RscDisplayArsenal {
    class Controls {
        class ListBackpack : RscListBox {
            onLoad = "'PrePreOpen' call TFAR_fnc_onArsenal"; //Called before PreOpen.
        };
    };
};
