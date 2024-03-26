global function InitRTKPostGameCups
global function RTKPostGameCups_OnInitialize
global function RTKPostGameCups_OnDestroy


global struct RTKApexPostGameModel
{
	array< RTKPlayerDataModel >			playerDataList
	RTKApexCupTierInfo& tierInfo

	int cupCalEvent = ASSET_SETTINGS_UNIQUE_ID_INVALID
	SettingsAssetGUID apexCup
	int position = -1
	int totalPoints = -1
	int totalMatches = 0
	int matchesCompleted = 0
}

void function RTKPostGameCups_OnInitialize( rtk_behavior self )
{
	if (  Cups_GetLatestMatchSummaryData( GetLocalClientPlayer() ) == null )
	{
		self.Warn( "RTKApexCupHistory Invalid Cup ID in peristence" )
		return
	}

	SettingsAssetGUID cupId = expect LastCupMatchPlayedData( Cups_GetLatestMatchSummaryData( GetLocalClientPlayer() )).cupID
	if (!Cups_IsValidCupID(cupId))
	{
		self.Warn( "RTKApexCupHistory Invalid Cup ID" )
		return
	}

	thread RTKPostGameCups_GetCupData( self )
}

void function RTKPostGameCups_GetCupData( rtk_behavior self )
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	LastCupMatchPlayedData lastMatch = expect LastCupMatchPlayedData( Cups_GetLatestMatchSummaryData( GetLocalClientPlayer() ))
	SettingsAssetGUID cupId = lastMatch.cupID

	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexPostGameModel" )
	RTKApexPostGameModel apexCupHistoryModel

	RTKStruct_SetInt( apexCupsDataModel, "apexCup", cupId )

	
	CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	
	while ( Cups_GetSquadCupData( cupId ) == null)
	{
		WaitFrame()
	}

	CupEntry cupEntryData =  expect CupEntry ( Cups_GetSquadCupData( cupId ))

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData

	apexCupHistoryModel.playerDataList = RTKApexCupHistory_GetPlayerBreakdownData( self, cupEntryData, lastMatch.matchNum -1 )

	
	apexCupHistoryModel.totalMatches = cupBakeryData.numMatches
	apexCupHistoryModel.matchesCompleted = matchSummaries.len()
	apexCupHistoryModel.position = cupEntryData.currSquadPosition
	apexCupHistoryModel.totalPoints = cupEntryData.currSquadScore
	apexCupHistoryModel.cupCalEvent = cupBakeryData.containerItemFlavor.guid
	apexCupHistoryModel.apexCup = cupId

	RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )

	RTKApexCupGetPlayerTierData(self, cupId)
}

void function RTKPostGameCups_OnDestroy( rtk_behavior self )
{
	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCups")
}

void function InitRTKPostGameCups( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
}
