global function RTKMilestoneEventPanelController_OnInitialize
global function RTKMilestoneEventPanelController_OnDestroy
global function RTKMilestoneEventPanelController_OnUpdate
global function RTKMilestoneEventPanelController_OnTabChanged
global function RTKMilestoneEventPanelController_SetActiveMilestoneEvent
global function RTKMilestoneEventPanelController_SetInitialEventPage
global function MilestoneEvent_PurchasePackDialogOnClose

const int SINGLE_BUTTON_PACK_QUANTITY = 1
const int MULTIPLE_BUTTON_PACK_QUANTITY = 4
const float ITEM_RESELECT_DELAY_TIME = 0.6

global struct RTKMilestoneEventPanelController_Properties
{
	rtk_panel offersGrid
	rtk_behavior giftButton
	rtk_behavior purchaseButton
	rtk_behavior informationButton
	rtk_panel progressTrackerMilestones
	rtk_behavior panelAnimator
}

struct
{
	ItemFlavor ornull activeEvent = null
	array<ItemFlavor> items
	array<ItemFlavor> chaseItems
	array<ItemFlavor> featuredItems
	bool isRestricted = false

	rtk_struct milestoneEventModel
	rtk_struct trackingPanelModel
	array<MilestoneEventGrantReward> milestones
	array<RTKMilestoneProgressTrackerTierInfo> milestoneTierInfo
	rtk_struct itemViewerModel

	bool willTriggerMilestonePackOpen = false
	bool waitingForPackOpening = false
	rtk_behavior self

	ItemFlavor ornull eventToReturnToOnNavBack = null

	array<rtk_behavior> hoveredItemButtons
	float lastHoveredItemButtonChangeTime
	float currentEventInfoPanelAlpha = 0.0
} file

const float EVENT_INFO_PANEL_ANIM_DURATION = 0.2

void function RTKMilestoneEventPanelController_OnInitialize( rtk_behavior self )
{
	file.self = self

	RegisterSignal( "OnTabChanged" )
	StoreMilestoneMenu_AddOnTabChangedCallback( RTKMilestoneEventPanelController_OnTabChanged )

	if ( file.eventToReturnToOnNavBack != null )
	{
		file.activeEvent = file.eventToReturnToOnNavBack
		file.eventToReturnToOnNavBack = null
	}
	else if ( file.activeEvent == null )
		file.activeEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )

	ItemFlavor ornull milestonePackFlav = GetMilestoneRewardPack()
	file.willTriggerMilestonePackOpen = milestonePackFlav != null

	BuildDataModels()
	SetupCallbacks()
	SetupButtons()

	file.currentEventInfoPanelAlpha = 0.0
	file.lastHoveredItemButtonChangeTime = UITime()

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "milestoneEvent", true ) )

	if ( milestonePackFlav != null )
	{
		expect ItemFlavor( milestonePackFlav )
		thread TryOpenMilestoneRewardPack( milestonePackFlav )
	}
}

void function RTKMilestoneEventPanelController_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "milestoneEvent" )
	file.activeEvent = null
	file.self = null
	file.items.clear()
	file.chaseItems.clear()
	file.featuredItems.clear()
	file.milestones.clear()
	file.hoveredItemButtons.clear()
	RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
	RunClientScript( "ClearBattlePassItem" )
}

void function RTKMilestoneEventPanelController_OnUpdate( rtk_behavior self, float dt )
{
	if ( file.hoveredItemButtons.len() > 0 )
	{
		if ( file.currentEventInfoPanelAlpha > 0.0 )
		{
			float elapsed = UITime() - file.lastHoveredItemButtonChangeTime
			float frac = elapsed / EVENT_INFO_PANEL_ANIM_DURATION
			file.currentEventInfoPanelAlpha = LerpFloat( file.currentEventInfoPanelAlpha, 0.0, frac )

			RTKStruct_SetFloat( file.itemViewerModel, "eventOverviewPanelAlpha", file.currentEventInfoPanelAlpha )
			RTKStruct_SetFloat( file.itemViewerModel, "itemViewerPanelAlpha", 1.0 - file.currentEventInfoPanelAlpha )
		}
	}
	else
	{
		if ( file.currentEventInfoPanelAlpha < 1.0 )
		{
			float elapsed = UITime() - file.lastHoveredItemButtonChangeTime
			float frac = elapsed / EVENT_INFO_PANEL_ANIM_DURATION
			file.currentEventInfoPanelAlpha = LerpFloat( file.currentEventInfoPanelAlpha, 1.0, frac )

			RTKStruct_SetFloat( file.itemViewerModel, "eventOverviewPanelAlpha", file.currentEventInfoPanelAlpha )
			RTKStruct_SetFloat( file.itemViewerModel, "itemViewerPanelAlpha", 1.0 - file.currentEventInfoPanelAlpha )

			
			
			if ( file.currentEventInfoPanelAlpha >= 0.98 )
			{
				RunClientScript( "ClearBattlePassItem" )
			}
		}
	}
}

void function RTKMilestoneEventPanelController_OnTabChanged( string eventId )
{
	Signal( uiGlobal.signalDummy, "OnTabChanged" )
	RTKMilestoneEventPanelController_SetActiveMilestoneEvent( eventId )
}

void function RTKMilestoneEventPanelController_SetInitialEventPage( string eventId )
{
	file.activeEvent = MilestoneEvent_GetEventById( eventId );
	SetCollectionEventAboutPageEvent( file.activeEvent )
}

void function RTKMilestoneEventPanelController_SetActiveMilestoneEvent( string eventId )
{
	file.activeEvent = MilestoneEvent_GetEventById( eventId );
	SetCollectionEventAboutPageEvent( file.activeEvent )

	if ( file.self != null && IsValid( file.self ) )
	{
		file.currentEventInfoPanelAlpha = 0.0
		file.lastHoveredItemButtonChangeTime = UITime()
		BuildDataModels()
		SetupButtons()
	}
}

void function BuildDataModels()
{
	BuildMilestonePanelDataModel()
	BuildProgressTrackerDataModel()
}

void function MilestoneEvent_PurchasePackDialogOnClose()
{
	file.waitingForPackOpening = true
}

void function SetupCallbacks()
{
	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
}

void function SetupButtons()
{
	rtk_behavior ornull informationButton = file.self.PropGetBehavior( "informationButton" )

	file.self.AutoSubscribe( informationButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : () {
		if ( IsMilestoneEventStoreOnly( file.activeEvent ) )
			StoreMilestoneEvents_SendPageViewInfoPage( "packInfoDialog" )
		else
			RTKEventsPanelController_SendPageViewInfoPage( "packInfoDialog" )

		OpenMilestonePackInfoDialog()
	} )

	SetUpGridButtons( file.self )
	SetupMilestoneButtons( file.self )
	SetUpPurchaseButtons( file.self )
}

void function BuildProgressTrackerDataModel()
{
	rtk_struct trackingPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "trackingPage", "RTKMilestoneEventPanelModel" )
	file.trackingPanelModel = trackingPanel

	BuildMilestoneTrackingPanelInfo()
	BuildMilestoneRewardsItemsInfo()
	BuildPackPricingDataModel()
}

void function BuildPackPricingDataModel()
{
	if ( file.activeEvent == null )
		return

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)
	array<GRXScriptOffer> singlePurchaseOffers = MilestoneEvent_GetSinglePackOffers( event )
	array<GRXScriptOffer> multiplePurchaseOffers = MilestoneEvent_GetMultiPackOffers( event )

	array<RTKMilestonePackPricingModel> pricingDataModel
	RTKMilestonePackPricingModel singlePurchaseDataModel = GetMilestonePricingDataModelFromOffers( singlePurchaseOffers, SINGLE_BUTTON_PACK_QUANTITY )
	RTKMilestonePackPricingModel multiplePurchaseDataModel = GetMilestonePricingDataModelFromOffers( multiplePurchaseOffers, MULTIPLE_BUTTON_PACK_QUANTITY )

	pricingDataModel.append( singlePurchaseDataModel )
	pricingDataModel.append( multiplePurchaseDataModel )

	rtk_array pricingDataData = RTKStruct_GetOrCreateScriptArrayOfStructs( file.trackingPanelModel, "packPricingData", "RTKMilestonePackPricingModel" )
	RTKArray_SetValue( pricingDataData, pricingDataModel )
}

void function BuildMilestonePanelDataModel()
{
	rtk_struct milestoneEvent = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "milestoneEvent", "RTKMilestoneEventCollectionPanelModel" )
	file.milestoneEventModel = milestoneEvent

	BuildMilestoneGeneralPanelInfo()

	BuildMilestoneTitleDataModel()
	BuildMilestoneCollectedCategoryInfo()
	BuildMilestoneCollectedItemsInfo()
	BuildMilestoneChaseItemInfo()
	BuildPackProbabilitiesDataModel()
	BuildMilestoneItemViewerModel( null )
}

void function BuildMilestoneRewardsItemsInfo()
{
	array<RTKMilestoneCollectedItemInfo> rewardsItemsModel = []

	if ( file.activeEvent == null )
	{
		return
	}

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	array<MilestoneEventGrantReward> milestones = MilestoneEvent_GetMilestoneGrantRewards( event, file.isRestricted )
	file.milestones = milestones

	table< int, array< RTKMilestoneCollectedItemInfo > > itemsTiers
	foreach ( milestone in milestones )
	{
		
		int milestoneLevel = milestone.grantingLevel
		if ( !( milestoneLevel in itemsTiers ) )
			itemsTiers[milestoneLevel] <- []

		
		RTKMilestoneCollectedItemInfo infoData
		ItemFlavor item = milestone.rewardFlav
		infoData.quality = ItemFlavor_GetQuality( item )
		infoData.icon = milestone.customImage == "" ? CustomizeMenu_GetRewardButtonImage( item ) : milestone.customImage
		infoData.isOwned = GRX_IsItemOwnedByPlayer( item )
		infoData.state = infoData.isOwned ? eShopItemState.OWNED : eShopItemState.AVAILABLE
		infoData.isPurchasable = false
		infoData.price = -1
		infoData.tooltipInfo.titleText = milestone.customName == "" ? ItemFlavor_GetLongName( item ) : milestone.customName

		if ( MilestoneEvent_IsEventStoreOnly( event ) )
		{
			infoData.tooltipInfo.descText = file.isRestricted ? Localize( "#MILESTONE_ITEM_TOOLTIP_DESC_LIMITED_RESTRICTED", milestoneLevel ) : Localize( "#MILESTONE_ITEM_TOOLTIP_DESC_LIMITED", milestoneLevel )
		}
		else
		{
			infoData.tooltipInfo.descText = file.isRestricted ? Localize( "#MILESTONE_ITEM_TOOLTIP_DESC_RESTRICTED", milestoneLevel ) : Localize( "#MILESTONE_ITEM_TOOLTIP_DESC", milestoneLevel )
		}

		infoData.itemGuid = item.guid
		itemsTiers[milestoneLevel].append( infoData )
	}

	array<ItemFlavor> poolItems = MilestoneEvent_GetEventItemsInPool( event, file.isRestricted )
	int totalCollectedItems = file.isRestricted ? GRX_GetNumberOfOwnedItemsByPlayer( poolItems ) : GRX_GetNumberOfOwnedItemsByPlayer( poolItems ) + GRX_GetNumberOfOwnedItemsByPlayer( file.chaseItems )

	
	file.milestoneTierInfo.clear()

	int index = 0
	int currentTierStartLevel = 0
	foreach ( grantLevel, rewardsArray in itemsTiers )
	{
		
		RTKMilestoneProgressTrackerTierInfo tier
		tier.grantLevel = grantLevel
		tier.tierStartLevel = currentTierStartLevel
		tier.items = rewardsArray
		tier.currentLevel = minint( grantLevel, totalCollectedItems )
		tier.prefabIndex = 0
		file.milestoneTierInfo.append( tier )

		
		if ( index != itemsTiers.len() - 1 )
		{
			RTKMilestoneProgressTrackerTierInfo dividerTier
			dividerTier.grantLevel = grantLevel
			dividerTier.currentLevel = minint( grantLevel, totalCollectedItems )
			dividerTier.prefabIndex = 1 
			file.milestoneTierInfo.append( dividerTier )
		}

		currentTierStartLevel = grantLevel
		index++
	}

	rtk_array rewardTiers = RTKStruct_GetOrCreateScriptArrayOfStructs( file.trackingPanelModel, "rewardTiersModel", "RTKMilestoneProgressTrackerTierInfo" )
	RTKArray_SetValue( rewardTiers, file.milestoneTierInfo )
}

void function BuildMilestoneGeneralPanelInfo()
{
	file.isRestricted = GRX_IsOfferRestricted()
	if ( file.activeEvent != null )
	{
		RTKMilestoneEventCollectionPanelModel generalModel
		ItemFlavor ornull event = file.activeEvent
		expect ItemFlavor(event)

		generalModel.color = MilestoneEvent_GetTitleCol( event )
		generalModel.titleBgColor = MilestoneEvent_GetTitleBGColor( event )
		generalModel.fullscreenBgDarkeningOpacity = MilestoneEvent_GetFullscreenBGDarkening( event )
		file.items = MilestoneEvent_GetEventItems( event, file.isRestricted )
		file.items.reverse() 
		file.chaseItems = MilestoneEvent_GetMythicEventItems( event, file.isRestricted )
		file.featuredItems = MilestoneEvent_GetFeaturedItems( event )
		array<ItemFlavor> poolItems = MilestoneEvent_GetEventItemsInPool( event, file.isRestricted )
		generalModel.totalItems = poolItems.len()
		generalModel.collectedItems = GRX_GetNumberOfOwnedItemsByPlayer( poolItems )
		generalModel.collectionBoxBGImage = MilestoneEvent_GetCollectionBoxBGImage( event )
		generalModel.collectionBoxBlur = MilestoneEvent_GetCollectionBoxBlur( event )
		generalModel.collectionBoxBlurImage = MilestoneEvent_GetCollectionBoxBlurImage( event )
		generalModel.infoBoxBGImage = MilestoneEvent_GetInfoBoxBGImage( event )
		generalModel.infoBoxBlur = MilestoneEvent_GetInfoBoxBlur( event )
		generalModel.infoBoxBlurImage = MilestoneEvent_GetInfoBoxBlurImage( event )
		generalModel.eventDescription = MilestoneEvent_GetEventDescription( event, file.isRestricted )
		generalModel.eventKeyArt = MilestoneEvent_GetEventKeyArt( event )
		generalModel.isRestricted = file.isRestricted

		RTKStruct_SetValue( file.milestoneEventModel, generalModel )
	}
}

void function BuildMilestoneCollectedCategoryInfo()
{
	array<RTKMilestoneCollectedCategoryInfo> collectedInfoModel = []

	if ( file.activeEvent == null )
	{
		return
	}
	if ( !GRX_IsInventoryReady() )
	{
		return
	}

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	array<CollectionEventRewardGroup> rewardGroups = MilestoneEvent_GetRewardGroups( event, file.isRestricted )
	foreach ( rewardGroup in rewardGroups )
	{
		
		int nonItemPoolItemCount = 0
		int ownedItemsNotInPool = 0
		foreach ( rewardItem in rewardGroup.rewards )
		{
			if ( !MilestoneEvent_IsItemInPool( event, rewardItem.grxIndex, file.isRestricted ) )
			{
				nonItemPoolItemCount++

				if ( GRX_IsItemOwnedByPlayer( rewardItem ) )
					ownedItemsNotInPool++
			}
		}

		RTKMilestoneCollectedCategoryInfo tierData
		tierData.quantity = GetNumberOfOwnedRewardsPerCategory( rewardGroup ) - ownedItemsNotInPool
		tierData.maxQuantity = rewardGroup.rewards.len() - nonItemPoolItemCount
		tierData.quality = rewardGroup.quality
		collectedInfoModel.append( tierData )
	}

	
	collectedInfoModel.reverse()

	rtk_array collectedInfo = RTKStruct_GetOrCreateScriptArrayOfStructs( file.milestoneEventModel, "collectedInfo", "RTKMilestoneCollectedCategoryInfo" )
	RTKArray_SetValue( collectedInfo, collectedInfoModel )
}

void function BuildMilestoneCollectedItemsInfo()
{
	array<RTKMilestoneCollectedItemInfo> collectedItemsModel = []

	if ( file.activeEvent == null )
	{
		return
	}

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	foreach ( item in file.items )
	{
		asset customImage = MilestoneEvent_GetCustomIconForItemIdx( event, item.grxIndex, file.isRestricted )
		RTKMilestoneCollectedItemInfo infoData
		infoData.quality = ItemFlavor_GetQuality( item )
		infoData.icon = customImage != "" ? customImage : CustomizeMenu_GetRewardButtonImage( item )
		infoData.isOwned = GRX_IsItemOwnedByPlayer( item )
		infoData.state = infoData.isOwned ? eShopItemState.OWNED : eShopItemState.AVAILABLE
		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( item, MilestoneEvent_GetFrontPageGRXOfferLocation( event, file.isRestricted ) )
		infoData.isPurchasable = offers.len() > 0
		bool isChaseItem = MilestoneEvent_IsChaseItem( event, item.grxIndex, file.isRestricted )
		infoData.isChaseItem = isChaseItem
		vector gridSizeOverride = MilestoneEvent_GetGridSizeOverride( event, item.grxIndex, file.isRestricted )
		infoData.gridColSpan = int(gridSizeOverride.x) != 0 ? int(gridSizeOverride.x) : ( isChaseItem ? 2 : 1 )
		infoData.gridRowSpan = int(gridSizeOverride.y) != 0 ? int(gridSizeOverride.y) : 1
		infoData.price = infoData.isPurchasable ? GRXOffer_GetPremiumPriceQuantity( offers[0] ) : -1
		infoData.tooltipInfo.titleText = ItemFlavor_GetLongName( item ) 
		collectedItemsModel.append( infoData )
	}
	rtk_array collectedInfo = RTKStruct_GetOrCreateScriptArrayOfStructs( file.milestoneEventModel, "collectedItemsModel", "RTKMilestoneCollectedItemInfo" )
	RTKArray_SetValue( collectedInfo, collectedItemsModel )
}

void function BuildMilestoneChaseItemInfo()
{
	if ( file.activeEvent == null )
	{
		return
	}
	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	if ( file.chaseItems.len() < 1 )
		return

	ItemFlavor chaseItem = file.chaseItems[0]

	RTKMilestoneChaseItemInfo infoData
	infoData.quality = ItemFlavor_GetQuality( chaseItem )
	infoData.icon = MilestoneEvent_GetChaseItemIcon( event )
	infoData.isOwned = GRX_IsItemOwnedByPlayer( chaseItem )
	infoData.state = infoData.isOwned ? eShopItemState.OWNED : eShopItemState.AVAILABLE
	infoData.name = Localize( ItemFlavor_GetLongName( chaseItem ) )
	int totalItems = file.isRestricted ? file.items.len() : file.items.len() + file.chaseItems.len()
	infoData.description = Localize( MilestoneEvent_GetChaseItemUnlockDescription( event ), totalItems, infoData.name )
	infoData.tooltipInfo.titleText = ItemFlavor_GetLongName( chaseItem ) 

	rtk_struct chaseInfo = RTKStruct_GetOrCreateScriptStruct( file.milestoneEventModel, "chaseItemModel", "RTKMilestoneChaseItemInfo" )
	RTKStruct_SetValue( chaseInfo, infoData )
}

RTKMilestonePackPricingModel function GetMilestonePricingDataModelFromOffers( array<GRXScriptOffer> offers, int defaultQuantity )
{
	RTKMilestonePackPricingModel offerModel
	if ( offers.len() > 0 )
	{
		GRXScriptOffer offer = offers[0]
		if ( offer.prices.len() == 2 )
		{
			string firstPrice = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float( GRXOffer_GetPremiumPriceQuantity( offer ) ), true )
			string secondPrice = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] ) + "% " + FormatAndLocalizeNumber( "1", float( GRXOffer_GetCraftingPriceQuantity( offer ) ), true )
			offerModel.price = Localize( "#STORE_PRICE_N_N", firstPrice, secondPrice )
		}
		else
		{
			offerModel.price = GRX_GetFormattedPrice( offer.prices[0], 1 )
		}
		offerModel.isPaidPack = GRXOffer_GetPremiumPriceQuantity( offer ) > 1 
		offerModel.doesOfferExist = true
		int originalPrice = GRXOffer_GetOriginalPremiumPriceQuantity( offer )
		int price = GRXOffer_GetPremiumPriceQuantity( offer )
		if ( originalPrice > 0 )
		{
			offerModel.discount = int( (float((originalPrice - price )) / float(originalPrice)) * 100 )
			offerModel.originalPrice = "%$" + ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) + "% " + FormatAndLocalizeNumber( "1", float(originalPrice), true )
		}
	}
	else
	{
		offerModel.price = ""
		offerModel.discount = 0
		offerModel.originalPrice = ""
		offerModel.doesOfferExist = false
	}
	offerModel.quantity = defaultQuantity
	return offerModel
}

int function GetNumberOfOwnedRewardsPerCategory( CollectionEventRewardGroup rewardGroup )
{
	int counter = 0
	foreach	( flav in rewardGroup.rewards )
	{
		if ( GRX_IsItemOwnedByPlayer( flav ) )
		{
			counter++
		}
	}
	return counter
}

void function SetUpGridButtons( rtk_behavior self )
{
	if ( file.activeEvent == null )
	{
		return
	}

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	rtk_struct milestoneEventModel = file.milestoneEventModel

	rtk_panel ornull offersGrid = self.PropGetPanel( "offersGrid" )
	if ( offersGrid != null )
	{
		expect rtk_panel( offersGrid )

		self.AutoSubscribe( offersGrid, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, event, milestoneEventModel ) {
			array< rtk_behavior > gridItems = newChild.FindBehaviorsByTypeName( "Button" )
			if ( !GRX_AreOffersReady( false ) )
			{
				return
			}
			foreach( button in gridItems )
			{
				array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( file.items[newChildIndex], MilestoneEvent_GetFrontPageGRXOfferLocation( event, file.isRestricted ) )

				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex, milestoneEventModel ) {
					BuildMilestoneItemViewerModel( file.items[newChildIndex] )
					OnItemButtonEnter( self, button )
				} )

				self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self, newChildIndex, milestoneEventModel ) {
					OnItemButtonExit( self, button )
				} )

				if( offers.len() > 0 )
				{
					GRXScriptOffer offer = offers[0]
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, offer ) {
						bool isStoreOnly = false
						ItemFlavor ornull event = file.activeEvent
						if ( event != null )
						{
							expect ItemFlavor( event )
							isStoreOnly = IsMilestoneEventStoreOnly( event )
						}

						if ( isStoreOnly )
							StoreMilestoneEvents_SendPageViewMilestoneOffer( newChildIndex, ItemFlavor_GetLongName( file.items[newChildIndex] ) )
						else
							RTKEventsPanelController_SendPageViewEventOffer( self, newChildIndex, ItemFlavor_GetLongName( file.items[newChildIndex] ) )

						StoreInspectMenu_AttemptOpenWithOffer( offer )
					} )
				}
				else
				{
					bool hasOffers = offers.len() > 0
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, event, hasOffers ) {
						bool isStoreOnly = false
						ItemFlavor ornull event = file.activeEvent
						if ( event != null )
						{
							expect ItemFlavor( event )
							isStoreOnly = IsMilestoneEventStoreOnly( event )
						}

						string title = file.isRestricted ? "#MILESTONE_EVENT_LOCKED_PRESENTATION_BUTTON_TITLE" : ( isStoreOnly ? "#MILESTONE_STORE_PURCHASE_PRESENTATION_BUTTON_TITLE" : "#MILESTONE_EVENT_PURCHASE_PRESENTATION_BUTTON_TITLE" )
						string desc = isStoreOnly ? "#MILESTONE_STORE_PURCHASE_PRESENTATION_BUTTON_DESC" : "#MILESTONE_EVENT_PURCHASE_PRESENTATION_BUTTON_DESC"
						if ( file.isRestricted && !hasOffers )
							desc = isStoreOnly ? "#MILESTONE_STORE_LOCKED_PRESENTATION_BUTTON_DESC" : "#MILESTONE_EVENT_LOCKED_PRESENTATION_BUTTON_DESC"

						file.eventToReturnToOnNavBack = event

						if ( isStoreOnly )
							StoreMilestoneEvents_SendPageViewMilestoneOffer( newChildIndex, ItemFlavor_GetLongName( file.items[newChildIndex] ) )
						else
							RTKEventsPanelController_SendPageViewEventOffer( self, newChildIndex, ItemFlavor_GetLongName( file.items[newChildIndex] ) )

						SetGenericItemPresentationModeActiveWithNavBack( file.items[newChildIndex], title, desc, void function() : () {} )
					} )
				}
			}
		} )
	}
}

void function SetupMilestoneButtons( rtk_behavior self )
{
	if ( file.activeEvent == null )
	{
		return
	}

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	rtk_struct milestoneEventModel = file.milestoneEventModel

	rtk_panel ornull milestonesList = self.PropGetPanel( "progressTrackerMilestones" )
	if ( milestonesList != null )
	{
		expect rtk_panel( milestonesList )

		self.AutoSubscribe( milestonesList, "onChildAdded", function ( rtk_panel newChild, int tierIndex ) : ( self, event, milestoneEventModel ) {

			
			rtk_panel ornull itemsPanel = newChild.FindDescendantByName( "Items" )
			if ( itemsPanel == null )
				return
			expect rtk_panel( itemsPanel )

			
			self.AutoSubscribe( itemsPanel, "onChildAdded", function ( rtk_panel newChild, int rewardIndex ) : ( self, tierIndex, event, milestoneEventModel ) {

				array< rtk_behavior > rewardButtons = newChild.FindBehaviorsByTypeName( "Button" )
				foreach( button in rewardButtons )
				{
					SettingsAssetGUID itemGuid = file.milestoneTierInfo[tierIndex].items[rewardIndex].itemGuid
					ItemFlavor item = GetItemFlavorByGUID( itemGuid )

					self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, item, milestoneEventModel ) {
						BuildMilestoneItemViewerModel( item )
						OnItemButtonEnter( self, button )
					} )

					self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self, rewardIndex, milestoneEventModel ) {
						OnItemButtonExit( self, button )
					} )

					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, rewardIndex, item, event ) {
						bool isStoreOnly = IsMilestoneEventStoreOnly( event )
						string desc = isStoreOnly ? "#MILESTONE_STORE_LOCKED_PRESENTATION_BUTTON_DESC" : "#MILESTONE_EVENT_LOCKED_PRESENTATION_BUTTON_DESC"
						string itemName = "milestoneReward_" + ItemFlavor_GetLongName( item )

						if ( isStoreOnly )
							StoreMilestoneEvents_SendPageViewMilestoneOffer( rewardIndex, itemName, true )
						else
							RTKEventsPanelController_SendPageViewEventOffer( self, rewardIndex, itemName, true )

						SetGenericItemPresentationModeActiveWithNavBack( item, "#MILESTONE_EVENT_LOCKED_PRESENTATION_BUTTON_TITLE", desc, void function() : ()
						{
						} )
					} )
				}
			} )
		} )
	}
}

void function BuildMilestoneTrackingPanelInfo()
{
	if ( file.activeEvent != null )
	{
		RTKMilestoneEventPanelModel generalModel
		ItemFlavor ornull event = file.activeEvent
		expect ItemFlavor(event)
		file.featuredItems = MilestoneEvent_GetFeaturedItems( event )
		array<ItemFlavor> items = MilestoneEvent_GetEventItemsInPool( event, file.isRestricted )
		array<ItemFlavor> chaseItems = MilestoneEvent_GetMythicEventItems( event, file.isRestricted )

		generalModel.titleColor = MilestoneEvent_GetTitleCol( event )
		generalModel.titleBgColor = MilestoneEvent_GetTitleBGColor( event )
		generalModel.subtitleColor = MilestoneEvent_GetMilestoneBoxTitleColor( event )
		generalModel.disclaimerBoxColor = MilestoneEvent_GetDisclaimerBoxColor( event )
		generalModel.endtime =  CalEvent_GetFinishUnixTime( event )
		int remainingItemsForMile =  MilestoneEvent_GetRemainingCompletionItemsForCurrentMilestone( event )
		if ( remainingItemsForMile == 0  )
		{
			generalModel.nextMilestoneText = Localize( "#MILESTONE_EVENT_TRACKING_BOX_COMPLETED_MILES" )
		}
		else
		{
			generalModel.nextMilestoneText = Localize( file.isRestricted ? "#MILESTONE_EVENT_TRACKING_BOX_NEXT_MILE_RESTRICT" : "#MILESTONE_EVENT_TRACKING_BOX_NEXT_MILE", remainingItemsForMile )
		}
		generalModel.totalItems = file.isRestricted ? items.len() : items.len() + chaseItems.len()
		generalModel.currentCollectedItems = file.isRestricted ? GRX_GetNumberOfOwnedItemsByPlayer( items ) : GRX_GetNumberOfOwnedItemsByPlayer( items ) + GRX_GetNumberOfOwnedItemsByPlayer( chaseItems )

		
		if ( generalModel.totalItems > 0 )
		{
			float percent = float( generalModel.currentCollectedItems ) / float( generalModel.totalItems )
			generalModel.completionPercentage = Localize( "#MILESTONE_TRACKER_PERCENT_COMPLETE", FormatNumber( "1", percent * 100 ) )
		}
		else
		{
			generalModel.completionPercentage = ""
		}

		generalModel.isRestricted = file.isRestricted
		generalModel.trackerBoxBGImage = MilestoneEvent_GetTrackerBoxBGImage( event )
		generalModel.trackerBoxBlurBg = MilestoneEvent_GetTrackerBoxBlur( event )
		generalModel.trackerBoxBlurImage = MilestoneEvent_GetTrackerBoxBlurImage( event )
		generalModel.trackerProgressBarColor = MilestoneEvent_GetMilestoneTrackerProgressBarColor( event )
		generalModel.trackerProgressBarBGColor = MilestoneEvent_GetMilestoneTrackerProgressBarBGColor( event )
		generalModel.eventShopHasMilestonePack = EventShop_HasMilestoneEventPack()
		generalModel.hasGuaranteedPack = MilestoneEvent_GetGuaranteedMultiPackOffers( event ).len() > 0
		RTKStruct_SetValue( file.trackingPanelModel, generalModel )
	}
}

void function BuildPackProbabilitiesDataModel()
{
	if ( file.activeEvent == null )
	{
		return
	}
	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	RTKPackProbabilitiesStrings probabilityStrings = MilestoneEvent_GetPackProbabilitiesStrings( event )

	rtk_struct probabilityModel = RTKStruct_GetOrCreateScriptStruct( file.milestoneEventModel, "packProbabilities", "RTKPackProbabilitiesStrings" )
	RTKStruct_SetValue( probabilityModel, probabilityStrings )
}

void function SetUpPurchaseButtons( rtk_behavior self )
{
	if ( file.activeEvent == null )
		return

	if ( !GRX_IsInventoryReady() )
		return

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	rtk_behavior ornull giftButton = self.PropGetBehavior( "giftButton" )
	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	array<GRXScriptOffer> singlePurchaseOffers = MilestoneEvent_GetSinglePackOffers( event )

	self.AutoSubscribe( giftButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( singlePurchaseOffers ) {
		int state = GetEventGiftButtonState( singlePurchaseOffers )
		switch ( state )
		{
			case eEventGiftingButtonState.AVAILABLE:
				if ( IsMilestoneEventStoreOnly( file.activeEvent ) )
					StoreMilestoneEvents_SendPageViewPurchaseDialog( true )
				else
					RTKEventsPanelController_SendPageViewPurchaseDialog( true )

				OpenPurchasePackSelectionDialog( true )
				break
			case eEventGiftingButtonState.TWO_FACTOR_DISABLED:
				OpenTwoFactorInfoDialog( null )
				break
			case eEventGiftingButtonState.GIFTING_EXCEEDED:
			case eEventGiftingButtonState.NOT_ENOUGH_LEVEL:
			case eEventGiftingButtonState.UNAVAILABLE:
				return
		}
	} )

	self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( singlePurchaseOffers ) {
		int state = GetEventPurchaseButtonState( singlePurchaseOffers )
		switch ( state )
		{
			case eEventPackPurchaseButtonState.AVAILABLE:
				if ( IsMilestoneEventStoreOnly( file.activeEvent ) )
					StoreMilestoneEvents_SendPageViewPurchaseDialog( false )
				else
					RTKEventsPanelController_SendPageViewPurchaseDialog( false )

				OpenPurchasePackSelectionDialog( false )
				break
			default:
				EmitUISound( "menu_deny" )
				return
		}
	} )

	BuildPurchaseButtonDataModel()
}

void function BuildPurchaseButtonDataModel()
{
	if ( file.activeEvent == null )
		return

	if ( !GRX_IsInventoryReady() )
		return

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	array<GRXScriptOffer> singlePurchaseOffers = MilestoneEvent_GetSinglePackOffers( event )

	RTKMilestoneGiftButtonData giftButtonModel
	giftButtonModel.state = GetEventGiftButtonState( singlePurchaseOffers )

	
	if ( file.willTriggerMilestonePackOpen )
		giftButtonModel.state = eEventGiftingButtonState.UNAVAILABLE

	rtk_struct giftButtonData = RTKStruct_GetOrCreateScriptStruct( file.trackingPanelModel, "giftButtonData", "RTKMilestoneGiftButtonData" )
	RTKStruct_SetValue( giftButtonData, giftButtonModel )

	RTKMilestonePurchaseButtonData purchaseButtonModel
	purchaseButtonModel.state = GetEventPurchaseButtonState( singlePurchaseOffers )

	
	if ( file.willTriggerMilestonePackOpen || GRX_AreOffersDirty() )
		purchaseButtonModel.state = eEventPackPurchaseButtonState.UNAVAILABLE

	rtk_struct purchaseButtonData = RTKStruct_GetOrCreateScriptStruct( file.trackingPanelModel, "purchaseButtonData", "RTKMilestonePurchaseButtonData" )
	RTKStruct_SetValue( purchaseButtonData, purchaseButtonModel )
}

void function BuildMilestoneTitleDataModel()
{
	if ( file.activeEvent != null )
	{
		ItemFlavor ornull event = file.activeEvent
		expect ItemFlavor(event)

		RTKMilestoneTitleInfo titleModel
		titleModel.headerText = MilestoneEvent_GetTitleHeaderText( event )
		titleModel.subheaderText = MilestoneEvent_GetTitleSubheaderText( event )
		titleModel.eventIcon = MilestoneEvent_GetTitleMainIcon( event )
		titleModel.bgBlur = MilestoneEvent_GetTitleUseBackgroundBlur( event )
		titleModel.bgBlurImage = MilestoneEvent_GetTitleBlurImage( event )
		titleModel.bgDarkening = MilestoneEvent_GetTitleBackgroundDarkening( event )
		titleModel.bgImage = MilestoneEvent_GetTitleBackgroundImage( event )
		titleModel.headerTextColor = MilestoneEvent_GetTitleHeaderColor( event )
		titleModel.subheaderTextColor = MilestoneEvent_GetTitleSubheaderColor( event )
		titleModel.endTime = CalEvent_GetFinishUnixTime( event )

		rtk_struct titleCard = RTKStruct_GetOrCreateScriptStruct( file.milestoneEventModel, "titleCard", "RTKMilestoneTitleInfo" )
		RTKStruct_SetValue( titleCard, titleModel )
	}
}

void function BuildMilestoneItemViewerModel( ItemFlavor ornull itemToDisplay )
{
	if ( file.activeEvent != null )
	{
		if ( !GRX_IsInventoryReady() )
		{
			return
		}

		
		file.itemViewerModel = RTKStruct_GetOrCreateScriptStruct( file.milestoneEventModel, "carouselInfo", "RTKMilestoneCarouselPanelInfo" )

		
		ItemFlavor ornull event = file.activeEvent
		expect ItemFlavor( event )

		if ( itemToDisplay == null )
			return

		ItemFlavor ornull item = itemToDisplay
		expect ItemFlavor( item )

		RTKMilestoneCarouselPanelInfo itemInfo

		
		itemInfo.eventOverviewPanelAlpha = file.currentEventInfoPanelAlpha
		itemInfo.itemViewerPanelAlpha = 1.0 - file.currentEventInfoPanelAlpha

		itemInfo.isOwned = IsItemFlavorRewardItem( item ) ? true : GRX_IsItemOwnedByPlayer( item )
		itemInfo.quality = ItemFlavor_GetQuality( item )
		itemInfo.name = ItemFlavor_GetLongName( item )
		itemInfo.itemTypeDescription = MilestoneEvent_GetCarouselItemDescriptionText(item )
		itemInfo.packIcon = MilestoneEvent_GetMainPackImage( event )
		itemInfo.packName = Localize( MilestoneEvent_GetMainPackShortPluralName( event ) )
		ItemFlavor currencyFlav = GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]
		itemInfo.coinIcon = ItemFlavor_GetIcon( currencyFlav )
		itemInfo.isRestricted = file.isRestricted
		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( item, MilestoneEvent_GetFrontPageGRXOfferLocation( event, file.isRestricted ) )
		if ( !file.isRestricted )
		{
			ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
			if ( activeThemedShopEvent != null )
			{
				expect ItemFlavor( activeThemedShopEvent )
				offers.extend( GRX_GetItemDedicatedStoreOffers( item, ThemedShopEvent_GetGRXOfferLocation( activeThemedShopEvent ) ) )
			}
		}
		itemInfo.price = offers.len() > 0 ? GRXOffer_GetPremiumPriceQuantity( offers[0] ) : -1

		RTKStruct_SetValue( file.itemViewerModel, itemInfo )
		if ( IsValidItemFlavorGUID( ItemFlavor_GetGUID( item ) ) )
		{
			bool isNxHH = false
#if PC_PROG_NX_UI
				isNxHH = IsNxHandheldMode()
#endif
			RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( item ) , -1, 1.19, Battlepass_ShouldShowLow( item ), null, true, "collection_event_ref", isNxHH, true, false, false )
		}
	}
}

void function OnItemButtonEnter( rtk_behavior self, rtk_behavior button )
{
	file.hoveredItemButtons.append( button )
	file.lastHoveredItemButtonChangeTime = UITime()
}

void function OnItemButtonExit( rtk_behavior self, rtk_behavior button )
{
	file.hoveredItemButtons.fastremovebyvalue( button )
	file.lastHoveredItemButtonChangeTime = UITime()
}

ItemFlavor ornull function GetMilestoneRewardPack()
{
	
	
	
	if ( !GRX_IsInventoryReady() )
	{
		return null
	}

	ItemFlavor ornull activeEvent = file.activeEvent
	if ( activeEvent == null )
	{
		return null
	}
	expect ItemFlavor( activeEvent )
	ItemFlavor mainPackFlav = MilestoneEvent_GetMainPackFlav( activeEvent )
	int mainPackFlavCount =  GRX_GetPackCount( ItemFlavor_GetGRXIndex( mainPackFlav ) )
	ItemFlavor guaranteedPackFlav = MilestoneEvent_GetGuaranteedPackFlav( activeEvent )
	int guaranteedPackFlavCount =  GRX_GetPackCount( ItemFlavor_GetGRXIndex( guaranteedPackFlav ) )

	if ( mainPackFlavCount == 0 && guaranteedPackFlavCount == 0 )
	{
		return null
	}
	
	
	ItemFlavor milestonePackFlav = mainPackFlavCount > 0 ? mainPackFlav : guaranteedPackFlav
	return milestonePackFlav
}

void function TryOpenMilestoneRewardPack( ItemFlavor milestonePackFlav )
{
	EndSignal( uiGlobal.signalDummy, "OnTabChanged" )
	
	
	while ( IsDialog( GetActiveMenu() ) )
	{
		WaitFrame()
	}
	
	
	
	wait 1.0
	
	if ( GetActiveMenu() != GetMenu( "StoreOnlyMilestoneEventsMenu" ) && !IsEventPanelCurrentlyTopLevel()  )
		return

	OnLobbyOpenLootBoxMenu_ButtonPress( milestonePackFlav )
}

void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady( false ) && IsPersistenceAvailable()

	if ( !ready )
	{
		return
	}

	BuildMilestoneTrackingPanelInfo()
	BuildMilestoneCollectedCategoryInfo()
	BuildMilestoneCollectedItemsInfo()
	BuildPackPricingDataModel()
	BuildPurchaseButtonDataModel()
	SetUpPurchaseButtons( file.self )
}