global function InitRTKCupInfoTiers
global function RTKCupInfoTiers_OnInitialize
global function RTKCupInfoTiers_OnDestroy

global struct RTKCupTierCard
{
	int 		tierIndex
	string 		tierReward
	string 		tierPercentage

	SettingsAssetGUID	cupID
}

global struct RTKCupInfoTiers
{
	array< RTKCupTierCard >	tierList
}

void function RTKCupInfoTiers_OnInitialize( rtk_behavior self )
{
	rtk_struct apexCups = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCupsDialog", "RTKCupInfoTiers" )
	RTKCupInfoTiers apexCupsModel

	SettingsAssetGUID cupId 	= RTKApexCupsOverview_GetCupID()
	CupBakeryAssetData cupData 	= Cups_GetCupBakeryAssetDataFromGUID( cupId )

	foreach ( index, CupTierData cupTier in cupData.tiers )
	{
		RTKCupTierCard	cupTierCard

		cupTierCard.cupID = cupId
		cupTierCard.tierIndex = index

		if ( cupTier.tierType == eCupTierType.ABSOLUTE )
		{
			cupTierCard.tierPercentage = Localize("#CUPS_REWARDS_TOP", (cupTier.bound).tostring())
		}
		else
		{
			cupTierCard.tierPercentage = Localize("#CUPS_TIER_PERCENTAGE", (cupTier.bound).tostring())
		}

		foreach( CupTierRewardData tierRewardData in cupTier.rewardData )
		{
			ItemFlavor rewardItemFlav = GetItemFlavorByAsset( tierRewardData.reward )

			
			if ( cupTierCard.tierReward == "" )
				cupTierCard.tierReward = ItemFlavor_GetRewardShortDescription( rewardItemFlav )

			if ( cupTierCard.tierReward == "" )
				cupTierCard.tierReward = ItemFlavor_GetLongName( rewardItemFlav )

			if ( cupTierCard.tierReward == "" )
				cupTierCard.tierReward = ItemFlavor_GetTypeName( rewardItemFlav )
		}

		apexCupsModel.tierList.append( cupTierCard )
	}

	RTKStruct_SetValue( apexCups, apexCupsModel )
}

void function RTKCupInfoTiers_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCupsDialog")
}

void function InitRTKCupInfoTiers( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}