global function Perk_ScoutExpert_Init
global function Perk_ScoutExpert_FastBeaconScan_Enabled
global function Perk_ScoutExpert_FastBeaconScan_ScanRange
global function Perk_ScoutExpert_FastBeaconScan_ScanDuration
global function Perk_ScoutExpert_RescanWait












const string INNATE_THREAT_VISION_MOD = "innate_threat_vision"
const asset FAST_BEACON_SCAN_START_FX = $"P_beacon_Survey_Pulse"

struct
{



}file

struct
{
	float beaconScanRange = 500
	float surveyBeaconScanRange = 20000
	bool refundTacOnBeaconScan = false
	float rescanWait = 5
	float satelliteScanDuration = 15
	float companionScanTime = 10
}tunings

void function Perk_ScoutExpert_Init()
{
	PerkInfo scoutExpert
	scoutExpert.perkId          = ePerkIndex.SCOUT_EXPERT
















	Perks_RegisterClassPerk( scoutExpert )

	RegisterSignal( "ScoutExpertEnd" )

	tunings.beaconScanRange = GetCurrentPlaylistVarFloat( "perk_scout_expert_fast_beacon_scan_range", tunings.beaconScanRange )
	tunings.refundTacOnBeaconScan = GetCurrentPlaylistVarBool( "perk_scout_expert_fast_beacon_scan_refund_tac", tunings.refundTacOnBeaconScan )
	tunings.surveyBeaconScanRange = GetCurrentPlaylistVarFloat( "perk_scout_expert_fast_beacon_survey_beacon_scan_range", tunings.surveyBeaconScanRange )
	tunings.rescanWait = GetCurrentPlaylistVarFloat( "perk_scout_expert_fast_beacon_rescan_wait", tunings.rescanWait )
	tunings.satelliteScanDuration = GetCurrentPlaylistVarFloat( "perk_scout_expert_fast_beacon_scan_duration", tunings.satelliteScanDuration )
	tunings.companionScanTime = GetCurrentPlaylistVarFloat( "perk_scout_expert_fast_beacon_companion_scan_time", tunings.companionScanTime )
}

float function Perk_ScoutExpert_RescanWait()
{
	return tunings.rescanWait
}

bool function Perk_ScoutExpert_FastBeaconScan_Enabled()
{
	return Perks_S22UpdateEnabled() && GetCurrentPlaylistVarBool( "perk_scout_expert_fast_beacon_scan_enabled", true )
}

bool function Perk_ScoutExpert_IsEnabled()
{
	return Perks_S22UpdateEnabled() && GetCurrentPlaylistVarBool( "perk_scout_expert_is_enabled", true )
}

float function Perk_ScoutExpert_FastBeaconScan_ScanRange()
{
	return tunings.surveyBeaconScanRange
}

float function Perk_ScoutExpert_FastBeaconScan_ScanDuration()
{
	return tunings.satelliteScanDuration
}












































































































































































































































