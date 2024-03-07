global function InitPersonalizedStore
global function RTKPersonalizedStore_OnInitialize
global function RTKPersonalizedOfferButton_OnInitialize
#if DEV
global function DEV_ResetRevealStatus
#endif

global struct RTKPersonalizedStore_Properties
{
	rtk_panel 			storeButtons
}



global struct RTKPersonalizedOfferButton_Properties
{
	bool isOfferHidden
	rtk_behavior animatorBehavior
}



global struct RTKPersonalizedOfferButtonModel
{
	bool miscBool

	asset  mainImage	
	bool newPriceShow

	int rarity
	int offerIndex

	string mainText		
	string subText		
	string miscText1	
	string miscText2	
	string miscText3	
	string discount
	string imageRef
	int	   pakType

	vector priceColor
	vector newPriceColor

	bool   isOnlyGiftable
}

global struct RTKPersonalizedStoreModel
{
	array< RTKPersonalizedOfferButtonModel > pButtons
}

struct
{
	array<bool> slotsRevealStatus
} file

void function RTKPersonalizedStore_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "yourStore")
}

void function RTKPersonalizedStore_OnInitialize( rtk_behavior self )
{
	PersonalStoreListBinder_Init( self )
	RTKPersonalizedStore_ButtonsInit( self )
	UpdateTabsPersonalizedStore()
}

void function InitPersonalizedStore( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
}

void function RTKPersonalizedStore_ButtonsInit( rtk_behavior self )
{
	rtk_struct personalizedStoreStruct = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "yourStore", "RTKPersonalizedStoreModel" )
	RTKPersonalizedStoreModel personalizedStoreModel

	file.slotsRevealStatus.clear()

	array<GRXPersonalizedStoreSlotData> slotData = GetPersonalizedStoreSlotData()

	for ( int i = 0; i < slotData.len(); i++ )
	{
		RTKPersonalizedOfferButtonModel newButton
		file.slotsRevealStatus.append( slotData[i].revealStatus )

		if ( slotData[i].offer.prices.len() == 0 )
			continue

		newButton = CreateNewPersonalizedButton( slotData[i].offer, slotData[i].revealStatus, i )
		newButton.pakType = ePakType.DL_STORE_EVENT_TALL
		personalizedStoreModel.pButtons.append( newButton )
	}

	RTKStruct_SetValue( personalizedStoreStruct, personalizedStoreModel )
}

RTKPersonalizedOfferButtonModel function CreateNewPersonalizedButton( GRXScriptOffer offer, bool hasRevealed, int index )
{
	RTKPersonalizedOfferButtonModel newButton

	if( offer.titleText == "Offer Title" || offer.prices.len() == 0 )
	{
		return TEMP_FailedToGetDetailsPersonalizedButton() 
	}

	newButton.miscBool = !hasRevealed

	RTKOfferButtonModel offerButtonModel = RTKStore_CreateOfferButtonModel( offer )

	newButton.mainImage    = offerButtonModel.offerImage
	newButton.newPriceShow = offerButtonModel.newPriceShow
	newButton.rarity       = offerButtonModel.rarity
	newButton.offerIndex   = index

	newButton.mainText  = offerButtonModel.offerName
	newButton.subText   = offerButtonModel.offerType
	newButton.miscText1 = offerButtonModel.price
	newButton.miscText2 = offerButtonModel.newPrice
	newButton.miscText3 = offerButtonModel.purchaseLimit
	newButton.discount  = offerButtonModel.discount
	newButton.imageRef  = offerButtonModel.imageRef

	newButton.priceColor	 = offerButtonModel.priceColor
	newButton.newPriceColor	 = offerButtonModel.newPriceColor
	newButton.isOnlyGiftable = offerButtonModel.isOnlyGiftable

	return newButton
}



RTKPersonalizedOfferButtonModel function TEMP_FailedToGetDetailsPersonalizedButton()
{
	RTKPersonalizedOfferButtonModel newButton

	newButton.miscBool = true 

	RTKOfferButtonModel offerButtonModel = RTKOfferButton_FailedButton()

	newButton.mainImage    = offerButtonModel.offerImage
	newButton.newPriceShow = offerButtonModel.newPriceShow
	newButton.rarity       = offerButtonModel.rarity

	newButton.mainText  = offerButtonModel.offerName
	newButton.subText   = offerButtonModel.offerType
	newButton.miscText1 = offerButtonModel.price
	newButton.miscText2 = offerButtonModel.newPrice
	newButton.discount  = offerButtonModel.discount

	newButton.priceColor	= offerButtonModel.priceColor
	newButton.newPriceColor	= offerButtonModel.newPriceColor

	return newButton
}

void function PersonalStoreListBinder_Init( rtk_behavior self )
{
	rtk_panel ornull storeButtons = self.PropGetPanel( "storeButtons" )

	if ( storeButtons != null )
	{
		expect rtk_panel( storeButtons )
		self.AutoSubscribe( storeButtons, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, storeButtons ) {
			PersonalStoreButton_Init( newChild, self, newChildIndex )
		} )
	}
}



void function RTKPersonalizedOfferButton_OnInitialize( rtk_behavior self )
{
	rtk_behavior animator = self.PropGetBehavior("animatorBehavior" )
	animator.GetPanel().SetVisible( self.PropGetBool( "isOfferHidden" ) )

	RTKOfferButton_RemoveEventListener(  self.GetPanel().FindBehaviorByTypeName( "OfferButton" ) )

	rtk_behavior button = self.GetPanel().FindBehaviorByTypeName( "Button" )
	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		RTKPersonalizedOfferButton_OnActivate( self )
	} )
}

void function RTKPersonalizedOfferButton_OnActivate( rtk_behavior self )
{
	if ( !self.PropGetBool( "isOfferHidden" ) )
		RTKPersonalizedOfferButton_GoToStorePage( self )
	else
		RTKPersonalizedOfferButton_RevealAnimation( self )
}

void function RTKPersonalizedOfferButton_GoToStorePage( rtk_behavior self)
{
	rtk_behavior ornull animator = self.PropGetBehavior("animatorBehavior" )
	if ( animator != null && RTKAnimator_IsPlaying( expect rtk_behavior( animator ) ) )
		return

	rtk_behavior offerButton = self.GetPanel().FindBehaviorByTypeName( "OfferButton" )
	int offerIndex = offerButton.PropGetInt( "offerIndex" )
	GRXScriptOffer offer = RTKStore_GetOfferFromIndex( offerIndex )

	if ( offer.output.flavors.len() > 0 )
		StoreInspectMenu_AttemptOpenWithOffer( offer )

	EmitUISound( "UI_Menu_Accept" )

	
	int slotIndex     = offerButton.PropGetInt( "slotIndex" )
	GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[ slotIndex ]
	string menuName   = "Your Shop"
	string objectName = "personalizedstorebutton_" + string( slotIndex )
	string offerSelectorAlias = GetOfferSelectorAliasFromIndex( slotData.offerSelectorAliasIndex )
	PIN_UIInteraction_PersonalisedStoreInteraction( menuName, objectName, slotIndex, offerSelectorAlias, slotData.offer.offerAlias )

	
	RTKStore_InspectOffer_SaveTelemetryData( offer, slotIndex )
	StoreTelemetry_SendOferPageViewEvent()
}

void function RTKPersonalizedOfferButton_RevealAnimation( rtk_behavior self )
{
	rtk_behavior animator = self.PropGetBehavior("animatorBehavior" )

	if ( !RTKAnimator_IsPlaying( animator ) )
	{
		RTKAnimator_PlayAnimation( animator, "Open" )
	}

	rtk_behavior offerButton = self.GetPanel().FindBehaviorByTypeName( "OfferButton" )
	RTKStore_RevealPersonalizedOffer( offerButton.PropGetInt( "offerIndex" ) )
	self.PropSetBool( "isOfferHidden", false )

	EmitUISound( "UI_Menu_StoreTab_Personalized_Offer_Stinger" )

	
	int slotIndex     = offerButton.PropGetInt( "slotIndex" )
	GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[ slotIndex ]
	string menuName   = "Your Shop"
	string objectName = "personalizedstorebutton_" + string( slotIndex )
	string offerSelectorAlias = GetOfferSelectorAliasFromIndex( slotData.offerSelectorAliasIndex )
	PIN_UIInteraction_PersonalisedStoreReveal( menuName, objectName, slotIndex, offerSelectorAlias, slotData.offer.offerAlias, slotData.userSegments )
}



void function PersonalStoreButton_Init( rtk_panel newChild, rtk_behavior self, int index )
{
	rtk_behavior ornull button = newChild.GetChildren()[0].FindBehaviorByTypeName( "Button" )

	if ( button )
	{
		expect rtk_behavior ( button )
		rtk_panel cover = button.GetPanel().FindChildByName( "Cover" )

		string bPath = "&menus.yourStore.pButtons[" + index + "]"

		button.GetPanel().SetBindingRootPath( bPath )
		int offerIndex = RTKStruct_GetInt(  RTKDataModel_GetStruct( bPath ), "offerIndex" )

		if ( file.slotsRevealStatus[ offerIndex ] == true )
		{
			cover.GetChildren()[cover.GetChildren().len()-1].SetVisible(false )

			rtk_behavior ornull animator = cover.FindBehaviorByTypeName( "Animator" )

			if ( animator != null )
			{
				expect rtk_behavior( animator )
				animator.GetPanel().SetVisible( false )
			}
		}

		RTKOfferButton_RemoveEventListener(  newChild.GetChildren()[0].FindBehaviorByTypeName( "OfferButton" ) )

		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, cover, index, offerIndex ) {
			PersonalStoreButton_OnActivate( cover, index, offerIndex )
		} )

	}
}

bool function HasRevealed( rtk_panel cover )
{
	if ( !cover.IsVisible() )
		cover.GetChildren()[cover.GetChildren().len()-1].SetVisible( false )

	return !cover.GetChildren()[cover.GetChildren().len()-1].IsVisible()
}

void function GoToStorePage( rtk_panel cover, int storeIndex, int offerIndex )
{
	rtk_behavior ornull animator = cover.FindBehaviorByTypeName( "Animator" )
	if ( animator != null && RTKAnimator_IsPlaying( expect rtk_behavior( animator ) ) )
		return

	GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[offerIndex]
	string offerSelectorAlias = GetOfferSelectorAliasFromIndex( slotData.offerSelectorAliasIndex )
	PIN_UIInteraction_PersonalisedStoreInteraction( GetActiveMenuName(), cover.GetParent().GetParent().GetName(), storeIndex, offerSelectorAlias, slotData.offer.offerAlias )
	StoreInspectMenu_AttemptOpenWithOffer( GetPersonalizedStoreSlotData()[offerIndex].offer )
}

void function RevealAnimation( rtk_panel cover, int storeIndex, int offerIndex )
{
	cover.GetChildren()[cover.GetChildren().len()-1].SetVisible( false )

	rtk_behavior ornull animator = cover.FindBehaviorByTypeName( "Animator" )

	if ( animator != null )
	{
		expect rtk_behavior( animator )

		if ( !RTKAnimator_IsPlaying( animator ) )
			RTKAnimator_PlayAnimation( animator, "Open" )
	}

	file.slotsRevealStatus[ offerIndex ] = true
	RTKDataModel_SetBool("&menus.yourStore.pButtons[" + storeIndex +"].miscBool", false )

	GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[offerIndex]
	slotData.revealStatus = true
	string offerSelectorAlias = GetOfferSelectorAliasFromIndex( slotData.offerSelectorAliasIndex )
	PIN_UIInteraction_PersonalisedStoreReveal( GetActiveMenuName(), cover.GetParent().GetParent().GetName(), storeIndex, offerSelectorAlias, slotData.offer.offerAlias, slotData.userSegments )
	UpdatePersonalizedStoreSlotsRevealStatus( file.slotsRevealStatus )
}

void function PersonalStoreButton_OnActivate( rtk_panel cover, int storeIndex, int offerIndex )
{
	if ( HasRevealed( cover ) )
		GoToStorePage( cover, storeIndex, offerIndex )
	else
		RevealAnimation( cover, storeIndex, offerIndex )

	UpdateTabsPersonalizedStore()
}

void function UpdateTabsPersonalizedStore()
{
	SetPanelTabNew( GetPanel( "StorePanel" ), HasNewPersonalisedOffers() )
	UpdateHotDropsTab()
}

#if DEV
void function DEV_ResetRevealStatus()
{
	array<bool> slotRevealed

	for ( int i = 0; i < NUM_PERSONALIZED_STORE_SLOTS; i++ )
	{
		slotRevealed.append( false )
	}

	for ( int i = 0; i < GetPersonalizedStoreSlotData().len(); i++ )
	{
		GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[i]
		slotData.revealStatus = false
	}

	UpdatePersonalizedStoreSlotsRevealStatus( slotRevealed )
}
#endif

