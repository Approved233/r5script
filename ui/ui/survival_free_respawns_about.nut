

global function Survival_FreeRespawns_PopulateAboutText


array< featureTutorialTab > function Survival_FreeRespawns_PopulateAboutText()
{
	array< featureTutorialTab > tabs

	string playlistUiRules = GetPlaylist_UIRules()
	if ( playlistUiRules != GAMEMODE_SURVIVAL_FREE_RESPAWNS )
		return tabs

	GameMode_AboutDialog_AppendFreeSpawnsTab(tabs)
	GameMode_AboutDialog_AppendRequeueTab(tabs)


	return tabs
}


      