global function AirdropExtra_Init
global function AirdropExtravaganza_RegisterNetworking














struct
{




























} file


global const string AIRDROPEXTRA_ANIMATION 		= "droppod_loot_drop_multi"
const int AIRDROPEXTRA_CLUSTER_COUNT 			= 1
const int AIRDROPEXTRA_LOOT_CONFETTI_COUNT 		= 3
const float AIRDROPEXTRA_CLUSTER_DELAY_BASE		= 6.0
const float AIRDROPEXTRA_CLUSTER_DELAY_VARIANCE	= 1.5
const float AIRDROPEXTRA_CLUSTER_DELAY_BETWEEN	= 1.0
const float AIRDROPEXTRA_CLUSTER_DISTANCE		= 800.0
const float AIRDROPEXTRA_CLUSTER_FAIL_MOD_DIST	= 150.0
const int AIRDROPEXTRA_CLUSTER_PLACEMENT_TRIES 	= 10
const float AIRDROPEXTRA_CLUSTER_MIN_DIST		= 30.0

void function AirdropExtra_Init()
{
























		if ( GetCurrentPlaylistVarBool( "airdrop_ltm_custom_UI_enabled", false ) )
		{
			SURVIVAL_SetGameStateAssetOverrideCallback( AirdropExtravaganzaOverrideGamestateUI )
		}


	AirdropExtravaganza_RegisterNetworking()
}

void function AirdropExtravaganza_RegisterNetworking()
{
	RegisterNetworkedVariable( "AirdropExtra_AirdropTier", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "AirdropExtra_AirdropProgress", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "AirdropExtra_AirdropCount", SNDC_GLOBAL, SNVT_INT, -1 )



		if ( GetCurrentPlaylistVarBool( "airdrop_ltm_custom_UI_enabled", false ) )
		{
			RegisterNetVarIntChangeCallback( "AirdropExtra_AirdropTier", OnServerVarChanged_AirdropExtra_AirdropTier )
			RegisterNetVarIntChangeCallback( "AirdropExtra_AirdropProgress", OnServerVarChanged_AirdropExtra_AirdropProgress )
			RegisterNetVarIntChangeCallback( "AirdropExtra_AirdropCount", OnServerVarChanged_AirdropExtra_AirdropProgress )
		}

}

















































































































































































































































































































































































































































void function AirdropExtravaganzaOverrideGamestateUI()
{
	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_airdropextra.rpak" )
}

void function OnServerVarChanged_AirdropExtra_AirdropTier( entity player, int new )
{
	if ( GetGameState() != eGameState.Playing )
		return

	printf( "AIRDROP EXTRAVAGANZA: server var changed: " + new )

	int colorID = GetAirdropPingColorIDFromRarityTier( new )
	string airdropText = GetAirdropTierTextFromTier( new )

	RuiSetColorAlpha( ClGameState_GetRui(), "airdropTierColor", SrgbToLinear( ColorPalette_GetColorFromID( colorID ) / 255.0 ), 1.0 )
	RuiSetString( ClGameState_GetRui(), "airdropTierText", airdropText )

	RuiSetInt( ClGameState_GetRui(), "airdropCount", GetGlobalNetInt("AirdropExtra_AirdropCount") )
}

void function OnServerVarChanged_AirdropExtra_AirdropProgress( entity player, int new )
{
	if ( GetGameState() != eGameState.Playing )
		return

	RuiSetInt( ClGameState_GetRui(), "airdropProgress", new )
}

string function GetAirdropTierTextFromTier( int tier )
{
	switch ( tier )
	{
		case eLootTier.COMMON:
			return "COMMON"
		case eLootTier.RARE:
			return "RARE"
		case eLootTier.EPIC:
			return "EPIC"
		case eLootTier.LEGENDARY:
			return "LEGENDARY"
		case eLootTier.MYTHIC:
			return "MYTHIC"
	}
	return ""
}

