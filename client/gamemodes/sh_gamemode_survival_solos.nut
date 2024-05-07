


global function Sh_Survival_Solos_Init
global function Sh_Survival_Solos_IsPlayerRespawnDisabled








global function Survival_Solos_CanLocalPlayerRespawn
global function Survival_Solos_CanLocalPlayerRespawnOrIsRespawning
global function Survival_Solos_SetCanLocalPlayerRespawn



global function Survival_Solos_Announcement_SquadElimination
global function Survival_Solos_Announcement_RespawnsDisabled
global function Survival_Solos_UpdateRui_OnReconnect
global function Survival_Solos_SetDeathScreenCallbacks



const string NETFUNC_ANNOUNCEMENT_SQUAD_ELIMINATION = "Survival_Solos_Announcement_SquadElimination"
const string NETFUNC_ANNOUNCEMENT_RESPAWNS_DISABLED = "Survival_Solos_Announcement_RespawnsDisabled"
const string NETFUNC_UPDATERUI_ON_RECONNECT = "Survival_Solos_UpdateRui_OnReconnect"
const string NETFUNC_SET_DEATH_SCREEN_CALLBACKS = "Survival_Solos_SetDeathScreenCallbacks"








const string NETVAR_SQUAD_LIVES = "Squad_Lives"
const string NETVAR_RESPAWN_DISABLED = "Squad_Respawn_Disabled"

const float TIME_ANNOUNCEMENT_RESPAWN_DISABLED = 7.0
const float TIME_ANNOUNCEMENT_SQUAD_ELIMINATED = 4.0
const float TIME_ANNOUNCEMENT_SQUAD_LIVES_REMAINING = 7.0

const int PRIORITY_ANNOUNCEMENT_SQUAD_LIVES_REMAINING = 1000







const string RUIVAR_SQUAD_LIVES = "squadStrikes"
const string RUIVAR_LIVES_HEADER_LABEL = "headerLabel"
const string RUIVAR_RESPAWN_DISABLED = "respawnsDisabled"
const string RUIVAR_DEATH_SCREEN_TITLE = "headerText"
const string RUIVAR_DEATH_SCREEN_KILLS = "killsText"
const string RUIVAR_DEATH_SCREEN_SCORE_LOSE = "losingScore"
const string RUIVAR_DEATH_SCREEN_SCORE_WIN = "winningScore"

const string TEXT_MODE_SOLOS = "#SURVIVAL_MODE_SOLOS"
const string TEXT_MODE_SOLOS_SUB = "#SURVIVAL_MODE_SOLOS_DESCRIPTION_2"
const string TEXT_MODE_SOLOS_RESPAWNS_REMAINING = "#SURVIVAL_MODE_SOLOS_RESPAWNS_REMAINING"
const string TEXT_MODE_SOLOS_RESPAWN_REMAINING = "#SURVIVAL_MODE_SOLOS_RESPAWN_REMAINING"
const string TEXT_MODE_SOLOS_FINAL_RESPAWN = "#SURVIVAL_MODE_SOLOS_FINAL_RESPAWN"
const string TEXT_MODE_SOLOS_RESPAWNS_REMAINING_LABEL = "#SURVIVAL_MODE_SOLOS_RESPAWNS_REMAINING_LABEL"
const string TEXT_RESPAWN_DISABLED = "RESPAWNING DISABLED"
const string TEXT_RESPAWN_DISABLED_SUB = "Tokens have been converted to XP"
const string TEXT_SQUAD_PLACEMENT_WIN = "#SQUAD_PLACEMENT_GCARDS_TITLE"
const string TEXT_SQUAD_PLACEMENT_LOSE = "#SQUAD_HEADER_DEFEAT"
const string TEXT_SQUAD_PLACEMENT_KILLS = "#DEATH_SCREEN_SUMMARY_KILLS"
const string TEXT_DEATH_SCREEN_SUMMARY_KILLS = "#DEATH_SCREEN_SUMMARY_KILLS"
const string TEXT_DEATH_SCREEN_SUMMARY_ASSISTS = "#DEATH_SCREEN_SUMMARY_ASSISTS"
const string TEXT_DEATH_SCREEN_SUMMARY_KNOCKDOWNS = "#DEATH_SCREEN_SUMMARY_KNOCKDOWNS"
const string TEXT_DEATH_SCREEN_SUMMARY_DAMAGE = "#DEATH_SCREEN_SUMMARY_DAMAGE_DEALT"
const string TEXT_DEATH_SCREEN_SUMMARY_TIME = "#DEATH_SCREEN_SUMMARY_SURVIVAL_TIME"
const string TEXT_DEATH_SCREEN_SUMMARY_REVIVES = "#DEATH_SCREEN_SUMMARY_REVIVES"
const string TEXT_DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_USED = "#DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_USED"
const string TEXT_DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_REMAINING = "#DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_REMAINING"

const string SFX_SQUAD_LIVES_REMAINING_TWO = "UI_3Strikes_Widget_Stinger_Strike1"
const string SFX_SQUAD_LIVES_REMAINING_ONE = "UI_3Strikes_Widget_Stinger_Strike1"
const string SFX_SQUAD_LIVES_REMAINING_ZERO = "UI_3Strikes_Widget_Stinger_Strike1"
const string SFX_SQUAD_ELIMINATED = "UI_3Strikes_EnemySquadEliminated"
const string SFX_RESPAWN_DISABLED = "UI_3Strikes_RespawningDisabled"


struct
{

		int squadLives = 0
		int squadLivesViewPlayer = 0
		int lastSquadLifeAnnouncement = -1
		bool soloSplashAnnounceDisplayed = false
		bool localPlayerCanRespawn = false
		bool localPlayerCanRespawnOrIsRespawning = false







		var nestedRespawnTokenRui
		var nestedSquadLivesRui
		bool squadEliminated = false

} file




global enum eSurvivalSolosStat {
	EXTRA_LIVES_USED = 5,
	EXTRA_LIVES_PRESERVED = 6,
}


void function Sh_Survival_Solos_Init()
{
	if ( !IsSoloMode() )
	{
		return
	}

	Sh_Survival_Solos_RegisterNetworking()

















		RegisterNetVarIntChangeCallback( NETVAR_SQUAD_LIVES, Survival_Solos_SquadLivesChanged )

		Announcements_SetOnSetupAnnouncement_RemainingRespawns( Survival_Solos_OnSetupAnnouncement_RemainingRespawns )

		AddCallback_PlayerFreefallActiveChanged( Survival_Solos_PlayerFreefallActiveChanged )

		DeathScreen_SetIsPlayerWaitingForRespawnFunc( Survival_Solos_IsPlayerWaitingForRespawn )

		Survival_Solos_OverrideGameState()

}



void function Sh_Survival_Solos_RegisterNetworking()
{
	RegisterNetworkedVariable( NETVAR_SQUAD_LIVES, SNDC_PLAYER_EXCLUSIVE, SNVT_INT, 0.0 )
	RegisterNetworkedVariable( NETVAR_RESPAWN_DISABLED, SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )

	Remote_RegisterClientFunction( NETFUNC_ANNOUNCEMENT_SQUAD_ELIMINATION )
	Remote_RegisterClientFunction( NETFUNC_ANNOUNCEMENT_RESPAWNS_DISABLED )
	Remote_RegisterClientFunction( NETFUNC_UPDATERUI_ON_RECONNECT )
	Remote_RegisterClientFunction( NETFUNC_SET_DEATH_SCREEN_CALLBACKS )
}



bool function Sh_Survival_Solos_IsPlayerRespawnDisabled( entity player )
{
	return player.GetPlayerNetBool( NETVAR_RESPAWN_DISABLED )
}
































































































































































































bool function Survival_Solos_CanLocalPlayerRespawn()
{
	if ( !IsValid( GetLocalClientPlayer() ) )
	{
		return false
	}

	return file.localPlayerCanRespawn
}

bool function Survival_Solos_CanLocalPlayerRespawnOrIsRespawning()
{
	if ( !IsValid( GetLocalClientPlayer() ) )
	{
		return false
	}

	return file.localPlayerCanRespawnOrIsRespawning
}

void function Survival_Solos_SetCanLocalPlayerRespawn(bool localPlayerCanRespawnOrIsRespawning = false, bool localPlayerCanRespawn = false)
{
	file.localPlayerCanRespawnOrIsRespawning = localPlayerCanRespawnOrIsRespawning
	file.localPlayerCanRespawn = localPlayerCanRespawn
}
































int function GetSquadLives( entity player )
{
	if ( !IsValid( player ) )
	{
		return 0
	}

	return player.GetPlayerNetInt( NETVAR_SQUAD_LIVES )
}








































































void function Survival_Solos_OverrideGameState()
{
	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_survival_solos.rpak" )
}



void function Survival_Solos_SetDeathScreenCallbacks()
{
	DeathScreen_SetModeSpecificRuiUpdateFunc( Survival_Solos_DeathScreenUpdate )
	DeathScreen_SetDataRuiAssetForGamemode( $"ui/header_data_solo.rpak" )
	SetSummaryDataDisplayStringsCallback( Survival_Solos_PopulateSummaryDataStrings )
	AddCallback_ShouldShowDeathScreen( Survival_Solos_ShouldShowDeathScreen )
}



void function Survival_Solos_DeathScreenUpdate( var rui )
{
	SquadSummaryData squadData = GetSquadSummaryData()
	string titleString = squadData.squadPlacement == 1 ? TEXT_SQUAD_PLACEMENT_WIN : TEXT_SQUAD_PLACEMENT_LOSE
	string killsText = TEXT_SQUAD_PLACEMENT_KILLS
	RuiSetString( rui, RUIVAR_DEATH_SCREEN_TITLE, titleString )
	RuiSetString( rui, RUIVAR_DEATH_SCREEN_KILLS, killsText )
	RuiSetBool( rui, "isAwaitingRespawn", Survival_Solos_CanLocalPlayerRespawnOrIsRespawning() )
}



var function Survival_Solos_OnSetupAnnouncement_RemainingRespawns( AnnouncementData announcement )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return null

	var rui = RuiCreate( $"ui/announcement_solos_respawns_remaining.rpak", clGlobal.topoFullScreen, RUI_DRAW_POSTEFFECTS, RUI_SORT_SCREENFADE + 1 )
	RuiSetInt( rui, "squadLives", file.squadLives )
	RuiSetInt( rui, "strikeTotal", LivesToStrikes( file.squadLives ) )

	EmitSoundOnEntity( player, announcement.soundAlias )
	return rui
}



bool function Survival_Solos_ShouldShowDeathScreen()
{
	return true 
}



void function Survival_Solos_PopulateSummaryDataStrings( SquadSummaryPlayerData data )
{
	data.modeSpecificSummaryData[0].displayString = TEXT_DEATH_SCREEN_SUMMARY_KILLS
	data.modeSpecificSummaryData[1].displayString = ""
	data.modeSpecificSummaryData[2].displayString = ""
	data.modeSpecificSummaryData[3].displayString = TEXT_DEATH_SCREEN_SUMMARY_DAMAGE
	data.modeSpecificSummaryData[4].displayString = TEXT_DEATH_SCREEN_SUMMARY_TIME
	data.modeSpecificSummaryData[5].displayString = TEXT_DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_USED
	data.modeSpecificSummaryData[6].displayString = TEXT_DEATH_SCREEN_SUMMARY_RESPAWN_TOKENS_REMAINING
}



void function Survival_Solos_SquadLivesChanged( entity player, int newValue )
{
	if ( !IsValid( player ) )
		return

	if ( player == GetLocalViewPlayer() )
	{
		file.squadLivesViewPlayer = newValue
	}

	if ( player == GetLocalClientPlayer() )
	{
		file.squadLives = newValue

		
		if ( file.squadLives <= -1 )
		{
			file.squadEliminated = true
		}
	}

	UpdateRui_SquadLives()
}



void function Survival_Solos_PlayerFreefallActiveChanged( entity player, bool isFreefallActive )
{
	if ( !isFreefallActive )
	{
		return
	}

	if ( !file.soloSplashAnnounceDisplayed && file.squadLives > 0 )
	{
		Announcement_SplashSolo()
		file.soloSplashAnnounceDisplayed = true
		file.lastSquadLifeAnnouncement = file.squadLives
		return
	}

	if ( file.lastSquadLifeAnnouncement == file.squadLives )
	{
		return
	}

	Announcement_SquadLivesRemaining()
	file.lastSquadLifeAnnouncement = file.squadLives
}



void function UpdateRui_SquadLives()
{
	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui != null && RuiIsAlive( gamestateRui ) && file.nestedSquadLivesRui == null || !RuiIsAlive( file.nestedSquadLivesRui ) )
	{
		RuiDestroyNestedIfAlive( gamestateRui, "respawnTokenHudHandle" )
		file.nestedSquadLivesRui = RuiCreateNested( gamestateRui, "respawnTokenHudHandle", $"ui/survival_solos_respawn_token.rpak" )
	}

	if ( file.nestedSquadLivesRui != null && RuiIsAlive( file.nestedSquadLivesRui ) )
	{
		RuiSetInt( file.nestedSquadLivesRui, "squadLives", maxint( file.squadLives, 0 ) )
		RuiSetInt( file.nestedSquadLivesRui, "viewPlayerLives", maxint( file.squadLivesViewPlayer, 0 ) )
	}

	if ( IsValid( GetLocalClientPlayer() ) )
	{
		bool canRespawnOrIsRespawning = file.squadLives >= 0 && !file.squadEliminated
		bool canRespawn = !file.squadEliminated && ( (file.squadLives > 0 && IsAlive( GetLocalClientPlayer() ) ) || (file.squadLives >= 0 && !IsAlive( GetLocalClientPlayer() ) ) )

		Survival_Solos_SetCanLocalPlayerRespawn( canRespawnOrIsRespawning, canRespawn )
		RunUIScript( "Survival_Solos_SetCanLocalPlayerRespawn", canRespawnOrIsRespawning, canRespawn )
	}
}



void function UpdateRui_RespawnState( bool newState )
{
	var rui = ClGameState_GetRui()
	if ( rui != null )
	{
		RuiSetBool( rui, RUIVAR_RESPAWN_DISABLED, newState )
	}

	Survival_Solos_SetCanLocalPlayerRespawn( newState, newState )
	RunUIScript( "Survival_Solos_SetCanLocalPlayerRespawn", newState, newState )
}



void function Survival_Solos_UpdateRui_OnReconnect()
{
	UpdateRui_SquadLives()
}



void function Announcement_SplashSolo()
{
	string message = TEXT_MODE_SOLOS
	string subText = TEXT_MODE_SOLOS_SUB

	AnnouncementData announcement = Announcement_Create( message )
	announcement.priority = 202 
	announcement.drawOverScreenFade = true

	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 16.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	Announcement_SetIcon( announcement, $"" )
	Announcement_SetLeftIcon( announcement, $"" )
	Announcement_SetRightIcon( announcement, $"" )

	AnnouncementFromClass( GetLocalClientPlayer(), announcement )
}



void function Announcement_SquadLivesRemaining()
{
	string message  = Localize( "#SURVIVAL_MODE_SOLOS_RESPAWN_TOKEN_USED" )
	string announcementSFX

	if ( file.squadLives >= 2 )
	{
		announcementSFX = SFX_SQUAD_LIVES_REMAINING_TWO
	}
	else if ( file.squadLives >= 1 )
	{
		announcementSFX = SFX_SQUAD_LIVES_REMAINING_ONE
	}
	else
	{
		announcementSFX = SFX_SQUAD_LIVES_REMAINING_ZERO
	}

	AnnouncementData announcement = Announcement_Create( message )
	announcement.priority = 202 

	Announcement_SetDuration( announcement, TIME_ANNOUNCEMENT_SQUAD_LIVES_REMAINING )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_REMAINING_RESPAWNS )
	Announcement_SetPriority( announcement, PRIORITY_ANNOUNCEMENT_SQUAD_LIVES_REMAINING )

	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	EmitSoundOnEntity( GetLocalViewPlayer(), announcementSFX )

	UpdateRui_SquadLives()
}



void function Survival_Solos_Announcement_SquadElimination()
{
	string message = ""

	AnnouncementData announcement = Announcement_Create( message )

	Announcement_SetDuration( announcement, TIME_ANNOUNCEMENT_SQUAD_ELIMINATED )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_MILESTONE_SMALL )
	Announcement_SetTitleColor( announcement, < 1,1,1 > )

	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	EmitSoundOnEntity( GetLocalViewPlayer(), SFX_SQUAD_ELIMINATED )
}




void function Survival_Solos_Announcement_RespawnsDisabled()
{
	int currentDeathFieldStage = SURVIVAL_GetCurrentDeathFieldStage()
	if ( currentDeathFieldStage >= 0 )
	{
		AnnouncementData announcement = Announcement_Create( Localize( "#SURVIVAL_CIRCLE_STARTING" ) )

		Announcement_SetSubText( announcement, GetAnnouncementSubtextString( currentDeathFieldStage + 1 ) )
		Announcement_SetHeaderText( announcement, "" ) 
		Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
		Announcement_SetAdditionalText( announcement, "#SURVIVAL_MODE_SOLOS_RESPAWNS_DISABLED" )
		
		Announcement_SetDuration( announcement, TIME_ANNOUNCEMENT_RESPAWN_DISABLED )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
		Announcement_SetSoundAlias( announcement, SFX_RESPAWN_DISABLED )
		Announcement_SetPriority( announcement, 209 )
		Announcement_SetPurge( announcement, false ) 

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	}

	UpdateRui_RespawnState( false )
	UpdateRui_SquadLives()
}



int function Survival_Solos_GetMaxSquadLives()
{
	return GetStartingRespawnCount() + 1
}



bool function Survival_Solos_IsPlayerWaitingForRespawn( entity player )
{
	if ( !IsValid( player ) || ( player != GetLocalClientPlayer() ) )
		return false

	if ( Sh_Survival_Solos_IsPlayerRespawnDisabled( player ) )
		return false

	if ( file.squadEliminated )
		return false

	
	return ( file.squadLives >= 0 )
}



















int function LivesToStrikes( int lives )
{
	
	const int MAX_STRIKES = 3

	int strikes = minint( MAX_STRIKES - lives - 1, 3 )
	return maxint( strikes, 0 )
}

bool function GetPlaylistVar_AmmoOnKillEnabled()
{
	return GetCurrentPlaylistVarBool( "survival_solos_ammo_on_kill_enabled", false )
}

float function GetPlaylistVar_AmmoOnKillMultiplier()
{
	return GetCurrentPlaylistVarFloat( "survival_solos_ammo_on_kill_multiplier", 1.0 )
}

int function GetPlaylistVar_AmmoOnKillBoxesToSpawn()
{
	return GetCurrentPlaylistVarInt( "survival_solos_ammo_on_kill_spawns", 4 )
}

bool function GetPlaylistVar_ArmorOnKillEnabled()
{
	return GetCurrentPlaylistVarBool( "survival_solos_armor_on_kill_enabled", false )
}

bool function GetPlaylistVar_PingDeathLocationEnabled()
{
	return GetCurrentPlaylistVarBool( "survival_solos_ping_death_location", false )
}

int function GetPlaylistVar_RespawnDisabledDeathstage()
{
	return GetCurrentPlaylistVarInt( "survival_solos_respawn_disable_deathstage_close", 4 )
}

int function GetPlaylistVar_XPForRespawnToken()
{
	return GetCurrentPlaylistVarInt( "survival_solos_xp_for_respawn_token", 500 )
}

bool function GetPlaylistVar_TakeTokenOnDisconnect()
{
	return GetCurrentPlaylistVarBool( "survival_solos_take_token_on_disconnect", false )
}

bool function GetPlaylistVar_KillPlayerOnDisconnect()
{
	return GetCurrentPlaylistVarBool( "survival_solos_kill_player_on_disconnect", false )
}

