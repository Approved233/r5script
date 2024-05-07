global function InitArtifactsInspectMenu
global function ArtifactsInspectMenu_AttemptOpenWithOffer

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
	bool isBaseArtifact
	bool isFullSet
	bool canAfford
	bool isHeirloomCurrency
	int initialIndex
	array< ItemFlavor > setItems
	GRXScriptOffer& offer
	ItemFlavorBag& price
	ItemFlavor& offerItem
} file

global struct ArtifactsInspectUIData
{
	var currencyInfo
	var purchaseButton
	var disclaimerInfo
	var descriptionInfo
	var previousItemGrid
}

ArtifactsInspectUIData s_inspectUIData
const int ITEM_GRID_ROWS = 1
const int ITEM_GRID_COLUMNS = 5
const int MAX_NUMBER_ITEMS = 5
const int LINK_INDEX = 2
const int INITIAL_INDEX_SINGLE_ITEM = 0
const int INITIAL_INDEX_FULL_SET = 2
const int ARTIFACT_ACTIVATION_EMOTE_INDEX = 3
const int ARTIFACT_DEATH_BOX_INDEX = 4

void function InitArtifactsInspectMenu( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ArtifactsInspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, ArtifactsInspectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ArtifactsInspectMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, ArtifactsInspectMenu_OnHide )

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

void function ArtifactsInspectMenu_OnOpen()
{
	AddCallback_OnGRXInventoryStateChanged( LockPurchaseButtonWhenInventoryIsNotReady )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( ArtifactsInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXOffersRefreshed( ArtifactsInspectMenu_OnGRXUpdated )
}

void function ArtifactsInspectMenu_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( LockPurchaseButtonWhenInventoryIsNotReady )
	RemoveCallback_OnGRXInventoryStateChanged( ArtifactsInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXOffersRefreshed( ArtifactsInspectMenu_OnGRXUpdated )
}

void function ArtifactsInspectMenu_OnGRXUpdated()
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	SetCurrencyData()
	SetHeader()
	SetItemInfo( file.isFullSet ? INITIAL_INDEX_FULL_SET : INITIAL_INDEX_SINGLE_ITEM )
	SetCurrencyInfo()
	SetPurchaseButton()
	SetArtifactsInfo()
	GridPanel_Refresh( file.itemGrid )
}

void function ArtifactsInspectMenu_OnShow()
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

void function ArtifactsInspectMenu_OnHide()
{
	DeregisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_RemoveEventHandler( Hud_GetChild( file.menu, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )
}

void function ArtifactsInspectMenu_AttemptOpenWithOffer( GRXScriptOffer offer )
{
	file.offer = offer
	file.price = offer.prices[INITIAL_INDEX_SINGLE_ITEM]
	file.isFullSet = offer.output.flavors.len() == MAX_NUMBER_ITEMS
	file.initialIndex = file.isFullSet ? INITIAL_INDEX_FULL_SET : INITIAL_INDEX_SINGLE_ITEM
	file.offerItem = offer.output.flavors[Artifacts_GetIndexOrder( file.initialIndex )]
	file.setItems = Artifacts_GetSetItemsOrdered( Artifacts_GetSetIndex( file.offerItem ) )
	file.isBaseArtifact = Artifacts_IsBaseArtifact( file.offerItem )

	AdvanceMenu( GetMenu( "ArtifactsInspectMenu" ) )
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
	HudElem_SetRuiArg( pageHeader, "offerDesc", Localize("#ARTIFACT_USABILITY") )
	HudElem_SetRuiArg( pageHeader, "headerTextWrapRatio", 10.0 )
	HudElem_SetRuiArg( pageHeader, "offerDescTextWrapRatio", 10.0 )
}

void function SetItemInfo( int index )
{
	var itemInfo = file.itemInfo
	ItemFlavor itemFlav = file.offer.output.flavors[Artifacts_GetIndexOrder( index )]

	HudElem_SetRuiArg( itemInfo, "isOwned", file.isOwned )
	HudElem_SetRuiArg( itemInfo, "rarity", 4 )
	HudElem_SetRuiArg( itemInfo, "rarityText", "#ARTIFACT" )
	HudElem_SetRuiArg( itemInfo, "itemType", itemTypeNameMap[ItemFlavor_GetType( itemFlav )] )
	HudElem_SetRuiArg( itemInfo, "itemName", ItemFlavor_GetLongName( itemFlav ) )
	Hud_SetVisible( itemInfo, file.isFullSet )

	var videoInfo = file.videoInfo
	string videoInfoText
	switch ( index )
	{
		case ARTIFACT_ACTIVATION_EMOTE_INDEX:
			videoInfoText = "#MELEE_CUSTOMIZATION_ACTIVATION_EMOTE_VIDEO_DESC"
			break
		case ARTIFACT_DEATH_BOX_INDEX:
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

void function SetArtifactsInfo()
{
	var descriptionInfo = s_inspectUIData.descriptionInfo
	string descriptionTitle = file.isOwned ? "#BASE_ARTIFACT_OWNED" : "#BASE_ARTIFACT_UNOWNED"
	HudElem_SetRuiArg( descriptionInfo, "descriptionTitle", descriptionTitle )
	HudElem_SetRuiArg( descriptionInfo, "descriptionText", "#ARTIFACT_DESCRIPTION" )
	HudElem_SetRuiArg( descriptionInfo, "isOwned", file.isOwned )
	Hud_SetVisible( descriptionInfo, file.isBaseArtifact )

	var disclaimerInfo = s_inspectUIData.disclaimerInfo
	HudElem_SetRuiArg( disclaimerInfo, "disclaimer", file.isBaseArtifact ? "#ARTIFACT_DISCLAIMER_BASE" : "#ARTIFACT_DISCLAIMER"  )
	HudElem_SetRuiArg( disclaimerInfo, "isShowingInfo", !file.canAfford && !file.isHeirloomCurrency && !file.isOwned )
}

void function SetPurchaseButton()
{
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
	else if ( !file.isBaseArtifact && !Artifacts_IsBaseArtifactOwned() )
	{
		buttonDescText = ""
		buttonText = "#BASE_ARTIFACT_REQUIRED"
		isPurchaseButtonLocked = true
	}
	else if ( !file.isFullSet && !Artifacts_HasPreviousItem( file.offerItem ) )
	{
		buttonDescText = file.canAfford ? GRX_GetFormattedPrice( file.price ) : ""
		buttonText = "#ARTIFACT_REQUIRED_PREVIOUS"
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

	RuiSetImage( rui, "itemThumbnail", Artifacts_GetComponentIcon( currentIndexItem ) )
	RuiSetFloat3( rui, "colorTag1", Artifacts_GetComponentMainColor( currentIndexItem ) )
	RuiSetFloat3( rui, "colorTag2", Artifacts_GetComponentSecondaryColor( currentIndexItem ) )
	RuiSetBool( rui, "isOwned", GRX_IsItemOwnedByPlayer( currentIndexItem ) )
	RuiSetBool( rui, "isLocked", !file.isFullSet && !Artifacts_HasPreviousItem( currentIndexItem ) )
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