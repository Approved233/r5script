
global function RTKEventsPrizeTrackerPanel_OnInitialize
global function RTKEventsPrizeTrackerPanel_OnDestroy
global function RTKEventsPrizeTrackerPanel_UpdatePresentationModel

global struct RTKEventsPrizeTrackerPanel_Properties
{
	rtk_panel rewardsContainer
	rtk_panel viewChallengesButton
	rtk_panel chaseItem
}

global struct RTKEventsPrizeTracker_Model
{
}

global struct RTKEventsPrizeTrackerTitle_Model
{
	string headerText = ""
	string subheaderText = ""
	asset eventIcon = $""
	asset bgImage = $""
	asset bgBlurImage = $""
	int endTime = 0
	bool bgBlur = false
	float bgDarkening = 0
	vector headerTextColor = <0,0,0>
	vector subheaderTextColor = <0,0,0>
	vector timeRemainingTextColor = <0,0,0>
}

global struct RTKEventsPrizeTrackerBadge_Model
{
	asset badgeRuiAsset = $""
	asset imageAsset = $""
	asset lockAsset = $""
	asset checkmarkAsset = $""
	asset lockedBG = $""
	asset ownedBG = $""
	asset badgeBorder = $""
	asset badgeTagBG = $""
	int   tier = 0
	string badgeTitle = ""
	string badgeDescription = ""
	string badgeAdditionalText = ""
	string badgeActionText = ""
	bool isOwned = false
	vector ownedBGColor = <1,1,1>
}

global struct RTKEventsPrizeTrackerBadgePanel_Model
{
	array<RTKEventsPrizeTrackerBadge_Model> badges

	string pointsLabelText = ""
	string badgesLabelText = ""
	string eventDescriptionText = ""
	string badgesOwned = ""
	string badgesAvailable = ""
	asset bgImage = $""
}

global struct RTKEventsPrizeTrackerRewardItem_Model
{
	bool isOwned = false
	bool isBottomText = false
	bool isLeftText = false
	asset unownedAsset = $""
	asset ownedAsset = $""
	asset rewardAsset = $""
	asset dividerAsset = $""
	int prefabIndex = 0
	int rarityTier = 0
	string rewardText = ""
	string rewardDescription = ""
	string rewardTitle = ""
	string rewardActionText = ""
	string rewardAdditionalText = ""
	vector checkMarkColor = <1,1,1>
}

global struct RTKEventsPrizeTrackerProgressPip_Model
{
	float progress = 0.0
	string pointsRequired = ""
	int width = 110
	bool doubleSided = false
}

global struct RTKEventsPrizeTrackerRewardPanel_Model
{
	string rewardsLabelText = ""
	string rewardsOwned = ""
	string rewardsAvailable = ""
	string pointsAcquired = ""
	string pointsAvailable = ""
	int startPageIndex = 0

	array<RTKEventsPrizeTrackerRewardItem_Model> rewards
	array<RTKEventsPrizeTrackerProgressPip_Model> progressBars
}

global struct RTKEventsPrizeTrackerChaseItem_Model
{
	string finalRewardText = ""
	string completeText = ""
	asset chaseItemIcon = $""
	asset chaseItemBG = $""
	bool chaseItemOwned = false
}

global struct RTKEventsPrizeTrackerItemInfo_Model
{
	string name = ""
	string itemTypeDescription = ""
	int quality = 0
}

struct RewardInfo
{
	ItemFlavor& rewardFlav
	int qty = 0
	int badgeTier = 0
	bool isOwned = false
	bool isDivider = false
	string itemName = ""
	string itemRarity = ""
	string itemDescription = ""
}

struct PrivateData
{
	ItemFlavor ornull activeEvent = null
	rtk_behavior self
	array<RewardInfo> rewardInfoList

	int rewardIconWidth = 0
	int rewardSpacing = 0
	int rewardDividerWidth = 0

	BuffetEventModesAndChallengesData& bemacd
}

struct
{
	RewardInfo& chaseReward
	rtk_struct prizeTracker = null
} file

const string RTK_PRIZE_TRACK_EVENT_MODEL_NAME = "prizeTrackEvent"

void function RTKEventsPrizeTrackerPanel_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	GetActiveBuffetEvent( self )
	BuildDataModel( self )

	SetupRewardButtons( self )
	SetupViewChallengesButton( self )
	SetupChaseItemButtons( self )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, RTK_PRIZE_TRACK_EVENT_MODEL_NAME, true ) )

	
	RTKEventsPrizeTrackerItemInfo_Model chaseRewardModel
	chaseRewardModel.quality = ItemFlavor_GetQuality( file.chaseReward.rewardFlav )
	chaseRewardModel.itemTypeDescription = file.chaseReward.itemDescription
	chaseRewardModel.name = file.chaseReward.itemName
	BuildItemPanelModel( chaseRewardModel )
}

void function RTKEventsPrizeTrackerPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, RTK_PRIZE_TRACK_EVENT_MODEL_NAME )
	file.prizeTracker = null
}


void function GetActiveBuffetEvent( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	array<ItemFlavor> events = GetActiveBuffetEventArray( GetUnixTimestamp() )

	if ( events.len() == 0 )
	{
		foreach ( string cat, int idx in eChallengeCategory )
		{
			if ( ! IsEventCategory( idx ) )
				continue

			ItemFlavor ornull activeBuffet = GetActiveBuffetEventForCategory( GetUnixTimestamp(), idx )
			if ( activeBuffet != null )
				events.append( expect ItemFlavor( activeBuffet ) )
		}
	}

	if ( events.len() > 0 )
	{
		p.activeEvent = events[0]
	}
}

void function BuildDataModel( rtk_behavior self )
{
	const string RTK_PRIZE_TRACK_EVENT_STRUCT_NAME = "RTKEventsPrizeTracker_Model"

	PrivateData p
	self.Private( p )

	file.prizeTracker = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, RTK_PRIZE_TRACK_EVENT_MODEL_NAME, RTK_PRIZE_TRACK_EVENT_STRUCT_NAME )

	ItemFlavor ornull event = p.activeEvent
	expect ItemFlavor(event)

	p.bemacd = BuffetEvent_GetModesAndChallengesData( event )

	BuildEventsPrizeTrackerTitleDataModel( self )
	BuildEventPrizeTrackerBadgePanelDataModel( self )
	BuildEventsPrizeTrackerRewardsPanelDataModel( self )
	BuildChaseItemModel( self )
	RTKEventsPrizeTrackerItemInfo_Model  itemPanel
	BuildItemPanelModel( itemPanel )
}

void function BuildEventsPrizeTrackerTitleDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.activeEvent != null )
	{
		ItemFlavor ornull event = p.activeEvent
		expect ItemFlavor( event )

		RTKEventsPrizeTrackerTitle_Model titleModel
		titleModel.headerText = BuffetEvent_GetString( event, UI_TITLE_HEADER_ID )
		titleModel.subheaderText = BuffetEvent_GetString( event, UI_TITLE_SUBHEADER_ID )
		titleModel.eventIcon = BuffetEvent_GetAsset( event, UI_TITLE_MAIN_ICON_ID )
		titleModel.bgBlur = BuffetEvent_GetBool( event,  UI_TITLE_USE_BG_BLUR_ID )
		titleModel.bgBlurImage = BuffetEvent_GetAsset( event, UI_TITLE_BG_BLUR_IMAGE_ID )
		titleModel.bgDarkening = BuffetEvent_GetFloat( event,  UI_TITLE_BG_BLUR_DARKENING_ID )
		titleModel.bgImage = BuffetEvent_GetAsset( event, UI_TITLE_BG_IMAGE_ID )
		titleModel.headerTextColor = BuffetEvent_GetVector( event, UI_TITLE_HEADER_COLOR_ID )
		titleModel.subheaderTextColor = BuffetEvent_GetVector( event, UI_TITLE_SUBHEADER_COLOR_ID )
		titleModel.timeRemainingTextColor = BuffetEvent_GetVector( event, UI_TITLE_TIME_REMAINING_COLOR_ID )
		titleModel.endTime = CalEvent_GetFinishUnixTime( event )

		const string TITLE_CARD_NAME = "titleCard"
		const string RTK_PRIZE_TRACK_TITLE_STRUCT_NAME = "RTKEventsPrizeTrackerTitle_Model"

		rtk_struct titleCard = RTKStruct_GetOrCreateScriptStruct( file.prizeTracker, TITLE_CARD_NAME, RTK_PRIZE_TRACK_TITLE_STRUCT_NAME )
		RTKStruct_SetValue( titleCard, titleModel )
	}
}

void function BuildEventPrizeTrackerBadgePanelDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.activeEvent != null )
	{
		ItemFlavor ornull event = p.activeEvent
		expect ItemFlavor(event)

		RTKEventsPrizeTrackerBadgePanel_Model badgePanelModel
		badgePanelModel.pointsLabelText = BuffetEvent_GetString( event, UI_BADGE_PANEL_POINTS_LABEL_ID )
		badgePanelModel.badgesLabelText = BuffetEvent_GetString( event, UI_BADGE_PANEL_BADGE_LABEL_ID )
		badgePanelModel.eventDescriptionText = BuffetEvent_GetString( event, UI_BADGE_PANEL_DESCRIPTION_LABEL_ID )
		badgePanelModel.bgImage = BuffetEvent_GetAsset( event, UI_MAIN_PANEL_BG_ID )

		int badgeCount = p.bemacd.badges.len()

		const int MAX_BADGE_COUNT = 5

		if ( badgeCount > MAX_BADGE_COUNT )
			Warning( "Buffet event defines more badges than layout can show (%d > %d)", badgeCount, MAX_BADGE_COUNT )

		badgePanelModel.badges.clear()

		entity player = GetLocalClientPlayer()
		EHI playerEHI = ToEHI( player )
		int owned = 0;

		for ( int badgeIdx = 0; badgeIdx < badgeCount; ++badgeIdx )
		{
			RTKEventsPrizeTrackerBadge_Model badgeModel
			ItemFlavor badge = p.bemacd.badges[badgeIdx].badge

			GladCardBadgeDisplayData gcbdd = GetBadgeData( playerEHI, null, 0, badge, null )

			badgeModel.badgeRuiAsset = gcbdd.ruiAsset
			badgeModel.imageAsset = gcbdd.imageAsset
			badgeModel.tier = gcbdd.dataInteger

			badgeModel.lockAsset = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_NOT_OWNED_ICON_ID )
			badgeModel.checkmarkAsset = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_OWNED_ICON_ID )

			badgeModel.lockedBG = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_NOT_OWNED_BG_ID )
			badgeModel.ownedBG = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_OWNED_BG_ID )
			badgeModel.ownedBGColor = BuffetEvent_GetVector( event, UI_BADGE_PANEL_OWNED_BG_COLOR_ID )
			badgeModel.badgeBorder = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_BAGDE_BORDER_ID )
			badgeModel.badgeTagBG = BuffetEvent_GetAsset( event, UI_BADGE_PANEL_STATE_BG_ID )

			if ( ItemFlavor_GetGRXMode( badge ) != eItemFlavorGRXMode.NONE )
			{
				
				badgeModel.isOwned = ( GRX_IsInventoryReady() && GRX_IsItemOwnedByPlayer( badge ) )
			}
			else
			{
				int currTierIdx = GetPlayerBadgeDataInteger( playerEHI, badge, 0, null )
				if ( currTierIdx >= 0 || IsEverythingUnlocked() )
					badgeModel.isOwned = true
			}

			if (badgeModel.isOwned)
				++owned;

			ToolTipData toolTipData = CreateBadgeToolTip( badge, null )

			badgeModel.badgeTitle = toolTipData.titleText
			badgeModel.badgeDescription = toolTipData.descText
			badgeModel.badgeAdditionalText = toolTipData.actionHint2
			badgeModel.badgeActionText = toolTipData.actionHint1

			badgePanelModel.badges.push( badgeModel )
		}

		badgePanelModel.badgesOwned = FormatAndLocalizeNumber( "1", float( owned ), true )
		badgePanelModel.badgesAvailable = FormatAndLocalizeNumber( "1", float( badgeCount ), true )

		const string BADGE_PANEL_NAME = "badgePanel"
		const string RTK_PRIZE_TRACK_BADGE_PANEL_STRUCT_NAME = "RTKEventsPrizeTrackerBadgePanel_Model"

		rtk_struct badgePanel = RTKStruct_GetOrCreateScriptStruct( file.prizeTracker, BADGE_PANEL_NAME, RTK_PRIZE_TRACK_BADGE_PANEL_STRUCT_NAME )
		RTKStruct_SetValue( badgePanel, badgePanelModel )
	}
}

void function BuildEventsPrizeTrackerRewardsPanelDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.activeEvent != null )
	{
		int rewardsOwned = 0
		int numRewards = 0

		ItemFlavor ornull event = p.activeEvent
		expect ItemFlavor(event)

		RTKEventsPrizeTrackerRewardPanel_Model rewardsPanelModel
		rewardsPanelModel.rewardsLabelText = BuffetEvent_GetString( event, UI_REWARDS_PANEL_REWARDS_LABEL_ID )

		if ( p.bemacd.mainChallengeFlav != null )
		{
			entity player = GetLocalClientPlayer()
			EHI playerEHI = ToEHI( player )

			ItemFlavor mainChallenge = expect ItemFlavor(p.bemacd.mainChallengeFlav)
			int tierCount            = Challenge_GetTierCount( mainChallenge )
			int activeTierIdx        = Challenge_GetCurrentTier( player, mainChallenge )
			int prevGoal			 = 0

			for ( int tierIdx = 0; tierIdx < tierCount; tierIdx++ )
			{
				bool showDiagonalWeapons                                 = false
				bool shouldUseBadgeRuis                                  = false
				int maxNumUntilCombineToPlus                             = 2
				array<ChallengeRewardDisplayData> tierRewardDisplayDatas = GetChallengeRewardDisplayData( mainChallenge, tierIdx,
					showDiagonalWeapons, shouldUseBadgeRuis, false )

				int goal = Challenge_GetGoalVal( mainChallenge, tierIdx )
				int progress = Challenge_GetProgressValue( player, mainChallenge, tierIdx )

				RTKEventsPrizeTrackerProgressPip_Model progressPip

				progressPip.pointsRequired = FormatAndLocalizeNumber( "1", float( goal ), true )

				progressPip.progress = progress == 0 ? 0.0 : float ( progress - prevGoal ) / float( goal - prevGoal )
				const int REWARD_ICON_SIZE = 60
				const int HORIZONTAL_SPACING = 16
				const int DIVIDER_SIZE = 15
				const int PIP_HORIZONTAL_SPACING = 8
				const int BUFFER = 1

				int numberOfRewardsInTier = tierRewardDisplayDatas.len()

				progressPip.width = ( tierIdx == 0 ? ( numberOfRewardsInTier * REWARD_ICON_SIZE ) + ( numberOfRewardsInTier *  HORIZONTAL_SPACING  ) + DIVIDER_SIZE : ( numberOfRewardsInTier * REWARD_ICON_SIZE ) + ( ( 1 + numberOfRewardsInTier ) * HORIZONTAL_SPACING ) + DIVIDER_SIZE + PIP_HORIZONTAL_SPACING ) - BUFFER
				progressPip.doubleSided = tierIdx != 0
				rewardsPanelModel.progressBars.push(progressPip)

				prevGoal = goal

				if ( tierIdx == activeTierIdx )
				{
					rewardsPanelModel.pointsAcquired = FormatAndLocalizeNumber( "1", float( progress ), true )
				}

				if ( tierIdx == tierCount - 1 )
				{
					rewardsPanelModel.pointsAvailable = FormatAndLocalizeNumber( "1", float( goal ), true )
				}

				int bestRarityTier = eRarityTier.NONE
				foreach ( int crddIdx, ChallengeRewardDisplayData crdd in tierRewardDisplayDatas )
				{
					RTKEventsPrizeTrackerRewardItem_Model reward

					RewardInfo rewardInfo
					rewardInfo.isOwned = tierIdx < activeTierIdx
					rewardInfo.rewardFlav = crdd.flav
					rewardInfo.qty = crdd.originalQuantity
					rewardInfo.badgeTier = crdd.badgeTier

					bestRarityTier = maxint( bestRarityTier, crdd.rarityTier )

					reward.isOwned = tierIdx < activeTierIdx

					if ( reward.isOwned )
						++rewardsOwned

					reward.unownedAsset = BuffetEvent_GetAboutPageUnownedRewardBorderImage( event )
					reward.ownedAsset = BuffetEvent_GetAboutPageOwnedRewardBorderImage( event )
					reward.rarityTier = crdd.rarityTier
					reward.rewardAsset = crdd.icon
					reward.prefabIndex = 0;
					reward.checkMarkColor = SrgbToLinear( BuffetEvent_GetAboutPageCheckMarkCol( event ) )
					if ( ItemFlavor_GetType( crdd.flav ) == eItemType.account_pack )
					{
						reward.rewardAsset = ItemFlavor_GetIcon( crdd.flav )
					}

					if ( crdd.tinyLabelText.len() > 0 )
					{
						reward.rewardText = crdd.tinyLabelText
						if ( crdd.tinyLabelPlacementStyle == eTinyLabelPlacementStyle.LEFT )
							reward.isLeftText = true
						else if ( crdd.tinyLabelPlacementStyle == eTinyLabelPlacementStyle.BOTTOM )
							reward.isBottomText = true
					}

					if ( crdd.displayQuantity > 1 )
						reward.rewardTitle = format( "%s %s", LocalizeNumber( string(crdd.displayQuantity), true ), Localize( ItemFlavor_GetLongName( crdd.flav ) ) )
					else
						reward.rewardTitle = Localize( ItemFlavor_GetLongName( crdd.flav ) )

					string itemDesc = ItemFlavor_GetShortDescription( crdd.flav )
					
					if ( ItemFlavor_GetType( crdd.flav ) == eItemType.voucher )
					{
						itemDesc = Localize( itemDesc, int( BATTLEPASS_XP_BOOST_AMOUNT * 100 ) )
					}
					else if ( itemDesc.find( "!UNLOCALIZED!" ) != -1 )
					{
						itemDesc = ""
					}
					reward.rewardDescription = itemDesc

					if ( InspectItemTypePresentationSupported( crdd.flav ) )
					{
						reward.rewardActionText = Localize( "#INSPECT_TOOLTIP" )
					}

					rewardInfo.itemName = reward.rewardTitle
					rewardInfo.itemDescription = reward.rewardDescription
					rewardInfo.itemRarity = ItemFlavor_HasQuality( crdd.flav ) ? ItemFlavor_GetQualityName( crdd.flav ) : ""

					p.rewardInfoList.push( rewardInfo )
					rewardsPanelModel.rewards.push( reward )

					++numRewards
				}

				RTKEventsPrizeTrackerRewardItem_Model divider
				divider.isOwned = true
				divider.prefabIndex = 1

				RewardInfo rewardInfo
				rewardInfo.isDivider = true
				p.rewardInfoList.push( rewardInfo )
				rewardsPanelModel.rewards.push( divider )
			}
		}

		rewardsPanelModel.rewardsAvailable = FormatAndLocalizeNumber( "1", float( numRewards ), true )
		rewardsPanelModel.rewardsOwned = FormatAndLocalizeNumber( "1", float( rewardsOwned ), true )

		int rewardIndex = rewardsOwned + 1
		if ( rewardIndex >= numRewards )
			rewardIndex = numRewards - 1

		const int NUM_REWARDS_PER_PAGE = 6
		rewardsPanelModel.startPageIndex = rewardIndex / NUM_REWARDS_PER_PAGE

		file.chaseReward = p.rewardInfoList[ p.rewardInfoList.len() - 2 ] 

		const string REWARDS_PANEL_NAME = "rewardsPanel"
		const string RTK_PRIZE_TRACK_REWARD_PANEL_STRUCT_NAME = "RTKEventsPrizeTrackerRewardPanel_Model"

		rtk_struct rewardsPanel = RTKStruct_GetOrCreateScriptStruct( file.prizeTracker, REWARDS_PANEL_NAME, RTK_PRIZE_TRACK_REWARD_PANEL_STRUCT_NAME )
		RTKStruct_SetValue( rewardsPanel, rewardsPanelModel )
	}
}


void function BuildChaseItemModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.activeEvent != null )
	{
		ItemFlavor ornull event = p.activeEvent
		expect ItemFlavor(event)


		RTKEventsPrizeTrackerChaseItem_Model chaseItem
		chaseItem.finalRewardText   = BuffetEvent_GetString( event, UI_CHASE_ITEM_FINAL_REWARDS_LABEL_ID )
		chaseItem.completeText   = BuffetEvent_GetString( event, UI_CHASE_ITEM_COMPLETEDLABEL_ID )
		chaseItem.chaseItemBG       = BuffetEvent_GetAsset( event, UI_CHASE_ITEM_CHASE_ITEM_BG_ID )
		chaseItem.chaseItemIcon = BuffetEvent_GetAsset( event, UI_CHASE_ITEM_CHASE_ITEM_ID )

		if ( p.bemacd.mainChallengeFlav != null )
		{
			entity player = GetLocalClientPlayer()

			ItemFlavor mainChallenge = expect ItemFlavor(p.bemacd.mainChallengeFlav)
			int tierCount            = Challenge_GetTierCount( mainChallenge )
			int activeTierIdx        = Challenge_GetCurrentTier( player, mainChallenge )
			chaseItem.chaseItemOwned = activeTierIdx == ( tierCount - 1 )
		}

		const string CHASE_PANEL_NAME = "chasePanel"
		const string RTK_PRIZE_TRACK_CHASE_PANEL_STRUCT_NAME = "RTKEventsPrizeTrackerChaseItem_Model"

		rtk_struct chaseItemModel = RTKStruct_GetOrCreateScriptStruct( file.prizeTracker, CHASE_PANEL_NAME, RTK_PRIZE_TRACK_CHASE_PANEL_STRUCT_NAME )
		RTKStruct_SetValue( chaseItemModel, chaseItem )
	}
}

void function BuildItemPanelModel( RTKEventsPrizeTrackerItemInfo_Model itemPanel )
{
	const string ITEM_PANEL_NAME = "itemPanel"
	const string RTK_PRIZE_TRACK_ITEM_PANEL_STRUCT_NAME = "RTKEventsPrizeTrackerItemInfo_Model"

	rtk_struct itemPanelModel = RTKStruct_GetOrCreateScriptStruct( file.prizeTracker, ITEM_PANEL_NAME, RTK_PRIZE_TRACK_ITEM_PANEL_STRUCT_NAME )
	RTKStruct_SetValue( itemPanelModel, itemPanel )
}



void function SetupRewardButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_panel ornull rewardsContainer = self.PropGetPanel( "rewardsContainer" )

	array<RewardInfo> rewardInfoList = p.rewardInfoList

	if ( rewardsContainer != null )
	{
		expect rtk_panel( rewardsContainer )

		self.AutoSubscribe( rewardsContainer, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, rewardInfoList ) {
			rtk_behavior button = newChild.FindBehaviorInDescendantsByTypeName( "Button" )
			{
				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex, rewardInfoList ) {
					RewardInfo rewardInfo = rewardInfoList[newChildIndex]

					if ( rewardInfo.isDivider )
						return

					OnRewardButtonHighlight( self, rewardInfo )
				} )


				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, rewardInfoList ) {
					RewardInfo rewardInfo = rewardInfoList[newChildIndex]
					OnRewardButtonPressed( self, rewardInfo )
				} )
			}
		} )
	}
	else
	{
		Warning("RTKCollectionEventPanel: No Grid buttons")
	}
}


void function SetupViewChallengesButton( rtk_behavior self )
{
	rtk_panel ornull viewChallengesButton = self.PropGetPanel( "viewChallengesButton" )

	if ( viewChallengesButton != null )
	{
		expect rtk_panel( viewChallengesButton )
		array< rtk_behavior > buttons = viewChallengesButton.FindBehaviorsByTypeName( "Button" )

		foreach ( button in buttons )
		{
			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) {

				JumpToChallenges( "SAID01140881451" ) 
			} )
		}
	}
}

void function SetupChaseItemButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_panel ornull chaseItem = self.PropGetPanel( "chaseItem" )

	RewardInfo chaseReward = file.chaseReward

	if ( chaseItem != null )
	{
		expect rtk_panel( chaseItem )

		array< rtk_behavior > buttons = chaseItem.FindBehaviorsByTypeName( "Button" )

		foreach ( button in buttons  )
		{
			self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, chaseReward ) {
				OnRewardButtonHighlight( self, chaseReward  )
			} )

			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, chaseReward ) {
				OnRewardButtonPressed( self, chaseReward )
			} )
		}
	}
	else
	{
		Warning("RTKCollectionEventPanel: No Grid buttons")
	}
}


void function OnRewardButtonHighlight( rtk_behavior self, RewardInfo rewardInfo )
{
	if ( IsValidItemFlavorGUID( ItemFlavor_GetGUID( rewardInfo.rewardFlav ) ) )
	{
		RTKEventsPrizeTrackerPanel_UpdatePresentationModel( rewardInfo.rewardFlav, rewardInfo.itemName, rewardInfo.itemDescription )
	}
}

void function RTKEventsPrizeTrackerPanel_UpdatePresentationModel( ItemFlavor ornull rewardFlav = null, string itemName = "", string itemDescription = "" )
{
	if ( rewardFlav == null )
	{
		rewardFlav = file.chaseReward.rewardFlav
		itemName = file.chaseReward.itemName
		itemDescription = file.chaseReward.itemDescription
	}

	RTKEventsPrizeTrackerItemInfo_Model presentationItem
	presentationItem.quality = ItemFlavor_GetQuality( expect ItemFlavor( rewardFlav ) )
	presentationItem.name = itemName
	presentationItem.itemTypeDescription = itemDescription
	BuildItemPanelModel( presentationItem )

	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( expect ItemFlavor( rewardFlav ) ) , -1, 1.19, Battlepass_ShouldShowLow( expect ItemFlavor( rewardFlav ) ), null, false, "collection_event_ref", false, false, false, false, <35, 0, 0> )
}

void function OnRewardButtonPressed( rtk_behavior self, RewardInfo rewardInfo )
{
	PrivateData p
	self.Private( p )

	if ( !InspectItemTypePresentationSupported( rewardInfo.rewardFlav ) )
		return

	ItemFlavor ornull event = p.activeEvent
	expect ItemFlavor(event)

	SetChallengeRewardPresentationModeActive( rewardInfo.rewardFlav, rewardInfo.qty, rewardInfo.badgeTier,
		"#CHALLENGE_REWARD",
		ItemFlavor_GetShortName( event ),
		rewardInfo.isOwned )
}

      