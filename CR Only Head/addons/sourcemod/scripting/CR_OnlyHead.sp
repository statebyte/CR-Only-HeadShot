#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdkhooks>
#include <cstrike>
#include <csgo_colors>

public Plugin myinfo =
{
	name        = 	"[CR] Only HeadShot",
	author      = 	"FIVE",
	version     = 	"2.0.0", // Спасибо Faya & Kruzya
	url         = 	"http://hlmod.ru"
};

bool g_bOnlyHSEnable;

public void OnPluginStart()
{
	for(int iClient = 1; iClient <= MaxClients; iClient++) 
	{
		if(IsClientInGame(iClient)) {
			SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
		}
	}
}

public void OnClientPutInServer(int iClient) 
{
	SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float fDamageForce[3], float fDamagePosition[3], int iDamageCustom)
{
	if(g_bOnlyHSEnable == false)
	{
		return Plugin_Continue;
	}

	if(iDamageType & CS_DMG_HEADSHOT) {
		return Plugin_Continue;
	}else{
		return Plugin_Handled;
	}
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		g_bOnlyHSEnable = view_as<bool>(Kv.GetNum("only_head"));
		if(g_bOnlyHSEnable)
		{
			CGOPrintToChatAll("В этом раунде включен режим {RED}Only HeadShot");
		}
	}
}

public void OnMapStart()
{
	g_bOnlyHSEnable = false;
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	g_bOnlyHSEnable = false;
}