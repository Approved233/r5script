
global function MilestoneEvents_Init



global function GetActiveMilestoneEvent
global function MilestoneEvent_GetFrontPageRewardBoxTitle
global function MilestoneEvent_GetMainPackFlav
global function MilestoneEvent_GetMainPackImage
global function MilestoneEvent_GetFrontPageGRXOfferLocation
global function MilestoneEvent_GetAboutText
global function MilestoneEvent_GetMainIcon
global function MilestoneEvent_GetMilestoneGrantRewards
global function MilestoneEvent_GetStoreEventSectionMainImage
global function MilestoneEvent_GetStoreEventSectionMainText
global function MilestoneEvent_GetStoreEventSectionSubText
global function MilestoneEvent_GetEventItems
global function MilestoneEvent_GetMythicEventItems
global function MilestoneEvent_GetRewardGroups
global function MilestoneEvent_GetGuaranteedPackFlav
global function MilestoneEvent_IsItemEventItem



global function MilestoneEvent_GetCurrentMaxEventPackPurchaseCount



global function MilestoneEvent_IsEnabled
global function MilestoneEvent_GetGuaranteedMultiPackOffers
global function MilestoneEvent_GetSinglePackOffers
global function MilestoneEvent_GetCustomIconForItemIdx
global function MilestoneEvent_GetCarouselItemDescriptionText
global function MilestoneEvent_GetRemainingCompletionItemsForCurrentMilestone
global function MilestoneEvent_GetDisclaimerBoxColor
global function MilestoneEvent_GetMilestoneBoxTitleColor
global function MilestoneEvent_GetTitleBGColor
global function MilestoneEvent_GetChaseItemUnlockDescription
global function MilestoneEvent_GetChaseItemIcon
global function MilestoneEvent_GetMainPackShortPluralName
global function MilestoneEvent_GetFeaturedItems
global function MilestoneEvent_GetGlobalSettingsFloat
global function MilestoneEvent_GetTitleCol
global function MilestoneEvent_GetPackOffers
global function MilestoneEvent_IsItemFlavorFromEvent
global function MilestoneEvent_IsMythicEventItem
global function MilestoneEvent_IsMilestoneGrantReward
global function MilestoneEvent_IsMilestoneRewardCeremonyDue
global function MilestoneEvent_SetMilestoneRewardCeremonyDue
global function MilestoneEvent_MoveToLobbyForMilestoneRewardCeremony
global function MilestoneEvent_TryDisplayMilestoneRewardCeremony
global function MilestoneEvent_TryMoveToMilestonePostRewardCeremony
global function ServerCallback_MilestoneEvent_MilestoneRewardCeremonyIsDue
global function ServerCallback_MilestoneEvent_TryDisplayMilestoneRewardCeremonyForAutoOpenPacks
global function MilestoneEvent_GetEventIcon
global function MilestoneEvent_GetCollectionBoxBGImage
global function MilestoneEvent_GetTrackerBoxBGImage
global function MilestoneEvent_GetMilestoneTrackerProgressBarColor
global function MilestoneEvent_GetMilestoneTrackerProgressBarBGColor

global function MilestoneEvent_EventAwardsArtifact



global function MilestoneEvent_GetEventItemRatesData
global function MilestoneEvent_GetStandardItemRatesData
global function MilestoneEvent_GetMultiItemRatesData
global function MilestoneEvent_GetPricePackRangesData
global function MilestoneEvent_GetLegalTextData
global function MilestoneEvent_GetGuaranteedPackText



global struct MilestoneEventGrantReward
{
	int         grantingLevel
	ItemFlavor& rewardFlav
	asset 		customImage
	string		customName
}



global struct RTKPackPurchaseSelectionButtonData
{
	string price
	asset image
	int discount
}

global struct RTKPurchasePackRateInfo
{
	string title
	string rate
	int quality
}

global struct RTKPurchasePackRowRatesInfo
{
	array<RTKPurchasePackRateInfo> rates
}

global struct RTKPurchasePackRateSectionInfo
{
	string title
	vector color
	array<RTKPurchasePackRowRatesInfo> rows
}

global struct RTKPurchasePackPriceInfo
{
	string title
	string originalPrice
	string price
	string craftingPrice
	string discount
	float discountBGAlpha
}

global struct RTKPurchasePackRowPriceInfo
{
	array<RTKPurchasePackPriceInfo> prices
}


global struct RTKPurchasePackPriceSectionInfo
{
	string title
	vector color
	array<RTKPurchasePackRowPriceInfo> rows
}

global struct RTKPurchasePackInformationLines
{
	array<string> text
}



struct FileStruct_LifetimeLevel
{
	EntitySet chasePackGrantQueued
	bool milestoneEvents_MilestoneRewardCeremonyDue = false
}




FileStruct_LifetimeLevel& fileLevel 

struct {
	
} fileVM 




void function MilestoneEvents_Init()
{

		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel






}



ItemFlavor ornull function GetActiveMilestoneEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_milestone ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple collection events are active!! (%s, %s)", string(ItemFlavor_GetAsset( expect ItemFlavor(event) )), string(ItemFlavor_GetAsset( ev )) ) )
		event = ev
	}
	return event
}




array<ItemFlavor> function MilestoneEvent_GetLoginRewards( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<ItemFlavor> rewards = []
	foreach ( var rewardBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "loginRewards" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( rewardBlock, "flavor" )
		if ( IsValidItemFlavorSettingsAsset( rewardAsset ) )
			rewards.append( GetItemFlavorByAsset( rewardAsset ) )
	}
	return rewards
}



string function MilestoneEvent_GetFrontPageRewardBoxTitle( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontPageRewardBoxTitle" )
}



array<GRXScriptOffer> function MilestoneEvent_GetGuaranteedMultiPackOffers( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( MilestoneEvent_GetGuaranteedPackFlav( event ), MilestoneEvent_GetFrontPageGRXOfferLocation( event, GRX_IsOfferRestricted() ) )
	return offers
}



array<GRXScriptOffer> function MilestoneEvent_GetSinglePackOffers( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( MilestoneEvent_GetMainPackFlav( event ), MilestoneEvent_GetFrontPageGRXOfferLocation( event, GRX_IsOfferRestricted() ) )
	int index = 0
	foreach( offer in offers )
	{
		if ( offer.items.len() > 1 )
		{
			offers.remove( index )
		}
		index++
	}
	return offers
}



ItemFlavor function MilestoneEvent_GetMainPackFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackFlav" ) )
}



string function MilestoneEvent_GetCarouselItemDescriptionText( ItemFlavor item )
{
	string descText = ""
	descText = GetLocalizedItemFlavorDescriptionForOfferButton( item, false )
	descText += " - "
	descText += Localize( GRX_IsInventoryReady() ? (GRX_IsItemOwnedByPlayer( item ) ? "#OWNED" : "#LOCKED") : "" )
	return descText
}



int function MilestoneEvent_GetRemainingCompletionItemsForCurrentMilestone( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<MilestoneEventGrantReward> milestones = MilestoneEvent_GetMilestoneGrantRewards( event, GRX_IsOfferRestricted() )

	array<ItemFlavor> items = MilestoneEvent_GetEventItems( event, GRX_IsOfferRestricted() )
	items.extend( MilestoneEvent_GetMythicEventItems( event, GRX_IsOfferRestricted() ) )
	int collectionProgress 							= GRX_GetNumberOfOwnedItemsByPlayer( items )

	foreach( milestone in milestones )
	{
		if ( milestone.grantingLevel > collectionProgress )
			return milestone.grantingLevel - collectionProgress
	}
	return 0
}



asset function MilestoneEvent_GetEventIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "eventIcon" )
}



ItemFlavor function MilestoneEvent_GetGuaranteedPackFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "guaranteedPackFlav" ) )
}



string function MilestoneEvent_GetChaseItemUnlockDescription( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), GRX_IsOfferRestricted() ? "chaseItemUnlockDescRestrict" : "chaseItemUnlockDesc" )
}



asset function MilestoneEvent_GetChaseItemIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "chaseItemButtonImage" )
}



string function MilestoneEvent_GetMainPackShortPluralName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "mainPackShortPluralName" )
}




asset function MilestoneEvent_GetMainPackImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackImage" )
}



string function MilestoneEvent_GetFrontPageGRXOfferLocation( ItemFlavor event, bool isRestricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), isRestricted ? "restrictedGRXOfferLocation" : "frontGRXOfferLocation" )
}



array<string> function MilestoneEvent_GetAboutText( ItemFlavor event, bool restricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<string> aboutText = []
	string key              = (restricted ? "aboutTextRestricted" : "aboutTextStandard")
	foreach ( var aboutBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), key ) )
		aboutText.append( GetSettingsBlockString( aboutBlock, "text" ) )
	return aboutText
}



void function MilestoneEvent_GetMainIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
}



array<MilestoneEventGrantReward> function MilestoneEvent_GetMilestoneGrantRewards( ItemFlavor event, bool isRestricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<MilestoneEventGrantReward> groups = []
	string rewardsGroupVar                  = isRestricted ? "restrictedMilestoneGroups" : "milestoneGroups"
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), rewardsGroupVar ) )
	{
		MilestoneEventGrantReward group
		group.grantingLevel = GetSettingsBlockInt( groupBlock, "milestoneLevel" )
		group.rewardFlav    = GetItemFlavorByAsset( GetSettingsBlockAsset( groupBlock, "reward" ) )
		group.customName 	= GetSettingsBlockString( groupBlock, "milestoneRewardCustomName" )
		group.customImage 	= GetSettingsBlockAsset( groupBlock, "milestoneRewardCustomImage" )
		groups.append( group )
	}
	return groups
}



asset function MilestoneEvent_GetStoreEventSectionMainImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "storeEventSectionMainImage" )
}



string function MilestoneEvent_GetStoreEventSectionMainText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "storeEventSectionMainText" )
}



string function MilestoneEvent_GetStoreEventSectionSubText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "storeEventSectionSubText" )
}



vector function MilestoneEvent_GetTitleCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "titleCol" )
}



vector function MilestoneEvent_GetTitleBGColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "titleBackCol" )
}



vector function MilestoneEvent_GetMilestoneBoxTitleColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "titleMilestoneCol" )
}



vector function MilestoneEvent_GetDisclaimerBoxColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "milestoneDisclaimerBoxCol" )
}



vector function MilestoneEvent_GetMilestoneTrackerProgressBarColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "milestoneTrackerProgressBarCol" )
}



vector function MilestoneEvent_GetMilestoneTrackerProgressBarBGColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "milestoneTrackerProgressBarBGCol" )
}



asset function MilestoneEvent_GetCollectionBoxBGImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "milestoneCollectionBoxBgImage" )
}



asset function MilestoneEvent_GetTrackerBoxBGImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "milestoneTrackerBoxBgImage" )
}



array<ItemFlavor> function MilestoneEvent_GetFeaturedItems( ItemFlavor event, bool isRestricted = false )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<ItemFlavor> items = []
	foreach ( var rewardBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "featuredItems" ) )
	{
		items.append( GetItemFlavorByAsset( GetSettingsBlockAsset( rewardBlock, "featuredItem" ) ) )
	}
	return items
}



float function MilestoneEvent_GetGlobalSettingsFloat( ItemFlavor event, string settingName )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( event ), settingName )
}



array<ItemFlavor> function MilestoneEvent_GetEventItems( ItemFlavor event, bool isRestricted = false )
{
	array<ItemFlavor> eventItems
	if ( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	{
		array<CollectionEventRewardGroup> rewardGroups = MilestoneEvent_GetRewardGroups( event, isRestricted )
		foreach ( CollectionEventRewardGroup rewardGroup in rewardGroups )
		{
			
			if ( rewardGroup.quality == eRarityTier.MYTHIC && rewardGroup.rewards.len() == 1 )
			{
				continue
			}

			foreach ( ItemFlavor reward in rewardGroup.rewards )
			{
				eventItems.append( reward )
			}
		}
	}
	return eventItems
}



array<ItemFlavor> function MilestoneEvent_GetMythicEventItems( ItemFlavor event, bool isRestricted = false )
{
	array<ItemFlavor> eventItems
	if ( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	{
		array<CollectionEventRewardGroup> rewardGroups = MilestoneEvent_GetRewardGroups( event, isRestricted )
		foreach ( CollectionEventRewardGroup rewardGroup in rewardGroups )
		{
			if ( rewardGroup.quality == eRarityTier.MYTHIC )
			{
				foreach ( ItemFlavor reward in rewardGroup.rewards )
				{
					eventItems.append( reward )
				}
			}
		}
	}
	return eventItems
}




array<CollectionEventRewardGroup> function MilestoneEvent_GetRewardGroups( ItemFlavor event, bool isRestricted = false )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<CollectionEventRewardGroup> groups = []
	string rewardPath = isRestricted ? "restrictedRewardGroups" : "rewardGroups"
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), rewardPath ) )
	{
		CollectionEventRewardGroup group
		group.ref = GetSettingsBlockString( groupBlock, "ref" )
		group.quality = eRarityTier[GetSettingsBlockString( groupBlock, "quality" )]
		foreach ( var rewardBlock in IterateSettingsArray( GetSettingsBlockArray( groupBlock, "rewards" ) ) )
			group.rewards.append( GetItemFlavorByAsset( GetSettingsBlockAsset( rewardBlock, "flavor" ) ) )

		groups.append( group )
	}
	return groups
}



bool function MilestoneEvent_IsItemEventItem( ItemFlavor event, int itemIdx )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<ItemFlavor> eventItems = MilestoneEvent_GetMythicEventItems( event )
	eventItems.extend( MilestoneEvent_GetEventItems( event, GRX_IsOfferRestricted() ) )
	foreach( ItemFlavor item in eventItems )
	{
		if ( item.grxIndex == itemIdx )
			return true
	}
	return false
}



asset function MilestoneEvent_GetCustomIconForItemIdx( ItemFlavor event, int grxIdx, bool isRestricted = false )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<CollectionEventRewardGroup> groups = []
	string rewardPath = isRestricted ? "restrictedRewardGroups" : "rewardGroups"
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), rewardPath ) )
	{
		CollectionEventRewardGroup group
		group.ref = GetSettingsBlockString( groupBlock, "ref" )
		group.quality = eRarityTier[GetSettingsBlockString( groupBlock, "quality" )]
		foreach ( var rewardBlock in IterateSettingsArray( GetSettingsBlockArray( groupBlock, "rewards" ) ) )
		{
			ItemFlavor item = GetItemFlavorByAsset( GetSettingsBlockAsset( rewardBlock, "flavor" ) )
			if ( item.grxIndex == grxIdx )
			{
				return GetSettingsBlockAsset( rewardBlock, "milestoneItemCustomImage" )
			}
		}
	}
	unreachable
}



bool function MilestoneEvent_IsItemFlavorFromEvent( ItemFlavor event, int grxIdx )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<ItemFlavor> eventItems = MilestoneEvent_GetEventItems( event )
	foreach( ItemFlavor item in eventItems )
	{
		if ( item.grxIndex == grxIdx )
			return true
	}
	return false
}



bool function MilestoneEvent_IsMythicEventItem( ItemFlavor event, int itemIdx )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<ItemFlavor> eventItems = MilestoneEvent_GetMythicEventItems( event )
	foreach( ItemFlavor item in eventItems )
	{
		if ( item.grxIndex == itemIdx )
			return true
	}
	return false
}




bool function MilestoneEvent_EventAwardsArtifact( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<ItemFlavor> eventItems = MilestoneEvent_GetMythicEventItems( event )
	foreach( ItemFlavor item in eventItems )
	{
		if ( ItemFlavor_GetType( item ) > eItemType.artifact_component_START && ItemFlavor_GetType( item ) < eItemType.artifact_component_END )
			return true
	}
	return false
}




bool function MilestoneEvent_IsMilestoneGrantReward( ItemFlavor event, int itemIdx )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	array<MilestoneEventGrantReward> rewards = MilestoneEvent_GetMilestoneGrantRewards( event, GRX_IsOfferRestricted() )
	foreach( MilestoneEventGrantReward reward in rewards )
	{
		if ( ItemFlavor_GetGRXIndex( reward.rewardFlav ) == itemIdx )
			return true
	}
	return false
}



array<GRXScriptOffer> ornull function MilestoneEvent_GetPackOffers( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	if ( GRX_IsOfferRestricted() )
		return null

	ItemFlavor packFlav          = MilestoneEvent_GetMainPackFlav( event )
	string offerLocation         = MilestoneEvent_GetFrontPageGRXOfferLocation( event, GRX_IsOfferRestricted() )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( packFlav, offerLocation )
	offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ){
		if ( a.items[0].itemQuantity > b.items[0].itemQuantity )
			return 1
		else if (  a.items[0].itemQuantity < b.items[0].itemQuantity )
			return -1
		return 0
	} )
	return offers.len() > 0 ? offers : null
}



int function MilestoneEvent_GetCurrentMaxEventPackPurchaseCount( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	
	




		if ( MilestoneEvent_GetPackOffers( event ) == null )
			return 0



	ItemFlavor packFlav = MilestoneEvent_GetMainPackFlav( event )



		int ownedPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) )


	return HeirloomEvent_GetCurrentRemainingItemCount( event, player ) - ownedPackCount
}



bool function MilestoneEvent_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "enable_milestone_event", true )
}



void function ServerCallback_MilestoneEvent_MilestoneRewardCeremonyIsDue()
{
	fileLevel.milestoneEvents_MilestoneRewardCeremonyDue = true
}



void function MilestoneEvent_TryDisplayMilestoneRewardCeremony()
{
	if ( MilestoneEvent_IsMilestoneRewardCeremonyDue() )
	{
		MilestoneEvent_MoveToLobbyForMilestoneRewardCeremony()
	}
}



void function ServerCallback_MilestoneEvent_TryDisplayMilestoneRewardCeremonyForAutoOpenPacks()
{
	if ( GetActiveMenu() != GetMenu( "LootBoxOpen" ) )
	{
		MilestoneEvent_TryDisplayMilestoneRewardCeremony()
	}
}



void function MilestoneEvent_SetMilestoneRewardCeremonyDue( bool isDue )
{
	fileLevel.milestoneEvents_MilestoneRewardCeremonyDue = isDue
}



bool function MilestoneEvent_IsMilestoneRewardCeremonyDue()
{
	return fileLevel.milestoneEvents_MilestoneRewardCeremonyDue
}



void function MilestoneEvent_MoveToLobbyForMilestoneRewardCeremony()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )

	ActivateTabPrev( lobbyTabData )
}



void function MilestoneEvent_TryMoveToMilestonePostRewardCeremony( array<BattlePassReward> awards )
{
	if ( !IsConnected() )
		return

	ItemFlavor ornull milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( milestoneEvent != null )
	{
		expect ItemFlavor( milestoneEvent )

		foreach ( BattlePassReward reward in awards )
		{
			if ( MilestoneEvent_IsMilestoneGrantReward( milestoneEvent, ItemFlavor_GetGRXIndex( reward.flav ) ) )
			{
				EventsPanel_SetOpenPageIndex( eEventsPanelPage.MILESTONES )
				JumpToEventTab( "RTKEventsPanel" )
				return
			}
		}
	}
}



array<RTKPurchasePackRowRatesInfo> function MilestoneEvent_GetEventItemRatesData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<RTKPurchasePackRowRatesInfo> rowsData
	foreach ( var rowBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "eventMilestonePackRatesRows" ) )
	{
		RTKPurchasePackRowRatesInfo row
		foreach ( var rateBlock in IterateSettingsArray( GetSettingsBlockArray( rowBlock, "eventMilestoneQualityRates" ) ) )
		{
			RTKPurchasePackRateInfo rate
			rate.quality = eRarityTier[GetSettingsBlockString( rateBlock, "quality" )]
			rate.title = Localize( ItemQuality_GetQualityName( rate.quality ) ).toupper()
			rate.rate = GetSettingsBlockString( rateBlock, "eventMilestoneItemRate" )
			row.rates.append( rate )
		}
		rowsData.append( row )
	}
	return rowsData
}



array<RTKPurchasePackRowRatesInfo> function MilestoneEvent_GetStandardItemRatesData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<RTKPurchasePackRowRatesInfo> rowsData
	foreach ( var rowBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "standardMilestonePackRatesRows" ) )
	{
		RTKPurchasePackRowRatesInfo row
		foreach ( var rateBlock in IterateSettingsArray( GetSettingsBlockArray( rowBlock, "standardMilestoneQualityRates" ) ) )
		{
			RTKPurchasePackRateInfo rate
			rate.quality = eRarityTier[GetSettingsBlockString( rateBlock, "quality" )]
			rate.title = Localize( ItemQuality_GetQualityName( rate.quality ) ).toupper()
			rate.rate = GetSettingsBlockString( rateBlock, "standardMilestoneItemRate" )
			row.rates.append( rate )
		}
		rowsData.append( row )
	}
	return rowsData
}



array<RTKPurchasePackRowRatesInfo> function MilestoneEvent_GetMultiItemRatesData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<RTKPurchasePackRowRatesInfo> rowsData
	foreach ( var rowBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "multiMilestonePackRatesRows" ) )
	{
		RTKPurchasePackRowRatesInfo row
		foreach ( var rateBlock in IterateSettingsArray( GetSettingsBlockArray( rowBlock, "multiMilestoneQualityRates" ) ) )
		{
			RTKPurchasePackRateInfo rate
			rate.quality = eRarityTier[GetSettingsBlockString( rateBlock, "quality" )]
			rate.rate = GetSettingsBlockString( rateBlock, "multiMilestoneItemRate" )
			rate.title = rate.rate == "" ? GetSettingsBlockString( rateBlock, "multiMilestoneItemInfo" ) : Localize( ItemQuality_GetQualityName( rate.quality ) ).toupper()

			row.rates.append( rate )
		}
		rowsData.append( row )
	}
	return rowsData
}



RTKPurchasePackRowPriceInfo function MilestoneEvent_GetPricePackRangesData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	RTKPurchasePackRowPriceInfo rowData
	string originalPrice = GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "milestonePackOriginalPrice" )
	string craftingPrice = GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "milestonePackCraftingPrice" )


	var assetBlock       = GetSettingsBlockForAsset( ItemFlavor_GetAsset( event ) )
	var arr              = GetSettingsBlockArray( assetBlock, "milestonePackPrices" )
	int arraySize        = GetSettingsArraySize( arr )
	float alphaFraction  = arraySize == 1 ? 1.0 : 1.0/(arraySize - 1 )

	int i = 0
	foreach ( var priceBlock in IterateSettingsArray( arr ) )
	{
		RTKPurchasePackPriceInfo price
		price.title = GetSettingsBlockString( priceBlock, "milestonePackTitleRange" )
		price.discount = GetSettingsBlockString( priceBlock, "milestonePackDiscount" )
		price.price = GetSettingsBlockString( priceBlock, "milestonePackPrice" )
		price.originalPrice = originalPrice
		price.craftingPrice = craftingPrice
		price.discountBGAlpha = 1 - (alphaFraction * i)
		rowData.prices.append( price )
		i++
	}
	return rowData
}



array<RTKPurchasePackInformationLines> function MilestoneEvent_GetLegalTextData( ItemFlavor event )
{
	const int NUMBER_OF_SIDES = 2 
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )

	array<RTKPurchasePackInformationLines> linesData
	for ( int i = 1; i <= NUMBER_OF_SIDES; i++ )
	{
		RTKPurchasePackInformationLines lineSide
		bool isRight = i == NUMBER_OF_SIDES
		foreach ( var linesBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), isRight ? "milestonePackRightInfoText" : "milestonePackLeftInfoText" ) )
		{
			lineSide.text.append( GetSettingsBlockString( linesBlock, "milestonePackLegalText" ) )
		}
		linesData.append( lineSide )
	}
	return linesData
}


string function MilestoneEvent_GetGuaranteedPackText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_milestone )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "milestoneGuaranteedPackText" )
}















































































































