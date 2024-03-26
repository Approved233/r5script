global function RTKLegendUpgradesArmorCore_OnInitialize
global function RTKLegendUpgradesArmorCore_OnDestroy
global function RTKLegendUpgradesArmorCore_OnUpdate
global function RTKLegendUpgradesArmorCore_UpdateArmorCoreDataModel

const string LEGEND_UPGRADES_ARMOR_CORE_DATA_MODEL_NAME = "legendUpgradeArmorCore"

global struct RTKUpgradeArmorCoreModel
{
	int upgradeTier = 0
}

struct
{
	bool updateArmorCore = false
} file

void function RTKLegendUpgradesArmorCore_OnInitialize( rtk_behavior self )
{
	if ( !UpgradeCore_IsEnabled() )
		return

	rtk_struct legendUpgradeArmorCore = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_ARMOR_CORE_DATA_MODEL_NAME, "RTKUpgradeArmorCoreModel" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_ARMOR_CORE_DATA_MODEL_NAME, true ) )

	RTKLegendUpgradesArmorCore_UpdateArmorCoreDataModel()
	RegisterSignal( "RTKLegendUpgradesArmorCore_OnDestroy" )
}

void function RTKLegendUpgradesArmorCore_OnDestroy( rtk_behavior self )
{
	if ( !UpgradeCore_IsEnabled() )
		return

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_ARMOR_CORE_DATA_MODEL_NAME )
	Signal( uiGlobal.signalDummy, "RTKLegendUpgradesArmorCore_OnDestroy" )
}

void function RTKLegendUpgradesArmorCore_OnUpdate( rtk_behavior self, float dt )
{
	if ( file.updateArmorCore )
	{
		if ( !UpgradeCore_IsEnabled() )
			return

		file.updateArmorCore = false
		rtk_struct legendUpgradeArmorCore = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_ARMOR_CORE_DATA_MODEL_NAME, "RTKUpgradeArmorCoreModel" )
		int armorTier = UpgradeCore_GetPlayerArmorTier( GetLocalClientPlayer() )
		RTKStruct_SetInt( legendUpgradeArmorCore, "upgradeTier", armorTier )
	}
}

void function RTKLegendUpgradesArmorCore_UpdateArmorCoreDataModel()
{
	if ( !UpgradeCore_IsEnabled() )
		return

	file.updateArmorCore = true
}