global function InitCupInfoDialog
global function UI_OpenCupInfoDialog
global function UI_CloseCupInfoDialog

const string SFX_MENU_OPENED = "UI_Menu_Focus_Large"

struct
{
	var menu
	var contentElm
} file

void function InitCupInfoDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetPopup( menu, true )
	file.contentElm = Hud_GetChild( menu, "DialogContent" )

	{
		TabDef pointsTabDef = AddTab( menu, Hud_GetChild( menu, "RTKCupInfoPoints" ), "Points" )
		SetTabBaseWidth( pointsTabDef, 150 )

		TabDef tiersTabDef = AddTab( menu, Hud_GetChild( menu, "RTKCupInfoTiers" ), "Tiers" )
		SetTabBaseWidth( tiersTabDef, 150 )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CupInfoDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CupInfoDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CupInfoDialog_OnClose )
}

void function CupInfoDialog_OnClose()
{
	UI_CloseCupInfoDialog()
}

void function CupInfoDialog_OnOpen()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	SetTabDefsToSeasonal( tabData )
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )
	ActivateTab( tabData, 0 )

	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
	ItemFlavor cupItemFlav = cupData.containerItemFlavor
	RuiSetString( Hud_GetRui( file.contentElm ), "messageText", Localize( ItemFlavor_GetLongName( cupItemFlav ) ) )

	EmitUISound( SFX_MENU_OPENED )
}

void function UI_OpenCupInfoDialog()
{
	if ( !IsFullyConnected() )
		return

	AdvanceMenu( GetMenu( "RTKCupInfoDialog" ) )
}

void function UI_CloseCupInfoDialog()
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
		}
	}
}
