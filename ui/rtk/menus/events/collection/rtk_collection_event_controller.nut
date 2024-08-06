global function RTKCollectionEventPanel_OnInitialize
global function RTKCollectionEventPanel_OnDestroy
global function RTKCollectionEventPanel_UpdateChaseItem

global struct RTKCollectionEventPanel_Properties
{
	rtk_behavior giftButton
	rtk_behavior purchaseButton
	rtk_panel offersGrid
	rtk_behavior eventPackOpenerHolder
	rtk_behavior openPackButton
	rtk_behavior chaseButton
	rtk_behavior informationButton
	rtk_panel mythicTierBreakdown
	rtk_panel heirloomBreakdown
}

global struct RTKCollectionCollectedItemInfoTooltip
{
	string titleText
}

global struct RTKCollectionCollectedItemInfo
{
	bool visible = false
	int quality
	int state
	bool isOwned
	bool isPurchasable
	bool isRestricted
	asset icon
	int price
	int index
	RTKCollectionCollectedItemInfoTooltip& tooltipInfo
}

global struct RTKCollectionChaseItemInfo
{
	bool visible = false
	int quality
	int state
	bool isOwned
	asset icon
	int totalItems
	int currentCollectedItems
	string chaseItemTitleFormat
	array< string >	chaseItemTitleArgs
	string chaseItemSubtitle
	string chaseItemDescription
	RTKCollectionCollectedItemInfoTooltip& tooltipInfo
	SettingsAssetGUID calEventCollection
}

global struct RTKCollectionPackInfo
{
	string packCountText
	string packTitleText
	string packDescriptionText
	asset icon
	int state
}

global struct RTKCollectionPurchaseButtonData
{
	bool visible
	bool interactive
	int price
	string title
	string details
	bool detailsVisible
}

global struct RTKCollectionGiftButtonData
{
	bool visible
	int state
}

global struct RTKCollectionMythicTierPipsInfo
{
	vector color
}

global struct RTKCollectionMythicTierInfo
{
	asset image
	string tooltipTitle
	int imageSize
	bool locked
	bool showLink
	bool showArrow
	array< RTKCollectionMythicTierPipsInfo > pips
}

global struct RTKCollectionDetailsPanelInfo
{
	string name
	int quality
	bool isOwned
	bool isRestricted
	asset packIcon
	asset coinIcon1
	asset coinIcon2
	string preTitle
	string title
	string subTitle
	string packName
	int price1
	int price2
	array<float> progress
	bool packDetailsVisible
	bool unlockWithDetailsVisible
	bool prestigeSkinDetailsVisible
	bool heirloomDetailsVisible
	bool artifactDetailsVisible
	string mythicTitle
	array< RTKCollectionMythicTierInfo > mythicTiers
}

global struct RTKCollectionEventPanel_ModelStruct
{
	bool visible = false
	string name
	string currentPageTitle
	string eventTitleText
	string titleCounterLocalizationString
	int titleEndTimestamp
	int totalItems
	int currentCollectedItems
	bool isRestricted
	SettingsAssetGUID calEventCollection
	RTKCollectionChaseItemInfo& chaseItemModel
	RTKCollectionPackInfo& packModel
	array< RTKCollectionCollectedItemInfo > collectedItemsModel
	RTKCollectionDetailsPanelInfo& detailsInfo
	RTKCollectionGiftButtonData& giftButtonData
	RTKCollectionPurchaseButtonData& purchaseButtonData
}

struct PrivateData
{
	void functionref() OnGRXStateChanged
}

const int MYTHIC_PREVIEW_SLOTS = 5
const int MYTHIC_TIERS = 3
const int MYTHIC_FINISHER_SLOT = 4
const int MYTHIC_SKYDIVE_TRAIL_SLOT = 1

void function RTKCollectionEventPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct collectionEventModelStruct = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "collectionEvent", "RTKCollectionEventPanel_ModelStruct" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "collectionEvent", true ) )

	thread function() : ( self, collectionEventModelStruct )
	{
		RTK_DevAssert( IsFullyConnected(), "RTKCollectionEventPanel_OnInitialize called while not connected to a server")

		while ( !IsFullyConnected() )
			WaitFrame()

		RTKCollectionEventPanel_OnInitializedAndConnected( self, collectionEventModelStruct )
	}()
}

void function RTKCollectionEventPanel_OnInitializedAndConnected( rtk_behavior self, rtk_struct collectionEventModelStruct )
{
	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	if ( !RTK_DevAssert( activeCollectionEvent != null, "RTKCollectionEventPanel_OnInitialize called without an active collection event, this panel should not have been instantiated") )
	{
		return
	}
	expect ItemFlavor( activeCollectionEvent )

	PrivateData p
	self.Private( p )
	p.OnGRXStateChanged = (void function() : (self, collectionEventModelStruct, activeCollectionEvent)
		{
			if ( !GRX_IsInventoryReady() )
				return

			bool isRestricted 				= GRX_IsOfferRestricted()
			array< ItemFlavor > items 		= CollectionEvent_GetEventItems( activeCollectionEvent )

			ItemFlavor chaseItem = HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
			ItemFlavor packItem = CollectionEvent_GetMainPackFlav( activeCollectionEvent )

			BuildEventSummaryPanelInfo( self, collectionEventModelStruct, activeCollectionEvent, isRestricted )
			BuildItemsInfo( self, collectionEventModelStruct, activeCollectionEvent, items, isRestricted )
			BuildChaseItemInfo( self, collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted )
			BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted ) 

			SetUpGridButtons( self, collectionEventModelStruct, activeCollectionEvent, items, isRestricted  )
			SetUpChaseButton( self, collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted  )
			SetUpInfoButton( self, activeCollectionEvent )
			SetUpOpenPackButton( self, collectionEventModelStruct, activeCollectionEvent, packItem, isRestricted )
			SetUpMythicTierButtons( self, collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted )
			SetUpPurchaseAndGiftButtons( self, collectionEventModelStruct, activeCollectionEvent, isRestricted )

			if ( !GetCurrentPlaylistVarBool( "disableCollectionEventAutoAward", false ) )
				thread TryOpenLootCeremonyAndCompletionRewardPack( activeCollectionEvent )
		})

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function RTKCollectionEventPanel_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function BuildEventSummaryPanelInfo( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, bool isRestricted = false )
{
	RTKCollectionEventPanel_ModelStruct newStruct
	newStruct.visible = true
	newStruct.isRestricted = isRestricted
	newStruct.calEventCollection = activeCollectionEvent.guid
	newStruct.titleEndTimestamp = CalEvent_GetFinishUnixTime( activeCollectionEvent )
	newStruct.currentPageTitle = CollectionEvent_GetCollectionName( activeCollectionEvent )
	newStruct.eventTitleText = ItemFlavor_GetShortName( activeCollectionEvent )
	newStruct.name = Localize( "#COLLECTION_EVENT" )
	newStruct.titleCounterLocalizationString = Localize( "#TIME_REMAINING" )
	RTKStruct_SetValue( collectionEventModelStruct, newStruct )
}

void function BuildItemsInfo( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, array<ItemFlavor> items, bool isRestricted = false)
{
	RTK_DevAssert( ItemFlavor_GetType( activeCollectionEvent ) == eItemType.calevent_collection, "RTKCollectionEventPanel_BuildItemsInfo called without a valid collection event.")

	array<RTKCollectionCollectedItemInfo> itemInfoStructArray = []

	string offerLocation        = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent, isRestricted )

	for ( int index = 0; index < items.len(); index++ )
	{
		ItemFlavor item = items[index]

		RTKCollectionCollectedItemInfo infoStruct
		infoStruct.visible = true
		infoStruct.index = index
		infoStruct.quality = ItemFlavor_GetQuality( item )
		infoStruct.icon = CustomizeMenu_GetRewardButtonImage( item )
		infoStruct.isOwned = GRX_IsItemOwnedByPlayer( item )
		infoStruct.state = infoStruct.isOwned ? eShopItemState.OWNED : eShopItemState.AVAILABLE
		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( item, offerLocation )
		infoStruct.isPurchasable = offers.len() > 0
		infoStruct.isRestricted = isRestricted
		infoStruct.price = infoStruct.isPurchasable ? GRXOffer_GetPremiumPriceQuantity( offers[0] ) : -1
		infoStruct.tooltipInfo.titleText = ItemFlavor_GetLongName( item )
		itemInfoStructArray.append( infoStruct )
	}

	RTKArray_SetValue(
		RTKStruct_GetOrCreateScriptArrayOfStructs( collectionEventModelStruct, "collectedItemsModel", "RTKCollectionCollectedItemInfo" )
		, itemInfoStructArray
	)
}

void function BuildChaseItemInfo( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, ItemFlavor chaseItem, bool isRestricted = false )
{
	entity localClientPlayer = GetLocalClientPlayer()

	RTKCollectionChaseItemInfo infoStruct
	infoStruct.visible = true
	infoStruct.chaseItemSubtitle = HeirloomEvent_GetHeirloomHeaderText( activeCollectionEvent )
	infoStruct.chaseItemDescription = HeirloomEvent_GetHeirloomUnlockDesc( activeCollectionEvent )
	infoStruct.quality = ItemFlavor_GetQuality( chaseItem )
	infoStruct.icon = HeirloomEvent_GetHeirloomButtonImage( activeCollectionEvent )
	infoStruct.isOwned = GRX_IsItemOwnedByPlayer( chaseItem ) || HeirloomEvent_IsCompletionRewardOwned( activeCollectionEvent, GRX_IsInventoryReady() )
	infoStruct.state = infoStruct.isOwned ? eShopItemState.OWNED : eShopItemState.AVAILABLE
	infoStruct.totalItems = HeirloomEvent_GetItemCount( activeCollectionEvent, false, localClientPlayer )
	infoStruct.currentCollectedItems = HeirloomEvent_GetItemCount( activeCollectionEvent, true, localClientPlayer )
	infoStruct.chaseItemTitleFormat = "#COLLECTION_VAL_SLASH_VAL_TWO_STYLE_COLLECTED"
	infoStruct.chaseItemTitleArgs = [ infoStruct.currentCollectedItems.tostring(), infoStruct.totalItems.tostring() ]
	infoStruct.tooltipInfo.titleText = ItemFlavor_GetLongName( chaseItem )
	infoStruct.calEventCollection = activeCollectionEvent.guid

	rtk_struct chaseInfo = RTKStruct_GetOrCreateScriptStruct( collectionEventModelStruct, "chaseItemModel", "RTKCollectionChaseItemInfo" )
	RTKStruct_SetValue( chaseInfo, infoStruct )
}

void function BuildInspectInfo( rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, ItemFlavor item, bool isRestricted = false, int buttonIndex = -1 )
{
	rtk_struct detailsInfo = RTKStruct_GetOrCreateScriptStruct( collectionEventModelStruct, "detailsInfo", "RTKCollectionDetailsPanelInfo" )

	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( item, CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent, isRestricted ) )
	if ( !isRestricted )
	{
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		if ( activeThemedShopEvent != null )
		{
			expect ItemFlavor( activeThemedShopEvent )
			offers.extend( GRX_GetItemDedicatedStoreOffers( item, ThemedShopEvent_GetGRXOfferLocation( activeThemedShopEvent ) ) )
		}
	}

	int itemType = ItemFlavor_GetType( item )
	ItemFlavor inspectItem = item

	bool artifactDetailsVisible = false
	if ( itemType == eItemType.artifact_component_blade ||
			itemType == eItemType.artifact_component_activation_emote ||
			itemType == eItemType.artifact_component_power_source ||
			itemType == eItemType.artifact_component_theme )
	{
		artifactDetailsVisible = true
	}

	bool isRewardMythicSkin = Mythics_IsItemFlavorMythicSkin( item )

	RTKCollectionDetailsPanelInfo itemInfo
	itemInfo.packDetailsVisible = ( itemType == eItemType.account_pack )
	itemInfo.prestigeSkinDetailsVisible = ( isRewardMythicSkin && itemType == eItemType.character_skin )
	itemInfo.heirloomDetailsVisible = ( itemType == eItemType.melee_skin )
	itemInfo.artifactDetailsVisible = artifactDetailsVisible
	itemInfo.unlockWithDetailsVisible = (!itemInfo.packDetailsVisible && !itemInfo.prestigeSkinDetailsVisible && !itemInfo.heirloomDetailsVisible && !itemInfo.artifactDetailsVisible)
	bool isStandardItem = ( itemInfo.unlockWithDetailsVisible || itemInfo.prestigeSkinDetailsVisible || itemInfo.heirloomDetailsVisible || itemInfo.artifactDetailsVisible )
	itemInfo.isOwned = ( isStandardItem )  ? GRX_IsItemOwnedByPlayer( item ) : false
	itemInfo.quality = ( isStandardItem ) ? ItemFlavor_GetQuality( item ) : 1
	itemInfo.preTitle = ( isStandardItem ) ? Localize( ItemQuality_GetQualityName( itemInfo.quality ) ).toupper() : Localize( "#itemtype_account_pack_NAME" )
	itemInfo.title = ( isStandardItem ) ? ItemFlavor_GetLongName( item ) : Localize( CollectionEvent_GetMainPackShortPluralName( activeCollectionEvent ) )
	itemInfo.subTitle = ( isStandardItem ) ? MilestoneEvent_GetCarouselItemDescriptionText( item ) : "#COLLECTION_EVENT_PACK_SUBTITLE"
	itemInfo.packIcon = CollectionEvent_GetMainPackImage( activeCollectionEvent )
	itemInfo.packName = Localize( CollectionEvent_GetMainPackShortPluralName( activeCollectionEvent ) )
	itemInfo.isRestricted = isRestricted

	if ( isRewardMythicSkin )
	{
		asset eventAsset = ItemFlavor_GetAsset( activeCollectionEvent )
		int tiersUnlocked = Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), item )

		itemInfo.title = HeirloomEvent_GetHeirloomHeaderText( activeCollectionEvent )
		itemInfo.mythicTitle = Localize( "#COLLECTION_EVENT_DETAILS_MYTHIC_TIER", tiersUnlocked )

		array<RTKCollectionMythicTierInfo> mythicTiers = []

		if ( buttonIndex >= 0 )
		{
			int buttonTier = buttonIndex <= 2 ? buttonIndex <= 1 ? 1 : 2 : 3
			ItemFlavor ornull itemFlavInspect = Mythics_GetItemTierForSkin( item, buttonTier -1 )
			if ( itemFlavInspect != null )
			{
				expect ItemFlavor(itemFlavInspect)
				inspectItem = itemFlavInspect
			}
		}

		for ( int i; i < MYTHIC_PREVIEW_SLOTS; i++ )
		{
			RTKCollectionMythicTierInfo mythicTier

			int tier = i <= 2 ? i <= 1 ? 1 : 2 : 3
			bool isOwned = GRX_IsItemOwnedByPlayer( item ) && tiersUnlocked >= tier
			bool isSkydiveOrFinisher = i == MYTHIC_SKYDIVE_TRAIL_SLOT || i == MYTHIC_FINISHER_SLOT

			mythicTier.tooltipTitle = Localize( "#COLLECTION_EVENT_DETAILS_MYTHIC_TIER", tier )
			mythicTier.locked = !isOwned

			ItemFlavor ornull itemFlavIcon
			if ( i == MYTHIC_SKYDIVE_TRAIL_SLOT )
			{
				itemFlavIcon = Mythics_GetCustomSkydivetrailForCharacterOrSkin( item )
			}
			else if ( i == MYTHIC_FINISHER_SLOT )
			{
				
				itemFlavIcon = Mythics_GetItemTierForSkin( item, tier )
			}
			else
			{
				itemFlavIcon = Mythics_GetItemTierForSkin( item, 1 )
			}
			if ( itemFlavIcon != null )
			{
				expect ItemFlavor(itemFlavIcon)
				mythicTier.image = CustomizeMenu_GetRewardButtonImage( itemFlavIcon )
				mythicTier.imageSize = isSkydiveOrFinisher ? 56 : 40
			}

			mythicTier.showArrow = i == 1 || i == 2
			mythicTier.showLink = isSkydiveOrFinisher

			bool showPips = !isSkydiveOrFinisher
			if ( showPips )
			{
				array<RTKCollectionMythicTierPipsInfo> pips = []
				for ( int j; j < MYTHIC_TIERS; j++ )
				{
					RTKCollectionMythicTierPipsInfo pip
					pip.color = j <= tier - 1 ? GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, 5 ) / 255.0 : <0.25, 0.25, 0.25>
					mythicTier.pips.push(pip)
				}
			}

			mythicTiers.push( mythicTier )
		}

		itemInfo.mythicTiers = mythicTiers
	}
	else if ( itemInfo.heirloomDetailsVisible )
	{
		array<RTKCollectionMythicTierInfo> mythicTiers = []

		ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
		array<ItemFlavor> packContents = GRXPack_GetPackContents( completionRewardPack )

		for ( int i; i < packContents.len() ; i++ )
		{
			ItemFlavor packItem = packContents[i]

			RTKCollectionMythicTierInfo mythicTier
			mythicTier.tooltipTitle = ItemFlavor_GetLongName( packItem )
			mythicTier.locked = !GRX_IsItemOwnedByPlayer( item )
			mythicTier.image = CustomizeMenu_GetRewardButtonImage( packItem )
			mythicTier.imageSize = 56
			mythicTier.showArrow = false
			mythicTier.showLink = false

			mythicTiers.push( mythicTier )

			if ( buttonIndex == i )
			{
				inspectItem = packItem
			}
		}

		itemInfo.mythicTiers = mythicTiers
	}

	ItemFlavor currencyFlav1 = GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]
	itemInfo.price1 = offers.len() > 0 ? GRXOffer_GetPremiumPriceQuantity( offers[0] ) : -1
	itemInfo.coinIcon1 = ItemFlavor_GetIcon( currencyFlav1 )

	ItemFlavor currencyFlav2 = GRX_CURRENCIES[GRX_CURRENCY_CRAFTING]
	itemInfo.price2 = offers.len() > 0 ? GRXOffer_GetCraftingPriceQuantity( offers[0] ) : -1
	itemInfo.coinIcon2 = ItemFlavor_GetIcon( currencyFlav2 )

	RTKStruct_SetValue( detailsInfo, itemInfo )

	if ( IsValidItemFlavorGUID( ItemFlavor_GetGUID( inspectItem ) ) )
	{
		if ( EventsPanel_GetCurrentPageIndex() == eEventsPanelPage.COLLECTION_EVENT )
		{
			RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( inspectItem ) , -1, 1.19, Battlepass_ShouldShowLow( inspectItem ), null, false, "collection_event_ref", false, false, false, false )
		}
	}
}

void function SetUpGridButtons( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, array<ItemFlavor> items, bool isRestricted = false )
{
	rtk_panel ornull offersGrid = self.PropGetPanel( "offersGrid" )
	if ( offersGrid != null )
	{
		expect rtk_panel( offersGrid )

		self.AutoSubscribe( offersGrid, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, activeCollectionEvent, collectionEventModelStruct, items, isRestricted ) {
			array< rtk_behavior > gridItems = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in gridItems )
			{
				array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( items[newChildIndex], CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent, isRestricted ) )

				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, activeCollectionEvent, newChildIndex, collectionEventModelStruct, items, isRestricted ) {
					if ( EventsPanel_GetCurrentPageIndex() != eEventsPanelPage.EVENT_SHOP )
					{
						Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )
						BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, items[newChildIndex], isRestricted )
					}
				} )

				if( offers.len() > 0 )
				{
					GRXScriptOffer offer = offers[0]
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, offer ) {
						StoreInspectMenu_AttemptOpenWithOffer( offer )
					} )
				}
				else
				{
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, activeCollectionEvent, items, isRestricted ) {
						string title = isRestricted ? "#MILESTONE_EVENT_LOCKED_PRESENTATION_BUTTON_TITLE" : "#MILESTONE_EVENT_PURCHASE_PRESENTATION_BUTTON_TITLE"
						SetGenericItemPresentationModeActiveWithNavBack( items[newChildIndex], title, "#MILESTONE_EVENT_PURCHASE_PRESENTATION_BUTTON_DESC", void function() : ()
						{
						} )
					} )
				}
			}
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No Grid buttons")
	}
}

void function SetUpMythicTierButtons( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, ItemFlavor chaseItem, bool isRestricted = false )
{
	array< rtk_panel ornull > panels

	panels.push( self.PropGetPanel( "mythicTierBreakdown" ) )
	panels.push( self.PropGetPanel( "heirloomBreakdown" ) )

	foreach ( rtk_panel ornull panel in panels )
	{
		if ( panel == null )
			continue

		expect rtk_panel( panel )

		self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, activeCollectionEvent, collectionEventModelStruct, chaseItem, isRestricted ) {
			array< rtk_behavior > buttons = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in buttons )
			{
				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted, newChildIndex ) {
					Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )
					BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted, newChildIndex )
				} )

				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, activeCollectionEvent, chaseItem, isRestricted ) {
					InspectChaseItem( activeCollectionEvent )
				} )
			}
		} )
	}
}

void function SetUpChaseButton( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, ItemFlavor chaseItem, bool isRestricted = false )
{
	rtk_behavior ornull button = self.PropGetBehavior( "chaseButton" )
	if ( button != null )
	{
		expect rtk_behavior( button )

		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( chaseItem, CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent, isRestricted ) )

		self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted ) {
			Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )
			BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, chaseItem, isRestricted )
		} )

		if( offers.len() > 0 )
		{
			GRXScriptOffer offer = offers[0]
			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self , offer ) {
				StoreInspectMenu_AttemptOpenWithOffer( offer )
			} )
		}
		else
		{
			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, activeCollectionEvent, chaseItem, isRestricted ) {
				InspectChaseItem( activeCollectionEvent )
			} )
		}
	}
	else
	{
		Warning("RTKCollectionEventPanel: No Chase button")
	}
}

void function SetUpInfoButton( rtk_behavior self, ItemFlavor activeCollectionEvent )
{
	rtk_behavior ornull informationButton = self.PropGetBehavior( "informationButton" )

	if ( informationButton == null )
		return

	expect rtk_behavior( informationButton )

	self.AutoSubscribe( informationButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, activeCollectionEvent ) {
		SetCollectionEventAboutPageEvent( activeCollectionEvent )
		OpenCollectionEventAboutPageWithEventTabTelemetry( button )
	} )
}

void function SetUpOpenPackButton( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, ItemFlavor packItem, bool isRestricted = false )
{
	ItemFlavor rewardPack = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
	asset rarityIcon = GRXPack_GetOpenButtonIcon( rewardPack )
	int ownedPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( rewardPack ) )

	RTKCollectionPackInfo infoStruct
	infoStruct.packCountText = ownedPackCount.tostring()
	infoStruct.packTitleText = Localize( CollectionEvent_GetMainPackShortPluralName( activeCollectionEvent ) )
	infoStruct.packDescriptionText = ownedPackCount == 1 ? "#EVENT_PACK" : "#EVENT_PACKS"
	infoStruct.icon = rarityIcon
	infoStruct.state = ownedPackCount <= 0 ? eEventPackPurchaseButtonState.UNAVAILABLE : eEventPackPurchaseButtonState.AVAILABLE

	rtk_struct packInfo = RTKStruct_GetOrCreateScriptStruct( collectionEventModelStruct, "packModel", "RTKCollectionPackInfo" )
	RTKStruct_SetValue( packInfo, infoStruct )

	rtk_behavior ornull eventPackOpenerHolder = self.PropGetBehavior( "eventPackOpenerHolder" )
	if ( eventPackOpenerHolder != null )
	{
		expect rtk_behavior( eventPackOpenerHolder )

		self.AutoSubscribe( eventPackOpenerHolder, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, collectionEventModelStruct, activeCollectionEvent, packItem, isRestricted) {
			BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, packItem, isRestricted )
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No openPackButton")
	}

	rtk_behavior ornull openPackButton = self.PropGetBehavior( "openPackButton" )
	if ( openPackButton != null )
	{
		expect rtk_behavior( openPackButton )

		self.AutoSubscribe( openPackButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( activeCollectionEvent ) {
			ItemFlavor packFlav              = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
			if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) ) > 0 )
				OnLobbyOpenLootBoxMenu_ButtonPress( packFlav )

			ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
			if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
				OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No openPackButton")
	}
}

void function SetUpPurchaseAndGiftButtons( rtk_behavior self, rtk_struct collectionEventModelStruct, ItemFlavor activeCollectionEvent, bool isRestricted = false  )
{

	int currentMaxEventPackPurchaseCount 	= 0
	bool isInventoryReady                   = GRX_IsInventoryReady()
	bool offersReady                        = GRX_AreOffersReady()
	array<GRXScriptOffer> offers			= []
	int lowestPrice 						= INT_MAX
	int lowestPriceIndex 					= -1
	array<GRXScriptOffer> ornull offersOrNull

	if ( isInventoryReady && offersReady )
	{
		currentMaxEventPackPurchaseCount = CollectionEvent_GetCurrentMaxEventPackPurchaseCount( activeCollectionEvent, GetLocalClientPlayer() )
		offersOrNull = CollectionEvent_GetPackOffers( activeCollectionEvent )
	}

	bool isPackOfferPurchasable = false
	if ( offersOrNull != null )
	{
		expect array<GRXScriptOffer>( offersOrNull )
		offers = offersOrNull
	}
	if ( offers.len() > 0 )
	{
		foreach ( int offerIndex, GRXScriptOffer offer in offers )
		{
			isPackOfferPurchasable = isPackOfferPurchasable || GRXOffer_IsEligibleForPurchase( offer )

			foreach ( int priceIndex, ItemFlavorBag price in offer.prices )
			{
				foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
				{
					int cost = price.quantities[costIndex]
					if ( ItemFlavor_GetType( costFlav ) == eItemType.account_currency && cost < lowestPrice)
					{
						lowestPrice = cost
						lowestPriceIndex = offerIndex
					}
				}
			}
		}
	}

	RTKCollectionGiftButtonData giftDataStruct
	giftDataStruct.visible = !isRestricted
	giftDataStruct.state = GetEventGiftButtonState( offers )
	rtk_struct giftButtonModelStruct = RTKStruct_GetOrCreateScriptStruct( collectionEventModelStruct, "giftButtonData", "RTKCollectionGiftButtonData" )
	RTKStruct_SetValue( giftButtonModelStruct, giftDataStruct )

	rtk_behavior ornull giftButton = self.PropGetBehavior( "giftButton" )
	if ( giftButton != null )
	{
		expect rtk_behavior( giftButton )

		self.AutoSubscribe( giftButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( activeCollectionEvent, offers, lowestPriceIndex ) {
			int state = GetEventGiftButtonState( offers )
			if ( lowestPriceIndex < 0 )
			{
				state = eEventPackPurchaseButtonState.UNAVAILABLE
			}
			switch ( state )
			{
				case eEventGiftingButtonState.AVAILABLE:
				{
					
					int quantity = 1
					PurchaseDialogConfig pdc
					pdc.offer = offers[lowestPriceIndex]
					pdc.quantity = quantity
					pdc.markAsNew = false
					pdc.isGiftPack = true
					PurchaseDialog( pdc )
					break
				}
				case eEventGiftingButtonState.TWO_FACTOR_DISABLED:
					OpenTwoFactorInfoDialog( null )
					break
				case eEventGiftingButtonState.GIFTING_EXCEEDED:
				case eEventGiftingButtonState.NOT_ENOUGH_LEVEL:
				case eEventGiftingButtonState.UNAVAILABLE:
				{
					EmitUISound( "menu_deny" )
					return
				}
				default:
					return
			}
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No giftButton")
	}

	RTKCollectionPurchaseButtonData purchaseDataStruct
	purchaseDataStruct.visible = !isRestricted
	purchaseDataStruct.interactive = offers.len() > 0 && lowestPriceIndex >= 0 && currentMaxEventPackPurchaseCount > 0
	purchaseDataStruct.price = lowestPrice
	purchaseDataStruct.title =  purchaseDataStruct.interactive ? Localize("#COLLECTION_PURCHASE_PACKS") : Localize( "#UNAVAILABLE" )
	purchaseDataStruct.details =  Localize( "#COLLECTION_PURCHASE_PACK", lowestPrice )
	purchaseDataStruct.detailsVisible = purchaseDataStruct.interactive && lowestPrice < INT_MAX
	rtk_struct purchaseButtonModelStruct = RTKStruct_GetOrCreateScriptStruct( collectionEventModelStruct, "purchaseButtonData", "RTKCollectionPurchaseButtonData" )
	RTKStruct_SetValue( purchaseButtonModelStruct, purchaseDataStruct )

	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	if ( purchaseButton != null )
	{
		expect rtk_behavior( purchaseButton )

		self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( activeCollectionEvent, offers, lowestPriceIndex, currentMaxEventPackPurchaseCount ) {
			int state = GetEventPurchaseButtonState( offers )
			if ( lowestPriceIndex < 0 || currentMaxEventPackPurchaseCount <= 0 )
			{
				state = eEventPackPurchaseButtonState.UNAVAILABLE
			}
			switch ( state )
			{
				case eEventPackPurchaseButtonState.AVAILABLE:
				{
					
					PurchaseDialogConfig pdc
					pdc.quantity = 1
					pdc.markAsNew = false
					GRXScriptOffer offer = offers[lowestPriceIndex]
					pdc.offer = offer
					PurchaseDialog( pdc )
					break
				}
				default:
				{
					EmitUISound( "menu_deny" )
					return
				}

			}
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No purchaseButton")
	}
}

void function InspectChaseItem(ItemFlavor activeCollectionEvent)
{
	if ( HeirloomEvent_AwardHeirloomShards( activeCollectionEvent ) )
	{
		JumpToHeirloomShop()
		return
	}

	ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
	array<ItemFlavor> packContents = GRXPack_GetPackContents( completionRewardPack )

	GRXScriptOffer fakeOffer
	fakeOffer.titleText = ItemFlavor_GetLongName( completionRewardPack )
	fakeOffer.descText = ""
	fakeOffer.prereq = activeCollectionEvent

	ItemFlavorBag priceBag
	priceBag.flavors.append( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	priceBag.quantities.append( 999999999 )
	fakeOffer.prices.append( priceBag )

	foreach ( item in packContents )
		AddItemToFakeOffer( fakeOffer, item )

	if ( HeirloomEvent_IsRewardMythicSkin( activeCollectionEvent ) )
		StoreMythicInspectMenu_AttemptOpenWithOffer( fakeOffer )
	else
		StoreInspectMenu_AttemptOpenWithOffer( fakeOffer )
}

void function TryOpenLootCeremonyAndCompletionRewardPack( ItemFlavor activeCollectionEvent )
{
	WaitFrame()

	bool grxReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	if ( !grxReady )
		return

	ItemFlavor completionRewardPack  = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
}

void function RTKCollectionEventPanel_UpdateChaseItem()
{
	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	if ( activeCollectionEvent == null )
		return

	expect ItemFlavor( activeCollectionEvent )

	ItemFlavor chaseItem = HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )

	rtk_struct collectionEventModelStruct = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "collectionEvent" ) )

	BuildInspectInfo( collectionEventModelStruct, activeCollectionEvent, chaseItem, GRX_IsOfferRestricted() ) 
}