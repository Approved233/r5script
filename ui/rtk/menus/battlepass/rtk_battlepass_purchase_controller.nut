global function InitRTKBattlePassPurchaseMenu
global function RTKBattlepassPurchasePanel_OnInitialize
global function RTKBattlepassPurchasePanel_OnDestroy
global function OpenBattlepassPurchaseMenu

global enum ePassPurchaseTab
{
	INVALID = -1,
	PREMIUM = 0,
	ULTIMATE = 1,
	ULTIMATE_PLUS = 2,
}

global struct RTKBattlepassPurchasePanel_Properties
{
	rtk_behavior purchasePremiumButton
	rtk_behavior purchaseUltimateButton
	rtk_behavior purchaseUltimatePlusButton
	rtk_behavior moreInfoButton
	rtk_behavior tabController
}

global struct RTKBattlepassPurchasePanel_ModelStruct
{
	bool   showPremiumTab = false
	bool   showUltimateTab = false
	bool   showUltimatePlusTab = false
	int	   bpOwnershipTier = eBattlePassV2OwnershipTier.INVALID
	bool   hasDiscount = false
	bool   isPlayStation = false
	string priceStringPremium = ""
	string priceStringUltimate = ""
	string originalPriceStringUltimate = ""
	string priceStringUltimatePlus = ""
	string originalPriceStringUltimatePlus = ""
	string taxNoticeMessage = ""
}

struct PrivateData
{
	void functionref() OnGRXStateChanged
	void functionref( var button ) openPreviousTab
	void functionref( var button ) openNextTab
	rtk_behavior ornull tabController
	bool purchaseAttempted = false
}

struct
{
	rtk_behavior self
	int targetTab = 1
	table< int, bool > purchasedEntitlements
}file

void function RTKBattlepassPurchasePanel_OnInitialize( rtk_behavior self )
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	file.self = self

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "bpPurchase", true ) )

	AddCallback_OnEntitlementPurchased( OnEntitlementPurchased )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePurchaseButtonData )

	ItemFlavor ornull bpFlavor = GetActiveBattlePassV2()
	if ( bpFlavor == null )
	{
		return
	}

	PrivateData p
	self.Private( p )

	p.openPreviousTab = void function( var button ) : ( self, p ) {
		OpenPreviousTab( self )
	}

	p.openNextTab     = void function( var button ) : ( self, p ) {
		OpenNextTab( self )
	}

	rtk_panel panel = self.GetPanel()
	p.tabController = panel.FindBehaviorByTypeName( "TabController" )

	if ( p.tabController != null )
	{
		rtk_behavior tabController = expect rtk_behavior( p.tabController )
		tabController.PropSetInt( "initialTab", file.targetTab )

		RTKTabController_OnInitialize( tabController )

		if ( file.targetTab == 0 )
		{
			EmitUISound( "UI_Menu_BattlePass_TierSelect_Premium" )
			OnCloseDLCStore()
		}
		else if ( file.targetTab == 1 || file.targetTab == 2 )
		{
			EmitUISound( "UI_Menu_BattlePass_TierSelect_PremiumPlus" )
			OnOpenDLCStore()
		}
	}

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, p.openPreviousTab)
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, p.openNextTab)

	p.OnGRXStateChanged = (void function() : (self )
	{
		if ( !GRX_IsInventoryReady() )
			return

		if ( !GRX_AreOffersReady() )
			return

		ItemFlavor ornull bpFlavor = GetActiveBattlePassV2()
		if ( bpFlavor == null )
		{
			return
		}
		expect ItemFlavor( bpFlavor )

		entity LocalPlayer = GetLocalClientPlayer()
		bool hasUltimatePlusPass = DoesPlayerOwnBattlePassTier( LocalPlayer, bpFlavor, eBattlePassV2OwnershipTier.ULTIMATE_PLUS )
		bool isRestricted = GRX_IsOfferRestricted()

		PrivateData p
		self.Private( p )

		if ( p.purchaseAttempted )
		{
			if ( !hasUltimatePlusPass && !isRestricted )
			{
				if ( p.tabController != null )
				{
					file.targetTab = ePassPurchaseTab.ULTIMATE_PLUS
					rtk_behavior tabController = expect rtk_behavior( p.tabController )
					RTKTabController_OnTabButtonClick( tabController, ePassPurchaseTab.ULTIMATE_PLUS )
				}
			}
			else
			{
				OnMenuClose()
			}
		}
	})

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function RTKBattlepassPurchasePanel_OnDestroy( rtk_behavior self )
{
	OnCloseDLCStore()

	PrivateData p
	self.Private( p )

	RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "bpPurchase")

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, p.openPreviousTab)
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, p.openNextTab)

	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseButtonData )
	RemoveCallback_OnEntitlementPurchased( OnEntitlementPurchased )
}



bool function IsTabIndexUnlocked( int index )
{
	ItemFlavor ornull bpFlavor = GetActiveBattlePassV2()
	if ( bpFlavor == null )
	{
		return false
	}
	expect ItemFlavor( bpFlavor )

	entity LocalPlayer = GetLocalClientPlayer()
	int bpOwnershipTier = GetPlayerBattlePassTier( LocalPlayer, bpFlavor )
	bool isRestricted = GRX_IsOfferRestricted()
	if ( isRestricted && index > 0 )
		return false

	return bpOwnershipTier < index + 1
}

void function OpenNextTab( rtk_behavior self )
{
	rtk_behavior tabController = self.PropGetBehavior( "tabController" )

	if ( tabController != null )
	{
		int currentTab = RTKTabController_GetCurrentTabIndex( tabController )
		if ( !IsTabIndexUnlocked( currentTab + 1 ) )
			return

		RTKTabController_NextTab( tabController )
		OnTabOpen( self )
	}
}

void function OpenPreviousTab(rtk_behavior self )
{
	rtk_behavior tabController = self.PropGetBehavior( "tabController" )

	if ( tabController != null )
	{
		int currentTab = RTKTabController_GetCurrentTabIndex( tabController )
		if ( !IsTabIndexUnlocked( currentTab - 1 ) )
			return

		RTKTabController_PrevTab( tabController )
		OnTabOpen( self )
	}
}

void function OnTabOpen( rtk_behavior self )
{
	rtk_behavior tabController = self.PropGetBehavior( "tabController" )

	if ( tabController != null )
	{
		int currentTab = RTKTabController_GetCurrentTabIndex( tabController )

		if ( currentTab == 0 )
		{
			EmitUISound( "UI_Menu_BattlePass_TierSelect_Premium" )
			OnCloseDLCStore()
		}
		else if ( currentTab == 1 || currentTab == 2 )
		{
			EmitUISound( "UI_Menu_BattlePass_TierSelect_PremiumPlus" )
			OnOpenDLCStore()
		}
	}
}

void function InitRTKBattlePassPurchaseMenu( var newMenuArg )
{
	var menu = newMenuArg
	SetDialog( menu, false )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", HandleBackButton )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMenuClose )
}

void function RTKBattlepassPurchasePanel_SetUpPurchaseButtons( rtk_behavior self, rtk_struct modelStruct, ItemFlavor activePass )
{
	PrivateData p
	self.Private( p )

	entity LocalPlayer = GetLocalClientPlayer()
	bool hasPremiumPass = DoesPlayerOwnBattlePassTier( LocalPlayer, activePass, eBattlePassV2OwnershipTier.PREMIUM )
	bool hasUltimatePass = DoesPlayerOwnBattlePassTier( LocalPlayer, activePass, eBattlePassV2OwnershipTier.ULTIMATE )
	bool hasUltimatePlusPass = DoesPlayerOwnBattlePassTier( LocalPlayer, activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS )
	bool isRestricted = GRX_IsOfferRestricted()
	bool canUpgradePass = hasUltimatePass && !hasUltimatePlusPass && !isRestricted 
	int bpOwnershipTier = GetPlayerBattlePassTier( LocalPlayer, activePass )

	RTKStruct_SetBool( modelStruct, "showPremiumTab", !hasPremiumPass )
	RTKStruct_SetBool( modelStruct, "showUltimateTab", !hasUltimatePass && !isRestricted )
	RTKStruct_SetBool( modelStruct, "showUltimatePlusTab", !hasUltimatePlusPass && !isRestricted  )
	RTKStruct_SetInt( modelStruct, "bpOwnershipTier", bpOwnershipTier )





	array<int> bpTierEntitlements = [ BattlepassGetEntitlementUltimate(), BattlepassGetEntitlementUltimatePlus(), BattlepassGetEntitlementUltToUltPlus() ]
	array<string> bpTierCurrentPriceStrings =  GetEntitlementPricesAsStr( bpTierEntitlements )
	array<string> bpTierOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( bpTierEntitlements )

	array<GRXScriptOffer> premiumPassOfferArray = GRX_GetItemDedicatedStoreOffers( activePass, "battlepass" )
	if ( premiumPassOfferArray.len() > 0 )
	{
		string priceStringPremium = Localize( GRX_GetFormattedPrice( premiumPassOfferArray[0].prices[0], 1 ) )
		RTKStruct_SetString( modelStruct, "priceStringPremium",  priceStringPremium )
	}
	else
	{
		Assert( false,"RTKBattlepassPurchasePanel_SetUpPurchaseButtons: premiumPassOfferArray was empty" )
	}

	if ( bpTierCurrentPriceStrings.len() == 3 && bpTierOriginalPriceStrings.len() == 3 )
	{
		if ( !Script_UserHasEAAccess() )
		{
			RTKStruct_SetString( modelStruct, "priceStringUltimate",  bpTierCurrentPriceStrings[0] )
			RTKStruct_SetString( modelStruct, "originalPriceStringUltimate",  "" )
			RTKStruct_SetString( modelStruct, "originalPriceStringUltimatePlus",  "" )

			if ( !canUpgradePass )
			{
				RTKStruct_SetString( modelStruct, "priceStringUltimatePlus", bpTierCurrentPriceStrings[1] )
			}
			else
			{
				RTKStruct_SetString( modelStruct, "priceStringUltimatePlus",  bpTierCurrentPriceStrings[2] )
			}
		}
		else
		{
			RTKStruct_SetBool( modelStruct, "hasDiscount", true )

			RTKStruct_SetString( modelStruct, "priceStringUltimate",  bpTierCurrentPriceStrings[0] )
			RTKStruct_SetString( modelStruct, "originalPriceStringUltimate",  bpTierOriginalPriceStrings[0] )
			if ( !canUpgradePass )
			{
				RTKStruct_SetString( modelStruct, "priceStringUltimatePlus", bpTierCurrentPriceStrings[1] )
				RTKStruct_SetString( modelStruct, "originalPriceStringUltimatePlus",  bpTierOriginalPriceStrings[1] )
			}
			else
			{
				RTKStruct_SetString( modelStruct, "priceStringUltimatePlus",  bpTierCurrentPriceStrings[2] )
				RTKStruct_SetString( modelStruct, "originalPriceStringUltimatePlus",  bpTierOriginalPriceStrings[2] )
			}
		}

		rtk_behavior ornull purchasePremiumButton = self.PropGetBehavior( "purchasePremiumButton" )
		if ( purchasePremiumButton != null )
		{
			expect rtk_behavior( purchasePremiumButton )

			self.AutoSubscribe( purchasePremiumButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, activePass, bpTierEntitlements ) {
				PIN_UIInteraction_OnClick( "menu_rtkbattlepasspurchasemenu", button.GetPanel().GetDisplayName() )

				GRXScriptOffer basicPurchaseOffer = GRX_GetItemDedicatedStoreOffers( activePass, "battlepass" )[0]

				PurchaseDialogConfig pdc
				pdc.offer = basicPurchaseOffer
				pdc.quantity = 1
				pdc.onPurchaseResultCallback = (void function( bool successful ) : (  ) {  } )
				pdc.purchaseSoundOverride = "UI_Menu_BattlePass_Purchase"
				PurchaseDialog( pdc )

				PrivateData p
				self.Private( p )
				p.purchaseAttempted = true
			} )
		}

		rtk_behavior ornull purchaseUltimateButton = self.PropGetBehavior( "purchaseUltimateButton" )
		if ( purchaseUltimateButton != null )
		{
			expect rtk_behavior( purchaseUltimateButton )

			self.AutoSubscribe( purchaseUltimateButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, bpTierEntitlements, bpTierCurrentPriceStrings ) {
				if ( bpTierCurrentPriceStrings[0] == "" )
				{
					Assert( false, "RTKBattlepassPurchasePanel_SetUpPurchaseButtons: price was empty" )
					return
				}
				PIN_UIInteraction_OnClick( "menu_rtkbattlepasspurchasemenu", button.GetPanel().GetDisplayName() )
				AttemptBattlePassPurchase( bpTierEntitlements[0] )

				PrivateData p
				self.Private( p )
				p.purchaseAttempted = true
			} )
		}

		rtk_behavior ornull purchaseUltimatePlusButton = self.PropGetBehavior( "purchaseUltimatePlusButton" )
		if ( purchaseUltimatePlusButton != null )
		{
			expect rtk_behavior( purchaseUltimatePlusButton )

			self.AutoSubscribe( purchaseUltimatePlusButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, bpTierEntitlements, canUpgradePass, bpTierCurrentPriceStrings ) {
				PIN_UIInteraction_OnClick( "menu_rtkbattlepasspurchasemenu", button.GetPanel().GetDisplayName() )

				if ( !canUpgradePass )
				{
					if ( bpTierCurrentPriceStrings[1] == "" )
					{
						Assert( false, "RTKBattlepassPurchasePanel_SetUpPurchaseButtons: price was empty" )
						return
					}
					AttemptBattlePassPurchase( bpTierEntitlements[1], bpTierEntitlements[2] )

					PrivateData p
					self.Private( p )
					p.purchaseAttempted = true
				}
				else
				{
					if ( bpTierCurrentPriceStrings[2] == "" )
					{
						Assert( false, "RTKBattlepassPurchasePanel_SetUpPurchaseButtons: price was empty" )
						return
					}
					AttemptBattlePassPurchase( bpTierEntitlements[2] )

					PrivateData p
					self.Private( p )
					p.purchaseAttempted = true
				}
			} )
		}
	}

	rtk_behavior ornull moreInfoButton = self.PropGetBehavior( "moreInfoButton" )
	if ( moreInfoButton != null )
	{
		expect rtk_behavior ( moreInfoButton )

		self.AutoSubscribe( moreInfoButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			CloseAllMenus()
			AdvanceMenu( GetMenu( "RTKBattlePassMoreInfoMenu" ) )
		} )
	}







}

void function UpdatePurchaseButtonData()
{
	if ( !GRX_IsInventoryReady() )
	{
		return
	}

	ItemFlavor ornull bpFlavor = GetActiveBattlePassV2()
	if ( bpFlavor == null )
	{
		return
	}
	expect ItemFlavor( bpFlavor )

	rtk_struct bpPurchaseModelStruct = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "bpPurchase", "RTKBattlepassPurchasePanel_ModelStruct" )
	RTKBattlepassPurchasePanel_SetUpPurchaseButtons( file.self, bpPurchaseModelStruct, bpFlavor )
}

void function OnEntitlementPurchased( int entitlementID )
{
	if ( entitlementID in file.purchasedEntitlements )
	{
		return
	}

	file.purchasedEntitlements[entitlementID] <- true
}

void function AttemptBattlePassPurchase( int entitlementID, int secondaryEntitlementID = -1 )
{
	if ( entitlementID in file.purchasedEntitlements || ( secondaryEntitlementID >= 0 && secondaryEntitlementID in file.purchasedEntitlements ) )
	{
		
		return
	}


		if ( !PCPlat_IsOverlayAvailable() )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			ConfirmDialogData dialogData
			dialogData.headerText = ""
			dialogData.messageText = "#" + platname + "_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}

		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_STORE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}


	PurchaseEntitlement( entitlementID )
}

void function OpenBattlepassPurchaseMenu( int tab = ePassPurchaseTab.ULTIMATE_PLUS )
{
	var menu = GetMenu("RTKBattlepassPurchaseMenu")
	if ( GetActiveMenu() == menu )
		return

	bool isRestricted = GRX_IsOfferRestricted( GetLocalClientPlayer() )
	if ( isRestricted && tab > ePassPurchaseTab.PREMIUM )
	{
		tab = ePassPurchaseTab.PREMIUM
	}

	file.targetTab = tab

	AdvanceMenu( menu )
}

void function HandleBackButton( var unused )
{
	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}

void function OnMenuClose()
{
	if ( !IsFullyConnected() )
		return

	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}

