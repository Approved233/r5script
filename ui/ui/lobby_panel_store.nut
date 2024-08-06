global function InitStorePanel
global function InitLootPanel
global function InitOffersPanel
global function InitSpecialsPanel
global function IsWalletModalOpened

global function OffersPanel_LevelShutdown

global function JumpToStoreTab
global function JumpToStoreOffer
global function JumpToStorePacks
global function JumpToHeirloomShop
global function JumpToStorePanel
global function JumpToStoreSection
global function JumpToMythicSection

global function OpenWalletInventoryModal
global function OpenVCPopUp
global function OpenExoticShardsModal
global function ToggleApexCoinsWalletModal
global function ToggleExoticShardsWalletModal

global function OnGRXStoreUpdate
global function GetLootTickPurchaseOffers
global function UpdatePackGiftButton
global function UpdateDisclaimer

global function GetBPPresaleOfferData
global function JumpToBPPresaleStoreOffer
global function OpenBPPresaleDialog

#if DEV
global function DEV_OffersPanel_DoFakeOffers
global function DEV_OffersPanel_DoFakeLayout
#endif


global function HasNewPersonalisedOffers
global function UpdateHotDropsTab


enum eStoreSection
{
	SHOP,
	LOOT,
	CHARACTERS,
	CURRECNY
}

const int MAX_FEATURED_OFFERS = 2
const int MAX_EXCLUSIVE_OFFERS = 2
const int MAX_OFFER_COLUMNS = 5

global const string FEATURED_STORE_PANEL = "ECPanel"
global const string SEASONAL_STORE_PANEL = "SeasonalPanel"
global const string SPECIALS_STORE_PANEL = "SpecialsPanel"
global const string PERSONALIZED_STORE_PANEL = "PersonalizedStorePanel"
global const string STORE_OFFER_SHOP = "StoreItemShop"
global const string STORE_MYTHIC_SHOP = "StoreMythicShop"
global const string STORE_SET_ITEM_SHOP = "StoreSetItemShop"
global const string RTK_APEX_PACKS_PANEL = "ApexPacksPanel"

global struct bpPresaleOfferData
{
	TabDef ornull offerTab = null
	GRXScriptOffer ornull basicOffer = null
	GRXScriptOffer ornull bundleOffer = null
}

enum bpPresaleOfferType
{
	NOT_PRESALE,
	BASIC,
	BUNDLE
}

struct
{
	var  storePanel
	bool tabsInitialized = false
	bool storeCacheValid = false
	var  tabBar
	var  hotDropsTab
	bool openDLCStoreCallbackCalled = false
	bool isOpened = false
	bool showStoreV2
	bool sortApexPacksFirst = false
	bool isWalletOpened = false

	var eventStoreButton

	GRXScriptOffer& TEMP_FOR_RTK_TESTING
	asset TEMP_FOR_RTK_TESTING2

#if DEV
		string DEV_fakeOffers_grxRef = ""
		string DEV_fakeOffers_seasonTag = ""
		int[MAX_OFFER_COLUMNS] DEV_fakeOffers_columnCounts = [1, 1, 1, 1, 1]
		int[MAX_OFFER_COLUMNS] DEV_fakeOffers_expireTime
#endif
} file

struct
{
	var                    panel
	var                    characterSelectInfoPanel
	var                    characterSelectInfoRui
	array<var>             buttons
	table<var, ItemFlavor> buttonToCharacter

	var allLegendsPanel

	var buttonWithFocus

	var characterDetailsPanel
	var characterDetailsRui

} s_characters

struct
{
	var lootPanel
	var lootButtonOpen
	var lootButtonPurchase
	var lootButtonGift
	var lootButtonInfo
	var lootButtonInfoInvis
	var lootPriceText

} s_loot


struct SeasonalStoreData
{
	string seasonTag = ""
	asset  tallImage = $""
	asset  squareImage = $""
	asset  tallFrameOverlayImage = $""
	asset  squareFrameOverlayImage = $""
	asset  specialPageHeaderImage = $""
	string specialPageHeaderTitle = ""
	vector headerOutlineOuterColor = <0,0,0>
	float  headerOutlineOuterAlpha = 0.0
	vector headerOutlineInnerColor = <0,0,0>
	float  headerOutlineInnerAlpha = 0.0
}


struct OfferButtonData
{
	int  activeOfferIndex = -1
	int  lastActiveOfferIndex = -1
	var  button
	var  buttonFade
	bool isTall

	array<GRXScriptOffer>    offerData

	void functionref(...)     stickMovedCallback
	void functionref()        wheelUpCallback
	void functionref()        wheelDownCallback

	table                    signalDummy
}


struct
{
	var offersPanel

	var                    buttonAnchor
	array<OfferButtonData> fullOfferButtonDataArray
	array<OfferButtonData> topOfferButtonDataArray
	array<OfferButtonData> bottomOfferButtonDataArray

	var featuredHeader
	var exclusiveHeader
	var specialPageHeader

	array<OfferButtonData> shopButtonDataArray

	
	table< var, array<GRXScriptOffer> > buttonToOfferData

	table< string, SeasonalStoreData > seasonalDataMap

	var focusedOfferButton

	bool navInputCallbacksRegistered
	bool grxCallbacksRegistered
	bool isShowing
	int  lastStickState
} s_offers

const int LAYOUT_NONE = 0
const int LAYOUT_TALL = 1
const int LAYOUT_SHORT = 2
int[MAX_OFFER_COLUMNS] s_layout






void function InitStorePanel( var panel )
{
	file.storePanel = panel

	RegisterSignal( "OffersPanel_Think" )

	SetPanelTabTitle( panel, "#STORE" )
	SetTabRightSound( panel, "UI_Menu_StoreTab_Select" )
	SetTabLeftSound( panel, "UI_Menu_StoreTab_Select" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnStorePanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnStorePanel_Hide )

	
	
	
	
	
	
	

	SetUpAccessToTheCurrenciesWallet()
	AddTabsToStoreMenu( panel )
}

void function AddTabsToStoreMenu( var panel, bool reOpen = false )
{
	bool showStoreV2 = !reOpen || ( reOpen && GRX_AreStoreSectionsEnabled() ) 

	bool sortApexPacksFirst = ( UICodeCallback_IsKeplerInitialized() && Kepler_IsPlayerInVariant( GetLocalClientPlayer(), eKeplerScenario.APEX_TAB_ORDERING, "treatment-a" ) )

	if ( reOpen && file.showStoreV2 == showStoreV2 && sortApexPacksFirst == file.sortApexPacksFirst )
		return

	file.showStoreV2 = showStoreV2
	file.sortApexPacksFirst = sortApexPacksFirst
	ClearTabs( panel )

	void functionref() addApexPacksTab = void function() : ( panel ) {
		var tabBody = Hud_GetChild( panel, GetConVarBool( "rtk_enableApexPacksScreen" ) ?  GetApexPacksPanelName() : "LootPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_LOOT" )
	}

	if ( sortApexPacksFirst )
	{
		addApexPacksTab()
	}

	if ( showStoreV2 )
	{

		var tabBody = Hud_GetChild( panel, STORE_OFFER_SHOP )
		AddTab( panel, tabBody, "#STORE_V2_SHOP_NAME" )

	}
	else
	{

		
		{
			var tabBody = Hud_GetChild( panel, PERSONALIZED_STORE_PANEL )
			AddTab( panel, tabBody, "#MENU_STORE_PANEL_HOT_DROPS" )
		}


		
		{
			var tabBody = Hud_GetChild( panel, SPECIALS_STORE_PANEL )
			AddTab( panel, tabBody, "#MENU_STORE_PANEL_SPECIALS" )
		}

		
		{
			var tabBody = Hud_GetChild( panel, FEATURED_STORE_PANEL )
			
			AddTab( panel, tabBody, "#MENU_STORE_PANEL_SHOP" )
		}

		
		{
			var tabBody = Hud_GetChild( panel, SEASONAL_STORE_PANEL )
			AddTab( panel, tabBody, "#MENU_STORE_PANEL_SEASONAL" )
		}
	}

	if ( !sortApexPacksFirst )
	{
		addApexPacksTab()
	}

	
	{
		var tabBody = Hud_GetChild( panel, GetMythicShopName() )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_PRESTIGE_SHOP" )
	}

	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( panel, "ScreenFrame" ), true )
}


void function OnStorePanel_Show( var panel )
{
	AddTabsToStoreMenu( panel, true )

	file.isOpened = true
	SetCurrentHubForPIN( Hud_GetHudName( panel ) )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	TabData tabData = GetTabDataForPanel( panel )
	tabData.centerTabs = true
	SetTabBackground( tabData, Hud_GetChild( file.storePanel, "TabsBackground" ), eTabBackground.STANDARD )
	SetTabDefsToSeasonal( tabData )

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
		thread AnimateInSmallTabBar( tabData )

	if ( !file.tabsInitialized )
	{
		SetTabNavigationEndCallback( tabData, eTabDirection.PREV, TabNavigateToLobby )
		file.tabsInitialized = true
	}

	
	DeactivateTab( tabData )
	SetTabNavigationEnabled( file.storePanel, false )

	foreach ( tabDef in GetPanelTabs( file.storePanel ) )
	{
		SetTabDefEnabled( tabDef, false )
	}

	file.storeCacheValid = false

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	RegisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	RegisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )


	Hud_AddEventHandler( Hud_GetChild( file.storePanel, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_AddEventHandler( Hud_GetChild( file.storePanel, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )


	var parentPanel = Hud_GetParent( file.storePanel )
	var mmStatus = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", true )
	HudElem_SetRuiArg( mmStatus, "hideBlur", true )
}



void function TabNavigateToLobby()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )

	
	ActivateTabPrev( lobbyTabData )
}


void function OnStorePanel_Hide( var panel )
{
	file.isOpened = false
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )

	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	RemoveCallback_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	DeregisterButtonPressedCallback( KEY_TAB, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleApexCoinsWalletModal )
	DeregisterButtonPressedCallback( KEY_Q, ToggleExoticShardsWalletModal )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ToggleExoticShardsWalletModal )

	Hud_RemoveEventHandler( Hud_GetChild( file.storePanel, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )
	Hud_RemoveEventHandler( Hud_GetChild( file.storePanel, "ExoticShardsPopUpButton" ), UIE_CLICK, OpenExoticShardsModal )

	file.storeCacheValid = false

	var parentPanel = Hud_GetParent( file.storePanel )
	var mmStatus = Hud_GetChild( parentPanel, "MatchmakingStatus" )
	HudElem_SetRuiArg( mmStatus, "verticalScrollPosition", false )
	HudElem_SetRuiArg( mmStatus, "hideBlur", false )
}


void function CallDLCStoreCallback_Safe()
{
	if ( !file.openDLCStoreCallbackCalled )
	{
		file.openDLCStoreCallbackCalled = true	
		if( IsStoreEmpty() == true)
		{
			ShowDLCStoreUnavailableNotice()
			file.openDLCStoreCallbackCalled = false
			CloseActiveMenu()
		}
		else
		{
			OnOpenDLCStore()
		}
	}
}


void function OnGRXStoreUpdate()
{
	TabData tabData = GetTabDataForPanel( file.storePanel )
	int numTabs     = tabData.tabDefs.len()

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		DeactivateTab( tabData )
		SetTabNavigationEnabled( file.storePanel, false )

		foreach ( tabDef in GetPanelTabs( file.storePanel ) )
		{
			SetTabDefEnabled( tabDef, false )
		}

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), true )

		if ( file.openDLCStoreCallbackCalled )
		{
			OnCloseDLCStore()
		}

		file.openDLCStoreCallbackCalled = false
	}
	else
	{
		bool haveLootTickPurchaseOffer          = ( GetLootTickPurchaseOffers() != null ) && !GRX_IsOfferRestricted()

		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = ( activeCollectionEvent != null )
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool haveActiveThemedShopEvent          = ( activeThemedShopEvent != null )
		bool haveActiveHeirloomTab				= HeirloomShop_IsVisibleWithoutCurrency() || GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ) > 0

		SetTabNavigationEnabled( file.storePanel, true )
		
		foreach ( TabDef tabDef in GetPanelTabs( file.storePanel ) )
		{
			bool showTab   = true
			bool enableTab = true

			if ( Hud_GetHudName( tabDef.panel ) == FEATURED_STORE_PANEL )
			{
				tabDef.title = "#MENU_STORE_FEATURED"
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "LootPanel" )
			{
				enableTab = haveLootTickPurchaseOffer
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "CollectionEventPanel" || Hud_GetHudName( tabDef.panel ) == "SpecialCurrencyShopPanel" )
			{
				showTab = haveActiveCollectionEvent
				enableTab = true
				if ( haveActiveCollectionEvent )
				{
					expect ItemFlavor(activeCollectionEvent)

					tabDef.title = CollectionEvent_GetFrontTabText( activeCollectionEvent )

					
					
					
					
					
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == GetMythicShopName() )
			{
				showTab = haveActiveHeirloomTab
				enableTab = haveActiveHeirloomTab
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "ThemedShopPanel" )
			{
				showTab = haveActiveThemedShopEvent
				if ( haveActiveThemedShopEvent )
				{
					expect ItemFlavor(activeThemedShopEvent)

					tabDef.title = ThemedShopEvent_GetTabText( activeThemedShopEvent )

					
					
					
					
					
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == SPECIALS_STORE_PANEL )
			{
				showTab = GRX_IsLocationActive( "specials" )
				enableTab = showTab
			}
			else if ( Hud_GetHudName( tabDef.panel ) == SEASONAL_STORE_PANEL )
			{
				showTab = GRX_IsLocationActive( "seasonal" )
				enableTab = showTab
			}

			else if ( Hud_GetHudName( tabDef.panel ) == PERSONALIZED_STORE_PANEL )
			{
				array<GRXPersonalizedStoreSlotData> slotData = GetPersonalizedStoreSlotData()

				bool hasOffers = slotData.len() > 0
				showTab = hasOffers
				enableTab = showTab

				bool hasNew = HasNewPersonalisedOffers()
				tabDef.new = hasNew
				file.hotDropsTab = tabDef.panel
			}


			SetTabDefVisible( tabDef, showTab )
			SetTabDefEnabled( tabDef, enableTab )
		}

		int activeIndex = tabData.activeTabIdx
		if ( !file.storeCacheValid && GetLastMenuNavDirection() == MENU_NAV_FORWARD )
			activeIndex = 0

		while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex )) && activeIndex < numTabs )
			activeIndex++

		if ( !IsTabActive( tabData ) && file.isOpened )
			ActivateTab( tabData, activeIndex )

		file.storeCacheValid = true

		UpdateLootTickTabNewness()

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), false )
	}
}


void function UpdateLootTickTabNewness()
{
	if ( !GRX_IsInventoryReady() )
		return

	int packCount = GRX_GetTotalPackCount()
}

















bool function IsWalletModalOpened()
{
	return file.isWalletOpened
}

bool function CanOpenWalletModal()
{
	var activeMenu = GetActiveMenu()
	
	bool activeMenuShouldBlock = IsSelfClosingMenu( activeMenu )
	return activeMenu != file.isWalletOpened && !activeMenuShouldBlock
}

void function OpenWalletInventoryModal( var button )
{
	if ( CanOpenWalletModal() )
		OpenWalletModal(eTabbedModalType.WALLET_INVENTORY)
}

void function OpenVCPopUp( var button )
{
	if ( CanOpenWalletModal() )
		OpenWalletModal(eTabbedModalType.WALLET_APEX_COINS)
}

void function OpenExoticShardsModal( var button )
{
	if ( CanOpenWalletModal() )
		OpenWalletModal(eTabbedModalType.WALLET_EXOTIC_SHARDS)
}

void function OpenWalletModal( int defaultTabType )
{
	int tabIndex = 0

	array<int> types = [ eTabbedModalType.WALLET_INVENTORY,
		eTabbedModalType.WALLET_APEX_COINS,
		eTabbedModalType.WALLET_EXOTIC_SHARDS
	]

	array<string> titles = [ "#CURRENCIES_WALLET_TITLE",
		"#CURRENCY_PREMIUM",
		"#CURRENCIES_WALLET_EXOTIC_SHARDS"
	]

	for ( int typeIndex = 0; typeIndex < types.len(); typeIndex++ )
	{
		if ( types[typeIndex] == defaultTabType )
		{
			tabIndex = typeIndex
			break
		}
	}

	UI_RTKTabbedModal_Open( "", Localize("#CURRENCIES_TITLE").toupper(), types, titles, tabIndex, OnWalletModalOpened, OnWalletModalClosed )
}

void function OnWalletModalOpened()
{
	RegisterSignal( "WalletShutDown" )
	file.isWalletOpened = true
	thread WalletModalThink()
}

void function WalletModalThink()
{
	EndSignal( uiGlobal.signalDummy, "WalletShutDown" )

	while ( file.isWalletOpened )
	{
		int tabType = UI_RTKTabbedModal_GetCurrentTabType()

		if ( tabType == eTabbedModalType.WALLET_APEX_COINS || tabType == eTabbedModalType.WALLET_EXOTIC_SHARDS )
		{
			if ( IsDLCStoreInitialized() )
			{
				if ( GRX_IsInventoryReady() || GRX_AreOffersReady() )
					CallDLCStoreCallback_Safe()
			}
			else
			{
				InitDLCStore()
			}
		}
		else if ( tabType == eTabbedModalType.WALLET_INVENTORY )
		{
			if ( file.openDLCStoreCallbackCalled )
			{
				OnCloseDLCStore()
			}

			file.openDLCStoreCallbackCalled = false
		}

		WaitFrame()
	}
}

void function OnWalletModalClosed()
{
	file.isWalletOpened = false

	Signal( uiGlobal.signalDummy, "WalletShutDown" )

	if ( file.openDLCStoreCallbackCalled )
	{
		OnCloseDLCStore()
	}

	file.openDLCStoreCallbackCalled = false

	if ( ShouldShowPremiumCurrencyDialog( false, true ) )
	{
		ShowPremiumCurrencyDialog( false )
	}

	if ( IsSteamDelayFulfilment() )
	{
		ShowPendingPurchaseDialog()
		ClearSteamDelayFulfilment()
	}
}

void function ToggleApexCoinsWalletModal( var button )
{
	if ( file.isWalletOpened )
	{
		CloseActiveMenu()
	} else {
		OpenVCPopUp( button )
	}
}

void function ToggleExoticShardsWalletModal( var button )
{
	if ( file.isWalletOpened )
	{
		CloseActiveMenu()
	} else {
		OpenExoticShardsModal( button )
	}
}













void function InitLootPanel( var panel )
{
	var lootPanelA = Hud_GetChild( panel, "LootPanelA" )
	s_loot.lootPanel = Hud_GetChild( lootPanelA, "PanelContent" )

	HudElem_SetRuiArg( s_loot.lootPanel, "titleText", Localize( "#RARE_LOOT_TICK" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "descText", Localize( "#LOOT_TICK_INFO" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "priceText1", Localize( "#LOOT_TICK_PRICE_1", "100" ) )

	var lootPanelB = Hud_GetChild( panel, "LootPanelB" )
	s_loot.lootButtonOpen = Hud_GetChild( lootPanelB, "OpenOwnedButton" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "buttonText", "#ACTIVATE_APEX_PACK" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "descText", "" )

	s_loot.lootButtonGift = Hud_GetChild( lootPanelA, "GiftButton" )
	s_loot.lootButtonPurchase = Hud_GetChild( lootPanelA, "PurchaseButton" )

	HudElem_SetRuiArg( s_loot.lootButtonGift, "buttonText", "#INBOX_GIFT_TITLE" )
	HudElem_SetRuiArg( s_loot.lootButtonPurchase, "buttonText", "#PURCHASE" )

	s_loot.lootButtonInfo = Hud_GetChild( lootPanelA, "PackInfoButton" )
	s_loot.lootButtonInfoInvis = Hud_GetChild( lootPanelA, "PackInfoButtonInvisible" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LootPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LootPanel_OnHide )

	Hud_AddEventHandler( s_loot.lootButtonOpen, UIE_CLICK, OpenLootBoxButton_OnActivate )

	Hud_AddEventHandler( s_loot.lootButtonGift, UIE_CLICK, LootTickGiftButton_Activate )
	Hud_AddEventHandler( s_loot.lootButtonPurchase, UIE_CLICK, LootTickPurchaseButton_Activate )
	Hud_AddEventHandler( s_loot.lootButtonInfo, UIE_CLICK, OpenPackInfoDialog )
	Hud_AddEventHandler( s_loot.lootButtonInfoInvis, UIE_CLICK, OpenPackInfoDialog )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUp )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
	AddPanelEventHandler_FocusChanged( panel, LootTick_OnFocusChanged )
}

void function LootPanel_OnShow( var panel )
{
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateLootTickButtons )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	ItemFlavorBag basePrice = expect array<GRXScriptOffer>( GetLootTickPurchaseOffers() )[0].prices[0]
	HudElem_SetRuiArg( s_loot.lootPanel, "priceText1", Localize( "#LOOT_TICK_PRICE_1", GRX_GetFormattedPrice( basePrice, 1 ) ) )
}


void function LootPanel_OnHide( var panel )
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdateLootTickButtons )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	AdvanceMenu( GetMenu( "LootBoxOpen" ) )
}

array<GRXScriptOffer> ornull function GetLootTickPurchaseOffers()
{
	ItemFlavor lootTick          = GetItemFlavorByAsset( $"settings/itemflav/pack/cosmetic_rare.rpak" )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( lootTick, "loot" )
	offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ){
		if ( a.items[0].itemQuantity > b.items[0].itemQuantity )
			return 1
		else if ( a.items[0].itemQuantity < b.items[0].itemQuantity )
			return -1
		return 0
	} )
	return offers.len() > 0 ? offers : null
}

GRXScriptOffer ornull function GetLootTickPurchaseOffer()
{
	ItemFlavor lootTick          = GetItemFlavorByAsset( $"settings/itemflav/pack/cosmetic_rare.rpak" )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( lootTick, "loot" )
	
	offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ){
		if ( a.items[0].itemQuantity > b.items[0].itemQuantity )
			return 1
		else if ( a.items[0].itemQuantity < b.items[0].itemQuantity )
			return -1
		return 0
	} )
	return offers.len() > 0 ? offers[0] : null
}

void function UpdateLootTickButtons()
{
	UpdatePackGiftButton( s_loot.lootButtonGift, false )
	UpdateLootBoxButton( s_loot.lootButtonOpen )
	UpdateDisclaimer( s_loot.lootPanel )
}

void function UpdateLootTickButton( var button, int quantity )
{
	HudElem_SetRuiArg( button, "buttonText", "#PURCHASE" )

	bool purchaseLock   = false
	string purchaseDesc = ""
	if ( GRX_IsInventoryReady() && GRX_AreOffersReady() )
	{
		array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
		if ( offers != null )
		{
			GRXScriptOffer offer = expect array<GRXScriptOffer>( offers )[0]
			purchaseDesc = Localize( "#STORE_PURCHASE_N_FOR_N", quantity, GRX_GetFormattedPrice( offer.prices[0], quantity ) )
			ItemFlavor lootTickFlavor = offer.output.flavors[0] 

			purchaseLock = false
		}
	}
	else
	{
		purchaseLock = true
	}

	Hud_SetLocked( button, purchaseLock )
	HudElem_SetRuiArg( button, "descText", purchaseDesc )
}

void function LootTickPurchaseButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	int quantity = 1

	array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
	if ( offers == null )
	{
		EmitUISound( "menu_deny" )
		return
	}

	PurchaseDialogConfig pdc
	pdc.offer = expect array<GRXScriptOffer>( offers )[0]
	pdc.quantity = quantity
	pdc.markAsNew = false
	pdc.onPurchaseResultCallback = OnLootTickPurchaseResult
	PurchaseDialog( pdc )
}

void function LootTickGiftButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( !IsTwoFactorAuthenticationEnabled() )
	{
		OpenTwoFactorInfoDialog( button )
		return
	}

	array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
	if ( offers == null )
	{
		EmitUISound( "menu_deny" )
		return
	}

	int quantity = 1
	PurchaseDialogConfig pdc
	pdc.offer = expect array<GRXScriptOffer>( offers )[0]
	pdc.quantity = quantity
	pdc.markAsNew = false
	pdc.isGiftPack = true
	PurchaseDialog( pdc )
}


void function LootTick_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )
		return

	if ( !newFocus )
		return

	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	if( !Hud_IsFocused( s_loot.lootButtonInfo ) )
	{
		if ( s_loot.lootButtonInfo != null && s_loot.lootButtonInfoInvis != null )
			HudElem_SetRuiArg( s_loot.lootButtonInfo, "isFocused", Hud_IsFocused( s_loot.lootButtonInfoInvis ) )
	}
}

void function OnLootTickPurchaseResult( bool wasSuccessful )
{
	if ( wasSuccessful )
	{
		UpdateLootTickButtons()
	}
}








array<OfferButtonData> function GetButtonOfferData( array<var> buttons, array<var> buttonFades, bool isTall )
{
	array<OfferButtonData> offerButtonDataArray

	Assert( buttons.len() == buttonFades.len() )

	foreach ( var button in buttons )
	{
		OfferButtonData offerButtonData
		offerButtonData.button = button
		offerButtonData.isTall = isTall

		foreach ( buttonFade in buttonFades )
		{
			if ( Hud_GetScriptID( buttonFade ) == Hud_GetScriptID( button ) )
			{
				offerButtonData.buttonFade = buttonFade
				RuiSetBool( Hud_GetRui( buttonFade ), "isFade", true )
			}
		}

		offerButtonDataArray.append( offerButtonData )

		offerButtonData.stickMovedCallback = void function( ... ) : ( offerButtonData )
		{
			OfferButton_OnStickMoved( offerButtonData, expect float( vargv[1] ) )
		}

		offerButtonData.wheelUpCallback = void function() : ( offerButtonData )
		{
			ChangeOfferPageToLeft( offerButtonData )
		}

		offerButtonData.wheelDownCallback = void function() : ( offerButtonData )
		{
			ChangeOfferPageToRight( offerButtonData )
		}
	}

	return offerButtonDataArray
}


void function InitOffersPanel( var panel )
{
	RegisterSignal( "EndAutoAdvanceOffers" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OffersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OffersPanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUp )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
	file.eventStoreButton = Hud_GetChild( Hud_GetParent( panel ), "EventStoreButton" )
	Hud_AddEventHandler( file.eventStoreButton, UIE_CLICK, EventStoreTabButton_OnActivate )
}

void function InitSpecialsPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OffersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OffersPanel_OnHide )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUp )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
	file.eventStoreButton = Hud_GetChild( Hud_GetParent( panel ), "EventStoreButton" )
	Hud_AddEventHandler( file.eventStoreButton, UIE_CLICK, EventStoreTabButton_OnActivate )
}

void function OffersPanel_OnShow( var panel )
{
	RemoveOfferPanelCallbacks()
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	s_offers.offersPanel = panel

	s_offers.buttonAnchor = Hud_GetChild( panel, "ButtonAnchor" )

	s_offers.featuredHeader = Hud_GetChild( panel, "LeftHeader" )
	s_offers.exclusiveHeader = Hud_GetChild( panel, "RightHeader" )
	s_offers.specialPageHeader = Hud_GetChild( panel, "SpecialPageHeader" )

	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )

	if ( activeCollectionEvent != null )
	{
		file.eventStoreButton = Hud_GetChild( Hud_GetParent( panel ), "EventStoreButton" )

		expect ItemFlavor( activeCollectionEvent )

		Hud_SetVisible( file.eventStoreButton, true )
		Hud_SetEnabled( file.eventStoreButton, true )

		string buttonName = Localize("#COLLECTION_STORE" )

		RuiSetString( Hud_GetRui( file.eventStoreButton ), "buttonText", buttonName )

		ItemFlavor completionRewardPack = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
		asset rarityIcon = GRXPack_GetOpenButtonIcon( completionRewardPack )
		vector rarityCol = SrgbToLinear( CollectionEvent_GetMainThemeCol( activeCollectionEvent ) )

		var rui = Hud_GetRui( file.eventStoreButton )

		HudElem_SetRuiArg( file.eventStoreButton, "rarityIcon", rarityIcon, eRuiArgType.ASSET )
		RuiSetColorAlpha( rui, "rarityCol", rarityCol, 1.0 )
	}

	if ( Hud_GetHudName( panel ) == SPECIALS_STORE_PANEL )
	{
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		if( activeThemedShopEvent != null )
		{
			expect ItemFlavor( activeThemedShopEvent )
			RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LeftHeader" ) ), "titleText", ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 1 ) )
			RuiSetString( Hud_GetRui( Hud_GetChild( panel, "RightHeader" ) ), "titleText", ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 2 ) )
		}
	}
	else
	{
		RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LeftHeader" ) ), "titleText", "#MENU_STORE_FEATURED" )
		RuiSetString( Hud_GetRui( Hud_GetChild( panel, "RightHeader" ) ), "titleText", "#MENU_STORE_EXCLUSIVE" )
	}

	s_offers.fullOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "FullOfferButton" ), GetPanelElementsByClassname( panel, "FullOfferButtonFade" ), true )
	s_offers.topOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "TopOfferButton" ), GetPanelElementsByClassname( panel, "TopOfferButtonFade" ), false )
	s_offers.bottomOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "BottomOfferButton" ), GetPanelElementsByClassname( panel, "BottomOfferButtonFade" ), false )

	s_offers.shopButtonDataArray.clear()
	s_offers.shopButtonDataArray.extend( s_offers.fullOfferButtonDataArray )
	s_offers.shopButtonDataArray.extend( s_offers.topOfferButtonDataArray )
	s_offers.shopButtonDataArray.extend( s_offers.bottomOfferButtonDataArray )

	AddOfferPanelCallbacks()

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	thread OffersPanel_Think( panel )
	thread OfferButton_AutoAdvanceOffers()

	s_offers.isShowing = true
}


void function OffersPanel_OnHide( var panel )
{
	RemoveOfferPanelCallbacks()
	s_offers.fullOfferButtonDataArray.clear()
	s_offers.topOfferButtonDataArray.clear()
	s_offers.bottomOfferButtonDataArray.clear()
	s_offers.shopButtonDataArray.clear()

	Hud_SetVisible( file.eventStoreButton, false )
	Hud_SetEnabled( file.eventStoreButton, false )

	s_offers.isShowing = false

	Signal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )
}

void function AddOfferPanelCallbacks()
{
	if( s_offers.grxCallbacksRegistered )
		return

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateOffersPanel )
	AddCallback_OnGRXOffersRefreshed( UpdateOffersPanel )

	for ( int index = 0; index < s_offers.shopButtonDataArray.len(); index++ )
	{
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_CLICK, OfferButton_OnActivate )
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_SetEnabled( s_offers.shopButtonDataArray[index].button, false )
	}
	s_offers.grxCallbacksRegistered = true
}

void function RemoveOfferPanelCallbacks()
{
	if( IsValid( s_offers.focusedOfferButton ) )
		OfferButton_RemoveCallbacks( s_offers.focusedOfferButton )

	if( !s_offers.grxCallbacksRegistered )
		return

	RemoveCallback_OnGRXInventoryStateChanged( UpdateOffersPanel )
	RemoveCallback_OnGRXOffersRefreshed( UpdateOffersPanel )

	for ( int index = 0; index < s_offers.shopButtonDataArray.len(); index++ )
	{
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_CLICK, OfferButton_OnActivate )
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
	}
	s_offers.grxCallbacksRegistered = false
}

void function OffersPanel_LevelShutdown()
{
	if ( s_offers.isShowing )
		OffersPanel_OnHide( s_offers.offersPanel )
}

void function UpdateOffersPanel()
{
	if ( GRX_IsInventoryReady() )
	{
		if ( GRX_AreOffersReady() )
		{
			InitOffers()
		}
		else
		{
			ClearOffers()
		}
	}
	else
	{
		foreach ( OfferButtonData buttonData in s_offers.shopButtonDataArray )
		{
			Hud_SetEnabled( buttonData.button, false )
			Hud_SetVisible( buttonData.button, false )
		}
	}
}

void function OffersPanel_Think( var panel )
{
	Signal( uiGlobal.signalDummy, "OffersPanel_Think" )
	EndSignal( uiGlobal.signalDummy, "OffersPanel_Think" )

	var menu = GetParentMenu( panel )
	while ( GetActiveMenu() == menu && uiGlobal.activePanels.contains( panel ) )
	{
		UpdateOffersPanel()

		wait 1.0
	}
}


void function InitOffers()
{
	var dataTable = GetDataTable( $"datatable/seasonal_store_data.rpak" )
	for ( int i = 0; i < GetDataTableRowCount( dataTable ); i++ )
	{
		string seasonTag               = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "seasonTag" ) ).tolower()
		asset tallImage                = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallImage" ) )
		asset squareImage              = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareImage" ) )
		asset tallFrameOverlayImage    = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallFrameOverlay" ) )
		asset squareFrameOverlayImage  = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareFrameOverlay" ) )
		asset specialPageHeaderImage   = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "specialPageHeaderImage" ) )
		string specialPageHeaderTitle  = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "specialPageHeaderTitle" ) )
		vector headerOutlineOuterColor = GetDataTableVector( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineOuterColor" ) )
		float  headerOutlineOuterAlpha = GetDataTableFloat( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineOuterAlpha" ) )
		vector headerOutlineInnerColor = GetDataTableVector( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineInnerColor" ) )
		float  headerOutlineInnerAlpha = GetDataTableFloat( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineInnerAlpha" ) )

		SeasonalStoreData seasonalStoreData
		seasonalStoreData.seasonTag = seasonTag
		seasonalStoreData.tallImage = tallImage
		seasonalStoreData.squareImage = squareImage
		seasonalStoreData.tallFrameOverlayImage = tallFrameOverlayImage
		seasonalStoreData.squareFrameOverlayImage = squareFrameOverlayImage
		seasonalStoreData.specialPageHeaderImage = specialPageHeaderImage
		seasonalStoreData.specialPageHeaderTitle = specialPageHeaderTitle
		seasonalStoreData.headerOutlineOuterColor = headerOutlineOuterColor
		seasonalStoreData.headerOutlineOuterAlpha = headerOutlineOuterAlpha
		seasonalStoreData.headerOutlineInnerColor = headerOutlineInnerColor
		seasonalStoreData.headerOutlineInnerAlpha = headerOutlineInnerAlpha

		s_offers.seasonalDataMap[seasonTag] <- seasonalStoreData
	}

	bool isSpecialPageHeaderDataValid = false
	asset specialPageHeaderImage      = $""
	string specialPageHeaderTitle     = ""
	vector headerOutlineOuterColor    = <0,0,0>
	float  headerOutlineOuterAlpha    = 0.0
	vector headerOutlineInnerColor    = <0,0,0>
	float  headerOutlineInnerAlpha    = 0.0

	int numTallColumns = 0
	int numShortColumns = 0
	int numBlankColumns = 0
	int storeLocation = GetStoreLocationFromPanel( s_offers.offersPanel )
	for ( int col = 0; col < MAX_OFFER_COLUMNS; col++ )
	{
		OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], false )
		OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], false )
		OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], false )
		Hud_SetLocked( s_offers.fullOfferButtonDataArray[col].button, false )
		Hud_SetLocked( s_offers.topOfferButtonDataArray[col].button, false )
		Hud_SetLocked( s_offers.bottomOfferButtonDataArray[col].button, false )
		OfferButton_SetNavDown( s_offers.fullOfferButtonDataArray[col] )
		OfferButton_SetNavDown( s_offers.bottomOfferButtonDataArray[col] )

		int numRows = GRX_GetStoreOfferColumnNumRows( col, storeLocation )

		array<GRXScriptOffer> topRowOffers    = GRX_GetStoreOfferColumn( col, 0, storeLocation )
		array<GRXScriptOffer> bottomRowOffers = GRX_GetStoreOfferColumn( col, 1, storeLocation )

#if DEV
			if ( file.DEV_fakeOffers_grxRef != "" )
			{
				topRowOffers = []
				bottomRowOffers = []
				numRows = 0

				array<GRXScriptOffer> fakeOffers
				for ( int fakeOfferIdx = 0; fakeOfferIdx < file.DEV_fakeOffers_columnCounts[col]; fakeOfferIdx++ )
				{
					ItemFlavor flav = DEV_GetItemFlavorByGRXRef( file.DEV_fakeOffers_grxRef )
					GRXScriptOffer fakeOffer
					fakeOffer.output.flavors = [flav]
					fakeOffer.output.quantities = [1]
					fakeOffer.prices = [ MakeItemFlavorBag( { [DEV_GetItemFlavorByGRXRef( "grx_currency_premium" )] = 550, } ) ]
					fakeOffer.titleText = ItemFlavor_GetLongName( flav )
					fakeOffer.descText = ItemFlavor_GetTypeName( flav )
					fakeOffer.image = ItemFlavor_GetIcon( flav )
					fakeOffer.imageRef = ""
					fakeOffer.tagText = "banana"
					fakeOffer.seasonTag = file.DEV_fakeOffers_seasonTag
					fakeOffer.originalPrice = MakeItemFlavorBag( { [DEV_GetItemFlavorByGRXRef( "grx_currency_premium" )] = 700, } )
					fakeOffer.expireTime = int( ceil( GetUnixTimestamp() / 1000.0 ) * 1000.0 )
					
					fakeOffers.append( fakeOffer )

					if ( IsEven( fakeOfferIdx ) )
						topRowOffers.append( fakeOffer )
					else
						bottomRowOffers.append( fakeOffer )
				}

				if ( topRowOffers.len() > 0 )
					numRows++

				if ( bottomRowOffers.len() > 0 )
					numRows++
			}
#endif

		array<GRXScriptOffer> allColumnOffers
		allColumnOffers.extend( topRowOffers )
		allColumnOffers.extend( bottomRowOffers )

		foreach ( GRXScriptOffer offerData in allColumnOffers )
		{
			string seasonTag = offerData.seasonTag in s_offers.seasonalDataMap ? offerData.seasonTag : "default"

			if ( isSpecialPageHeaderDataValid )
			{
				if ( s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage != specialPageHeaderImage )
				{
					Warning( "Mismatched store special page header images: \"%s\", \"%s\"", string(specialPageHeaderImage), string(s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage) )
					specialPageHeaderImage = $""
				}
				if ( s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle != specialPageHeaderTitle )
				{
					Warning( "Mismatched store special page header titles: \"%s\", \"%s\"", specialPageHeaderTitle, s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle )
					specialPageHeaderTitle = ""
				}
			}
			else
			{
				isSpecialPageHeaderDataValid = true
				specialPageHeaderImage = s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage
				specialPageHeaderTitle = s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle
				headerOutlineOuterColor = s_offers.seasonalDataMap[seasonTag].headerOutlineOuterColor
				headerOutlineOuterAlpha = s_offers.seasonalDataMap[seasonTag].headerOutlineOuterAlpha
				headerOutlineInnerColor = s_offers.seasonalDataMap[seasonTag].headerOutlineInnerColor
				headerOutlineInnerAlpha = s_offers.seasonalDataMap[seasonTag].headerOutlineInnerAlpha
			}
		}

		if ( numRows == 0 )
		{
			s_layout[col] = LAYOUT_NONE
			if ( col != 4 ) 
			numBlankColumns++
		}
		else if ( numRows == 1 )
		{
			s_layout[col] = LAYOUT_TALL
			numTallColumns++

			OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], true )
			OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], false )
			OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], false )

			s_offers.fullOfferButtonDataArray[col].offerData = topRowOffers.len() > 0 ? topRowOffers : bottomRowOffers
			OfferButton_SetOffer( s_offers.fullOfferButtonDataArray[col], -1 )
		}
		else
		{
			s_layout[col] = LAYOUT_SHORT
			numShortColumns++

			Assert( numRows == 2 )

			OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], false )
			OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], true )
			OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], true )

			s_offers.topOfferButtonDataArray[col].offerData = topRowOffers
			OfferButton_SetOffer( s_offers.topOfferButtonDataArray[col], -1 )

			s_offers.bottomOfferButtonDataArray[col].offerData = bottomRowOffers
			OfferButton_SetOffer( s_offers.bottomOfferButtonDataArray[col], -1 )
		}
	}

	if ( IsValid( file.eventStoreButton ) )
	{
		if ( Hud_IsEnabled( file.eventStoreButton ) )
		{
			int layoutLast = s_layout.len() - 1
			switch ( s_layout[layoutLast] )
			{
				case LAYOUT_TALL:
					Hud_SetNavUp( file.eventStoreButton, s_offers.fullOfferButtonDataArray[layoutLast].button )
					break
				case LAYOUT_SHORT:
					Hud_SetNavUp( file.eventStoreButton , s_offers.bottomOfferButtonDataArray[layoutLast].button )
					break
			}
		}
	}

	const int TALL_BUTTON_MIN_WIDTH = 360
	const int TALL_BUTTON_MAX_WIDTH = 420
	const int SHORT_BUTTON_MIN_WIDTH = 360
	const int SHORT_BUTTON_MAX_WIDTH = 370
	const int TALL_WIDER_BUTTON_WIDTH = 600
	const int TALL_2SLOT_BUTTON_WIDTH = 800
	const int TALL_1SLOT_BUTTON_WIDTH = 1200

	int totalColumns = numTallColumns + numShortColumns
	int totalWidth    = 0
	int featuredWidth = 0
	int exclusiveWidth = 0
	int exclusiveX     = 0
	for ( int col = 0; col < MAX_OFFER_COLUMNS; col++ )
	{
		int offerPanelWidth
		switch ( s_layout[col] )
		{
			case LAYOUT_TALL:
				if ( totalColumns > 4 )
					offerPanelWidth = TALL_BUTTON_MIN_WIDTH
				else
					offerPanelWidth = TALL_BUTTON_MAX_WIDTH

				if ( totalColumns == 1 )
					offerPanelWidth = TALL_1SLOT_BUTTON_WIDTH

				else if ( totalColumns == 2 )
					offerPanelWidth = TALL_2SLOT_BUTTON_WIDTH

				else if ( col == 0 && totalColumns + numBlankColumns == 4 )
					offerPanelWidth = TALL_WIDER_BUTTON_WIDTH

				break

			case LAYOUT_SHORT:
				if ( totalColumns > 4 )
					offerPanelWidth = SHORT_BUTTON_MIN_WIDTH
				else
					offerPanelWidth = SHORT_BUTTON_MAX_WIDTH
				break

			case LAYOUT_NONE:
				if ( featuredWidth == 0 || totalColumns <= col )
					offerPanelWidth = 0
				else
					offerPanelWidth = TALL_BUTTON_MIN_WIDTH / 4

				if ( exclusiveX <= 0 )
					exclusiveX = -1
				break
		}

		offerPanelWidth = int( offerPanelWidth * GetContentFixedScaleFactor( GetMenu("MainMenu") ).x )
		int offerX = Hud_GetX( s_offers.fullOfferButtonDataArray[col].button )

		OfferButton_SetWidth( s_offers.fullOfferButtonDataArray[col], offerPanelWidth )
		OfferButton_SetWidth( s_offers.topOfferButtonDataArray[col], offerPanelWidth )
		OfferButton_SetWidth( s_offers.bottomOfferButtonDataArray[col], offerPanelWidth )

		if ( exclusiveX == -1 && s_layout[col] != LAYOUT_NONE )
			exclusiveX = totalWidth + offerX

		totalWidth += offerPanelWidth + offerX

		if ( exclusiveX == 0 )
		{
			featuredWidth += offerPanelWidth
			if ( col > 0 )
				featuredWidth += offerX
		}
		else if ( exclusiveX > 0 && s_layout[col] != LAYOUT_NONE)
		{
			exclusiveWidth += offerPanelWidth
			if ( col > 0 && s_layout[col - 1] != LAYOUT_NONE )
				exclusiveWidth += offerX
		}

		
		TrySetHorizontalNav( col, -1 )
		TrySetHorizontalNav( col, 1 )
	}

	if( specialPageHeaderImage != $"" || specialPageHeaderTitle != "" ) 
	{
		Hud_Hide( s_offers.featuredHeader )
		Hud_Hide( s_offers.exclusiveHeader )
		Hud_Show( s_offers.specialPageHeader )

		HudElem_SetRuiArg( s_offers.specialPageHeader, "headerImage", specialPageHeaderImage, eRuiArgType.IMAGE )
		HudElem_SetRuiArg( s_offers.specialPageHeader, "headerTitle", specialPageHeaderTitle )

		if ( headerOutlineOuterColor != <0,0,0> )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineOuterColor", headerOutlineOuterColor, eRuiArgType.VECTOR )
		if (   headerOutlineOuterAlpha != 0.0 )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineOuterAlpha", headerOutlineOuterAlpha, eRuiArgType.FLOAT )
		if (  headerOutlineInnerColor != <0,0,0> )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineInnerColor", headerOutlineInnerColor, eRuiArgType.VECTOR )
		if (   headerOutlineInnerAlpha != 0.0 )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineInnerAlpha", headerOutlineInnerAlpha, eRuiArgType.FLOAT )

		Hud_SetY( s_offers.buttonAnchor, ContentScaledYAsInt( -28 ) )
		Hud_SetX( s_offers.specialPageHeader, (Hud_GetWidth( s_offers.specialPageHeader ) - totalWidth) / 2 )
	}
	else 
	{
		Hud_Hide( s_offers.specialPageHeader )
		Hud_SetY( s_offers.buttonAnchor, 0 )
		Hud_Show( s_offers.featuredHeader )
		Hud_SetVisible( s_offers.exclusiveHeader, exclusiveWidth > 0 )
		Hud_SetWidth( s_offers.featuredHeader, featuredWidth > 0 ? featuredWidth : totalWidth )

		Hud_SetX( s_offers.exclusiveHeader, exclusiveX )
		Hud_SetWidth( s_offers.exclusiveHeader, exclusiveWidth > 0 ? exclusiveWidth : totalWidth - exclusiveX )
	}

	Hud_SetWidth( s_offers.offersPanel, totalWidth )
}

void function TrySetHorizontalNav( int col, int dir )
{
	int colNav = col + dir
	void functionref( var, var ) setNavFunc = ( dir < 0 ) ? OfferButton_SetNavLeft : OfferButton_SetNavRight

	
	if ( colNav < 0 || colNav >= MAX_OFFER_COLUMNS )
	{
		setNavFunc( s_offers.fullOfferButtonDataArray[col].button, null )
		setNavFunc( s_offers.topOfferButtonDataArray[col].button, null )
		setNavFunc( s_offers.bottomOfferButtonDataArray[col].button, null )

		return
	}

	switch ( s_layout[colNav] )
	{
		case LAYOUT_TALL:
			setNavFunc( s_offers.fullOfferButtonDataArray[col].button, s_offers.fullOfferButtonDataArray[colNav].button )
			setNavFunc( s_offers.topOfferButtonDataArray[col].button, s_offers.fullOfferButtonDataArray[colNav].button )
			setNavFunc( s_offers.bottomOfferButtonDataArray[col].button, s_offers.fullOfferButtonDataArray[colNav].button )
			break

		case LAYOUT_SHORT:
			setNavFunc( s_offers.fullOfferButtonDataArray[col].button, s_offers.topOfferButtonDataArray[colNav].button )
			setNavFunc( s_offers.topOfferButtonDataArray[col].button, s_offers.topOfferButtonDataArray[colNav].button )
			setNavFunc( s_offers.bottomOfferButtonDataArray[col].button, s_offers.bottomOfferButtonDataArray[colNav].button )
			break

		case LAYOUT_NONE:
			
			TrySetHorizontalNav( col, dir + dir )
			break
	}
}

void function ClearOffers()
{
	foreach ( buttonData in s_offers.shopButtonDataArray )
	{
		var rui = Hud_GetRui( buttonData.button )

		RuiSetImage( rui, "imageAsset", $"" )
		RuiSetString( rui, "ecTitle", "" )
		RuiSetString( rui, "ecDesc", "" )
		RuiSetString( rui, "ecReqs", "" )
		RuiSetString( rui, "tagText", "" )
		RuiSetInt( rui, "numCollected", 0 )
		RuiSetInt( rui, "numTotalInCollection", 0 )

		RuiSetString( rui, "ecPrice", "#UNAVAILABLE" )
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

		Hud_SetEnabled( buttonData.button, false )
	}
}


#if DEV
void function DEV_OffersPanel_DoFakeOffers( bool doIt = false, string itemRef = "character_skin_caustic_legendary_04", string seasonTag = "", int col0 = 1, int col1 = 1, int col2 = 1, int col3 = 1, int col4 = 1 )
{
	if ( !doIt )
		itemRef = ""

	file.DEV_fakeOffers_grxRef = itemRef
	file.DEV_fakeOffers_seasonTag = seasonTag
	file.DEV_fakeOffers_columnCounts[0] = col0
	file.DEV_fakeOffers_columnCounts[1] = col1
	file.DEV_fakeOffers_columnCounts[2] = col2
	file.DEV_fakeOffers_columnCounts[3] = col3
	file.DEV_fakeOffers_columnCounts[4] = col4

	file.DEV_fakeOffers_expireTime[0] = int( ceil( GetUnixTimestamp() / 500.0 ) * 500.0 )
	file.DEV_fakeOffers_expireTime[1] = int( ceil( GetUnixTimestamp() / 400.0 ) * 400.0 )
	file.DEV_fakeOffers_expireTime[2] = int( ceil( GetUnixTimestamp() / 300.0 ) * 300.0 )
	file.DEV_fakeOffers_expireTime[3] = int( ceil( GetUnixTimestamp() / 200.0 ) * 200.0 )
	file.DEV_fakeOffers_expireTime[4] = int( ceil( GetUnixTimestamp() / 100.0 ) * 100.0 )
}

void function DEV_OffersPanel_DoFakeLayout( bool doIt = false, int col0 = 1, int col1 = 1, int col2 = 1, int col3 = 1, int col4 = 1, string seasonTag = "", string itemRef = "character_skin_caustic_legendary_04" )
{
	if ( !doIt )
		itemRef = ""

	file.DEV_fakeOffers_grxRef = itemRef
	file.DEV_fakeOffers_seasonTag = seasonTag
	file.DEV_fakeOffers_columnCounts[0] = col0
	file.DEV_fakeOffers_columnCounts[1] = col1
	file.DEV_fakeOffers_columnCounts[2] = col2
	file.DEV_fakeOffers_columnCounts[3] = col3
	file.DEV_fakeOffers_columnCounts[4] = col4

	file.DEV_fakeOffers_expireTime[0] = int( ceil( GetUnixTimestamp() / 500.0 ) * 500.0 )
	file.DEV_fakeOffers_expireTime[1] = int( ceil( GetUnixTimestamp() / 400.0 ) * 400.0 )
	file.DEV_fakeOffers_expireTime[2] = int( ceil( GetUnixTimestamp() / 300.0 ) * 300.0 )
	file.DEV_fakeOffers_expireTime[3] = int( ceil( GetUnixTimestamp() / 200.0 ) * 200.0 )
	file.DEV_fakeOffers_expireTime[4] = int( ceil( GetUnixTimestamp() / 100.0 ) * 100.0 )
}
#endif


void function OfferButton_OnActivate( var button )
{
	if ( !(button in s_offers.buttonToOfferData) )
		return

	GRXScriptOffer offer = s_offers.buttonToOfferData[button][0]

	Assert( offer.output.flavors.len() > 0 )
	SetCurrentTabForPIN( FEATURED_STORE_PANEL ) 
	StoreInspectMenu_AttemptOpenWithOffer( offer ) 
}


OfferButtonData ornull function GetOfferButtonDataByButton( var button )
{
	foreach ( offerButtonData in s_offers.shopButtonDataArray )
	{
		if ( offerButtonData.button != button )
			continue

		return offerButtonData
	}
	return null
}


void function OfferButton_OnGetFocus( var button )
{
	if( IsValid( s_offers.focusedOfferButton ) )
		OfferButton_RemoveCallbacks( s_offers.focusedOfferButton )

	if ( s_offers.navInputCallbacksRegistered )
		return

	OfferButtonData ornull offerButtonData = GetOfferButtonDataByButton( button )

	TEMP_StoreOffer( button, s_offers.seasonalDataMap )

	if( offerButtonData == null )
		return

	expect OfferButtonData( offerButtonData )

	s_offers.lastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, offerButtonData.stickMovedCallback )
	AddCallback_OnMouseWheelUp( offerButtonData.wheelUpCallback )
	AddCallback_OnMouseWheelDown( offerButtonData.wheelDownCallback )
	s_offers.focusedOfferButton = button
	s_offers.navInputCallbacksRegistered = true
}


void function OfferButton_OnLoseFocus( var button )
{
	OfferButton_RemoveCallbacks( button )
}

void function OfferButton_RemoveCallbacks( var button )
{
	if ( !s_offers.navInputCallbacksRegistered )
		return

	OfferButtonData ornull offerButtonData = GetOfferButtonDataByButton( button )

	if ( offerButtonData == null )
		return

	expect OfferButtonData( offerButtonData )

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, offerButtonData.stickMovedCallback )
	RemoveCallback_OnMouseWheelUp( offerButtonData.wheelUpCallback )
	RemoveCallback_OnMouseWheelDown( offerButtonData.wheelDownCallback )
	if ( s_offers.focusedOfferButton == button )
	{
		s_offers.focusedOfferButton = null
		s_offers.navInputCallbacksRegistered = false
	}
}

const bool OFFERBUTTON_NAV_RIGHT = true
const bool OFFERBUTTON_NAV_LEFT = false

void function OfferButton_OnStickMoved( OfferButtonData offerButtonData, float stickDeflection )
{
	

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != s_offers.lastStickState && offerButtonData.activeOfferIndex != -1 )
	{
		if ( stickState == eStickState.RIGHT )
		{
			
			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
		}
		else if ( stickState == eStickState.LEFT )
		{
			
			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_LEFT )
		}
	}

	s_offers.lastStickState = stickState
}


void function ChangeOfferPageToLeft( OfferButtonData offerButtonData )
{
	if ( offerButtonData.activeOfferIndex == -1 )
		return

	OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_LEFT )
}


void function ChangeOfferPageToRight( OfferButtonData offerButtonData )
{
	if ( offerButtonData.activeOfferIndex == -1 )
		return

	OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
}


void function OfferButton_ChangeOffer( OfferButtonData offerButtonData, bool direction )
{
	Assert( direction == OFFERBUTTON_NAV_LEFT || direction == OFFERBUTTON_NAV_RIGHT )
	Assert( offerButtonData.activeOfferIndex != -1 )

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	int numOffers      = offerButtonData.offerData.len()
	int nextOfferIndex = offerButtonData.activeOfferIndex

	for ( int i = 1; i < numOffers; i++ )
	{
		int candidateOfferIndex = direction == OFFERBUTTON_NAV_RIGHT ? (offerButtonData.activeOfferIndex + i) % numOffers : (offerButtonData.activeOfferIndex - i + numOffers) % numOffers

		nextOfferIndex = candidateOfferIndex
		break
	}

	if ( nextOfferIndex != offerButtonData.activeOfferIndex )
		OfferButton_SetOffer( offerButtonData, nextOfferIndex )
}

void function OfferButton_SetWidth( OfferButtonData offerButtonData, int width )
{
	Hud_SetWidth( offerButtonData.button, width )
	Hud_SetWidth( offerButtonData.buttonFade, width )
}

void function OfferButton_SetVisible( OfferButtonData offerButtonData, bool state )
{
	Hud_SetVisible( offerButtonData.button, state )
	Hud_SetVisible( offerButtonData.buttonFade, state )
}

void function OfferButton_SetNavDown( OfferButtonData offerButtonData )
{
	if ( IsValid( file.eventStoreButton ) )
	{
		if ( Hud_IsEnabled( file.eventStoreButton ) )
		{
			Hud_SetNavDown( offerButtonData.button, file.eventStoreButton )
			return
		}
	}

	Hud_SetNavDown( offerButtonData.button, null )
}

void function OfferButton_SetNavLeft( var offerButton, var offerButtonNav )
{
	if ( offerButtonNav != null && Hud_IsVisible( offerButtonNav ) )
	{
		Hud_SetNavLeft( offerButton, offerButtonNav )
		return
	}

	Hud_SetNavLeft( offerButton, null )
}

void function OfferButton_SetNavRight( var offerButton, var offerButtonNav )
{
	if ( offerButtonNav != null && Hud_IsVisible( offerButtonNav ) )
	{
		Hud_SetNavRight( offerButton, offerButtonNav )
		return
	}

	Hud_SetNavRight( offerButton, null )
}

void function OfferButton_SetOffer( OfferButtonData offerButtonData, int offerIndex )
{
	if ( offerIndex == -1 )
	{
		if ( offerButtonData.activeOfferIndex == -1 || offerButtonData.activeOfferIndex >= offerButtonData.offerData.len() )
			offerIndex = 0
		else
			offerIndex = offerButtonData.activeOfferIndex
	}

	int lastActiveOffer = offerButtonData.activeOfferIndex
	if ( lastActiveOffer >= offerButtonData.offerData.len() )
		lastActiveOffer = -1

	offerButtonData.activeOfferIndex = offerIndex

	var button  = offerButtonData.button
	bool isTall = offerButtonData.isTall
	var rui     = Hud_GetRui( button )

	GRXScriptOffer offerData = offerButtonData.offerData[offerIndex]

	if ( GetConVarBool( "assetdownloads_enabled" ) && offerData.imageRef != "" && offerData.image == $"" )
	{
		offerData.image = GetDownloadedImageAsset( offerData.imageRef, offerData.imageRef, (isTall)?ePakType.DL_STORE_TALL:ePakType.DL_STORE_SHORT, button )
	}

	RuiSetInt( rui, "offerCount", offerButtonData.offerData.len() )
	RuiSetInt( rui, "activeOfferIndex", offerButtonData.activeOfferIndex )
	OfferButton_SetDisplay( offerButtonData.button, offerData, offerButtonData.isTall )
	if ( offerButtonData.lastActiveOfferIndex != offerButtonData.activeOfferIndex )
	{
		if ( lastActiveOffer == -1 )
		{
			RuiSetGameTime( Hud_GetRui( offerButtonData.buttonFade ), "initTime", RUI_BADGAMETIME )
		}
		else
		{
			RuiSetInt( Hud_GetRui( offerButtonData.buttonFade ), "offerCount", 0 )
			RuiSetInt( Hud_GetRui( offerButtonData.buttonFade ), "activeOfferIndex", lastActiveOffer )
			RuiSetGameTime( Hud_GetRui( offerButtonData.buttonFade ), "initTime", ClientTime() )
			OfferButton_SetDisplay( offerButtonData.buttonFade, offerButtonData.offerData[lastActiveOffer], offerButtonData.isTall )
		}
	}

	offerButtonData.lastActiveOfferIndex = offerButtonData.activeOfferIndex

	s_offers.buttonToOfferData[offerButtonData.button] <- [offerData]
}


void function OfferButton_SetDisplay( var button, GRXScriptOffer offerData, bool isTall )
{
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "imageAsset", offerData.image )

	asset backgroundImage
	asset frameOverlayImage
	string seasonTag = offerData.seasonTag in s_offers.seasonalDataMap ? offerData.seasonTag : "default"

	backgroundImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallImage : s_offers.seasonalDataMap[seasonTag].squareImage
	frameOverlayImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallFrameOverlayImage : s_offers.seasonalDataMap[seasonTag].squareFrameOverlayImage

	RuiSetImage( rui, "backgroundImg", backgroundImage )
	RuiSetImage( rui, "frameOverlayImg", frameOverlayImage )

	if ( offerData.tooltipDesc != "" )
	{
		ToolTipData tooltipData
		tooltipData.titleText = offerData.tooltipTitle
		tooltipData.descText = offerData.tooltipDesc

		Hud_SetToolTipData( button, tooltipData )
	}
	else
	{
		Hud_ClearToolTipData( button )
	}

	bool isPurchasableByLocalPlayer = false
	string priceText                = ""

	Assert( offerData.output.flavors.len() > 0 )

	ItemFlavor itemFlav = offerData.output.flavors[0]

	float vertAlign = 0.0
	switch ( ItemFlavor_GetType( itemFlav ) )
	{
		case eItemType.weapon_skin:
			vertAlign = -0.6
			break

		default:
			vertAlign = -0.1
			break
	}

	if ( GetConVarBool( "assetdownloads_enabled" ) && DidImagePakLoadFail( offerData.imageRef ) )
		vertAlign = -0.1 

	RuiSetFloat( rui, "vertAlign", isTall ? 0.0 : vertAlign )

	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( offerData )

	GRX_PackCollectionInfo packCollectionInfo = GRXOffer_GetEventThematicPackCollectionInfoFromScriptOffer( offerData )

	string originalPriceText = ""
	if ( offerData.originalPrice != null && !isOfferFullyClaimed )
		originalPriceText = GRX_GetFormattedPrice( expect ItemFlavorBag(offerData.originalPrice) )
	RuiSetString( rui, "ecOriginalPrice", originalPriceText )

	if ( !offerData.isAvailable )
	{
		priceText = offerData.unavailableReason
	}
	else if ( isOfferFullyClaimed )
	{
		priceText = "#OWNED"
	}
	else if ( GRXOffer_IsPurchaseLimitReached( offerData ) )
	{
		bool canGift = offerData.isGiftable && IsGiftingEnabled() && CanLocalPlayerGift( offerData )

		if ( !canGift )
		{
			priceText = "#LIMIT_REACHED"
		}
		else
		{
			priceText = "#PURCHASE_AS_GIFT"
		}
	}
	else if ( offerData.prices.len() > 0 )
	{
		
		if ( offerData.prices.len() == 2 )
		{
			array<ItemFlavorBag> orderedPricesList = GRXOffer_GetPricesInPriorityOrder( offerData )
			string firstPrice = GRX_GetFormattedPrice( orderedPricesList[0] )
			string secondPrice = GRX_GetFormattedPrice( orderedPricesList[1] )
			priceText = Localize( "#STORE_PRICE_N_N", firstPrice, secondPrice )
		}
		else
		{
			priceText = GRX_GetFormattedPrice( offerData.prices[0] )
		}

		isPurchasableByLocalPlayer = true
	}
	else
	{
		if( offerData.output.flavors.len() > 1 )
			Warning( "Offer has no price: %s", offerData.offerAlias )
		else
			Warning( "Offer has no price: %s", string(ItemFlavor_GetAsset( itemFlav )) )

		priceText = "#UNAVAILABLE"
	}

	if ( offerData.purchaseLimit > 1 && packCollectionInfo.numTotalInCollection == 0 )
	{
		RuiSetString( rui, "ecDesc", Localize( "#STORE_LIMIT_N", offerData.purchaseLimit ) )
	}
	else
	{
		RuiSetString( rui, "ecDesc", "" )
	}

	int highestItemQuality = 0
	string highestItemQualityName = ""
	foreach ( ItemFlavor flav in offerData.output.flavors )
	{
		if ( ItemFlavor_HasQuality( flav ) && ItemFlavor_GetQuality( flav ) > highestItemQuality )
		{
			highestItemQuality = ItemFlavor_GetQuality( flav )
			highestItemQualityName = ItemFlavor_GetQualityName( itemFlav )
		}
	}

	RuiSetInt( rui, "rarity", highestItemQuality )
	RuiSetString( rui, "rarityName", highestItemQualityName )
	RuiSetString( rui, "ecTitle", Localize( offerData.titleText ) )
	RuiSetString( rui, "tagText", offerData.tagText )
	RuiSetString( rui, "ecPrice", priceText )
	RuiSetInt( rui, "numCollected", packCollectionInfo.numCollected )
	RuiSetInt( rui, "numTotalInCollection", packCollectionInfo.numTotalInCollection )

	int remainingTime = offerData.expireTime - GetUnixTimestamp()
	if ( remainingTime > 0 )
		RuiSetGameTime( rui, "expireTime", ClientTime() + remainingTime )
	else
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

	
	Hud_SetEnabled( button, true )

	if ( offerData.prereq != null )
	{
		ItemFlavor prereqFlav = expect ItemFlavor( offerData.prereq )
		if ( GRX_IsItemOwnedByPlayer( prereqFlav ) )
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_OWNED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
		else
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_LOCKED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
	}
	else
	{
		RuiSetString( rui, "ecReqs", "" )
	}
}


void function OfferButton_AutoAdvanceOffers()
{
	Signal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )
	EndSignal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )

	const float OFFER_DELAY = 7.0
	while ( true )
	{
		foreach ( offerButtonData in s_offers.shopButtonDataArray )
		{
			HudElem_SetRuiArg( offerButtonData.button, "nextOfferChangeTime", ClientTime() + OFFER_DELAY, eRuiArgType.GAMETIME )
		}

		wait OFFER_DELAY

		foreach ( offerButtonData in s_offers.shopButtonDataArray )
		{
			if ( GetFocus() == offerButtonData.button )
				continue

			if ( offerButtonData.offerData.len() < 2 )
				continue

			if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
				continue

			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
		}
	}
}

void function JumpToStoreTab()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )
}

bool function JumpToStorePanel( string panelName )
{
	JumpToStoreTab()
	if ( panelName.len() == 0 )
	{
		printt( "Store panel name was empty." )
		return false
	}
	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	int tabIndex = Tab_GetTabIndexByBodyName( storeTabData, panelName )
	if ( IsTabIndexVisible( storeTabData, tabIndex ) && IsTabIndexEnabled( storeTabData, tabIndex ) )
	{
		ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, panelName ) )
		return true
	}
	printt( "Failed to activate tab \"" + panelName + "\"." )
	return false
}

void function JumpToStoreSection( string sectionName )
{
	RTKStore_SetOverrideStartingSection( STORE_OFFER_SHOP )
	RTKStore_SetStartingSection( sectionName, 0, STORE_OFFER_SHOP )
	StoreTelemetry_SaveDeepLink( sectionName )

	JumpToStoreTab()

	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	storeTabData.activeTabIdx = Tab_GetTabIndexByBodyName( storeTabData, STORE_OFFER_SHOP )

	if ( !IsTabActive( storeTabData ) )
		ActivateTab( storeTabData, storeTabData.activeTabIdx )
}

void function JumpToMythicSection( string sectionName )
{
	RTKStore_SetOverrideStartingSection( STORE_MYTHIC_SHOP )
	RTKStore_SetStartingSection( sectionName, 0, STORE_MYTHIC_SHOP )
	StoreTelemetry_SaveDeepLink( sectionName )

	JumpToHeirloomShop()
}

int function GetBPPresaleOfferType( GRXScriptOffer offer )
{
	bool hasPresaleVoucher = false
	bool hasBPLevels = false
	foreach ( ItemFlavor flav in offer.output.flavors )
	{
		if ( ItemFlavor_GetType( flav ) == eItemType.battlepass_presale_voucher )
		{
			hasPresaleVoucher = true
		}
		else if ( ItemFlavor_GetType( flav ) == eItemType.battlepass_purchased_xp )
		{
			hasBPLevels = true
		}
	}
	if ( hasPresaleVoucher && hasBPLevels )
	{
		return bpPresaleOfferType.BUNDLE
	}
	if ( hasPresaleVoucher )
	{
		return bpPresaleOfferType.BASIC
	}
	return bpPresaleOfferType.NOT_PRESALE
}

void function JumpToBPPresaleStoreOffer( GRXScriptOffer offer, TabDef tabDef )
{
	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	int currentStoreLocation = GetStoreLocationFromPanel( tabDef.panel )
	Assert(tabDef.visible && tabDef.enabled, "Presale store tab location is either invisible or disabled.")
	ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, Hud_GetHudName( tabDef.panel ) ) )
	StoreInspectMenu_AttemptOpenWithOffer( offer )
}

void function OpenBPPresaleDialog( bpPresaleOfferData bpPresaleOffers )
{
	Assert( bpPresaleOffers.basicOffer != null && bpPresaleOffers.bundleOffer != null,
		    "Attempted to Open BP Presale Dialog with a null basic or bundle offer." )
	ConfirmDialogData data
	data.headerText = "#BP_PRESALE_DIALOG_PRIMARY_TEXT"
	data.messageText = "#BP_PRESALE_DIALOG_SECONDARY_TEXT"
	data.yesText = [ "#BP_PRESALE_DIALOG_OPTION_BASIC" "#BP_PRESALE_DIALOG_OPTION_BASIC" ]
	data.noText = [ "#BP_PRESALE_DIALOG_OPTION_BUNDLE" "#BP_PRESALE_DIALOG_OPTION_BUNDLE" ]
	
	data.msgTextVerticalOffset = 150.0

	data.resultCallback = void function ( int result ) : ( bpPresaleOffers )
	{
		TabDef offersTab = expect TabDef( bpPresaleOffers.offerTab )
		if ( result == eDialogResult.YES )
		{
			JumpToBPPresaleStoreOffer( expect GRXScriptOffer( bpPresaleOffers.basicOffer ), offersTab )
		}
		else if ( result == eDialogResult.NO )
		{
			JumpToBPPresaleStoreOffer( expect GRXScriptOffer( bpPresaleOffers.bundleOffer ), offersTab )
		}
	}
	OpenConfirmDialogFromData( data )
}

bpPresaleOfferData function GetBPPresaleOfferData()
{
	bpPresaleOfferData offerData
	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	foreach ( tabDef in storeTabData.tabDefs )
	{
		int currentStoreLocation = GetStoreLocationFromPanel( tabDef.panel )
		if ( !tabDef.visible || !tabDef.enabled )
			continue

		foreach ( GRXScriptOffer offer in GRX_GetStoreOffers( currentStoreLocation ) )
		{
			int offerType = GetBPPresaleOfferType( offer )
			if ( offerType == bpPresaleOfferType.BASIC || offerType == bpPresaleOfferType.BUNDLE )
			{
				offerData.offerTab = tabDef
			}
			switch ( offerType )
			{
				case bpPresaleOfferType.BASIC:
					offerData.basicOffer = offer
					break
				case bpPresaleOfferType.BUNDLE:
					offerData.bundleOffer = offer
					break
				default:
					break
			}
		}
	}
	
	
	Assert( ( offerData.basicOffer == null ) == ( offerData.bundleOffer == null ),
		"The BP Presale period is currently live, but one of the bundle or basic tier offers is null. Both offer tiers must be present while presale is live." )
	return offerData
}

void function JumpToStoreOffer( string panel, string storeOfferName )
{
	if ( !JumpToStorePanel( panel ) )
		return

	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	foreach ( tabDef in storeTabData.tabDefs )
	{
		int currentStoreLocation = GetStoreLocationFromPanel( tabDef.panel )
		if ( !tabDef.visible || !tabDef.enabled )
			continue

		foreach ( offer in GRX_GetStoreOffers( currentStoreLocation ) )
		{
			if ( offer.offerAlias == storeOfferName )
			{
				int currentStoreLocationIndex = Tab_GetTabIndexByBodyName( storeTabData, Hud_GetHudName( tabDef.panel ) )
				ActivateTab( storeTabData, currentStoreLocationIndex )
				StoreInspectMenu_AttemptOpenWithOffer( offer )
				return
			}
		}
	}
}

void function JumpToStorePacks()
{
	JumpToStoreTab()
	TabData legendsTabData = GetTabDataForPanel( file.storePanel )
	ActivateTab( legendsTabData, Tab_GetTabIndexByBodyName( legendsTabData, GetConVarBool( "rtk_enableApexPacksScreen" ) ?  GetApexPacksPanelName() : "LootPanel" ) )
}


void function JumpToHeirloomShop()
{
	JumpToStoreTab()
	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, GetMythicShopName() ) )
}

string function GetMythicShopName()
{
	string panelName = ""

		panelName = STORE_MYTHIC_SHOP




	return panelName
}

string function GetApexPacksPanelName()
{
	string panelName = ""


		panelName = RTK_APEX_PACKS_PANEL




	return panelName
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}

int function GetStoreLocationFromPanel( var panel )
{
	string panelName = Hud_GetHudName( panel )

	switch( panelName )
	{
		case FEATURED_STORE_PANEL:
			return eStoreLocation.SHOP

		case SPECIALS_STORE_PANEL:
			return eStoreLocation.SPECIALS

		case SEASONAL_STORE_PANEL:
			return eStoreLocation.SEASONAL

		default:
			return eStoreLocation.SHOP
	}
	unreachable
}

void function EventStoreTabButton_OnActivate( var button )
{
	if ( GetActiveCollectionEvent( GetUnixTimestamp() ) == null )
		return

	PIN_Store_EventButton( Hud_GetHudName( s_offers.offersPanel ) )
	JumpToEventTab( "CollectionEventPanel" )
}

void function UpdatePackGiftButton( var button, bool hasAsterisk = true )
{
	int giftsLeft = Gifting_GetRemainingDailyGifts()
	bool isPlayerLeveledForGifting = IsPlayerLeveledForGifting()
	bool isPlayerWithinGiftingLimit = IsPlayerWithinGiftingLimit()
	bool isTwoFactorEnabled = IsTwoFactorAuthenticationEnabled()
	bool canLocalPlayerGift = CanLocalPlayerGift()

	string giftMainText = Localize( hasAsterisk ? "#BUY_GIFT_STAR" : "#BUY_GIFT"  )
	string giftDescText = Localize( "#GIFTS_LEFT_FRACTION", giftsLeft )

	Hud_ClearToolTipData( button )

	if ( !canLocalPlayerGift )
	{
		ToolTipData giftTooltipData
		giftMainText = Localize( "#LOCKED_GIFT" )

		if( !isPlayerLeveledForGifting )
		{
			giftDescText = Localize( "#LEVEL_REQUIRED", GetConVarInt( "mtx_giftingMinAccountLevel" ) )
		}
		else if ( !isPlayerWithinGiftingLimit )
		{
			giftTooltipData.titleText =  Localize( "#GIFTS_LEFT", giftsLeft )

			DisplayTime giftTime = SecondsToDHMS( GRX_GetGiftingLimitResetDate() - GetUnixTimestamp() )
			if ( giftTime.hours > 0 )
				giftTooltipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_HOURS", string( GetGiftingMaxLimitPerResetPeriod() ), giftTime.hours )
			else if ( giftTime.minutes > 0 )
				giftTooltipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_MINUTES", string( GetGiftingMaxLimitPerResetPeriod() ), giftTime.minutes )
			else
				giftTooltipData.descText =  Localize( "#GIFTS_MAXED_OUT_REASON_MINUTES", string( GetGiftingMaxLimitPerResetPeriod() ), "<1" )

			Hud_SetToolTipData( button, giftTooltipData )
		}
		else if ( !isTwoFactorEnabled )
		{
			giftDescText = Localize( "#TWO_FACTOR_NEEDED" )

			giftTooltipData.titleText = Localize( "#ENABLE_TWO_FACTOR" )
			giftTooltipData.descText = Localize( "#TWO_FACTOR_NEEDED_DETAILS" )
			giftTooltipData.tooltipFlags = giftTooltipData.tooltipFlags | eToolTipFlag.SOLID
			giftTooltipData.tooltipStyle = eTooltipStyle.DEFAULT

			Hud_SetToolTipData( button, giftTooltipData )
		}
	}

	bool purchaseLock = true
	bool isPurchaseReady = GRX_IsInventoryReady() && GRX_AreOffersReady() && GetLootTickPurchaseOffers() != null
	bool onlyMissingTwoFactor = isPlayerLeveledForGifting && isPlayerWithinGiftingLimit && !isTwoFactorEnabled
	if ( isPurchaseReady && ( canLocalPlayerGift || onlyMissingTwoFactor ) )
	{
		purchaseLock = false
	}

	Hud_SetLocked( button, purchaseLock )

	HudElem_SetRuiArg( button, "buttonText", giftMainText )
	HudElem_SetRuiArg( button, "buttonDescText", giftDescText )
}

void function UpdateDisclaimer( var container )
{
	
	HudElem_SetRuiArg( container, "hideDisclaimer", true )
}

void function TEMP_StoreOffer( var button, table< string, SeasonalStoreData > seasonalDataMap )
{
	OfferButtonData ornull offerButtonData = GetOfferButtonDataByButton( button )

	if ( offerButtonData == null )
		return

	OfferButtonData temp = expect OfferButtonData( offerButtonData )
	file.TEMP_FOR_RTK_TESTING = temp.offerData[0]
	string seasonTag = "default"
	file.TEMP_FOR_RTK_TESTING2 = seasonalDataMap[seasonTag].tallImage
}


bool function HasNewPersonalisedOffers()
{
	array<GRXPersonalizedStoreSlotData> slotData = GetPersonalizedStoreSlotData()
	bool hasNew = false

	foreach ( GRXPersonalizedStoreSlotData data in slotData )
	{
		if ( data.revealStatus == false )
		{
			hasNew = true
			break
		}
	}

	return hasNew
}


void function UpdateHotDropsTab()
{
	SetPanelTabNew( file.hotDropsTab, HasNewPersonalisedOffers() )
}