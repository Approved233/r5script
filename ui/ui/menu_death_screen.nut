global function InitDeathScreenMenu


global function UI_OpenDeathScreenMenu
global function UI_CloseDeathScreenMenu
global function UI_EnableDeathScreenTab
global function UI_SwitchToDeathScreenTab
global function UI_SetDeathScreenTabTitle
global function UI_GetDeathScreenRequeueElement
global function UI_DeathScreenUpdateHeader
global function UI_DeathScreenHideTabs
global function UI_DeathScreenSetRespawnStatus
global function UI_RequeueStatusChanged
global function UI_IsReadyForRequeue
global function UI_IsFullPartyConnectedForRequeue

global function UI_DeathScreenSetBannerCraftingStatus

global function UI_DeathScreenSetSpectateTargetCount
global function UI_DeathScreenSetCanReportRecapPlayer
global function UI_DeathScreenSetObserverMode
global function UI_DeathScreenSetBlockPlayer
global function UI_SetCanShowGladCard
global function UI_SetShouldShowSkip
global function UI_SetIsEliminiated
global function UI_DeathScreenFadeInBlur
global function UI_SetAllowGladCard

global function DeathScreenIsOpen
global function DeathScreenOnReportButtonClick
global function DeathScreenOnBlockButtonClick
global function DeathScreenTryToggleGladCard

global function DeathScreenTryToggleUpgradesOnGladCard

global function DeathScreenPingRespawn
global function DeathScreenSpectateNext
global function DeathScreenSkipDeathCam
global function DeathScreenSkipRecap
global function DeathScreenUpdateCursor
global function DeathScreenGetHeader

global function InitDeathScreenPanelFooter

#if DEV
global function ShowBanner
#endif

struct
{
	var       menu
	bool      tabsInitialized
	float     menuOpenTime
	bool      isGladCardShowing = true	

		bool      isUpgradesGladCardShowing = false	

	bool      canShowGladCard = true	
	bool      canReportRecapPlayer
	int       observerMode
	string    blockEAID
	string    blockHardware
	bool      shouldShowSkip
	bool      isEliminated
	int       respawnStatus
	bool	  fullPartyConnectedForRequeue
	bool	  canRequeue
	int       spectateTargetCount
	bool      allowGladCard = true
	InputDef& gladCardToggleInputData

	bool	  bannerCanBeCrafted = false


} file


void function InitDeathScreenMenu( var menu )
{
	file.menu = menu

	SetMenuReceivesCommands( menu, true )
	DeathScreen_AddPassthroughCommandsToMenu( menu ) 

	AddUICallback_UIShutdown( DeathScreenMenu_Shutdown )
	AddUICallback_OnResolutionChanged( DeathScreenMenu_OnResolutionChanged )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, DeathScreenMenuOnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, DeathScreenMenuOnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, DeathScreenMenuOnNavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_INPUT_MODE_CHANGED, OnSurvivalInventory_OnInputModeChange )

	SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
	SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )
}


void function InitDeathScreenPanelFooter( var panel, int panelID )
{
	
	AddPanelFooterOption( panel, RIGHT, BUTTON_START, true, "#BUTTON_OPEN_MENU", "#BUTTON_OPEN_MENU", DeathScreenTryOpenSystemMenu, DeathScreenShowMenuButton )
	AddPanelFooterOption( panel, RIGHT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", null, DeathScreenShowNavBack )


	
	AddPanelFooterOption( panel, RIGHT, KEY_SPACE, true, "#BUTTON_LOBBY_RETURN", "#BUTTON_LOBBY_RETURN", DeathScreenLeaveGameDialog, DeathScreenShowLobbyButton )
	AddPanelFooterOption( panel, RIGHT, KEY_SPACE, true, "", "#SPACE_LOBBY_RETURN", DeathScreenLeaveGameDialog, DeathScreenShowLobbySpace )


		
		if( panelID != eDeathScreenPanel.SCOREBOARD )
		{
				if( panelID == eDeathScreenPanel.SQUAD_SUMMARY || panelID == eDeathScreenPanel.CUP || panelID == eDeathScreenPanel.RANK || panelID == eDeathScreenPanel.SQUAD )
					AddPanelFooterOption( panel, RIGHT, KEY_ENTER, false, "", "", UI_OnLoadoutButton_Enter_RTKMenu )
				else
					AddPanelFooterOption( panel, RIGHT, KEY_ENTER, false, "", "", UI_OnLoadoutButton_Enter )
		}


	
	switch( panelID )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_REPORT_PLAYER", "#BUTTON_REPORT_PLAYER", DeathScreenOnReportButtonClick, DeathRecapCanReportPlayer )
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_LEFT, true, "#BUTTON_BLOCK_PLAYER", "#BUTTON_BLOCK_PLAYER", DeathScreenOnBlockButtonClick, CanBlockPlayer )

				AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_SKIP", "#X_BUTTON_SKIP", DeathScreenSkipRecap, CanSkipRecap )

			break

		case eDeathScreenPanel.KILLREPLAY:
			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#BUTTON_SKIP", "#BUTTON_SKIP", DeathScreenSkipDeathCam, CanSkipDeathCam )
		case eDeathScreenPanel.SPECTATE:
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_REPORT_PLAYER", "#BUTTON_REPORT_PLAYER", DeathScreenOnReportButtonClick, CanReportPlayer )
			
			
			
			AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#DEATH_SCREEN_NEXT_SPECTATE", "#DEATH_SCREEN_NEXT_SPECTATE", DeathScreenSpectateNext, DeathScreenCanChangeSpectateTarget )

			
			string gladCardMessageString = "#SPECTATE_HIDE_BANNER"
			if ( !IsGladCardShowing() )
				gladCardMessageString = "#SPECTATE_SHOW_BANNER"

			file.gladCardToggleInputData = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, gladCardMessageString, gladCardMessageString, DeathScreenTryToggleGladCard, AllowGladCard )

			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#HINT_PING_GLADIATOR_CARD", "#HINT_PING_GLADIATOR_CARD", DeathScreenPingRespawn, DeathScreenRespawnWaitingForPickup )
			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#HINT_PING_RESPAWN_BEACON", "#HINT_PING_RESPAWN_BEACON", DeathScreenPingRespawn, DeathScreenRespawnWaitingForDelivery )


				AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#HINT_PING_NEAREST_REPLICATOR", "#HINT_PING_NEAREST_REPLICATOR", DeathScreenPingReplicator, DeathScreenRespawnWaitingForBannerCraft )


			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			break

		case eDeathScreenPanel.SCOREBOARD:

				AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_SKIP", "#X_BUTTON_SKIP", DeathScreenSkipRecap, CanSkipRecap )

			break

		case eDeathScreenPanel.RANK:
			break

		case eDeathScreenPanel.CUP:
			break

		case eDeathScreenPanel.SQUAD:
			break

		default:
			unreachable
	}

#if DEV
	AddMenuThinkFunc( Hud_GetParent( panel ), DeathScreenPanelFooterAutomationThink )
#endif

#if PC_PROG_NX_UI
	
	
	if( Hud_HasChild( panel, "LobbyChatBox" ) )
	{
		UISize screenSize   = GetScreenSize()
		float resMultiplier = screenSize.height / 1080.0
		int width           = 900
		int height          = 200

		var chatbox = Hud_GetChild( panel, "LobbyChatBox" )

		Hud_SetSize( chatbox, width * resMultiplier, height * resMultiplier )
	}
	
#endif
}


void function DeathScreenMenuOnOpen()
{
	TabDef spectateTab
	TabDef recapTab
	TabDef scoreboardTab
	TabDef squadSummaryTab
	TabDef squadTab
	TabDef rankTab
	TabDef rumbleTab
	TabDef killreplayTab

	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		

		spectateTab     = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenSpectate" ), "#DEATH_SCREEN_SPECTATE" ) 
		recapTab        = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenRecap" ), "#DEATH_SCREEN_RECAP" ) 
		scoreboardTab   = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenGenericScoreboardPanel" ), "#TAB_SCOREBOARD" ) 
		squadSummaryTab = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenSquadSummary" ), "#DEATH_SCREEN_SUMMARY" ) 


			if( IsRTKSquadsEnabled() )
				squadTab        = AddTab( file.menu, Hud_GetChild( file.menu, "RTKDeathScreenSquadPanel" ), "#SQUAD" )	
			else

		{
			squadTab        = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenSquadPanel" ), "#SQUAD" )
		}	

		rankTab         = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenRankedMatchSummaryPanel" ), "#MENU_BADGE_RANKED" ) 
		rumbleTab       = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenPostGameCupsPanel" ), "#GAMEMODE_APEX_CUPS_TAB" ) 
		killreplayTab   = AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenKillreplay" ), "#DEATH_KILL_REPLAY" )


		SetTabBaseWidth( spectateTab, 200 )
		SetTabBaseWidth( recapTab, 200 )
		SetTabBaseWidth( scoreboardTab, 210 )
		SetTabBaseWidth( squadSummaryTab, 200 )
		SetTabBaseWidth( squadTab, 150 )
		SetTabBaseWidth( rankTab, 200 )
		SetTabBaseWidth( rumbleTab, 200 )
		SetTabBaseWidth( killreplayTab, 200 )

		AddCallback_OnTabChanged( DeathScreen_OnTabChanged )
		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	spectateTab     = Tab_GetTabDefByBodyName( tabData, "DeathScreenSpectate" )
	recapTab        = Tab_GetTabDefByBodyName( tabData, "DeathScreenRecap" )
	scoreboardTab   = Tab_GetTabDefByBodyName( tabData, "DeathScreenGenericScoreboardPanel" )
	squadSummaryTab = Tab_GetTabDefByBodyName( tabData, "DeathScreenSquadSummary" )

		if( IsRTKSquadsEnabled() )
			squadTab        = Tab_GetTabDefByBodyName( tabData, "RTKDeathScreenSquadPanel" )
		else

	{
		squadTab        = Tab_GetTabDefByBodyName( tabData, "DeathScreenSquadPanel" )
	}
	rankTab         = Tab_GetTabDefByBodyName( tabData, "DeathScreenRankedMatchSummaryPanel" )
	rumbleTab       = Tab_GetTabDefByBodyName( tabData, "DeathScreenPostGameCupsPanel" )
	killreplayTab   = Tab_GetTabDefByBodyName( tabData, "DeathScreenKillreplay" )

	SetTabDefsToSeasonal(tabData)
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.DEATH )

	spectateTab.title = "#DEATH_SCREEN_SPECTATE"

	SetTabDefEnabled( spectateTab, false )
	SetTabDefEnabled( recapTab, false )
	SetTabDefEnabled( scoreboardTab, false )
	SetTabDefEnabled( squadSummaryTab, false )
	SetTabDefEnabled( squadTab, false )
	SetTabDefEnabled( rankTab, false )
	SetTabDefEnabled( rumbleTab, false )
	SetTabDefEnabled( killreplayTab, false )

	SetTabDefVisible( spectateTab, false )
	SetTabDefVisible( recapTab, false )
	SetTabDefVisible( scoreboardTab, false )
	SetTabDefVisible( squadSummaryTab, false )
	SetTabDefVisible( squadTab, false )
	SetTabDefVisible( rankTab, false )
	SetTabDefVisible( rumbleTab, false )
	SetTabDefVisible( killreplayTab, false )

	UpdateMenuTabs()

	Hud_Show( Hud_GetChild( file.menu, "TabsCommon" ) )

	SetTabNavigationEnabled( file.menu, true )

	var screenBlur = Hud_GetChild( file.menu, "ScreenBlur" )
	HudElem_SetRuiArg( screenBlur, "startTime", ClientTime(), eRuiArgType.GAMETIME )    



	file.menuOpenTime = UITime()
	
	file.respawnStatus = 0
	file.spectateTargetCount = 0
	file.shouldShowSkip = true 

	UISize screenSize = GetScreenSize()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

	if ( CanRunClientScript() )
	{
		
		RunClientScript( "UICallback_ToggleGladCard", file.isGladCardShowing )

		RunClientScript( "UICallback_SetChangeLegendButton", DeathScreenGetChangeLegendButton() )
		RunClientScript( "UICallback_SetChangeLoadoutButton", DeathScreenGetChangeLoadoutButton() )
	}

	Hud_AddEventHandler( DeathScreenGetChangeLegendButton(), UIE_CLICK, ChangeLegend_OnActivate )
	Hud_AddEventHandler( DeathScreenGetChangeLoadoutButton(), UIE_CLICK, ChangeLoadout_OnActivate )

	if( !IsPrivateMatch() )
	{
		RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, UI_FullmapChallengeCategoryLeft )
		RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, UI_FullmapChallengeCategoryRight )
		RegisterButtonPressedCallback( KEY_Y, UI_FullmapChallengeCategoryRight )
	}

	RegisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, ChangeLegend_OnActivate )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, ChangeLoadout_OnActivate )

#if DEV
		RegisterButtonPressedCallback( KEY_PAD_ENTER, DevExit )
#endif

	RegisterButtonPressedCallback( BUTTON_DPAD_UP, RequeueWithParty )
	RegisterButtonPressedCallback( KEY_1, RequeueWithParty )

	SetFooterPanelVisibility( file.menu, true )

	UpdateFooterOptions()
}


void function DeathScreen_OnTabChanged()
{
	if ( GetActiveMenu() != file.menu )
		return

	TabData tabData = GetTabDataForPanel( file.menu )

	
	if ( tabData.activeTabIdx  == eDeathScreenPanel.RANK )
	{
		var headerElement = Hud_GetChild( file.menu, "Header" )
		if ( CanRunClientScript() )
			RunClientScript( "UICallback_ShowRank", headerElement )
	}
	else if ( tabData.activeTabIdx  == eDeathScreenPanel.CUP )
	{
		var headerElement = Hud_GetChild( file.menu, "Header" )
		if ( CanRunClientScript() )
			RunClientScript( "UICallback_ShowCup", headerElement )
	}
}


void function DeathScreenMenuOnClose()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	DeactivateTab( tabData )

	Hud_RemoveEventHandler( DeathScreenGetChangeLegendButton(), UIE_CLICK, ChangeLegend_OnActivate )
	Hud_RemoveEventHandler( DeathScreenGetChangeLoadoutButton(), UIE_CLICK, ChangeLoadout_OnActivate )

	if( !IsPrivateMatch() )
	{
		DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, UI_FullmapChallengeCategoryLeft )
		DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, UI_FullmapChallengeCategoryRight )
		DeregisterButtonPressedCallback( KEY_Y, UI_FullmapChallengeCategoryRight )
	}

	DeregisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, ChangeLegend_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, ChangeLoadout_OnActivate )

#if DEV
		DeregisterButtonPressedCallback( KEY_PAD_ENTER, DevExit )
#endif

	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, RequeueWithParty )
	DeregisterButtonPressedCallback( KEY_1, RequeueWithParty )

	if ( IsFullyConnected() && CanRunClientScript() )
		RunClientScript( "UICallback_CloseDeathScreenMenu", GetGameState() < eGameState.WinnerDetermined  )


	Hud_SetVisible( DeathScreenGetChangeLegendButton(), false )
	Hud_SetVisible( DeathScreenGetChangeLoadoutButton(), false )
}


void function UI_OpenDeathScreenMenu( int tabIndex )
{
	
	
	CloseAllMenus()

	if ( !MenuStack_Contains( file.menu ) )
	{
		AdvanceMenu( file.menu )
		
	}

	EnableDeathScreenTab_Internal( tabIndex, true )

	
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, tabIndex )
}


void function UI_CloseDeathScreenMenu()
{
	

	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
	}
	else if ( MenuStack_Contains( file.menu ) )
	{
		if( IsDialog( GetActiveMenu() ) )
		{
			
			CloseAllMenus()
		}
		else
		{
			
			MenuStack_Remove( file.menu )
			DeathScreenMenuOnClose()
		}
	}
}


void function UI_EnableDeathScreenTab( int tabIndex, bool enable )
{
	
	EnableDeathScreenTab_Internal( tabIndex, enable )
}


void function EnableDeathScreenTab_Internal( int tabIndex, bool enable )
{
	if ( !MenuStack_Contains( file.menu ) )
		return

	string panelName
	switch( tabIndex )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			panelName = "DeathScreenRecap"
			break

		case eDeathScreenPanel.SPECTATE:
			panelName = "DeathScreenSpectate"
			break

		case eDeathScreenPanel.KILLREPLAY:
			
			return

		case eDeathScreenPanel.SCOREBOARD:
			panelName = "DeathScreenGenericScoreboardPanel"
			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			panelName = "DeathScreenSquadSummary"
			break

		case eDeathScreenPanel.SQUAD:

				if( IsRTKSquadsEnabled() )
					panelName = "RTKDeathScreenSquadPanel"
				else

			{
				panelName = "DeathScreenSquadPanel"
			}

			break

		case eDeathScreenPanel.RANK:
			panelName = "DeathScreenRankedMatchSummaryPanel"
			break

		case eDeathScreenPanel.CUP:
			panelName = "DeathScreenPostGameCupsPanel"
			break

		default:
			unreachable
			break
	}

	


	TabData tabData = GetTabDataForPanel( file.menu )
	TabDef tabDef   = Tab_GetTabDefByBodyName( tabData, panelName )

	SetTabDefEnabled( tabDef, enable )
	SetTabDefVisible( tabDef, enable )

	if ( !enable && tabData.activeTabIdx == tabIndex )
	{
		
		DeactivateTab( tabData )
	}
}


void function UI_SwitchToDeathScreenTab( int tabIndex )
{
	

	if ( !MenuStack_Contains( file.menu ) )
		return

	EnableDeathScreenTab_Internal( tabIndex, true )

	TabData tabData = GetTabDataForPanel( file.menu )

	

	if ( tabData.activeTabIdx != tabIndex )
		ActivateTab( tabData, tabIndex )
	
	
}


void function UI_DeathScreenFadeInBlur( bool fadeInBlur )
{
	float startTime = fadeInBlur ? ClientTime() : 0.0

	

	var screenBlur = Hud_GetChild( file.menu, "ScreenBlur" )
	HudElem_SetRuiArg( screenBlur, "startTime", startTime, eRuiArgType.GAMETIME )
}


void function UI_SetDeathScreenTabTitle( int tabIndex, string title )
{
	
	if ( !MenuStack_Contains( file.menu ) )
	{
		
		return
	}

	string panelName
	switch( tabIndex )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			panelName = "DeathScreenRecap"
			break

		case eDeathScreenPanel.SPECTATE:
			panelName = "DeathScreenSpectate"
			break

		case eDeathScreenPanel.SCOREBOARD:
			panelName = "DeathScreenGenericScoreboardPanel"
			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			panelName = "DeathScreenSquadSummary"
			break

		case eDeathScreenPanel.SQUAD:

				if( IsRTKSquadsEnabled() )
					panelName = "RTKDeathScreenSquadPanel"
				else

			{
				panelName = "DeathScreenSquadPanel"
			}
			break

		case eDeathScreenPanel.RANK:
			panelName = "DeathScreenRankedMatchSummaryPanel"
			break

		case eDeathScreenPanel.CUP:
			panelName = "DeathScreenPostGameCupsPanel"
			break

		default:
			unreachable
			break
	}

	TabData tabData = GetTabDataForPanel( file.menu )
	TabDef tabDef   = Tab_GetTabDefByBodyName( tabData, panelName )
	tabDef.title = title

	UpdateMenuTabs()
}


var function UI_GetDeathScreenRequeueElement()
{
	return Hud_GetChild( file.menu, "DeathScreenRequeue" )
}


void function UI_SetCanShowGladCard( bool canShowGladCard )
{
	

	if ( file.canShowGladCard == canShowGladCard )
		return

	file.canShowGladCard = canShowGladCard
	UpdateFooterOptions()
}


void function UI_SetAllowGladCard( bool allowGladCard )
{
	


	if ( file.allowGladCard == allowGladCard )
		return

	file.allowGladCard = allowGladCard
	UpdateFooterOptions()
}


void function UI_SetShouldShowSkip( bool shouldShowSkip )
{
	
	file.shouldShowSkip = shouldShowSkip
	UpdateFooterOptions()
}


void function UI_SetIsEliminiated( bool isEliminated)
{
	
	file.isEliminated = isEliminated
	UpdateFooterOptions()
}


void function UI_DeathScreenSetRespawnStatus( int respawnStatus )
{
	file.respawnStatus = respawnStatus
	UpdateFooterOptions()
}

void function UI_RequeueStatusChanged( bool canRequeue, bool fullPartyConnected )
{
	if ( file.canRequeue && !canRequeue )
		MatchRequeueCancel()

	file.canRequeue = canRequeue
	file.fullPartyConnectedForRequeue = fullPartyConnected
}

bool function UI_IsReadyForRequeue()
{

	if( GameModeVariant_IsActiveForPlaylist( GetCurrentPlaylistName(), eGameModeVariants.SURVIVAL_RANKED ) && RankedRumble_IsLatestGameRankedRumble( GetLocalClientPlayer() ) )
	{



	}


	return ( file.isEliminated || GetGameState() >= eGameState.WinnerDetermined ) &&
		IsMatchmakingFromMatchAllowed( GetLocalClientPlayer() ) &&
		!LeaveMatch_WasInitiated()
}

bool function UI_IsFullPartyConnectedForRequeue()
{
	return file.fullPartyConnectedForRequeue
}


void function UI_DeathScreenSetBannerCraftingStatus( bool bannerCanBeCrafter )
{
	file.bannerCanBeCrafted = bannerCanBeCrafter
}



void function UI_DeathScreenSetSpectateTargetCount( int targetCount )
{
	
	file.spectateTargetCount = targetCount
	UpdateFooterOptions()
}


void function UI_DeathScreenSetCanReportRecapPlayer( bool canReport )
{
	file.canReportRecapPlayer = canReport
	UpdateFooterOptions()
}


void function UI_DeathScreenSetObserverMode( int observerMode )
{
	file.observerMode = observerMode
	UpdateFooterOptions()
}


void function UI_DeathScreenSetBlockPlayer( string eaid, string hardware )
{
	printt( "#EADP UI_DeathScreenSetBlockPlayer", eaid, hardware )
	file.blockEAID = eaid
	file.blockHardware = hardware
	UpdateFooterOptions()
}


void function UI_DeathScreenUpdateHeader()
{
	

	var headerElement = Hud_GetChild( file.menu, "Header" )
	if ( CanRunClientScript() )
		RunClientScript( "UICallback_UpdateHeader", headerElement )
}

void function UI_DeathScreenHideTabs( bool hide )
{
	var tabElement = Hud_GetChild( file.menu, "TabsCommon" )
	Hud_SetVisible( tabElement, !hide )
}

void function UI_OnLoadoutButton_Enter( var button )
{
	

	var panel   = _GetActiveTabPanel( file.menu )
	var chatbox = Hud_GetChild( panel, "LobbyChatBox" )

	if ( !HudChat_HasAnyMessageModeStoppedRecently() )
		Hud_StartMessageMode( chatbox )

	Hud_SetVisible( chatbox, true )
}

void function UI_OnLoadoutButton_Enter_RTKMenu( var button )
{
	

	var panel   = _GetActiveTabPanel( file.menu )
	var parentPanel = Hud_GetParent( panel )
	var child = Hud_GetChild( parentPanel, "DeathScreenChatBox" )
	var chatbox = Hud_GetChild( child, "LobbyChatBox" )

	if ( !HudChat_HasAnyMessageModeStoppedRecently() )
		Hud_StartMessageMode( chatbox )

	Hud_SetVisible( chatbox, true )
}

void function OnSurvivalInventory_OnInputModeChange()
{
}

var function DeathScreenGetHeader()
{
	return Hud_GetChild( file.menu, "Header" )
}

var function DeathScreenGetChangeLegendButton()
{
	return Hud_GetChild( file.menu, "ChangeLegendButton" )
}

var function DeathScreenGetChangeLoadoutButton()
{
	return Hud_GetChild( file.menu, "ChangeLoadoutButton" )
}


void function DeathScreenMenu_OnResolutionChanged()
{
	if ( IsFullyConnected() && CanRunClientScript() )
	{
		RunClientScript( "UICallback_OnResolutionChange" )
		RunClientScript( "UICallback_SetChangeLegendButton", DeathScreenGetChangeLegendButton() )
		RunClientScript( "UICallback_SetChangeLoadoutButton", DeathScreenGetChangeLoadoutButton() )
	}
}


void function DeathScreenMenu_Shutdown()
{
	if ( IsFullyConnected() && CanRunClientScript() )
		RunClientScript( "UICallback_DestroyAllClientGladCardData" )
	return
}


void function DeathScreenMenuOnNavBack()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	{
		int tabIndex = GetMenuActiveTabIndex( file.menu )
		if ( tabIndex == eDeathScreenPanel.SPECTATE && GetGameState() < eGameState.Resolution )
		{
			if ( file.isEliminated && IsTabIndexEnabled( tabData, eDeathScreenPanel.SQUAD_SUMMARY ) )
			{
				ActivateTab( tabData, eDeathScreenPanel.SQUAD_SUMMARY )
			}
			else if ( InputIsButtonDown( KEY_ESCAPE ) )
			{
				OpenSystemMenu()
			}
		}
		else if ( ( tabIndex == eDeathScreenPanel.DEATH_RECAP || tabIndex == eDeathScreenPanel.SCOREBOARD || tabIndex == eDeathScreenPanel.SQUAD ) && GetGameState() < eGameState.Resolution )
		{
			if ( file.isEliminated && IsTabIndexEnabled( tabData, eDeathScreenPanel.SQUAD_SUMMARY ) )
			{
				ActivateTab( tabData, eDeathScreenPanel.SQUAD_SUMMARY )
			}
			else
			{
				if( GetGameState() < eGameState.Playing ) 
					UI_CloseDeathScreenMenu()
				else
				{
					if ( file.isEliminated && IsTabIndexEnabled( tabData, eDeathScreenPanel.SPECTATE ) )
					{
						ActivateTab( tabData, eDeathScreenPanel.SPECTATE )
					}
					else if ( InputIsButtonDown( KEY_ESCAPE ) )
					{
						OpenSystemMenu()
					}
				}
			}
		}
		else
		{
			if ( InputIsButtonDown( KEY_ESCAPE ) )
				OpenSystemMenu()
			else
				LeaveDialog()
		}
	}
}


void function DeathScreen_AddPassthroughCommandsToMenu( var menu )
{
	AddCommandForMenuToPassThrough( menu, "toggle_map" )
}


bool function DeathScreenShowLobbySpace()
{
	return DeathScreenCanLeaveMatch() && !( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY )
}


bool function DeathScreenShowLobbyButton()
{
	return DeathScreenCanLeaveMatch() && ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY || GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SCOREBOARD )
}


bool function DeathScreenCanLeaveMatch()
{
	
	if ( GetGameState() >= eGameState.Resolution )
		return true

	
	if ( GetGameState() >= eGameState.WinnerDetermined )
		return false

	return file.isEliminated
}


bool function DeathScreenShowNavBack()
{
	return !CurrentTabIsDeadEnd() && GetGameState() < eGameState.Resolution
}


bool function DeathScreenShowMenuButton()
{
	return !DeathScreenCanLeaveMatch() && CurrentTabIsDeadEnd()
}


bool function CurrentTabIsDeadEnd()
{
	if ( file.isEliminated )
	{
		return ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY )
	}

	return ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SPECTATE )
}


bool function DeathScreenRespawnWaitingForPickup()
{
	return file.respawnStatus == eRespawnStatus.WAITING_FOR_PICKUP
}


bool function DeathScreenRespawnWaitingForDelivery()
{
	return file.respawnStatus == eRespawnStatus.WAITING_FOR_DELIVERY && RespawnBeacons_PLV_Enabled()
}


bool function DeathScreenRespawnWaitingForBannerCraft()
{
	if( file.respawnStatus == eRespawnStatus.PICKUP_DESTROYED && file.bannerCanBeCrafted )
		return true

	return false
}


bool function DeathScreenCanChangeSpectateTarget()
{
	return file.spectateTargetCount	> 1
}


bool function DeathRecapCanReportPlayer()
{
	return GetReportStyle() != 0 && file.canReportRecapPlayer
}


bool function CanReportPlayer()
{
	return GetReportStyle() != 0 && !file.shouldShowSkip && file.observerMode == OBS_MODE_IN_EYE
}


void function DeathScreenPingRespawn( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UICallback_TryPingRespawn" )
}


void function DeathScreenPingReplicator( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UICallback_TryPingReplicator" )
}


void function DeathScreenLeaveGameDialog( var button )
{
	if ( DeathScreenCanLeaveMatch() )
		LeaveDialog()
}


bool function IsGladCardShowing()
{
	if ( !CanShowGladCard() )
		return false

	return file.isGladCardShowing
}


bool function CanShowGladCard()
{
	return file.canShowGladCard
}

bool function AllowGladCard()
{
	return file.allowGladCard
}


bool function CanSkipDeathCam()
{
	if ( GetGameState() > eGameState.Playing )
		return false

	if (!IsFullyConnected())
		return false

	bool playlistEnabled = GamemodeUtility_GetKillReplayActive()


	if ( GameMode_IsActive( eGameModes.CONTROL ) && !playlistEnabled )
		return false



	if ( GameModeVariant_IsActive( eGameModeVariants.FREEDM_TDM ) && !playlistEnabled )
		return false



	if ( GameModeVariant_IsActive( eGameModeVariants.FREEDM_GUNGAME ) && !playlistEnabled )
		return false

	
	
	
	
	

	return file.shouldShowSkip
}

bool function CanSkipRecap()
{
	if ( GetGameState() > eGameState.Playing  )
		return false

	if( !IsConnected() )
		return false







	return false
}

void function DeathScreenTryOpenSystemMenu( var panel )
{
	OpenSystemMenu()
}


bool function CanBlockPlayer()
{
	printt( "#EADP CanBlockPlayer", CrossplayUserOptIn(), file.blockHardware, file.blockEAID, EADP_IsBlockedByEAID( file.blockEAID ) )
	if ( !CrossplayUserOptIn() )
		return false

	if ( IsUserOnSamePlatform( file.blockHardware ) )
		return false

	if ( file.blockEAID == "" )
		return false

	if ( EADP_IsBlockedByEAID( file.blockEAID ) )
		return false

	return true
}


void function DeathScreenOnBlockButtonClick( var button )
{
	printt( "#EADP DeathScreenOnBlockButtonClick" )
	if ( !CanBlockPlayer() )
		return

	if( !CanRunClientScript() )
		return

	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) || InputIsButtonDown( GetPCBlockKey() ) )
	{
		thread RunClientScriptOnButtonHold( BUTTON_STICK_LEFT, GetPCBlockKey(), "UICallback_BlockPlayer" )
		return
	}
	else if ( CanRunClientScript() )
	{
		
		RunClientScript( "UICallback_BlockPlayer" )
	}
}


void function DeathScreenOnReportButtonClick( var button )
{
	if( !CanRunClientScript() )
		return

	if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) || InputIsButtonDown( GetPCReportKey() ) )
	{
		thread RunClientScriptOnButtonHold( BUTTON_STICK_RIGHT, GetPCReportKey(), "UICallback_ReportPlayer" )
		return
	}
	else if ( CanRunClientScript() )
	{
		
		RunClientScript( "UICallback_ReportPlayer" )
	}
}


void function DeathScreenSpectateNext( var button )
{
	if ( DeathScreenCanChangeSpectateTarget() )
		SpectatorNextTarget()
}


void function DeathScreenTryToggleGladCard( var button )
{
	file.isGladCardShowing = !file.isGladCardShowing
	if ( CanRunClientScript() )
		RunClientScript( "UICallback_ToggleGladCard", file.isGladCardShowing )

	string gladCardMessageString = "#SPECTATE_HIDE_BANNER"
	if ( !file.isGladCardShowing )
		gladCardMessageString = "#SPECTATE_SHOW_BANNER"

	file.gladCardToggleInputData.mouseLabel = gladCardMessageString
	file.gladCardToggleInputData.gamepadLabel = gladCardMessageString
	UpdateFooterLabels()
}


void function DeathScreenTryToggleUpgradesOnGladCard( var button )
{
	if ( !IsGladCardShowing() )
		return

	if ( !UpgradeCore_IsEnabled() )
		return

	if( !UpgradeCore_GladCardShowUpgrades() ) 
		return


	if ( GameModeVariant_IsActive( eGameModeVariants.FREEDM_TDM ) )
		return



	if ( GameModeVariant_IsActive( eGameModeVariants.FREEDM_GUNGAME ) )
		return



	if ( GameMode_IsActive( eGameModes.CONTROL ) )
		return


	file.isUpgradesGladCardShowing = !file.isUpgradesGladCardShowing
	if ( CanRunClientScript() )
		RunClientScript( "UICallback_ToggleUpgradesGladCard", file.isUpgradesGladCardShowing )
}


void function DeathScreenUpdateCursor()
{
	int tabIndex = GetMenuActiveTabIndex( file.menu )
	if ( tabIndex == eDeathScreenPanel.SPECTATE || tabIndex == eDeathScreenPanel.KILLREPLAY )
	{
		HideGameCursor()
		SetGamepadCursorEnabled( file.menu, false )
	}
	else if ( !IsGamepadCursorEnabled( file.menu ) )
	{
		
		ShowGameCursor()
		SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )
		SetGamepadCursorEnabled( file.menu, true )
	}
}


void function DeathScreenSkipDeathCam( var button )
{
	

	
	if ( CanSkipDeathCam () )
		Remote_ServerCallFunction( "ClientCallback_SkipDeathCam" )
}

void function DeathScreenSkipRecap( var button )
{
	
	if ( CanSkipRecap () )
	{
		Remote_ServerCallFunction( "ClientCallback_SkipDeathCam" )
	}

}

void function RunClientScriptOnButtonHold( int consoleButtonID, int PCKeyID, string clientScriptCallback )
{
	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( ( InputIsButtonDown( consoleButtonID ) || InputIsButtonDown( PCKeyID ) ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( UITime() >= endTIme && ( InputIsButtonDown( consoleButtonID ) || InputIsButtonDown( PCKeyID ) ) )
	{
		if ( CanRunClientScript() )
		{
			printt( "#EADP RunClientScriptOnButtonHold", clientScriptCallback )
			RunClientScript( clientScriptCallback )
		}
		return
	}
}


bool function DeathScreenIsOpen()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == file.menu )
		return true
	return false
}

void function ChangeLegend_OnActivate( var button )
{
	if( Hud_IsVisible( DeathScreenGetChangeLegendButton() ) && DeathScreenIsOpen() && CanRunClientScript() )
		RunClientScript( "UICallback_OpenCharacterSelectMenu" )
}

void function ChangeLoadout_OnActivate( var button )
{
	if( Hud_IsVisible( DeathScreenGetChangeLoadoutButton() ) && DeathScreenIsOpen() )
		LoadoutSelectionMenu_OpenLoadoutMenu( true )
}

void function RequeueWithParty( var button )
{
	if ( !DeathScreenIsOpen() )
		return

	if ( LeaveMatch_WasInitiated() )
		return


	entity clientPlayer = GetLocalClientPlayer()
	if ( !IsMatchmakingFromMatchAllowed( clientPlayer ) )
		return

	if ( IsMyPartyMatchmaking() )
		AdvanceMenu( GetMenu( "RequeueDialog" ) )
	else
		StartMatchmakingFromMatch()

}

void function UI_FullmapChallengeCategoryLeft( var unused )
{
	if ( CanRunClientScript() )
		RunClientScript( "FullmapChallengeCategoryLeft", null )
}

void function UI_FullmapChallengeCategoryRight( var unused )
{
	if ( CanRunClientScript() )
		RunClientScript( "FullmapChallengeCategoryRight", null )
}

#if DEV
void function DevExit( var button )
{
	CloseActiveMenu()
}

void function ShowBanner()
{
	

	var headerElement = Hud_GetChild( file.menu, "Header" )
	if ( CanRunClientScript() )
		RunClientScript( "DEV_UICallback_UpdateHeader", headerElement )
}
#endif


#if DEV
void function DeathScreenPanelFooterAutomationThink( var menu )
{
	if ( AutomateUi() && !AutomateUiWaitForPostmatch() && DeathScreenShowLobbyButton() )
	{
		if ( AutomateUiRequeue() )
		{
			printt("DeathScreenPanelFooterAutomationThink AutomateUiRequeue()")
			RequeueWithParty( null )
		}
		else{ 
			printt("DeathScreenPanelFooterAutomationThink StopMatchmaking()")
			
			StopMatchmaking()
			ClientCommand( "disconnect" )
			Party_LeaveParty()
		}
	}
}
#endif
