class RscPictureKeepAspect;
class RscTitles
{
    class GVAR(PhoneConnectionIndicatorRsc) {
        idd = -1;
        movingEnable = 1;
        duration = 9999999;
        fadein = 0;
        fadeout = 0;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2(QUOTE(QGVAR(PhoneConnectionIndicatorRscDisplay)),_this select 0)];);
        class controls {
            class ConnectionIndicator: RscPictureKeepAspect {
                idc= 1112;
                type = 0;
                style = "0x30 + 0x800";
                colorText[] = { 1, 1, 1, 1 };
                colorBackground[]={0, 0, 0, 0};
                font = "PuristaMedium";
                sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                text=QPATHTOF(ui\tfar_external_intercom_phone.paa);
                x="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_X"",  0.85 * safezoneW + safezoneX])";
                y="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_Y"",  0.9 * safezoneH + safezoneY])";
                w="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
                h="(profilenamespace getvariable [""IGUI_grid_TFAR_External_Intercom_Phone_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
            };
        };
    };
};
