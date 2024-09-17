global function InitRTKApexCupMenu
global function RTKMutator_ApexCupGetTierText
global function RTKApexCupGetPlayerTierData
global function ApexCupMenu_JumpToMatchHistory

struct
{
	var menu = null
} file

global struct RTKApexCupTierInfo
{
	int currentPoints = -1
	int targetPoints = -1
	int positionPercentage = -1
	int tierIndex = -1
	int lowerBounds = -1
	bool isTop100 = false

	SettingsAssetGUID apexCup
}

global struct RTKPlayerDataModel
{
	array  <RTKSummaryBreakdownRowModel> summaryList
	string	playerName = ""
	string 	playerHardware = ""
	string  playerLegendName = ""
	string	playerPoints = ""
	asset	playerAssetPath

}

void function InitRTKApexCupMenu( var menu )
{
	file.menu = menu

	{
		TabDef overviewTabDef = AddTab( menu, Hud_GetChild( file.menu, "RTKApexCupsOverview" ), "#APEX_CUPS_OVERVIEW_TAB" )
		SetTabBaseWidth( overviewTabDef, 300 )

		TabDef leaderboardTabDef = AddTab( menu, Hud_GetChild( file.menu, "RTKApexCupsLeaderboard" ), "#GAMEMODE_APEX_CUPS_LEADERBOARD_TAB" )
		SetTabBaseWidth( leaderboardTabDef, 300 )

		TabDef historyTabDef = AddTab( menu, Hud_GetChild( file.menu, "RTKApexCupsHistory" ), "#GAMEMODE_APEX_CUPS_HISTORY_TAB" )
		SetTabBaseWidth( historyTabDef, 300 )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, InitRTKApexCupMenuScreen_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, ApexCupMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ApexCupMenu_NavBackToCups )
}

void function ApexCupMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}

void function InitRTKApexCupMenuScreen_Open()
{
	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "RTKApexCupsOverview" ), true )
	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "RTKApexCupsHistory" ), true )
	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "RTKApexCupsLeaderboard" ), true )

	TabData tabData = GetTabDataForPanel( file.menu )
	{
		bool showTab 	= GetConVarBool( "cups_has_match_history" )
		TabDef tabDef	= Tab_GetTabDefByBodyName( tabData, "RTKApexCupsHistory" )
		tabDef.visible = showTab
		tabDef.enabled = showTab
	}

	tabData.centerTabs = true
	tabData.forcePrimaryNav = true
	tabData.activeTabIdx = 0
	SetTabDefsToSeasonal( tabData )
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )
	ActivateTab( tabData, tabData.activeTabIdx )
}

void function RTKApexCupGetPlayerTierData( rtk_behavior self , SettingsAssetGUID cupId )
{
	RTKApexCupTierInfo tierInfo

	if (  Cups_GetSquadCupData( cupId ) )
	{
		CupEntry cupEntryData  = expect CupEntry ( Cups_GetSquadCupData( cupId ))
		tierInfo.currentPoints = cupEntryData.currSquadScore
		tierInfo.tierIndex     = Cups_GetPlayerTierIndexForCup( cupId )
		tierInfo.apexCup	   = cupId

		if( cupEntryData.tierScoreBounds.len() > 0 )
		{
			tierInfo.targetPoints  = cupEntryData.tierScoreBounds[ maxint( 0, tierInfo.tierIndex - 1 ) ]
		}

		tierInfo.lowerBounds   = tierInfo.tierIndex < cupEntryData.tierScoreBounds.len() ? cupEntryData.tierScoreBounds[tierInfo.tierIndex] : 0
		tierInfo.isTop100	   = tierInfo.tierIndex == 0

		
		if ( tierInfo.isTop100 )
			tierInfo.targetPoints = tierInfo.currentPoints

		
		if ( tierInfo.isTop100 )
		{
			tierInfo.positionPercentage = cupEntryData.currSquadPosition
		}
		else
		{
			tierInfo.positionPercentage = Cups_CalculatePositionPercentageDisplay( cupId, cupEntryData, tierInfo.tierIndex )
		}
	}

	rtk_struct tierModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "tierInfo", true, [ "apexCups" ] ) )
	RTKStruct_SetValue( tierModel, tierInfo )
}

string function RTKMutator_ApexCupGetTierText( int tier )
{
	string tierString = ""
	switch ( tier )
	{
		case 0:
			tierString = "#NUMERAL_1"
			break
		case 1:
			tierString = "#NUMERAL_2"
			break
		case 2:
			tierString = "#NUMERAL_3"
			break
		case 3:
			tierString = "#NUMERAL_4"
			break
		case 4:
			tierString = "#NUMERAL_5"
			break
		default:
			Warning( "RTKMutator_ApexCupGetTierText Invalid Tier" )
			tierString = ""
	}
	return tierString
}

void function ApexCupMenu_NavBackToCups()
{
	GamemodeSelect_JumpToCups( null )
}

void function ApexCupMenu_JumpToMatchHistory()
{
	if ( GetActiveMenu() != file.menu )
		return

	TabData tabData = GetTabDataForPanel( file.menu )
	int tabIdx = Tab_GetTabIndexByBodyName( tabData, "RTKApexCupsHistory" )
	if ( tabIdx == -1 )
		return

	ActivateTab( tabData, tabIdx )
}
