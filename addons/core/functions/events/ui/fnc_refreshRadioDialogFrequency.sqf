#include "script_component.hpp"

disableSerialization;
private _control = uiNamespace getVariable ["TFAR_frequencyControl", controlNull];
if (isNull _control || {(_control getVariable ["TFAR_frequencyState", ""]) == "editing"}) exitWith {};
(_control getVariable "TFAR_frequencyRadio") call TFAR_fnc_updateRadioDialogFrequency;
