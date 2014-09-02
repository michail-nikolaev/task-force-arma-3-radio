/*
 	Name: TFAR_fnc_preparePositionCoordinates
 	
 	Author(s):
		NKey

 	Description:
		Prepares the position coordinates of the passed unit.
	
	Parameters:
		0: OBJECT - unit
		1: BOOLEAN - Is near player
 	
 	Returns:
		Nothing
 	
 	Example:
		
*/
private ["_x_player","_isolated_and_inside","_can_speak", "_pos", "_depth", "_useSw", "_useLr", "_useDd"];
_unit = _this select 0;
_nearPlayer = _this select 1;

_pos = [_unit, _nearPlayer] call (_unit getVariable ["TF_fnc_position", TFAR_fnc_defaultPositionCoordinates]);
_isolated_and_inside = _unit call TFAR_fnc_vehicleIsIsolatedAndInside;
_depth = _unit call TFAR_fnc_eyeDepth;
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
_useSw = true;
_useLr = true;
_useDd = false;
if (_depth < 0) then {
	_useSw = [_unit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio;
	_useLr = [_unit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio;	
	_useDd = [_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};
if (count _pos != 4) then {
	_pos pushBack 0;
};

(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11", name _unit, _pos select 0, _pos select 1, _pos select 2, _pos select 3, _can_speak, _useSw, _useLr, _useDd, _unit call TFAR_fnc_vehicleId, _unit call TFAR_fnc_calcTerrainInterception])