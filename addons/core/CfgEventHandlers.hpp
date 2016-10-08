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
        TFAR_ArsenalOpened = "diag_log 'EHARSENAL';'PreOpen' call TFAR_fnc_onArsenal";
    };
};
