global function InitCardPosesPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      cardPoseList
} file


void function InitCardPosesPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "PoseList" )

	SetPanelTabTitle( panel, "#POSE" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardPosesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardPosesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardPosesPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	
	
	
	
}


void function CardPosesPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CardPosesPanel_Update )
	CardPosesPanel_Update( panel )
}


void function CardPosesPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CardPosesPanel_Update )
	CardPosesPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function CardPosesPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	
	foreach ( int flavIdx, ItemFlavor unused in file.cardPoseList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardPoseList.clear()

	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.STANCE, -1, null )

	
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_GladiatorCardStance( GetTopLevelCustomizeContext() )
		file.cardPoseList = GetLoadoutItemsSortedForMenu( [entry], GladiatorCardStance_GetSortOrdinal, null, [] )

		Hud_InitGridButtons( file.listPanel, file.cardPoseList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.cardPoseList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCardPose, CanEquipCanBuyCharacterItemCheck )
		}
	}
}


void function CardPosesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCardPose( ItemFlavor flav )
{
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.STANCE, 0, flav )
}


