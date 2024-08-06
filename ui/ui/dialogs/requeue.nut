global function InitRequeueDialog


struct {
	var menu

	var dialogContent

	var actionButton1
	var actionButton2
	var holdExitLobbyButton
	var statusText

	bool registeredKeys = false
} file


void function InitRequeueDialog( var newMenuArg )
{
	file.menu = newMenuArg
	SetDialog( newMenuArg, true )

	file.dialogContent = Hud_GetChild( file.menu, "DialogContent" )
	file.actionButton1       = Hud_GetChild( file.menu, "ActionButton1" )
	file.actionButton2       = Hud_GetChild( file.menu, "ActionButton2" )
	file.holdExitLobbyButton = Hud_GetChild( file.menu, "HoldExitLobby" )
	file.statusText 		 = Hud_GetChild( file.menu, "StatusText" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, RequeueDialog_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, RequeueDialog_OnClose )

	AddButtonEventHandler( file.actionButton1, UIE_CLICK, RequeueDialog_Action1_OnClick )
	AddButtonEventHandler( file.actionButton2, UIE_CLICK, RequeueDialog_Action2_OnClick )
	AddButtonEventHandler( file.holdExitLobbyButton, UIE_CLICK, RequeueDialog_HoldExitLobbyButton_OnClick )

	AddMenuFooterOption( file.menu, LEFT, BUTTON_B, true, "#B_BUTTON_MINIMIZE", "#B_BUTTON_MINIMIZE", null )

	RegisterSignal( "KillExistingRequeueRefreshThreads" )
	RegisterSignal( "KillExistingRequeueHoldThreads" )
}

void function RequeueDialog_OnOpen()
{
	Reset_HoldExitLobbyButtonPercentage()

	thread RequeueDialog_RefreshContent_Thread()

	if( !file.registeredKeys )
	{
		RegisterButtonPressedCallback( BUTTON_DPAD_UP, RequeueDialog_OnShoulderLeft )
		RegisterButtonPressedCallback( KEY_1, RequeueDialog_OnKey1 )

		RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, RequeueDialog_OnShoulderRight )
		RegisterButtonPressedCallback( KEY_2, RequeueDialog_OnKey2 )

		RegisterButtonPressedCallback( KEY_SPACE, RequeueDialog_OnSpace )
		RegisterButtonPressedCallback( BUTTON_X, RequeueDialog_OnXButton )

		file.registeredKeys = true
	}
}

void function RequeueDialog_RefreshContent_Thread()
{
	Signal( uiGlobal.signalDummy, "KillExistingRequeueRefreshThreads" )
	EndSignal( uiGlobal.signalDummy, "KillExistingRequeueRefreshThreads" )
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	var dialogContentRui = Hud_GetRui( file.dialogContent )
	var actionButton1Rui = Hud_GetRui( file.actionButton1 )
	var actionButton2Rui = Hud_GetRui( file.actionButton2 )
	var exitToLobbyButtonRui = Hud_GetRui( file.holdExitLobbyButton )

	while ( true )
	{
		bool isPartyLead = AmIPartyLeader()
		bool isMatchmaking = IsMyPartyMatchmaking()
		bool fullPartyConnected = UI_IsFullPartyConnectedForRequeue()
		bool playlistHidden = Playlist_ShouldBeHiddenForScheduleBlocks( GetCurrentPlaylistName() )
		bool partyRankTierDifferences = Ranked_ShowRankedSummary() && !Ranked_PartyMeetsRankedDifferenceRequirements()

		Hud_SetVisible( file.actionButton1, false )
		Hud_SetVisible( file.actionButton2, false )

		string statusString = ""
		bool canRequeue = false
		if ( !fullPartyConnected )
			statusString = Localize( "#REQUEUE_UNAVAILALE_PARTY_NOT_CONNECTED" )
		else if ( playlistHidden )
			statusString = Localize( "#REQUEUE_UNAVAILALE_PLAYLIST_EXPIRED" )
		else if ( partyRankTierDifferences )
			statusString = Localize( "#REQUEUE_UNAVAILALE_RANK_TIER_DIFFERENCES" )
		else
			canRequeue = true

		if ( isMatchmaking )
		{
			RuiSetString( dialogContentRui, "headerText", Localize( "#DIALOG_REQUEUED_TITLE" ) )
			RuiSetString( dialogContentRui, "messageText", Localize( "#REQUEUE_WARNING_TEXT_MATCHMAKING" ) )

			RuiSetString( exitToLobbyButtonRui, "buttonText", Localize( "#BUTTON_CANCEL_AND_EXIT_TO_LOBBY" ) )

			Hud_SetText( file.statusText, Localize( GetMyMatchmakingStatus() ) )
		}
		else if ( isPartyLead )
		{
			RuiSetString( dialogContentRui, "headerText", Localize( "#DIALOG_REQUEUE_TITLE_LEAD" ) )
			RuiSetString( dialogContentRui, "messageText", Localize( "#REQUEUE_WARNING_TEXT_LEAD" ) )

			int partySize = GetPartySize()
			RuiSetString( actionButton1Rui, "buttonText", ( partySize > 1 ) ? Localize( "#BUTTON_REQUEUE_WITH_PARTY", string( partySize ) ) : Localize( "#BUTTON_REQUEUE_SOLO" ) )
			RuiSetString( actionButton2Rui, "buttonText", Localize( "#BUTTON_REQUEUE_WITH_SQUAD" ) )
			RuiSetString( exitToLobbyButtonRui, "buttonText", Localize( "#BUTTON_REQUEUE_HOLD_EXIT_TO_LOBBY" ) )

			Hud_SetVisible( file.actionButton1, canRequeue )
			

			Hud_SetText( file.statusText, statusString )
		}
		else
		{
			RuiSetString( dialogContentRui, "headerText", Localize( "#DIALOG_REQUEUE_TITLE" ) )
			RuiSetString( dialogContentRui, "messageText", Localize( "#REQUEUE_WARNING_TEXT" ) )

			RuiSetString( exitToLobbyButtonRui, "buttonText", Localize( "#BUTTON_REQUEUE_HOLD_EXIT_TO_LOBBY" ) )

			Hud_SetText( file.statusText, statusString )
		}

		WaitFrame()
	}
}

void function RequeueDialog_OnClose()
{
	Signal( uiGlobal.signalDummy, "KillExistingRequeueRefreshThreads" )
	Signal( uiGlobal.signalDummy, "KillExistingRequeueHoldThreads" )

	if( file.registeredKeys )
	{
		file.registeredKeys = false

		DeregisterButtonPressedCallback( BUTTON_DPAD_UP, RequeueDialog_OnShoulderLeft )
		DeregisterButtonPressedCallback( KEY_1, RequeueDialog_OnKey1 )

		DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, RequeueDialog_OnShoulderRight )
		DeregisterButtonPressedCallback( KEY_2, RequeueDialog_OnKey2 )

		DeregisterButtonPressedCallback( KEY_SPACE, RequeueDialog_OnSpace )
		DeregisterButtonPressedCallback( BUTTON_X, RequeueDialog_OnXButton )
	}
}

bool function RequeueDialogIsOpen()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == file.menu )
		return true

	return false
}

void function RequeueDialog_Action1_OnClick( var btn )
{
	if( !RequeueDialogIsOpen() )
		return

	StartMatchmakingFromMatch()
}

void function RequeueDialog_Action2_OnClick( var btn )
{
	if( !RequeueDialogIsOpen() )
		return

	
}

void function RequeueDialog_HoldExitLobbyButton_OnClick( var btn )
{
	thread RequeueDialog_Thread_ExitToLobby( btn )
}

void function RequeueDialog_OnShoulderLeft( var btn )
{
	if( !AmIPartyLeader() )
		return

	RequeueDialog_Action1_OnClick( btn )
}

void function RequeueDialog_OnShoulderRight( var btn )
{
	if( !AmIPartyLeader() )
		return

	RequeueDialog_Action2_OnClick( btn )
}

void function RequeueDialog_OnKey1( var btn )
{
	if( !AmIPartyLeader() )
		return

	RequeueDialog_Action1_OnClick( btn )
}

void function RequeueDialog_OnKey2( var btn )
{
	if( !AmIPartyLeader() )
		return

	RequeueDialog_Action2_OnClick( btn )
}


void function RequeueDialog_OnSpace( var btn )
{
	RequeueDialog_HoldExitLobbyButton_OnClick( btn )
}

void function RequeueDialog_OnXButton( var btn )
{
	RequeueDialog_HoldExitLobbyButton_OnClick( btn )
}



const float EXIT_TO_LOBBY_HOLDTIME = 0.6

void function RequeueDialog_Thread_ExitToLobby( var btn )
{
	Signal( uiGlobal.signalDummy, "KillExistingRequeueHoldThreads" )
	EndSignal( uiGlobal.signalDummy, "KillExistingRequeueHoldThreads" )
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	string HOLD_SOUND = "UI_Menu_ReadyUp_CancelBar_1P"

	OnThreadEnd(
		function() : ( HOLD_SOUND )
		{
			StopUISound( HOLD_SOUND )
		}
	)

	float startTime = ClientTime()
	var rui = Hud_GetRui( file.holdExitLobbyButton )

	EmitUISound( HOLD_SOUND )

	while( RequeueDialogIsOpen() && ClientTime() < startTime + EXIT_TO_LOBBY_HOLDTIME &&
		( InputIsButtonDown( KEY_SPACE )
			|| InputIsButtonDown( BUTTON_X )
			|| ( Hud_IsCursorOver( file.holdExitLobbyButton ) && InputIsButtonDown( BUTTON_A ) )
			|| ( Hud_IsCursorOver( file.holdExitLobbyButton ) && InputIsButtonDown( MOUSE_LEFT ) )
		)
	)
	{
		float timeElapsed = ClientTime() - startTime
		float percentage = timeElapsed / EXIT_TO_LOBBY_HOLDTIME

		RuiSetFloat( rui, "holdPercentage", percentage )

		WaitFrame()
	}

	
	if ( ClientTime() >= startTime + EXIT_TO_LOBBY_HOLDTIME )
	{
		RuiSetFloat( rui, "holdPercentage", 1.0 )
		EmitUISound( "UI_Menu_ReadyUp_Cancel_1P" )
		LeaveMatch()
		CloseAllDialogs()
	}
	else
	{
		Reset_HoldExitLobbyButtonPercentage()
	}
}

void function Reset_HoldExitLobbyButtonPercentage()
{
	var rui = Hud_GetRui( file.holdExitLobbyButton )

	RuiSetFloat( rui, "holdPercentage", 0.0 )
}