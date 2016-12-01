#include <sdktools>
#include <sdkhooks>
#pragma semicolon 1

int playerViewModel[MAXPLAYERS+1];

#define PLUGIN_VERSION              "1.0.0"
public Plugin myinfo = {
	name = "Viewmodel API",
	author = "Mitchell",
	description = "Natives for retireving the client's viewmodel.",
	version = PLUGIN_VERSION,
	url = "mtch.tech"
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNative("GetViewModel", Native_GetViewModel);
	RegPluginLibrary("ViewModelAPI");
	return APLRes_Success;
}

public void OnPluginStart() {
	CreateConVar("sm_viewmodelapi_version", PLUGIN_VERSION, "ViewModelAPI Version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	for(int client=1; client <= MAXPLAYERS; client++) {
		playerViewModel[client] = INVALID_ENT_REFERENCE;
	}
	
	int ent = -1;
	int owner = -1;
	while((ent = FindEntityByClassname(ent, "predicted_viewmodel"))!=-1) {
		owner = GetEntPropEnt(ent, Prop_Send, "m_hOwner");
		if((owner > 0) && (owner <= MaxClients)) {
			if(GetEntProp(ent, Prop_Send, "m_nViewModelIndex") == 0) {
				playerViewModel[owner] = EntIndexToEntRef(ent);
			}
		}
	}
}

public void OnClientDisconnect(int client) {
	playerViewModel[client] = INVALID_ENT_REFERENCE;
}

public void OnEntityCreated(int entity, const char[] classname) {
	if(StrEqual(classname, "predicted_viewmodel", false)) {
		SDKHook(entity, SDKHook_Spawn, OnEntitySpawned);
	}
}

public void OnEntitySpawned(int entity) {
	int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwner");
	if((owner > 0) && (owner <= MaxClients)) {
		if(GetEntProp(entity, Prop_Send, "m_nViewModelIndex") == 0) {
			playerViewModel[owner] = EntIndexToEntRef(entity);
		}
	}
}

public int Native_GetViewModel(Handle plugin, int args) {
	int client = GetNativeCell(1);
	if(NativeCheck_IsClientValid(client)) {
		return playerViewModel[client];
	}
	return INVALID_ENT_REFERENCE;
}

stock bool NativeCheck_IsClientValid(int client) {
	if(client <= 0 || client > MaxClients) {
		ThrowNativeError(SP_ERROR_NATIVE, "Client index %i is invalid", client);
		return false;
	}
	if(!IsClientInGame(client)) {
		ThrowNativeError(SP_ERROR_NATIVE, "Client %i is not in game", client);
		return false;
	}
	return true;
}