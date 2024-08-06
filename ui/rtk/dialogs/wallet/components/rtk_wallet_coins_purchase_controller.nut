global function RTKWalletCoinsPurchasePanel_OnInitialize
global function RTKWalletCoinsPurchasePanel_OnDestroy

global struct RTKWalletCoinsPurchasePanel_Properties
{
	int currencyType
}

global struct CurrencyPurchaseData
{
	asset image
	string originalPriceDesc
	string priceDesc
	string totalValueDesc
	string baseValueDesc
	string bonusDesc
	bool isCondensed
	bool makeRoomForOriginalPrice
	int currencyType
	int spanCellsHorizontal
	int spanCellsVertical
}

global struct CurrencyPurchaseItems
{
	string taxNoticeMessage
	string giftDisclaimer
	string discountText
	asset discountImage
	array<CurrencyPurchaseData> itemsArray
}

struct VCPackDef
{
	int    entitlementId
	string priceString
	string originalPriceString
	int    price
	int    base
	int    bonus
	asset  image = $""
}

struct {
	array<int>   vcPackEntitlements
	array<int>   vcPackBase
	array<int>   vcPackBonus
	array<asset> vcPackImage
	array<VCPackDef> vcPacks
	CurrencyPurchaseItems& itemsData
	int currencyType
} file

void function RTKWalletCoinsPurchasePanel_OnInitialize( rtk_behavior self )
{
	rtk_struct walletCoinsPurchasePanel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "walletCoinsPurchasePanel", "CurrencyPurchaseItems" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "walletCoinsPurchasePanel", true ) )
	RTKWalletCoinsPurchasePanel_SetUpData( self )
	RTKWalletCoinsPurchasePanel_HandleListener( self )
	RegisterSignal( "CurrencyPurchaseShutDown" )
	CurrencyPurchaseItems itemsData
	file.itemsData = itemsData
	ShowOffers()
}

void function RTKWalletCoinsPurchasePanel_SetUpData( rtk_behavior self )
{
	file.currencyType = self.PropGetInt("currencyType")

	if ( file.currencyType == GRX_CURRENCY_PREMIUM )
	{
		file.vcPackEntitlements = [PREMIUM_CURRENCY_10_XPROG, PREMIUM_CURRENCY_05_XPROG, PREMIUM_CURRENCY_20_XPROG, PREMIUM_CURRENCY_40_XPROG, PREMIUM_CURRENCY_60_XPROG, PREMIUM_CURRENCY_100_XPROG]
		file.vcPackBase = [1000, 500, 2000, 4000, 6000, 10000]
		file.vcPackBonus = [0, 0, 150, 350, 700, 1500]
		file.vcPackImage = [$"rui/menu/store/store_coins_t1", $"rui/menu/store/store_coins_t0", $"rui/menu/store/store_coins_t2", $"rui/menu/store/store_coins_t3", $"rui/menu/store/store_coins_t4", $"rui/menu/store/store_coins_t5"]
	}
	else if ( file.currencyType == GRX_CURRENCY_EXOTIC )
	{
		file.vcPackEntitlements = [R5_EXOTIC_CURRENCY_10, R5_EXOTIC_CURRENCY_50, R5_EXOTIC_CURRENCY_110]
		file.vcPackBase = [10, 40, 80]
		file.vcPackBonus = [0, 10, 30]
		file.vcPackImage = [$"rui/menu/store/store_exoticshards_t1", $"rui/menu/store/store_exoticshards_t2", $"rui/menu/store/store_exoticshards_t3"]
	}
}

void function RTKWalletCoinsPurchasePanel_HandleListener( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel().FindChildByName( "Container" )
	self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {

		rtk_behavior button =  newChild.FindChildByName( "CurrencyButton" ).FindBehaviorByTypeName( "Button" )

		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {

			RTKWalletCoinsPurchasePanel_onPressedOffer( newChildIndex )

		} )
	} )
}

void function RTKWalletCoinsPurchasePanel_onPressedOffer( int vcPackIndex )
{

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


	PurchaseEntitlement( file.vcPacks[vcPackIndex].entitlementId )
}

void function RTKWalletCoinsPurchasePanel_OnDestroy( rtk_behavior self )
{
	Signal( uiGlobal.signalDummy, "CurrencyPurchaseShutDown" )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "walletCoinsPurchasePanel" )
	file.vcPacks.clear()
}

void function ShowOffers()
{














	thread Think()
}

void function Think()
{
	EndSignal( uiGlobal.signalDummy, "CurrencyPurchaseShutDown" )

	bool packsInitialized = false

	while ( true )
	{
		if ( !packsInitialized && IsDLCStoreInitialized() && IsFullyConnected() )
		{
			packsInitialized = true
			bool blockVCPanel = GetCurrentPlaylistVarBool( "block_vc_panel", false )
			if ( !blockVCPanel )
				InitVCPacks( )
		}

		CheckEAPlay()

		WaitFrame()
	}
}

void function InitVCPacks()
{
	array<int> vcPriceInts               = GetEntitlementPricesAsInt( file.vcPackEntitlements )
	array<string> vcPriceStrings         = GetEntitlementPricesAsStr( file.vcPackEntitlements )
	array<string> vcOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( file.vcPackEntitlements )

	for ( int vcPackIndex = 0; vcPackIndex < file.vcPackEntitlements.len(); vcPackIndex++ )
	{
		if ( vcPriceStrings[vcPackIndex] == "" )
			continue

		VCPackDef vcPack
		vcPack.entitlementId       = file.vcPackEntitlements[vcPackIndex]
		vcPack.price               = vcPriceInts[vcPackIndex]
		vcPack.priceString         = vcPriceStrings[vcPackIndex]
		vcPack.originalPriceString = vcOriginalPriceStrings[vcPackIndex]
		vcPack.image               = file.vcPackImage[vcPackIndex]
		vcPack.base                = file.vcPackBase[vcPackIndex]
		vcPack.bonus               = file.vcPackBonus[vcPackIndex]
		file.vcPacks.append( vcPack )

		CurrencyPurchaseData purchaseData

		purchaseData.image             = vcPack.image
		purchaseData.originalPriceDesc = vcPack.originalPriceString
		purchaseData.priceDesc         = (vcPack.priceString == "") ? Localize( "#UNAVAILABLE" ) : vcPack.priceString
		purchaseData.totalValueDesc    = GetFormattedValueForCurrency( vcPack.base + vcPack.bonus, file.currencyType )
		purchaseData.bonusDesc         = (vcPack.bonus == 0) ? "" : Localize( "#STORE_VC_BONUS_ADD", FormatAndLocalizeNumber( "1", float( vcPack.bonus ), true ) )
		purchaseData.currencyType      = file.currencyType

		if ( purchaseData.currencyType == GRX_CURRENCY_PREMIUM )
		{
			purchaseData.baseValueDesc     = Localize( "#STORE_VC_BONUS_BASE", FormatAndLocalizeNumber( "1", float( vcPack.base ), true ) )
			purchaseData.spanCellsHorizontal = 1
			if ( vcPackIndex == 0 || vcPackIndex == 1 )
			{
				purchaseData.isCondensed       = true
				purchaseData.makeRoomForOriginalPrice = (purchaseData.originalPriceDesc != "")
				purchaseData.spanCellsVertical = 1
			}
			else
			{
				purchaseData.isCondensed       = false
				purchaseData.makeRoomForOriginalPrice = false
				purchaseData.spanCellsVertical = 2
			}
		}
		else if ( purchaseData.currencyType == GRX_CURRENCY_EXOTIC )
		{
			purchaseData.baseValueDesc     = Localize( "#STORE_VC_EXOTIC_BONUS_BASE", FormatAndLocalizeNumber( "1", float( vcPack.base ), true ) )
			purchaseData.spanCellsHorizontal = 1
			purchaseData.spanCellsVertical = 2
			purchaseData.makeRoomForOriginalPrice = (purchaseData.originalPriceDesc != "")
		}

		file.itemsData.itemsArray.append( purchaseData )
	}

	file.itemsData.taxNoticeMessage = ""
	file.itemsData.giftDisclaimer = ""

	if ( ShouldShowGiftDisclaimer() )
	{
		file.itemsData.giftDisclaimer = "#BUY_GIFT_HOLD_LONG"
	}








	rtk_struct walletCoinsPurchasePanel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "walletCoinsPurchasePanel", "CurrencyPurchaseItems" )
	RTKStruct_SetValue( walletCoinsPurchasePanel, file.itemsData)
}

void function CheckEAPlay()
{
	string prevText = file.itemsData.discountText
	if ( Script_UserHasEAAccess() )
	{
		file.itemsData.discountText = Localize( "#EA_ACCESS_DISCOUNT" )


			file.itemsData.discountImage = $"rui/menu/common/ea_access_pc"







	}
	else
	{
		file.itemsData.discountText  = ""
		file.itemsData.discountImage = $""
	}

	if ( file.itemsData.discountText != prevText )
	{
		rtk_struct walletCoinsPurchasePanel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "walletCoinsPurchasePanel", "CurrencyPurchaseItems" )
		RTKStruct_SetValue( walletCoinsPurchasePanel, file.itemsData)
	}
}