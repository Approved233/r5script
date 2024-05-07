global function RTKStore_PopulateOfferSetButtonModel
global function RTKStore_GetSelectedOfferSet

global function RTKOfferSetButton_OnInitialize
global function RTKOfferSetButton_OnDestroy

global struct RTKOfferSetButton_Properties
{
	rtk_behavior buttonBehavior
	int setIndex
}

struct PrivateData
{
	int eventListener
}

struct
{
	int selectedSetIndex
} file

bool function RTKStore_PopulateOfferSetButtonModel( RTKOfferButtonModel offerSetButtonModel, int setIndex )
{
	array< ItemFlavor > setItems = Artifacts_GetSetItems( setIndex )
	if ( setItems.len() < 2 )
		return false

	ItemFlavor firstItem = setItems[0]
	array<GRXScriptOffer> firstItemOffers = GRX_GetItemDedicatedStoreOffers( firstItem, "artifact_set_shop" )
	if ( firstItemOffers.len() == 0 )
		return false

	
	ItemFlavor secondItem = setItems[1]
	array<GRXScriptOffer> secondItemOffers = GRX_GetItemDedicatedStoreOffers( secondItem, "artifact_set_shop" )
	if ( secondItemOffers.len() == 0 )
		return false

	
	ItemFlavor ornull prereq = firstItemOffers[0].prereq
	bool locked = ( prereq != null && !GRX_IsItemOwnedByPlayer( expect ItemFlavor( prereq ) ) )

	ArtifactThemeUIData uiData = Artifacts_GetSetUIData( setIndex )

	int numOwned = 0
	foreach ( ItemFlavor item in setItems )
	{
		if ( GRX_IsItemOwnedByPlayer( item ) )
			numOwned++
	}

	offerSetButtonModel.imageRef = uiData.imageRef
	offerSetButtonModel.offerName = uiData.name
	offerSetButtonModel.offerType = Localize( locked ? "#ARTIFACT_SET_LOCKED" : "#ARTIFACT_SET_UNLOCKED" )
	offerSetButtonModel.purchaseLimit = Localize( "#OWNED_COLLECTED", numOwned, setItems.len() )
	offerSetButtonModel.priceColor = < 0.596, 0.596, 0.596 >
	offerSetButtonModel.price = ( numOwned == setItems.len() ) ? Localize( "#SET_OWNED" ) : Localize( "#PER_ITEM", GRX_GetFormattedPrice( secondItemOffers[0].prices[0], 1 ) )
	offerSetButtonModel.rarity = eRarityTier.ICONIC
	offerSetButtonModel.sourceIcon = ItemFlavor_GetSourceIcon( firstItem )
	offerSetButtonModel.locked = locked

	return true
}

int function RTKStore_GetSelectedOfferSet()
{
	return file.selectedSetIndex
}

void function RTKOfferSetButton_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_behavior ornull button = self.PropGetBehavior( "buttonBehavior" )
	if ( button )
	{
		expect rtk_behavior ( button )
		p.eventListener = button.AddEventListener( "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) { RTKOfferSetButton_OnActivate( self ) } )
	}
}

void function RTKOfferSetButton_OnDestroy( rtk_behavior self )
{
	rtk_behavior ornull button = self.PropGetBehavior( "buttonBehavior" )
	int listenerID = GetOnPressedEventListener( self )

	if ( button && listenerID != RTKEVENT_INVALID )
	{
		expect rtk_behavior ( button )
		button.RemoveEventListener( "OnPressed", listenerID )
	}
}

void function RTKOfferSetButton_OnActivate( rtk_behavior self )
{
	RTKStore_SetOverrideStartingSection()

	file.selectedSetIndex = self.PropGetInt( "setIndex" )
	AdvanceMenu( GetMenu( "StoreOfferSetItemsMenu" ) )
}

int function GetOnPressedEventListener( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	return p.eventListener
}
