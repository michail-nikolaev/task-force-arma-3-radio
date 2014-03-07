private ["_sw_cycle_direction", "_result"];
_sw_cycle_direction = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then
{
	private ["_radio", "_radio_list", "_active_radio_index", "_new_radio_index", "_pos"];
	_radio = call TFAR_fnc_activeSwRadio;
	_radio_list = call TFAR_fnc_radiosList;

	_active_radio_index = 0;
	_new_radio_index = 0;

	{
		if (_x == _radio) then
		{
			_active_radio_index = _forEachIndex;
		};
	} forEach _radio_list;


	switch (_sw_cycle_direction) do
	{
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

	_new_radio = _radio_list select _new_radio_index;
	_new_radio call TFAR_fnc_setActiveSwRadio;

	[(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_ShowRadioInfo;

	_result = true;
};
_result