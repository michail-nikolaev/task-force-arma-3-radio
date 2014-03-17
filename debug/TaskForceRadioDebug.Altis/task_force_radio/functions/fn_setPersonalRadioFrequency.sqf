if (call TFAR_fnc_haveSWRadio) then {
	[(call TFAR_fnc_activeSwRadio), _this] call TFAR_fnc_setSwFrequency;
};