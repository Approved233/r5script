globalize_all_functions

global enum ePlaylistState
{
	AVAILABLE,
	NO_PLAYLIST,
	TRAINING_REQUIRED,
	COMPLETED_TRAINING_REQUIRED,

	COMPLETED_ORIENTATION_REQUIRED,

	PARTY_SIZE_OVER,
	LOCKED,
	RANKED_LEVEL_REQUIRED,
	RANKED_LARGE_RANK_DIFFERENCE,
	RANKED_NOT_INITIALIZED,
	RANKED_MATCH_ABANDON_DELAY,
	RANKED_MATCH_PATCH_REQUIRED,
	RANKED_MATCH_SEASON_ENDING,
	ACCOUNT_LEVEL_REQUIRED,
	ROTATION_GROUP_MISMATCH,
	DEV_PLAYTEST,
	LOCKED_FOR_EVENT,
	_COUNT
}

global enum eTrainingExemptionState
{
	UNINITIALIZED,
	FALSE,
	TRUE,
}

const table< int, string > playlistStateMap = {
	[ ePlaylistState.NO_PLAYLIST ] = "#PLAYLIST_STATE_NO_PLAYLIST",
	[ ePlaylistState.TRAINING_REQUIRED ] = "#PLAYLIST_STATE_TRAINING_REQUIRED",
	[ ePlaylistState.COMPLETED_TRAINING_REQUIRED ] = "#PLAYLIST_STATE_COMPLETED_TRAINING_REQUIRED",

		[ ePlaylistState.COMPLETED_ORIENTATION_REQUIRED ] = "#PLAYLIST_STATE_COMPLETED_ORIENTATION_REQUIRED",

	[ ePlaylistState.AVAILABLE ] = "#PLAYLIST_STATE_AVAILABLE",
	[ ePlaylistState.PARTY_SIZE_OVER ] = "#PLAYLIST_STATE_PARTY_SIZE_OVER",
	[ ePlaylistState.LOCKED ] = "#PLAYLIST_STATE_LOCKED",
	[ ePlaylistState.RANKED_LEVEL_REQUIRED ] = "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED",
	[ ePlaylistState.RANKED_LARGE_RANK_DIFFERENCE ] = "#PLAYLIST_STATE_RANKED_LARGE_RANK_DIFFERENCE",
	[ ePlaylistState.RANKED_NOT_INITIALIZED ] = "#PLAYLIST_STATE_RANKED_NOT_INITIALIZED",
	[ ePlaylistState.RANKED_MATCH_ABANDON_DELAY ] = "#RANKED_ABANDON_PENALTY_PLAYLIST_STATE",
	[ ePlaylistState.RANKED_MATCH_PATCH_REQUIRED ] = "#PLAYLIST_STATE_RANKED_PATCH_REQUIRED",
	[ ePlaylistState.RANKED_MATCH_SEASON_ENDING ] = "#PLAYLIST_STATE_RANKED_SPLIT_ROLLOVER",
	[ ePlaylistState.ROTATION_GROUP_MISMATCH ] = "#PLAYLIST_UNAVAILABLE",
	[ ePlaylistState.ACCOUNT_LEVEL_REQUIRED ] = "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED",
	[ ePlaylistState.DEV_PLAYTEST ] = "#PLAYLIST_STATE_PLAYTEST",
	[ ePlaylistState.LOCKED_FOR_EVENT ] = "#PLAYSTATE_STATE_EVENTLOCKED",
}

struct
{
	array<string> playlists
	array<string> playlistMods

	string        selectedUiSlot
	string        selectedPlaylist
	string        selectedPlaylistMods

	array<void functionref( string )> Callbacks_OnSelectedUiSlotUpdated
	array<void functionref( string )> Callbacks_OnSelectedPlaylistUpdated
	array<void functionref( string )> Callbacks_OnSelectedPlaylistModsUpdated

	float currentMaxMatchmakingDelayEndTime = -1

} file

void function LobbyPlaylist_Init()
{
	if( !HasCallback_OnPartyMemberRemoved( LobbyPlaylist_UpdateCurrentMaxMatchmakingDelayEndTime ) )
		AddCallback_OnPartyMemberRemoved( LobbyPlaylist_UpdateCurrentMaxMatchmakingDelayEndTime )
}




void function LobbyPlaylist_SetPlaylists( array< string > playlists )
{
	Assert( playlists.len() > 0 )

	
	if ( CanRunClientScript() )
		RunClientScript( "LSS_UpdateLobbyStage", LobbyPlaylist_GetSelectedPlaylist() )

	file.playlists = playlists
}

array< string > function LobbyPlaylist_GetPlaylists()
{
	return file.playlists
}

void function LobbyPlaylist_ClearPlaylists()
{
	file.playlists.clear()
}




void function LobbyPlaylist_SetPlaylistMods( array< string > playlistMods )
{
	file.playlistMods = playlistMods
}

array< string > function LobbyPlaylist_GetPlaylistMods()
{
	return file.playlistMods
}

void function LobbyPlaylist_ClearPlaylistMods()
{
	file.playlistMods.clear()
}




void function LobbyPlaylist_SetSelectedPlaylist( string playlistName )
{
	printt( "Lobby_SetSelectedPlaylist " + playlistName )
	LobbyPlaylist_SetSelectedUISlot( GetPlaylistVarString( playlistName, "ui_slot", "" ) )
	file.selectedPlaylist = playlistName

	foreach ( void functionref( string ) cb in file.Callbacks_OnSelectedPlaylistUpdated )
		cb( playlistName )
}

string function LobbyPlaylist_GetSelectedPlaylist()
{
	return IsPartyLeader() ? file.selectedPlaylist : GetParty().playlistName
}

void function LobbyPlaylist_ClearSelectedPlaylist()
{
	file.selectedPlaylist = ""
}

void function AddCallback_LobbyPlaylist_OnSelectedPlaylistChanged( void functionref( string ) callbackFunc )
{
	if( !file.Callbacks_OnSelectedPlaylistUpdated.contains( callbackFunc ) )
		file.Callbacks_OnSelectedPlaylistUpdated.append( callbackFunc )
}




void function LobbyPlaylist_SetSelectedUISlot( string UiSlot )
{
	printt( "Lobby_SetSelectedUISlot " + UiSlot )
	file.selectedUiSlot = UiSlot

	foreach ( void functionref( string ) cb in file.Callbacks_OnSelectedUiSlotUpdated )
		cb( UiSlot )
}

string function LobbyPlaylist_GetSelectedUISlot()
{
	return file.selectedUiSlot
}

void function LobbyPlaylist_ClearSelectedUISlot()
{
	file.selectedUiSlot = ""
}

void function AddCallback_LobbyPlaylist_OnSelectedUISlotChanged( void functionref( string ) callbackFunc )
{
	if( !file.Callbacks_OnSelectedUiSlotUpdated.contains( callbackFunc ) )
		file.Callbacks_OnSelectedUiSlotUpdated.append( callbackFunc )
}




void function LobbyPlaylist_SetSelectedPlaylistMods( string playlistMods )
{
	printt( "Lobby_SetSelectedPlaylistMods " + playlistMods )

	file.selectedPlaylistMods = playlistMods

	foreach ( void functionref( string ) cb in file.Callbacks_OnSelectedPlaylistModsUpdated )
		cb( playlistMods )
}

string function LobbyPlaylist_GetSelectedPlaylistMods()
{
	return file.selectedPlaylistMods
}

void function LobbyPlaylist_ClearSelectedPlaylistMods()
{
	file.selectedPlaylistMods = ""
}

void function AddCallback_LobbyPlaylist_OnSelectedPlaylistModsChanged( void functionref( string ) callbackFunc )
{
	if( !file.Callbacks_OnSelectedPlaylistModsUpdated.contains( callbackFunc ) )
		file.Callbacks_OnSelectedPlaylistModsUpdated.append( callbackFunc )
}




void function LobbyPlaylist_UpdateCurrentMaxMatchmakingDelayEndTime()
{
	file.currentMaxMatchmakingDelayEndTime = SharedRanked_GetMaxPartyMatchmakingDelay() + UITime()
}

void function LobbyPlaylist_SetCurrentMaxMatchmakingDelayEndTime( float currentMaxMatchmakingDelayEndTime )
{
	file.currentMaxMatchmakingDelayEndTime = currentMaxMatchmakingDelayEndTime
}

float function LobbyPlaylist_GetCurrentMaxMatchmakingDelayEndTime()
{
	return file.currentMaxMatchmakingDelayEndTime
}




bool function DoesPlaylistRequireTraining( string playlist )
{
	if ( playlist == PLAYLIST_TRAINING )
		return false

	if ( GetPartySize() > 1 )
		return false

	if ( IsLocalPlayerExemptFromTraining() )
		return false

	if ( HasLocalPlayerCompletedTraining() )
		return false

	return GetPlaylistVarBool( playlist, "require_training", false )
}

bool function HasLocalPlayerCompletedTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	if ( !GetVisiblePlaylistNames().contains( PLAYLIST_TRAINING ) )
		return true

#if DEV
		if ( GetConVarBool( "skip_training" ) )
			return true
#endif

	if ( GetCurrentPlaylistVarBool( "require_training", false ) )
		return GetPersistentVarAsInt( "trainingCompleted" ) > 0

	return true
}





bool function IsLocalPlayerExemptFromNewPlayerOrientation()
{
	if( GetConVarBool( "orientation_matches_disabled" ) )
		return true

	if ( !GetCurrentPlaylistVarBool( "require_new_player_orientation", false ) )
		return true

	if ( !IsFullyConnected() )
		return false






	CommunityUserInfo ornull userInfo = GetUserInfo( GetPlayerHardware(), GetPlayerUID() )
	if ( userInfo == null )
		return false


		if ( LobbyPlaylist_IsTournamentMatchmaking() )
			return true


	return false
}

bool function DoesPlaylistRequireNewPlayerOrientation( string playlist )
{
	if( GetConVarBool( "orientation_matches_disabled" ) )
		return false

	if ( playlist == PLAYLIST_NEW_PLAYER_ORIENTATION )
		return false









	return GetPlaylistVarBool( playlist, "require_new_player_orientation", false )
}

bool function HasLocalPlayerCompletedNewPlayerOrientation()
{
	if( GetConVarBool( "orientation_matches_disabled" ) )
		return true

	if ( !GetCurrentPlaylistVarBool( "require_new_player_orientation", false ) )
		return true

	if ( !IsFullyConnected() )
		return false






	CommunityUserInfo ornull userInfo = GetUserInfo( GetPlayerHardware(), GetPlayerUID() )
	if ( userInfo == null )
		return false
	expect CommunityUserInfo( userInfo )

	if ( !GetVisiblePlaylistNames().contains( PLAYLIST_NEW_PLAYER_ORIENTATION ) )
		return true

#if DEV
		if ( GetConVarBool( "skip_training" ) )
			return true 
#endif

	return userInfo.hasGraduatedBotsQueue
}

bool function DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation()
{
	if( GetConVarBool( "orientation_matches_disabled" ) )
		return false

	if ( !GetCurrentPlaylistVarBool( "require_new_player_orientation", false ) )
		return false

	Party party           = GetParty()
	string localPlayerUID = GetPlayerUID()

	foreach ( PartyMember partyMember in party.members )
	{
		if ( partyMember.uid == localPlayerUID )
			continue

		CommunityUserInfo ornull userInfo = GetUserInfo( partyMember.hardware, partyMember.uid )
		if ( userInfo == null )
			continue

		expect CommunityUserInfo( userInfo )

		if ( !userInfo.hasGraduatedBotsQueue )
			return true
	}

	return false
}





bool function IsPlaylistLockedForEvent( string playlistName )
{
	if ( GameModeVariant_IsActiveForPlaylist( playlistName, eGameModeVariants.SURVIVAL_RANKED ) )
		return false


		if ( playlistName == PLAYLIST_NEW_PLAYER_ORIENTATION )
		{
			
			if ( HasLocalPlayerCompletedNewPlayerOrientation() )
				return true
			else
				return false
		}


	if ( playlistName == PLAYLIST_TRAINING )
	{
		
		if ( HasLocalPlayerCompletedTraining() )
			return true
		else
			return false
	}

	if ( playlistName == GetEventTakeoverPlaylist() )
		return false

	return ( GetPlaylistVarBool( playlistName, "lockedForEvent", true ) )
}

string function GetEventTakeoverPlaylist()
{
	return GetCurrentPlaylistVarString( "event_takeover_playlist", "" )
}

bool function HasEventTakeOverActive()
{
	if ( GetEventTakeoverPlaylist() == "" )
		return false

	int eventTakeoverStartTime = expect int(GetCurrentPlaylistVarTimestamp( "event_takeover_start_timestamp", UNIX_TIME_FALLBACK_2038 ))
	int eventTakeoverEndTime = expect int(GetCurrentPlaylistVarTimestamp( "event_takeover_end_timestamp", UNIX_TIME_FALLBACK_2038 ))
	int now = GetUnixTimestamp()

	if ( now >= eventTakeoverStartTime && now < eventTakeoverEndTime )
		return true

	return false
}




bool function Lobby_IsPlaylistAvailable( string playlistName )
{
	return LobbyPlaylist_GetPlaylistState( playlistName ) == ePlaylistState.AVAILABLE
}

int function LobbyPlaylist_GetSelectedPlaylistExpectedSquadSize()
{
	string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()
	return int ( GetPlaylistVarFloat( selectedPlaylist, "max_players", 60 ) / GetPlaylistVarFloat( selectedPlaylist, "max_teams", 20 ) )
}

int function LobbyPlaylist_GetPlaylistState( string playlistName )
{
	if ( playlistName == "" )
		return ePlaylistState.NO_PLAYLIST

	if ( IsPrivateMatchLobby() )
	{
		if ( GetPlaylistVarBool( playlistName, "private_match", false ) )
			return ePlaylistState.AVAILABLE
		else
			return ePlaylistState.LOCKED
	}

	if ( HasEventTakeOverActive() )
	{
		if ( IsPlaylistLockedForEvent( playlistName ) )
			return ePlaylistState.LOCKED_FOR_EVENT
	}


		if ( DoesPlaylistRequireNewPlayerOrientation( playlistName ) )
			return ePlaylistState.COMPLETED_ORIENTATION_REQUIRED


	if ( DoesPlaylistRequireTraining( playlistName ) )
	{
		if ( GetCurrentPlaylistVarBool( "full_training_required", true ) )
			return ePlaylistState.COMPLETED_TRAINING_REQUIRED
		else
			return ePlaylistState.TRAINING_REQUIRED
	}

	if ( GetPlaylistVarBool ( playlistName, "DEV_Playtest", false ))
	{
		if ( GetPartySize() != 1 )
		{
			return ePlaylistState.DEV_PLAYTEST
		}
	}

	if ( file.currentMaxMatchmakingDelayEndTime > (UITime() + 0.01 ) )
		return ePlaylistState.RANKED_MATCH_ABANDON_DELAY

	if ( GetPartySize() > GetMaxTeamSizeForPlaylist( playlistName ) )
		return ePlaylistState.PARTY_SIZE_OVER

	if ( GameModeVariant_IsActiveForPlaylist( playlistName, eGameModeVariants.SURVIVAL_RANKED ) )
	{
		if ( !SharedRanked_PartyHasRankedLevelAccess() )
			return ePlaylistState.RANKED_LEVEL_REQUIRED
		else if ( !Ranked_PartyMeetsRankedDifferenceRequirements() )
			return ePlaylistState.RANKED_LARGE_RANK_DIFFERENCE
		else if ( !Ranked_HasBeenInitialized() )
			return ePlaylistState.RANKED_NOT_INITIALIZED
		else if ( Playlist_ShouldLockRankedPlaylistForPatch( playlistName ) )
			return ePlaylistState.RANKED_MATCH_PATCH_REQUIRED
		else if ( Playlist_IsPastRankedSeasonEndDate() )
			return ePlaylistState.RANKED_MATCH_SEASON_ENDING
	}













	if ( !PartyHasPlaylistAccountLevelRequired( playlistName ) )
		return ePlaylistState.ACCOUNT_LEVEL_REQUIRED

	if ( IsPlaylistBeingRotated( playlistName ) && !IsPlaylistInActiveRotation( playlistName ) )
		return ePlaylistState.ROTATION_GROUP_MISMATCH

	if ( Playlist_ShouldBeHiddenForScheduleBlocks( playlistName ) )
		return ePlaylistState.ROTATION_GROUP_MISMATCH


		if ( playlistName == "private_match" && !LobbyPlaylist_IsTournamentMatchmaking() )
			return ePlaylistState.LOCKED


	return ePlaylistState.AVAILABLE
}

string function LobbyPlaylist_GetPlaylistStateString( int playlistState )
{
	string playlistStateString = playlistStateMap[playlistState]
	if ( playlistState == ePlaylistState.ACCOUNT_LEVEL_REQUIRED )
	{
		int level = GetPlaylistVarInt( LobbyPlaylist_GetSelectedPlaylist(), "account_level_required", 0 )
		playlistStateString = Localize( playlistStateString, level )
	}
	else if ( playlistState == ePlaylistState.RANKED_LEVEL_REQUIRED )
	{
		int level = Ranked_GetRankedLevelRequirement() + 1
		playlistStateString = Localize( playlistStateString, level )
	}
	else if ( playlistState == ePlaylistState.RANKED_LARGE_RANK_DIFFERENCE )
	{
		int level = Ranked_RankedPartyMaxTierDifferential()
		playlistStateString = Localize( playlistStateString, level )
	}

	return playlistStateString
}


bool function LobbyPlaylist_IsTournamentMatchmaking()
{
	if ( LobbyPlaylist_GetSelectedPlaylist() != "private_match" )
		return false

	return GetConVarString( "match_roleToken" ) != ""
}

