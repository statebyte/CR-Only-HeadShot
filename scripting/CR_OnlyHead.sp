#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdkhooks>
#include <cstrike>
#include <csgo_colors>

public Plugin myinfo =
{
	name        = 	"[CR] Only HeadShot", // Спасибо Someone за ядро
	author      = 	"FIVE",
	description =	"Provides Only HeadShot for custom rounds",
	version     = 	"2.2", // Спасибо Faya & Kruzya за фикс кода
	url         = 	"http://hlmod.ru"
};

int g_iOnlyHSEnable;

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
	if(g_iOnlyHSEnable > 0 && iWeapon > 0)
	{
		char sClassname[10];
		GetEntPropString(iWeapon, Prop_Data, "m_iClassname", sClassname, sizeof(sClassname));

		if(g_iOnlyHSEnable == 2 && (sClassname[0] == 'w' && (sClassname[7] == 'k' || (sClassname[7] == 'b' && sClassname[8] == 'a')))) return Plugin_Continue;

		if(iDamageType & CS_DMG_HEADSHOT) return Plugin_Continue;
		else return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		g_iOnlyHSEnable = Kv.GetNum("only_head", 0);
		
		switch(g_iOnlyHSEnable)
		{
			case 1: CGOPrintToChatAll("В этом раунде включен режим {RED}Only HeadShot (NOKNIFE)");
			case 2: CGOPrintToChatAll("В этом раунде включен режим {RED}Only HeadShot (KNIFE)");
		}
		
	}
}

public void OnMapStart()
{
	g_iOnlyHSEnable = 0;
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	g_iOnlyHSEnable = 0;
}
