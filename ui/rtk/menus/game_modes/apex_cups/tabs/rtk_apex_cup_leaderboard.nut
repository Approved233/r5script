global function RTKApexCupLeaderboard_OnInitialize
global function RTKApexCupLeaderboard_OnDestroy
global function InitRTKApexCupLeaderboard
global function RTKApexCupLeaderboard_UpdateLeaderboard

global struct RTKApexCupLeaderboardRow
{
	string playerUID = ""
	string hardware = ""
	string name = "#CUPS_LEADERBOARD_EMPTY_DATA"
	string points = "#CUPS_LEADERBOARD_EMPTY_DATA"
	int placement = -1
	int index = -1

	array <RTKSummaryBreakdownRowModel> squadStats
}

const int NUM_LEADERBOARDROWS = 10

global struct RTKApexCupLeaderboardModel
{
	int cupCalEvent = ASSET_SETTINGS_UNIQUE_ID_INVALID
	SettingsAssetGUID apexCup

	array < RTKApexCupLeaderboardRow > rows
	int selectedIdx = 0
	int showStatTable = -1
	string headerString = ""

	RTKApexCupTierInfo& tierInfo
}

global struct RTKApexCupLeaderboard_Properties
{
	rtk_panel LeaderBoardRowsList
	rtk_behavior infoButton
}

void function RTKApexCupLeaderboard_OnInitialize( rtk_behavior self )
{
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupLeaderboardModel" )

	if ( Cups_IsValidCupID(cupId ))
	{
		Cups_RegisterOnLeaderboardChangedCallback(  RTKApexCupLeaderboard_UpdateLeaderboard )
		Remote_ServerCallFunction( "ClientCallback_GetLeaderboardData", cupId,  1  , NUM_LEADERBOARDROWS )
		RTKApexCupLeaderboard_OnInitRows( self )

		Cups_RequireUpdateLeaderboard()

		CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
		bool cupStarted = CalEvent_HasStarted( cupBakeryData.containerItemFlavor, GetUnixTimestamp() )
		bool cupFinished = CalEvent_HasFinished( cupBakeryData.containerItemFlavor, GetUnixTimestamp() )

		RTKStruct_SetInt( apexCupsDataModel, "cupCalEvent", cupBakeryData.containerItemFlavor.guid )
		RTKStruct_SetInt( apexCupsDataModel, "apexCup", cupId )

		RTKStruct_SetString( apexCupsDataModel, "headerString", Localize( "#CUPS_LEADERBOARD_HEADER" ) )

		if ( cupStarted )
		{
			self.Message( "RTKApexCupLeaderboard OnInitialize - Cup Started" )
			thread RTKApexCupLeaderboard_GetPlayerTierData( self )
		}
		else
		{
			self.Message( "RTKApexCupLeaderboard OnInitialize - Cup Not Started" )
		}

		rtk_behavior ornull infoButton = self.PropGetBehavior( "infoButton" )
		if ( infoButton != null )
		{
			self.AutoSubscribe( infoButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
				UI_OpenCupInfoDialog()
			} )
		}
	}
	else
	{
		self.Warn( "RTKApexCupLeaderboard OnInitialize - Cup ID is invalid" )
	}
}

void function RTKApexCupLeaderboard_OnInitRows( rtk_behavior self )
{
	rtk_panel ornull LeaderBoardRowsList = self.PropGetPanel( "LeaderBoardRowsList" )
	if ( LeaderBoardRowsList != null )
	{
		expect rtk_panel( LeaderBoardRowsList )
		self.AutoSubscribe( LeaderBoardRowsList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {

			array< rtk_behavior > LeaderBoardRows = newChild.FindBehaviorsByTypeName( "Button" )

			foreach ( row in LeaderBoardRows )
			{
				self.AutoSubscribe( row, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex )
				{
					rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "apexCups", true ) )
					RTKStruct_SetInt( rtkModel, "selectedIdx", newChildIndex )
					RTKStruct_SetInt( rtkModel, "showStatTable", 0 )
				})
			}
		})
	}
}

table< string, int > function RTKApexCupLeaderBoard_GetSquadBreakdown( SettingsAssetGUID cupId, CupLeaderboardEntry entry )
{
	CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	table< string, int > result
	foreach ( CupMatchSummary summary in entry.matchHistoryData )
	{
		foreach ( CupsPlayerMatchSummary player in summary.playerSummaries )
		{
			if ( !( "#CUPS_POINTS_PLACEMENT" in result ) )
				result["#CUPS_POINTS_PLACEMENT"] <- Cups_GetPointsForPlacement( cupBakeryData, player.playerPlacement )
			else
				result["#CUPS_POINTS_PLACEMENT"] += Cups_GetPointsForPlacement( cupBakeryData, player.playerPlacement )

			foreach ( CupsMatchStatInformation stat in player.statInformation )
			{
				string statName = ShStats_GenerateStatLocStringFromStatRef( stat.statRef )
				if ( !( statName in result ) )
					result[statName] <- stat.pointsGained
				else
					result[statName] += stat.pointsGained
			}
		}
	}
	return result
}

RTKSummaryBreakdownRowModel function CreateBreakdownRow( int index )
{
	RTKSummaryBreakdownRowModel row
	row.index 		= index
	row.rightText = "#CUPS_LEADERBOARD_EMPTY_DATA"
	return row
}

void function RTKApexCupLeaderboard_UpdateLeaderboard( SettingsAssetGUID cupID, int start, array<CupLeaderboardEntry> entries )
{
	rtk_struct apexCupsDataModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "apexCups", true ) )

	RTKApexCupLeaderboardModel apexCupLeaderBoardModel
	RTKStruct_GetValue( apexCupsDataModel, apexCupLeaderBoardModel )

	int count = minint( entries.len(), NUM_LEADERBOARDROWS )

	
	for ( int i = 0 ; i < count ; i++ )
	{
		RTKApexCupLeaderboardRow newRow

		
		CupLeaderboardEntry entry = entries[i]
		newRow.playerUID	= entry.squadInfo[0].playerUID
		newRow.hardware		= entry.squadInfo[0].hardware
		newRow.name   		= entry.squadInfo[0].name
		newRow.points 		= entry.squadScore == -1 ? Localize( "#CUPS_LEADERBOARD_EMPTY_DATA" ) : FormatAndLocalizeNumber( "1" , float(entry.squadScore), true )
		newRow.placement 	= start + ( i + 1 )
		newRow.index 		= i

		
		int idx = 0
		foreach ( key, value in RTKApexCupLeaderBoard_GetSquadBreakdown( cupID, entry ) )
		{
			RTKSummaryBreakdownRowModel statRow = CreateBreakdownRow( idx )
			statRow.leftText = key
			if ( value > 0 )
				statRow.rightText = FormatAndLocalizeNumber( "1" , float(value), true )
			newRow.squadStats.append( statRow )
			idx++
		}
		apexCupLeaderBoardModel.rows.append( newRow )
	}

	
	for ( int i = count; i < NUM_LEADERBOARDROWS; ++i )
	{
		RTKApexCupLeaderboardRow row
		row.playerUID 	= ""
		row.hardware 	= ""
		row.name  		= ""
		row.points 		= "#CUPS_LEADERBOARD_EMPTY_DATA"
		row.placement 	= start + ( i + 1 )
		row.index 		= i

		apexCupLeaderBoardModel.rows.append( row )
	}

	RTKStruct_SetValue( apexCupsDataModel, apexCupLeaderBoardModel )

	
	RTKStruct_SetInt( apexCupsDataModel, "selectedIdx", 0 )
	RTKStruct_SetInt( apexCupsDataModel, "showStatTable", 0 )
}

void function RTKApexCupLeaderboard_GetPlayerTierData( rtk_behavior self )
{
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	while ( !Cups_GetAllUserCupData() )
	{
		WaitFrame()
	}
	if ( Cups_GetSquadCupData( cupId ) == null )
		return

	CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
	CupEntryRestrictions restriction = cupBakeryData.entryRestrictions
	if ( restriction.hasMinRankLimit )
	{
		rtk_struct apexCupsDataModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "apexCups", true ) )
		RTKStruct_SetString( apexCupsDataModel, "headerString", Localize( "#CUPS_LEADERBOARD_RANKED_HEADER", Localize( restriction.minRankString ) ) )
	}

	RTKApexCupTierInfo tierInfo
	tierInfo.apexCup = cupId

	CupEntry cupEntryData  = expect CupEntry ( Cups_GetSquadCupData( cupId ))
	tierInfo.currentPoints = cupEntryData.currSquadScore
	tierInfo.tierIndex     = Cups_GetPlayerTierIndexForCup( cupId )

	if( cupEntryData.tierScoreBounds.len() > 0 )
	{
		tierInfo.targetPoints  = cupEntryData.tierScoreBounds[ maxint( 0, tierInfo.tierIndex - 1 ) ]
	}

	tierInfo.lowerBounds   = tierInfo.tierIndex <  cupEntryData.tierScoreBounds.len() ? cupEntryData.tierScoreBounds[tierInfo.tierIndex] : 0
	tierInfo.isTop100	   = tierInfo.tierIndex == 0

	
	if ( tierInfo.isTop100 )
		tierInfo.targetPoints = tierInfo.currentPoints

	
	if ( tierInfo.isTop100 )
	{
		tierInfo.positionPercentage = cupEntryData.currSquadPosition
	}
	else
	{
		tierInfo.positionPercentage = Cups_CalculatePositionPercentageDisplay( cupId, cupEntryData )
	}

	rtk_struct tierModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "tierInfo", true, [ "apexCups" ] ) )
	RTKStruct_SetValue( tierModel, tierInfo )
}

void function RTKApexCupLeaderboard_OnDestroy( rtk_behavior self )
{
	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCups" )
	Cups_UnRegisterOnLeaderboardChangedCallback(RTKApexCupLeaderboard_UpdateLeaderboard )
}

void function InitRTKApexCupLeaderboard( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", GamemodeSelect_JumpToCups )
}

