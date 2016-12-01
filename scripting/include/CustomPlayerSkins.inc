//Viewmodel API include file

#if defined _ViewModelAPI_included
 #endinput
#endif
#define _ViewModelAPI_included

/**
 * Gets the client's predicted_viewmodel entity reference.
 *
 * @param client Client index
 * @return Returns the entity reference of the player's skin, INVALID_ENT_REFERENCE if there is no skin.
 * @error Invalid client.
 */
native int GetViewModel(int client);

public SharedPlugin:__pl_ViewModelAPI =
{
	name = "ViewModelAPI",
	file = "ViewModelAPI.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_ViewModelAPI_SetNTVOptional()
{
	MarkNativeAsOptional("GetViewModel");
}
#endif
