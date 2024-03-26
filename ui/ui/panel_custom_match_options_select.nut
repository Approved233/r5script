global function InitCustomMatchOptionsSelectPanel
global function ToggleRenameButtonVisibility
global function CustomMatch_HasPlaylistAccess

struct
{
	var panel
} file

struct CustomMatchOption
{
	string setting
	string name
	string description
}

void function InitCustomMatchOptionsSelectPanel( var panel )
{
	file.panel = panel

	CustomMatchOption option

	option = CreateOption( CUSTOM_MATCH_SETTING_CHAT_PERMISSION, 	"#CUSTOM_MATCH_CHAT_MODE", 			"#CUSTOM_MATCH_CHAT_MODE_DESC" )
	SetUpOptionsButton( Hud_GetChild( panel, "ChatPermissions" ), option )

	option = CreateOption( CUSTOM_MATCH_SETTING_RENAME_TEAM,		"#CUSTOM_MATCH_RENAME_TEAM", 		"#CUSTOM_MATCH_RENAME_TEAM_DESC" )
	SetUpOptionsButton( Hud_GetChild( panel, "RenameTeam" ), option )

	option = CreateOption( CUSTOM_MATCH_SETTING_SELF_ASSIGN, 		"#CUSTOM_MATCH_SELF_ASSIGN", 		"#CUSTOM_MATCH_SELF_ASSIGN_DESC" )
	SetUpOptionsButton( Hud_GetChild( panel, "SelfAssign" ), option )

	option = CreateOption( CUSTOM_MATCH_SETTING_AIM_ASSIST, 		"#CUSTOM_MATCH_AIM_ASSIST", 		"#CUSTOM_MATCH_AIM_ASSIST_DESC" )
	SetUpOptionsButton( Hud_GetChild( panel, "AimAssist" ), option )

	option = CreateOption( CUSTOM_MATCH_SETTING_ANONYMOUS_MODE, 	"#CUSTOM_MATCH_ANONOYMOUS_MODE", 	"#CUSTOM_MATCH_ANONOYMOUS_MODE_DESC" )
	SetUpOptionsButton( Hud_GetChild( panel, "AnonymousMode" ), option )

	option = CreateOption( CUSTOM_MATCH_SETTING_PLAYLIST, 	"#CUSTOM_MATCH_GAME_MODE_VARIANT", 	"#CUSTOM_MATCH_GAME_MODE_VARIANT_DESC" )
	SetUpVaryingOptionsButton( Hud_GetChild( panel, "ModeVariant" ), option, Callback_OnPlaylistChanged )

	ToggleRenameButtonVisibility()
}

CustomMatchOption function CreateOption( string setting, string name, string description )
{
	CustomMatchOption option
	option.setting = setting
	option.name = name
	option.description = description
	return option
}

void function SetUpOptionsButton( var button, CustomMatchOption option )
{
	HudElem_SetRuiArg( button, "buttonText", option.name )
	AddButtonEventHandler( button, UIE_CHANGE,
		void function( var button ) : ( option )
		{
			CustomMatch_SetSetting( option.setting, Hud_GetDialogListSelectionValue( button ) )
		} )

	ToolTipData toolTipData
	toolTipData.titleText = option.name
	toolTipData.descText = option.description
	Hud_SetToolTipData( button, toolTipData )

	AddCallback_OnCustomMatchSettingChanged( option.setting,
		void function( string setting, string value ) : ( button )
		{
			Callback_OnSettingChanged( button, setting, value )
		} )
}

void function Callback_OnSettingChanged( var button, string setting, string value )
{
	Hud_SetDialogListSelectionValue( button, value )
}

void function SetUpVaryingOptionsButton( var button, CustomMatchOption option, void functionref( var, string, string ) onChangeCallback  )
{
	HudElem_SetRuiArg( button, "buttonText", option.name )
	AddButtonEventHandler( button, UIE_CHANGE,
		void function( var button ) : ( option )
		{
			CustomMatch_SetSetting( option.setting, Hud_GetDialogListSelectionValue( button ) )
		} )

	ToolTipData toolTipData
	toolTipData.titleText = option.name
	toolTipData.descText = option.description
	Hud_SetToolTipData( button, toolTipData )

	AddCallback_OnCustomMatchSettingChanged( option.setting,
		void function( string setting, string value ) : ( onChangeCallback, button )
		{
			onChangeCallback( button, setting, value )
		} )
}

void function ToggleRenameButtonVisibility()
{
	var renameTeamOption = Hud_GetChild( file.panel, "RenameTeam" )
	var chatPermissionsOption = Hud_GetChild( file.panel, "ChatPermissions" )
	var selfAssignOption = Hud_GetChild( file.panel, "SelfAssign" )

	if( CustomMatch_HasSpecialAccess() )
	{
		Hud_SetNavDown( chatPermissionsOption, renameTeamOption )
		Hud_SetNavUp( selfAssignOption, renameTeamOption )

		Hud_SetPinSibling( selfAssignOption, Hud_GetHudName( renameTeamOption ) )
		Hud_SetVisible( renameTeamOption, true )
	}
	else
	{
		Hud_SetNavDown( chatPermissionsOption, selfAssignOption  )
		Hud_SetNavUp( selfAssignOption, chatPermissionsOption )

		Hud_SetPinSibling( selfAssignOption, Hud_GetHudName( chatPermissionsOption ) )
		Hud_SetVisible( renameTeamOption, false )
	}
}

const table<string, string> GAME_MODE_VARIANT_MAP = {
	[CUSTOM_MATCH_MODE_VARIANT_DEFAULT] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_DEFAULT",
	[CUSTOM_MATCH_MODE_VARIANT_NO_RING] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_NO_RING",
	[CUSTOM_MATCH_MODE_VARIANT_TOURNAMENT] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_TOURNAMENT",
	[CUSTOM_MATCH_MODE_VARIANT_CUSTOM_ENDING] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_CUSTOM_ENDING"
}

const table<string, string> GAME_MODE_VARIANT_DESC_MAP = {
	[CUSTOM_MATCH_MODE_VARIANT_DEFAULT] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_DEFAULT_DESC",
	[CUSTOM_MATCH_MODE_VARIANT_NO_RING] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_NO_RING_DESC",
	[CUSTOM_MATCH_MODE_VARIANT_TOURNAMENT] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_TOURNAMENT_DESC",
	[CUSTOM_MATCH_MODE_VARIANT_CUSTOM_ENDING] = "#CUSTOM_MATCH_GAME_MODE_VARIANT_CUSTOM_ENDING_DESC"
}

void function Callback_OnPlaylistChanged( var button, string setting, string value )
{
	CustomMatchPlaylist playlist = expect CustomMatchPlaylist( CustomMatch_GetPlaylist( value ) )
	CustomMatchMap map = expect CustomMatchMap( CustomMatch_GetMap( playlist.mapIndex ) )

	ToolTipData toolTipData
	toolTipData.titleText = "#CUSTOM_MATCH_GAME_MODE_VARIANT"
	toolTipData.descText = Localize( "#CUSTOM_MATCH_GAME_MODE_VARIANT_DESC" ) + "\n"

	Hud_DialogList_ClearList( button )
	foreach ( string key, CustomMatchPlaylist entry in map.playlists )
	{
		if ( CustomMatch_HasPlaylistAccess( entry.playlistName ) )
		{
			Hud_DialogList_AddListItem( button, GAME_MODE_VARIANT_MAP[ key ], entry.playlistName )
			toolTipData.descText += "\n" + Localize( GAME_MODE_VARIANT_DESC_MAP[ key ] )
		}
	}

	Hud_SetDialogListSelectionValue( button, value )
	Hud_SetEnabled( button, map.playlists.len() > 1 )
	Hud_SetToolTipData( button, toolTipData )
}

const string REQUIRES_SPECIAL_ACCESS_VAR = "requires_special_access"
bool function CustomMatch_HasPlaylistAccess( string playlist )
{
	if ( CustomMatch_HasSpecialAccess() )
		return true

	if ( !IsFullyConnected() )
		return false

	return !GetPlaylistVarBool( playlist, REQUIRES_SPECIAL_ACCESS_VAR, false )
}