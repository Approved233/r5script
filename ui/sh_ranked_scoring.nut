
global function Sh_RankedScoring_Init
global function Ranked_GetPointsForPlacement
global function Ranked_GetPenaltyPointsForAbandon
global function Ranked_GetParticipationMutlipler
global function Ranked_GetNumProvisionalMatchesCompleted
global function Ranked_GetNumProvisionalMatchesRequired
global function Ranked_HasCompletedProvisionalMatches






global function LoadLPBreakdownFromPersistance

global function GetHighEndLostMultiplier

global const RANKED_LP_PROMOTION_BONUS = 250
global const RANKED_LP_DEMOTION_PENALITY = 150
global const float PARTICIPATION_MODIFIER = 0.5
global const int RANKED_NUM_PROVISIONAL_MATCHES = 10
global const float HIGH_END_LOST_MULTIPLIER = 1.5

global struct RankLadderPointsBreakdown
{
	
	

	bool isHighTier
	bool wasInProvisonalGame			
	bool wasAbandoned					
	bool lossForgiveness				
	int  damage							

	int  knockdown						
	int  knockdownAssist				

	int kills							
	int assists							
	int participation					

	int killsUnique = 0					
	int assistUnique = 0				
	int participationUnique = 0			

	int placement						
	int totalSquads						
	int placementScore					











	
	

	int killBonus = 0                      
	int convergenceBonus = 0               
	int skillDiffBonus = 0                 
	int provisionalMatchBonus = 0               
	int promotionBonus = 0							

	int demotionPenality = 0						
	int penaltyPointsForAbandoning = 0				
	int demotionProtectionAdjustment = 0			
	int lossProtectionAdjustment = 0				

	int highEndAdjustment = 0    

	
	int startingLP
	int netLP
	int finalLP


		int trialState = 0 

}

global struct RankedPlacementScoreStruct
{
	
	int   placementPosition
	int   placementPoints



}

struct
{
	array< RankedPlacementScoreStruct > placementScoringData
} file


void function Sh_RankedScoring_Init()
{
	Ranked_InitPlacementScoring()
}

void function Ranked_InitPlacementScoring()
{
	
	var dataTable = GetDataTable( $"datatable/ranked_placement_scoring.rpak" ) 
	int numRows   = GetDataTableRowCount( dataTable )

	file.placementScoringData.clear()








	for ( int i = 0; i < numRows; ++i )
	{
		RankedPlacementScoreStruct placementScoringData
		placementScoringData.placementPosition            = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "placement" ) )
		placementScoringData.placementPoints              = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "placementPoints" ) )



		file.placementScoringData.append( placementScoringData )







	}
}


bool function Ranked_HasCompletedProvisionalMatches( entity player )
{
	return ( Ranked_GetNumProvisionalMatchesCompleted( player ) >= Ranked_GetNumProvisionalMatchesRequired() )
}

int function Ranked_GetNumProvisionalMatchesRequired()
{
	if ( GetConVarBool( "ranked_disable_placement_matches" ) )
		return 0

	return GetCurrentPlaylistVarInt( "ranked_num_provisional_matches", RANKED_NUM_PROVISIONAL_MATCHES )
}

int function Ranked_GetNumProvisionalMatchesCompleted( entity player )
{

	if ( !IsFullyConnected() )
		return 0








	return Ranked_GetXProgMergedPersistenceData( player, RANKED_PROVISIONAL_MATCH_COUNT_PERSISTENCE_VAR_NAME )








	unreachable
}

int function Ranked_GetPointsForPlacement( int placement )
{
	int lookupPlacement    = minint( file.placementScoringData.len() - 1, placement )
	int csvValue           = file.placementScoringData[ lookupPlacement ].placementPoints
	string playlistVarName = "rankedPointsForPlacement_" + lookupPlacement

	return GetCurrentPlaylistVarInt( playlistVarName, csvValue )
}



















float function Ranked_GetParticipationMutlipler( )
{
	return GetCurrentPlaylistVarFloat( "ranked_participation_mod", PARTICIPATION_MODIFIER )
}

int function Ranked_GetPenaltyPointsForAbandon( )
{
	
	string playlistVarString      = "ranked_abandon_cost"
	return GetCurrentPlaylistVarInt( playlistVarString, Ranked_GetCostForEntry() )
}



















































void function LoadLPBreakdownFromPersistance ( RankLadderPointsBreakdown breakdown , entity player)
{
	
	
	
	

	string myName 					   	   = GetPlayerName()
	int mySquadIndex					   = -1
	int maxTrackedSquadMembers 			   = PersistenceGetArrayCount( "lastGameSquadStats" )
	for ( int i = 0 ; i < maxTrackedSquadMembers ; i++ )
	{

		string squadMemberName = expect string( player.GetPersistentVar( "lastGameSquadStats[" + i + "].playerName" ) )
		if ( squadMemberName == myName )
		{
			mySquadIndex = i
			break
		}
	}

	if ( mySquadIndex >= 0 )
	{
		breakdown.kills 				   = GetPersistentVarAsInt( "lastGameSquadStats[" + mySquadIndex + "].kills" )
		breakdown.assists 				   = GetPersistentVarAsInt( "lastGameSquadStats[" + mySquadIndex + "].assists" )
		breakdown.participationUnique  	   = GetRankedGameData( player, "lastGameParticipationCount" )
	}

	breakdown.wasAbandoned 				   =  bool ( GetRankedGameData( player,  "lastGameRankedAbandon" ) )
	breakdown.placement 				   = player.GetPersistentVarAsInt( "lastGameRank" )
	breakdown.totalSquads				   = player.GetPersistentVarAsInt( "lastGameSquads" )
	breakdown.placementScore 			   = GetRankedGameData( player, "lastGamePlacementScore" )

	breakdown.wasInProvisonalGame          = Ranked_GetNumProvisionalMatchesCompleted( player ) <= Ranked_GetNumProvisionalMatchesRequired()
	breakdown.penaltyPointsForAbandoning   = GetRankedGameData( player,  "lastGamePenaltyPointsForAbandoning" )
	breakdown.lossProtectionAdjustment     = GetRankedGameData ( player, "lastGameLossProtectionAdjustment"  )
	breakdown.demotionProtectionAdjustment = GetRankedGameData ( player, "lastGameTierDerankingProtectionAdjustment" )
	breakdown.startingLP                   = GetRankedGameData ( player, "lastGameStartingScore" )
	breakdown.netLP 					   = GetRankedGameData ( player, "lastGameScoreDiff" )

	breakdown.killBonus                    = GetRankedGameData ( player, "lastGameBonus[0]" )
	breakdown.convergenceBonus             = GetRankedGameData ( player, "lastGameBonus[1]" )
	breakdown.skillDiffBonus               = GetRankedGameData ( player, "lastGameBonus[2]" )
	breakdown.provisionalMatchBonus        = GetRankedGameData ( player, "lastGameBonus[3]" )
	breakdown.highEndAdjustment            = GetRankedGameData ( player, "lastGameBonus[4]" )
	breakdown.promotionBonus               = GetRankedGameData ( player, "lastGameBonus[5]" )

	breakdown.finalLP 					   = breakdown.startingLP + breakdown.netLP

	breakdown.demotionPenality 			   = ( GetCurrentRankedDivisionFromScore( breakdown.finalLP ).tier.index  < GetCurrentRankedDivisionFromScore( breakdown.startingLP ).tier.index )
													? GetCurrentPlaylistVarInt ( "ranked_tier_demotion_penality", RANKED_LP_DEMOTION_PENALITY )
													: 0


		breakdown.trialState = GetRankedGameData( player, RANKED_TRIALS_PERSISTENCE_STATE_KEY )


#if DEV
		PrintRankLadderPointsBreakdown (breakdown, 1, "LoadLPBreakdownFromPersistance" )
#endif
}


float function GetHighEndLostMultiplier ()
{
	return GetCurrentPlaylistVarFloat( "ranked_tuning_var_high_end_multiplier", HIGH_END_LOST_MULTIPLIER ) 
}