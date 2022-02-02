#pragma semicolon 1

#include <sourcemod>
#include <vip_core>
#include <sdktools_functions>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "[VIP] Armor", 
	author = "R1KO (skype: vova.andrienko1), NiGHT", 
	version = "1.3"
};

#define MENU_INFO 		1 // Отображать ли информацию в меню

static const char g_sFeature[] = "Armor";

int m_ArmorValue;
int m_bHasHelmet;

bool g_bLateLoaded;
bool g_bEnabled;
bool g_bEnable[MAXPLAYERS+1];

char g_sArmorValue[MAXPLAYERS+1][16];

public void OnPluginStart()
{
	m_ArmorValue = FindSendPropInfo("CCSPlayer", "m_ArmorValue");
	m_bHasHelmet = FindSendPropInfo("CCSPlayer", "m_bHasHelmet");
	
	#if MENU_INFO 1
	LoadTranslations("vip_modules.phrases");
	#endif
	
	if (VIP_IsVIPLoaded())
	{
		VIP_OnVIPLoaded();
	}

	if(g_bLateLoaded)
	{
		for(int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if(!IsClientInGame(iClient) || IsFakeClient(iClient))
			{
				continue;
			}

			VIP_OnVIPClientLoaded(iClient);
		}
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_bLateLoaded = late;
	return APLRes_Success;
}

public void OnMapStart()
{
	g_bEnabled = true;
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));
	if(strncmp(map, "35hp_", 5) == 0 || strncmp(map, "awp_", 4) == 0 || strncmp(map, "aim_", 4) == 0 || strncmp(map, "fy_", 3) == 0)
	{
		g_bEnabled = false;
	}
}

public void VIP_OnVIPLoaded()
{
	#if MENU_INFO 1
	VIP_RegisterFeature(g_sFeature, STRING, _, OnToggleItem, OnItemDisplay);
	#else
	VIP_RegisterFeature(g_sFeature, STRING);
	#endif
}

public Action OnToggleItem(int iClient, const char[] sFeatureName, VIP_ToggleState OldStatus, VIP_ToggleState &NewStatus)
{
	g_bEnable[iClient] = (NewStatus == ENABLED);
	return Plugin_Continue;
}

public void VIP_OnVIPClientLoaded(int iClient)
{
	g_bEnable[iClient] = VIP_IsClientFeatureUse(iClient, g_sFeature);
	VIP_GetClientFeatureString(iClient, g_sFeature, g_sArmorValue[iClient], sizeof(g_sArmorValue[]));
}

public void OnClientDisconnect(int iClient)
{
	g_bEnable[iClient] = false;
	g_sArmorValue[iClient][0] = '\0';
}

#if MENU_INFO 1
public bool OnItemDisplay(int iClient, const char[] szFeature, char[] szDisplay, int iMaxLength)
{
	if (g_bEnable[iClient])
	{
		FormatEx(szDisplay, iMaxLength, "%T [%s]", g_sFeature, iClient, g_sArmorValue[iClient][(g_sArmorValue[iClient][0] == '+') ? 1:0]);
		return true;
	}
	
	return false;
}
#endif

public void OnPluginEnd()
{
	if (CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		VIP_UnregisterFeature(g_sFeature);
	}
}

public void VIP_OnPlayerSpawn(int iClient, int iTeam, bool bIsVIP)
{
	if(!g_bEnabled || !g_bEnable[iClient])
		return;
	
	int iRound = GetTeamScore(2) + GetTeamScore(3);
	if(iRound == 0 || iRound == 15)
		return;
	
	int iArmor;
	if (g_sArmorValue[iClient][0] == '+')
	{
		iArmor = StringToInt(g_sArmorValue[iClient][2]) + GetEntData(iClient, m_ArmorValue);
	}
	else
	{
		StringToIntEx(g_sArmorValue[iClient], iArmor);
	}
	
	SetEntData(iClient, m_ArmorValue, iArmor);
	SetEntData(iClient, m_bHasHelmet, 1);
}