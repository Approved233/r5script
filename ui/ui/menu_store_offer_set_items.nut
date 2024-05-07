global function InitStoreOfferSetItemsMenu
global function InitStoreOfferSetItemsPanel

struct
{
	var menu
	var panel
	bool tabsInitialized
} file





void function InitStoreOfferSetItemsMenu( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetTabRightSound( menu, "UI_Menu_LegendTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_LegendTab_Select" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, StoreOfferSetItems_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, StoreOfferSetItems_OnNavigateBack )
}

void function StoreOfferSetItems_OnOpen()
{
	if ( !file.tabsInitialized )
	{
		var panel = Hud_GetChild( file.menu, "StoreOfferSetItemsPanel" )

		TabDef tab = AddTab( file.menu, panel, Localize( "#MENU_STORE_PANEL_ITEMS" ) )
		tab.isBannerLogoSmall = true
		SetTabBaseWidth( tab, 300 )

		file.tabsInitialized = true
	}

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		
		RTKStore_SetStartingSection( "", 0, STORE_SET_ITEM_SHOP )

		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		tabData.bannerTitle = Localize( "#ARTIFACT_SET" ).toupper()
		tabData.bannerLogoScale = 0.7
		tabData.callToActionWidth = 300
		tabData.initialFirstTabButtonXPos = GetNearestAspectRatio( GetScreenSize().width, GetScreenSize().height ) <= 2.0 ? 80: 0
		SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.CAPSTONE )

		SetTabDefsToSeasonal(tabData)
		ActivateTab( tabData, 0 )
	}
}

void function StoreOfferSetItems_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	CloseActiveMenu()
}






void function InitStoreOfferSetItemsPanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, StoreOfferSetItems_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, StoreOfferSetItems_OnHide )

	StoreOfferSetItems_SetupFooterButtons( panel )
}

void function StoreOfferSetItems_OnShow( var panel )
{
	var parentPanel = Hud_GetParent( file.panel )
	var mmStatus    = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", true )
}

void function StoreOfferSetItems_OnHide( var panel )
{
	var parentPanel = Hud_GetParent( file.panel )
	var mmStatus = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", false )
}

void function StoreOfferSetItems_SetupFooterButtons( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


