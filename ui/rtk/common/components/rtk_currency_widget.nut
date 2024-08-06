global function RTKCurrencyWidget_OnInitialize
global function RTKCurrencyWidget_OnDestroy

global struct RTKCurrencyDisplayModel
{
	asset currencyIcon
	int currencyAmount
}

global struct RTKCurrencyWidgetModel
{
	array<RTKCurrencyDisplayModel> currencyDisplays
}

struct PrivateData
{
	void functionref() OnGRXStateChanged
}

const string RTK_CURRENCY_WIDGET_MODEL_NAME = "currencyWidget"

void function RTKCurrencyWidget_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_struct widgetStruct  = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, RTK_CURRENCY_WIDGET_MODEL_NAME, "RTKCurrencyWidgetModel" )
	string pathToModel = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, RTK_CURRENCY_WIDGET_MODEL_NAME )

	p.OnGRXStateChanged = ( void function() {
		RTKCurrencyWidget_UpdateDataModel()
	} )

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )

	self.GetPanel().SetBindingRootPath( pathToModel )
}

void function RTKCurrencyWidget_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, RTK_CURRENCY_WIDGET_MODEL_NAME )
	RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function RTKCurrencyWidget_UpdateDataModel()
{
	if ( !GRX_IsInventoryReady() )
		return

	rtk_struct widgetStruct  = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, RTK_CURRENCY_WIDGET_MODEL_NAME, "RTKCurrencyWidgetModel" )
	entity player = GetLocalClientPlayer()
	RTKCurrencyWidgetModel widgetModel

	RTKCurrencyDisplayModel legendTokenData
	legendTokenData.currencyIcon = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
	legendTokenData.currencyAmount = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
	widgetModel.currencyDisplays.append( legendTokenData )

	RTKCurrencyDisplayModel craftingMetalData
	craftingMetalData.currencyIcon = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
	craftingMetalData.currencyAmount = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
	widgetModel.currencyDisplays.append( craftingMetalData )

	RTKCurrencyDisplayModel exoticShardData
	exoticShardData.currencyIcon = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	exoticShardData.currencyAmount = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	widgetModel.currencyDisplays.append( exoticShardData )

	RTKCurrencyDisplayModel apexCoinData
	apexCoinData.currencyIcon = ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	apexCoinData.currencyAmount = GRXCurrency_GetPlayerBalance( player, GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	widgetModel.currencyDisplays.append( apexCoinData )

	RTKStruct_SetValue( widgetStruct, widgetModel )
}