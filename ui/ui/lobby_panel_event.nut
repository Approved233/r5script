global function InitEventPanel
global function JumpToEventTab
global function IsEventPanelCurrentlyTopLevel

global function OnGRXEventUpdate

global function EventPanel_GetLastMenuNavDirectionTopLevel

struct
{
	var panel

	bool callbacksAdded = false

	bool wasCollectionEventActive = false
	bool wasThemedShopEventActive = false
	bool wasEventShopActive = false
	bool wasMilestoneEventActive = false

	bool isFirstSessionOpen = true

	bool lastMenuNavDirectionTopLevel = MENU_NAV_FORWARD
	bool isOpened = false
} file


void function InitEventPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#TAB_EVENT" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, EventPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, EventPanel_OnHide )
}

bool function IsEventPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}

void function EventPanel_OnShow( var panel )
{
	file.isOpened = true

	SetCurrentHubForPIN( Hud_GetHudName( panel ) )
	TabData tabData = GetTabDataForPanel( panel )

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	if ( !file.callbacksAdded )
	{
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXEventUpdate )
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXEventUpdate )
		file.callbacksAdded = true
	}

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
		thread AnimateInSmallTabBar( tabData )

	ItemFlavor ornull milestoneEvent = GetActiveEventTabMilestoneEvent( GetUnixTimestamp() )
	if ( milestoneEvent != null )
	{
		var parentPanel = Hud_GetParent( file.panel )
		var mmStatus    = Hud_GetChild( parentPanel, "MatchmakingStatus" )
		HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", true )
	}
}


void function EventPanel_OnHide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )
	file.isOpened = false

	if ( file.callbacksAdded )
	{
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXEventUpdate )
		RemoveCallback_OnGRXOffersRefreshed( OnGRXEventUpdate )
		file.callbacksAdded = false
	}

	var parentPanel = Hud_GetParent( file.panel )
	var mmStatus = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", false )
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
	string playlistVal = GetCurrentPlaylistVarString( "event_panel_order", "RTKEventsPanel|CollectionEventPanel|ThemedShopPanel" )
	if ( playlistVal == "" )
		return 0

	array<string> tokens = split( playlistVal, "|" )
	if ( tokens.find( Hud_GetHudName( a ) ) > tokens.find( Hud_GetHudName( b ) ) )
		return 1
	else if ( tokens.find( Hud_GetHudName( b ) ) > tokens.find( Hud_GetHudName( a ) ) )
		return -1

	return 0
}


void function OnGRXEventUpdate()
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
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = ( activeCollectionEvent != null )
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool hasThemedShopCalevent              = ( activeThemedShopEvent != null )

		ItemFlavor ornull activeEventShop 		= EventShop_GetCurrentActiveEventShop()
		bool haveActiveEventShop          		= activeEventShop != null
		ItemFlavor ornull baseEvent 		    = GetActiveBaseEvent( GetUnixTimestamp() )
		bool haveActiveBaseEvent      	        = baseEvent != null


		bool haveActiveThemedShopEvent			= false
		if ( hasThemedShopCalevent )
		{
			haveActiveThemedShopEvent = ThemedShopEvent_HasThemedShopTab( expect ItemFlavor( activeThemedShopEvent ) )
		}

		if ( haveActiveCollectionEvent != file.wasCollectionEventActive || haveActiveThemedShopEvent != file.wasThemedShopEventActive || GetMenuNumTabs( file.panel ) == 0 )
		{
			ClearTabs( file.panel )
			array<var> nestedPanels = GetAllMenuPanelsSorted( file.panel )
			foreach ( nestedPanel in nestedPanels )
			{


					if ( Hud_GetHudName( nestedPanel ) == "RTKEventsPanel" && (!haveActiveEventShop && !haveActiveBaseEvent && !haveActiveCollectionEvent) )
						continue








				switch ( Hud_GetHudName( nestedPanel ) )
				{
					case "ThemedShopPanel":
					case "CollectionEventPanel":
					case "RTKEventsPanel":
						break
				}

				AddTab( file.panel, nestedPanel, GetPanelTabTitle( nestedPanel ) )
			}

			file.wasCollectionEventActive = haveActiveCollectionEvent
			file.wasThemedShopEventActive = haveActiveThemedShopEvent
			file.wasEventShopActive = haveActiveEventShop

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
			bool enableTab = false

			tabDef.title = GetPanelTabTitle( tabDef.panel )

			if ( Hud_GetHudName( tabDef.panel ) == "CollectionEventPanel" )
			{

					showTab = false 




				enableTab = haveActiveCollectionEvent
				if ( haveActiveCollectionEvent )
				{
					expect ItemFlavor(activeCollectionEvent)

					tabDef.title = "#MENU_STORE_PANEL_COLLECTION" 
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "ThemedShopPanel" )
			{
				showTab = haveActiveThemedShopEvent
				enableTab = haveActiveThemedShopEvent
				if ( haveActiveThemedShopEvent )
				{
					tabDef.title = "#EVENT_EXCLUSIVE_OFFERS"
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "RTKEventsPanel" )
			{

					showTab = haveActiveEventShop || haveActiveBaseEvent || haveActiveCollectionEvent




				if ( haveActiveBaseEvent )
				{
					enableTab = true
					tabDef.title = "#EVENT_TAB_TITLE"

						if ( !haveActiveThemedShopEvent )
						{
							SetTabBaseWidth( tabDef, 325 )
							SetTabNavigationEnabled( file.panel, false )
						}







				}
				else if ( haveActiveEventShop )
				{
					enableTab = true
					tabDef.title = "#EVENTS_EVENT_SHOP"
				}


				else if ( haveActiveCollectionEvent )
				{
					expect ItemFlavor(activeCollectionEvent)

					tabDef.title = "#MENU_STORE_PANEL_COLLECTION" 
				}


				if ( !MilestoneEvent_IsPlaylistVarEnabled() )
				{
					showTab = false
					enableTab = false
				}
			}

			hasSubTab = hasSubTab || showTab
			SetTabDefVisible( tabDef, showTab )
			SetTabDefEnabled( tabDef, enableTab )
		}

		int activeIndex = tabData.activeTabIdx

		file.lastMenuNavDirectionTopLevel = GetLastMenuNavDirection()

		
		
		bool isEventPanelReverseNav        = GetCurrentPlaylistVarBool( "event_panel_reverse_nav", true )
		bool isEventPanelFirstOpenBehavior = GetCurrentPlaylistVarBool( "event_panel_first_open_behavior", true )

		if ( ( isEventPanelReverseNav || ( file.isFirstSessionOpen && isEventPanelFirstOpenBehavior ) ) )
		{
			if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
				activeIndex = 0

			while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex > numTabs )
				activeIndex++
		}
		else
		{
			if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
				activeIndex = numTabs - 1

			while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex < numTabs )
				activeIndex--
		}
		file.isFirstSessionOpen = false

		bool wasPanelActive = IsTabActive( tabData )
		if ( !wasPanelActive && file.isOpened  )
			ActivateTab( tabData, activeIndex )

		UpdateEventTabVisibility( hasSubTab )
	}

}


bool function EventPanel_GetLastMenuNavDirectionTopLevel()
{
	return file.lastMenuNavDirectionTopLevel
}

void function JumpToEventTab( string activateSubPanel = "" )
{
	EventsPanel_SaveDeepLink( activateSubPanel )

	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "EventPanel" ) )

	if ( activateSubPanel == "" )
		return

	TabData tabData = GetTabDataForPanel( file.panel )
	int tabIndex = Tab_GetTabIndexByBodyName( tabData, activateSubPanel )
	if ( tabIndex == -1 )
	{
		Warning( "JumpToEventTab() is ignoring unknown subpanel \"" + activateSubPanel + "\"" )
		return
	}

	ActivateTab( tabData, tabIndex )
}
