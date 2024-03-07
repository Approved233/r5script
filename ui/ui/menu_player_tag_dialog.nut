global function InitPlayerTagDialog

global function UICodeCallback_PlayerTAGResult

struct
{
	var menu
	var contentRui

	string oldTag = ""
} file


void function InitPlayerTagDialog( var menu )
{
	SetDialog( menu, true )

	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PlayerTagDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PlayerTagDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, PlayerTagDialog_OnNavigateBack )

#if DEV
		AddMenuThinkFunc( menu, PlayerTagDialogAutomationThink )
#endif

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", PlayerTagDialog_No )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_CHANGE", "#X_BUTTON_CHANGE", PlayerTagDialog_Yes )
}


void function PlayerTagDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", "#PLAYER_TAG_CHANGE_TITLE" )

	string playerTag = GetConVarString( "player_tag" )
	string messageText = ""

	if ( playerTag.len() > 0 )
	{
		file.oldTag = playerTag

		messageText = "`2["+ playerTag + "]"

		Hud_SetUTF8Text( Hud_GetChild( file.menu, "TextEntry" ), file.oldTag )
	}

	RuiSetString( contentRui, "bottomText", "" )
	RuiSetString( contentRui, "messageText", messageText )
	RuiSetFloat( contentRui, "msgTextVerticalOffset", -40.0 )
	RuiSetFloat( contentRui, "headerTextVerticalOffset", -40.0 )

	RegisterButtonPressedCallback( KEY_ENTER, PlayerTagDialog_Yes )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "TextEntry" ), UIE_CHANGE, PlayerTag_OnTextEntryChanged )
}

void function PlayerTagDialog_OnClose()
{
	DeregisterButtonPressedCallback( KEY_ENTER, PlayerTagDialog_Yes )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "TextEntry" ), UIE_CHANGE, PlayerTag_OnTextEntryChanged )
}


void function PlayerTagDialog_OnNavigateBack()
{
	CloseActiveMenu()
}


void function PlayerTagDialog_Yes( var button )
{
	string newTag = Hud_GetUTF8Text( Hud_GetChild( file.menu, "TextEntry" ) )

	if( !PlayerTagIsInLengthReq( newTag ) )
		return

	if( newTag != file.oldTag)
	{
		SendPlayerTAG( newTag )
	}else
	{
		CloseActiveMenu()
	}
}

void function PlayerTag_OnTextEntryChanged( var button  )
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	string text = Hud_GetUTF8Text( Hud_GetChild( file.menu, "TextEntry" ) )
}

bool function PlayerTagIsInLengthReq( string tag )
{
	int characters = tag.len()

	if( characters == 0 )
		return true

	if( characters < 3 )
		return false

	if( characters > 4 )
		return false

	return true
}

void function PlayerTagDialog_No( var button )
{
	CloseActiveMenu()
}

#if DEV
void function PlayerTagDialogAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("PlayerTagDialogAutomationThink ConfirmDialog_Yes()")
		PlayerTagDialog_Yes(null)
	}
}
#endif

void function UICodeCallback_PlayerTAGResult( int resultCode, string tag )
{
	printt( "UICodeCallback_PlayerTAGResult: " + resultCode + " tag: " + tag )

	switch( resultCode )
	{
		case 0:
			
			var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
			RuiSetString( contentRui, "bottomText", Localize( "#PLAYER_TAG_CREATE_INAPPROPRIATETAG" ) )
			break
		case 1:
			
			var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
			RuiSetString( contentRui, "bottomText", Localize( "#PLAYER_TAG_FAIL_COOLDOWN" ) )
			break
		case 2:
			
			PIN_PlayerTagChange( tag )
			RunClientScript( "UIToClient_UpdateLocalPlayerTag", tag )
			CloseActiveMenu()
			break
		default:
			break
	}
}