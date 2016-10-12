#include "..\uiDefines.hpp"
//#TODO
#TODO move to handhelds
if !(call TFAR_fnc_haveProgrammator) then {
    ((_this select 0) displayCtrl IDC_MICRODAGR_BACKGROUND) ctrlShow false;
    ((_this select 0) displayCtrl IDC_MICRODAGR_CLEAR) ctrlShow false;
    ((_this select 0) displayCtrl IDC_MICRODAGR_ENTER) ctrlShow false;
    ((_this select 0) displayCtrl IDC_MICRODAGR_EDIT) ctrlShow false;
    ((_this select 0) displayCtrl IDC_MICRODAGR_CHANNEL_EDIT) ctrlShow false;
};
