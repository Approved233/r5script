global function InitStoreOnlyMilestoneEventsMenu
global function InitStoreOnlyMilestoneEventsPanel
global function JumpToStoreMilestoneEventsMenu
global function StoreMilestoneMenu_AddOnTabChangedCallback
global function StoreMilestoneEvents_SendPageViewMilestoneOffer
global function StoreMilestoneEvents_SendPageViewInfoPage
global function StoreMilestoneEvents_SendPageViewPurchaseDialog

struct
{
	var menu
	var panel
	bool tabsInitialized

	table<int, string> tabIndexToEventId
	string desiredEventIdToOpen = "" 

	array<void functionref( string )> tabChangedCallbacks

	InputDef& secondFooter
	InputDef& thirdFooter
} file

struct
{
	string pageName
	string prevPage

	int prevPageTimestamp
	int prevPageDuration
	int pageNum
	string eventName
	string linkName
	string clickType

} fileTelemetry





void function InitStoreOnlyMilestoneEventsMenu( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	
	fileTelemetry.clickType = NAV_TYPE_CLICK
	fileTelemetry.linkName = ""

	SetTabRightSound( menu, "UI_Menu_LegendTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_LegendTab_Select" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, StoreMilestoneEvents_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, StoreMilestoneEvents_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, StoreMilestoneEvents_OnNavigateBack )
}

void function StoreMilestoneEvents_OnOpen()
{
	if ( !file.tabsInitialized )
	{
		array<ItemFlavor> activeStoreOnlyMilestoneEvents = GetActiveStoreOnlyMilestoneEvents( GetUnixTimestamp() )
		if ( activeStoreOnlyMilestoneEvents.len() > 0 )
		{
			var panel = Hud_GetChild( file.menu, "StoreOnlyMilestoneEventsPanel" )

			
			activeStoreOnlyMilestoneEvents.sort( int function( ItemFlavor eventA, ItemFlavor eventB ) {
				int eventAEndTime = CalEvent_GetFinishUnixTime( eventA )
				int eventBEndTime = CalEvent_GetFinishUnixTime( eventB )
				if ( eventAEndTime < eventBEndTime )
					return -1
				else if ( eventAEndTime > eventBEndTime )
					return 1

				return 0
			})

			
			int index = 0
			foreach ( activeStoreEvent in activeStoreOnlyMilestoneEvents )
			{
				{
					string eventName = ItemFlavor_GetLongName( activeStoreEvent )
					string eventId = MilestoneEvent_GetEventId( activeStoreEvent )
					TabDef tab = AddTab( file.menu, panel, eventName )
					tab.isBannerLogoSmall = true
					SetTabBaseWidth( tab, 300 )
					file.tabIndexToEventId[index] <- eventId
				}

				index++
			}
		}

		file.tabsInitialized = true
	}

	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		tabData.bannerTitle = Localize( "#MILESTONE_STORE_TAB_TITLE" ).toupper()
		tabData.bannerLogoScale = 0.7
		tabData.callToActionWidth = 400
		tabData.initialFirstTabButtonXPos = GetNearestAspectRatio( GetScreenSize().width, GetScreenSize().height ) <= 2.0? 80: 0
		SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.CAPSTONE )

		SetTabDefsToSeasonal(tabData)

		if ( file.desiredEventIdToOpen != "" )
		{
			GoToTabByEventId( file.desiredEventIdToOpen )
			file.desiredEventIdToOpen = ""
		}
		else
			ActivateTab( tabData, 0 )
	}

	AddCallback_OnTabChanged( StoreMilestoneMenu_OnTabChanged )
}

void function StoreMilestoneEvents_OnClose()
{
	file.tabChangedCallbacks.clear()
}

void function StoreMilestoneEvents_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	CloseActiveMenu()
}

void function JumpToStoreMilestoneEventsMenu( string eventToFocus = "", string fromPageId = "", bool isDeeplink = false )
{
	if ( !IsFullyConnected() )
		return

	if ( GetActiveMenu() == file.menu )
		return

	
	if ( isDeeplink )
	{
		fileTelemetry.clickType = NAV_TYPE_DEEPLINK
		StoreMilestoneEvents_SaveDeepLink( eventToFocus )
	}

	if ( fromPageId != "" )
		fileTelemetry.pageName = fromPageId

	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	AdvanceMenu( GetMenu( "StoreOnlyMilestoneEventsMenu" ) )

	if ( eventToFocus != "" )
	{
		if ( file.tabsInitialized )
		{
			GoToTabByEventId( eventToFocus )
		}
		else
		{
			file.desiredEventIdToOpen = eventToFocus
		}
	}
}

void function GoToTabByEventId( string eventToFocus = "" )
{
	TabData tabData = GetTabDataForPanel( file.menu )
	foreach ( index, eventId in file.tabIndexToEventId )
	{
		if ( eventId == eventToFocus )
		{
			ActivateTab( tabData, index )
			RTKMilestoneEventPanelController_SetInitialEventPage( eventToFocus )
			return
		}
	}
}


void function StoreMilestoneMenu_OnTabChanged()
{
	if ( GetActiveMenu() != file.menu )
		return

	TabData tabData = GetTabDataForPanel( file.menu )
	if ( file.tabIndexToEventId.len() > tabData.activeTabIdx )
	{
		string eventId = file.tabIndexToEventId[tabData.activeTabIdx]
		foreach ( void functionref( string eventId ) func in file.tabChangedCallbacks )
		{
			if ( IsValid( func ) )
			{
				func( eventId );
			}
		}

		StoreMilestoneEvents_SendPageViewEvent()

		
		fileTelemetry.clickType = NAV_TYPE_CLICK
		fileTelemetry.linkName = ""
	}
}

void function StoreMilestoneMenu_AddOnTabChangedCallback( void functionref( string ) func )
{
	file.tabChangedCallbacks.append( func )
}






void function InitStoreOnlyMilestoneEventsPanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, StoreMilestoneEvents_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, StoreMilestoneEvents_OnHide )

	StoreMilestoneEvents_SetupFooterButtons( panel )
}

void function StoreMilestoneEvents_OnShow( var panel )
{
	var parentPanel = Hud_GetParent( file.panel )
	var mmStatus    = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", true )

	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )

	RegisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )
	RegisterButtonPressedCallback( KEY_H, OpenCollectionEventAboutPageWithMilestoneStoreTelemetry )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )

	
	ToolTipData ttd
	ttd.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
	ttd.actionHint1 = "#A_BUTTON_VIEW_WALLET"
	Hud_SetToolTipData( Hud_GetChild( file.menu, "UserInfo" ), ttd )
}

void function StoreMilestoneEvents_OnHide( var panel )
{
	var parentPanel = Hud_GetParent( file.panel )
	var mmStatus = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", false )

	DeregisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )
	DeregisterButtonPressedCallback( KEY_H, OpenCollectionEventAboutPageWithMilestoneStoreTelemetry )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )
}

void function StoreMilestoneEvents_SetupFooterButtons( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

#if PC_PROG_NX_UI
		file.secondFooter = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_MILESTONE_BUTTON_MILESTONE_INFO", "#MILESTONE_BUTTON_MILESTONE_INFO", OpenCollectionEventAboutPageWithMilestoneStoreTelemetry )
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUpWithMilestoneStoreTelemetry )
#else
		file.secondFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_MILESTONE_BUTTON_MILESTONE_INFO", "#MILESTONE_BUTTON_MILESTONE_INFO", OpenCollectionEventAboutPageWithMilestoneStoreTelemetry )
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUpWithMilestoneStoreTelemetry )
#endif
}





void function StoreMilestoneEvents_SaveDeepLink( string link )
{
	fileTelemetry.linkName = link
}

void function StoreMilestoneEvents_SaveTelemetryData()
{
	if ( GetActiveMenu() != file.menu )
		return

	
	string eventName = ""
	TabData tabData = GetTabDataForPanel( file.menu )
	if ( file.tabIndexToEventId.len() > tabData.activeTabIdx )
	{
		string eventId = file.tabIndexToEventId[tabData.activeTabIdx]
		ItemFlavor ornull event = MilestoneEvent_GetEventById( eventId )
		if ( event != null )
		{
			expect ItemFlavor( event )
			eventName = ItemFlavor_GetLongName( event )
			fileTelemetry.eventName = eventName
		}
	}

	fileTelemetry.prevPage = fileTelemetry.pageName
	fileTelemetry.pageName = "milestonestoretab" + tabData.activeTabIdx + "_" + eventName
	fileTelemetry.prevPageDuration = int( UITime() ) - fileTelemetry.prevPageTimestamp
	fileTelemetry.prevPageTimestamp = int ( UITime() )
	fileTelemetry.pageNum = tabData.activeTabIdx
}

void function StoreMilestoneEvents_SendPageViewEvent()
{
	StoreMilestoneEvents_SaveTelemetryData()
	PIN_PageView_StoreMilestone( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.pageNum, fileTelemetry.linkName, fileTelemetry.clickType, fileTelemetry.eventName )
}

void function StoreMilestoneEvents_SendPageViewMilestoneOffer( int buttonIndex, string offerName, bool isReward = false )
{
	StoreMilestoneEvents_SaveTelemetryData()
	PIN_PageView_StoreMilestoneOffer( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		buttonIndex, fileTelemetry.linkName, fileTelemetry.clickType, fileTelemetry.eventName, offerName, isReward )
}

void function StoreMilestoneEvents_SendPageViewInfoPage( string infoPageName )
{
	StoreMilestoneEvents_SaveTelemetryData()
	PIN_PageView_StoreMilestoneInfoPage( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.pageNum, infoPageName, fileTelemetry.clickType, fileTelemetry.eventName )
}

void function StoreMilestoneEvents_SendPageViewPurchaseDialog( bool asGift )
{
	StoreMilestoneEvents_SaveTelemetryData()
	PIN_PageView_StoreMilestoneViewPurchasePanel( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.pageNum, fileTelemetry.clickType, fileTelemetry.eventName, asGift )
}