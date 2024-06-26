global function InitQuipsPanel
global function InitEmotesPanel
global function QuipPanel_SetItemTypeFilter
global function QuipsPanel_Update

struct
{
	table<var,var>              listPanel
	table<var,bool>             isBoxPanel
	array<ItemFlavor> 			quipList
	string 						lastSoundPlayed
	array<int>					filterTypes

	var 						blurbPanel = null
} file

void function InitEmotesPanel( var panel )
{
	___Init( panel )

	file.isBoxPanel[ panel ] <- true

	file.blurbPanel = Hud_GetChild( Hud_GetParent( panel ), "SkinBlurb" )
}

void function InitQuipsPanel( var panel )
{
	___Init( panel )

	file.isBoxPanel[ panel ] <- false
}

void function ___Init( var panel )
{
	file.listPanel[ panel ] <- Hud_GetChild( panel, "QuipList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, QuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, QuipsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, QuipsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )


	var gridPanel = file.listPanel[ panel ]
	void functionref( var ) func = (
			void function( var button ) : ( gridPanel )
			{
				SetOrClearFavoredQuipFromFocus( gridPanel )
			}
	)
#if PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemAbleToBeFavored )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemAlreadyFavored )
#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemAbleToBeFavored )
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemAlreadyFavored )
#endif
}


void function QuipsPanel_OnShow( var panel )
{
	if ( file.filterTypes.contains( eItemType.character_emote ) )
		UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )
	else
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
}


void function QuipsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
	RunClientScript( "ClearBattlePassItem" )

	if ( file.quipList.len() > 0 )
	{
		var scrollPanel = Hud_GetChild( file.listPanel[ panel ], "ScrollPanel" )
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )

		foreach ( int flavIdx, ItemFlavor unused in file.quipList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			Hud_ClearToolTipData( button )
		}
	}

	Hud_ClearAllToolTips()
}


void function QuipsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel[ panel ], "ScrollPanel" )

	Hud_SetVisible( file.blurbPanel, false )

	string hintSub = ""

	if ( file.filterTypes.contains( eItemType.character_emote ) )
	{
		UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )
		hintSub = "#HINT_SOCIAL_ANTI_PEEK"
	}
	else if ( file.filterTypes.contains( eItemType.emote_icon ) )
	{
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )
	}
	else
	{
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )
		hintSub = "#HINT_SOCIAL_QUIPS_ENEMIES"
	}
	CharacterEmotesPanel_SetHintSub( hintSub )

	
	foreach ( int flavIdx, ItemFlavor unused in file.quipList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.quipList.clear()

	StopLastPlayedQuip()

	
	if ( IsPanelActive( panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		LoadoutEntry entry
		array<LoadoutEntry> entries
		for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
		{
			entry = Loadout_CharacterQuip( character, i )
			entries.append( entry )
		}

		file.quipList = clone GetLoadoutItemsSortedForMenu( entries, null, CharacterQuip_IsTheEmpty, file.filterTypes )

		array<LoadoutEntry> auxEntries
		for ( int i = 0; i < MAX_FAVORED_QUIPS; i++ )
			auxEntries.append( Loadout_FavoredQuip( character, i ) )

		Hud_InitGridButtons( file.listPanel[ panel ], file.quipList.len() )

		bool emptyShown = false
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			int type = ItemFlavor_GetType( flav )
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewQuip, CanEquipCanBuyCharacterItemCheck, false, null, null, auxEntries, CustomizeButton_AddOrClearFavoredQuip )

			Hud_ClearToolTipData( button )
			if ( file.isBoxPanel[ panel ] )
			{
				var rui = Hud_GetRui( button )
				RuiDestroyNestedIfAlive( rui, "badge" )
				RuiSetBool( rui, "displayQuality", true )

				var nestedRui = CreateNestedRuiForQuip( rui, "badge", flav )

				if ( type == eItemType.gladiator_card_intro_quip || type == eItemType.gladiator_card_kill_quip )
				{
					RuiSetFloat( nestedRui, "fontSize", 28.0 )
					RuiSetFloat( nestedRui, "centerLineBreakWidth", 100.0 )
				}
				else
				{
					RuiSetBool( nestedRui, "showBackground", false )
				}

				ToolTipData toolTipData
				toolTipData.titleText = Localize( ItemFlavor_GetLongName( flav ) )
				toolTipData.descText = Localize( ItemFlavor_GetTypeName( flav ) )
				toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
				Hud_SetToolTipData( button, toolTipData )
			}
		}
		Hud_ScrollToTop( file.listPanel[ panel ] )
	}
}


void function QuipsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return

	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewQuip( ItemFlavor flav )
{
	StopLastPlayedQuip()

	if ( CharacterQuip_IsTheEmpty( flav ) )
		return

	int type = ItemFlavor_GetType( flav )
	string ref = "customize_character_skin_ref"
	bool showLow = false
	float scale = 1.0

	Hud_SetVisible( file.blurbPanel, false )

	switch ( type )
	{
		case eItemType.character_emote:
			showLow = true
			break

		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
			ref = "customize_character_emote_quip_ref"
			break

		case eItemType.emote_icon:
			ref = "customize_character_emotes_ref"
			scale = 0.6
			if ( HoloSpray_HasStoryBlurb( flav ) )
			{
				Hud_SetVisible( file.blurbPanel, true )
				int quality = 0
				if ( ItemFlavor_HasQuality( flav ) )
					quality = ItemFlavor_GetQuality( flav )

				var rui = Hud_GetRui( file.blurbPanel )
				RuiSetString( rui, "characterName", ItemFlavor_GetShortName( flav ) )
				RuiSetString( rui, "skinNameText", ItemFlavor_GetLongName( flav ) )
				RuiSetString( rui, "bodyText", HoloSpray_GetStoryBlurbBodyText( flav ) )
				RuiSetFloat3( rui, "characterColor", SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, quality + 1 ) / 255.0 ) )
				RuiSetGameTime( rui, "startTime", ClientTime() )
			}
			break
	}

	switch ( type )
	{
		case eItemType.character_emote:
			ItemFlavor ornull character = CharacterQuip_GetCharacterFlavor( flav )
			int chGUID = -1
			if ( character != null )
			{
				expect ItemFlavor( character )
				chGUID = ItemFlavor_GetGUID( character )
			}
			else
			{
				character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )
				expect ItemFlavor( character )
				chGUID = ItemFlavor_GetGUID( character )
			}
			RunClientScript( "UIToClient_PreviewCharacterEmote", ItemFlavor_GetGUID( flav ), chGUID )
			break

		default:
			bool isNxHH = false
#if PC_PROG_NX_UI
			isNxHH = IsNxHandheldMode()
#endif
			RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( flav ), -1, scale, showLow, null, false, ref, isNxHH )
			break
	}

	string subAlias = CharacterQuip_GetAliasSubName( flav )

	if ( subAlias != "" )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		asset playerSettings = CharacterClass_GetSetFile( character )
		string voice = GetGlobalSettingsString( playerSettings, "voice" )

		string quipAlias = "diag_mp_" + voice + "_" + subAlias + "_1p"
		if ( quipAlias != "" )
		{
			EmitUISound( quipAlias )
			file.lastSoundPlayed = quipAlias
		}
	}
}


void function StopLastPlayedQuip()
{
	if ( file.lastSoundPlayed != "" )
		StopUISoundByName( file.lastSoundPlayed )
}


void function QuipPanel_SetItemTypeFilter( array<int> filters )
{
	file.filterTypes = filters
}
