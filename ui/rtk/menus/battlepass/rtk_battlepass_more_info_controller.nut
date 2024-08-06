global function InitRTKBattlePassMoreInfoMenu
global function RTKBattlepassMoreInfo_OnInitialize
global function RTKBattlepassMoreInfo_OnDestroy
global function OpenBattlepassMoreInfo

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
	string topTitle = ""
	string bottomTitle = ""
	string priceString = ""
	string originalPriceString = ""
	bool hasPrice = false
	bool hasDiscount = false
	array<RTKBattlepassMoreInfoRowData> rows
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
	CloseAllMenus()
	AdvanceMenu( GetMenu( "LobbyMenu" ) )
	JumpToSeasonTab( "RTKBattlepassPanel" )
}


void function RTKBattlepassMoreInfo_SetUpButtons( rtk_behavior self, rtk_struct modelStruct, ItemFlavor bpFlavor )
{
	entity LocalPlayer = GetLocalClientPlayer()
	bool hasPremiumPass = DoesPlayerOwnBattlePass( LocalPlayer, bpFlavor )
	bool hasElitePass = DoesPlayerOwnEliteBattlePass( LocalPlayer, bpFlavor )
	bool canUpgrade = hasPremiumPass && ! hasElitePass
	bool userHasEAAccess = Script_UserHasEAAccess()

	RTKStruct_SetBool( modelStruct, "hasDiscount", userHasEAAccess )
	RTKStruct_SetBool( modelStruct, "canUpgrade" , canUpgrade)
	RTKStruct_SetBool( modelStruct, "showPurchaseButton" , !hasElitePass)

	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	if ( purchaseButton != null )
	{
		expect rtk_behavior( purchaseButton )

		self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, hasPremiumPass ) {
			PIN_UIInteraction_OnClick( "menu_rtkbattlepassmoreinfomenu", button.GetPanel().GetDisplayName() )
			CloseActiveMenu()
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.PREMIUMPLUS )
		} )
	}

	rtk_behavior ornull purchasePremiumButton = self.PropGetBehavior( "battlepassButton" )
	if ( purchasePremiumButton != null )
	{
		expect rtk_behavior( purchasePremiumButton )

		self.AutoSubscribe( purchasePremiumButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
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
	moreInfoData.timeRemainingText = Season_GetTimeRemainingText( GetLatestSeason( GetUnixTimestamp() ) )
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
		string topTitle = GetDataTableString( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "topTitle" ) )
		string bottomTitle = GetDataTableString( panelsDT, panelIndex, GetDataTableColumnByName( panelsDT, "bottomTitle" ) )

		Assert ( panelAsset != $"", format( "Battlepass flav (%s) More Info Panels Data Table has empty asset fields.", string( ItemFlavor_GetAsset( bpFlavor ) ) ) )

		RTKBattlepassMoreInfoPanelData panelData

		panelData.panelBackground = panelAsset
		panelData.rewardImage = rewardsImages[panelIndex]
		if ( useTint )	panelData.panelTint = moreInfoData.mainColor
		panelData.rewardImageHeight = rewardImageHeight
		panelData.rewardImageWidth = rewardImageWidth
		panelData.rewardImageOffsetY = rewardImageOffsetY
		panelData.panelWidth = panelWidth
		panelData.orderNumber = panelIndex + 1
		panelData.description = description
		panelData.topTitle = topTitle
		panelData.bottomTitle = bottomTitle

		moreInfoData.panels.append( panelData )
		panelIndex++
	}

	array<int> bpTierEntitlements = [ R5_BATTLEPASS_1, R5_BATTLEPASS_1_PLUS ]
	array<string> bpTierEntitlementsPriceStrings =  GetEntitlementPricesAsStr( bpTierEntitlements )
	array<string> bpTierOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( bpTierEntitlements )
	bool hasDiscount =  Script_UserHasEAAccess()

	if ( bpTierEntitlementsPriceStrings.len() != bpTierEntitlements.len() )
		return

	
	moreInfoData.panels[1].hasPrice = true
	moreInfoData.panels[1].priceString = bpTierEntitlementsPriceStrings[0]
	moreInfoData.panels[1].hasDiscount = hasDiscount
	moreInfoData.panels[1].originalPriceString = bpTierOriginalPriceStrings[0]

	
	moreInfoData.panels[2].hasPrice = true
	moreInfoData.panels[2].priceString = bpTierEntitlementsPriceStrings[1]
	moreInfoData.panels[2].hasDiscount = hasDiscount
	moreInfoData.panels[2].originalPriceString = bpTierOriginalPriceStrings[1]

	array<int> cosmeticsCountPerTier = GetCosmeticsCountPerTier( bpFlavor )
	if( cosmeticsCountPerTier.len() == moreInfoData.panels.len() )
	{
		foreach (int index, RTKBattlepassMoreInfoPanelData panel in moreInfoData.panels )
		{
			RTKBattlepassMoreInfoRowData cosmeticsRow
			cosmeticsRow.hasIcon = false
			cosmeticsRow.rowtext = Localize( "#BP_MOREINFO_PANEL_COSMETICS_ROW", cosmeticsCountPerTier[index] )
			panel.rows.append( cosmeticsRow )
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
			rowData.rowtext     = rowText

			moreInfoData.panels[ownerIndex].rows.append( rowData )
		}

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