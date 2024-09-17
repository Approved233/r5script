global function InitRTKCupInfoPoints
global function RTKCupInfoPoints_OnInitialize
global function RTKCupInfoPoints_OnDestroy

global struct RTKCupInfoPoints
{
	bool isCupRanked
	array< RTKSummaryBreakdownRowModel > pointList1
	array< RTKSummaryBreakdownRowModel > pointList2
	array< RTKSummaryBreakdownRowModel > additionalList
}

void function RTKCupInfoPoints_OnInitialize( rtk_behavior self )
{
	rtk_struct apexCups = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCupsDialog", "RTKCupInfoPoints" )
	RTKCupInfoPoints apexCupsModel

	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
	ItemFlavor cupItemFlavor = cupData.itemFlavor
	int midpoint = cupData.placementPoints.len() / 2

	for ( int i = 1; i <= cupData.placementPoints.len(); i++  )
	{
		RTKSummaryBreakdownRowModel summaryBreakdownModel

		summaryBreakdownModel.index		= i - 1
		summaryBreakdownModel.leftText	= Localize( "#CUPS_POSTGAME_POSITION_DATA", i )
		summaryBreakdownModel.rightText	= Localize( "#CUPS_POSTGAME_PTS", Cups_GetPointsForPlacement( cupData, i ) )

		if( i == cupData.placementPoints.len() )
		{
			summaryBreakdownModel.leftText	= Localize( "#CUPS_POINTS_LAST_PLACMENT_ROW", i )
		}

		if( summaryBreakdownModel.index <= midpoint )
		{
			apexCupsModel.pointList1.append( summaryBreakdownModel )
		}
		else
		{
			apexCupsModel.pointList2.append( summaryBreakdownModel )
		}
	}

	
	foreach ( int index, CupStatPoints statPointData in cupData.statPoints )
	{
		RTKSummaryBreakdownRowModel summaryBreakdownModel

		summaryBreakdownModel.index = index

		if( statPointData.hasStatLimit )
		{
			summaryBreakdownModel.textArgs = ( statPointData.statLimit ).tostring()
		}

		summaryBreakdownModel.leftText		= Localize( statPointData.statLocLong )
		summaryBreakdownModel.rightText		= Localize( "#CUPS_TOTAL_CUP_POINTS_VALUE", statPointData.pointsRate )

		apexCupsModel.additionalList.append( summaryBreakdownModel )
	}


		apexCupsModel.isCupRanked = RankedRumble_IsCupRankedRumble( cupData.itemFlavor )


	RTKStruct_SetValue( apexCups, apexCupsModel )
}

void function RTKCupInfoPoints_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCupsDialog")
}

void function InitRTKCupInfoPoints( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}