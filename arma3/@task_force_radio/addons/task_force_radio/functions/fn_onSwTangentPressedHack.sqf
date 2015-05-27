    /*
        Description:
            An event handler callback function for keypress events that get
            associated to a Display in ClientInit.sqf. Verifies that the
            SWTransmit key is currently being pressed before allowing
            onSwTangentPressed to be called.
        
        Parameters: 
            _this [Array]
            [
                0 : ? unused
                1 : [STRING] DIK code of current key pressed
                2 : [BOOLEAN] Current state of SHIFT key - true if pressed, false otherwise
                3 : [BOOLEAN] Current state of CTRL key - true if pressed, false otherwise
                4 : [BOOLEAN] Current state of ALT key - true if pressed, false otherwise 
            ]
        
        Returns:
            Boolean - whether to override default engine handling for keyboard
                events (always returns false)
            
        See Also:
            https://community.bistudio.com/wiki/displayAddEventHandler
            https://dev.withsix.com/projects/cca/wiki/Keybinding
    */

    private [
        // [STRING] The DIK code of the currently pressed key
        "_scancode_pressed",
        /*
         * [BOOLEAN[]] State of modifier keys [SHIFT, CTRL, ALT]
         * for the current key press event, where the values will
         * be false when not pressed or true when pressed
         *
         * For example, [false, true, true] would mean that the user is
         * currently pressing CTRL and ALT, but not SHIFT
         */
        "_mods_pressed",
        //[OBJECT] CBA Keybind data for the current key press event
        "_keybind_sw",
        // [STRING] The DIK code for the SWTransmit key bind
        "_scancode_sw",
        /*
         * [NUMBER[]] The modifier keys for the SWTransmit keybind,
         * same structure as _mods_pressed
         */
        "_mods_sw",
        /*
         * [BOOLEAN] Used to determine if the user is currently pressing
         * the exact SWTransmit key combination
         */
        "_is_sw_pressed"
    ];

    // Ensure that the player has a radio
    if !(call TFAR_fnc_isAbleToUseRadio) then {
        // Get the DIK code of the key that is currently being pressed
        _scancode_pressed = _this select 1;
        
        // Get the state of each modifier key currently pressed
        _mods_pressed = [_this select 2, _this select 3, _this select 4];
        
        // Get the current keybind for SWTransmit
        _keybind_sw = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
        
        if (!(isNil "_keybind_sw")) then {
        
            // Get the DIK code for the SWTransmit key bind
            _scancode_sw = ((_keybind_sw) select 5) select 0;
            
            // Get the modifier keys for the SWTransmit key bind
            _mods_sw = ((_keybind_sw) select 5) select 1;
            
            // If the DIK code AND the modifier keys of the keybind
            // match those of the current key event, then the user
            // is transmitting on SW
            _is_sw_pressed = ((_mods_pressed isEqualTo _mods_sw) &&
                    (_scancode_pressed == _scancode_sw));

            // Proceed with SWTransmit event handler
            if (_is_sw_pressed) then {
                call TFAR_fnc_onSwTangentPressed;
            };
        };
    };
    false