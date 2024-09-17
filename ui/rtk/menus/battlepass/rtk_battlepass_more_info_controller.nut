global function InitRTKBattlePassMoreInfoMenu
global function RTKBattlepassMoreInfo_OnInitialize
global function RTKBattlepassMoreInfo_OnDestroy
global function OpenBattlepassMoreInfo

global function BattlePassV2_TierHasInstantRewards
global function BattlePassV2_GetInstantRewardModelForTier

global struct RTKBattlepassMoreInfo_Properties
{
	rtk_behavior purchaseButton
	rtk_behavior battlepassButton
}

global struct RTKBattlepassMoreInfoRowData
{
	bool hasIcon = false
	bool hasLongText = false
	asset icon = $""
	string rowtext = "test"
}

global struct RTKBattlepassMoreInfoInstantData
{
	string packString

	array<asset> rewardIcons
	array<string> rewardStrings

	array<RTKBattlepassMoreInfoRowData> rewardRows

	bool unlockAllLegends
}

global struct RTKBattlepassMoreInfoPanelData
{
	vector panelTint = < 1, 1, 1>
	int panelWidth = 0
	asset panelBackground = $""
	asset rewardImage = $""
	int rewardImageHeight = 0
	int rewardImageWidth = 0
	int rewardImageOffsetY = 0
	int orderNumber = 0
	string description = ""
	string bottomTitle = ""
	string priceString = ""
	string originalPriceString = ""
	bool hasPrice = false
	bool hasDiscount = false
	bool hasInstantRewards = false
	bool hasUpgradeText = false
	array<RTKBattlepassMoreInfoRowData> rows
	RTKBattlepassMoreInfoInstantData &instantRewards
}

global struct RTKBattlepassMoreInfoModel
{
	asset seasonLogo = $""
	string seasonName = ""
	string timeRemainingText = ""
	vector mainColor = < 0, 0, 0>
	bool canUpgrade = false
	bool hasDiscount = false
	bool showPurchaseButton = true

	array< RTKBattlepassMoreInfoPanelData > panels
}

void function InitRTKBattlePassMoreInfoMenu( var newMenuArg )
{
	var menu = newMenuArg
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", RTKBattlepassMoreInfo_HandleBackButton)
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMenuClose )
}

void function RTKBattlepassMoreInfo_OnInitialize( rtk_behavior self )
{
	rtk_struct battlepassMoreInfoModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "bpMoreInfo", "RTKBattlepassMoreInfoModel" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "bpMoreInfo", true ) )

	ItemFlavor ornull bpFlavor = GetActiveBattlePassV2()
	if ( bpFlavor == null )
	{
		return
	}

	expect ItemFlavor( bpFlavor )

	SetupMoreInfoDataModel( battlepassMoreInfoModel, bpFlavor )
	RTKBattlepassMoreInfo_SetUpButtons(self, battlepassMoreInfoModel, bpFlavor)
}
void function RTKBattlepassMoreInfo_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "bpMoreInfo")
	SocialEventUpdate()
}

void function OpenBattlepassMoreInfo( var button )
{
	var menu = GetMenu("RTKBattlePassMoreInfoMenu")
	if ( GetActiveMenu() == menu )
		return
	AdvanceMenu( menu )
}

void function RTKBattlepassMoreInfo_HandleBackButton( var button )
{
	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}

void function OnMenuClose()
{
	if ( !IsFullyConnected() )
		return

	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}


void function RTKBattlepassMoreInfo_SetUpButtons( rtk_behavior self, rtk_struct modelStruct, ItemFlavor bpFlavor )
{
	entity LocalPlayer = GetLocalClientPlayer()
	bool hasPremiumPass = DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), bpFlavor, eBattlePassV2OwnershipTier.PREMIUM )
	bool hasUltimatePass = DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), bpFlavor, eBattlePassV2OwnershipTier.ULTIMATE )
	bool hasUltimatePlusPass = DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), bpFlavor, eBattlePassV2OwnershipTier.ULTIMATE_PLUS )
	bool isRestricted = GRX_IsOfferRestricted()
	bool canUpgrade = hasPremiumPass && !hasUltimatePlusPass && !isRestricted
	bool canPurchase = ( canUpgrade ) || ( !hasPremiumPass )
	bool userHasEAAccess = Script_UserHasEAAccess()

	RTKStruct_SetBool( modelStruct, "hasDiscount", userHasEAAccess )
	RTKStruct_SetBool( modelStruct, "canUpgrade" , canUpgrade )
	RTKStruct_SetBool( modelStruct, "showPurchaseButton" , canPurchase )

	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	if ( purchaseButton != null )
	{
		expect rtk_behavior( purchaseButton )

		self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, hasPremiumPass ) {
			PIN_UIInteraction_OnClick( "menu_rtkbattlepassmoreinfomenu", button.GetPanel().GetDisplayName() )
			CloseActiveMenu()
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE_PLUS )
		} )
	}

	rtk_behavior ornull battlepassButton = self.PropGetBehavior( "battlepassButton" )
	if ( battlepassButton != null )
	{
		expect rtk_behavior( battlepassButton )

		self.AutoSubscribe( battlepassButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKBattlepassMoreInfo_HandleBackButton( button )
		} )
	}

}

void function SetupMoreInfoDataModel( rtk_struct dataModel , ItemFlavor bpFlavor )
{
	asset bpAsset = ItemFlavor_GetAsset( bpFlavor )

	RTKBattlepassMoreInfoModel moreInfoData

	array<asset> rowsIcons = GetRewardIconArray( bpFlavor )
	array<asset> rewardsImages = GetRewardImageArray( bpFlavor )

	moreInfoData.seasonName = ItemFlavor_GetLongName( bpFlavor )
	moreInfoData.timeRemainingText = Localize( "#BP_MOREINFO_ENDS_IN", Season_GetTimeRemainingText( GetLatestSeason( GetUnixTimestamp() ) ) )
	moreInfoData.seasonLogo = GetGlobalSettingsAsset( bpAsset , "largeLogo" )
	moreInfoData.mainColor = GetGlobalSettingsVector( bpAsset, "moreInfoColor" )

	var panelsDT = MoreInfoPanelsDatatable( bpFlavor )
	var rowsDT = MoreInfoRowsDatatable( bpFlavor )

	int panelIndex = 0
	int numPanels = GetDataTableRowCount( panelsDT )

	while ( panelIndex < numPanels )
	{
		asset panelAsset = GetDataTableAsset( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "panelAsset" ) )
		int panelWidth = GetDataTableInt( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "panelWidth" ) )
		int rewardImageHeight = GetDataTableInt( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "rewardImageHeight" ) )
		int rewardImageWidth = GetDataTableInt( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "rewardImageWidth" ) )
		int rewardImageOffsetY = GetDataTableInt( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "rewardImageOffsetY" ) )
		bool useTint = GetDataTableBool( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "useTint" ) )
		string description = GetDataTableString( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "description" ) )
		string bottomTitle = GetDataTableString( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "bottomTitle" ) )

		Assert ( panelAsset != $"", format( "Battlepass flav (%s) More Info Panels Data Table has empty asset fields.", string( ItemFlavor_GetAsset( bpFlavor ) ) ) )

		RTKBattlepassMoreInfoPanelData panelData

		panelData.panelBackground = panelAsset
		if ( rewardsImages.isvalidindex( panelIndex ) )
			panelData.rewardImage = rewardsImages[panelIndex]
		if ( useTint )
			panelData.panelTint = moreInfoData.mainColor
		panelData.rewardImageHeight = rewardImageHeight
		panelData.rewardImageWidth = rewardImageWidth
		panelData.rewardImageOffsetY = rewardImageOffsetY
		panelData.panelWidth = panelWidth
		panelData.orderNumber = panelIndex + 1
		panelData.description = description
		panelData.bottomTitle = bottomTitle
		panelData.hasInstantRewards = BattlePassV2_TierHasInstantRewards( bpFlavor, panelIndex )

		moreInfoData.panels.append( panelData )
		panelIndex++
	}

	array<int> bpTierEntitlements = [ BattlepassGetEntitlementUltimate(), BattlepassGetEntitlementUltimatePlus(), BattlepassGetEntitlementUltToUltPlus() ]
	array<string> bpTierEntitlementsPriceStrings =  GetEntitlementPricesAsStr( bpTierEntitlements )
	array<string> bpTierOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( bpTierEntitlements )
	bool hasDiscount =  Script_UserHasEAAccess()

	if ( bpTierEntitlementsPriceStrings.len() != bpTierEntitlements.len() )
		return

	array<GRXScriptOffer> premiumPassOfferArray = GRX_GetItemDedicatedStoreOffers( bpFlavor, "battlepass" )

	for (int i = 1; i < moreInfoData.panels.len(); i++ )
	{
		if ( i == 1 ) 
		{
			if ( premiumPassOfferArray.len() > 0 )
			{
				string priceStringPremium = Localize( GRX_GetFormattedPrice( premiumPassOfferArray[0].prices[0], 1 ) )
				moreInfoData.panels[i].hasPrice = true
				moreInfoData.panels[i].priceString = priceStringPremium
				moreInfoData.panels[i].hasDiscount = false
				moreInfoData.panels[i].originalPriceString = ""
			}
		}
		else 
		{
			int entitlementIndex = i - 2
			if ( entitlementIndex >= 0 && entitlementIndex < bpTierEntitlements.len() )
			{
				moreInfoData.panels[i].hasPrice = true
				moreInfoData.panels[i].priceString = bpTierEntitlementsPriceStrings[entitlementIndex]
				moreInfoData.panels[i].hasDiscount = hasDiscount
				moreInfoData.panels[i].originalPriceString = bpTierOriginalPriceStrings[entitlementIndex]
			}
		}
	}

	array<int> cosmeticsCountPerTier = GetCosmeticsCountPerTier( bpFlavor )
	if( cosmeticsCountPerTier.len() >= moreInfoData.panels.len() )
	{
		foreach (int index, RTKBattlepassMoreInfoPanelData panel in moreInfoData.panels )
		{
			RTKBattlepassMoreInfoRowData cosmeticsRow
			cosmeticsRow.hasIcon = false
			cosmeticsRow.rowtext = Localize( "#BP_MOREINFO_PANEL_COSMETICS_ROW", cosmeticsCountPerTier[index] )
			panel.rows.append( cosmeticsRow )
		}
	}

	array<bool> tierShowUpgradeText = GetHasUpgradeText( bpFlavor )
	if ( tierShowUpgradeText.len() >= moreInfoData.panels.len() )
	{
		foreach (int index, RTKBattlepassMoreInfoPanelData panel in moreInfoData.panels )
		{
			panel.hasUpgradeText = tierShowUpgradeText[index]
		}
	}

	foreach (int index, RTKBattlepassMoreInfoPanelData panel in moreInfoData.panels )
	{
		if ( panel.hasInstantRewards )
		{
			panel.instantRewards = BattlePassV2_GetInstantRewardModelForTier( bpFlavor, index )
		}
	}

	string rowTextLabel = "rowText"
	if ( GRX_IsOfferRestricted() )
		rowTextLabel = "rowTextGRXRestricted"
	for ( int rowsDataIndex = 0; rowsDataIndex < GetDataTableRowCount( rowsDT ); rowsDataIndex++ )
	{
		bool hasIcon = GetDataTableBool( rowsDT, rowsDataIndex, GetDataTableColumnByName( rowsDT, "hasIcon" ) )
		bool hasLongText = GetDataTableBool( rowsDT, rowsDataIndex, GetDataTableColumnByName( rowsDT, "hasLongText" ) )
		int ownerIndex = GetDataTableInt( rowsDT, rowsDataIndex, GetDataTableColumnByName( rowsDT, "ownerIndex" ) )
		int iconIndex = GetDataTableInt( rowsDT, rowsDataIndex, GetDataTableColumnByName( rowsDT, "iconIndex" ) )
		string rowText = GetDataTableString( rowsDT, rowsDataIndex, GetDataTableColumnByName( rowsDT, rowTextLabel ) )

		if ( !( rowText.isnumeric() && int( rowText ) == 0 ) ) 
		{
			RTKBattlepassMoreInfoRowData rowData
			rowData.hasIcon     = hasIcon
			rowData.hasLongText = hasLongText
			rowData.icon        = rowsIcons[iconIndex]

			if ( rowText.isnumeric() )
				rowText = LocalizeNumber( rowText, true )

			rowData.rowtext     = rowText

			if ( ownerIndex < moreInfoData.panels.len() )
			{
				moreInfoData.panels[ownerIndex].rows.append( rowData )
			}
		}

	}

	
	if ( GRX_IsOfferRestricted() )
	{
		moreInfoData.panels.remove( moreInfoData.panels.len() - 1 )
		moreInfoData.panels.remove( moreInfoData.panels.len() - 1 )
	}

	RTKStruct_SetValue( dataModel, moreInfoData )
}

array<asset> function GetRewardIconArray( ItemFlavor pass )
{
	array<asset> rtnArray
	foreach ( var block in IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoIcons" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( block, "flavor" )
		rtnArray.append(rewardAsset)
	}
	return rtnArray
}

array<asset> function GetRewardImageArray( ItemFlavor pass )
{
	array<asset> rtnArray
	foreach ( var block in IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoRewards" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( block, "flavor" )
		rtnArray.append(rewardAsset)
	}
	return rtnArray
}

array<int> function GetCosmeticsCountPerTier( ItemFlavor pass )
{
	array<int> rtnArray
	foreach ( var block in IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoCosmeticsPerTier" ) )
	{
		int tierCount = GetSettingsBlockInt( block, "cosmeticCount" )
		rtnArray.append(tierCount)
	}
	return rtnArray
}

array<bool> function GetHasUpgradeText( ItemFlavor pass )
{
	array<bool> rtnArray
	bool isRestricted = GRX_IsOfferRestricted()
	foreach ( var block in IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoTierShowUpgradeTexts" ) )
	{
		bool showUpgradeText = GetSettingsBlockBool( block, "showUpgradeText" ) && !isRestricted
		rtnArray.append( showUpgradeText )
	}
	return rtnArray
}

bool function BattlePassV2_TierHasInstantRewards( ItemFlavor pass, int tier )
{
	array<var> boolArray = IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "tierHasInstantRewards" )
	if ( tier < boolArray.len() )
	{
		return GetSettingsBlockBool(boolArray[tier], "hasInstantRewards" )
	}

	return false
}

RTKBattlepassMoreInfoInstantData function BattlePassV2_GetInstantRewardModelForTier( ItemFlavor pass, int tier )
{
	RTKBattlepassMoreInfoInstantData model

	array<var> packStringsArray = IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoTierInstantPacksStrings" )
	if ( tier < packStringsArray.len() )
		model.packString = GetSettingsBlockString( packStringsArray[tier], "instantPacksString" )

	array<var> unlockAllLegendsArray = IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoTierUnlocksAllLegends" )
	if ( tier < unlockAllLegendsArray.len() )
		model.unlockAllLegends = GetSettingsBlockBool( unlockAllLegendsArray[tier], "unlocksAllLegends" )

	array<var> rewardIconsArrayArray = IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoTierInstantRewardIcons" )
	array<var> rewardStringsArrayArray = IterateSettingsAssetArray( ItemFlavor_GetAsset( pass ), "moreInfoTierInstantRewardStrings" )
	if ( tier < rewardIconsArrayArray.len() && tier < rewardStringsArrayArray.len() )
	{
		array<var> stringsArray  = IterateSettingsArray( GetSettingsBlockArray( rewardStringsArrayArray[tier], "moreInfoInstantRewardStrings" ) )
		array<var> iconsArray  = IterateSettingsArray( GetSettingsBlockArray( rewardIconsArrayArray[tier], "moreInfoInstantRewardIcons" ) )
		for ( int i = 0; i < iconsArray.len(); i++ )
		{
			RTKBattlepassMoreInfoRowData row
			row.hasIcon = true
			row.icon = GetSettingsBlockAsset( iconsArray[i], "rewardIcon" )
			row.rowtext  = GetSettingsBlockString( stringsArray[i], "instantRewardString" )

			model.rewardRows.append( row )
		}
	}

	return model
}

var function MoreInfoPanelsDatatable( ItemFlavor pass )
{
	Assert( ItemFlavor_GetType( pass ) == eItemType.battlepass )

	asset moreInfoPanelsAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( pass ), "moreInfoPanelsDataTable" )
	Assert ( moreInfoPanelsAsset != $"", format( "Battlepass flav (%s) must define a V2 More Info Panels Data Table (null/not found).", string( ItemFlavor_GetAsset( pass ) ) ) )

	return GetDataTable( moreInfoPanelsAsset )
}

var function MoreInfoRowsDatatable( ItemFlavor pass )
{
	Assert( ItemFlavor_GetType( pass ) == eItemType.battlepass )

	asset moreInfoRowsAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( pass ), "moreInfoRowsDataTable" )
	Assert ( moreInfoRowsAsset != $"", format( "Battlepass flav (%s) must define a More Info Rows Data Table (null/not found).", string( ItemFlavor_GetAsset( pass ) ) ) )

	return GetDataTable( moreInfoRowsAsset )
}