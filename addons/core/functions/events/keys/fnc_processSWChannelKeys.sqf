#include "script_component.hpp"

/*
  Name: TFAR_fnc_processSRChannelKeys

  Author: Nkey, Garth de Wet (L-H)
    Switches the active SR radio to the passed channel.

  Arguments:
    0: Channel : Range (0,7) <NUMBER>

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_processSRChannelKeys;

  Public: No
*/

params ["_sw_channel_number"];

private _result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive TFAR_currentUnit}) then {
    private _radio = call TFAR_fnc_activeSwRadio;
    [_radio, _sw_channel_number] call TFAR_fnc_setSwChannel;
    playSound "TFAR_rotatorPush";
    if (TFAR_showChannelChangedHint) then {[_radio, false] call TFAR_fnc_showRadioInfo;};
    if (dialog) then {
        call compile getText(configFile >> "CfgWeapons" >> _radio >> "tf_dialogUpdate");
    };
    _result = true;
};
_result
