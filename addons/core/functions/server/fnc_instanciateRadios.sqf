#include "script_component.hpp"

/*
  Name: TFAR_fnc_instanciateRadios

  Author: Dedmen, Dorbedo
    Takes Radio classnames and returns instanciated classnames (With _ID appended)

  Arguments:
    0: List of classnames of prototype radios <ARRAY>
    1: Unit that is requesting the Radios <OBJECT>

  Return Value:
    classnames of instanciated radios <ARRAY>

  Example:
    [["TFAR_anprc_152"], TFAR_currentUnit] call TFAR_fnc_instanciateRadios;

  Public: No
*/

params [["_radio_request", [], [[]]], ["_requestingUnit", objNull]];

//Note: This WILL be executed in unscheduled and freeze Server until done
private _response = [];
{
    _x params ["_radioBaseClass"];

    if (_radioBaseClass == "ItemRadio") then {
        _radioBaseClass = (_requestingUnit call TFAR_fnc_getDefaultRadioClasses) param [[2, 1] select ((TFAR_givePersonalRadioToRegularSoldier) or {leader _requestingUnit == _requestingUnit} or {rankId _requestingUnit >= 2}), ""];
    } else {
        //get Radio baseclass without ID
        _radioBaseClass = [_radioBaseClass, "tf_parent", ""] call DFUNC(getWeaponConfigProperty);
    };

    if (_radioBaseClass isEqualTo "") then {
        _response pushBack 0;
    } else {
        private _nextRadioIndex = (TFAR_RadioCountNamespace getVariable [_radioBaseClass, 0]) + 1;

        //If too big go to 1 again. Could cause duplicate Radios if you really have >MAX_RADIO_COUNT active radios
        if (_nextRadioIndex > MAX_RADIO_COUNT) then {_nextRadioIndex = 1;};

        TFAR_RadioCountNamespace setVariable [_radioBaseClass, _nextRadioIndex];

        _response pushBack _nextRadioIndex;

    };
} forEach _radio_request;

_response
