global function RTKStore_PopulateOfferArtifactSetButtonModel
global function RTKStore_PopulateOfferUniversalSetButtonModel
global function RTKStore_GetSelectedOfferSet
global function RTKStore_GetGridItemType

global function RTKOfferSetButton_OnInitialize
global function RTKOfferSetButton_OnDestroy

global struct RTKOfferSetButton_Properties
{
	rtk_behavior buttonBehavior
	int setIndex
	int gridItemType
}

struct PrivateData
{
	int eventListener
}

struct
{
	int selectedSetIndex
	int gridItemType
} file

bool function RTKStore_PopulateOfferArtifactSetButtonModel( RTKOfferButtonModel offerSetButtonModel, int setIndex )
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

bool function RTKStore_PopulateOfferUniversalSetButtonModel( RTKOfferButtonModel offerSetButtonModel, int setIndex )
{
	array<GRXScriptOffer> offers =  GRX_GetLocationOffers( "universal_set_shop" )
	array<GRXScriptOffer> bundles =  GRX_GetLocationOffers( "universal_bund_shop" )
	array< ItemFlavor > setItems = []

	foreach ( offer in offers )
	{
		foreach (index, flav in offer.output.flavors )
		{
			setItems.push( flav )
		}
	}

	GRXScriptOffer firstItemOffer = offers[ 0 ]
	GRXScriptOffer secondItemOffer = offers[ 1 ]

	
	ItemFlavor ornull prereq = firstItemOffer.prereq
	bool locked = ( prereq != null && !GRX_IsItemOwnedByPlayer( expect ItemFlavor( prereq ) ) )

	int numOwned = 0
	foreach ( ItemFlavor item in setItems )
	{
		if ( GRX_IsItemOwnedByPlayer( item ) )
			numOwned++
	}

	offerSetButtonModel.imageRef = bundles[ 0 ].imageRef
	offerSetButtonModel.offerName = bundles[ 0 ].titleText
	offerSetButtonModel.offerType = Localize( locked ? "#UNIVERSAL_MELEE_SET_LOCKED" : "#UNIVERSAL_MELEE_SET_UNLOCKED" )
	offerSetButtonModel.purchaseLimit = Localize( "#OWNED_COLLECTED", numOwned, setItems.len() )
	offerSetButtonModel.priceColor = < 0.596, 0.596, 0.596 >
	offerSetButtonModel.price = ( numOwned == setItems.len() ) ? Localize( "#SET_OWNED" ) : Localize( "#PER_ITEM", GRX_GetFormattedPrice( secondItemOffer.prices[0], 1 ) )
	offerSetButtonModel.rarity = eRarityTier.ICONIC
	offerSetButtonModel.sourceIcon = ItemFlavor_GetSourceIcon( setItems[ 0 ] )
	offerSetButtonModel.locked = locked

	return true
}


int function RTKStore_GetSelectedOfferSet()
{
	return file.selectedSetIndex
}

int function RTKStore_GetGridItemType()
{
	return file.gridItemType
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
	file.gridItemType = self.PropGetInt( "gridItemType" )
	AdvanceMenu( GetMenu( "StoreOfferSetItemsMenu" ) )
}

int function GetOnPressedEventListener( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	return p.eventListener
}
