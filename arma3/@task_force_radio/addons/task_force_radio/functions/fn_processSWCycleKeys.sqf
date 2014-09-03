/*
 	Name: TFAR_fnc_processSWCycleKeys
 	
 	Author(s):
		

 	Description:
		Allows rotating through the list of SW radios with keys.
	
	Parameters:
		0: STRING - Direction to cycle : VALUES (next, prev)
 	
 	Returns:
		BOOLEAN - If the event was handled or not.
 	
 	Example:
		Handled via CBA's onKey eventhandler.
*/
private ["_sw_cycle_direction", "_result"];
_sw_cycle_direction = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then{
	private ["_radio", "_radio_list", "_active_radio_index", "_new_radio_index"];
	_radio = call TFAR_fnc_activeSwRadio;
	_radio_list = call TFAR_fnc_radiosListSorted;

	_active_radio_index = 0;
	_new_radio_index = 0;

	{
		if (_x == _radio) exitWith{
			_active_radio_index = _forEachIndex;
		};
	} forEach _radio_list;


	switch (_sw_cycle_direction) do{
		case "next":
			{
				_new_radio_index = (_active_radio_index + 1) mod (count _radio_list);
			};
	    case "prev":
	    {
	    	if (_active_radio_index != 0) then {
	    		_new_radio_index = (_active_radio_index - 1);
	    	} else {
	    		_new_radio_index = (count _radio_list) - 1;
	    	};
	    };
	};

	(_radio_list select _new_radio_index) call TFAR_fnc_setActiveSwRadio;

	[(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_ShowRadioInfo;

	_result = true;
};
_result