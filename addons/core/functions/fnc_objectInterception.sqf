#include "script_component.hpp"



KK_fnc_inString = {
    params [["_needle", "", [""]], ["_needle", "", [""]]];
    private _haystack = toArray (_haystack);
    private _needleLen = count toArray _needle;
    private _hay = +_haystack;
    _hay resize _needleLen;

    private _found = false;
    for "_i" from _needleLen to count _haystack do {
        if (toString _hay == _needle) exitWith {_found = true};
        _hay set [_needleLen, _haystack select _i];
        _hay set [0, "x"];
        _hay = _hay - ["x"]
    };
    _found
};

private _result = "";
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
