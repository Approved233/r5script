globalize_all_functions

string function RTKMutator_ApexCupTierText( int input, int p0 )
{
	CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( input )

	if ( p0 < 0 || assetData.tiers.len() <= p0 )
	{
		Warning( "Invalid tier text index {" + p0 + "} for cup {" + input + "}" )
		return ""
	}

	int relativeTier = 0
	for ( int i = 0; i < assetData.tiers.len(); ++i )
	{
		if ( assetData.tiers[i].tierType == eCupTierType.ABSOLUTE )
		{
			if ( i == p0 )
				return ""
		}
		else if ( assetData.tiers[i].tierType == eCupTierType.PERCENTILE )
		{
			++relativeTier
			if ( i == p0 )
				return LocalizeNumeral( relativeTier )
		}
	}
	return ""
}

asset function RTKMutator_ApexCupTierIcon( int input, int p0 )
{
	switch ( p0 )
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
			Warning( "Invalid tier icon index {" + p0 + "} for cup {" + input + "}" )
			return $""
	}
	unreachable
}

string function RTKMutator_ApexCupCurrentTierText( int input )
{
	CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( input )

	int index = Cups_GetPlayerTierIndexForCup( input )
	if ( index < 0 || assetData.tiers.len() <= index )
	{
		Warning( "Invalid tier index {" + index + "} for cup {" + input + "}" )
		return ""
	}

	int relativeTier = 0
	for ( int i = 0; i < assetData.tiers.len(); ++i )
	{
		if ( assetData.tiers[i].tierType == eCupTierType.ABSOLUTE )
		{
			if ( i == index )
			{
				CupEntry ornull entry = Cups_GetSquadCupData( input )
				if ( entry == null )
				{
					Warning( "Invalid entry for cup {" + input + "}" )
					return ""
				}
				expect CupEntry( entry )

				return entry.currSquadPosition.tostring()
			}
		}
		else if ( assetData.tiers[i].tierType == eCupTierType.PERCENTILE )
		{
			++relativeTier
			if ( i == index )
				return LocalizeNumeral( relativeTier )
		}
	}
	return ""
}

asset function RTKMutator_ApexCupCurrentTierIcon( int input )
{
	return RTKMutator_ApexCupTierIcon( input, Cups_GetPlayerTierIndexForCup( input ) )
}