class RscStructuredText;

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
};