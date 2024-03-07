global function RTKStore_CreateOfferButtonModel
global function RTKOfferButton_OnInitialize
global function RTKOfferButton_OnDestroy
global function RTKOfferButton_RemoveEventListener
global function RTKOfferButton_FailedButton

global struct RTKOfferButton_Properties
{
	int slotIndex
	int offerIndex
	rtk_behavior buttonBehavior
	rtk_panel purchaseLimitParent
}

global struct RTKOfferButtonModel
{
	int offerIndex

	asset offerImage
	bool newPriceShow

	int rarity

	string newPrice
	string offerName
	string offerType
	string price
	string discount
	string purchaseLimit
	string imageRef
	int	   pakType
	asset  sourceIcon

	vector priceColor
	vector newPriceColor

	bool   isOnlyGiftable
}

struct PrivateData
{
	int eventListener
}

RTKOfferButtonModel function RTKStore_CreateOfferButtonModel( GRXScriptOffer offer )
{
	RTKOfferButtonModel offerButtonModel


	offerButtonModel.offerIndex = RTKStore_RegisterOffer( offer )


	if( offer.titleText == "Offer Title" || offer.prices.len() == 0 )
	{
		return RTKOfferButton_FailedButton()
	}

	ItemFlavor itemFlav = offer.output.flavors[0]
	int rarity = 0

	ItemFlavorBag ornull OriginalPrice = null

	if ( offer.originalPrice != null )
		OriginalPrice = expect ItemFlavorBag( offer.originalPrice )

	foreach ( ItemFlavor flav in offer.output.flavors )
	{
		if ( ItemFlavor_HasQuality( flav ) && ItemFlavor_GetQuality( flav ) >= rarity )
		{
			rarity = ItemFlavor_GetQuality( flav )
		}
	}

	offerButtonModel.rarity = rarity + 1
	offerButtonModel.imageRef = offer.imageRef
	offerButtonModel.offerName = offer.titleText
	offerButtonModel.priceColor = <1, 1, 1>

	offerButtonModel.isOnlyGiftable = GRXOffer_IsOfferOnlyGiftable( offer )

	string offerTypeName
	if ( offer.output.flavors.len() > 1 )
	{
		
		int lastIndex = offer.items.len() - 1
		if ( offer.items[lastIndex].itemType == GRX_OFFERITEMTYPE_BONUS )
		{
			offerTypeName = Localize( "#BONUS_BUNDLE" )
		}
		else if ( ItemFlavor_GetType( itemFlav ) == eItemType.account_pack )
		{
			if ( ItemFlavor_IsThematic( itemFlav ) )
			{
				offerTypeName = Localize( "#THEMATIC_PACKS" )
			}
			else if ( ItemFlavor_GetAccountPackType( itemFlav ) == eAccountPackType.EVENT )
			{
				offerTypeName = Localize( "#EVENT_PACK_BUNDLE" )
			}
			else
			{
				offerTypeName = Localize( "#APEX_PACK_BUNDLE" )
			}
		}
		else
		{
			offerTypeName = Localize( "#BUNDLE" )
		}
	}
	else if ( ItemFlavor_IsThematic( itemFlav ) )
	{
		offerTypeName = Localize( "#THEMATIC_PACK" )
	}
	else
	{
		offerTypeName = ItemFlavor_GetRewardShortDescription( itemFlav )
	}

	offerButtonModel.offerType = offerTypeName

	foreach( flav in offer.output.flavors )
	{
		asset sourceIcon = ItemFlavor_GetSourceIcon( flav )

		if ( sourceIcon != $"" )
		{
			offerButtonModel.sourceIcon = ItemFlavor_GetSourceIcon( flav )
			break
		}
	}

	if ( offer.purchaseLimit > 1 )
	{
		int purchaseCount = offer.purchaseCount

		if( GRXOffer_IsFullyClaimed( offer ) )
			purchaseCount = offer.purchaseLimit
		offerButtonModel.purchaseLimit = Localize( "#STORE_V2_PURCHASE_LIMIT", purchaseCount, offer.purchaseLimit )
	}

	if ( offerButtonModel.isOnlyGiftable )
		return offerButtonModel

	if ( GRXOffer_IsFullyClaimed( offer ) )
	{
		offerButtonModel.price        = Localize( "#OWNED" )
		offerButtonModel.newPriceShow = false
	}
	else if ( offer.prices.len() > 1 )
	{
		offerButtonModel.price = Localize( "#STORE_PRICE_N_N", GRX_GetFormattedPrice( offer.prices[1], 1 ), GRX_GetFormattedPrice( offer.prices[0], 1 ) )
	}
	else
	{
		if ( OriginalPrice != null  )
		{
			offerButtonModel.price      = Localize( GRX_GetFormattedPrice( expect ItemFlavorBag( OriginalPrice ), 1  ) )
			offerButtonModel.priceColor = < 0.3, 0.3, 0.3 >

			offerButtonModel.newPriceShow = true

			offerButtonModel.newPrice      = GRX_GetFormattedPrice( offer.prices[0], 1  )
			offerButtonModel.newPriceColor = < 1, 1, 1 >

			ItemFlavorBag origPrice = expect ItemFlavorBag( OriginalPrice )

			if ( origPrice == offer.prices[0] )
				offerButtonModel.newPriceShow = false

			float originalPrice = origPrice.quantities[0].tofloat()
			float newPrice = offer.prices[0].quantities[0].tofloat()
			float discount = ( ( originalPrice - newPrice )  / originalPrice ) * 100

			offerButtonModel.discount = Localize("#STORE_BUTTON_DISCOUNT", int( discount ) )
		}
		else
		{
			offerButtonModel.newPriceShow = false
			offerButtonModel.price        = Localize( GRX_GetFormattedPrice( offer.prices[0], 1 ) )
		}
	}

	return offerButtonModel
}

void function RTKOfferButton_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_behavior ornull button = self.PropGetBehavior( "buttonBehavior" )

	if ( button )
	{
		expect rtk_behavior ( button )
		p.eventListener = button.AddEventListener( "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) { RTKOfferButton_OnActivate( self ) } )
	}

	RTKStruct_AddPropertyListener( self.GetProperties(), "offerIndex", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKOfferButton_InstatiateExtraComponents( self )
	} )
}

void function RTKOfferButton_InstatiateExtraComponents( rtk_behavior self )
{
	int offerIndex = self.PropGetInt( "offerIndex" )
	GRXScriptOffer offer = RTKStore_GetOfferFromIndex( offerIndex )

	if ( offer.purchaseLimit > 1 )
	{
		rtk_panel ornull purchaseLimitParent = self.PropGetPanel( "purchaseLimitParent" )

		if ( purchaseLimitParent )
		{
			expect rtk_panel ( purchaseLimitParent )

			asset prefab = $"ui_rtk/menus/store/components/store_purchase_limit.rpak"
			rtk_panel purchaseLimitPanel = RTKPanel_Instantiate( prefab, purchaseLimitParent, "PurchaseLimit" )
			purchaseLimitPanel.SetBindingRootPath( "*" )
		}
	}

	if ( GRXOffer_IsOfferOnlyGiftable( offer ) )
	{
		rtk_panel freeToGiftParent = self.GetPanel()

		asset prefab              = $"ui_rtk/menus/store/components/store_free_to_gift_panel.rpak"
		rtk_panel freeToGiftPanel = RTKPanel_Instantiate( prefab, freeToGiftParent, "freeToGift" )
		freeToGiftPanel.SetBindingRootPath( "*" )
		freeToGiftPanel.SetSiblingIndex( freeToGiftParent.GetChildCount() - 2 )
	}
}

void function RTKOfferButton_OnDestroy( rtk_behavior self )
{
	RTKOfferButton_RemoveEventListener( self )
}

void function RTKOfferButton_RemoveEventListener( rtk_behavior self )
{
	rtk_behavior ornull button = self.PropGetBehavior( "buttonBehavior" )

	int listenerID = GetOnPressedEventListener( self )

	if ( button && listenerID != RTKEVENT_INVALID )
	{
		expect rtk_behavior ( button )
		button.RemoveEventListener( "OnPressed", listenerID )
	}
}

void function RTKOfferButton_OnActivate( rtk_behavior self )
{

	int offerIndex = self.PropGetInt( "offerIndex" )
	GRXScriptOffer offer = RTKStore_GetOfferFromIndex( offerIndex )

	if ( offer.output.flavors.len() > 0 )
		StoreInspectMenu_AttemptOpenWithOffer( offer )

	EmitUISound( "UI_Menu_Accept" )

	int slotIndex = self.PropGetInt( "slotIndex" )
	RTKStore_InspectOffer_SaveTelemetryData( offer, slotIndex )
	StoreTelemetry_SendOferPageViewEvent()

}

int function GetOnPressedEventListener( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	return p.eventListener
}



RTKOfferButtonModel function RTKOfferButton_FailedButton()
{
	RTKOfferButtonModel offerButtonModel

	int rarity = 0
	ItemFlavorBag ornull OriginalPrice = null
	rarity                        = 1
	offerButtonModel.rarity       = rarity + 1
	offerButtonModel.offerImage   = $"ui_image/rui/menu/image_download/image_load_failed_store_vertical.rpak"
	offerButtonModel.offerName    = Localize( "" )
	offerButtonModel.newPriceShow = false
	offerButtonModel.price        = Localize( "" )
	offerButtonModel.priceColor   = < 1, 1, 1 >

	return offerButtonModel
}
