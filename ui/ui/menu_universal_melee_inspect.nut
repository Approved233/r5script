global function InitUniversalMeleeInspectMenu
global function UniversalMeleeInspectMenu_AttemptOpenWithOffer

struct
{
	var menu
	var inspectPanel
	var mouseCaptureElem
	var pageHeader
	var itemGrid
	var itemInfo
	var videoInfo
	bool isOwned
	bool isSelected
	bool isBaseWeapon
	bool isFullSet
	bool canAfford
	bool isHeirloomCurrency
	int initialIndex
	array< ItemFlavor > setItems
	GRXScriptOffer& offer
	ItemFlavorBag& price
	ItemFlavor& offerItem
	ItemFlavor ornull activeEvent
} file

global struct UniversalMeleeInspectUIData
{
	var currencyInfo
	var purchaseButton
	var disclaimerInfo
	var descriptionInfo
	var previousItemGrid
}

UniversalMeleeInspectUIData s_inspectUIData
const int ITEM_GRID_ROWS = 1
const int ITEM_GRID_COLUMNS = 3
const int MAX_NUMBER_ITEMS = 3
const int LINK_INDEX = 0
const int INITIAL_INDEX_SINGLE_ITEM = 0
const int INITIAL_INDEX_FULL_SET = 2
const int UNIVERSAL_MELEE_UPGRADE_INDEX = 1
const int UNIVERSAL_MELEE_DEATH_BOX_INDEX = 2

void function InitUniversalMeleeInspectMenu( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, UniversalMeleeInspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, UniversalMeleeInspectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, UniversalMeleeInspectMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, UniversalMeleeInspectMenu_OnHide )

	file.inspectPanel = Hud_GetChild( menu, "InspectPanel" )
	file.mouseCaptureElem = Hud_GetChild( menu, "ModelRotateMouseCapture" )
	file.pageHeader = Hud_GetChild( file.inspectPanel, "InspectHeader" )
	file.itemGrid = Hud_GetChild( file.inspectPanel, "ItemGridPanel" )
	file.itemInfo = Hud_GetChild( file.inspectPanel, "IndividualItemInfo" )
	file.videoInfo = Hud_GetChild( file.inspectPanel, "VideoInfo" )

	s_inspectUIData.purchaseButton = Hud_GetChild( file.inspectPanel, "PurchaseOfferButton" )
	s_inspectUIData.currencyInfo = Hud_GetChild( file.inspectPanel, "CurrencyInfo" )
	s_inspectUIData.disclaimerInfo = Hud_GetChild( file.inspectPanel, "DisclaimerInfo" )
	s_inspectUIData.descriptionInfo = Hud_GetChild( file.inspectPanel, "DescriptionInfo" )

	SetGridItems()

	AddButtonEventHandler( s_inspectUIData.purchaseButton, UIE_CLICK, PurchaseOfferButton_OnClick )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function UniversalMeleeInspectMenu_OnOpen()
{
	AddCallback_OnGRXInventoryStateChanged( LockPurchaseButtonWhenInventoryIsNotReady )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UniversalMeleeInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXOffersRefreshed( UniversalMeleeInspectMenu_OnGRXUpdated )
}

void function UniversalMeleeInspectMenu_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( LockPurchaseButtonWhenInventoryIsNotReady )
	RemoveCallback_OnGRXInventoryStateChanged( UniversalMeleeInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXOffersRefreshed( UniversalMeleeInspectMenu_OnGRXUpdated )
}

void function UniversalMeleeInspectMenu_OnGRXUpdated()
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	int index = file.isFullSet ? INITIAL_INDEX_FULL_SET : INITIAL_INDEX_SINGLE_ITEM

	SetCurrencyData()
	SetHeader()
	SetItemInfo( index )
	SetCurrencyInfo()
	SetPurchaseButton( index )
	SetArtifactsInfo( index )
	GridPanel_Refresh( file.itemGrid )

		AutoEquipAddon( index )

}

void function UniversalMeleeInspectMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.STORE_INSPECT )
	RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( file.offerItem ), true )

	RegisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )
}

void function UniversalMeleeInspectMenu_OnHide()
{
	DeregisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )
}

void function UniversalMeleeInspectMenu_AttemptOpenWithOffer( GRXScriptOffer offer )
{
	file.offer = offer
	file.price = offer.prices[INITIAL_INDEX_SINGLE_ITEM]
	file.isFullSet = offer.output.flavors.len() == MAX_NUMBER_ITEMS
	file.initialIndex = file.isFullSet ? INITIAL_INDEX_FULL_SET : INITIAL_INDEX_SINGLE_ITEM
	file.offerItem = offer.output.flavors[0]
	file.setItems = UniversalMelee_GetSetItems( offer.output.flavors[0] )
	file.isBaseWeapon = UniversalMelee_IsBaseSkin( file.offerItem )

	AdvanceMenu( GetMenu( "UniversalMeleeInspectMenu" ) )
}

void function SetCurrencyData()
{
	file.isOwned = GRX_IsItemOwnedByPlayer( file.offerItem )
	file.isHeirloomCurrency = file.price.flavors[Artifacts_GetIndexOrder( INITIAL_INDEX_SINGLE_ITEM )] == GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM]
	var currencyTotal = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), file.isHeirloomCurrency ? GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] : GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	file.canAfford = currencyTotal >= file.price.quantities[INITIAL_INDEX_SINGLE_ITEM]
}

void function SetHeader()
{
	var pageHeader = file.pageHeader

	HudElem_SetRuiArg( pageHeader, "offerName", file.offer.titleText )
	HudElem_SetRuiArg( pageHeader, "underLineVisible", true )
	HudElem_SetRuiArg( pageHeader, "isSingleItem", false )
	HudElem_SetRuiArg( pageHeader, "singleItemRarity", 0 )
	HudElem_SetRuiArg( pageHeader, "offerDesc", Localize("#UNIVERSAL_MELEE_USABILITY") )
	HudElem_SetRuiArg( pageHeader, "headerTextWrapRatio", 10.0 )
	HudElem_SetRuiArg( pageHeader, "offerDescTextWrapRatio", 10.0 )
}

void function SetItemInfo( int index )
{
	var itemInfo = file.itemInfo
	ItemFlavor itemFlav = file.offer.output.flavors[index]

	HudElem_SetRuiArg( itemInfo, "isOwned", file.isOwned )
	HudElem_SetRuiArg( itemInfo, "rarity", 4 )
	HudElem_SetRuiArg( itemInfo, "rarityText", "#UNIVERSAL_MELEE" )
	HudElem_SetRuiArg( itemInfo, "itemType", itemTypeNameMap[ItemFlavor_GetType( itemFlav )] )
	HudElem_SetRuiArg( itemInfo, "itemName", ItemFlavor_GetLongName( itemFlav ) )
	Hud_SetVisible( itemInfo, file.isFullSet )

	var videoInfo = file.videoInfo
	string videoInfoText
	switch ( index )
	{
		case UNIVERSAL_MELEE_UPGRADE_INDEX:
			videoInfoText = "#MELEE_CUSTOMIZATION_ACTIVATION_EMOTE_VIDEO_DESC"
			break
		case UNIVERSAL_MELEE_DEATH_BOX_INDEX:
			videoInfoText = "#MELEE_CUSTOMIZATION_DEATHBOX_SUBTITLE"
			break
		default:
			videoInfoText = ""
			break
	}

	HudElem_SetRuiArg( videoInfo, "videoInfo", videoInfoText )
	Hud_SetVisible( videoInfo, videoInfoText != "" )
}

void function SetGridItems()
{
	var itemGrid = file.itemGrid

	GridPanel_Init( itemGrid, ITEM_GRID_ROWS, ITEM_GRID_COLUMNS, OnBindItemGridButton, ItemGridButtonCountCallback, ItemGridButtonInitCallback )
	GridPanel_SetFillDirection( itemGrid, eGridPanelFillDirection.RIGHT )
	GridPanel_SetButtonHandler( itemGrid, UIE_GET_FOCUS, OnArtifactsGridItemHover )
}

void function SetCurrencyInfo()
{
	var currencyInfo = s_inspectUIData.currencyInfo

	HudElem_SetRuiArg( currencyInfo, "canAfford", file.canAfford )
	HudElem_SetRuiArg( currencyInfo, "price", GRX_GetFormattedPrice( file.price ) )
	HudElem_SetRuiArg( currencyInfo, "isHeirloomCurrency", file.isHeirloomCurrency )
	Hud_SetVisible( currencyInfo, !file.canAfford && !file.isHeirloomCurrency && !file.isOwned )
}

void function SetArtifactsInfo( int index )
{
	ItemFlavor itemFlav = file.offer.output.flavors[ index ]
	string baseWeaponName = Localize( ItemFlavor_GetLongName( UniversalMelee_GetBaseSkin( itemFlav ) ) )

	var descriptionInfo = s_inspectUIData.descriptionInfo
	string descriptionTitle = file.isOwned ? "#BASE_UNIVERSAL_MELEE_OWNED" : "#BASE_UNIVERSAL_MELEE_UNOWNED"
	HudElem_SetRuiArg( descriptionInfo, "descriptionTitle", Localize( descriptionTitle, baseWeaponName ) )
	HudElem_SetRuiArg( descriptionInfo, "descriptionText", Localize( "#UNIVERSAL_MELEE_DESCRIPTION", baseWeaponName ) )
	HudElem_SetRuiArg( descriptionInfo, "isOwned", file.isOwned )
	Hud_SetVisible( descriptionInfo, file.isBaseWeapon )

	var disclaimerInfo = s_inspectUIData.disclaimerInfo
	string disclaimerText = file.isBaseWeapon ? "#UNIVERSAL_MELEE_DISCLAIMER_BASE" : "#UNIVERSAL_MELEE_DISCLAIMER"
	HudElem_SetRuiArg( disclaimerInfo, "disclaimer", Localize( disclaimerText, baseWeaponName ) )
	HudElem_SetRuiArg( disclaimerInfo, "isShowingInfo", !file.canAfford && !file.isHeirloomCurrency && !file.isOwned )
}

void function SetPurchaseButton( int index )
{
	ItemFlavor itemFlav = file.offer.output.flavors[ index ]
	string baseWeaponName = Localize( ItemFlavor_GetLongName( UniversalMelee_GetBaseSkin( itemFlav ) ) )

	var purchaseButton = s_inspectUIData.purchaseButton
	string buttonDescText
	string buttonText
	bool isPurchaseButtonLocked

	if ( file.isOwned )
	{
		buttonDescText = ""
		buttonText = "#OWNED"
		isPurchaseButtonLocked = true
	}
	else if ( file.isBaseWeapon && MeleeSkin_IsRewardForActiveEvent( itemFlav ) )
	{
		file.activeEvent = GetActiveBaseEvent( GetUnixTimestamp() )
		if ( file.activeEvent != null )
		{
			ItemFlavor ornull event = file.activeEvent
			expect ItemFlavor(event)
			buttonText = Localize( BaseEvent_GetLandingPageTitleData( event ).text )
		}
		else
		{
			isPurchaseButtonLocked = true
			Assert( true, "No active event" )
		}

	}
	else if ( !file.isBaseWeapon && !UniversalMelee_IsBaseSkinOwned( itemFlav ) )
	{
		buttonDescText = ""
		buttonText = Localize( "#BASE_UNIVERSAL_MELEE_REQUIRED", baseWeaponName )
		isPurchaseButtonLocked = true
	}
	else if ( !file.isFullSet && !UniversalMelee_HasPreviousItem( file.offerItem ) )
	{
		buttonDescText = file.canAfford ? GRX_GetFormattedPrice( file.price ) : ""
		buttonText = "#UNIVERSAL_MELEE_REQUIRED_PREVIOUS"
		isPurchaseButtonLocked = true
	}
	else if ( !file.isHeirloomCurrency && !file.canAfford )
	{
		buttonDescText = ""
		buttonText = "#CONFIRM_GET_EXOTIC"
		isPurchaseButtonLocked = false
	}
	else
	{
		buttonDescText = GRX_GetFormattedPrice( file.price )
		buttonText = "#PURCHASE"
		isPurchaseButtonLocked = false
	}

	HudElem_SetRuiArg( purchaseButton, "buttonDescText", buttonDescText )
	HudElem_SetRuiArg( purchaseButton, "buttonText", buttonText )
	Hud_SetLocked( purchaseButton, isPurchaseButtonLocked )
}


void function AutoEquipAddon( int index )
{
	ItemFlavor addOnToEquip = file.offer.output.flavors[ index ]

	if ( ItemFlavor_GetType( addOnToEquip ) == eItemType.melee_addon )
	{
		EHI playerEHI = LocalClientEHI()
		array< LoadoutEntry > addOnSlots = Loadout_MeleeAddOns()

		int emptySlotIndex = -1
		for ( int i = 0; i < addOnSlots.len(); i++ ) 
		{
			ItemFlavor equippedItem = LoadoutSlot_GetItemFlavor( playerEHI, addOnSlots[i] )
			if ( equippedItem == addOnToEquip )
				return
			else if ( emptySlotIndex == -1 && equippedItem == addOnSlots[0].defaultItemFlavor )
				emptySlotIndex = i
		}

		Assert( emptySlotIndex != -1 )
		if ( emptySlotIndex == -1 )
			return

		RequestSetItemFlavorLoadoutSlot( playerEHI, addOnSlots[ emptySlotIndex ], addOnToEquip )
	}
}


void function LockPurchaseButtonWhenInventoryIsNotReady()
{
	Hud_SetLocked( s_inspectUIData.purchaseButton, !GRX_IsInventoryReady() )
}

void function PurchaseOfferButton_OnClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	if (!file.canAfford && !file.isHeirloomCurrency)
	{
		OpenExoticShardsModal( button )
	}
	else if ( file.isBaseWeapon && MeleeSkin_IsRewardForActiveEvent( file.offerItem ) )
	{
		JumpToEventTab( "RTKEventsPanel" )
	}
	else
	{
		PurchaseDialogConfig pdc
		pdc.offer = file.offer
		pdc.quantity = 1

		PurchaseDialog( pdc )
	}
}

void function OnBindItemGridButton( var panel, var button, int index )
{
	if ( file.setItems.len() == 0 )
		return

	ItemFlavor currentIndexItem = file.setItems[index]
	bool isCurrentSelectedItem = currentIndexItem.guid == file.offerItem.guid
	var rui = Hud_GetRui( button )

	RuiSetImage( rui, "itemThumbnail", ItemFlavor_GetIcon( currentIndexItem ) )

	if ( ItemFlavor_GetType( currentIndexItem ) == eItemType.artifact_component_deathbox )
	{
		RuiSetFloat3( rui, "colorTag1", Artifacts_GetComponentMainColor( currentIndexItem ) )
		RuiSetFloat3( rui, "colorTag2", Artifacts_GetComponentSecondaryColor( currentIndexItem ) )
	}
	else
	{
		RuiSetFloat3( rui, "colorTag1", UniversalMelee_GetComponentMainColor( currentIndexItem ) )
		RuiSetFloat3( rui, "colorTag2", UniversalMelee_GetComponentSecondaryColor( currentIndexItem ) )
	}
	RuiSetBool( rui, "isOwned", GRX_IsItemOwnedByPlayer( currentIndexItem ) )
	RuiSetBool( rui, "isLocked", !file.isFullSet && !UniversalMelee_HasPreviousItem( currentIndexItem ) )
	RuiSetBool( rui, "isSelected", isCurrentSelectedItem )
	RuiSetBool( rui, "showLink", index == LINK_INDEX  )
	RuiSetBool( rui, "showArrow", index != MAX_NUMBER_ITEMS - 1 )
	RuiSetInt( rui, "rarity", 0 )
	RuiSetInt( rui, "itemQty", 1)

	if ( isCurrentSelectedItem )
	{
		s_inspectUIData.previousItemGrid = button
	}
}

int function ItemGridButtonCountCallback( var panel )
{
	return MAX_NUMBER_ITEMS
}

void function ItemGridButtonInitCallback( var button )
{
}

void function OnArtifactsGridItemHover( var panel, var button, int index )
{
	if ( file.isFullSet)
	{
		ItemFlavor currentIndexItem = file.setItems[index]
		if ( currentIndexItem != file.offerItem )
		{
			RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( currentIndexItem ), true )
			file.offerItem = currentIndexItem
			SetItemSelected( button )
			SetItemInfo( index )
		}
	}
}

void function SetItemSelected( var currentButton )
{
	var previousRui = Hud_GetRui( s_inspectUIData.previousItemGrid )
	RuiSetBool( previousRui, "isSelected", false )

	var rui = Hud_GetRui( currentButton )
	RuiSetBool( rui, "isSelected", true )
	s_inspectUIData.previousItemGrid = currentButton
}