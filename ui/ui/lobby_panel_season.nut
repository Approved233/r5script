global function InitSeasonPanel
global function JumpToSeasonTab
global function IsSeaonPanelCurrentlyTopLevel

global function OnGRXSeasonUpdate

global function SeasonPanel_GetLastMenuNavDirectionTopLevel

struct
{
	var panel

	bool callbacksAdded = false

	bool wasCollectionEventActive = false
	bool wasThemedShopEventActive = false
	bool wasWhatsNewEventActive = false
	bool wasEventShopActive = false
	bool wasMilestoneEventActive = false

	bool isFirstSessionOpen = true

	bool lastMenuNavDirectionTopLevel = MENU_NAV_FORWARD
	bool isOpened = false
} file


void function InitSeasonPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PASSES_HUB" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SeasonPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SeasonPanel_OnHide )
}

bool function IsSeaonPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}

void function SeasonPanel_OnShow( var panel )
{
	file.isOpened = true

	SetCurrentHubForPIN( Hud_GetHudName( panel ) )
	TabData tabData = GetTabDataForPanel( panel )

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	if ( !file.callbacksAdded )
	{
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXSeasonUpdate )
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXSeasonUpdate )
		file.callbacksAdded = true
	}

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
		thread AnimateInSmallTabBar( tabData )
}


void function SeasonPanel_OnHide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )
	file.isOpened = false

	if ( file.callbacksAdded )
	{
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXSeasonUpdate )
		RemoveCallback_OnGRXOffersRefreshed( OnGRXSeasonUpdate )
		file.callbacksAdded = false
	}
}


array<var> function GetAllMenuPanelsSorted( var menu )
{
	array<var> allPanels = GetAllMenuPanels( menu )
	foreach ( panel in allPanels )
		printt( Hud_GetHudName( panel ) )
	allPanels.sort( SortMenuPanelsByPlaylist )

	return allPanels
}


int function SortMenuPanelsByPlaylist( var a, var b )
{
	string playlistVal = GetCurrentPlaylistVarString( "season_panel_order", "PassPanel|ChallengesPanel" )
	if ( playlistVal == "" )
		return 0

	array<string> tokens = split( playlistVal, "|" )
	if ( tokens.find( Hud_GetHudName( a ) ) > tokens.find( Hud_GetHudName( b ) ) )
		return 1
	else if ( tokens.find( Hud_GetHudName( b ) ) > tokens.find( Hud_GetHudName( a ) ) )
		return -1

	return 0
}


void function OnGRXSeasonUpdate()
{
	TabData tabData = GetTabDataForPanel( file.panel )
	bool hasSubTab = false

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		DeactivateTab( tabData )
		SetTabNavigationEnabled( file.panel, false )

		foreach ( tabDef in GetPanelTabs( file.panel ) )
		{
			SetTabDefEnabled( tabDef, false )
		}
	}
	else
	{
		if ( GetMenuNumTabs( file.panel ) == 0 )
		{
			ClearTabs( file.panel )
			array<var> nestedPanels = GetAllMenuPanelsSorted( file.panel )
			foreach ( nestedPanel in nestedPanels )
			{
				AddTab( file.panel, nestedPanel, GetPanelTabTitle( nestedPanel ) )
			}
		}

		SetTabNavigationEnabled( file.panel, true )
		ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )

		int numTabs = tabData.tabDefs.len()
		tabData.centerTabs = true
		SetTabDefsToSeasonal(tabData)
		SetTabBackground( tabData, Hud_GetChild( file.panel, "TabsBackground" ), eTabBackground.STANDARD )

		
		foreach ( TabDef tabDef in GetPanelTabs( file.panel ) )
		{
			bool showTab   = true
			bool enableTab = true

			tabDef.title = GetPanelTabTitle( tabDef.panel )


			if ( Hud_GetHudName( tabDef.panel ) == "RTKBattlepassPanel" )
			{
				ItemFlavor ornull activePass = GetActiveBattlePassV2()
				showTab = activePass != null
				enableTab = showTab
			}



			if ( Hud_GetHudName( tabDef.panel ) == "RTKNewplayerpassPanel" )
			{
				ItemFlavor ornull activePass = NPP_GetPlayerActiveNPP( GetLocalClientPlayer() )
				showTab = activePass != null
				enableTab = showTab
			}


			hasSubTab = hasSubTab || showTab
			SetTabDefVisible( tabDef, showTab )
			SetTabDefEnabled( tabDef, enableTab )
		}

		int activeIndex = tabData.activeTabIdx

		file.lastMenuNavDirectionTopLevel = GetLastMenuNavDirection()

		
		
		bool isSeasonPanelReverseNav = GetCurrentPlaylistVarBool( "season_panel_reverse_nav", true )
		bool isSeasonPanelFirstOpenBehavior = GetCurrentPlaylistVarBool( "season_panel_first_open_behavior", true )

		if ( ( isSeasonPanelReverseNav || ( file.isFirstSessionOpen && isSeasonPanelFirstOpenBehavior ) ) && !storeInspect_JumpingToBPFromBPStorePurchase )
		{
			if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
				activeIndex = 0

			while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex < numTabs )
			{
				activeIndex++
			}
		}
		else if ( storeInspect_JumpingToBPFromBPStorePurchase )
		{
			int tabIndex = Tab_GetTabIndexByBodyName( tabData, "PassPanel" )

			if ( tabIndex == -1 )
			{
				activeIndex = 0

				while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex < numTabs )
					activeIndex++
			}
			else
			{
				activeIndex = tabIndex
			}
		}
		else
		{
			if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
				activeIndex = numTabs - 1

			while( activeIndex < numTabs && (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex >= 0 )
				activeIndex--
		}
		file.isFirstSessionOpen = false

		bool wasPanelActive = IsTabActive( tabData )
		if ( !wasPanelActive && file.isOpened  )
			ActivateTab( tabData, activeIndex )

		UpdateSeasonTabVisibility( hasSubTab )
	}
}


bool function SeasonPanel_GetLastMenuNavDirectionTopLevel()
{
	return file.lastMenuNavDirectionTopLevel
}

void function JumpToSeasonTab( string activateSubPanel = "" )
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	if ( IsTabIndexEnabled( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "SeasonPanel" ) ) )
	{
		ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "SeasonPanel" ) )
	}
	else
	{
		ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" ) )
	}

	if ( activateSubPanel == "" )
		return

	TabData tabData = GetTabDataForPanel( file.panel )
	int tabIndex = Tab_GetTabIndexByBodyName( tabData, activateSubPanel )
	if ( tabIndex == -1 )
	{
		Warning( "JumpToSeasonTab() is ignoring unknown subpanel \"" + activateSubPanel + "\"" )
		return
	}

	if ( IsTabIndexEnabled( tabData, tabIndex ) )
	{
		ActivateTab( tabData, tabIndex )
	}
	else
	{
		ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" ) )
	}
}