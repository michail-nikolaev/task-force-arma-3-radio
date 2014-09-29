/*
 	Name: TFAR_fnc_canUseLrRadio
 	
 	Author(s):
		NKey

 	Description:
		Checks whether the radio would be able to be used at passed depth.
	
	Parameters:
		0: OBJECT - Unit
		1: BOOLEAN - Isolated and inside
		2: BOOLEAN - Can Speak
		3: NUMBER - Depth
 	
 	Returns:
		BOOLEAN
 	
 	Example:
		_canUseSW = [player, false, false, 10] call TFAR_fnc_canUseLrRadio;
*/
private ["_player", "_isolated_and_inside", "_result", "_depth"];

_depth = _this select 2;
_result = false;

if (_depth > 0) then {
	_result = true;
} else {
	_player = _this select 0;
	_isolated_and_inside = _this select 1;
	if ((vehicle _player != _player) and {_depth > TF_UNDERWATER_RADIO_DEPTH}) then {
		if ((_isolated_and_inside) or {isAbleToBreathe _player}) then {
			_result = true;
		};
	};
};

_result