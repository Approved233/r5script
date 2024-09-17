global function InitBattlepassMilestoneMenu
global function IsBattlepassMilestoneEnabled
global function IsBattlepassMilestoneMenuOpened


global function OpenBattlePassMilestoneDialog


enum ePassMilestoneTab
{
	INVALID = -1,
	PREMIUM = 0,
	ULTIMATE = 1,
	ULTIMATE_PLUS = 2,
}

struct {
	var menu

	var awardHeader
	var awardPanel
	var awardHeaderText
	var awardDescText
	var instantGrantsText

	var purchaseButton
	var continueButton
	var premiumToggleButton
	var ultimateToggleButton
	var ultimatePlusToggleButton

	var rep2DImage

	bool isOpened = false
	bool isShowingImagePremium = false
	bool isShowingImageUltimate = false
	bool isShowingImageUltimatePlus = false

	array<BattlePassReward> displayRewards = []
	table<var, BattlePassReward> buttonToItem
	array<int> rewardsClicked
	array<int> tierRepLevels
	array<int> bundleRepLevels
	array<int> ultPlusRepLevels

	array<int> milestones
	int milestoneIndex
	int currentBPLevel = 0

	var discountPanel
	var taxNoticeMessage

	int tabIndex = ePassMilestoneTab.INVALID
}file

void function InitBattlepassMilestoneMenu( var newMenuArg )
{
	file.menu = newMenuArg

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, BattlepassMilestoneMenu_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, BattlepassMilestoneMenu_OnClose )

	file.awardHeader     	= Hud_GetChild( file.menu, "Header" )
	file.awardPanel      	= Hud_GetChild( file.menu, "AwardsList" )
	file.awardHeaderText 	= Hud_GetChild( file.menu, "AwardsHeaderText" )
	file.awardDescText   	= Hud_GetChild( file.menu, "AwardsDescText" )
	file.instantGrantsText  = Hud_GetChild( file.menu, "InstantGrantsText" )
	file.rep2DImage      	= Hud_GetChild( file.menu, "Rep2DImage" )

	file.purchaseButton      = Hud_GetChild( file.menu, "PassPurchaseButton" )
	file.continueButton      = Hud_GetChild( file.menu, "ContinueButton" )
	file.premiumToggleButton = Hud_GetChild( file.menu, "LeftToggleButton" )
	file.ultimateToggleButton = Hud_GetChild( file.menu, "MiddleToggleButton" )
	file.ultimatePlusToggleButton  = Hud_GetChild( file.menu, "RightToggleButton" )

	file.discountPanel	  = Hud_GetChild( file.menu, "DiscountPanel" )
	if ( Script_UserHasEAAccess() )
		Hud_Show( file.discountPanel )
	else
		Hud_Hide( file.discountPanel )







	AddButtonEventHandler( file.purchaseButton, UIE_CLICK, PurchaseButton_OnClick )
	AddButtonEventHandler( file.continueButton, UIE_CLICK, ContinueButton_OnClick )
	AddButtonEventHandler( file.premiumToggleButton, UIE_GET_FOCUS, PremiumButton_OnFocused )
	AddButtonEventHandler( file.premiumToggleButton, UIE_CLICK, (void function( var button ) : () { SetActiveTab( ePassMilestoneTab.PREMIUM ) }) )
	AddButtonEventHandler( file.ultimateToggleButton, UIE_GET_FOCUS, UltimateButton_OnFocused )
	AddButtonEventHandler( file.ultimateToggleButton, UIE_CLICK, (void function( var button ) : () { SetActiveTab( ePassMilestoneTab.ULTIMATE ) }) )
	AddButtonEventHandler( file.ultimatePlusToggleButton, UIE_GET_FOCUS, UltimatePlusButton_OnFocused )
	AddButtonEventHandler( file.ultimatePlusToggleButton, UIE_CLICK, (void function( var button ) : () { SetActiveTab( ePassMilestoneTab.ULTIMATE_PLUS ) }) )
}

void function BattlepassMilestoneMenu_OnOpen()
{
	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "ScreenFrame" ), true )

	ItemFlavor ornull activeBattlePass = GetActiveBattlePassV2()
	if ( activeBattlePass == null || !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	expect ItemFlavor( activeBattlePass )

	HudElem_SetRuiArg( file.awardHeader, "titleText", "#BP_MILESTONE_HEADER_TITLE" )
	HudElem_SetRuiArg( file.awardHeader, "descText", "#BP_MILESTONE_HEADER_DESC" )
	HudElem_SetRuiArg( file.awardHeaderText, "textString", "#BP_MILESTONE_AWARDS_HEADER" )
	HudElem_SetRuiArg( file.awardHeaderText, "isTitleFont", true )
	HudElem_SetRuiArg( file.awardDescText, "textString", "#BP_MILESTONE_AWARDS_DESC_PREMIUM" )
	Hud_SetVisible( file.instantGrantsText, false)

	HudElem_SetRuiArg( file.purchaseButton, "buttonText", "#BP_MILESTONE_PURCHASE_BUTTON" )
	HudElem_SetRuiArg( file.purchaseButton, "buttonDescText",
		file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? "#BP_MILESTONE_TOGGLE_ULTIMATE_PLUS"
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? "#BP_MILESTONE_TOGGLE_ULTIMATE"
		: "#BP_MILESTONE_TOGGLE_PREMIUM"
	)
	HudElem_SetRuiArg( file.purchaseButton, "buttonPriceText", " %$rui/menu/common/currency_premium%" + " 9999" )

	HudElem_SetRuiArg( file.continueButton, "buttonText", "#B_BUTTON_CLOSE" )
	HudElem_SetRuiArg( file.continueButton, "processingState", 1 )

	bool isRestricted = GRX_IsOfferRestricted( GetLocalClientPlayer() )
	if ( isRestricted )
	{
		Hud_SetWidth( file.premiumToggleButton, 380 )
		Hud_SetX( file.premiumToggleButton, 0 )
		HudElem_SetRuiArg( file.premiumToggleButton, "buttonText", "#BP_MILESTONE_TOGGLE_PREMIUM_LONG" )
	}
	else
	{
		HudElem_SetRuiArg( file.premiumToggleButton, "buttonText", "#BP_MILESTONE_TOGGLE_PREMIUM" )
	}

	HudElem_SetRuiArg( file.ultimateToggleButton, "buttonText", "#BP_MILESTONE_TOGGLE_ULTIMATE" )
	Hud_SetEnabled( file.ultimateToggleButton, !isRestricted )
	Hud_SetVisible( file.ultimateToggleButton, !isRestricted )
	HudElem_SetRuiArg( file.ultimatePlusToggleButton, "buttonText", "#BP_MILESTONE_TOGGLE_ULTIMATE_PLUS" )
	Hud_SetEnabled( file.ultimateToggleButton, !isRestricted )
	Hud_SetVisible( file.ultimatePlusToggleButton, !isRestricted )

	if ( !isRestricted )
	{
		HudElem_SetRuiArg( Hud_GetChild( file.menu, "LeftToggleIndicator" ), "textString", "#BP_MILESTONE_TOGGLE_INDICATOR_LEFT" )
		HudElem_SetRuiArg( Hud_GetChild( file.menu, "RightToggleIndicator" ), "textString", "#BP_MILESTONE_TOGGLE_INDICATOR_RIGHT" )
	}

	HudElem_SetRuiArg( file.rep2DImage, "purchaseDisclaimer", "#BP_MILESTONE_PURCHASE_DISCLAIMER" )

	RuiSetImage( Hud_GetRui( file.rep2DImage ), "tierRepImage", GetGlobalSettingsAsset( ItemFlavor_GetAsset( activeBattlePass ), "milestoneTierRepImage" ) ) 
	RuiSetImage( Hud_GetRui( file.rep2DImage ), "bundleRepImage", GetGlobalSettingsAsset( ItemFlavor_GetAsset( activeBattlePass ), "milestoneTierRepImage" ) ) 
	RuiSetImage( Hud_GetRui( file.rep2DImage ), "ultPlusRepImage", GetGlobalSettingsAsset( ItemFlavor_GetAsset( activeBattlePass ), "milestoneBundleRepImage" ) ) 

	file.tierRepLevels = GetMilestoneRepImageLevelArray( activeBattlePass, "milestoneTierRepLevels", "tierRepLevels" ) 
	file.bundleRepLevels = GetMilestoneRepImageLevelArray( activeBattlePass, "milestoneTierRepLevels", "tierRepLevels" ) 
	file.ultPlusRepLevels = GetMilestoneRepImageLevelArray( activeBattlePass, "milestoneBundleRepLevels", "bundleRepLevels" ) 

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, NavigateTabLeft )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, NavigateTabRight )

	file.isOpened = true
	file.milestoneIndex  = 0

	var dataTable   = BattlePass_GetMilestoneDatatable( activeBattlePass )
	int numRows     = GetDataTableRowCount( dataTable )
	int levelColumn = GetDataTableColumnByName( dataTable, "milestone_level" )

	entity player 		  = GetLocalClientPlayer()
	int currentXPProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	file.currentBPLevel   = GetBattlePassLevelForXP( activeBattlePass, currentXPProgress )

	for ( int i = 0; i < numRows; i++ )
	{
		file.milestones.append( GetDataTableInt( dataTable, i, levelColumn ) - 1 ) 

		if ( file.milestones[ i ] <= file.currentBPLevel )
			file.milestoneIndex = i
	}

	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	BattlepassMilestone_UpdatePurchaseButtons()
	BattlepassMilestoneMenu_Update( file.currentBPLevel )
}

void function BattlepassMilestoneMenu_Update( int level )
{
	const int BUTTON_OFFSET = 12
	int targetLevel = level
	entity player = GetLocalClientPlayer()

	int bpRewardTier = file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? eBattlePassV2RewardTier.ELITE
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? eBattlePassV2RewardTier.PREMIUM
		: eBattlePassV2RewardTier.PREMIUM 
	ItemFlavor activeBattlePass = expect ItemFlavor( GetActiveBattlePassV2() )
	file.displayRewards = GetBattlePassV2Rewards( activeBattlePass, level, bpRewardTier, player, true )

	HudElem_SetRuiArg( file.awardHeader, "level", level + 1 )
	file.displayRewards.sort( SortByQuality )
	AddUpStackableRewards( file.displayRewards )

	var scrollPanel = Hud_GetChild( file.awardPanel, "ScrollPanel" )
	foreach ( button, _ in file.buttonToItem )
	{
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, PassAwardButton_OnGetFocus )
		Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, PassAwardButton_OnLoseFocus )
	}
	file.buttonToItem.clear()
	file.rewardsClicked.clear()

	int numAwards = file.displayRewards.len()
	int numButtons = numAwards
	bool showButtons = true

	file.rewardsClicked.resize( numButtons, 0 )

	if ( !showButtons )
	{
		numButtons = 0
		PresentItem( file.displayRewards[0].flav, file.displayRewards[0].level )
	}

	Hud_InitGridButtonsDetailed( file.awardPanel, numButtons, 1, maxint( 1, minint( numButtons, 5 ) ) )
	Hud_SetHeight( file.awardPanel, Hud_GetHeight( file.awardPanel ) * 3 + BUTTON_OFFSET )

	for ( int index = 0; index < numButtons; index++ )
	{
		var awardButton = Hud_GetChild( scrollPanel, "GridButton" + index )

		BattlePassReward bpReward = file.displayRewards[index]
		file.buttonToItem[awardButton] <- bpReward

		HudElem_SetRuiArg( awardButton, "isOwned", false )
		HudElem_SetRuiArg( awardButton, "isPremium", bpReward.rewardTier >= eBattlePassV2RewardTier.PREMIUM )

		int rarity = ItemFlavor_HasQuality( bpReward.flav ) ? ItemFlavor_GetQuality( bpReward.flav ) : 0
		HudElem_SetRuiArg( awardButton, "itemCountString", "" )
		if ( bpReward.quantity > 1 || ItemFlavor_GetType( bpReward.flav ) == eItemType.account_currency )
		{
			rarity = 0
			HudElem_SetRuiArg( awardButton, "itemCountString", FormatAndLocalizeNumber( "1", float( bpReward.quantity ), true ) )
		}
		HudElem_SetRuiArg( awardButton, "rarity", rarity )
		RuiSetImage( Hud_GetRui( awardButton ), "buttonImage", CustomizeMenu_GetRewardButtonImage( bpReward.flav ) )

		bool isRewardLootBox = (ItemFlavor_GetType( bpReward.flav ) == eItemType.account_pack)
		HudElem_SetRuiArg( awardButton, "isLootBox", isRewardLootBox )

		BattlePass_PopulateRewardButton( bpReward, awardButton, false, false, null, true )

		Hud_AddEventHandler( awardButton, UIE_GET_FOCUS, PassAwardButton_OnGetFocus )
		Hud_AddEventHandler( awardButton, UIE_LOSE_FOCUS, PassAwardButton_OnLoseFocus )

		ToolTipData toolTip
		toolTip.titleText = GetBattlePassRewardHeaderText( bpReward )
		toolTip.descText = GetBattlePassRewardItemName( bpReward )
		toolTip.tooltipFlags = eToolTipFlag.SOLID
		toolTip.rarity = ItemFlavor_GetQuality( bpReward.flav )
		Hud_SetToolTipData( awardButton, toolTip )

		if ( index == 0 )
			PassAwardButton_OnLoseFocus( awardButton )
	}

	HudElem_SetRuiArg( file.rep2DImage, "isShowingBundleImage", file.tabIndex == ePassMilestoneTab.ULTIMATE ) 
	HudElem_SetRuiArg( file.rep2DImage, "isShowingUltPlusImage", file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS )

	HudElem_SetRuiArg( file.rep2DImage, "purchaseDisclaimer",
		file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? "#BP_MILESTONE_PURCHASE_DISCLAIMER_ULT_PLUS"
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? "#BP_MILESTONE_PURCHASE_DISCLAIMER_ULT"
		: "#BP_MILESTONE_PURCHASE_DISCLAIMER"
	)

	array<int> repLevels = file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? file.ultPlusRepLevels
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? file.bundleRepLevels
		: file.tierRepLevels

	for( int i = 0; i < repLevels.len(); i++ )
	{
		HudElem_SetRuiArg( file.rep2DImage, format( "unlockLevel%d", i ), repLevels[i].tostring() )

		if ( targetLevel >= repLevels[i] - 1 )
		{
			HudElem_SetRuiArg( file.rep2DImage, format ( "isUnlocked%d", i ), true )
		}
		else
		{
			HudElem_SetRuiArg( file.rep2DImage, format ( "isUnlocked%d", i ), false )
		}
	}
}

void function BattlepassMilestoneMenu_OnClose()
{
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, NavigateTabLeft )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, NavigateTabRight )

	foreach ( button, _ in file.buttonToItem )
	{
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, PassAwardButton_OnGetFocus )
		Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, PassAwardButton_OnLoseFocus )
	}

	ClearAwardsTooltips()
	RunClientScript( "ClearBattlePassItem" )

	array<string> rewardStringsForPIN = GetRewardStringsForPIN();

	PIN_BattlepassMilestonePageView (
		GetLastMenuIDForPIN(),
		UITime() - uiGlobal.menuData[file.menu].enterTime,
		file.milestones[file.milestoneIndex] + 1,
		false, 
		rewardStringsForPIN,
		file.tabIndex
	)

	file.isOpened = false
	file.displayRewards = []
	file.rewardsClicked = []
	file.buttonToItem.clear()
	file.milestones.clear()
}

void function PassAwardButton_OnGetFocus( var button )
{
	ItemFlavor item = file.buttonToItem[button].flav
	int level       = file.buttonToItem[button].level

	HudElem_SetRuiArg( file.rep2DImage, "isVisible", false )

	file.rewardsClicked[file.displayRewards.find( file.buttonToItem[button] )]++

	PresentItem( item, level )
}

void function PassAwardButton_OnLoseFocus( var button )
{
	HudElem_SetRuiArg( file.rep2DImage, "isVisible", true )

	RunClientScript( "ClearBattlePassItem" )
}

void function PresentItem( ItemFlavor item, int level )
{
	if ( ItemFlavor_GetType( item ) == eItemType.character )
	{
		ItemFlavor overrideSkin = GetDefaultItemFlavorForLoadoutSlot( Loadout_CharacterSkin( item ) )
		item = overrideSkin
	}

	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( item ), level, 0.95, Battlepass_ShouldShowLow( item ), Hud_GetChild( file.menu, "LoadscreenImage" ), true, "battlepass_right_ref", false, false, true )
}

void function BattlepassMilestone_UpdatePurchaseButtons()
{
	entity player = GetLocalClientPlayer()
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePassV2( ToEHI( player ) )

	if ( activeBattlePass == null || !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		Hud_SetEnabled( file.purchaseButton, false )
		Hud_SetVisible( file.purchaseButton, false )
		return
	}

	expect ItemFlavor( activeBattlePass )

	GRXScriptOffer ornull purchaseOffer = null

	HudElem_SetRuiArg( file.awardDescText, "textString", "#BP_MILESTONE_AWARDS_DESC_PREMIUM" )
	Hud_SetText( file.instantGrantsText,
		file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? "#BP_MILESTONE_INSTANT_GRANT_DESC_ULT_PLUS"
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? "#BP_MILESTONE_INSTANT_GRANT_DESC_ULT"
		: ""
	)
	Hud_SetVisible( file.instantGrantsText, file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS || file.tabIndex == ePassMilestoneTab.ULTIMATE )

	HudElem_SetRuiArg( file.premiumToggleButton, "isSelected", file.tabIndex == ePassMilestoneTab.PREMIUM )
	HudElem_SetRuiArg( file.ultimateToggleButton, "isSelected", file.tabIndex == ePassMilestoneTab.ULTIMATE )
	HudElem_SetRuiArg( file.ultimatePlusToggleButton, "isSelected", file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS )

	HudElem_SetRuiArg( file.purchaseButton, "buttonDescText",
		file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS ? "#BP_MILESTONE_TOGGLE_ULTIMATE_PLUS"
		: file.tabIndex == ePassMilestoneTab.ULTIMATE ? "#BP_MILESTONE_TOGGLE_ULTIMATE"
		: "#BP_MILESTONE_TOGGLE_PREMIUM"
	)

	bool playerOwnsPremium = DoesPlayerOwnBattlePassTier( player, activeBattlePass, eBattlePassV2OwnershipTier.PREMIUM )
	bool playerOwnsUltimate = DoesPlayerOwnBattlePassTier( player, activeBattlePass, eBattlePassV2OwnershipTier.ULTIMATE )
	bool playerOwnsUltimatePlus = DoesPlayerOwnBattlePassTier( player, activeBattlePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS )

	if ( file.tabIndex == ePassMilestoneTab.ULTIMATE_PLUS && !playerOwnsUltimatePlus )
	{
		HudElem_SetRuiArg( file.purchaseButton, "buttonDiscountText", !Script_UserHasEAAccess() ? " " : GetEntitlementOriginalPricesAsStr( [ BattlepassGetEntitlementUltimatePlus() ] )[0] )
		HudElem_SetRuiArg( file.purchaseButton, "buttonPriceText", GetEntitlementPricesAsStr( [ BattlepassGetEntitlementUltimatePlus() ] )[0] )
		Hud_SetLocked( file.purchaseButton, false )
	}
	else if ( file.tabIndex == ePassMilestoneTab.ULTIMATE && !playerOwnsUltimate )
	{
		HudElem_SetRuiArg( file.purchaseButton, "buttonDiscountText", !Script_UserHasEAAccess() ? " " : GetEntitlementOriginalPricesAsStr( [ BattlepassGetEntitlementUltimate() ] )[0] )
		HudElem_SetRuiArg( file.purchaseButton, "buttonPriceText", GetEntitlementPricesAsStr( [ BattlepassGetEntitlementUltimate() ] )[0] )
		Hud_SetLocked( file.purchaseButton, false )
	}
	else if ( file.tabIndex == ePassMilestoneTab.PREMIUM && !playerOwnsPremium )
	{
		HudElem_SetRuiArg( file.purchaseButton, "buttonDiscountText", " ")

		array<GRXScriptOffer> purchaseOffers = GRX_GetItemDedicatedStoreOffers( activeBattlePass, "battlepass" )

		if ( purchaseOffers.len() == 1 )
		{
			purchaseOffer = purchaseOffers[0]
			expect GRXScriptOffer( purchaseOffer )
		}
		else
		{
			Assert( false, "Expected 1 offer for battlepass " + string( ItemFlavor_GetAsset( activeBattlePass ) ) )
		}

		if ( purchaseOffer != null )
		{
			expect GRXScriptOffer( purchaseOffer )
			if ( purchaseOffer.prices.len() == 1)
			{
				HudElem_SetRuiArg( file.purchaseButton, "buttonPriceText", GRX_GetFormattedPrice ( purchaseOffer.prices[0] ) )
			}
			else
			{
				Assert( false, "Expected 1 price for offer of " + purchaseOffer.offerAlias )
			}
		}

		bool isOfferPurchasable = false
		if ( purchaseOffer != null )
		{
			isOfferPurchasable = GRXOffer_IsEligibleForPurchase( expect GRXScriptOffer( purchaseOffer ) )
		}
		Hud_SetLocked( file.purchaseButton, !isOfferPurchasable )
	}
	else
	{
		Assert( false, "BattlepassMilestone_UpdatePurchaseButtons reached invalid state.")
		Hud_SetLocked( file.purchaseButton, true )
	}
}

void function NavigateTabLeft( var button )
{
	file.tabIndex--

	if ( file.tabIndex < ePassMilestoneTab.PREMIUM )
		file.tabIndex = ePassMilestoneTab.PREMIUM

	SetActiveTab( file.tabIndex )
}

void function NavigateTabRight( var button )
{
	file.tabIndex++

	if ( file.tabIndex > ePassMilestoneTab.ULTIMATE_PLUS )
		file.tabIndex = ePassMilestoneTab.ULTIMATE_PLUS

	SetActiveTab( file.tabIndex )
}

void function SetActiveTab( int tabIndex = ePassMilestoneTab.INVALID )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	if ( GRX_IsOfferRestricted( GetLocalClientPlayer() ) && tabIndex > ePassMilestoneTab.PREMIUM )
	{
		tabIndex = ePassMilestoneTab.PREMIUM
	}

	ClearAwardsTooltips()
	file.tabIndex = tabIndex
	BattlepassMilestone_UpdatePurchaseButtons()
	BattlepassMilestoneMenu_Update( file.currentBPLevel )
}

void function PremiumButton_OnFocused( var button )
{
	HudElem_SetRuiArg( file.premiumToggleButton, "isFocused", true )
}

void function UltimateButton_OnFocused( var button )
{
	HudElem_SetRuiArg( file.ultimateToggleButton, "isFocused", true )
}

void function UltimatePlusButton_OnFocused( var button )
{
	HudElem_SetRuiArg( file.ultimatePlusToggleButton, "isFocused", true )
}

void function ContinueButton_OnClick( var button )
{
	CloseActiveMenu()
}

void function PurchaseButton_OnClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	PIN_UIInteraction_OnClick( GetLastMenuIDForPIN(), Hud_GetHudName( button ) )

	
	CloseActiveMenu()
	switch ( file.tabIndex )
	{
		case ePassMilestoneTab.ULTIMATE_PLUS:
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE_PLUS )
			break

		case ePassMilestoneTab.ULTIMATE:
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE )
			break

		default:
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.PREMIUM )
	}
}

array<string> function GetRewardStringsForPIN( )
{
	const int MAX_REWARD_COUNT_FOR_PIN = 10

	array<string> result;

	for( int i = 0; i < file.rewardsClicked.len(); i++ )
	{
		if ( file.rewardsClicked[i] != 0 )
		{
			result.append( format( "%s:%d", ItemFlavor_GetHumanReadableRefForPIN_Slow( file.displayRewards[i].flav ), file.rewardsClicked[i] ) )
		}
	}

	result.sort( SortByClickedCount )

	if ( result.len() > MAX_REWARD_COUNT_FOR_PIN )
	{
		result.resize( MAX_REWARD_COUNT_FOR_PIN )
	}

	return result
}


void function AddUpStackableRewards( array<BattlePassReward> rewards )
{
	int prevType = eItemType.INVALID

	for( int i = 0; i < rewards.len(); i++ )
	{
		int currType = ItemFlavor_GetType( rewards[i].flav )

		if ( currType == prevType )
		{
			if ( currType == eItemType.account_currency )
			{
				int quantityToAdd = 0;

				for( int j = i; j < rewards.len(); )
				{
					if ( ItemFlavor_GetType( rewards[j].flav ) != prevType )
						break

					quantityToAdd += rewards[j].quantity
					rewards.remove( j )
				}

				rewards[i - 1].quantity += quantityToAdd
			}
		}

		prevType = currType
	}
}



int function SortByQuality( BattlePassReward a, BattlePassReward b )
{
	int a_quality = ItemFlavor_HasQuality( a.flav ) ? ItemFlavor_GetQuality( a.flav ) : 0
	int b_quality = ItemFlavor_HasQuality( b.flav ) ? ItemFlavor_GetQuality( b.flav ) : 0

	if ( a_quality < b_quality )
	{
		return 1
	}
	else if ( a_quality > b_quality )
	{
		return -1
	}
	else
	{
		int a_type = ItemFlavor_GetType( a.flav )
		int b_type = ItemFlavor_GetType( b.flav )

		if ( a_type == eItemType.account_currency )
		{
			return -1
		}
		else if ( b_type == eItemType.account_currency )
		{
			return 1
		}

		if ( a_type == eItemType.weapon_skin && WeaponSkin_DoesReactToKills ( a.flav ) )
		{
			return -1
		}
		else if ( b_type == eItemType.weapon_skin && WeaponSkin_DoesReactToKills ( b.flav ) )
		{
			return 1
		}

		
		if ( a_type == eItemType.skydive_emote || a_type == eItemType.skydive_trail )
		{
			a_type = eItemType.character_execution
		}

		if ( b_type == eItemType.skydive_emote || b_type == eItemType.skydive_trail )
		{
			b_type = eItemType.character_execution
		}

		if ( a_type < eItemType.character && b_type >= eItemType.character )
		{
			return 1
		}
		else if ( a_type >= eItemType.character && b_type < eItemType.character )
		{
			return -1
		}
		else
		{
			if ( a_type > b_type )
			{
				return 1
			}
			else if ( a_type < b_type )
			{
				return -1
			}
		}
	}

	return 0
}



int function SortByClickedCount( string a, string b )
{
	int a_clicked = a.slice( a.find (":", 0) + 1, a.len() ).tointeger()
	int b_clicked = b.slice( b.find (":", 0) + 1, b.len() ).tointeger()

	if ( a_clicked < b_clicked )
		return 1
	else if ( a_clicked > b_clicked )
		return -1

	return 0
}



void function ClearAwardsTooltips()
{
	var scrollPanel = Hud_GetChild( file.awardPanel, "ScrollPanel" )

	for ( int index = 0; index < file.displayRewards.len(); index++)
	{
		Hud_ClearToolTipData( Hud_GetChild( scrollPanel, "GridButton" + index ) )
	}
}



bool function IsBattlepassMilestoneEnabled()
{
	return GetConVarBool( "lobby_battlepass_milestone_enabled" )
}



bool function IsBattlepassMilestoneMenuOpened()
{
	return file.isOpened
}



bool function OpenBattlePassMilestoneDialog( bool forceShow = false, int tab = ePassMilestoneTab.PREMIUM )
{




	if ( !IsLocalClientEHIValid() )
		return false

	if ( !IsBattlepassMilestoneEnabled() || !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return false

	ItemFlavor ornull activeBattlePass = GetActiveBattlePassV2()

	if ( activeBattlePass == null )
		return false

	expect ItemFlavor( activeBattlePass )

	entity player = GetLocalClientPlayer()

	string activeBattlePassGUID = ItemFlavor_GetGUIDString( activeBattlePass )

	if ( DoesPlayerOwnBattlePassTier( player, activeBattlePass, eBattlePassV2OwnershipTier.PREMIUM ) && forceShow == false )
		return false

	int currentXPProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	int currentBPLevel    = GetBattlePassLevelForXP( activeBattlePass, currentXPProgress )

	var dataTable   = GetDataTable( $"datatable/battlepass_season_milestone.rpak" )
	int numRows     = GetDataTableRowCount( dataTable )
	int levelColumn = GetDataTableColumnByName( dataTable, "milestone_level" )

	int lastSeenMilestone = expect int( player.GetPersistentVar( format( "battlePasses[%s].lastSeenMilestone", activeBattlePassGUID ) ) )
	bool showMilestoneMenu = forceShow

	for ( int currentRow = numRows; currentRow > 0; currentRow-- )
	{
		int milestoneLevel = GetDataTableInt( dataTable, currentRow - 1, levelColumn )

		if ( currentBPLevel >= milestoneLevel - 1 )
		{
			if ( currentRow > lastSeenMilestone )
			{
				showMilestoneMenu = true
				Remote_ServerCallFunction( "ClientCallback_MarkBattlePassMilestoneAsSeen", currentRow )
				break
			}
		}
	}

	if ( showMilestoneMenu )
	{
		if ( GRX_IsOfferRestricted( GetLocalClientPlayer() ) && tab > ePassMilestoneTab.PREMIUM )
		{
			tab = ePassMilestoneTab.PREMIUM
		}

		file.tabIndex = tab

		thread function() : ( )
		{
			wait 0.2

			if ( IsLobby() && IsBattlePassEnabled() && GRX_IsInventoryReady() && GRX_AreOffersReady() )
				AdvanceMenu( GetMenu( "BattlePassMilestoneMenu" ) )

			SetActiveTab( file.tabIndex )
		}()
	}

	return showMilestoneMenu
}

