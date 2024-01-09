

global function ShLobaPassiveEyeForQuality_LevelInit

global function GetEyeForQualityRadius
global function GetEyeForQualityCanSee




void function ShLobaPassiveEyeForQuality_LevelInit()
{
















		AddCallback_EditLootDesc( Loba_EditUALootDesc )

}























string function Loba_EditUALootDesc( string lootRef, entity player, string originalDesc )
{
	string finalDesc = originalDesc

	
	if ( lootRef == "health_pickup_ultimate"
			&& IsValid( player )
			&& LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
			&& ItemFlavor_GetAsset( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() ) ) == $"settings/itemflav/character/loba.rpak" )
	{
		finalDesc = Localize( "#SURVIVAL_PICKUP_HEALTH_ULTIMATE_HINT_LOBA" )
	}
	return finalDesc
}
































































































































































float function GetEyeForQualityRadius()
{
	return GetCurrentPlaylistVarFloat( "loba_pas_eye_for_quality_range", GetBlackMarketNearbyLootRadius() )
}

bool function GetEyeForQualityCanSee( LootData data )
{
	if ( data.tier - 1 >= eRarityTier.EPIC )
		return true


		if ( data.ref.find( "hopup_golden_horse" ) != -1 )
			return true



	return false
}



