private["_localName", "_hintText"];
if (alive player) then {
	_localName = "STR_voice_normal";
	if (TF_speak_volume_level == "Whispering") then {
		TF_speak_volume_level = "normal";
		TF_speak_volume_meters = 20;
		_localName = localize "STR_voice_normal";
	} else {
		if (TF_speak_volume_level == "Normal") then {
			TF_speak_volume_level = "yelling";
			TF_speak_volume_meters = 60;
			_localName = localize "STR_voice_yelling";
		} else {
			TF_speak_volume_level = "whispering";
			TF_speak_volume_meters = 5;
			_localName = localize "STR_voice_whispering";
		}
	};
	_hintText = format[localize "STR_voice_volume", _localName];
	[parseText (_hintText), 5] call TFAR_fnc_showHint;
};
true