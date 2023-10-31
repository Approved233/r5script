global function Perk_EnemyBeaconScan_Init




















struct
{





} file

void function Perk_EnemyBeaconScan_Init()
{







	if ( !(GetCurrentPlaylistVarBool( "disable_perk_beacon_scan_enemy", false ) ) )
	{
		PerkInfo beaconScanEnemy
		beaconScanEnemy.perkId          = ePerkIndex.BEACON_ENEMY_SCAN











		Perks_RegisterClassPerk( beaconScanEnemy )















	}

	bool shouldUseSeperateNextZoneScanProp = SurveyBeacons_ShouldUseNextZoneSurveyBeaconProp()
	if ( !(GetCurrentPlaylistVarBool( "disable_perk_beacon_scan", false ) ) && !shouldUseSeperateNextZoneScanProp )
	{
		PerkInfo beaconScan
		beaconScan.perkId          = ePerkIndex.BEACON_SCAN







		Perks_RegisterClassPerk( beaconScan )
	}
}













bool function EnemyBeaconScan_UseNewBeaconModel()
{
	return GetCurrentPlaylistVarBool( "perk_enemy_beacon_use_new_model", true )
}

bool function EnemyBeaconScan_RevealScannerLocation()
{
	return GetCurrentPlaylistVarBool( "perk_enemy_beacon_use_scanner_location", true )
}












































































































































































































































































































































































































































































