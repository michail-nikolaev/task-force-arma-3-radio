#include "script_component.hpp"

/*
    Name: TFAR_fnc_parseFrequenciesInput

    Author(s):
        Dorbedo

    Description:
        parses a frequencies array and fills it up with default values
        does a valuecheck and ignores wrong values

    Parameters:
        STRING: value string
        SCALAR: min amount of channels
        SCALAR: min freq
        SCALAR: max freq
        SCALAR: round power

    Returns:
        NOTHING

    Example:
        ["[50.16549, 51122, 52, 53, 4, 5, 56, 57, 58, 59, ""asd"", asd, ""88""]", 8, 87, 40] call TFAR_fnc_parseFrequenciesInput;
*/

params [
    ["_valueString","",[""]],
    ["_minChannels",TFAR_MAX_CHANNELS,[TFAR_MAX_CHANNELS]],
    ["_maxFreq",TFAR_MAX_SW_FREQ,[TFAR_MAX_SW_FREQ]],
    ["_minFreq",TFAR_MIN_SW_FREQ,[TFAR_MIN_SW_FREQ]],
    ["_roundPower",TFAR_FREQ_ROUND_POWER,[TFAR_FREQ_ROUND_POWER]]
];

// add brackets if they are missing
if !(((_valueString find "[") isEqualTo 0) && {(_valueString find "]") isEqualTo ((count _valueString) - 1)}) then {
    _valueString = format["[%1]",_valueString];
};

private _parsedValue = (parseSimpleArray _valueString) apply {
    if (IS_STRING(_x)) then {parseNumber _x} else {_x};
};

_parsedValue = _parsedValue select {
    IS_NUMBER(_x) &&
    {_x >= _minFreq} &&
    {_x <= _maxFreq}
};

_parsedValue = _parsedValue apply {QTFAR_ROUND_FREQUENCYP(_x,_roundPower)};


if ((count _parsedValue) < _minChannels) then {
    private _randomized = [_minChannels,_maxFreq,_minFreq,_roundPower] call DFUNC(generateFrequencies);
    _parsedValue append _randomized;
    _parsedValue resize _minChannels;
};

_parsedValue
