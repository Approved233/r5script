global function InitConfirmPurchaseDialog
global function InitConfirmPackBundlePurchaseDialog
global function InitConfirmMultiPackBundlePurchaseDialog
global function InitBattlepassPurchaseDialog
global function InitConfirmPackPurchaseDialog
global function InitMultiPackDisclosureHeaderPanel
global function InitApexPackDisclosureDialogContentPanel
global function InitEventPackDisclosureDialogContentPanel
global function InitThematicPackDisclosureDialogContentPanel0
global function InitThematicPackDisclosureDialogContentPanel1
global function InitThematicPackDisclosureDialogContentPanel2
global function InitThematicPackDisclosureDialogContentPanel3
global function InitEventThematicPackDisclosureDialogContentPanel
global function UpdateGiftButtonToolTip

global function PurchaseDialog
global function IsUserAwaitingForConfirmation

global enum ePurchaseDialogStatus
{
	INACTIVE = 0,
	AWAITING_USER_CONFIRMATION = 1,
	WORKING = 2,
	FINISHED_SUCCESS = 3,
	FINISHED_FAILURE = 4,
}

enum eButtonDisplayStatus
{
	ONLY_PACKS = 0,
	ONLY_PREMIUM = 1,
	BOTH = 2,
	NONE = 3
}

const int MAX_PURCHASE_BUTTONS = 2
const string PIN_MESSAGE_TYPE_AC = "apex_coins_click"
const string PIN_MESSAGE_TYPE_PACKS ="pack_button_click"
const array<int> PACK_QUANTITIES = [1, 10, 25, 50, 100]
const array<int> PACK_EVENT_QUANTITIES = [1, 3, 5, 10, 24]
const vector TOOLTIP_COLOR_ORANGE = <255, 78, 29>

struct PurchaseDialogState
{
	PurchaseDialogConfig&                   cfg
	array<GRXScriptOffer>                   purchaseOfferList
	table<var, GRXScriptOffer>              purchaseButtonOfferMap
	table<var, ItemFlavorBag>               purchaseButtonPriceMap
	string                                  purchaseSoundOverride = ""
}

struct
{
	var activeDialog
	var genericPurchaseDialog
	var packBundlePurchaseDialog
	var multiPackBundlePurchaseDialog
	var battlepassPurchaseDialog
	var packPurchaseDialog
	var contentRui
	var buttonsPanel
	var processingButton

	var dialogContent
	var dialogHeader

	bool isAllApexPacks
	bool isMultipackDisclosure = false

	var        cancelButton
	var        AcButton
	var		   packButton
	var        giftButton
	bool	   isGiftableLegend = false
	bool 	   isGiftableOnly = false
	bool       blockInput = false
	array<var> packQuantityButtons
	var		   activePackQuantityButton
	array<var> purchaseButtonBottomToTopList
	ItemFlavor ornull activeCollectionEvent = null

	int                  status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState& state
} file

void function InitPurchaseMenu( var menu, array< var > purchaseButtons )
{
	
	SetDialog( menu, true )

	foreach ( button in purchaseButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmPurchaseDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmPurchaseDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmPurchaseDialog_OnNavigateBack )

	var cancelButton = Hud_GetChild( menu, "CancelButton" )
	HudElem_SetRuiArg( cancelButton, "buttonText", "#B_BUTTON_CANCEL" )
	Hud_AddEventHandler( cancelButton, UIE_CLICK, CancelButton_Activate )
}

array< var > function GetPurchaseButtonArray( var menu, int maxIndex )
{
	array< var > purchaseButtons = []
	for ( int index = 0; index < maxIndex; index++ )
	{
		var currentButton = Hud_GetChild( menu, "PurchaseButton" + index )
		purchaseButtons.append( currentButton )
	}
	return purchaseButtons
}














void function SetupPurchaseMenu( int purchaseButtonStatus )
{
	var menu = file.activeDialog
	void functionref( var ) purchaseButtonFunction = PurchaseButton_Activate

	
	var acPurchaseButton = Hud_GetChild( menu, "AcPurchaseButton" )
	var packPurchaseButton = Hud_GetChild( menu, "PackPurchaseButton" )
	var giftButton = Hud_GetChild( menu, "GiftButton" )
	var cancelButton = Hud_GetChild( menu, "CancelButton" )

	
	array< var > purchaseButtonArray = []
	switch ( menu )
	{
		case file.genericPurchaseDialog:
		case file.packBundlePurchaseDialog:
			purchaseButtonArray = GetPurchaseButtonArray( menu, MAX_PURCHASE_BUTTONS )
			break

		case file.battlepassPurchaseDialog:
			purchaseButtonArray = GetPurchaseButtonArray( menu, 1 )
			break

		default:
			Assert( false, "Unhandled active dialog for SetupPurchaseMenu(): " + menu )
	}

	
	bool boundPurchaseButtons = false
	foreach ( index, button in purchaseButtonArray )
	{
		bool skippedButton = false

		
		if ( !Hud_IsVisible( button ) )
			continue

		
		if ( index == 0 )
			Hud_SetNavUp( button, null )

		
		if ( index > 0 )
			Hud_SetNavUp( button, purchaseButtonArray[ index - 1 ] )

		
		if ( index + 1 < purchaseButtonArray.len() )
		{
			var nextButton = purchaseButtonArray[ index + 1 ]

			
			if ( Hud_IsVisible( nextButton ) )
				Hud_SetNavDown( button, nextButton )
			else
				skippedButton = true
		}

		
		
		if ( index == purchaseButtonArray.len() - 1 || skippedButton )
		{
			switch ( purchaseButtonStatus )
			{
				case eButtonDisplayStatus.BOTH:
				case eButtonDisplayStatus.ONLY_PREMIUM:
					Hud_SetNavDown( button, acPurchaseButton )
					break

				case eButtonDisplayStatus.ONLY_PACKS:
					Hud_SetNavDown( button, packPurchaseButton )
					break

				case eButtonDisplayStatus.NONE:
					Hud_SetNavDown( button, cancelButton )
					break
			}
		}
	}

	
	var lastPurchaseButton = null
	for ( int index = purchaseButtonArray.len() - 1; index >= 0; index-- )
	{
		if ( Hud_IsVisible( purchaseButtonArray[ index ] ) )
		{
			lastPurchaseButton = purchaseButtonArray[ index ]
			break
		}
	}

	switch ( purchaseButtonStatus )
	{
		case eButtonDisplayStatus.BOTH:
			if ( lastPurchaseButton != null )
			{
				Hud_SetNavUp( acPurchaseButton, lastPurchaseButton )
				Hud_SetNavDown( acPurchaseButton, packPurchaseButton )

				Hud_SetNavUp( packPurchaseButton, acPurchaseButton )
				Hud_SetNavDown( packPurchaseButton, cancelButton )

				Hud_SetNavUp( cancelButton, packPurchaseButton )
				Hud_SetNavDown( cancelButton, null )
			}
			break

		case eButtonDisplayStatus.ONLY_PREMIUM:

			if ( file.isGiftableLegend )
			{
				if ( file.isGiftableOnly )
				{
					Hud_SetNavUp( file.giftButton , null )
					Hud_SetNavDown( file.giftButton , acPurchaseButton )

					Hud_SetNavUp( acPurchaseButton, file.giftButton )
					Hud_SetNavDown( acPurchaseButton, cancelButton )

					Hud_SetNavUp( cancelButton, acPurchaseButton )
					Hud_SetNavDown( cancelButton, null )
				}
				else
				{

					if ( lastPurchaseButton != null )
					{
						Hud_SetNavDown( lastPurchaseButton, file.giftButton )
						Hud_SetNavUp( file.giftButton, lastPurchaseButton )
						Hud_SetNavDown( file.giftButton, acPurchaseButton )

						Hud_SetNavUp( acPurchaseButton, file.giftButton )
						Hud_SetNavDown( acPurchaseButton, cancelButton )

						Hud_SetNavUp( cancelButton, acPurchaseButton )
						Hud_SetNavDown( cancelButton, null )
					}
				}
			}
			else
			{
				if ( lastPurchaseButton != null )
				{
					Hud_SetNavUp( acPurchaseButton, lastPurchaseButton )
					Hud_SetNavDown( acPurchaseButton, cancelButton )

					Hud_SetNavUp( cancelButton, acPurchaseButton )
					Hud_SetNavDown( cancelButton, null )
				}
			}
			break

		case eButtonDisplayStatus.ONLY_PACKS:
			if ( lastPurchaseButton != null )
			{
				Hud_SetNavUp( packPurchaseButton, lastPurchaseButton )
				Hud_SetNavDown( packPurchaseButton, cancelButton )

				Hud_SetNavUp( cancelButton, packPurchaseButton )
				Hud_SetNavDown( cancelButton, null )
			}
			break

		case eButtonDisplayStatus.NONE:

			if ( file.isGiftableLegend )
			{
				if ( file.isGiftableOnly )
				{
					Hud_SetNavUp( file.giftButton , null )
					Hud_SetNavDown( file.giftButton , acPurchaseButton )

					Hud_SetNavUp( acPurchaseButton, file.giftButton )
					Hud_SetNavDown( acPurchaseButton, cancelButton )

					Hud_SetNavUp( cancelButton, acPurchaseButton )
					Hud_SetNavDown( cancelButton, null )
				}
				else
				{
					if ( lastPurchaseButton != null )
					{
						Hud_SetNavDown( lastPurchaseButton, file.giftButton )

						Hud_SetNavUp( file.giftButton, lastPurchaseButton )
						Hud_SetNavDown( file.giftButton, cancelButton )

						Hud_SetNavUp( cancelButton, file.giftButton )
						Hud_SetNavDown( cancelButton, null )
					}
				}
			}
			else
			{
				if ( lastPurchaseButton != null )
				{
					Hud_SetNavUp( cancelButton, lastPurchaseButton )
					Hud_SetNavDown( cancelButton, null )
				}
			}
			break
	}

	
	file.AcButton = acPurchaseButton
	file.packButton = packPurchaseButton
	file.giftButton = giftButton
	file.cancelButton = cancelButton
}

void function InitConfirmPurchaseDialog( var menu )
{
	file.genericPurchaseDialog = menu
	
	
	

	
	file.AcButton = Hud_GetChild( menu, "AcPurchaseButton" )
	file.packButton = Hud_GetChild( menu, "PackPurchaseButton" )
	file.giftButton = Hud_GetChild( menu, "GiftButton" )
	Hud_AddEventHandler( file.AcButton, UIE_CLICK, AcButton_Activate )
	Hud_AddEventHandler( file.packButton, UIE_CLICK, PackButton_Activate )
	Hud_AddEventHandler( file.giftButton, UIE_CLICK, GiftButton_Activate )

	InitPurchaseMenu( menu, GetPurchaseButtonArray( menu, MAX_PURCHASE_BUTTONS ) )
	SetIsSelfClosingMenu( menu, true )

	
	
	

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function InitConfirmPackBundlePurchaseDialog( var menu )
{
	file.packBundlePurchaseDialog = menu
	InitPurchaseMenu( menu, GetPurchaseButtonArray( menu, MAX_PURCHASE_BUTTONS ) )
	SetIsSelfClosingMenu( menu, true )

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function InitConfirmMultiPackBundlePurchaseDialog( var menu )
{
	file.multiPackBundlePurchaseDialog = menu
	InitPurchaseMenu( menu, GetPurchaseButtonArray( menu, MAX_PURCHASE_BUTTONS ) )
	SetIsSelfClosingMenu( menu, true )

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function InitBattlepassPurchaseDialog( var menu )
{
	file.battlepassPurchaseDialog = menu
	InitPurchaseMenu( menu, GetPurchaseButtonArray( menu, 1 ) )

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function InitConfirmPackPurchaseDialog( var newMenuArg )
{
	file.packPurchaseDialog = newMenuArg
	var cancelButton = Hud_GetChild( newMenuArg, "CancelButton" )
	HudElem_SetRuiArg( cancelButton, "buttonText", "#B_BUTTON_CLOSE" )
	Hud_AddEventHandler( Hud_GetChild( newMenuArg, "PurchaseButton0" ), UIE_CLICK, PurchaseButton_Activate )
	Hud_AddEventHandler( cancelButton, UIE_CLICK, CancelButton_Activate )

	for ( int i = 0; i < PACK_QUANTITIES.len(); i++ )
	{
		var button = Hud_GetChild( newMenuArg, "PackButton" + i )
		file.packQuantityButtons.append( button )
		Hud_AddEventHandler( button, UIE_CLICK, PackQuantitySelectButton_Activate )
	}

	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, ConfirmPurchaseDialog_OnOpen )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, ConfirmPurchaseDialog_OnClose )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_NAVIGATE_BACK, ConfirmPurchaseDialog_OnNavigateBack )
	SetDialog( file.packPurchaseDialog, false )

	RegisterSignal( "ConfirmPurchaseClosed" )
}

struct DialogElementReferencesConfig
{
	bool hasEventPack = false
	bool hasThematicPack = false
	bool hasEventThematicPack = false
	bool hasStickers = false
	bool hasSkydives = false
	bool hasHolosprays = false
	bool usesMOTDButtonForCount = false

	string disclaimerSpecifics = ""
}


void function UpdateDialogElementReferences( DialogElementReferencesConfig cfg, array<ItemFlavor> packFlavors )
{
	bool hasEventPack = cfg.hasEventPack
	bool hasThematicPack = cfg.hasThematicPack
	bool hasEventThematicPack = cfg.hasEventThematicPack
	bool hasStickers = cfg.hasStickers
	bool hasSkydives = cfg.hasSkydives
	bool hasHolosprays = cfg.hasHolosprays
	bool usesMOTDButtonForCount = cfg.usesMOTDButtonForCount
	string disclaimerSpecifics = cfg.disclaimerSpecifics

	file.cancelButton = Hud_GetChild( file.activeDialog, "CancelButton" )

	Assert( ( !hasStickers && hasSkydives ) || ( hasStickers && !hasSkydives ) || ( !hasStickers && !hasSkydives ), "Cannot currently have both Stickers *and* Skydives in Slot 12 of 'Available Item Categories.'" )

	file.purchaseButtonBottomToTopList.clear()
	file.purchaseButtonBottomToTopList = GetPurchaseButtonArray( file.activeDialog, MAX_PURCHASE_BUTTONS )

	if ( IsPanelTabbed( file.activeDialog ) )
		ClearTabs( file.activeDialog )

	
	if ( file.isMultipackDisclosure )
	{
		bool apexDisclosurePresent = false 
		int thematicPackCount = 0 

		Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContentPackHeader" ), true )

		foreach ( ItemFlavor pack in packFlavors )
		{
			
			if ( ItemFlavor_GetGRXMode( pack ) == eItemFlavorGRXMode.PACK && ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.APEX && apexDisclosurePresent == false )
			{
				TabDef tabDef = AddTab( file.activeDialog, Hud_GetChild( file.activeDialog, "DialogContentApexPackContent" ), ItemFlavor_GetLongName( pack ) )
				apexDisclosurePresent = true 
			}

			
			if ( ItemFlavor_GetGRXMode( pack ) == eItemFlavorGRXMode.PACK && ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.EVENT )
			{
				AddMultiPackDisclosureCollectionEventPackTab( pack )
			}

			
			if ( ItemFlavor_GetGRXMode( pack ) == eItemFlavorGRXMode.PACK && ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.THEMATIC )
			{
				Assert( thematicPackCount < 4, "We are not set up to accomdate more than 4 different Thematic Packs at once." )

				AddMultiPackDisclosureThematicPackTab( pack, thematicPackCount )
				thematicPackCount++ 
			}

			
			if ( ItemFlavor_GetGRXMode( pack ) == eItemFlavorGRXMode.PACK && ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.EVENT_THEMATIC )
			{
				AddMultiPackDisclosureEventThematicPackTab( pack, usesMOTDButtonForCount )
			}
		}

		TabData tabData = GetTabDataForPanel( file.activeDialog )

		tabData.centerTabs = true
		ActivateTab( tabData, 0 )
		file.dialogContent = _GetActiveTabPanel( file.activeDialog )
		SetTabBackground( tabData, Hud_GetChild( file.activeDialog, "TabsBackground" ), eTabBackground.STANDARD )
		SetTabDefsToSeasonal(tabData)

	}
	else
	{
		if ( hasEventPack )
		{
			file.dialogContent = Hud_GetChild( file.activeDialog, "EventDialogContent" )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )
		}
		else if ( hasThematicPack )
		{
			file.dialogContent = Hud_GetChild( file.activeDialog, "ThematicDialogContent" )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )

			SetThematicPackDisclosureText( packFlavors[ 0 ], file.dialogContent )
		}
		else if ( hasEventThematicPack )
		{
			file.dialogContent = Hud_GetChild( file.activeDialog, "EventThematicDialogContent" )
			HudElem_SetRuiArg( file.dialogContent, "eventName", disclaimerSpecifics )
			HudElem_SetRuiArg( file.dialogContent, "hasStickers", hasStickers )
			HudElem_SetRuiArg( file.dialogContent, "hasSkydives", hasSkydives )
			HudElem_SetRuiArg( file.dialogContent, "hasHolosprays", hasHolosprays )
			HudElem_SetRuiArg( file.dialogContent, "usesMOTDButtonForCount", usesMOTDButtonForCount )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
		}
		else
		{
			file.dialogContent = Hud_GetChild( file.activeDialog, "DialogContent" )

			if ( file.activeDialog == file.packBundlePurchaseDialog || file.activeDialog == file.packPurchaseDialog )
			{
				Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
				Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
				Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )
			}
		}
		Hud_SetVisible( file.dialogContent, true )
	}


	InitButtonRCP( file.dialogContent )

	if ( file.activeDialog != file.packPurchaseDialog )
		SetDialog( file.activeDialog, true )
	SetClearBlur( file.activeDialog, false )
}

void function InitMultiPackDisclosureHeaderPanel( var panel )
{
	file.dialogHeader = panel
}
void function InitApexPackDisclosureDialogContentPanel( var panel )
{
}

void function InitEventPackDisclosureDialogContentPanel( var panel )
{
}

void function InitThematicPackDisclosureDialogContentPanel0( var panel )
{
}

void function InitThematicPackDisclosureDialogContentPanel1( var panel )
{
}

void function InitThematicPackDisclosureDialogContentPanel2( var panel )
{
}

void function InitThematicPackDisclosureDialogContentPanel3( var panel )
{
}

void function InitEventThematicPackDisclosureDialogContentPanel( var panel )
{
}

void function AddMultiPackDisclosureCollectionEventPackTab( ItemFlavor pack )
{
	TabDef tabDef = AddTab( file.activeDialog, Hud_GetChild( file.activeDialog, "DialogContentEventPackContent" ), ItemFlavor_GetLongName( pack ) )

	SetTabBaseWidth( tabDef,340 )
	var tabPanel = Hud_GetChild( file.activeDialog, "DialogContentEventPackContent" )

	var rui = Hud_GetRui( tabPanel )

	string currentEventName = Localize( ItemFlavor_GetLongName( expect ItemFlavor( file.activeCollectionEvent ) ) )

	ItemFlavor chaseItem = HeirloomEvent_GetPrimaryCompletionRewardItem( expect ItemFlavor( file.activeCollectionEvent ) )
	string nameText = Localize( ItemFlavor_GetLongName( chaseItem ) )

	RuiSetString( rui, "probabilityDescText", Localize( "#COLLECTION_EVENT_PACK_SUBHEADER", currentEventName ) )
	RuiSetString( rui, "itemDetailsText3", Localize( "#COLLECTION_EVENT_DISCLAIMER_1", currentEventName ) )
	RuiSetString( rui, "itemDetailsText4", Localize( "#COLLECTION_EVENT_DISCLAIMER_2", currentEventName ) )
	RuiSetString( rui, "itemDetailsText5", Localize( "#COLLECTION_EVENT_DISCLAIMER_3", currentEventName, nameText ) )
	RuiSetString( rui, "eventItemDetails", Localize( "#COLLECTION_EVENT_PACK_EVENT_ITEM", currentEventName ) )
}

void function AddMultiPackDisclosureThematicPackTab( ItemFlavor pack, int panelCount )
{
	string panelName = "DialogContentThematicPackContent" + panelCount.tostring()

	TabDef tabDef = AddTab( file.activeDialog, Hud_GetChild( file.activeDialog, panelName ), ItemFlavor_GetLongName( pack ) )

	SetTabBaseWidth( tabDef,340 )
	var tabPanel = tabDef.panel

	SetThematicPackDisclosureText( pack, tabPanel )
}

void function AddMultiPackDisclosureEventThematicPackTab( ItemFlavor pack, bool usesMOTDButtonForCount )
{
	TabDef tabDef = AddTab( file.activeDialog, Hud_GetChild( file.activeDialog, "DialogContentEventThematicPackContent" ), ItemFlavor_GetLongName( pack ) )

	SetTabBaseWidth( tabDef,340 )
	var tabPanel = Hud_GetChild( file.activeDialog, "DialogContentEventThematicPackContent" )

	bool multipackHasStickers = GetGlobalSettingsBool( ItemFlavor_GetAsset( pack ), "hasStickers" )
	bool multipackHasSkydives = GetGlobalSettingsBool( ItemFlavor_GetAsset( pack ), "hasSkydives" )

	Assert( ( !multipackHasStickers && multipackHasSkydives ) || ( multipackHasStickers && !multipackHasSkydives ) || ( !multipackHasStickers && !multipackHasSkydives ), "Cannot currently have both Stickers *and* Skydives in Slot 12 of 'Available Item Categories.'" )

	HudElem_SetRuiArg( tabPanel, "eventName", Localize( ItemFlavor_GetShortName( pack ) ) )
	HudElem_SetRuiArg( tabPanel, "hasStickers", multipackHasStickers )
	HudElem_SetRuiArg( tabPanel, "hasSkydives", multipackHasSkydives )
	HudElem_SetRuiArg( tabPanel, "usesMOTDButtonForCount", usesMOTDButtonForCount )
}

void function SetThematicPackDisclosureText( ItemFlavor pack, var tabPanel )
{
	ItemFlavor ornull packTheme = null
	asset themeAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( pack ), "themeFlavor" )

	if ( IsValidItemFlavorSettingsAsset( themeAsset ) )
	{
		packTheme = GetItemFlavorByAsset( themeAsset )
		var rui = Hud_GetRui( tabPanel )

		
		if ( ItemFlavor_GetType( expect ItemFlavor( packTheme ) ) == eItemType.character )
		{
			RuiSetString( rui, "probabilityDescText", Localize( "#PACK_BUNDLE_LEGEND_THEMATIC_PROBABILITIES_DESC" ) )
			RuiSetString( rui, "itemProbabilitiesBlob", Localize( "#PACK_BUNDLE_LEGEND_THEMATIC_ITEM_PROBABILITIES_BLOB" ) )
			RuiSetString( rui, "generalItemContentDetails3", Localize( "#PACK_BUNDLE_LEGEND_THEMATIC_ITEM_DETAILS_3" ) )
			RuiSetString( rui, "generalItemContentDetails4", Localize( "#PACK_BUNDLE_LEGEND_THEMATIC_ITEM_DETAILS_4" ) )
			RuiSetString( rui, "generalItemContentDetails5", Localize( "#PACK_BUNDLE_LEGEND_THEMATIC_ITEM_DETAILS_5" ) )
		}
		else if ( ItemFlavor_GetType( expect ItemFlavor( packTheme ) ) == eItemType.weapon_category )
		{
			RuiSetString( rui, "probabilityDescText", Localize( "#PACK_BUNDLE_WEAPON_THEMATIC_PROBABILITIES_DESC" ) )
			RuiSetString( rui, "itemProbabilitiesBlob", Localize( "#PACK_BUNDLE_WEAPON_THEMATIC_ITEM_PROBABILITIES_BLOB" ) )
			RuiSetString( rui, "generalItemContentDetails3", Localize( "#PACK_BUNDLE_WEAPON_THEMATIC_ITEM_DETAILS_3" ) )
			RuiSetString( rui, "generalItemContentDetails4", Localize( "#PACK_BUNDLE_WEAPON_THEMATIC_ITEM_DETAILS_4" ) )
			RuiSetString( rui, "generalItemContentDetails5", Localize( "#PACK_BUNDLE_WEAPON_THEMATIC_ITEM_DETAILS_5" ) )
		}
	}
}

void function PurchaseDialog( PurchaseDialogConfig cfg )
{
	Assert( GRX_IsInventoryReady() )
	if ( file.status != ePurchaseDialogStatus.INACTIVE )
		return

	PurchaseDialogState state
	file.state = state
	file.status = ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION
	file.state.cfg = cfg
	file.activeDialog = file.genericPurchaseDialog
	file.activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	Hud_SetVisible( file.giftButton, false )
	file.isMultipackDisclosure = false
	file.isAllApexPacks = false

	bool hasApexPack = false
	bool hasSirngePack = false
	bool hasEventPack = false
	bool hasThematicPack = false
	bool hasEventThematicPack = false
	bool isOnlyPackOffer = false
	string specialPackName = ""

	bool hasStickers = false
	bool hasSkydives = false
	bool hasHolosprays = false
	bool isBattlepass = false
	bool usesMOTDButtonForCount = false
	file.isGiftableLegend = false
	file.isGiftableOnly = false

	array<ItemFlavor> packFlavors

	if ( cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(cfg.flav)
		printt( "PurchaseDialog", string(ItemFlavor_GetAsset( flav )) )
		Assert( ItemFlavor_GetGRXMode( flav ) != GRX_ITEMFLAVORMODE_NONE )

		if ( ItemFlavor_GetType( flav ) == eItemType.character )
		{
			Hud_SetVisible( file.giftButton, true )
			file.isGiftableLegend = true
		}

		if ( ItemFlavor_IsItemDisabledForGRX( flav ) )
		{
			EmitUISound( "menu_deny" )
			return
		}

		if ( ItemFlavor_GetGRXMode( flav ) == GRX_ITEMFLAVORMODE_REGULAR && GRX_IsItemOwnedByPlayer( flav ) )
		{
			Assert( false, "Called PurchaseDialog with an already-owned item: " + string(ItemFlavor_GetAsset( flav )) )
			EmitUISound( "menu_deny" )
			return
		}

		uiGlobal.menuData[ file.activeDialog ].pin_metaData[ "item_name" ] <- ItemFlavor_GetHumanReadableRefForPIN_Slow( flav )

		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( flav )
		Assert( ifpi.isPurchasableAtAll )

		if ( ifpi.craftingOfferOrNull != null )
			file.state.purchaseOfferList.append( GRX_ScriptOfferFromCraftingOffer( expect GRXScriptCraftingOffer(ifpi.craftingOfferOrNull) ) )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
				if ( locationOffer.offerType != GRX_OFFERTYPE_BUNDLE && locationOffer.output.flavors.len() == 1 )
					file.state.purchaseOfferList.append( locationOffer )

	}
	else if ( cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(cfg.offer)
		printt( "PurchaseDialog", DEV_GRX_DescribeOffer( offer ) )
		Hud_SetVisible( file.giftButton, false )

		if ( GRXOffer_IsFullyClaimed( offer ) && cfg.friend == null && offer.offerType != 0 )
		{
			Assert( false, "Called PurchaseDialog with an already-fully-claimed offer: " + DEV_GRX_DescribeOffer( offer ) )
			EmitUISound( "menu_deny" )
			return
		}


		uiGlobal.menuData[ file.activeDialog ].pin_metaData[ "item_name" ] <- offer.offerAlias
		SetCachedOfferAlias( offer.offerAlias )

		foreach ( GRXStoreOfferItem item in offer.items )
		{
			ItemFlavor itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )

			if ( ItemFlavor_GetType( itemFlav ) == eItemType.account_pack )
			{
				packFlavors.append( itemFlav )
			}
		}

		if ( GRXOffer_ContainsPack( offer ) )
		{
			bool hasPurchaseLimit = offer.purchaseLimit > 0

			isOnlyPackOffer = GRXOffer_ContainsOnlySinglePack( offer )
			hasApexPack = GRXOffer_ContainsApexPack( offer )
			
			hasSirngePack = GRXOffer_ContainsSirngePack( offer )
			hasEventPack = GRXOffer_ContainsEventPack( offer )
			hasThematicPack = GRXOffer_ContainsThematicPack( offer )
			hasEventThematicPack = GRXOffer_ContainsEventThematicPack( offer )
			specialPackName = Localize( GRXOffer_GetSpecialPackName( offer ) )
			file.isAllApexPacks = !hasEventPack && !hasThematicPack && !hasEventThematicPack && !hasSirngePack && hasApexPack

			bool isEventPackPurchaseOffer = isOnlyPackOffer && hasEventPack
			bool isApexPackPurchaseOffer = isOnlyPackOffer && !hasPurchaseLimit && !hasSirngePack && hasApexPack
			if ( isApexPackPurchaseOffer || isEventPackPurchaseOffer )
			{
				file.activeDialog = file.packPurchaseDialog
				RuiSetBool( Hud_GetRui( Hud_GetChild( file.activeDialog, "DialogBackground" ) ) , "isPackSelection", true )
			}
			else if ( packFlavors.len() > 1 && !file.isAllApexPacks && !hasSirngePack )
			{
				file.activeDialog = file.multiPackBundlePurchaseDialog
				file.isMultipackDisclosure = true
				RuiSetBool( Hud_GetRui( Hud_GetChild( file.activeDialog, "DialogBackground" ) ) , "isPackSelection", false )
			}
			else if( !hasSirngePack )
			{
				file.activeDialog = file.packBundlePurchaseDialog
				RuiSetBool( Hud_GetRui( Hud_GetChild( file.activeDialog, "DialogBackground" ) ) , "isPackSelection", false )
			}

			hasStickers = GRXOffer_GetSpecialPackContainsStickers( offer )
			hasSkydives = GRXOffer_GetSpecialPackContainsSkydives( offer )
			hasHolosprays = GRXOffer_GetSpecialPackContainsHolosprays( offer )
			usesMOTDButtonForCount = GRXOffer_GetSpecialPackCountShownOnMOTD( offer )
		}

		if ( GRX_IsLegendOffer( offer ) )
		{
			Hud_SetVisible( file.giftButton, true )
			file.isGiftableLegend = true
			file.isGiftableOnly = GRX_IsItemOwnedByPlayer( offer.output.flavors[0] )
		}

		file.state.purchaseOfferList.append( offer )
	}
	else
	{
		Assert( false, "Called PurchaseDialog with no flav or offer" )
		return
	}

	DialogElementReferencesConfig dialogRefConfig
	dialogRefConfig.hasEventPack           = hasEventPack
	dialogRefConfig.hasThematicPack        = hasThematicPack
	dialogRefConfig.hasEventThematicPack   = hasEventThematicPack
	dialogRefConfig.hasStickers            = hasStickers
	dialogRefConfig.hasSkydives            = hasSkydives
	dialogRefConfig.hasHolosprays          = hasHolosprays
	dialogRefConfig.usesMOTDButtonForCount = usesMOTDButtonForCount
	dialogRefConfig.disclaimerSpecifics    = specialPackName

	UpdateDialogElementReferences( dialogRefConfig, packFlavors )

	if ( !file.isMultipackDisclosure )
	{
		if ( hasEventPack && file.dialogContent == Hud_GetChild( file.activeDialog, "EventDialogContent" ) )
		{
			var rui                 = Hud_GetRui( file.dialogContent )
			string currentEventName = Localize( ItemFlavor_GetLongName( expect ItemFlavor( file.activeCollectionEvent ) ) )

			ItemFlavor chaseItem = HeirloomEvent_GetPrimaryCompletionRewardItem( expect ItemFlavor( file.activeCollectionEvent ) )
			string nameText = Localize( ItemFlavor_GetLongName( chaseItem ) )

			RuiSetString( rui, "probabilityDescText", Localize( "#COLLECTION_EVENT_PACK_SUBHEADER", currentEventName ) )
			RuiSetString( rui, "itemDetailsText3", Localize( "#COLLECTION_EVENT_DISCLAIMER_1", currentEventName ) )
			RuiSetString( rui, "itemDetailsText4", Localize( "#COLLECTION_EVENT_DISCLAIMER_2", currentEventName ) )
			RuiSetString( rui, "itemDetailsText5", Localize( "#COLLECTION_EVENT_DISCLAIMER_3", currentEventName, nameText ) )
			RuiSetString( rui, "eventItemDetails", Localize( "#COLLECTION_EVENT_PACK_EVENT_ITEM", currentEventName ) )
		}
	}

	if ( file.state.cfg.isCupsReRoll )
		EmitUISound( "RumbleCup_UI_ReRoll_1p" )
	else
		EmitUISound( "UI_Menu_Cosmetic_Unlock" )

	AdvanceMenu( file.activeDialog )
}

bool function IsUserAwaitingForConfirmation()
{
	return file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION
}

void function GotoPremiumStoreTab()
{
	Assert( IsLobby() )

	if ( GetActiveMenu() == GetMenu( "ConfirmPurchaseDialog" ) || GetActiveMenu() == GetMenu( "ConfirmPackBundlePurchaseDialog" ) )
		CloseActiveMenu()

	OpenVCPopUp( null )
}

void function PurchaseButton_Activate( var button )
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	if ( Hud_IsLocked( button ) || GRX_QueuedOperationMayDirtyOffers() )
		return

	if ( file.state.cfg.isGiftPack && !IsPlayerWithinGiftingLimit() )
		return

	if ( !( button in file.state.purchaseButtonOfferMap ) && file.state.cfg.deepLinkConfig != null )
	{
		PurchaseDialogDeepLinkConfig pdlc = expect PurchaseDialogDeepLinkConfig( file.state.cfg.deepLinkConfig )

		if ( pdlc.onPurchaseCallback != null )
			pdlc.onPurchaseCallback()
		return
	}

	GRXScriptOffer offer = file.state.purchaseButtonOfferMap[button]
	ItemFlavorBag price  = file.state.purchaseButtonPriceMap[button]

	bool isPremiumOnly = GRX_IsPremiumPrice( price )
	int quantity       = file.state.cfg.quantity
	bool canAfford     = ( !Escrow_IsPlayerTrusted() && HasEscrowBalance() ) ? GRX_CanAfford( price, quantity, file.state.cfg.isGiftPack ) : GRX_CanAfford( price, quantity)
	bool hasPack 	   = GRXOffer_ContainsPack( offer )
	bool isOnlyPack	   = GRXOffer_ContainsOnlySinglePack( offer )

	if ( isPremiumOnly && !canAfford && hasPack )
	{
		GotoPremiumStoreTab()
		return
	}

	if ( isOnlyPack && file.state.cfg.isGiftPack && file.state.cfg.friend == null )
	{
		if ( GRX_IsOfferRestricted() )
		{
			EmitUISound( "menu_deny" )
			return
		}

		int buttonId = int(Hud_GetScriptID( file.activePackQuantityButton ))
		GRXScriptOffer giftOffer
		array<GRXScriptOffer> ornull collectionOffers
		array<GRXScriptOffer> packOffers

		if ( GetLootTickPurchaseOffers() != null )
			packOffers = expect array<GRXScriptOffer>( GetLootTickPurchaseOffers() )
		if ( file.activeCollectionEvent != null )
		{
			ItemFlavor event = expect ItemFlavor( file.activeCollectionEvent )
			if ( CollectionEvent_GetPackOffers( event ) != null )
				collectionOffers = CollectionEvent_GetPackOffers( event )
		}

		if ( expect GRXScriptOffer( file.state.cfg.offer ).offerAlias != packOffers[0].offerAlias )
		{
			if ( collectionOffers != null )
				packOffers = expect array<GRXScriptOffer>( collectionOffers )
			else
			{
				printf( "cfg offer was not a Regular Pack offer and Packs from Collection Events were null" )
				CloseActiveMenu()
				return
			}
		}

		if ( buttonId > packOffers.len() - 1  )
		{
			EmitUISound( "menu_deny" )
			printf( "Tried to gift pack offer index %i but does not exist", buttonId )
			return
		}

		if ( offer.offerAlias == packOffers[0].offerAlias )
			giftOffer = packOffers[buttonId]

		OpenGiftingDialog( giftOffer )
		return
	}

	file.status = ePurchaseDialogStatus.WORKING

	int queryGoal
	if ( offer.isCraftingOffer )
	{
		queryGoal = GRX_HTTPQUERYGOAL_CRAFT_ITEM
	}
	else if ( file.state.cfg.friend != null )
	{
		queryGoal = GRX_HTTPQUERYGOAL_GIFT_OFFER
	}
	else if ( offer.offerType == GRX_OFFERTYPE_BUNDLE )
	{
		queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_BUNDLE_OFFER
	}
	else
	{
		queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_STORE_OFFER

		if ( file.state.cfg.flav != null )
		{
			int itemType = ItemFlavor_GetType( expect ItemFlavor(file.state.cfg.flav) )
			if ( itemType == eItemType.character )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_CHARACTER
			else if ( itemType == eItemType.account_pack )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_PACK
		}
	}

	ScriptGRXOperationInfo operation
	operation.expectedQueryGoal = queryGoal
	operation.doOperationFunc = (void function( int opId ) : (queryGoal, offer, price, quantity) {
		GRX_PurchaseOffer( opId, queryGoal, offer, price, quantity, file.state.cfg.friend )
	})
	operation.onDoneCallback = (void function( int status ) : ( offer, price, quantity )
	{
		OnPurchaseOperationFinished( status, offer, price, quantity )
	})

	if ( file.state.cfg.onPurchaseStartCallback != null )
	{
		file.state.cfg.onPurchaseStartCallback()
		file.state.cfg.onPurchaseStartCallback = null
	}

	QueueGRXOperation( GetLocalClientPlayer(), operation )

	UpdateProcessingElements()
	HudElem_SetRuiArg( button, "isProcessing", true )
	file.blockInput = true
}

void function PackQuantitySelectButton_Activate( var button )
{
	int quantity = 1
	int id = int(Hud_GetScriptID( button ))
	GRXScriptOffer ornull lootOffer = expect array<GRXScriptOffer>( GetLootTickPurchaseOffers() )[0]
	if ( expect GRXScriptOffer(file.state.cfg.offer).offerAlias == expect GRXScriptOffer( lootOffer ).offerAlias )
		quantity = PACK_QUANTITIES[id]
	else
		quantity = PACK_EVENT_QUANTITIES[id]

	file.state.cfg.quantity = quantity

	if ( file.activePackQuantityButton != button )
	{
		HudElem_SetRuiArg( button, "isSelected", true )
		if ( file.activePackQuantityButton != null )
			HudElem_SetRuiArg( file.activePackQuantityButton , "isSelected", false )
	}

	file.activePackQuantityButton = button
	UpdatePurchaseDialog()

	if ( file.activeCollectionEvent != null )
		UpdateCollectionPackPurchaseButton( quantity )
}

void function CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}

void function AcButton_Activate( var button )
{
	GotoPremiumStoreTab()
	PIN_Store_Message( PIN_MESSAGE_TYPE_AC, ePINPromoMessageStatus.CLICK )
}

void function PackButton_Activate( var button )
{
	JumpToStorePacks()
	PIN_Store_Message( PIN_MESSAGE_TYPE_PACKS, ePINPromoMessageStatus.CLICK )
}

void function UpdateProcessingElements()
{
	bool isWorking = (file.status == ePurchaseDialogStatus.WORKING)

	Hud_SetEnabled( file.cancelButton, !isWorking )
	HudElem_SetRuiArg( file.cancelButton, "isProcessing", isWorking )
	HudElem_SetRuiArg( file.cancelButton, "processingState", file.status )

	foreach ( button in file.purchaseButtonBottomToTopList )
	{
		Hud_SetEnabled( button, !isWorking )
		HudElem_SetRuiArg( button, "isProcessing", false )
	}

	Hud_SetEnabled( file.giftButton, !isWorking )
	HudElem_SetRuiArg( file.giftButton, "isProcessing", isWorking )

	if ( file.activeDialog == file.packPurchaseDialog )
	{
		foreach ( var button in file.packQuantityButtons )
			Hud_SetEnabled( button, !isWorking )
	}
}


void function OnPurchaseOperationFinished( int status, GRXScriptOffer offer, ItemFlavorBag price, int quantity )
{
	bool wasSuccessful = (status == eScriptGRXOperationStatus.DONE_SUCCESS)

	file.status = (wasSuccessful ? ePurchaseDialogStatus.FINISHED_SUCCESS : ePurchaseDialogStatus.FINISHED_FAILURE)

	if ( wasSuccessful )
	{
		offer.purchaseCount += quantity
		if ( GRXOffer_IsPurchaseLimitReached( offer ) )
		{
			offer.ineligibilityCode = eIneligibilityCode.PURCHASE_LIMIT
		}

		
		foreach ( item in offer.items )
		{
			ItemFlavor itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )
			if ( Mythics_IsItemFlavorMythicSkin( itemFlav ) )
			{
				Remote_ServerCallFunction( "ClientCallback_UpdateMythicChallenges" )
				break
			}
		}

		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )

		string purchaseSound
		if ( file.state.cfg.purchaseSoundOverride != null )
		{
			purchaseSound = expect string(file.state.cfg.purchaseSoundOverride)
		}
		else
		{
			int lowestCurrencyIndex = GRX_CURRENCY_COUNT
			foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
			{
				
				
				if ( GRXCurrency_GetCurrencyIndex( costFlav ) < lowestCurrencyIndex )
					lowestCurrencyIndex = GRXCurrency_GetCurrencyIndex( costFlav )
			}

			if ( lowestCurrencyIndex != GRX_CURRENCY_COUNT )
				purchaseSound = GRXCurrency_GetPurchaseSound( GRX_CURRENCIES[lowestCurrencyIndex] )
		}
		if ( purchaseSound != "" )
			EmitUISound( purchaseSound )


			if ( file.state.cfg.isCupsReRoll )
			{
				SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
				Remote_ServerCallFunction( "ClientCallback_ReRollCup", cupId )
			}

	}
	else
	{
		EmitUISound( "menu_deny" )
	}

	if ( file.state.cfg.markAsNew )
	{
		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			Newness_TEMP_MarkItemAsNewAndInformServer( outputFlav )
	}

	if ( file.state.cfg.onPurchaseResultCallback != null )
	{
		file.state.cfg.onPurchaseResultCallback( wasSuccessful )
		file.state.cfg.onPurchaseResultCallback = null
	}

	thread ReportStatusAndClose( file.status )
}


void function ReportStatusAndClose( int processingState )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	EndSignal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )

	OnThreadEnd( function() : (  ) {
		file.blockInput = false
		file.status = ePurchaseDialogStatus.INACTIVE
	} )

	HudElem_SetRuiArg( file.cancelButton, "processingState", processingState )

	wait 1.6
	file.blockInput = false

	if ( GetActiveMenu() == file.activeDialog )
	{
		thread CloseActiveMenu()
		file.status = ePurchaseDialogStatus.INACTIVE
	}
}


void function ConfirmPurchaseDialog_OnOpen()
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePurchaseDialog )

	file.activePackQuantityButton = file.packQuantityButtons[0]
	RuiSetBool( Hud_GetRui( file.activePackQuantityButton ) , "isSelected", true )
	Hud_SetFocused( file.activePackQuantityButton )
}

void function UpdatePurchaseDialog()
{
	if ( file.status != ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )
		return

	int quality        = eRarityTier.COMMON
	string qualityText = ""
	string messageText = "#PURCHASE"
	string prereqText = ""
	string devDesc

	if ( file.state.cfg.messageOverride != null )
	{
		messageText = expect string(file.state.cfg.messageOverride)
	}
	else if ( file.state.cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(file.state.cfg.flav)
		devDesc = string(ItemFlavor_GetAsset( flav ))

		string flavName = Localize( ItemFlavor_GetLongName( flav ) )
		quality = ItemFlavor_HasQuality( flav ) ? ItemFlavor_GetQuality( flav ) : 0
		qualityText = Localize( ItemQuality_GetQualityName( quality ) )

		switch ( ItemFlavor_GetType( flav ) )
		{
			case eItemType.gladiator_card_intro_quip:
			case eItemType.gladiator_card_kill_quip:
				messageText = Localize( "#QUOTE_STRING", flavName )
				break

			case eItemType.character:
				messageText = flavName
				break

			case eItemType.voucher:
			case eItemType.battlepass_purchased_xp:
				if ( file.state.cfg.quantity > 1 )
					messageText = Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity )
				else
					messageText = flavName
				break

			default:
				if ( file.state.cfg.quantity > 1 )
					messageText =  Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity )
				else
					messageText = flavName
				break
		}
		if ( ItemFlavor_IsBattlepass( flav ) )
		{
			qualityText = ItemQuality_GetBattlePassQualityName( flav )
			quality = eRarityTier.COMMON
		}
	}
	else if ( file.state.cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(file.state.cfg.offer)
		devDesc = DEV_GRX_DescribeOffer( offer )

		messageText = offer.titleText
		prereqText = offer.prereqText

		quality = eRarityTier.COMMON

		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			quality = maxint( quality, ItemFlavor_GetQuality( outputFlav, 0 ) )

		qualityText = Localize( ItemQuality_GetQualityName( quality ) )

		if ( file.activeDialog == file.packPurchaseDialog )
		{
			UpdatePackQuantitySelectionButtons()
			HudElem_SetRuiArg( Hud_GetChild( file.activeDialog, "PackPurchaseBackground" ), "isBundle", false )
		}
	}

	printt( "UpdatePurchaseDialog", devDesc )

	if ( file.isMultipackDisclosure )
	{
		HudElem_SetRuiArg( file.dialogHeader, "quality", quality )
		HudElem_SetRuiArg( file.dialogHeader, "qualityText", Localize( qualityText ) )
		HudElem_SetRuiArg( file.dialogHeader, "quantity", file.state.cfg.quantity )
		HudElem_SetRuiArg( file.dialogHeader, "messageText", messageText )
	}
	else
	{
		HudElem_SetRuiArg( file.dialogContent, "quality", quality )
		HudElem_SetRuiArg( file.dialogContent, "qualityText", Localize( qualityText ) )
		HudElem_SetRuiArg( file.dialogContent, "quantity", file.state.cfg.quantity )
	}

	HudElem_SetRuiArg( file.dialogContent, "giftRecipient", "" )

	if ( file.state.cfg.isGiftPack )
		HudElem_SetRuiArg( file.dialogContent, "headerText", "#BUY_GIFT" )
	else if ( file.state.cfg.friend != null )
	{
		GiftingFriend recipient = expect GiftingFriend ( file.state.cfg.friend )
		EadpPeopleList eadFriendlist = EADP_GetFriendsListWithOffline()
		string gifterName = GetFriendNameFromNucleusPId( recipient.activeNucleusPersonaId, eadFriendlist.people )

		if ( file.isMultipackDisclosure  )
		{
			HudElem_SetRuiArg( file.dialogHeader, "headerText", "#CONFIRM_PURCHASE_HEADER" )
		}
		else
		{
			HudElem_SetRuiArg( file.dialogContent, "headerText", "#BUY_GIFT" )
		}

		HudElem_SetRuiArg( file.dialogContent, "giftRecipient", gifterName )
	}
	else
	{
		if ( file.isMultipackDisclosure  )
		{
			HudElem_SetRuiArg( file.dialogHeader, "headerText", "#CONFIRM_PURCHASE_HEADER" )
		}
		else
		{
			HudElem_SetRuiArg( file.dialogContent, "headerText", "#CONFIRM_PURCHASE_HEADER" )
		}

	}

	if ( file.isMultipackDisclosure )
	{
		HudElem_SetRuiArg( file.dialogHeader, "messageText", messageText )
	}
	else
	{
		HudElem_SetRuiArg( file.dialogContent, "messageText", messageText )
	}

	HudElem_SetRuiArg( file.dialogContent, "reqsText", prereqText )


		if ( file.activeDialog == file.genericPurchaseDialog )
			HudElem_SetRuiArg( file.dialogContent, "reRollsAmount", "" )
		if ( file.state.cfg.isCupsReRoll && Cups_IsValidCupID( RTKApexCupsOverview_GetCupID() ) )
		{
			SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
			CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

			CupEntry entry = expect CupEntry ( file.state.cfg.entry )

			if ( cupData.maximumNumberOfReRolls > entry.reRollCount  )
			{
				HudElem_SetRuiArg( file.dialogContent, "quality", 3 )
				HudElem_SetRuiArg( file.dialogContent, "headerText", Localize( "#CUPS_REROLL_DIALOG_HEADER" ) )

				CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

				int endTime       = CalEvent_GetFinishUnixTime( assetData.containerItemFlavor )
				int remainingTime = endTime - GetUnixTimestamp()

				HudElem_SetRuiArg( file.dialogContent, "qualityText", Localize("#TIME_REMAINING", RTKMutator_FormatTimeLong( remainingTime.tofloat() ) ) )

				if ( RankedRumble_IsCupRankedRumble( assetData.itemFlavor ) )
					HudElem_SetRuiArg( file.dialogContent, "reRollsAmount", Localize( "#CUPS_RANKED_REROLL_DIALOG_AMOUNT" ) )
				else

					HudElem_SetRuiArg( file.dialogContent, "reRollsAmount", Localize( "#CUPS_REROLL_DIALOG_AMOUNT", assetData.maximumNumberOfReRolls - entry.reRollCount ) )

			}
		}


	UpdateProcessingElements()

	int purchaseButtonIdx = 0
	file.state.purchaseButtonOfferMap.clear()
	file.state.purchaseButtonPriceMap.clear()

	array<GRXScriptOffer> offerList = clone file.state.purchaseOfferList
	bool isWithPack
	bool isMilestonePack
	array<bool> canAffordPremiumAndCraft = [true, true] 

	foreach ( GRXScriptOffer offer in offerList )
	{
		isWithPack = GRXOffer_ContainsPack( offer )
		isMilestonePack = GRXOffer_ContainsSirngePack( offer )
		array<ItemFlavorBag> priceList = clone offer.prices
		priceList.sort( int function( ItemFlavorBag a, ItemFlavorBag b ) {
			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) > GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return 1

			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) < GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return -1

			return 0
		} )

		priceList.reverse() 

		foreach ( ItemFlavorBag price in priceList )
		{
			Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", devDesc, file.purchaseButtonBottomToTopList.len() ) )
			if ( purchaseButtonIdx >= file.purchaseButtonBottomToTopList.len() )
				break

			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			
			if ( !file.state.cfg.isEventShopDialog && !offer.isCraftingOffer )
			{
				if ( ItemFlavor_GetTypeName( GetItemFlavorByGRXIndex( offer.items[0].itemIdx ) ) == "#itemtype_battlepass_purchased_xp_NAME" )
				{
					ItemFlavor ornull activeEventShop = EventShop_GetCurrentActiveEventShop()
					if ( activeEventShop != null )
					{
						if ( price.flavors[0] == EventShop_GetEventShopCurrency( expect ItemFlavor( activeEventShop ) ) )
							break
					}
				}
			}

			file.state.purchaseButtonOfferMap[button] <- offer
			file.state.purchaseButtonPriceMap[button] <- price

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", offer.isCraftingOffer ? "#CONFIRM_CRAFT_WITH" : "#CONFIRM_PURCHASE_WITH" )
			HudElem_SetRuiArg( button, "priceText", GRX_GetFormattedPrice( price, file.state.cfg.quantity ) )

			if ( IsTwoFactorAuthenticationEnabled() )
			{
				HudElem_SetRuiArg( file.giftButton, "priceText", GRX_GetFormattedPrice( price, file.state.cfg.quantity ) )
			}
			else
			{
				HudElem_SetRuiArg( file.giftButton, "priceText", "" )
			}

			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			if ( GRX_IsInventoryReady() )
			{
				SetPurchaseButtonAndTooltip( price, button, offer, canAffordPremiumAndCraft )
				isLoadingPrice = false
			}
			else
			{
				isLoadingPrice = true
				Hud_SetEnabled( button, false )
			}
			HudElem_SetRuiArg( button, "isLoadingPrice", isLoadingPrice )

			purchaseButtonIdx++
		}
	}

	if ( file.state.cfg.deepLinkConfig != null )
	{
		Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", devDesc, file.purchaseButtonBottomToTopList.len() ) )
		if ( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len() )
		{
			PurchaseDialogDeepLinkConfig pdlc = expect PurchaseDialogDeepLinkConfig( file.state.cfg.deepLinkConfig )
			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", pdlc.message )
			HudElem_SetRuiArg( button, "priceText", pdlc.priceText )
			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			Hud_SetEnabled( button, true )
			Hud_SetLocked( button, false )
			purchaseButtonIdx++
		}
	}

	int usedPurchaseButtonCount = purchaseButtonIdx

	if ( file.isGiftableOnly )
	{
		for ( int index = file.purchaseButtonBottomToTopList.len() - 1; index >= 0; index-- )
		{
			Hud_SetVisible( file.purchaseButtonBottomToTopList[ index ], false )
		}
	}
	else
	{
		for ( int index = file.purchaseButtonBottomToTopList.len() - 1; index >= 0; index-- )
		{
			Hud_SetVisible( file.purchaseButtonBottomToTopList[ index ], true )
		}
	}

	for ( int unusedPurchaseButtonIdx = purchaseButtonIdx; unusedPurchaseButtonIdx < file.purchaseButtonBottomToTopList.len(); unusedPurchaseButtonIdx++ )
		Hud_Hide( file.purchaseButtonBottomToTopList[unusedPurchaseButtonIdx] )

	int buttonHeight  = Hud_GetHeight( file.purchaseButtonBottomToTopList[0] )
	int buttonPadding = Hud_GetY( file.purchaseButtonBottomToTopList[0] )

	if ( file.activeDialog == file.packBundlePurchaseDialog || file.activeDialog == file.packPurchaseDialog || file.activeDialog == file.multiPackBundlePurchaseDialog )
		return
	UpdateAffordabilityAndButtonPositions( canAffordPremiumAndCraft, isWithPack, isMilestonePack, usedPurchaseButtonCount )
}

void function ConfirmPurchaseDialog_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseDialog )

	file.status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState state
	file.state = state

	if ( file.activePackQuantityButton != null )
		RuiSetBool( Hud_GetRui( file.activePackQuantityButton ) , "isSelected", false )

	file.activePackQuantityButton = file.packQuantityButtons[0]
	RuiSetBool( Hud_GetRui( file.activePackQuantityButton ) , "isSelected", true )

	UpdateProcessingElements()
	Signal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )
}

void function ConfirmPurchaseDialog_OnNavigateBack()
{
	if ( file.blockInput || file.status == ePurchaseDialogStatus.INACTIVE || file.status == ePurchaseDialogStatus.WORKING )
		return

	CloseActiveMenu()
}

void function UpdateButtonPositions( int state, int usedButtons = 0 )
{
	const float ruiScreenHeight = 1080.0
	UISize screen		= GetScreenSize()
	float yScale		= screen.height / ruiScreenHeight
	var rui = Hud_GetRui( file.dialogContent )
	RuiSetArg( rui, "buttonsUsed", usedButtons )

	Hud_Show( file.AcButton )
	Hud_SetVisible( file.packButton, !GRX_IsOfferRestricted() )

	RuiSetArg( rui, "showCoins", true )
	RuiSetArg( rui, "showPacks", !GRX_IsOfferRestricted() )

	const float singleButtonPremiumOffset = -70
	const float singleButtonCraftOffset = -150
	const float doubleButtonCraftOffset = -80
	const float tripleButtonOffset = 250
	const float giftingButtonOffset = -220
	const float	giftingACOffset = 25.5

	float yOffset = 0
	float giftYOffset = 0

	switch ( state )
	{
		case eButtonDisplayStatus.BOTH:

			if ( usedButtons == 1 )
				yOffset = singleButtonPremiumOffset * yScale
			break

		case eButtonDisplayStatus.ONLY_PACKS:
			RuiSetArg( rui, "showCoins", false )
			Hud_Hide( file.AcButton )
			if ( usedButtons == 1 )
				yOffset = singleButtonCraftOffset * yScale
			else if ( usedButtons == 2 )
				yOffset = doubleButtonCraftOffset * yScale
			break

		case eButtonDisplayStatus.ONLY_PREMIUM:
			RuiSetArg( rui, "showPacks", false )
			Hud_Hide( file.packButton )
			if ( usedButtons == 1 )
				yOffset = singleButtonPremiumOffset * yScale
			if ( usedButtons == 2 )
				yOffset = tripleButtonOffset * yScale
			break

		case eButtonDisplayStatus.NONE:
			Hud_Hide( file.AcButton )
			Hud_Hide( file.packButton )
			RuiSetArg( rui, "showCoins", false )
			RuiSetArg( rui, "showPacks", false )
			break
	}

	Hud_SetY( file.AcButton, Hud_GetBaseY( file.AcButton ) + yOffset )
	Hud_SetY( file.packButton, Hud_GetBaseY( file.packButton ) + yOffset )

	RuiSetBool( rui, "giftOnly", file.isGiftableOnly )

	if ( file.state.cfg.isCupsReRoll )
		RuiSetBool( rui, "giftOnly", true ) 

	if ( file.isGiftableOnly )
	{
		giftYOffset = giftingButtonOffset * yScale
		Hud_SetY( file.AcButton, Hud_GetBaseY( file.AcButton ) + giftingACOffset * yScale )
	}

	Hud_SetY( file.giftButton, Hud_GetBaseY( file.giftButton ) + giftYOffset )

	SetupPurchaseMenu( state )
}

string function GetExtraPurchaseTooltipInfo( ItemFlavor currency )
{
	switch ( currency )
	{
		case GRX_CURRENCIES[GRX_CURRENCY_CRAFTING]:
			return Localize( "#CANNOT_AFFORD_CRAFTING" )
		case GRX_CURRENCIES[GRX_CURRENCY_CREDITS]:
			return Localize( "#CANNOT_AFFORD_CREDITS" )
		case GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM]:
			return Localize( "#CANNOT_AFFORD_HEIRLOOM" )
	}
	return ""
}

string function GetCantAffordTooltipDesc( ItemFlavorBag price, string priceDeltaText, ItemFlavor currency, string currencyName )
{
	bool isPremiumNegativeBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) < 0
	bool isPremiumCurrency = false
	foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
	{
		if ( costFlav == GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
		{
			isPremiumCurrency = true
		}
	}

	return isPremiumNegativeBalance && isPremiumCurrency ? Localize( "#CANNOT_AFFORD_NEGATIVE", priceDeltaText, currencyName ) : Localize( "#CANNOT_AFFORD_DESC", priceDeltaText, currencyName ) + GetExtraPurchaseTooltipInfo( currency )
}

vector function GetTooltipAltDescColorFromCurrency( ItemFlavor currency )
{
	vector color = <1,1,1>
	switch ( currency )
	{
		case GRX_CURRENCIES[GRX_CURRENCY_CRAFTING]:
			color = SrgbToLinear( <40, 205, 205> / 255 )
			break
		case GRX_CURRENCIES[GRX_CURRENCY_CREDITS]:
			color = SrgbToLinear( <225, 87, 44> / 255 )
			break
		case GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]:
			color = SrgbToLinear( <250, 220, 28> / 255 )
			break
		case GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM]:
			color = SrgbToLinear( <255, 49, 13> / 255 )
			break
	}
	return color
}

void function SetPurchaseButtonAndTooltip( ItemFlavorBag price, var button, GRXScriptOffer offer, array<bool> canAffordPremiumAndCraft )
{

	bool canAfford     = GRX_CanAfford( price, file.state.cfg.quantity )
	bool isPremiumOnly = GRX_IsPremiumPrice( price )
	bool isWithPack = GRXOffer_ContainsPack( offer )
	bool isPremiumWithPack = isPremiumOnly && isWithPack

	string currencyName
	ItemFlavor currency
	array<int> priceArray = GRX_GetCurrencyArrayFromBag( price )

	ButtonCurrencyCheck( priceArray, canAffordPremiumAndCraft, canAfford, file.activeDialog )

	foreach ( currencyIndex, priceInt in priceArray )
	{
		if ( priceInt >= 0 )
		{
			currency = GRX_CURRENCIES[currencyIndex]
			currencyName = ItemFlavor_GetShortName( currency )
			break
		}
	}

	currencyName = Localize( currencyName )

	if ( file.activeCollectionEvent != null )
	{
		if ( offer.items.len() > 0 )
		{
			int itemIdx = offer.items[0].itemIdx
			ItemFlavor event = expect ItemFlavor(file.activeCollectionEvent)
			if ( CollectionEvent_IsItemFlavorFromEvent( event , itemIdx ) )
				canAffordPremiumAndCraft[1] = true 
		}
	}

		
		
		bool renameButtonToRedeem = false
		if ( IsOfferPartOfEventShop( offer ) )
		{
			if ( ItemFlavor_GetTypeName( GetItemFlavorByGRXIndex( offer.items[0].itemIdx ) ) == "#itemtype_battlepass_purchased_xp_NAME" )
				renameButtonToRedeem = file.state.cfg.isEventShopDialog
			else
				renameButtonToRedeem = true
		}
		else
			renameButtonToRedeem = false

		HudElem_SetRuiArg( button, "buttonText",  file.state.cfg.isGiftPack ? Localize( "#GIFT_DIALOG_SELECT_FRIEND" ) : ( renameButtonToRedeem ? Localize( "#REDEEM" ) : Localize("#PURCHASE" ) ) )

	
	
	
	bool buttonShouldBeLocked = ( offer.isAvailable && !canAfford || ( GRXOffer_IsFullyClaimed( offer ) || GRXOffer_IsPurchaseLimitReached( offer ) ) ) && ( !isPremiumWithPack || IsVerticalPurchaseLayout() )
	Hud_SetLocked( button, buttonShouldBeLocked )

	Hud_SetEnabled( button, true )
	Hud_ClearToolTipData( button )
	if ( !offer.isAvailable )
	{
		HudElem_SetRuiArg( button, "buttonText", "#UNAVAILABLE" )
	}
	else if ( !canAfford && isPremiumWithPack && !buttonShouldBeLocked )
	{
		HudElem_SetRuiArg( button, "buttonText", "#CONFIRM_GET_PREMIUM" )
	}
	else if ( !canAfford )
	{
		ToolTipData toolTipData
		ButtonToolTipCantAfford( toolTipData, button, price, file.state.cfg.quantity, currencyName, currency  )
	}

	Hud_ClearToolTipData( file.giftButton )
	bool canGift = CanLocalPlayerGift( offer )
	int giftsLeft = Gifting_GetRemainingDailyGifts()
	HudElem_SetRuiArg( file.giftButton, "descText", Localize( "#GIFTS_LEFT_FRACTION", giftsLeft ) )
	HudElem_SetRuiArg( file.giftButton, "buttonText", Localize( "#BUY_GIFT_STAR" ) )
	HudElem_SetRuiArg( file.giftButton, "canGift", canGift )

	Hud_SetEnabled( file.giftButton, false )
	Hud_SetLocked( file.giftButton, false )
	UpdateGiftButtonToolTip( file.giftButton, price, canAffordPremiumAndCraft, file.activeDialog, file.state.cfg.quantity, file.isMultipackDisclosure, false )
}

void function UpdateAffordabilityAndButtonPositions( array<bool> canAffordPremiumAndCraft, bool isWithPack, bool isMilestonePack, int usedPurchaseButtonCount )
{
	if ( !isWithPack )
	{
		int buttonDisplayState
		if( canAffordPremiumAndCraft[0] && !canAffordPremiumAndCraft[1] )
			buttonDisplayState = eButtonDisplayStatus.ONLY_PACKS
		else if ( !canAffordPremiumAndCraft[0] && canAffordPremiumAndCraft[1] )
			buttonDisplayState = eButtonDisplayStatus.ONLY_PREMIUM
		else if ( !canAffordPremiumAndCraft[1] && !canAffordPremiumAndCraft[0] )
			buttonDisplayState = eButtonDisplayStatus.BOTH
		else
			buttonDisplayState = eButtonDisplayStatus.NONE

		if ( !canAffordPremiumAndCraft[0] )
			Hud_SetLocked( file.giftButton, true )
		else
			Hud_SetLocked( file.giftButton, false )

		UpdateButtonPositions( buttonDisplayState, usedPurchaseButtonCount )
	}
	else
	{
		if ( isMilestonePack )
		{
			if ( !canAffordPremiumAndCraft[0] )
				UpdateButtonPositions( eButtonDisplayStatus.ONLY_PREMIUM, usedPurchaseButtonCount )
			else
				UpdateButtonPositions( eButtonDisplayStatus.NONE, usedPurchaseButtonCount )
		}
		else
		{
			UpdateButtonPositions( eButtonDisplayStatus.NONE )
		}
	}
}

bool function IsVerticalPurchaseLayout()
{
	return GetActiveMenuName() == "ConfirmPurchaseDialog"
}

void function UpdatePackQuantitySelectionButtons()
{
	int quantity = 1
	if ( !GRX_IsInventoryReady() )
		return
	GRXScriptOffer ornull lootOffer = expect array<GRXScriptOffer>( GetLootTickPurchaseOffers() )[0]
	GRXScriptOffer offer = expect GRXScriptOffer( file.state.cfg.offer )
	foreach ( int i, var button in file.packQuantityButtons )
	{
		Hud_ClearToolTipData( button )
		if ( offer.offerAlias == expect GRXScriptOffer( lootOffer ).offerAlias )
		{
			quantity = PACK_QUANTITIES[i]
			Hud_SetLocked( button, false )
		}
		else
		{
			quantity = PACK_EVENT_QUANTITIES[i]
			Hud_SetLocked( button, false )
			if ( !file.state.cfg.isGiftPack )
			{
				int currentMaxEventPackPurchaseCount
				bool cannotBuy
				ItemFlavor activeEvent

				if ( file.activeCollectionEvent == null  )
				{
					if ( GRXOffer_ContainsEventThematicPack( offer ) != false )
					{
						GRX_PackCollectionInfo colInfo = GRXOffer_GetEventThematicPackCollectionInfoFromScriptOffer( offer )

						currentMaxEventPackPurchaseCount = colInfo.numTotalInCollection
						cannotBuy = quantity > currentMaxEventPackPurchaseCount - colInfo.numCollected

					}
					else
						return
				}
				else
				{
					activeEvent = expect ItemFlavor( file.activeCollectionEvent )

					currentMaxEventPackPurchaseCount = CollectionEvent_GetCurrentMaxEventPackPurchaseCount( activeEvent , GetLocalClientPlayer() )
					cannotBuy = quantity > currentMaxEventPackPurchaseCount
				}

				if ( cannotBuy )
				{
					ToolTipData toolTipData
					toolTipData.titleText = Localize( "#CANNOT_PURCHASE" ).toupper()
					toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.SOLID
					toolTipData.tooltipStyle = eTooltipStyle.STORE_CONFIRM
					toolTipData.storeTooltipData.tooltipAltDescColor = SrgbToLinear( TOOLTIP_COLOR_ORANGE / 255 )

					if ( file.activeCollectionEvent != null )
						toolTipData.descText = Localize( "#COLLECTION_CANNOT_PURCHASE_DESC", currentMaxEventPackPurchaseCount, HeirloomEvent_GetItemCount( activeEvent, false ) )
					else
						toolTipData.descText = ""

					Hud_SetToolTipData( button, toolTipData )
				}

				Hud_SetLocked( button, cannotBuy )
			}
		}
		if ( quantity > 1 )
			HudElem_SetRuiArg( button, "buttonText", Localize( "#N_APEX_PACKS", quantity ) )
		else
			HudElem_SetRuiArg( button, "buttonText", Localize( "#N_APEX_PACK", quantity ) )

		HudElem_SetRuiArg( button, "buttonBottomText", GRX_GetFormattedPrice( offer.prices[0], quantity ) )
	}
}

void function UpdateCollectionPackPurchaseButton( int quantity )
{
	if ( file.state.cfg.isGiftPack )
		return

	ItemFlavor event = expect ItemFlavor( file.activeCollectionEvent )
	array<GRXScriptOffer> ornull eventPackOffers = CollectionEvent_GetPackOffers( event )
	if ( eventPackOffers != null )
	{
		if ( file.state.cfg.offer == expect array<GRXScriptOffer>( eventPackOffers )[0] )
		{
			bool isPurchasable = quantity <= CollectionEvent_GetCurrentMaxEventPackPurchaseCount( event , GetLocalClientPlayer() )

			if ( isPurchasable && file.state.cfg.offer != null )
			{
				isPurchasable = GRXOffer_IsEligibleForPurchase( expect GRXScriptOffer( file.state.cfg.offer ) )
			}

			Hud_SetLocked( file.purchaseButtonBottomToTopList[0], !isPurchasable )
		}
	}
}

void function GiftButton_Activate( var button )
{
	if ( file.blockInput )
		return

	if ( file.state.cfg.flav == null && file.state.cfg.offer == null )
		return

	if ( !IsTwoFactorAuthenticationEnabled() )
	{
		OpenTwoFactorInfoDialog( button )
		return
	}

	if ( !IsPlayerWithinGiftingLimit() )
		return

	if ( file.state.cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor( file.state.cfg.flav )
		GRXScriptOffer offer = GRX_GetItemDedicatedStoreOffers( flav, "character" )[0]
		OpenGiftingDialog( offer )
	}
	else
		OpenGiftingDialog( expect GRXScriptOffer( file.state.cfg.offer ) )
}

void function UpdateGiftButtonToolTip( var giftButton, ItemFlavorBag price, array<bool> canAffordPremiumAndCraft, var activeDialog, int quantity, bool multipackDisclosure, bool inspectButton )
{
	bool canAfford     = GRX_CanAfford( price, file.state.cfg.quantity )
	string currencyName
	ItemFlavor currency
	array<int> priceArray = GRX_GetCurrencyArrayFromBag( price )

	ButtonCurrencyCheck( priceArray, canAffordPremiumAndCraft, canAfford, activeDialog )

	foreach ( currencyIndex, priceInt in priceArray )
	{
		if ( priceInt >= 0 )
		{
			currency = GRX_CURRENCIES[currencyIndex]
			currencyName = ItemFlavor_GetShortName( currency )
			break
		}
	}
	currencyName = Localize( currencyName )

	ToolTipData giftToolTipData

	if ( !IsTwoFactorAuthenticationEnabled() )
	{
		GiftButtonToolTipTwoFactor( giftToolTipData, giftButton, inspectButton )
	}
	else if ( !IsPlayerWithinGiftingLimit() )
	{
		GiftButtonToolTipGiftingLimit( giftToolTipData, giftButton )
	}
	else if( !IsPlayerLeveledForGifting() )
	{
		GiftButtonToolTipNotHighEnoughLevel( giftButton )
	}
	else if ( !canAfford )
	{
		ButtonToolTipCantAfford( giftToolTipData, giftButton, price, quantity, currencyName, currency, true )
	}
	else
	{
		Hud_SetEnabled( giftButton, true )
	}
}

void function ButtonCurrencyCheck( array<int> priceArray, array<bool> canAffordPremiumAndCraft, bool canAfford, var activeDialog  )
{
	foreach ( currencyIndex, priceInt in priceArray )
	{
		if ( priceInt < 0 )
			continue

		ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
		string currencyName = ItemFlavor_GetShortName( currency )

		if ( !canAfford )
		{
			if ( currency == GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
			{
				canAffordPremiumAndCraft[0] = false
			}
			else if ( currency == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
			{
				canAffordPremiumAndCraft[1] = false
			}
			else if ( currency == GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
			{
				canAffordPremiumAndCraft[1] = false
			}

			if ( file.isMultipackDisclosure )
			{
				break 
			}

			if ( activeDialog != null )
			{
				var rui = Hud_GetRui( Hud_GetChild( activeDialog, "DialogContent" ) )

				if ( currency == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
				{
					RuiSetString( rui, "getPacksDescText", "CONFIRM_COSMETIC_DESCRIPTION" )
				}
				else if ( currency == GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
				{
					RuiSetString( rui, "getPacksDescText", "CONFIRM_COSMETIC_HEIRLOOM_DESCRIPTION" )
				}
			}
		}

		break
	}
}

void function GiftButtonToolTipTwoFactor( ToolTipData giftToolTipData, var giftButton, bool inspectButton )
{
	giftToolTipData.titleText = Localize( "#ENABLE_TWO_FACTOR" )
	giftToolTipData.descText = Localize( "#TWO_FACTOR_NEEDED_DETAILS" )
	HudElem_SetRuiArg( giftButton, "buttonText", Localize( "#LOCKED_GIFT" ) )

	if ( inspectButton )
		HudElem_SetRuiArg( giftButton, "buttonDescText", Localize( "#TWO_FACTOR_NEEDED" ) )
	else
		HudElem_SetRuiArg( giftButton, "descText", Localize( "#TWO_FACTOR_NEEDED" ) )

	giftToolTipData.tooltipFlags = giftToolTipData.tooltipFlags | eToolTipFlag.SOLID
	giftToolTipData.tooltipStyle = eTooltipStyle.DEFAULT

	Hud_SetToolTipData( giftButton, giftToolTipData )
	Hud_SetEnabled( giftButton, true )
}

void function GiftButtonToolTipGiftingLimit( ToolTipData giftToolTipData, var giftButton )
{
	HudElem_SetRuiArg( giftButton, "buttonText", Localize( "#LOCKED_GIFT" ) )
	giftToolTipData.titleText =  Localize( "#GIFTS_LEFT", Gifting_GetRemainingDailyGifts() )
	DisplayTime giftTime = SecondsToDHMS( GRX_GetGiftingLimitResetDate() - GetUnixTimestamp() )

	if ( giftTime.hours > 0 )
		giftToolTipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_HOURS", string( GetGiftingMaxLimitPerResetPeriod() ), giftTime.hours )
	else if ( giftTime.minutes > 0 )
		giftToolTipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_MINUTES", string( GetGiftingMaxLimitPerResetPeriod() ), giftTime.minutes )
	else
		giftToolTipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_MINUTES", string( GetGiftingMaxLimitPerResetPeriod() ), "<1" )

	Hud_SetToolTipData( giftButton, giftToolTipData )
	Hud_SetLocked( giftButton, true )
}

void function ButtonToolTipCantAfford( ToolTipData toolTipData, var button, ItemFlavorBag price, int quantity, string currencyName, ItemFlavor currency, bool isGift = false )
{
	int priceDelta = GRX_CanAffordDelta( price, quantity )
	string priceDeltaText = FormatAndLocalizeNumber( "1", float( priceDelta ), true )

	if ( isGift )
		HudElem_SetRuiArg( button, "buttonText", Localize( "#LOCKED_GIFT" ) )

	toolTipData.titleText = "#CANNOT_AFFORD"
	toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.SOLID
	toolTipData.tooltipStyle = eTooltipStyle.STORE_CONFIRM
	toolTipData.storeTooltipData.tooltipAltDescColor = GetTooltipAltDescColorFromCurrency( currency )
	toolTipData.descText = GetCantAffordTooltipDesc( price, priceDeltaText, currency, currencyName )

	Hud_SetToolTipData( button, toolTipData )
}

void function GiftButtonToolTipNotHighEnoughLevel( var giftButton  )
{
	HudElem_SetRuiArg( giftButton, "buttonText", Localize( "#LOCKED_GIFT" ) )
	Hud_SetLocked( giftButton, true )
}
