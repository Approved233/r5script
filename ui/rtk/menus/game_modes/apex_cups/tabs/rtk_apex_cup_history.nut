global function RTKMutator_ApexCupTimelineSpacing
global function RTKApexCupHistory_OnInitialize
global function RTKApexCupHistory_OnDestroy
global function InitRTKApexCupHistory
global function RTKApexCupHistory_GetPlayerBreakdownData

global struct  RTKApexCupHistory_Properties
{
	rtk_panel buttonList
}

global struct RTKApexCupMatchesInfo
{
	bool isLastMatch
	bool completed
	int  score
	int  matchNumber
}

global struct RTKApexCupHistoryModel
{
	array< RTKApexCupMatchesInfo > 	infoList
	array< RTKPlayerDataModel >		playerDataList

	SettingsAssetGUID 	cupId
	RTKApexCupTierInfo& tierInfo

	int position = -1
	int totalPoints = -1
	int totalMatches = 0
	int matchesCompleted = 0
	string noMatchesText = "#CUPS_MATCHHISTORY_NO_MATCHES"
}

void function RTKApexCupHistory_OnInitialize( rtk_behavior self )
{
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()

	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupHistoryModel" )

	if ( Cups_IsValidCupID(cupId ))
	{
		CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
		bool cupStarted = CalEvent_HasStarted( cupBakeryData.containerItemFlavor, GetUnixTimestamp() )

		if ( cupStarted && ( Cups_GetPlayersPDataIndexForCupID(  GetLocalClientPlayer() , cupId) != -1 ))
		{
			thread RTKApexCupHistory_GetHistoryData( self )
		}
		else if ( cupStarted == false)
		{
			self.Message( "RTKApexCupHistory OnInitialize - Cup Not Started" )
			RTKApexCupHistoryModel apexCupHistoryModel
			apexCupHistoryModel.noMatchesText = "#CUPS_MATCHHISTORY_NOT_STARTED"
			apexCupHistoryModel.cupId = cupId
			RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )
		}
		else
		{
			self.Message( "RTKApexCupHistory OnInitialize - Player Not Registered To Cup" )
			RTKApexCupHistoryModel apexCupHistoryModel
			apexCupHistoryModel.noMatchesText = "#CUPS_MATCHHISTORY_NOT_ENTERED"
			apexCupHistoryModel.cupId = cupId
			RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )
		}
	}
	else
	{
		self.Warn( "RTKApexCupHistory OnInitialize - Cup ID is invalid" )
	}
}

void function RTKApexCupHistory_GetHistoryData(rtk_behavior self)
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()

	while ( Cups_GetSquadCupData( cupId ) == null)
	{
		WaitFrame()
	}

	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupHistoryModel" )
	RTKApexCupHistoryModel apexCupHistoryModel

	
	UserCupEntryData userCupData = Cups_GetPlayersPCupData( GetLocalClientPlayer(), cupId )

	
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	
	CupEntry cupEntryData =  expect CupEntry ( Cups_GetSquadCupData( cupId ))

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData

	apexCupHistoryModel.infoList       = GetTimelineData( self, cupEntryData )

	apexCupHistoryModel.playerDataList = RTKApexCupHistory_GetPlayerBreakdownData( self, cupEntryData, 0 )
	if ( apexCupHistoryModel.playerDataList.len() == 0 )
	{
		
		apexCupHistoryModel.cupId = cupId
		RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )
		return
	}

	
	apexCupHistoryModel.cupId = cupId
	apexCupHistoryModel.totalMatches = cupData.numMatches
	apexCupHistoryModel.matchesCompleted = matchSummaries.len()
	apexCupHistoryModel.position = cupEntryData.currSquadPosition
	apexCupHistoryModel.totalPoints = cupEntryData.currSquadScore

	RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )

	InitTimelineButtons( self )

	RTKApexCupGetPlayerTierData(self, cupId)
}

array< RTKApexCupMatchesInfo > function GetTimelineData( rtk_behavior self,  CupEntry cupEntryData )
{
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
	array< RTKApexCupMatchesInfo > retInfoList;

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData

	int totalNumMatches = cupData.numMatches
	int completetedNum = minint( matchSummaries.len(), totalNumMatches  )

	for ( int i = 0 ; i < completetedNum ; i++ )
	{
		RTKApexCupMatchesInfo matchInfo;
		matchInfo.completed = true
		int playerplacement = matchSummaries[i].playerSummaries[0].playerPlacement
		int placementPoints = Cups_GetPointsForPlacement( cupData, playerplacement )
		matchInfo.score = matchSummaries[i].squadCalculatedScore + placementPoints
		matchInfo.matchNumber = (completetedNum ) - i
		matchInfo.isLastMatch = i == totalNumMatches - 1

		retInfoList.append(matchInfo)
	}
	retInfoList.reverse()

	for ( int i = completetedNum; i < totalNumMatches; i++ )
	{
		RTKApexCupMatchesInfo matchInfo;
		matchInfo.completed = false
		matchInfo.matchNumber = i + 1
		matchInfo.isLastMatch = i == totalNumMatches - 1
		retInfoList.append(matchInfo)
	}

	return	retInfoList
}


void function InitTimelineButtons( rtk_behavior self )
{

	rtk_panel ornull buttonList = self.PropGetPanel( "buttonList" )

	if ( buttonList != null )
	{
		expect rtk_panel( buttonList )
		self.AutoSubscribe( buttonList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {

			array< rtk_behavior > buttons = newChild.FindBehaviorsByTypeName( "Button" )

			foreach ( button in buttons  )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
					SetSelectedMatch(self, newChildIndex)
				} )
			}
		} )
	}
}

void function SetSelectedMatch( rtk_behavior self , int matchIndex )
{
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	CupEntry cupEntryData =  expect CupEntry ( Cups_GetSquadCupData( cupId ))

	
	rtk_array playerDataList_RTK = RTKDataModel_GetArray( "&menus.apexCups.playerDataList" )
	array< RTKPlayerDataModel > playerDataList_Script = RTKApexCupHistory_GetPlayerBreakdownData(self, cupEntryData, matchIndex)
	RTKArray_SetValue( playerDataList_RTK, playerDataList_Script )
}

array< RTKPlayerDataModel > function  RTKApexCupHistory_GetPlayerBreakdownData( rtk_behavior self , CupEntry cupEntryData,  int matchIndex )
{
	SettingsAssetGUID cupId = cupEntryData.cupID
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	array< RTKPlayerDataModel > retPlayerDataList

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData
	if ( matchSummaries.len() <= matchIndex )
	{
		return retPlayerDataList
	}

	CupMatchSummary summary = matchSummaries[matchIndex]

	foreach( CupsPlayerMatchSummary playerData in summary.playerSummaries )
	{
		RTKPlayerDataModel playerDataModel

		int totalPlayerPoints = 0
		int numStats = playerData.statInformation.len()

		RTKSummaryBreakdownRowModel placementRow = RTKApexCupHistory_NewStatCardRow( 0 )
		placementRow.leftText = Localize( "#CUPS_MATCHHISTORY_PLAYER_STATS_CARD_ROW", Localize ( "#CUPS_POINTS_PLACEMENT" ), playerData.playerPlacement )
		int placementPoints = Cups_GetPointsForPlacement( cupData, playerData.playerPlacement )
		placementRow.rightText = Localize( "#PLUS_N", FormatAndLocalizeNumber( "1" , float( placementPoints ) , true ) )
		playerDataModel.summaryList.append( placementRow )
		totalPlayerPoints += placementPoints

		for ( int i = 0; i < numStats; i++  )
		{
			RTKSummaryBreakdownRowModel newRow = RTKApexCupHistory_NewStatCardRow( i + 1 )

			CupsMatchStatInformation statInfo = playerData.statInformation[i]

			foreach ( CupStatPoints statPoints in cupData.statPoints )
			{
				if ( statPoints.statRef == statInfo.statRef )
				{
					newRow.leftText =  Localize( "#CUPS_MATCHHISTORY_PLAYER_STATS_CARD_ROW", Localize ( ShStats_GenerateStatLocStringFromStatRef( statInfo.statRef ) ), statInfo.statChange )

					if ( statInfo.pointsGained != 0 )
						newRow.rightText =  Localize( "#PLUS_N", FormatAndLocalizeNumber( "1" , float( statInfo.pointsGained  ) , true ) )

					totalPlayerPoints += statInfo.pointsGained
				}
			}

			playerDataModel.summaryList.append( newRow )
		}

		while ( playerDataModel.summaryList.len() < 7 )
		{
			RTKSummaryBreakdownRowModel newRow = RTKApexCupHistory_NewStatCardRow( playerDataModel.summaryList.len() )
			playerDataModel.summaryList.append( newRow )
		}

		CommunityUserInfo userInfo = expect CommunityUserInfo( GetUserInfo( playerData.playerHardware, playerData.playerUID ) )

		if ( userInfo.tag != "" )
			playerDataModel.playerName = Localize("#OBIT_BRACKETED_STRING", userInfo.tag ) + " " + userInfo.name
		else
			playerDataModel.playerName = userInfo.name
		playerDataModel.playerHardware = playerData.playerHardware
		playerDataModel.playerPoints = Localize( "#CUPS_TOTAL_CUP_POINTS_VALUE", totalPlayerPoints.tostring() )
		playerDataModel.playerAssetPath = CharacterClass_GetGalleryPortrait ( GetItemFlavorByCharacterRef( playerData.playerLegendName ) )
		playerDataModel.playerLegendName = Localize( "#"+ playerData.playerLegendName + "_NAME" )

		retPlayerDataList.append( playerDataModel )
	}
	return retPlayerDataList
}

void function RTKApexCupHistory_OnDestroy( rtk_behavior self )
{
	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCups")
}

void function InitRTKApexCupHistory( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK",GamemodeSelect_JumpToCups )
}


int function RTKMutator_ApexCupTimelineSpacing( int timelineWidth , int buttonWidth , int numButtons  )
{
	return	(timelineWidth / (numButtons-1) ) - buttonWidth
}

RTKSummaryBreakdownRowModel function RTKApexCupHistory_NewStatCardRow( int index )
{
	RTKSummaryBreakdownRowModel newRow
	newRow.index 		= index
	newRow.rowBGAlpha 	= 0.6
	newRow.leftText 	= "#CUPS_LEADERBOARD_EMPTY_DATA"
	newRow.rightText 	= "#CUPS_LEADERBOARD_EMPTY_DATA"
	newRow.rowSize 		= 457
	newRow.textSize 	= 24

	return newRow
}