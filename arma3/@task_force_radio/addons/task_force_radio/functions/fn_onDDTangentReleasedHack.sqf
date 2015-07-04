/*
	Description:
		An event handler callback function for Key Up events that get
		associated to a Display in ClientInit.sqf. Verifies that the
		DDTransmit key was being pressed before allowing
		onDDTangentReleased to be called.
	
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
	"_keybind_dd",
	// [STRING] The DIK code for the DDTransmit key bind
	"_scancode_dd",
	/*
	 * [NUMBER[]] The modifier keys for the DDTransmit keybind,
	 * same structure as _mods_pressed
	 */
	"_mods_dd",
	/*
	 * [BOOLEAN] Used to determine if the user is currently pressing
	 * the exact DDTransmit key combination
	 */
	"_was_dd_pressed"
];

// Get the DIK code of the key that is currently being pressed
_scancode_pressed = _this select 1;

// Get the state of each modifier key currently pressed
_mods_pressed = [_this select 2, _this select 3, _this select 4];

// Get the current keybind for DDTransmit
_keybind_dd = ["TFAR", "DDTransmit"] call cba_fnc_getKeybind;

if (!(isNil "_keybind_dd")) then {

	// Get the DIK code for the DDTransmit key bind
	_scancode_dd = ((_keybind_dd) select 5) select 0;
	
	// Get the modifier keys for the DDTransmit key bind
	_mods_dd = ((_keybind_dd) select 5) select 1;
	
	// If the DIK code AND the modifier keys of the keybind
	// match those of the current key event, then the user
	// is releasing the DD Transmit key
	_was_dd_pressed = ((_mods_pressed isEqualTo _mods_dd) &&
			(_scancode_pressed == _scancode_dd));

	// Proceed with DD Released event handler
	if (_was_dd_pressed) then {
		call TFAR_fnc_onDDTangentReleased;
	};
};
false