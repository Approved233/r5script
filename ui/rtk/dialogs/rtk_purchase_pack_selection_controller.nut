global function InitPurchasePackSelectionDialog
global function OpenPurchasePackSelectionDialog

global function RTKPurchasePackSelectionPanel_OnInitialize
global function RTKPurchasePackSelectionPanel_OnDestroy

global function RTKMutator_GetPurchaseDialogButtonTitle
global function RTKMutator_IsPurchaseButtonInteractable

const string SFX_MENU_OPENED = "UI_Menu_Focus_Large"
const int MAX_INFO_SIDES = 2 
global struct RTKPurchasePackSelectionPanel_Properties
{
	rtk_behavior cancelButton
	rtk_behavior purchaseButton
	rtk_panel packButtonsList
}

global struct RTKPurchasePackSelectionButtonModel
{
	string originalPrice
	string price
	int packQuantity
	int discount
}

global struct RTKPurchasePackSelectionModel
{
	string title
	string guaranteedInfo
	bool isGift
	RTKPurchasePackRateSectionInfo& eventItemsSection
	RTKPurchasePackRateSectionInfo& standardItemsSection
	RTKPurchasePackRateSectionInfo& multiItemsSection
	RTKPurchasePackPriceSectionInfo& priceSection
	array<RTKPurchasePackInformationLines> infoLines
	int purchaseButtonState
}

global enum ePurchaseDialogButtonState
{
	AVAILABLE,
	GET_COINS,
	INSUFICIENT_FUNDS,
	UNAVAILABLE
}

struct DialogData
{
	GRXScriptOffer& offer
	bool isGift
	ItemFlavorBag& price
	int quantity = 1
}

struct {
	bool isRestricted
	var	menu
	DialogData& dialogSelectedData
	ItemFlavor& activeEvent
	GRXScriptOffer& singleOffer
	GRXScriptOffer& multipleOffer
} file

void function InitPurchasePackSelectionDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu
	SetDialog( menu, false )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function RTKPurchasePackSelectionPanel_OnInitialize( rtk_behavior self )
{
	ItemFlavor ornull event = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( event == null )
	{
		return
	}
	expect ItemFlavor( event )
	file.activeEvent = event

	EmitUISound( SFX_MENU_OPENED )
	file.isRestricted = GRX_IsOfferRestricted()
	rtk_struct packSelectionPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "packSelectionPage", "RTKPurchasePackSelectionModel" )


	SetUpDialogDataModel( packSelectionPanel )
	SetUpPackSelectionButtonsModel( packSelectionPanel )
	SetUpPackSelectionButtons( self, packSelectionPanel )
	SetUpFooterButtons( self )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "packSelectionPage", true ) )
	AddCallback_OnGRXInventoryStateChanged( UpdatePurchaseButtonData )
}

void function RTKPurchasePackSelectionPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "packSelectionPage" )
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseButtonData )
}

void function SetUpDialogDataModel( rtk_struct packSelectionPanel )
{
	RTKPurchasePackSelectionModel model
	model.eventItemsSection.title = MilestoneEvent_GetEventItemsRatesSectionHeader( file.activeEvent )
	model.eventItemsSection.color = <0.83, 0.66, 0.15>
	model.standardItemsSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_STANDARD_LABEL" )
	model.standardItemsSection.color = <0.7, 0.7, 0.7>
	model.multiItemsSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_MULTIDRAW_LABEL" )
	model.multiItemsSection.color = <0.7, 0.7, 0.7>
	model.priceSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_SINGLE_PACK_LABEL" )
	model.priceSection.color = <0.7, 0.7, 0.7>
	model.isGift = file.dialogSelectedData.isGift

	model.title = MilestoneEvent_GetMainPackShortPluralName( file.activeEvent )
	model.guaranteedInfo = MilestoneEvent_GetGuaranteedPackText( file.activeEvent )
	model.eventItemsSection.rows = MilestoneEvent_GetEventItemRatesData( file.activeEvent )
	model.standardItemsSection.rows = MilestoneEvent_GetStandardItemRatesData( file.activeEvent )
	if ( GRX_EventHasMultiPackOffers( file.activeEvent ) )
	{
		model.multiItemsSection.rows = MilestoneEvent_GetMultiItemRatesData( file.activeEvent )
	}
	model.priceSection.rows.append( MilestoneEvent_GetPricePackRangesData( file.activeEvent ) )
	model.infoLines = MilestoneEvent_GetLegalTextData( file.activeEvent )
	Assert( model.infoLines.len() <= MAX_INFO_SIDES )
	RTKStruct_SetValue( packSelectionPanel, model )
}

void function OpenPurchasePackSelectionDialog( bool isGift )
{
	AdvanceMenu( GetMenu( "PurchasePackSelectionDialog" ) )
	file.dialogSelectedData.isGift = isGift
}

void function SetUpPackSelectionButtonsModel( rtk_struct packSelectionPanel )
{
	array<GRXScriptOffer> singlePurchaseOffers = MilestoneEvent_GetSinglePackOffers( file.activeEvent )
	array<GRXScriptOffer> multiplePurchaseOffers = MilestoneEvent_GetMultiPackOffers( file.activeEvent )

	Assert( singlePurchaseOffers.len() <= 1, "RTK Pack Purchase flow only supports up to ONE [1 pack] offer" )
	Assert( multiplePurchaseOffers.len() <= 1, "RTK Pack Purchase flow only supports up to ONE [multiple pack] offer" )

	

	array<RTKPurchasePackSelectionButtonModel> buttonsDataModel

	bool hasCraftingOffer = false
	RTKPurchasePackSelectionButtonModel singleCraft

	
	if ( singlePurchaseOffers.len() > 0 )
	{
		file.singleOffer = singlePurchaseOffers[0]
		Assert( file.singleOffer.prices.len() <= 2 )

		
		RTKPurchasePackSelectionButtonModel singlePremium

		if ( !file.dialogSelectedData.isGift )
		{
			singlePremium.price = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float( GRXOffer_GetPremiumPriceQuantity( file.singleOffer ) ), true )
			int originalPrice = GRXOffer_GetOriginalPremiumPriceQuantity( file.singleOffer )
			int price = GRXOffer_GetPremiumPriceQuantity( file.singleOffer )
			if ( originalPrice > 0 )
			{
				singlePremium.discount = int( (float((originalPrice - price )) / float(originalPrice)) * 100 )
				singlePremium.originalPrice = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float(originalPrice), true )
			}
		}
		singlePremium.packQuantity = 1
		buttonsDataModel.append( singlePremium )

		
		if ( !file.dialogSelectedData.isGift )
		{
			int craftingPrice = GRXOffer_GetCraftingPriceQuantity( file.singleOffer )
			if ( craftingPrice >= 0 )
			{
				singleCraft.price = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] ) + "% " + FormatAndLocalizeNumber( "1", float( craftingPrice ), true )
				singleCraft.packQuantity = 1
				
				hasCraftingOffer = true
			}
		}
	}

	
	if ( multiplePurchaseOffers.len() > 0 )
	{
		file.multipleOffer = multiplePurchaseOffers[0]
		Assert( file.multipleOffer.prices.len() == 1 )

		
		RTKPurchasePackSelectionButtonModel multiplePremium
		if ( !file.dialogSelectedData.isGift )
		{
			multiplePremium.price = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float( GRXOffer_GetPremiumPriceQuantity( file.multipleOffer ) ), true )
			int originalPrice = GRXOffer_GetOriginalPremiumPriceQuantity( file.multipleOffer )
			int price = GRXOffer_GetPremiumPriceQuantity( file.multipleOffer )
			if ( originalPrice > 0 )
			{
				multiplePremium.discount = int( (float((originalPrice - price )) / float(originalPrice)) * 100 )
				multiplePremium.originalPrice = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float(originalPrice), true )
			}
		}
		multiplePremium.packQuantity = 4
		buttonsDataModel.append( multiplePremium )
	}

	
	if ( hasCraftingOffer )
		buttonsDataModel.append( singleCraft )

	rtk_array packSelectionButtonData = RTKStruct_GetOrCreateScriptArrayOfStructs( packSelectionPanel, "buttonData", "RTKPurchasePackSelectionButtonModel" )
	RTKArray_SetValue( packSelectionButtonData, buttonsDataModel )

	if ( IsValid( file.singleOffer ) )
	{
		
		file.dialogSelectedData.offer = file.singleOffer
	}
	else if ( IsValid( file.multipleOffer ) )
	{
		
		file.dialogSelectedData.offer = file.multipleOffer
	}

	file.dialogSelectedData.price = GetSelectedPriceList()[0]
	UpdatePurchaseButtonData()
}


void function SetUpPackSelectionButtons( rtk_behavior self, rtk_struct packSelectionPanel )
{
	rtk_panel ornull buttonList = self.PropGetPanel( "packButtonsList" )
	if ( buttonList != null )
	{
		expect rtk_panel( buttonList )
		self.AutoSubscribe( buttonList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, packSelectionPanel ) {
			array< rtk_behavior > buttons = newChild.FindBehaviorsByTypeName( "Button" )
			foreach ( button in buttons )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, packSelectionPanel  ) {
					if ( newChildIndex == 0 )
					{
						if ( IsValid( file.singleOffer ) )
						{
							file.dialogSelectedData.offer = file.singleOffer
							file.dialogSelectedData.price = GetSelectedPriceList()[0]
						}
					}
					else if ( newChildIndex == 1 )
					{
						if ( IsValid( file.multipleOffer ) )
						{
							file.dialogSelectedData.offer = file.multipleOffer
							file.dialogSelectedData.price = GetSelectedPriceList()[0]
						}
					}
					else if ( newChildIndex == 2 && !file.dialogSelectedData.isGift )
					{
						if ( IsValid( file.singleOffer ) )
						{
							file.dialogSelectedData.offer = file.singleOffer
							file.dialogSelectedData.price = GetSelectedPriceList()[1]
						}
					}
					UpdatePurchaseButtonData()
				} )
			}
		} )
	}
}

void function SetUpFooterButtons( rtk_behavior self )
{
	rtk_behavior ornull cancelButton = self.PropGetBehavior( "cancelButton" )
	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	expect rtk_behavior( cancelButton )
	expect rtk_behavior( purchaseButton )

	self.AutoSubscribe( cancelButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( ) {
		UICodeCallback_NavigateBack()
	} )

	self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : () {
		if ( !GRX_IsInventoryReady() )
			return

		if ( file.dialogSelectedData.isGift )
		{
			OpenGiftingDialog( file.dialogSelectedData.offer )
			return
		}

		int state = GetPurchaseButtonState()
		if ( state == ePurchaseDialogButtonState.GET_COINS )
		{
			OpenVCPopUp( null )
		}
		else if( state == ePurchaseDialogButtonState.AVAILABLE )
		{
			if ( GRX_QueuedOperationMayDirtyOffers() )
			{
				EmitUISound( "menu_deny" )
				return
			}

			QueuePackPurchaseOperation()
		}
	} )
}

int function GetPurchaseButtonState()
{
	if ( !GRX_IsInventoryReady() )
		return ePurchaseDialogButtonState.UNAVAILABLE

	if ( file.dialogSelectedData.isGift )
	{
		return ePurchaseDialogButtonState.AVAILABLE
	}

	if ( !GRXOffer_IsEligibleForPurchase( file.dialogSelectedData.offer ) )
		return ePurchaseDialogButtonState.UNAVAILABLE

	int state = ePurchaseDialogButtonState.UNAVAILABLE
	if ( GRX_CanAfford( file.dialogSelectedData.price, 1 ) )
	{
		state = ePurchaseDialogButtonState.AVAILABLE
	}
	else if ( GRX_IsPremiumPrice( file.dialogSelectedData.price ) )
	{
		state = ePurchaseDialogButtonState.GET_COINS
	}
	else
	{
		state = ePurchaseDialogButtonState.INSUFICIENT_FUNDS
	}
	return state
}

void function UpdatePurchaseButtonData()
{
	if ( !GRX_IsInventoryReady() )
		return

	rtk_struct packSelectionModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "packSelectionPage", true ) )
	RTKStruct_SetInt( packSelectionModel, "purchaseButtonState", GetPurchaseButtonState() )
}

void function QueuePackPurchaseOperation()
{
	int queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_PACK
	ScriptGRXOperationInfo operation
	operation.expectedQueryGoal = queryGoal
	operation.doOperationFunc = (void function( int opId ) : ( queryGoal ) {
		GRX_PurchaseOffer( opId, queryGoal, file.dialogSelectedData.offer, file.dialogSelectedData.price, file.dialogSelectedData.quantity, null )
	})
	operation.onDoneCallback = (void function( int status ) : ()
	{
		OnPurchaseOperationFinished( status, file.dialogSelectedData.offer, file.dialogSelectedData.price, file.dialogSelectedData.quantity )
	})
	QueueGRXOperation( GetLocalClientPlayer(), operation )
}

array<ItemFlavorBag> function GetSelectedPriceList()
{
	array<ItemFlavorBag> priceList = clone file.dialogSelectedData.offer.prices
	priceList.sort( int function( ItemFlavorBag a, ItemFlavorBag b ) {
		if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) > GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
			return 1

		if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) < GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
			return -1

		return 0
	} )
	return priceList
}

void function OnPurchaseOperationFinished( int status, GRXScriptOffer offer, ItemFlavorBag price, int quantity )
{
	bool wasSuccessful = ( status == eScriptGRXOperationStatus.DONE_SUCCESS )
	string sound = GRXCurrency_GetPurchaseSound( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	if ( wasSuccessful )
	{
		EmitUISound( sound )
		if ( GetActiveMenu() == file.menu )
		{
			MilestoneEvent_PurchasePackDialogOnClose()
			CloseActiveMenu()
		}
	}
	else
	{
		sound = "menu_deny"
		EmitUISound( sound )
	}
}

string function RTKMutator_GetPurchaseDialogButtonTitle( int state, bool isGift = false )
{
	switch ( state )
	{
		case ePurchaseDialogButtonState.INSUFICIENT_FUNDS:
			return Localize( "#CANNOT_AFFORD" )
		case ePurchaseDialogButtonState.GET_COINS:
			return Localize( "#CONFIRM_GET_PREMIUM" )
		case ePurchaseDialogButtonState.AVAILABLE:
			return isGift ? Localize( "#GIFT_DIALOG_SELECT_FRIEND" ) : Localize( "#PURCHASE" )
		case ePurchaseDialogButtonState.UNAVAILABLE:
			return Localize( "#UNAVAILABLE" )
	}
	return Localize( "#UNAVAILABLE" )
}

bool function RTKMutator_IsPurchaseButtonInteractable( int state )
{
	switch ( state )
	{
		case ePurchaseDialogButtonState.GET_COINS:
		case ePurchaseDialogButtonState.AVAILABLE:
			return true
		case ePurchaseDialogButtonState.INSUFICIENT_FUNDS:
		case ePurchaseDialogButtonState.UNAVAILABLE:
			return false
	}
	unreachable
}