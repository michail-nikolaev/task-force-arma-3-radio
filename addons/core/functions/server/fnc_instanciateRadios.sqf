#include "script_component.hpp"

/*
    Name: TFAR_fnc_instanciateRadios

    Author(s):
        Dedmen, Dorbedo

    Description:
        Takes Radio classnames and returns next availlible ID
        Internal use only!

    Parameters:
        ARRAY - classnames of Radios

    Returns:
        ARRAY - next availlible IDs

    Example:
        ["TFAR_anprc_152"] call TFAR_fnc_instanciateRadios;
*/

params [["_radio_request", [], [[]]], ["_requestingUnit", objNull]];

//Note: This WILL be executed in unscheduled and freeze Server until done
private _response = [];
{
    _x params ["_radioBaseClass"];

    if (_radioBaseClass == "ItemRadio") then {
        _radioBaseClass = missionNamespace getVariable [format["TFAR_DefaultRadio_Rifleman_%1", side _requestingUnit], ""];
    } else {
        //get Radio baseclass without ID
        _radioBaseClass = [_radioBaseClass, "tf_parent", ""] call DFUNC(getWeaponConfigProperty);
    };

    If (_radioBaseClass isEqualTo "") then {
        _response pushBack 0;
    } else {
        private _nextRadioIndex = (TFAR_RadioCountNamespace getVariable [_radioBaseClass, 0]) + 1;

        //If too big go to 1 again. Could cause duplicate Radios if you really have >MAX_RADIO_COUNT active radios
        If (_nextRadioIndex > MAX_RADIO_COUNT) then {_nextRadioIndex = 1;};

        TFAR_RadioCountNamespace setVariable [_radioBaseClass, _nextRadioIndex];

        _response pushBack _nextRadioIndex;

    };
    nil
} count _radio_request;

_response
