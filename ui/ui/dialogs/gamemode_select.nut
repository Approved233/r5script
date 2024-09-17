global function InitGamemodeSelectDialog
global function GamemodeSelect_IsEnabled
global function GamemodeSelect_JumpToCups

struct {
	var menu

	var background

	bool isOpen
} file




void function InitGamemodeSelectDialog( var menu )
{
	RegisterSignal( "GamemodeSelectClosed" )

	file.menu = menu

	file.background = Hud_GetChild( menu, "ScreenFrame" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, GamemodeSelect_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, GamemodeSelect_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, GamemodeSelect_NavBack )

	AddCallback_OnPartyMemberAdded( OnPartyChanged )
	AddCallback_OnPartyMemberRemoved( OnPartyChanged )

	SetDialog( menu, true )
	SetClearBlur( menu, false )

#if DEV
	AddMenuThinkFunc( menu, GameModeAutomationThink )
#endif
}

void function GamemodeSelect_Open()
{
	file.isOpen = true

	{
		TabDef tabDef = AddTab( file.menu, Hud_GetChild( file.menu, "GamemodeSelectDialogPublicPanel" ), "#GAMEMODE_CATEGORY_PUBLIC_MATCH" )
		SetTabBaseWidth( tabDef, 300 )
	}


	if ( CupsEnabled() )
	{
		
		if ( Cups_GetVisibleEvents().len() > 0 )
		{
			TabDef tabDef = AddTab( file.menu, Hud_GetChild( file.menu, "RTKGamemodeSelectApexCups" ), "#GAMEMODE_APEX_CUPS_TAB" )
			SetTabBaseWidth( tabDef, 300 )

			thread GamemodeSelect_RefreshCupsTabAsync( tabDef )
		}
	}



		{
			TabDef tabDef = AddTab( file.menu, Hud_GetChild( file.menu, "GamemodeSelectDialogPrivatePanel" ), "#GAMEMODE_CATEGORY_PRIVATE_MATCH" )
			SetTabBaseWidth( tabDef, 300 )

			GamemodeSelect_SetPrivateMatchEnabled()
		}


	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	SetTabDefsToSeasonal(tabData)
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		ActivateTab( tabData, 0 )
	}

	AnimateIn()

}

void function GamemodeSelect_RefreshCupsTabAsync( TabDef tabDef )
{
	EndSignal( GetLocalClientPlayer(), "GamemodeSelectClosed" )

	Cups_WaitForResponse()

	if ( !IsPersistenceAvailable() )
		return

	
	int unixTime = GetUnixTimestamp()
	foreach ( ItemFlavor cupEvent in Cups_GetAllEvents() )
	{
		
		if ( !CalEvent_IsVisible( cupEvent, unixTime ) && !Cups_HasParticipated( cupEvent ) )
			continue

		
		if ( !CalEvent_IsActive( cupEvent, unixTime ) )
			continue

		
		int lockState = RTKGameModeSelectApexCups_GetLockState( cupEvent )
		if ( lockState != CUP_LOCK_NONE )
			continue

		ItemFlavor ornull activeCupFlavor = Cups_GetEligbleCup( cupEvent )
		if ( activeCupFlavor == null )
			continue
		expect ItemFlavor( activeCupFlavor )

		
		int persistenceDataIndex = Cups_GetPlayersPDataIndexForCupID( GetLocalClientPlayer(), activeCupFlavor.guid )
		if ( persistenceDataIndex < 0 )
			continue

		
		bool cupSeen = expect bool( GetPersistentVar( format( "cups[%d].uiSeen", persistenceDataIndex ) ) )
		if ( !cupSeen )
		{
			tabDef.new = true
			UpdateMenuTabs()

			break
		}
	}
}

void function GamemodeSelect_Close()
{
	Signal( GetLocalClientPlayer(), "GamemodeSelectClosed" )

	file.isOpen = false
	ClearTabs( file.menu )
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), true )

	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )

	SetModeSelectMenuOpen( false )

	Lobby_OnGamemodeSelectClose()

}

void function GamemodeSelect_NavBack()
{
	if( !file.isOpen )
		return

	TabData gamemodeTabData = GetTabDataForPanel( file.menu )

	
	if ( gamemodeTabData.activeTabIdx == Tab_GetTabIndexByBodyName( gamemodeTabData, "RTKGamemodeSelectApexCups" ) )
		ActivateTab( gamemodeTabData, 0 )
	else
		CloseActiveMenu()
}
#if DEV
void function GameModeAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("GameModeAutomationThink OnCloseButton_Activate()")
		CloseAllDialogs()
	}
}
#endif

void function AnimateIn()
{
	SetElementAnimations(file.background, 0, 0.14)
}

void function SetElementAnimations( var element, float delay, float duration )
{
	RuiSetWallTimeWithOffset( Hud_GetRui( element ), "animateStartTime", delay )
	RuiSetFloat( Hud_GetRui( element ), "animateDuration", duration )
}

void function OnPartyChanged()
{
	if( !file.isOpen )
		return

	GamemodeSelect_SetPrivateMatchEnabled()
}

void function GamemodeSelect_SetPrivateMatchEnabled()
{
	if( !file.isOpen )
		return

	TabData tabData = GetTabDataForPanel( file.menu )
	TabDef tabDef   = Tab_GetTabDefByBodyName( tabData, "GamemodeSelectDialogPrivatePanel" )

	bool isEnabled = GetPartySize() <= PRIVATE_MATCH_MAX_PARTY_SIZE
	tabDef.enabled = isEnabled

	Hud_ClearToolTipData( tabDef.button )

	if(!isEnabled )
	{
		ToolTipData tooltip
		tooltip.descText = "#CUSTOMMATCH_TOOLTIP_UNAVILIABLE"

		Hud_SetToolTipData( tabDef.button, tooltip )
		if( GetMenuActiveTabIndex(file.menu ) > 0 )
			ActivateTab( tabData, 0 )
	}

	UpdateMenuTabs()
}




bool function GamemodeSelect_IsEnabled()
{
	if ( !IsConnectedServerInfo() )
		return false
	
	return GetCurrentPlaylistVarBool( "gamemode_select_v3_enable", true )
}

void function GamemodeSelect_JumpToCups( var button )
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	var menu = GetMenu( "GamemodeSelectDialog" )
	AdvanceMenu( menu )
	TabData gamemodeTabData = GetTabDataForPanel( menu )

	
	int tabIdx = Tab_GetTabIndexByBodyName( gamemodeTabData, "RTKGamemodeSelectApexCups" )
	if ( tabIdx == -1 )
		return

	ActivateTab( gamemodeTabData, tabIdx )
}