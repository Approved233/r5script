global function ShSpawnSquadSkyDive_Init
global function SpawnGroupSkydive_GetSquadSpawnDelay
global function SpawnGroupSkydive_SetCallback_GetSquadSpawnDelay













global function SpawnSquadSkyDive_GetRemainingRespawnsForPlayer
global function SpawnSquadSkyDive_GetRemainingRespawnsForAllPlayersInSquad
global function SpawnGroupSkydive_ShouldTeamHavePoolOfRespawns





struct
{
	float functionref( int ) GetSquadSpawnDelay_Callback






} file

void function ShSpawnSquadSkyDive_Init()
{
	if ( GetRespawnStyle() != eRespawnStyle.SPAWN_GROUP_SKYDIVE )
		return
	print( "Respawn style is SPAWN_GROUP_SKYDIVE\n" )















}

































int function SpawnSquadSkyDive_GetRemainingRespawnsForAllPlayersInSquad( int team )
{
	
	int teamRespawnsCount = GetStartingRespawnCount()
	if ( teamRespawnsCount < 0 )
		return teamRespawnsCount

	
	teamRespawnsCount = 0
	array < entity > teammates = GetPlayerArrayOfTeam( team )

	foreach ( teammate in teammates )
	{
		teamRespawnsCount += SpawnSquadSkyDive_GetRemainingRespawnsForPlayer( teammate )
	}

	return teamRespawnsCount
}


int function SpawnSquadSkyDive_GetRemainingRespawnsForPlayer( entity player )
{
	if ( !IsValid( player ) )
		return 0

	return player.GetPlayerNetInt( "respawnsRemaining" )
}








































































































































































































































































































































































































































float function SpawnGroupSkydive_GetSquadSpawnDelay( int team )
{
	float spawnDelay = GetCurrentPlaylistVarFloat( "respawn_cooldown", 5.0 )

	if ( file.GetSquadSpawnDelay_Callback != null )
		spawnDelay = file.GetSquadSpawnDelay_Callback( team )

	return spawnDelay
}


void function SpawnGroupSkydive_SetCallback_GetSquadSpawnDelay( float functionref( int ) func )
{
	Assert( file.GetSquadSpawnDelay_Callback == null )
	file.GetSquadSpawnDelay_Callback = func
}




















bool function SpawnGroupSkydive_ShouldTeamHavePoolOfRespawns()
{
	return GetCurrentPlaylistVarBool( "spawn_group_skydive_use_team_lives_pool", false )
}






bool function SpawnGroupSkydive_ShouldAllDeadPlayersSpawnTogether()
{
	return GetCurrentPlaylistVarBool( "spawn_group_skydive_spawn_all_players_together", false )
}




float function SpawnGroupSkydive_MinSpawnCooldownTime()
{
	return GetCurrentPlaylistVarFloat( "spawn_group_skydive_min_respawn_cooldown", 1.0 )
}