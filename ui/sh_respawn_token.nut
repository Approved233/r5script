global function GetPlaylistVar_RespawnTokenEnabled












global function Respawn_Token_CanLocalPlayerRespawn
global function Respawn_Token_CanLocalPlayerRespawnOrIsRespawning
global function Respawn_Token_SetCanLocalPlayerRespawn









































global enum eRespawnTokenType
{
	INVALID = -1,
	INDIVIDUAL,  
	SQUAD,       
	BANK,        
	_COUNT
}

struct
{





	int  squadRespawnTokens = 0
	int  squadRespawnTokensViewPlayer = 0
	int  lastSquadRespawnTokenAnnouncement = -1
	bool canRespawn = false
	bool isRespawning = false






} file





































































































































































































































































































bool function Respawn_Token_CanLocalPlayerRespawn()
{
	return file.canRespawn
}



bool function Respawn_Token_CanLocalPlayerRespawnOrIsRespawning()
{
	return file.canRespawn || file.isRespawning
}



void function Respawn_Token_SetCanLocalPlayerRespawn( bool isRespawning, bool canRespawn )
{
	file.isRespawning = isRespawning
	file.canRespawn = canRespawn
}















































































































































































































































































































































int function RespawnTokensToStrikes( int respawnTokens )
{
	
	const int MAX_STRIKES = 3

	int strikes = minint( MAX_STRIKES - respawnTokens - 1, 3 )
	return maxint( strikes, 0 )
}

bool function GetPlaylistVar_RespawnTokenEnabled()
{
	return GetCurrentPlaylistVarBool( "respawn_token_enabled", false )
}

int function GetPlaylistVar_RespawnTokenType()
{
	string playlistTokenType = GetCurrentPlaylistVarString( "respawn_token_type", "" ).tolower()

	int tokenType = eRespawnTokenType.INVALID
	bool typeFound = false
	for( int i = 0; i < eRespawnTokenType._COUNT; i++ )
	{
		string enumType = GetEnumString( "eRespawnTokenType", i ).tolower()
		if ( enumType.tolower() == playlistTokenType )
		{
			tokenType = i
			typeFound = true
			break
		}
	}

	Assert( typeFound, "Playlist Respawn Token type '" + playlistTokenType + "' is not a specified enumerator." )

	return tokenType
}

bool function GetPlaylistVar_AmmoOnKillEnabled()
{
	return GetCurrentPlaylistVarBool( "respawn_token_ammo_on_kill_enabled", false )
}

float function GetPlaylistVar_AmmoOnKillMultiplier()
{
	return GetCurrentPlaylistVarFloat( "respawn_token_ammo_on_kill_multiplier", 1.0 )
}

int function GetPlaylistVar_AmmoOnKillBoxesToSpawn()
{
	return GetCurrentPlaylistVarInt( "respawn_token_ammo_on_kill_spawns", 4 )
}

bool function GetPlaylistVar_ArmorOnKillEnabled()
{
	return GetCurrentPlaylistVarBool( "respawn_token_armor_on_kill_enabled", false )
}

bool function GetPlaylistVar_PingDeathLocationEnabled()
{
	return GetCurrentPlaylistVarBool( "respawn_token_ping_death_location", false )
}

int function GetPlaylistVar_RespawnDisabledDeathstage()
{
	return GetCurrentPlaylistVarInt( "respawn_token_respawn_disable_deathstage_close", 4 )
}

int function GetPlaylistVar_XPForRespawnToken()
{
	return GetCurrentPlaylistVarInt( "respawn_token_xp_for_respawn_token", 500 )
}

bool function GetPlaylistVar_TakeTokenOnDisconnect()
{
	return GetCurrentPlaylistVarBool( "respawn_token_take_token_on_disconnect", false )
}

bool function GetPlaylistVar_KillPlayerOnDisconnect()
{
	return GetCurrentPlaylistVarBool( "respawn_token_kill_player_on_disconnect", false )
}
