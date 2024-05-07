global function UserInfoPanels_LevelInit
global function UpdateActiveUserInfoPanels
global function SetUpAccessToTheCurrenciesWallet



struct SingleCurrencyBalanceElement
{
	var         element
	ItemFlavor& currency
}

struct FileStruct_LifetimeLevel
{
	table<var, bool>                    activeUserInfoPanelSet
	array<SingleCurrencyBalanceElement> singleCurrencyBalanceElementList
}
FileStruct_LifetimeLevel& fileLevel

void function UserInfoPanels_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddCallbackOrMaybeCallNow_OnAllItemFlavorsRegistered( SetupUserInfoPanels )
}

struct
{
	bool accessToWalletSetUp = false
} file







void function SetupUserInfoPanels()
{
	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		if ( userInfoElemList.len() > 0 )
		{
			foreach ( var elem in userInfoElemList )
			{
				var rui = Hud_GetRui( elem )
				RuiSetImage( rui, "symbol1", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) )
				RuiSetImage( rui, "symbol2", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] ) )
				RuiSetImage( rui, "symbol3", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] ) )
				RuiSetImage( rui, "symbol4", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] ) )

				fileLevel.activeUserInfoPanelSet[elem] <- true 
			}

			
			
			
			
			
			
			
			
			
		}
	}

	table<string, int> singleCurrencyElementTypesTable = {
		["PremiumBalance"] = GRX_CURRENCY_PREMIUM,
		["CreditBalance"] = GRX_CURRENCY_CREDITS,
		["CraftingBalance"] = GRX_CURRENCY_CRAFTING,
		["ExoticBalance"] = GRX_CURRENCY_EXOTIC,
	}
	foreach( string classname, int currencyIndex in singleCurrencyElementTypesTable )
	{
		ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
		foreach ( var elem in GetElementsByClassnameForMenus( classname, uiGlobal.allMenus ) )
		{
			var rui = Hud_GetRui( elem )
			RuiSetImage( rui, "symbol", ItemFlavor_GetIcon( currency ) )

			SingleCurrencyBalanceElement scbe
			scbe.element = elem
			scbe.currency = currency
			fileLevel.singleCurrencyBalanceElementList.append( scbe )
		}
	}

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateActiveUserInfoPanels )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateActiveUserInfoPanels )
}


void function UpdateActiveUserInfoPanels()
{
	bool isReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	int premiumBalance, creditsBalance, craftingBalance, exoticBalance

	printt("UpdateActiveUserInfoPanels Offers:" + GRX_AreOffersReady() + " Inventory:" + GRX_IsInventoryReady()  + " isReady:" +isReady + " " + FUNC_NAME( 1 ) );

	if ( isReady )
	{
		premiumBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
		creditsBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
		craftingBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
		exoticBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	}

	foreach( var elem, bool unused in fileLevel.activeUserInfoPanelSet )
	{
		var rui = Hud_GetRui( elem )
		
		RuiSetBool( rui, "isQuerying", !isReady )

		RuiSetBool( rui, "count1isNegative", premiumBalance < 0 )
		RuiSetBool( rui, "count2isNegative", creditsBalance < 0 )
		RuiSetBool( rui, "count3isNegative", craftingBalance < 0 )
		RuiSetBool( rui, "count4isNegative", exoticBalance < 0 )
		if ( isReady )
		{
#if DEV
				RuiSetBool( rui, "hasUnknownItems", GetConVarBool( "grx_hasUnknownItems" ) )
#endif
			RuiSetString( rui, "count1",  FormatAndLocalizeNumber( "1", float( premiumBalance ), true ) )
			RuiSetString( rui, "count2", LocalizeAndShortenNumber_Int( creditsBalance ) )
			RuiSetString( rui, "count3", LocalizeAndShortenNumber_Int( craftingBalance ) )
			RuiSetString( rui, "count4", FormatAndLocalizeNumber( "1", float( exoticBalance ), true ) )
		}
	}

	foreach( SingleCurrencyBalanceElement scbe in fileLevel.singleCurrencyBalanceElementList )
	{
		var rui = Hud_GetRui( scbe.element )
		RuiSetBool( rui, "isQuerying", !isReady )

		if ( isReady )
			RuiSetInt( rui, "count", GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), scbe.currency ) )
	}

}






























void function SetUpAccessToTheCurrenciesWallet()
{
	if ( file.accessToWalletSetUp )
		return

	ToolTipData ttd
	ttd.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
	ttd.actionHint1 = "#A_BUTTON_VIEW_WALLET"

	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		foreach ( var elem in userInfoElemList )
		{
			Hud_AddEventHandler( elem, UIE_CLICK, OpenWalletInventoryModal )
			Hud_SetToolTipData( elem, ttd )
		}
	}

	file.accessToWalletSetUp = true
}