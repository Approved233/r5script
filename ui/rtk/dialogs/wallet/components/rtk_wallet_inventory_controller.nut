global function RTKWalletInventoryPanel_OnInitialize
global function RTKWalletInventoryPanel_OnDestroy

global struct CurrencyDescriptionData
{
	asset image
	int total
	string description
	string expirationInfo
}

global struct WalletInventoryPanelItems
{
	array<CurrencyDescriptionData> itemsArray
}

void function RTKWalletInventoryPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct walletInventoryPanel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "walletInventoryPanel", "WalletInventoryPanelItems" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "walletInventoryPanel", true ) )
	RegisterSignal( "InventoryShutDown" )
	thread RTKWalletInventoryPanel_SetUp()
}

void function RTKWalletInventoryPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "walletInventoryPanel" )
	Signal( uiGlobal.signalDummy, "InventoryShutDown" )
}

void function RTKWalletInventoryPanel_SetUp()
{
	EndSignal( uiGlobal.signalDummy, "InventoryShutDown" )

	bool waitingForInventoryReady = true

	while ( waitingForInventoryReady )
	{
		if ( GRX_IsInventoryReady() && GRX_AreOffersReady() )
		{
			waitingForInventoryReady = false

			WalletInventoryPanelItems itemsData
			entity player = GetLocalClientPlayer()
			int currencyTotal
			int nextExpirationAmount

			CurrencyDescriptionData apexCoinsData
			apexCoinsData.image = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
			currencyTotal = GRXCurrency_GetPlayerBalance( player , GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
			apexCoinsData.total = currencyTotal
			apexCoinsData.description = ( currencyTotal >= 0 ) ? Localize( "#CURRENCIES_TOOLTIP_PREMIUM" ) : Localize( "#CURRENCIES_TOOLTIP_NEGATIVE" )
			nextExpirationAmount = GRX_GetNextCurrencyExpirationAmt( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
			apexCoinsData.expirationInfo = ( nextExpirationAmount > 0 ) ? Localize( "#CURRENCIES_TOOLTIP_EXPIRATION", nextExpirationAmount, ( GRX_GetNextCurrencyExpirationTime(GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]) - GetUnixTimestamp() ) / SECONDS_PER_DAY ) : ""
			itemsData.itemsArray.append( apexCoinsData )

			CurrencyDescriptionData craftingMetalsData
			craftingMetalsData.image = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
			currencyTotal = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
			craftingMetalsData.total = currencyTotal
			craftingMetalsData.description = "#CURRENCIES_TOOLTIP_CRAFTING"
			craftingMetalsData.expirationInfo = ""
			itemsData.itemsArray.append( craftingMetalsData )

			CurrencyDescriptionData legendTokens
			legendTokens.image = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
			currencyTotal = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
			legendTokens.total = currencyTotal
			legendTokens.description = "#CURRENCIES_TOOLTIP_CREDITS"
			legendTokens.expirationInfo = ""
			itemsData.itemsArray.append( legendTokens )

			CurrencyDescriptionData heirloomShardsData
			heirloomShardsData.image = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
			currencyTotal = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
			heirloomShardsData.total = currencyTotal
			heirloomShardsData.description = "#CURRENCIES_WALLET_HEIRLOOM"
			heirloomShardsData.expirationInfo = ""
			itemsData.itemsArray.append( heirloomShardsData )

			CurrencyDescriptionData exoticShardsData
			exoticShardsData.image = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
			currencyTotal = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
			exoticShardsData.total = currencyTotal
			exoticShardsData.description = ( currencyTotal >= 0 ) ? Localize( "#CURRENCIES_WALLET_EXOTIC" ) : Localize( "#CURRENCIES_WALLET_NEGATIVE_EXOTIC" )
			nextExpirationAmount = GRX_GetNextCurrencyExpirationAmt( GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
			exoticShardsData.expirationInfo = ( nextExpirationAmount > 0 ) ? Localize( "#CURRENCIES_WALLET_EXPIRATION_EXOTIC", nextExpirationAmount, ( GRX_GetNextCurrencyExpirationTime(GRX_CURRENCIES[GRX_CURRENCY_EXOTIC]) - GetUnixTimestamp() ) / SECONDS_PER_DAY ) : ""
			itemsData.itemsArray.append( exoticShardsData )

			rtk_struct walletInventoryPanel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "walletInventoryPanel", "WalletInventoryPanelItems" )
			RTKStruct_SetValue( walletInventoryPanel, itemsData )
		}
		else
		{
			WaitFrame()
		}
	}
}