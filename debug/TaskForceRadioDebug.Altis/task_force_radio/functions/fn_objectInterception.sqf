#include "script.h"
private ["_result", "_s"];

KK_fnc_inString = {   
    private ["_needle","_haystack","_needleLen","_hay","_found"];
    _needle = [_this, 0, "", [""]] call BIS_fnc_param;
    _haystack = toArray ([_this, 1, "", [""]] call BIS_fnc_param);
    _needleLen = count toArray _needle;
    _hay = +_haystack;
    _hay resize _needleLen;
    _found = false;
    for "_i" from _needleLen to count _haystack do {
        if (toString _hay == _needle) exitWith {_found = true};
        _hay set [_needleLen, _haystack select _i];
        _hay set [0, "x"];
        _hay = _hay - ["x"]
    };
    _found
};

_result = "";
{
	if ((_x isKindOf "Static") or {_x isKindOf "AllVehicles"}) then {	
		if (!(_x isKindOf "Lamps_Base_F") and {!(_x isKindOf "PowerLines_base_F")}) then {
			_result = _result + "wall|";
		};			
	} else {
		if ((typeOf _x) == "") then {
			_result = _result + str(_x) + "|";
			//(if ((["wall", _s] call KK_fnc_inString) 
			//	or {["city", _s] call KK_fnc_inString} 
			//	or {["rock", _s] call KK_fnc_inString} 
			//	or {["wreck", _s] call KK_fnc_inString} 
			//	or {["cargo", _s] call KK_fnc_inString} 
			//	or {["stone", _s] call KK_fnc_inString}) then {
			//	_result = _result + 1;
			//};
		};
	};
	true;
} count (lineIntersectsWith  [eyepos TFAR_currentUnit, eyepos _this, TFAR_currentUnit, _this]);

_result;