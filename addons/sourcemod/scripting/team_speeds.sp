#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Levi2288"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <clients>
//#include <sdkhooks>

ConVar sm_T_speed;
ConVar sm_CT_speed;
Handle sm_enable_speed = INVALID_HANDLE;

public Plugin myinfo = 
{
	name = "Team_speeds",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "https://github.com/Bufika2288"
};

public void OnPluginStart()
{
	//Commands
	RegConsoleCmd("sm_refreshspeed", Refresh, "Refresh the player speed settings", ADMFLAG_GENERIC);
	RegConsoleCmd("sm_rts", Refresh, "Refresh the player speed settings", ADMFLAG_GENERIC);
	
	//Cvars 
	sm_enable_speed = CreateConVar("sm_enable_speed", "1", "Enable the plugin");
	sm_T_speed = CreateConVar("sm_T_speed", "1.5", "Speed for T team");
	sm_CT_speed = CreateConVar("sm_CT_speed", "1", "Speed for CT team");
	
	//Events
	HookEvent("player_spawn", Event_Spawn);
	
	AutoExecConfig(true, "team_speeds");
	
}

public Action Event_Spawn(Event event, const char[] name, bool dontBroadcast )
{
	if (GetConVarBool(sm_enable_speed))
	{
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
		
	
		if (IsPlayerAlive(client) && !IsFakeClient(client)) 
		{
			Set_Player_Speed(client);
		}
	}
}

public bool Set_Player_Speed(int client)
{		
	int i_Team;
	char s_TSpeed[4];
	char s_CTSpeed[4];
			
	i_Team = GetClientTeam(client);
			
	GetConVarString(sm_T_speed, s_TSpeed, sizeof(s_TSpeed));
	GetConVarString(sm_CT_speed, s_CTSpeed, sizeof(s_CTSpeed));
			
					
	if (i_Team == 2) 
	{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", GetConVarFloat(sm_T_speed));
	}
			
	else if (i_Team == 3)
	{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", GetConVarFloat(sm_CT_speed));
	}
}

public Action Refresh(int client, int args)
{
	for (int intCurrentPlayer = 1; intCurrentPlayer  <= MaxClients; intCurrentPlayer++) 
	{	
		
		if (IsClientInGame(intCurrentPlayer) && !IsFakeClient(intCurrentPlayer)) 
		{
			Set_Player_Speed(intCurrentPlayer);
		}
	}
}	