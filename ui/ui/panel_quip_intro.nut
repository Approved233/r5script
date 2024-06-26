global function InitIntroQuipsPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      quipList

	string lastSoundPlayed
} file


void function InitIntroQuipsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "QuipList" )

	SetPanelTabTitle( panel, "#INTRO_QUIP" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, IntroQuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, IntroQuipsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, IntroQuipsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	
	
	
	
}


void function IntroQuipsPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, IntroQuipsPanel_Update )
	IntroQuipsPanel_Update( panel )
}


void function IntroQuipsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, IntroQuipsPanel_Update )
	IntroQuipsPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function IntroQuipsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	
	foreach ( int flavIdx, ItemFlavor unused in file.quipList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.quipList.clear()

	StopLastPlayedQuip()

	
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_CharacterIntroQuip( GetTopLevelCustomizeContext() )
		file.quipList = GetLoadoutItemsSortedForMenu( [entry], CharacterIntroQuip_GetSortOrdinal, null, [] )

		Hud_InitGridButtons( file.listPanel, file.quipList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewQuip, CanEquipCanBuyCharacterItemCheck )
		}
	}
}


void function IntroQuipsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewQuip( ItemFlavor flav )
{
	printt( string(ItemFlavor_GetAsset( flav )) )

	StopLastPlayedQuip()

	string quipAlias = CharacterIntroQuip_GetVoiceSoundEvent( flav )
	if ( quipAlias != "" )
	{
		EmitUISound( quipAlias )
		file.lastSoundPlayed = quipAlias
	}
}


void function StopLastPlayedQuip()
{
	if ( file.lastSoundPlayed != "" )
		StopUISoundByName( file.lastSoundPlayed )
}


