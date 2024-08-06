global function RTKMutator_ApexCupTimelineSpacing
global function RTKApexCupHistory_OnInitialize
global function RTKApexCupHistory_OnDestroy
global function InitRTKApexCupHistory
global function RTKApexCupHistory_GetPlayerBreakdownData
global function RTKApexCupHistory_RegisterOrRerollComplete

global struct  RTKApexCupHistory_Properties
{
	rtk_panel buttonList
	rtk_behavior reRollButton
}

global struct RTKApexCupMatchesInfo
{
	bool completed
	int  score
	int  matchNumber
}

global struct RTKApexCupHistoryModel
{
	array< RTKApexCupMatchesInfo > 	infoList
	array< RTKPlayerDataModel >		playerDataList

	SettingsAssetGUID 	apexCup
	RTKApexCupTierInfo& tierInfo

	int position = -1
	int totalPoints = -1
	int totalMatches = 0
	int matchesCompleted = 0
	int selectedIdx = 0
	string noMatchesText = "#CUPS_MATCHHISTORY_NO_MATCHES"

	bool showRerollButton = false
	string rerollButtonText = ""
}

struct
{
	rtk_behavior ornull activeHistoryBehavior = null

} file

void function RTKApexCupHistory_OnInitialize( rtk_behavior self )
{
	file.activeHistoryBehavior = self

	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()

	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupHistoryModel" )

	if ( Cups_IsValidCupID( cupId ))
	{
		CupBakeryAssetData cupBakeryData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
		bool cupStarted = CalEvent_HasStarted( cupBakeryData.containerItemFlavor, GetUnixTimestamp() )

		bool isCupRankedRumble = false

		isCupRankedRumble = RankedRumble_IsCupRankedRumble( cupBakeryData.itemFlavor )


		RTKStruct_SetInt( apexCupsDataModel, "apexCup", cupId )

		if ( cupStarted )
		{
			thread RTKApexCupHistory_GetHistoryData( self, isCupRankedRumble )
		}
		else
		{
			self.Message( "OnInitialize - Cup Not Started" )
			RTKApexCupHistoryModel apexCupHistoryModel
			apexCupHistoryModel.noMatchesText = isCupRankedRumble ? "#RANKED_RUMBLE_MATCHHISTORY_NOT_STARTED" : "#CUPS_MATCHHISTORY_NOT_STARTED"
			apexCupHistoryModel.apexCup = cupId
			RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )
		}
	}
	else
	{
		self.Warn( "OnInitialize - Cup ID is invalid" )
	}
}

void function RTKApexCupHistory_GetHistoryData( rtk_behavior self, bool isRankedRumble )
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()

	printt( "RTKApexCupHistory_GetHistoryData Cups_GetAllUserCupData Start :" +  cupId )
	while ( !Cups_GetAllUserCupData() )
	{
		WaitFrame()
	}
	printt( "RTKApexCupHistory_GetHistoryData Cups_GetAllUserCupData End :" +  cupId )

	if ( Cups_GetSquadCupData( cupId ) == null )
	{
		rtk_struct apexCupsDataModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "apexCups", true ) )
		self.Message( "OnInitialize - Player Not Registered To Cup" )
		RTKApexCupHistoryModel apexCupHistoryModel
		apexCupHistoryModel.noMatchesText = isRankedRumble ? "#RANKED_RUMBLE_MATCHHISTORY_NOT_ENTERED" : "#CUPS_MATCHHISTORY_NOT_ENTERED"
		apexCupHistoryModel.apexCup = cupId
		RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )
		return
	}

	rtk_struct apexCupsDataModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupHistoryModel" )
	RTKApexCupHistoryModel apexCupHistoryModel

	
	UserCupEntryData userCupData = Cups_GetPlayersPCupData( GetLocalClientPlayer(), cupId )

	
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	
	CupEntry cupEntryData =  expect CupEntry ( Cups_GetSquadCupData( cupId ))

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData

	apexCupHistoryModel.infoList = GetTimelineData( self, cupEntryData )

	int matchIndex = minint( matchSummaries.len(), cupData.numMatches  ) - 1
	apexCupHistoryModel.playerDataList = RTKApexCupHistory_GetPlayerBreakdownData( self, cupEntryData, matchIndex )
	apexCupHistoryModel.selectedIdx = matchIndex
	if ( apexCupHistoryModel.playerDataList.len() == 0 )
	{
		
		apexCupHistoryModel.apexCup = cupId
		apexCupHistoryModel.showRerollButton = false
		apexCupHistoryModel.noMatchesText = isRankedRumble ? "#RANKED_RUMBLE_MATCHHISTORY_NO_MATCHES" : "#CUPS_MATCHHISTORY_NO_MATCHES"
		RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )

		printt( "RTKApexCupHistory_GetHistoryData No Matches :" +  cupId )

		return
	}

	
	apexCupHistoryModel.apexCup = cupId
	apexCupHistoryModel.totalMatches = cupData.numMatches
	apexCupHistoryModel.matchesCompleted = matchSummaries.len()
	apexCupHistoryModel.position = cupEntryData.currSquadPosition
	apexCupHistoryModel.totalPoints = cupEntryData.currSquadScore

	
	rtk_behavior ornull reRollButton = self.PropGetBehavior( "reRollButton" )
	if ( reRollButton != null && !Cups_IsCupUseBestTen( cupId ) )
	{
		RTKApexCupHistory_InitReroll( apexCupHistoryModel, cupEntryData )

		self.AutoSubscribe( reRollButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( cupData, cupEntryData ) {
			if ( IsValidItemFlavorGUID( cupData.reRollToken.guid ) )
				OpenApexCupPurchaseRerollDialog( cupData.reRollToken, Localize ( cupData.name ), cupEntryData )
		} )
	}

	RTKStruct_SetValue( apexCupsDataModel, apexCupHistoryModel )

	InitTimelineButtons( self )

	RTKApexCupGetPlayerTierData(self, cupId)

	printt( "RTKApexCupHistory_GetHistoryData End :" +  cupId )
}

void function RTKApexCupHistory_InitReroll( RTKApexCupHistoryModel model, CupEntry cupEntryData )
{
	model.showRerollButton = false

	
	SettingsAssetGUID cupId = RTKApexCupsOverview_GetCupID()
	if ( !Cups_IsCupActive( cupId ) )
		return

	
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )
	if ( !Cups_HasParticipated( cupData.containerItemFlavor ) )
		return

	
	bool hasRerolls = ( cupData.maximumNumberOfReRolls > cupEntryData.reRollCount ) && ( cupData.maximumNumberOfReRolls > 0 ) && ( cupEntryData.matchSummaryData.len() > 0 )
	if ( !hasRerolls )
		return

	
	array <GRXScriptOffer> offers
	ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( cupData.reRollToken )
	if ( ifpi.isPurchasableAtAll )
	{
		if ( ifpi.craftingOfferOrNull != null )
			offers.append( GRX_ScriptOfferFromCraftingOffer( expect GRXScriptCraftingOffer( ifpi.craftingOfferOrNull ) ) )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
				if ( locationOffer.offerType != GRX_OFFERTYPE_BUNDLE && locationOffer.output.flavors.len() == 1 )
					offers.append( locationOffer )
	}

	
	if ( offers.len() == 0 || offers[0].prices.len() == 0 )
		return

	model.showRerollButton = true

	int numTokens = maxint( GRX_GetConsumableCount( ItemFlavor_GetGRXIndex( cupData.reRollToken ) ), 0 )
	if ( numTokens > cupEntryData.reRollCount )
		model.rerollButtonText = Localize( "#CUPS_REROLL_DIALOG_HEADER" )
	else
		model.rerollButtonText = Localize( "#CUPS_REROLL_BUTTON", GRX_GetFormattedPrice( offers[0].prices[0], 1 ) )
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
		matchInfo.matchNumber = i + 1

		retInfoList.append(matchInfo)
	}

	for ( int i = completetedNum; i < totalNumMatches; i++ )
	{
		RTKApexCupMatchesInfo matchInfo;
		matchInfo.completed = false
		matchInfo.matchNumber = i + 1
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
	RTKDataModel_SetInt( "&menus.apexCups.selectedIdx", matchIndex )
}

array< RTKPlayerDataModel > function  RTKApexCupHistory_GetPlayerBreakdownData( rtk_behavior self , CupEntry cupEntryData, int matchIndex )
{
	SettingsAssetGUID cupId = cupEntryData.cupID
	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( cupId )

	array< RTKPlayerDataModel > retPlayerDataList

	array < CupMatchSummary > matchSummaries = cupEntryData.matchSummaryData
	if ( matchIndex < 0 || matchIndex >= matchSummaries.len() )
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
		placementRow.leftText = Localize( "#CUPS_MATCHHISTORY_PLAYER_STATS_CARD_ROW", Localize ( "#CUPS_POINTS_PLACEMENT" ), ( FormatAndLocalizeNumber( "1" , float( playerData.playerPlacement ) , true ) ) )
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
					newRow.leftText =  Localize( "#CUPS_MATCHHISTORY_PLAYER_STATS_CARD_ROW", Localize ( ShStats_GenerateStatLocStringFromStatRef( statInfo.statRef ) ), ( FormatAndLocalizeNumber( "1" , float( statInfo.statChange ) , true ) ) )

					if ( statInfo.pointsGained != 0 )
						newRow.rightText =  Localize( "#PLUS_N", FormatAndLocalizeNumber( "1" , float( statInfo.pointsGained  ) , true ) )

					totalPlayerPoints += statInfo.pointsGained
				}
			}

			playerDataModel.summaryList.append( newRow )
		}

		int retrieveAttempts = 0
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( playerData.playerHardware, playerData.playerUID )
		while ( userInfoOrNull == null )
		{
			retrieveAttempts++
			if( retrieveAttempts > 10 )
			{
				Warning( "Timed out when attempting to retrieve User Info for CupHistory" )
				break
			}

			wait 0.2

			userInfoOrNull = GetUserInfo( playerData.playerHardware, playerData.playerUID )
		}

		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )

			if ( userInfo.tag != "" )
				playerDataModel.playerName = Localize("#OBIT_BRACKETED_STRING", userInfo.tag ) + " " + userInfo.name
			else
				playerDataModel.playerName = userInfo.name
		}

		playerDataModel.playerHardware = playerData.playerHardware
		playerDataModel.playerPoints = Localize( "#CUPS_PLAYER_SUMMARY_POINTS_VALUE", totalPlayerPoints.tostring() )

#if DEV
			if ( !IsValidItemFlavorCharacterRef( playerData.playerLegendName, eValidation.ASSERT ) )
				playerData.playerLegendName = "character_lifeline"
#endif

		ItemFlavor characterItemFlav = GetItemFlavorByCharacterRef( playerData.playerLegendName )
		playerDataModel.playerAssetPath = CharacterClass_GetGalleryPortrait( characterItemFlav )
		playerDataModel.playerLegendName = Localize( ItemFlavor_GetLongName( characterItemFlav ))

		retPlayerDataList.append( playerDataModel )
	}
	return retPlayerDataList
}

void function RTKApexCupHistory_RegisterOrRerollComplete()
{
	if ( file.activeHistoryBehavior )
	{
		rtk_behavior ornull activeHistoryBehavior = file.activeHistoryBehavior
		expect rtk_behavior ( activeHistoryBehavior )

		RTKApexCupHistory_OnInitialize( activeHistoryBehavior )
	}
}

void function RTKApexCupHistory_OnDestroy( rtk_behavior self )
{
	file.activeHistoryBehavior = null

	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCups")
}

void function InitRTKApexCupHistory( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK",GamemodeSelect_JumpToCups )
}


int function RTKMutator_ApexCupTimelineSpacing( int timelineWidth , int buttonWidth , int numButtons  )
{
	if ( numButtons <= 1 )
		return 0

	return	(timelineWidth / (numButtons-1) ) - buttonWidth
}

RTKSummaryBreakdownRowModel function RTKApexCupHistory_NewStatCardRow( int index )
{
	RTKSummaryBreakdownRowModel newRow
	newRow.index 		= index
	newRow.leftText 	= "#CUPS_LEADERBOARD_EMPTY_DATA"
	newRow.rightText 	= "#CUPS_LEADERBOARD_EMPTY_DATA"

	return newRow
}