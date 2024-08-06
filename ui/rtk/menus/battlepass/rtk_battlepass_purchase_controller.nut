global function InitRTKBattlePassPurchaseMenu
global function RTKBattlepassPurchasePanel_OnInitialize
global function RTKBattlepassPurchasePanel_OnDestroy
global function OpenBattlepassPurchaseMenu

global enum ePassPurchaseTab
{
	INVALID = -1,
	PREMIUM = 0,
	PREMIUMPLUS = 1,
}

global struct RTKBattlepassPurchasePanel_Properties
{
	rtk_behavior purchasePremiumButton
	rtk_behavior purchasePlusButton
	rtk_behavior moreInfoButton
	rtk_behavior tabController
}

global struct RTKBattlepassPurchasePanel_ModelStruct
{
	bool enablePlusButton = false
	bool enablePremiumButton = false
	bool plusOnlyMode = false
	bool hasDiscount = false
	bool isPlayStation = false
	string priceStringPlus = ""
	string originalPriceStringPlus = ""
	string priceStringPremium = ""
	string originalPriceStringPremium = ""
	string taxNoticeMessage = ""
}

struct PrivateData
{
	void functionref( var button ) openPremiumFunc
	void functionref( var button ) openPlusFunc
	bool plusOnlyMode = false
	rtk_behavior ornull tabController
}

struct
{
	rtk_behavior self
	int targetTab = 1
	table< int, bool > purchasedEntitlements
}file

void function RTKBattlepassPurchasePanel_OnInitialize( rtk_behavior self )
{
	file.self = self

	EmitUISound( "UI_Menu_BattlePass_TierSelect_PremiumPlus" )
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
	p.openPremiumFunc = void function( var button ) : ( self, p ) { if (!p.plusOnlyMode) { OpenPremiumTab( self ) } }
	p.openPlusFunc = void function( var button ) : ( self, p ) { if (!p.plusOnlyMode) { OpenPlusTab( self ) } }

	switch ( file.targetTab )
	{
		case ePassPurchaseTab.PREMIUM:
			EmitUISound( "UI_Menu_BattlePass_TierSelect_Premium" )
			break

		case ePassPurchaseTab.PREMIUMPLUS:
			EmitUISound( "UI_Menu_BattlePass_TierSelect_PremiumPlus" )
			break

	}

	rtk_panel panel = self.GetPanel()
	p.tabController = panel.FindBehaviorByTypeName( "TabController" )

	if ( p.tabController != null )
	{
		rtk_behavior tabController = expect rtk_behavior( p.tabController )
		tabController.PropSetInt( "initialTab", file.targetTab )

		RTKTabController_OnInitialize( tabController )
	}

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, p.openPremiumFunc)
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, p.openPlusFunc)

	OnOpenDLCStore()
}

void function RTKBattlepassPurchasePanel_OnDestroy( rtk_behavior self )
{
	OnCloseDLCStore()

	PrivateData p
	self.Private( p )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "bpPurchase")

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, p.openPremiumFunc)
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, p.openPlusFunc)

	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseButtonData )
	RemoveCallback_OnEntitlementPurchased( OnEntitlementPurchased )
}

void function OpenPlusTab(rtk_behavior self)
{
	PrivateData p
	self.Private( p )
	if ( p.tabController != null )
	{
		rtk_behavior tabController = expect rtk_behavior( p.tabController )
		RTKTabController_OnTabButtonClick( tabController, 1 )
		EmitUISound( "UI_Menu_BattlePass_TierSelect_PremiumPlus" )
	}
}

void function OpenPremiumTab(rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	if ( p.tabController != null )
	{
		rtk_behavior tabController = expect rtk_behavior( p.tabController )
		RTKTabController_OnTabButtonClick( tabController, 0 )
		EmitUISound( "UI_Menu_BattlePass_TierSelect_Premium" )
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
	bool hasPremiumPass = DoesPlayerOwnBattlePass( LocalPlayer, activePass )
	bool hasElitePass = DoesPlayerOwnEliteBattlePass( LocalPlayer, activePass )
	bool canUpgradePass = hasPremiumPass && !hasElitePass

	if ( canUpgradePass )
	{
		file.targetTab = ePassPurchaseTab.PREMIUMPLUS
		if ( p.tabController != null )
		{
			
			rtk_behavior tabController = expect rtk_behavior( p.tabController )
			RTKTabController_OnTabButtonClick( tabController, ePassPurchaseTab.PREMIUMPLUS )
		}
	}

	p.plusOnlyMode = canUpgradePass

	RTKStruct_SetBool( modelStruct, "enablePremiumButton", !hasPremiumPass )
	RTKStruct_SetBool( modelStruct, "enablePlusButton", !hasElitePass )
	RTKStruct_SetBool( modelStruct, "plusOnlyMode", p.plusOnlyMode )





	array<int> bpTierEntitlements = [ R5_BATTLEPASS_1, R5_BATTLEPASS_1_PLUS, R5_BATTLEPASS_1_UPGRADE ]
	array<string> bpTierCurrentPriceStrings =  GetEntitlementPricesAsStr( bpTierEntitlements )
	array<string> bpTierOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( bpTierEntitlements )

	if( bpTierCurrentPriceStrings.len() == 3 )
	{
		if( !Script_UserHasEAAccess() )
		{
			RTKStruct_SetString( modelStruct, "priceStringPremium",  bpTierCurrentPriceStrings[0] )
			if ( !canUpgradePass )
			{
				RTKStruct_SetString( modelStruct, "priceStringPlus", bpTierCurrentPriceStrings[1] )
			}
			else
			{
				RTKStruct_SetString( modelStruct, "priceStringPlus",  bpTierCurrentPriceStrings[2] )
			}
		}
		else
		{
			RTKStruct_SetBool( modelStruct, "hasDiscount", true )

			RTKStruct_SetString( modelStruct, "priceStringPremium",  bpTierCurrentPriceStrings[0] )
			RTKStruct_SetString( modelStruct, "originalPriceStringPremium",  bpTierOriginalPriceStrings[0] )
			if ( !canUpgradePass )
			{
				RTKStruct_SetString( modelStruct, "priceStringPlus", bpTierCurrentPriceStrings[1] )
				RTKStruct_SetString( modelStruct, "originalPriceStringPlus",  bpTierOriginalPriceStrings[1] )
			}
			else
			{
				RTKStruct_SetString( modelStruct, "priceStringPlus",  bpTierCurrentPriceStrings[2] )
				RTKStruct_SetString( modelStruct, "originalPriceStringPlus",  bpTierOriginalPriceStrings[2] )
			}
		}

		rtk_behavior ornull purchasePremiumButton = self.PropGetBehavior( "purchasePremiumButton" )
		if ( purchasePremiumButton != null )
		{
			expect rtk_behavior( purchasePremiumButton )

			self.AutoSubscribe( purchasePremiumButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, bpTierEntitlements ) {
				PIN_UIInteraction_OnClick( "menu_rtkbattlepasspurchasemenu", button.GetPanel().GetDisplayName() )
				AttemptBattlePassPurchase( bpTierEntitlements[0] )
			} )
		}

		rtk_behavior ornull purchasePlusButton = self.PropGetBehavior( "purchasePlusButton" )
		if ( purchasePlusButton != null )
		{
			expect rtk_behavior( purchasePlusButton )

			self.AutoSubscribe( purchasePlusButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, bpTierEntitlements, canUpgradePass ) {
				PIN_UIInteraction_OnClick( "menu_rtkbattlepasspurchasemenu", button.GetPanel().GetDisplayName() )
				if(!canUpgradePass)
					AttemptBattlePassPurchase( bpTierEntitlements[1], bpTierEntitlements[2] )
				else
					AttemptBattlePassPurchase( bpTierEntitlements[2] )
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

void function OpenBattlepassPurchaseMenu( int tab = ePassPurchaseTab.PREMIUMPLUS )
{
	var menu = GetMenu("RTKBattlepassPurchaseMenu")
	if ( GetActiveMenu() == menu )
		return
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
	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}

