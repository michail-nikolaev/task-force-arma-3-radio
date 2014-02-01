private ["_result"];
_result = [];
if ((backpack player == "tf_rt1523g") or {backpack player == "tf_anprc155"} or {backpack player == "tf_mr3000"}) then {
	_result = [unitBackpack player, "radio_settings"];
};
_result