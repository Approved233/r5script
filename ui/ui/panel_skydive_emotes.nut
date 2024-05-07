global function InitSkydiveEmotesPanel
global function HasEquippableSkydiveEmotes

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      skydiveEmoteList

	var   videoRui
	int   videoChannel = -1
	asset currentVideo = $""
} file


void function InitSkydiveEmotesPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "SkydiveEmotesList" )
	file.videoRui = Hud_GetRui( Hud_GetChild( panel, "Video" ) )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SkydiveEmotesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SkydiveEmotesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, SkydiveEmotesPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )

	file.videoChannel = ReserveVideoChannel()
	RuiSetInt( file.videoRui, "channel", file.videoChannel )
}


void function SkydiveEmotesPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_CARD )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, SkydiveEmotesPanel_Update )
	SkydiveEmotesPanel_Update( panel )

	CharacterEmotesPanel_SetHintSub( "", true )
}


void function SkydiveEmotesPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, SkydiveEmotesPanel_Update )
	SkydiveEmotesPanel_Update( panel )

	if ( file.skydiveEmoteList.len() > 0 )
	{
		var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )

		foreach ( int flavIdx, ItemFlavor unused in file.skydiveEmoteList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			Hud_ClearToolTipData( button )
		}
	}

	Hud_ClearAllToolTips()
}


void function SkydiveEmotesPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	
	foreach ( int flavIdx, ItemFlavor unused in file.skydiveEmoteList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.skydiveEmoteList.clear()

	StopVideoOnChannel( file.videoChannel )
	file.currentVideo = $""

	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		LoadoutEntry entry
		array<LoadoutEntry> entries
		for ( int i = 0; i < NUM_SKYDIVE_EMOTE_SLOTS; i++ )
		{
			entry = Loadout_SkydiveEmote( character, i )
			entries.append( entry )
		}

		file.skydiveEmoteList = clone GetLoadoutItemsSortedForMenu( entries, null, SkydiveEmote_IsTheEmpty, [] )

		Hud_InitGridButtons( file.listPanel, file.skydiveEmoteList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.skydiveEmoteList )
		{

			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewSkydiveEmote, CanEquipCanBuyCharacterItemCheck, false, null, null, [], SkydiveEmote_OnMiddleClick )

			Hud_ClearToolTipData( button )

			var rui = Hud_GetRui( button )
			RuiDestroyNestedIfAlive( rui, "badge" )
			RuiSetBool( rui, "displayQuality", true )

			var nestedRui = CreateNestedRuiForSkydiveEmote( rui, "badge", flav )

			ToolTipData toolTipData
			toolTipData.titleText = Localize( ItemFlavor_GetLongName( flav ) )
			toolTipData.descText = Localize( ItemFlavor_GetTypeName( flav ) )
			toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
			Hud_SetToolTipData( button, toolTipData )
		}

		Hud_ScrollToTop( file.listPanel )
		file.currentVideo = $""
	}
}

void function SkydiveEmote_OnMiddleClick( var button )
{

}

void function SkydiveEmotesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return

	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewSkydiveEmote( ItemFlavor flav )
{
	asset desiredVideo = SkydiveEmote_GetVideo( flav )

	if ( file.currentVideo != desiredVideo ) 
	{
		file.currentVideo = desiredVideo
		StartVideoOnChannel( file.videoChannel, desiredVideo, true, 0.0 )
	}
}


bool function HasEquippableSkydiveEmotes()
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	array<LoadoutEntry> entries
	for ( int i = 0; i < NUM_SKYDIVE_EMOTE_SLOTS; i++ )
		entries.append( Loadout_SkydiveEmote( character, i ) )

	array<ItemFlavor> items = GetLoadoutItemsSortedForMenu( entries, null, SkydiveEmote_IsTheEmpty, [] )

	return items.len() > 0
}
