class RscStructuredText;
class RscPictureKeepAspect;
class RscTitles
{
    class RscTaskForceHint
    {
        idd = 30040;
        onLoad = "uiNamespace setVariable ['TFAR_Hint_Display', _this select 0]";
        onUnload = "uiNamespace setVariable ['TFAR_Hint_Display', displayNull]";
        fadeIn=0.2;
        fadeOut=0.2;
        movingEnable = false;
        duration = 10e10;
        name = "RscTaskForceHint";
        class controls
        {
            class InformationText: RscStructuredText
            {
                idc = 1100;
                text = "";
                x = 0.85 * safezoneW + safezoneX;
                y = 0.9 * safezoneH + safezoneY;
                w = 0.15 * safezoneW;
                h = 0.1 * safezoneH;
                colorText[] = {1,1,1,1};
                colorBackground[] = {0.1,0.1,0.1,0.5};
                sizeEx = 1;
                size = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * (0.55 / (getResolution select 5)))";
            };
        };
    };
    class GVAR(HUDVolumeIndicatorRsc) {
        idd = -1;
        movingEnable = 1;
        duration = 9999999;
        fadein = 0;
        fadeout = 0;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2(QUOTE(QGVAR(HUDVolumeIndicatorRscDisplay)),_this select 0)];);
        class controls {
            class VolumeIndicator: RscPictureKeepAspect {
                idc= 1112;
                text=QPATHTOF(ui\tfar_volume_normal.paa);
                x="(profilenamespace getvariable [""IGUI_grid_TFAR_Volume_X"",	0.85 * safezoneW + safezoneX])";
                y="(profilenamespace getvariable [""IGUI_grid_TFAR_Volume_Y"",	0.9 * safezoneH + safezoneY])";
                w="(profilenamespace getvariable [""IGUI_grid_TFAR_Volume_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
                h="(profilenamespace getvariable [""IGUI_grid_TFAR_Volume_W"",  2 * (((safezoneW / safezoneH) min 1.2) / 50)])";
            };
        };
    };
};
