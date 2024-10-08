global function InitSelectSlotDefaultPanel

const int MAX_PURCHASE_BUTTONS = 8

enum eDisplayStyle
{
	DEFAULT,
	BADGE_OR_STICKER,
	QUIP
}

struct
{
	var        panel
	array<var> buttonList
	var        displayItem
	var        swapIcon
	int        displayStyle = eDisplayStyle.DEFAULT
	bool 	   allowEquipAllLegends = false
	int		   equipAllSlotIndex = -1

} file

void function InitSelectSlotDefaultPanel( var panel )
{
	file.panel = panel

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( panel, "PurchaseButton" + purchaseButtonIdx )

		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, PurchaseButton_EquipAll )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, PurchaseButton_OnFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, PurchaseButton_LoseFocus )

		file.buttonList.append( button )
	}

	Hud_AddEventHandler( Hud_GetChild( panel, "DarkenBackground" ), UIE_CLICK, SelectSlot_CancelButton_Activate )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SelectSlotDefault_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SelectSlotDefault_OnHide )

	file.displayItem = Hud_GetChild( panel, "DisplayItem" )
	file.swapIcon = Hud_GetChild( panel, "SwapIcon" )
	RuiSetImage( Hud_GetRui( file.swapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )
}

void function PurchaseButton_Activate( var button )
{
	int index = int(Hud_GetScriptID( button ))
	SelectSlot_GetEquipFunc()( index )
	CloseActiveMenu()
}

void function PurchaseButton_EquipAll( var button )
{
	if ( file.allowEquipAllLegends == false )
		return

	if ( button == null ) 
	{
		Assert( IsControllerModeActive() )
		button = GetFocus()
	}

	file.equipAllSlotIndex = int(Hud_GetScriptID( button ))

	DialogData dialogData
	dialogData.header = Localize( "#EQUIP_ALL_CONFIRM_HEADER" )
	dialogData.message = Localize( "#EQUIP_ALL_CONFIRM_DESC" )
	dialogData.darkenBackground = true
	dialogData.useFullMessageHeight = true

	AddDialogButton( dialogData, "#PROMPT_CONFIRM", EquipAllConfirm )
	AddDialogButton( dialogData, "#B_BUTTON_BACK" )

	OpenDialog( dialogData )
}

void function EquipAllConfirm()
{
	Assert( file.equipAllSlotIndex >= 0 && file.equipAllSlotIndex < NUM_TRACKER_LOADOUT_SLOTS )

	array<LoadoutEntry> loadoutEntries = SelectSlot_GetLoadoutEntries()
	RequestSetItemFlavorLoadoutSlot_AllLegends( LocalClientEHI(), loadoutEntries[ file.equipAllSlotIndex ], SelectSlot_GetItem() )
	CloseActiveMenu()
	file.equipAllSlotIndex = -1
}

void function SelectSlotDefault_OnShow( var panel )
{
	SelectSlot_Common_AdjustButtons( panel, file.buttonList, file.displayItem, file.swapIcon )

	array<LoadoutEntry> loadoutEntries = SelectSlot_GetLoadoutEntries()
	file.displayStyle = eDisplayStyle.DEFAULT

	if ( loadoutEntries.len() > 0 )
	{
		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[0] )
		int itemType = ItemFlavor_GetType( flavor )

		if ( itemType == eItemType.gladiator_card_badge || itemType == eItemType.sticker )
			file.displayStyle = eDisplayStyle.BADGE_OR_STICKER
		else if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
			file.displayStyle = eDisplayStyle.QUIP

		file.allowEquipAllLegends = ( itemType == eItemType.gladiator_card_stat_tracker && GetTrackerUIContext() == eTrackerType.ART )
	}

	foreach ( button in file.buttonList )
	{
		int buttonHeight = Hud_GetBaseHeight( button )
		if ( file.displayStyle == eDisplayStyle.QUIP )
			buttonHeight = int( buttonHeight * 0.7 )
		Hud_SetHeight( button, buttonHeight )

		int buttonWidth = Hud_GetBaseWidth( button )
		if ( file.displayStyle == eDisplayStyle.BADGE_OR_STICKER )
			buttonWidth = buttonHeight
		Hud_SetWidth( button, buttonWidth )
	}

	if ( file.displayStyle == eDisplayStyle.BADGE_OR_STICKER )
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
		Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
	}
	else
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseWidth( file.displayItem ) )

		if ( file.displayStyle == eDisplayStyle.QUIP )
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 0.7 )
		else
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) )
	}

	for ( int i = 0; i < file.buttonList.len(); i++ )
	{
		var button = file.buttonList[i]
		UpdateFocusButton( button )
	}

	RuiDestroyNestedIfAlive( Hud_GetRui( file.displayItem ), "badgeUIHandle" )

	ApplyItemToButton( file.displayItem, SelectSlot_GetItem() )

	HudElem_SetRuiArg( file.displayItem, "bgVisible", file.displayStyle != eDisplayStyle.BADGE_OR_STICKER )

	ClearPanelFooterOptions( panel )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP" )
	if ( file.allowEquipAllLegends )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_EQUIP_ALL_LEGENDS", "#Y_BUTTON_EQUIP_ALL_LEGENDS", PurchaseButton_EquipAll )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, false, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	UpdateFooterOptions()
}

void function SelectSlotDefault_OnHide( var panel )
{

}

void function PurchaseButton_OnFocus( var button )
{
	int index = int( Hud_GetScriptID( button ) )

	array< LoadoutEntry > loadoutEntries = SelectSlot_GetLoadoutEntries()

	if ( index >= loadoutEntries.len() )
		return

	ApplyItemToButton( button, SelectSlot_GetItem() )

	ItemFlavor itemInButton = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[ index ] )

	for ( int i = 0; i < loadoutEntries.len(); i++ )
	{
		var bt = file.buttonList[i]
		if ( bt == button )
			continue

		ItemFlavor flav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[i] )
		if ( flav == SelectSlot_GetItem() )
		{
			ApplyItemToButton( bt, itemInButton )
		}
	}
}

void function PurchaseButton_LoseFocus( var button )
{
	foreach ( bt in file.buttonList )
	{
		UpdateFocusButton( bt )
	}
}

void function UpdateFocusButton( var button )
{
	int index = int( Hud_GetScriptID( button ) )

	array<LoadoutEntry> loadoutEntries = SelectSlot_GetLoadoutEntries()

	if ( index < loadoutEntries.len() )
	{
		Hud_Show( button )

		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[index] )

		ApplyItemToButton( button, flavor )
	}
	else
	{
		Hud_Hide( button )
	}
}

void function ApplyItemToButton( var button, ItemFlavor item )
{
	int itemType = ItemFlavor_GetType( item )
	var rui      = Hud_GetRui( button )

	RuiDestroyNestedIfAlive( rui, "badgeUIHandle" )

	if ( file.displayStyle == eDisplayStyle.BADGE_OR_STICKER )
	{
		if ( itemType == eItemType.gladiator_card_badge )
		{
			int index = int( Hud_GetScriptID( button ) )
			ItemFlavor character = expect ItemFlavor( SelectSlot_GetCharacter() )

			RuiSetString( rui, "buttonText", "" )
			RuiSetAsset( rui, "buttonImage", $"" )
			CreateNestedGladiatorCardBadge( rui, "badgeUIHandle", LocalClientEHI(), item, index, character )
		}
		else
		{
			Assert( itemType == eItemType.sticker )

			RuiSetString( rui, "buttonText", "" )
			RuiSetAsset( rui, "buttonImage", $"" )
			CreateNestedRuiForSticker( rui, "badgeUIHandle", item )
		}
	}
	else
	{
		string name = ItemFlavor_GetShortName( item )
		if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip || name == "" )
			name = ItemFlavor_GetLongName( item )

		RuiSetString( rui, "buttonText", name )
		RuiSetAsset( rui, "buttonImage", $"" )

		if ( itemType == eItemType.gladiator_card_stat_tracker && GetTrackerUIContext() == eTrackerType.ART )
		{
			RuiSetAsset( rui, "buttonImage", GladiatorCardStatTracker_GetBackgroundImage( item ) )
			string trackerName = Localize( ItemFlavor_GetLongName( item ) )
			RuiSetString( rui, "buttonText", trackerName )
		}
	}
}