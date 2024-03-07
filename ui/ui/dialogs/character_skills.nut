global function InitCharacterSkillsDialog
global function OpenCharacterSkillsDialog


global function OpenCharacterUpgradesDialog


global function ClientToUI_OpenCharacterSkillsDialog

struct
{

	bool showUpgradeTree

	var         menu
	ItemFlavor& character
} file

void function InitCharacterSkillsDialog( var newMenuArg )

{
	var menu = GetMenu( "CharacterSkillsDialog" )
	file.menu = menu

	SetDialog( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CharacterSkillsDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CharacterSkillsDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CharacterSkillsDialog_OnNavigateBack )

	HudElem_SetChildRuiArg( menu, "BG", "basicImage", $"rui/menu/character_skills/background_notchless", eRuiArgType.IMAGE )

}

void function OpenCharacterSkillsDialog( ItemFlavor character )
{
	file.character = character
	AdvanceMenu( file.menu )
}


void function OpenCharacterUpgradesDialog( ItemFlavor character )
{
	OpenCharacterSkillsDialog( character )
	RTKLegendUpgradeTree_SetCharacter( character )
	RTKLegendUpgradeTree_IsInteractable( false )
	RTKLegendUpgradeTree_SetTitleVisibility( true )
	RTKLegendUpgradeTree_SetDescriptionVisibility( true )

	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, "LegendUpgradesPanel" ) )
}


void function ClientToUI_OpenCharacterSkillsDialog( int characterGUID )
{
	if ( !IsValidItemFlavorGUID( characterGUID ) )
		return
	GetItemFlavorByGUID( characterGUID )
	ItemFlavor character = GetItemFlavorByGUID( characterGUID )

	file.character = character

	AdvanceMenu( file.menu )
}

void function CharacterSkillsDialog_OnOpen()
{
	AddTabsToSkillsMenu()

	SetCharacterSkillsPanelLegend( file.character )

	RTKLegendUpgradeTree_SetCharacter( file.character )
	RTKLegendUpgradeTree_IsInteractable( false )
	RTKLegendUpgradeTree_SetTitleVisibility( true )
	RTKLegendUpgradeTree_SetDescriptionVisibility( true )

	TabData tabData = GetTabDataForPanel( file.menu )

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		ActivateTab( tabData, 0 )
	}

	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "BG" ), false )
}


void function CharacterSkillsDialog_OnClose()
{

	RTKLegendUpgradeTree_SetTitleVisibility( false )
	RTKLegendUpgradeTree_SetDescriptionVisibility( false )

}


void function CharacterSkillsDialog_OnNavigateBack()
{

	RTKLegendUpgradeTree_SetTitleVisibility( false )
	RTKLegendUpgradeTree_SetDescriptionVisibility( false )

	CloseActiveMenu()
}

void function AddTabsToSkillsMenu()
{
	var menu = file.menu


	bool showUpgradeTree = UpgradeCore_ShowUpgradeTree_SkillsMenu()
	if ( GetMenuNumTabs( menu ) > 0 && showUpgradeTree == file.showUpgradeTree )
		return

	file.showUpgradeTree = showUpgradeTree


	ClearTabs( menu )

	{
		TabDef tabDef = AddTab( menu, Hud_GetChild( menu, "CharacterAbilitiesPanel" ), "#ABILITIES" )
		SetTabBaseWidth( tabDef,  220 )
	}

	if ( showUpgradeTree )
	{
		TabDef tabDef = AddTab( menu, Hud_GetChild( menu, "LegendUpgradesPanel" ), "#UPGRADES" )
		SetTabBaseWidth( tabDef,  260 )
	}

	{
		TabDef tabDef = AddTab( menu, Hud_GetChild( menu, "CharacterRolesPanel" ), "#ALL_CLASSES" )
		SetTabBaseWidth( tabDef,  260 )
	}

	TabData tabData = GetTabDataForPanel( file.menu )

	tabData.centerTabs = true
	tabData.initialFirstTabButtonXPos = 20
	SetTabDefsToSeasonal(tabData)
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )
}