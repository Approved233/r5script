globalize_all_functions

string function RTKMutator_ApexCupTierText( int input, int p0 )
{
	if( !Cups_IsValidCupID( input ) )
	{
		Warning( "Invalid tier text for cup {" + input + "}" )
		return ""
	}

	CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( input )

	if ( p0 < 0 || assetData.tiers.len() <= p0 )
	{
		Warning( "Invalid tier text index {" + p0 + "} for cup {" + input + "}" )
		return ""
	}

	int relativeTier = 0
	for ( int i = 0; i < assetData.tiers.len(); ++i )
	{
		++relativeTier
		if ( i == p0 )
			return LocalizeNumeral( relativeTier )
	}
	return ""
}

asset function RTKMutator_ApexCupTierIcon( SettingsAssetGUID input, int teirIndex )
{
	if( !Cups_IsValidCupID( input ) )
	{
		Warning( "Invalid tier icon for cup {" + input + "}" )
		return $""
	}

	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( input )

	if (( teirIndex > -1  ) && (teirIndex < cupData.tiers.len() ))
	{
		if ( cupData.tiers[teirIndex].icon != $"" )
			return cupData.tiers[teirIndex].icon
	}

	switch ( teirIndex )
	{
		case 0:
			return $"ui_image/rui/menu/apex_rumble/cups_emblem_01.rpak"
		case 1:
			return $"ui_image/rui/menu/apex_rumble/cups_emblem_02.rpak"
		case 2:
			return $"ui_image/rui/menu/apex_rumble/cups_emblem_03.rpak"
		case 3:
			return $"ui_image/rui/menu/apex_rumble/cups_emblem_04.rpak"
		case 4:
			return $"ui_image/rui/menu/apex_rumble/cups_emblem_05.rpak"
		default:
			Warning( "Invalid tier icon index {" + teirIndex + "} for cup {" + input + "}" )
			return $""
	}
	unreachable
}

string function GetApexCupTierText( int input, int offset = 0 )
{
	if( !Cups_IsValidCupID( input ) )
	{
		Warning( "Invalid tier for cup {" + input + "}" )
		return ""
	}

	CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( input )

	int index = Cups_GetPlayerTierIndexForCup( input ) + offset
	if ( index < 0 || assetData.tiers.len() <= index )
	{
		Warning( "Invalid tier index {" + index + "} for cup {" + input + "}" )
		return ""
	}

	int relativeTier = 0
	for ( int i = 0; i < assetData.tiers.len(); ++i )
	{
		++relativeTier
		if ( i == index )
			return LocalizeNumeral( relativeTier )
	}
	return ""
}

string function RTKMutator_ApexCupCurrentTierText( int input )
{
	return GetApexCupTierText( input )
}

string function RTKMutator_ApexCupNextTierText( int input )
{
	return GetApexCupTierText( input, -1 )
}

asset function RTKMutator_ApexCupCurrentTierIcon( int input )
{
	return RTKMutator_ApexCupTierIcon( input, Cups_GetPlayerTierIndexForCup( input ) )
}

asset function RTKMutator_ApexCupNextTierIcon( int input )
{
	return RTKMutator_ApexCupTierIcon( input, Cups_GetPlayerTierIndexForCup( input ) - 1 )
}

string function RTKMutator_ApexCupLockStateText( int input )
{
	switch ( input )
	{
		case CUP_LOCK_LEVELS:
			return Localize( "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED", Ranked_GetRankedLevelRequirement() + 1 )
			break
		case CUP_LOCK_ORIENTATION:
			return Localize( "#PLAYLIST_STATE_COMPLETED_ORIENTATION_REQUIRED" )
			break
		case CUP_LOCK_TRAINING:
			return Localize( "#PLAYLIST_STATE_COMPLETED_TRAINING_REQUIRED" )
			break
		case CUP_LOCK_NO_POSITION:
			return Localize( "#PLAYLIST_STATE_NO_POSITION" )
			break
		case CUP_LOCK_NOT_REGISTERED:
			return Localize( "#PLAYLIST_STATE_RANKED_RUMBLE_NOT_REGISTERED" )
			break

		default:
			return ""
			break
	}
	unreachable
}

bool function RTKMutator_ApexCupContainerIsBestTen( int input )
{
	return Cups_IsCupContainerUseBestTen( input )
}