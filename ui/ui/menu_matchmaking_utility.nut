global function LeaveMatch
global function LeaveMatch_WasInitiated
global function LeaveMatch_ResetInitiated
global function LeaveMatch_Freelance
global function LeaveParty
global function LeaveMatchAndParty

global function IsSendOpenInviteTrue
global function SendOpenInvite

struct
{
	bool sendOpenInvite = false
	bool leaveMatchInitiated = false
} file

void function LeaveMatch_ResetInitiated()
{
	file.leaveMatchInitiated = false
}

bool function LeaveMatch_WasInitiated()
{
	return file.leaveMatchInitiated
}

void function LeaveMatch()
{
	ResetReconnectParameters()

	
	
	




	CancelMatchmaking()
	Remote_ServerCallFunction( "ClientCallback_LeaveMatch" )
	RunClientScript( "UICallback_LeaveMatchInitiated" )

	file.leaveMatchInitiated = true
}

void function LeaveMatch_Freelance()
{




	CancelMatchmaking()

	string hubPlaylist = GetCurrentPlaylistVarString( "freelance_hub_playlist", "freelance_hub" )
	Assert( (hubPlaylist.len() > 0), "Missing 'freelance_hub_playlist' entry." )
	StartMatchmakingStandard( hubPlaylist )
}

void function LeaveParty()
{
	Party_LeaveParty()
	Signal( uiGlobal.signalDummy, "LeaveParty" )
}

void function LeaveMatchAndParty()
{
	LeaveParty()
	LeaveMatchWithDialog()
}

void function SendOpenInvite( bool state )
{
	file.sendOpenInvite = state
}

bool function IsSendOpenInviteTrue()
{
	return file.sendOpenInvite
}
