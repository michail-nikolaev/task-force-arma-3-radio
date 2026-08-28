//type, some array, dunno, function, canUseWhileDead

["TFAR","OpenSWRadioMenu",[localize LSTRING(openSWMenu), localize LSTRING(openSWMenu)],{["player",[],-3,"_this call TFAR_fnc_swRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_sw_scancode, TF_dialog_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","OpenLRRadioMenu",[localize LSTRING(openLRMenu), localize LSTRING(openLRMenu)],{["player",[],-3,"_this call TFAR_fnc_lrRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_lr_scancode, TF_dialog_lr_modifiers],false] call cba_fnc_addKeybind;
