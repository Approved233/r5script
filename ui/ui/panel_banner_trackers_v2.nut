global function InitCardTrackersPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      cardTrackerList
} file


void function InitCardTrackersPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "TrackerList" )

	SetPanelTabTitle( panel, "#TRACKERS" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardTrackersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardTrackersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardTrackersPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	
	
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	
	
	
	
}


void function CardTrackersPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
}


void function CardTrackersPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	if ( file.cardTrackerList.len() > 0 )
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function CardTrackersPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	
	foreach ( int flavIdx, ItemFlavor unused in file.cardTrackerList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardTrackerList.clear()

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, trackerIndex, null )

	
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i=0; i<GLADIATOR_CARDS_NUM_BADGES; i++ )
		{
			entry   = Loadout_GladiatorCardStatTracker( character, i )
			entries.append( entry )
		}

		file.cardTrackerList = GetLoadoutItemsSortedForMenu( entries, GladiatorCardStatTracker_GetSortOrdinal, GladiatorCardTracker_IsTheEmpty, [] )

		Hud_InitGridButtons( file.listPanel, file.cardTrackerList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.cardTrackerList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewCardTracker, CanEquipCanBuyCharacterItemCheck, true )

			var rui = Hud_GetRui( button )
			RuiSetString( rui, "trackerValue", GladiatorCardStatTracker_GetFormattedValueText( GetLocalClientPlayer(), character, flav ) )
		}
	}
}


void function CardTrackersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCardTracker( ItemFlavor flav )
{
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, GetCardPropertyIndex(), flav )
}