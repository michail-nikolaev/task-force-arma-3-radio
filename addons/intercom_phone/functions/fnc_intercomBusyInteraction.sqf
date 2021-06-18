#include "script_component.hpp"

/*
  Name: TFAR_fnc_intercomBusyIntercation

  Author: Arend(Saborknight)
    Modifies the "Pickup Intercom Phone" interaction if it's already in use by
    someone else by modifying the _actionData array directly.

  Arguments:
    0: Target object of the interaction (will always be vehicle) <OBJECT>
    1: Player unit <OBJECT>
    2: Params passed in the interaction (none are passed as of writing) <ARRAY>
    3: Currently set interaction data <ARRAY>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_fnc_intercomBusyIntercation;

  Public: Yes
*/

params["_target", "_player", "_params", "_actionData"];
if (!isNil {_target getVariable ["IntercomPhoneSpeaker", nil]}) then {
    _actionData set [1, localize LSTRING(SOMEONE_USING)];
    _actionData set [2, [QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa), "#FF8383"]];
} else {
    _actionData set [1, localize LSTRING(PICKUP_PHONE)];
    _actionData set [2, QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa)];
};
