private["_localName", "_hintText"];
if (alive player) then
{
	_localName = "STR_voice_normal";
	if (speak_volume_level == "Whispering") then {
		speak_volume_level = "normal";
		_localName = localize "STR_voice_normal";
	} else {
		if (speak_volume_level == "Normal") then {
			speak_volume_level = "yelling";
			_localName = localize "STR_voice_yelling";
		} else {
			speak_volume_level = "whispering";
			_localName = localize "STR_voice_whispering";
		}
	};
	_hintText = format[localize "STR_voice_volume", _localName];
	hintSilent parseText (_hintText);
};
true