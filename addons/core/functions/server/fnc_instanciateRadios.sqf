#include "script_component.hpp"

/*
    Name: TFAR_fnc_instanciateRadios

    Author(s):
        Dedmen

    Description:
        Takes Radio classnames and returns instanciated classnames (With _ID appended)
        Internal use only!

    Parameters:
        ARRAY - classnames of prototype Radios

    Returns:
        ARRAY - classnames of instanciated Radios

    Example:
        ["TFAR_anprc_152"] call TFAR_fnc_instanciateRadios;
*/

//params [ ["_radio_request", [], [[]] ] ];
_radio_request = _this; //Params doesn't work because it turns ["test"] into "test" cuz its dumb
//Note: This WILL be executed in unscheduled and freeze Server until done
private _response = [];
{
    _x params ["_radioBaseClass"];

    //get Radio baseclass without ID
    _radioBaseClass = getText (configFile >> "CfgWeapons" >> _radioBaseClass >> "tf_parent");

    //#Deprecated radio classes
    if (_radioBaseClass == "tf_anprc148jem") then {_radioBaseClass = "TFAR_anprc148jem"};
    if (_radioBaseClass == "tf_anprc152") then {_radioBaseClass = "TFAR_anprc152"};
    if (_radioBaseClass == "tf_anprc154") then {_radioBaseClass = "TFAR_anprc154"};
    if (_radioBaseClass == "tf_fadak") then {_radioBaseClass = "TFAR_fadak"};
    if (_radioBaseClass == "tf_pnr1000a") then {_radioBaseClass = "TFAR_pnr1000a"};
    if (_radioBaseClass == "tf_rf7800str") then {_radioBaseClass = "TFAR_rf7800str"};

    private _nextRadioIndex = 1;
    if ([TFAR_RadioCountHash,_radioBaseClass] call CBA_fnc_hashHasKey) then {
        //Baseclass already exists so increment its current Index
        private _currentRadioIndex = [TFAR_RadioCountHash,_radioBaseClass] call CBA_fnc_hashGet;

        if (_currentRadioIndex > MAX_RADIO_COUNT) then {
            //If too big go to 1 again. Could cause duplicate Radios if you really have >MAX_RADIO_COUNT active radios
            _nextRadioIndex = 1;
        } else {
            //Increment Index and return in _nextRadioIndex
            _nextRadioIndex = _currentRadioIndex + 1;
        };
    };
    //This will either set the new Index or add an entry with Index 1
    [TFAR_RadioCountHash,_radioBaseClass,_nextRadioIndex] call CBA_fnc_hashSet;

    _response pushBack format["%1_%2", _radioBaseClass, _nextRadioIndex];//form new classname of baseclass_ID
    true;
} count _radio_request;

_response
