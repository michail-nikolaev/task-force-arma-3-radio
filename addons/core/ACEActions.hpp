class Man;
class CAManBase: Man {
	class ACE_SelfActions {
		class TFAR_Radio {
			displayName = "Radios";
			condition = "call TFAR_fnc_haveSWRadio";
			exceptions[] = {"isNotSwimming"};
			statement = "";
			icon = "";
			insertChildren = "[_player] call TFAR_fnc_addRadiosToACE";
		};
	};
};