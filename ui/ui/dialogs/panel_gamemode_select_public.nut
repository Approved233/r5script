global function InitGameModeSelectPublicPanel

global function GamemodeSelect_UpdateSelectButton
global function UpdateOpenModeSelectDialog
global function GamemodeSelect_PlayVideo
global function GamemodeSelect_SetFeaturedSlot
global function GameModeSelect_GetPlaylists
global function GameModeSelect_OnPartyChanged

#if DEV
global function ShippingPlaylistCheck
#endif

global function ModeSelectorHighlight

struct
{
	var panel
	var craftingPreview
	var mixtapePreview
	var craftingSlideout
	var disabledCover
	var gameModeButtonBackground
	var header
	var closeButton

	var backToFTUEButton


	bool hasLTM = false

	bool hasRegular0 = false
	bool hasRegular2 = false
	bool hasRegular3 = false

	int   videoChannel = -1
	asset currentVideoAsset = $""
	bool showVideo
	bool craftingOpen = false

	string featuredSlot = ""
	string featuredSlotString = "#HEADER_NEW_MODE"

	float lastCrossFadeGameTime = -1
	bool  hasLocalPlayerCompletedTraining = false

	bool  hasLocalPlayerCompletedNewPlayerOrientation = false


	array<var> modeSelectButtonList
	table<var, string> selectButtonPlaylistNameMap
	var rankedRUIToUpdate = null

	table<string, var > slotToButtonMap
	table<string, var > slotToColorMap
	table<string, string> slotToPlaylistNameMap

	string mapPreviewSlotKey = ""
	string mapPreviewPlaylistName = ""

} file

const int DRAW_NONE = 0
const int DRAW_IMAGE = 1
const int DRAW_RANK = 2

const int FEATURED_NONE = 0
const int FEATURED_ACTIVE = 1
const int FEATURED_INACTIVE = 2

void function InitGameModeSelectPublicPanel( var panel )
{
	file.panel = panel

	RegisterSignal( "GamemodeSelect_EndVideoStopThread" )

	file.closeButton              = Hud_GetChild( panel, "CloseButton" )
	file.gameModeButtonBackground = Hud_GetChild( panel, "GameModeButtonBg" )
	file.header                   = Hud_GetChild( panel, "Header" )
	file.craftingPreview          = Hud_GetChild( panel, "CraftingPreview" )
	file.mixtapePreview           = Hud_GetChild( panel, "MixtapePreview" )
	file.disabledCover            = Hud_GetChild( panel, "DisabledCover" )

	file.backToFTUEButton         = Hud_GetChild( panel, "BackToFTUEModalButton" )


	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowModePublicPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHidePublicPanel )

	file.slotToButtonMap = {
		training = Hud_GetChild( panel, "GamemodeButton0" ),

			bot_playground = Hud_GetChild( panel, "GameModeButton9" ),

		firing_range = Hud_GetChild( panel, "GamemodeButton1" ),
		regular_0 = Hud_GetChild( panel, "GameModeButton10" ),
		regular_1 = Hud_GetChild( panel, "GamemodeButton2" ),
		regular_2 = Hud_GetChild( panel, "GamemodeButton3" ),
		regular_3 = Hud_GetChild( panel, "GamemodeButton4" ),
		ranked = Hud_GetChild( panel, "GamemodeButton5" ),
		mixtape = Hud_GetChild( panel, "GamemodeButton6" ),
		ltm = Hud_GetChild( panel, "GamemodeButton7" ),
		event = Hud_GetChild( panel, "GamemodeButton8" )
	}

	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "SurvivalCategory" ) ), "header", "#GAMEMODE_CATEGORY_SURVIVAL" )
	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "MixtapeCategory" ) ), "header", "" ) 
	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LTMCategory" ) ), "header", "" ) 
	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "PracticeCategory" ) ), "header", "#GAMEMODE_CATEGORY_PRACTICE" )

	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "", null, HasModeFocused )
}




void function OnShowModePublicPanel( var panel )
{

		if ( FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
		{
			string recommendedSlot = FTUEFlow_GameModeSelectRecommendation()
			if ( recommendedSlot != "" )
			{
				GamemodeSelect_SetFeaturedSlot( recommendedSlot, "#MENU_RETICLE_RECOMMENDED" )
			}
		}


	SetModeSelectMenuOpen( true )
	file.hasLocalPlayerCompletedTraining             = HasLocalPlayerCompletedTraining() || IsLocalPlayerExemptFromTraining()

	file.hasLocalPlayerCompletedNewPlayerOrientation = HasLocalPlayerCompletedNewPlayerOrientation() || IsLocalPlayerExemptFromNewPlayerOrientation()

	UpdateOpenModeSelectDialog()

	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )


		Hud_AddEventHandler( file.backToFTUEButton, UIE_CLICK, NavigateBackToFTUEModal )
		Hud_SetVisible(file.backToFTUEButton, FTUEFlow_GetFTUEFlowStage() < eFTUEFlowStage.POST_TUTORIAL && IsPartyLeader() )


	foreach ( string slotKey, button in file.slotToButtonMap )
	{
		Hud_AddEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, GamemodeButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, GamemodeButton_OnLoseFocus )
		file.modeSelectButtonList.append( button )
	}
	ModeSelectorHighlight()
	AnimateIn()
}

void function OnHidePublicPanel( var panel )
{
	printt( "Clearing rui to update in game mode select" )
	
	var craftingRui = Hud_GetRui( file.craftingPreview )
	RuiSetWallTimeBad( craftingRui, "animateStartTime" )
	var mixtapeRui = Hud_GetRui( file.mixtapePreview )
	RuiSetWallTimeBad( mixtapeRui, "animateStartTime" )
	Hud_SetVisible(file.mixtapePreview, false)

	file.rankedRUIToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )


	Hud_RemoveEventHandler( file.backToFTUEButton, UIE_CLICK, NavigateBackToFTUEModal )


	foreach ( string slotKey, button in file.slotToButtonMap )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, GamemodeButton_OnGetFocus )
		Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, GamemodeButton_OnLoseFocus )
	}
}

void function ModeSelectorHighlight()
{
	string selectedPlaylist = GetGamemodeSelectorPlaylist()
	foreach ( string slotKey, button in file.slotToButtonMap )
	{
		if ( button in file.selectButtonPlaylistNameMap )
		{
#if DEV
				printt("ModeSelectorHighlight", file.selectButtonPlaylistNameMap[button])
#endif
			bool shouldShowHighlight = HasGamemodeSelector() && file.selectButtonPlaylistNameMap[button] == selectedPlaylist
			var rui = Hud_GetRui( button )
			RuiSetBool( rui, "isNew", shouldShowHighlight )
		}
	}
}

void function DismissGamemodeSelectorAndRefresh()
{
	if ( HasGamemodeSelector() )
	{
		DismissGamemodeSelector()
		ModeSelectorHighlight()
	}
}

void function ToggleCraftingTooltip( bool turnOn )
{
	if ( turnOn && !Hud_IsVisible( file.disabledCover ) )
	{
		ToolTipData td
		td.tooltipStyle = eTooltipStyle.CRAFTING_INFO
		td.titleText = "#CRAFTING_FLOW"
		td.descText = "#CRAFTING_FEATURE_DESC"

		Hud_SetToolTipData( file.craftingPreview, td )
	}
	else
	{
		Hud_ClearToolTipData( file.craftingPreview )
	}
}





void function GamemodeButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	string playlistName = file.selectButtonPlaylistNameMap[button]


	if ( RankedRumble_GamemodeButtonActivateCheck( playlistName ) )
		return
	else

	{
		if ( IsPrivateMatchLobby() )
			PrivateMatch_SetSelectedPlaylist( playlistName )
		else
			LobbyPlaylist_SetSelectedPlaylist( playlistName )
			DismissGamemodeSelectorAndRefresh()
		CloseAllDialogs()
	}
}

bool function HasModeFocused()
{
	var focus = GetFocus()

	return focus in file.selectButtonPlaylistNameMap
}

void function GamemodeButton_OnGetFocus( var button )
{
	bool allowCraftingToBeSeen = !AreCraftingDispensersEnabled()

	CrossFadeCraftingMapPreview(button, true, allowCraftingToBeSeen)
	ToggleCraftingTooltip(false)
	UpdateFooterOptions()
}

void function GamemodeButton_OnLoseFocus( var button )
{
	bool allowCraftingToBeSeen = !AreCraftingDispensersEnabled()

	CrossFadeCraftingMapPreview(button, false, allowCraftingToBeSeen)
	ToggleCraftingTooltip(allowCraftingToBeSeen)
	UpdateFooterOptions()
}





void function UpdateOpenModeSelectDialog()
{
	file.showVideo = GetCurrentPlaylistVarBool( "lobby_gamemode_video", false )
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), false )


	if ( file.featuredSlot != "" && !FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )



		thread ClearFeaturedSlotAfterDelay()


	file.selectButtonPlaylistNameMap.clear()
	UpdateGameModes()
	UpdateCrafting()
#if DEV
		ShippingPlaylistCheck()
#endif

	string headerText
	string headerDescText
	bool useAnimation
	bool showDisabledCover


	if ( file.hasLocalPlayerCompletedNewPlayerOrientation )



	{
		headerText     = ""
		headerDescText = "#GAMEMODE_SELECT_HEADER"
		useAnimation   = false
		showDisabledCover = false
	}

	else if ( file.hasLocalPlayerCompletedTraining )
	{
		headerText     = "#PL_WELCOME_TO_APEX"
		headerDescText = "#GAMEMODE_SELECT_HEADER_COMPLETE_ORIENTATION"
		useAnimation   = true
		showDisabledCover = true

		Hud_SetZ( file.disabledCover, 7 )
	}

	else
	{
		headerText     = "#PL_WELCOME_TO_APEX"
		headerDescText = "#GAMEMODE_SELECT_HEADER_COMPLETE_TRAINING"
		useAnimation   = true
		showDisabledCover = true

		Hud_SetZ( file.disabledCover, 10 )
	}

	HudElem_SetRuiArg( file.header, "header", headerText )
	HudElem_SetRuiArg( file.header, "description", headerDescText )
	HudElem_SetRuiArg( file.header, "useAnimation", useAnimation )
	Hud_SetVisible( file.disabledCover, showDisabledCover )
	ToggleCraftingTooltip( !showDisabledCover )
}

void function UpdateGameModes()
{
	file.slotToPlaylistNameMap = GameModeSelect_GetPlaylists();

	string mainPlaylist = "defaults"

	foreach ( string slotKey, string playlistName in file.slotToPlaylistNameMap )
	{

		printf( "GameModesDebug: %s(): Slot: %s, Game Mode: %s", FUNC_NAME(), slotKey, playlistName )
	}

	foreach ( string slotKey, button in file.slotToButtonMap )
	{
		string playlistName = file.slotToPlaylistNameMap[slotKey]
		var rui = Hud_GetRui( button )
		bool isLtm = button == file.slotToButtonMap["ltm"]
		bool isEvent = button == file.slotToButtonMap["event"]
		bool isMixtape = button == file.slotToButtonMap["mixtape"]
		bool isRankedBR = button == file.slotToButtonMap["ranked"]
		bool isRegular0 = button == file.slotToButtonMap["regular_0"]
		bool isRegular2 = button == file.slotToButtonMap["regular_2"]
		bool isRegular3 = button == file.slotToButtonMap["regular_3"]

		if ( playlistName == "" )
		{
			Hud_SetEnabled( button, false )
			if(isLtm)
			{
				Hud_Hide( button )
				Hud_Hide( Hud_GetChild(file.panel,"LTMCategory" ) )
				file.hasLTM = false
			}
			else if(isEvent)
				Hud_Hide( button )
			else if( isRegular0 )
			{
				file.hasRegular0 = false
				Hud_Hide( button )
			}
			else if( isRegular2 )
			{
				file.hasRegular2 = false
				Hud_Hide( button )
			}
			else if( isRegular3 )
			{
				file.hasRegular3 = false
				Hud_Hide( button )
			}

			RuiSetString( rui, "modeNameText", "")
			RuiSetImage( rui, "modeImage", $"rui/menu/gamemode/playlist_bg_none" )

			if( isRankedBR )
			{
				if ( !Playlist_IsPastRankedSeasonEndDate() )
				{
					RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )
					if ( Playlist_HasRankedSeasonEndDate() )
					{
						int ornull seasonEndDate = Playlist_GetRankedSeasonEndDate()
						expect int( seasonEndDate )
						int remainingDuration = seasonEndDate - GetUnixTimestamp()
						RuiSetGameTime( rui, "nextRankUpdateTime", ClientTime() + remainingDuration )
						RuiSetString( rui, "modeLockedReason", "#PLAYLIST_STATE_RANKED_PATCH_REQUIRED_COUNTDOWN" )
					}
					else
					{
						RuiSetGameTime( rui, "nextRankUpdateTime", RUI_BADGAMETIME )
						RuiSetString( rui, "modeLockedReason", "#PLAYLIST_STATE_RANKED_PATCH_REQUIRED" )
					}
				}
				else
				{
					RuiSetString( rui, "modeLockedReason", "#PLAYLIST_STATE_RANKED_SPLIT_ROLLOVER" )
					RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )
					RuiSetGameTime( rui, "nextRankUpdateTime", RUI_BADGAMETIME )
				}
			}
			else
			{
				RuiSetString( rui, "modeLockedReason", "" )
			}
			RuiSetBool( rui, "showLockedIcon", true )
			RuiSetBool( rui, "isLocked", true )
		}
		else
		{
			Hud_Show( button )
			if(isLtm)
			{
				Hud_Show( Hud_GetChild(file.panel,"LTMCategory" ) )
				file.hasLTM = true
			}

			if( isRegular0 )
				file.hasRegular0 = true

			if( isRegular2 )
				file.hasRegular2 = true

			if( isRegular3 )
				file.hasRegular3 = true

			if( isMixtape )
				RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "MixtapeCategory" ) ), "header", GetPlaylistVarString( playlistName, "gamemode_select_category_name", "#GAMEMODE_CATEGORY_MIXTAPE" ) )
			else if( isLtm )
				RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "LTMCategory" ) ), "header", GetPlaylistVarString( playlistName, "gamemode_select_category_name", "#GAMEMODE_CATEGORY_LTM" ) )

			
			if ( slotKey.find( "regular" ) == 0 )
			{
				if ( file.slotToPlaylistNameMap[ slotKey ] != "" )
					Hud_SetHeight( button, Hud_GetBaseHeight( button ) )
				else
					Hud_SetHeight( button, 0 )
			}

			bool isEnabled = false

		if ( HasEventTakeOverActive() )
		{
			if ( button == file.slotToButtonMap["ltm"] )
				isEnabled = true

			if ( !file.hasLocalPlayerCompletedNewPlayerOrientation && button == file.slotToButtonMap["regular_1"] )
				isEnabled = true

			if ( !file.hasLocalPlayerCompletedTraining && button == file.slotToButtonMap["training"] )
				isEnabled = true

			if ( file.hasLocalPlayerCompletedNewPlayerOrientation && file.hasLocalPlayerCompletedTraining && isRankedBR )
				isEnabled = true
		}
		else
		{
			if ( file.hasLocalPlayerCompletedNewPlayerOrientation )
			{
				
				isEnabled = true
			}
			else if ( file.hasLocalPlayerCompletedTraining )
			{
				
				if ( button == file.slotToButtonMap["training"] || button == file.slotToButtonMap["firing_range"] || button == file.slotToButtonMap["regular_1"] )
					isEnabled = true
			}
			else
			{
				
				if ( button == file.slotToButtonMap["training"] )
					isEnabled = true
			}
		}







			
			if ( isRankedBR )
			{
				if ( Playlist_ShouldLockRankedPlaylistForPatch( playlistName ) || Playlist_IsPastRankedSeasonEndDate() )
				{
					isEnabled = false
					RuiSetBool( rui, "showLockedIcon", true )
					RuiSetBool( rui, "isLocked", true )
				}
				RuiSetGameTime( rui, "nextRankUpdateTime", RUI_BADGAMETIME )
			}

			Hud_SetEnabled( button, isEnabled )

			if ( slotKey == "regular_1" )
				mainPlaylist = playlistName

			GamemodeSelect_UpdateSelectButton( button, playlistName, slotKey )
		}

		
		if ( isRankedBR )
		{
			
			bool isLadderOnlyRank = Ranked_IsLocalPlayerInLadderOnlyTier()
			RuiSetBool( rui, "isLadderRank", isLadderOnlyRank )
		}
	}
	
	var backgroundRui = Hud_GetRui( file.gameModeButtonBackground )

	
	string playlistName = file.slotToPlaylistNameMap[ "regular_1" ]
	int mapIdx = playlistName != "" ? GetPlaylistActiveMapRotationIndex( playlistName ) : -1
	string panelImageKey = GetPlaylistMapVarString( playlistName, mapIdx, "panel_image", "" )
	string rotationMapName = GetPlaylistMapVarString( playlistName, mapIdx, "map_name", "" )

	asset panelImageAsset = GetImageFromImageMap( panelImageKey )
	if ( HasEventTakeOverActive() && IsPlaylistLockedForEvent( playlistName ) )
	{
		panelImageAsset = GetImageFromImageMap("play_apex_panel_locked")
	}

	int remainingTimeSeconds = GetPlaylistRotationNextTime() - GetUnixTimestamp()

	RuiSetImage( backgroundRui, "modeImage", panelImageAsset )
	RuiSetString( backgroundRui, "modeNameText", GetPlaylistVarString( mainPlaylist, "survival_takeover_name", "#PL_PLAY_APEX" ) ) 
	RuiSetString( backgroundRui, "mapDisplayName", rotationMapName ) 
	RuiSetGameTime( backgroundRui, "rotationGroupNextTime", ClientTime() + remainingTimeSeconds ) 


	if ( file.featuredSlot == "" || FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )



		RuiSetInt( backgroundRui, "featuredState", FEATURED_NONE )
	else
		RuiSetInt( backgroundRui, "featuredState", FEATURED_INACTIVE )

	if(file.mapPreviewSlotKey != "")
	{
		file.mapPreviewPlaylistName = file.slotToPlaylistNameMap[ file.mapPreviewSlotKey ]
		GamemodeSelect_UpdateMixtapePreview(file.mapPreviewPlaylistName, file.mapPreviewSlotKey )
	}
}

void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}



#if DEV
void function ShippingPlaylistCheck()
{


		if ( GetCurrentPlaylistVarBool( "this_is_a_dev_playlist", false ) )
			Hud_SetText( Hud_GetChild( file.panel, "PlaylistWarning" ), "Warning: this is not a shipping playlist" )

}
#endif



void function UpdateCrafting()
{

		
		if ( GetCurrentPlaylistVarBool( "crafting_enabled", true ) )
		{
			
			if ( AreCraftingDispensersEnabled() )
				return

			
			RunClientScript( "UICallback_PopulateCraftingPanel", file.craftingPreview )
		}

}

bool function AreCraftingDispensersEnabled()
{
	return GetCurrentPlaylistVarBool( "crafting_dispensers_enabled", true )
}

const float startBuffer = 0.05

void function AnimateIn()
{
	
	SetElementAnimations( file.header, 0.35, 0.07 )

	if ( Hud_IsVisible( file.disabledCover ) )
		SetElementAnimations( file.disabledCover, 0, 0.07 )

	
	SetElementAnimations(file.gameModeButtonBackground, 0, 0.07)
	SetElementAnimations(file.slotToButtonMap["ranked"], 0.07, 0.07)
	SetElementAnimations(Hud_GetChild(file.panel,"SurvivalCategory" ), 0.07, 0.07)
	
	if( file.hasRegular0 )
		SetElementAnimations(file.slotToButtonMap["regular_0"], 0.11, 0.07)

	SetElementAnimations(file.slotToButtonMap["regular_1"], 0.14, 0.07)

	if( file.hasRegular2 )
		SetElementAnimations(file.slotToButtonMap["regular_2"], 0.17, 0.07)

	if( file.hasRegular3 )
		SetElementAnimations(file.slotToButtonMap["regular_3"], 0.20, 0.07)
	
	SetElementAnimations(file.slotToButtonMap["mixtape"], 0.14, 0.07)

	SetElementAnimations(Hud_GetChild(file.panel,"MixtapeCategory" ), 0.21, 0.07)
	if(file.hasLTM)
	{
		SetElementAnimations(file.slotToButtonMap["ltm"], 0.28, 0.07)
		SetElementAnimations(Hud_GetChild(file.panel,"LTMCategory" ), 0.28, 0.07)
		Hud_SetPinSibling(file.slotToButtonMap["training"], "GameModeButton7")

		
		Hud_SetNavRight( file.slotToButtonMap["mixtape"], file.slotToButtonMap["ltm"] )
		Hud_SetNavLeft( file.slotToButtonMap["training"], file.slotToButtonMap["ltm"] )

			Hud_SetNavLeft( file.slotToButtonMap["bot_playground"], file.slotToButtonMap["ltm"] )

		Hud_SetNavLeft( file.slotToButtonMap["firing_range"], file.slotToButtonMap["ltm"] )

	}else{
		Hud_SetPinSibling(file.slotToButtonMap["training"], "GameModeButton6")
		
		Hud_SetNavRight( file.slotToButtonMap["mixtape"], file.slotToButtonMap["training"] )
		Hud_SetNavLeft( file.slotToButtonMap["training"], file.slotToButtonMap["mixtape"] )

			Hud_SetNavLeft( file.slotToButtonMap["bot_playground"], file.slotToButtonMap["mixtape"] )

		Hud_SetNavLeft( file.slotToButtonMap["firing_range"], file.slotToButtonMap["mixtape"] )
	}
	
	SetElementAnimations(Hud_GetChild(file.panel,"PracticeCategory" ), 0.35, 0.07)
	SetElementAnimations(file.slotToButtonMap["training"], 0.35,  0.07)

		SetElementAnimations(file.slotToButtonMap["bot_playground"], 0.35,  0.07)

	SetElementAnimations(file.slotToButtonMap["firing_range"], 0.35, 0.07)
	SetElementAnimations(file.slotToButtonMap["event"], 0.35, 0.07)

	bool animateCraftingRui = !AreCraftingDispensersEnabled()

	if ( animateCraftingRui )
	{
		SetElementAnimations(file.craftingPreview, 0.35, 0.07)
		RuiSetInt( Hud_GetRui(file.craftingPreview), "animationDirection", 1 )
	}
	else
	{
		Hud_SetVisible( file.craftingPreview, false )
	}

}

void function SetElementAnimations( var element, float delay, float duration )
{
	RuiSetWallTimeWithOffset( Hud_GetRui( element ), "animateStartTime", startBuffer + delay )
	RuiSetFloat( Hud_GetRui( element ), "animateDuration", duration )
}

void function CrossFadeCraftingMapPreview(var button, bool showMixtape = false, bool allowCraftingRotationToBeSeen = true)
{
	foreach ( string slotKey, slotButton in file.slotToButtonMap )
	{
		
		bool isMixtape = slotButton == button && ( slotKey == "mixtape" )
		bool isRanked  = slotButton == button && ( slotKey == "ranked" )
		bool isLtm = slotButton == button && ( slotKey == "ltm" )
		bool isPub = slotButton == button && ( slotKey == "regular_0" || slotKey == "regular_1" || slotKey == "regular_2" || slotKey == "regular_3")

		if( isMixtape || isRanked || isPub || isLtm )
		{
			
			var craftingRui = Hud_GetRui( file.craftingPreview )
			var mixtapeRui  = Hud_GetRui( file.mixtapePreview )

			string playlistName = file.slotToPlaylistNameMap[slotKey]
			GamemodeSelect_UpdateMixtapePreview(playlistName, slotKey )

			float delayTime = startBuffer

			Hud_SetVisible(file.craftingPreview, allowCraftingRotationToBeSeen)
			file.mapPreviewPlaylistName = ""
			file.mapPreviewSlotKey      = ""

			if(showMixtape)
			{
				Hud_SetVisible(file.mixtapePreview, true)
				file.mapPreviewPlaylistName = playlistName
				file.mapPreviewSlotKey      = slotKey
			}

			float startOffset = delayTime

			RuiSetInt( craftingRui, "animationDirection", (showMixtape)? -1: 1 )
			RuiSetWallTimeWithOffset( craftingRui, "animateStartTime", startOffset )
			RuiSetFloat( craftingRui, "animateDuration", 0.1 )

			RuiSetInt( mixtapeRui, "animationDirection", (showMixtape)? 1: -1 )
			RuiSetWallTimeWithOffset( mixtapeRui, "animateStartTime", startOffset )
			RuiSetFloat( craftingRui, "animateDuration", 0.1 )

			break
		}
	}
}




table<string, string> function GameModeSelect_GetPlaylists()
{
	table<string, string> slotToPlaylistNameMap
	foreach ( slotKey, button  in file.slotToButtonMap )
		slotToPlaylistNameMap[ slotKey ] <- ""

	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	foreach ( string plName in playlistNames )
	{
		if ( plName == PLAYLIST_NEW_PLAYER_ORIENTATION && HasLocalPlayerCompletedNewPlayerOrientation() && !DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation() )
			continue

		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )
		if ( uiSlot == "" )
			continue

		if ( uiSlot == "arenas")
			continue

		if ( uiSlot == "story" )
			continue

		if(  uiSlot in slotToPlaylistNameMap )
		{
			if ( slotToPlaylistNameMap[uiSlot] != "" )
			{
				
				bool currPlaylistIsAvailable     = Lobby_IsPlaylistAvailable( plName )
				bool currSlotPlaylistIsAvailable = Lobby_IsPlaylistAvailable( slotToPlaylistNameMap[uiSlot] )
				if ( !currSlotPlaylistIsAvailable && currPlaylistIsAvailable )
					slotToPlaylistNameMap[uiSlot] = plName
			}
			else
			{
				slotToPlaylistNameMap[uiSlot] = plName
			}
		}
	}
	return slotToPlaylistNameMap
}



void function GamemodeSelect_UpdateSelectButton( var button, string playlistName, string slot = "" )
{
	var rui = Hud_GetRui( button )

	if ( playlistName == "" )
		Warning( FUNC_NAME() + ": Function called with empty playlistName!" )
	

	int mapIdx = playlistName != "" ? GetPlaylistActiveMapRotationIndex( playlistName ) : -1

	bool doDebug = (InputIsButtonDown( KEY_LSHIFT ) && InputIsButtonDown( KEY_LCONTROL )) || (InputIsButtonDown( BUTTON_TRIGGER_LEFT_FULL ) && InputIsButtonDown( BUTTON_B ))
	RuiSetString( rui, "modeNameText", GamemodeSelect_GetModeName( playlistName, mapIdx, "#PLAYLIST_UNAVAILABLE" ) )
	RuiSetString( rui, "playlistName", playlistName )
	RuiSetString( rui, "playlistTypeText", "" )


	if ( GetPlaylistVarString( playlistName, "ui_slot", "" ) == "mixtape" )
		RuiSetString( rui, "playlistTypeText", "#GAMEMODE_CATEGORY_MIXTAPE" )


	RuiSetBool( rui, "doDebug", doDebug )

	string descText = GetPlaylistMapVarString( playlistName, mapIdx, "description", "#HUD_UNKNOWN" )
	RuiSetString( rui, "modeDescText", descText )
	RuiSetString( rui, "modeLockedReason", "" )
	RuiSetBool( rui, "alwaysShowDesc", false )
	RuiSetBool( rui, "isPartyLeader", false )
	RuiSetBool( rui, "showLockedIcon", true )

	string imageKey  = GetPlaylistMapVarString( playlistName, mapIdx, "image", "" )
	asset imageAsset = GetImageFromImageMap( imageKey )
	asset thumbnailAsset = GetThumbnailImageFromImageMap( imageKey )
	if ( HasEventTakeOverActive() && IsPlaylistLockedForEvent( playlistName ) )
	{
		if ( GetPlaylistVarString( playlistName, "ui_slot", "" ) == "mixtape" )
			imageAsset = GetImageFromImageMap( "mixtape_locked" )
		else
			imageAsset = GetImageFromImageMap( imageKey + "_event_locked" )

		thumbnailAsset = GetThumbnailImageFromImageMap( "event_locked" )
		RuiSetBool( rui, "eventLocked", true )
	}
	string iconKey = GetPlaylistMapVarString( playlistName, mapIdx, "lobby_mini_icon", "" )
	asset iconAsset = GetImageFromMiniIconMap( iconKey )
	RuiSetImage( Hud_GetRui( button ), "modeImage", imageAsset )
	RuiSetImage( Hud_GetRui( button ), "thumbnailImage", thumbnailAsset )
	RuiSetImage( Hud_GetRui( button ), "expandArrowImage", iconAsset )

	bool isPlaylistAvailable = Lobby_IsPlaylistAvailable( playlistName )
	Hud_SetLocked( button, !isPlaylistAvailable )
	int playlistState = LobbyPlaylist_GetPlaylistState( playlistName )
	string playlistStateString = LobbyPlaylist_GetPlaylistStateString( playlistState )

	RuiSetString( rui, "modeLockedReason", playlistStateString )

	
	RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

	bool hideCountDown = GetPlaylistVarBool( playlistName, "force_hide_schedule_block_countdown", false )
	if (!hideCountDown)
	{

		if( RankedRumble_IsRankedRumblePlaylist( playlistName ) )
		{
			TimestampRange ornull rankedRumbleTimeRange = RankedRumble_CurrentRankedRumbleTimestampRange()
			if ( rankedRumbleTimeRange != null )
			{
				int rankedRumbleRemainingDuration = expect TimestampRange( rankedRumbleTimeRange ).endUnixTime - GetUnixTimestamp()

				RuiSetGameTime( rui, "expireTime", ClientTime() + rankedRumbleRemainingDuration )
			}
		}
		else

		{
			TimestampRange ornull playlistTimeRange = Playlist_GetPlaylistScheduledTimeRange( playlistName )
			if ( playlistTimeRange != null )
			{
				int remainingDuration = expect TimestampRange( playlistTimeRange ).endUnixTime - GetUnixTimestamp()
				
				if ( GameModeVariant_IsActiveForPlaylist( playlistName, eGameModeVariants.SURVIVAL_RANKED ) && Playlist_HasRankedSeasonEndDate() )
				{
					int ornull seasonEndDate = Playlist_GetRankedSeasonEndDate()
					expect int( seasonEndDate )
					remainingDuration = seasonEndDate - GetUnixTimestamp()
				}

				RuiSetGameTime( rui, "expireTime", ClientTime() + remainingDuration )
			}
		}
	}

	int emblemMode = DRAW_NONE
	if ( GameModeVariant_IsActiveForPlaylist( playlistName, eGameModeVariants.SURVIVAL_RANKED ) )
	{
		emblemMode = DRAW_RANK
		int rankScore      = 0
		int ladderPosition = 0


		if ( RankedRumble_IsRunningRankedRumble() )
		{
			table scorePosition = RankedRumble_GetHighestRankedScoreAndPositionAcrossPlatforms( GetLocalClientPlayer() )
			rankScore = expect int( scorePosition.score )
			ladderPosition = expect int( scorePosition.position )
#if DEV
				if ( GetConVarBool( "enableRankedRumblePositionLog" ) )
					printt( "panel_gamemode_select_public is RR", rankScore, ladderPosition )
#endif
		}
		else

		{
			rankScore = GetPlayerRankScore( GetLocalClientPlayer() )
			ladderPosition = Ranked_GetLadderPosition( GetLocalClientPlayer() )
#if DEV
				if ( GetConVarBool( "enableRankedRumblePositionLog" ) )
					printt( "panel_gamemode_select_public NOT RR", rankScore, ladderPosition )
#endif
		}

		if ( Ranked_ShouldUpdateWithComnunityUserInfo( rankScore, ladderPosition ) ) 
			file.rankedRUIToUpdate = rui


		PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
	}
	else if (button != file.slotToButtonMap["firing_range"])
	{
		asset emblemImage = GetModeEmblemImage( playlistName )
		if ( emblemImage != $"" )
		{
			emblemMode = DRAW_IMAGE
			RuiSetImage( rui, "emblemImage", emblemImage )
		}
	}
	RuiSetInt( rui, "emblemMode", emblemMode )

	file.selectButtonPlaylistNameMap[button] <- playlistName

	if ( file.featuredSlot == "" || slot == "" )
	{
		RuiSetInt( rui, "featuredState", FEATURED_NONE )
	}
	else
	{
		if ( slot == file.featuredSlot )
		{
			RuiSetInt( rui, "featuredState", FEATURED_ACTIVE )
			RuiSetString( rui, "featuredString", file.featuredSlotString )

			RuiSetBool ( rui, "featuredIsFTUE", FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )

		}
		else
		{

			if ( FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
				RuiSetInt( rui, "featuredState", FEATURED_NONE )
			else
				RuiSetInt( rui, "featuredState", FEATURED_INACTIVE )



		}
	}


	if ( !FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )

	{
		
		ItemFlavor ornull cupFlavor = Cups_GetActiveCupForPlaylist( playlistName, GetLocalClientPlayer() )
		if ( cupFlavor != null )
		{
			expect ItemFlavor( cupFlavor )

			UserCupEntryData cupEntryData = Cups_GetPlayersPCupData( GetLocalClientPlayer(), ItemFlavor_GetGUID( cupFlavor ) )
			ItemFlavor cupEventFlavor = CupFlavor_GetEvent( cupFlavor )
			int cupEventCount = CupEvent_GetMatchCount( cupEventFlavor )

			
			bool cupHasSquadSize = false
			int cupSquadSize = 0
			bool badSquadSize = false
			bool isLimitSquadSize = CupEvent_GetLimitSquadSize( cupEventFlavor )
			if ( isLimitSquadSize )
			{
				cupHasSquadSize = true
				cupSquadSize = CupEvent_GetSquadSize( cupEventFlavor )
				badSquadSize = cupSquadSize != GetPartySize()
			}

			
			bool rumbleComplete = cupEntryData.numMatches >= cupEventCount
			bool rumbleInactive = badSquadSize || rumbleComplete

			
			string progressString = ""
			if ( cupEntryData.registered )
				progressString = Localize( "#GAMEMODE_APEX_CUPS_FEATURE", cupEntryData.numMatches, cupEventCount )
			else
				progressString = Localize( "#GAMEMODE_APEX_CUPS_FEATURE_AVAILABLE" )

			
			RuiSetInt( rui, "featuredState", FEATURED_ACTIVE )
			RuiSetString( rui, "featuredString", progressString )
			RuiSetBool( rui, "featuredDisabled", rumbleInactive && cupEntryData.registered )
			RuiSetBool( rui, "featuredInfoVisible", cupHasSquadSize )
			RuiSetString( rui, "featuredInfoString", isLimitSquadSize ? Localize( "#APEX_CUPS_PARTY_SIZE", cupSquadSize ): "" )
			RuiSetBool( rui, "featuredInfoDisabled", badSquadSize && cupEntryData.registered && !rumbleComplete )
		}
	}

	int RotationTimeLeft = ( playlistName != "" )? GetPlaylistActiveMapRotationTimeLeft( playlistName ): 0
	if( IsPlaylistInActiveRotation( playlistName ) )
	{
		string ornull rotationName = GetPlaylistRotationNameFromPlaylist( playlistName )
		RotationTimeLeft = GetPlaylistRotationNextTime( rotationName ? expect string( rotationName ) : "" ) - GetUnixTimestamp()
	}

	string mapName =  GetPlaylistMapVarString( playlistName, mapIdx, "map_name", "" )
	RuiSetString( rui, "mapDisplayName", mapName )

	if( RotationTimeLeft > 0 )
	{
		RuiSetGameTime( rui, "rotationGroupNextTime", ClientTime() + RotationTimeLeft - 1) 
	}

	for ( int i = 1; i <= 2; i++ )
	{
		if ( slot == "regular_" + i )
		{
			RTKPlayMenuTakeoverModelStruct takeoverStruct
			if ( RotationTimeLeft > 0
					&& GetPlaylistVarBool( playlistName, "ui_slot_regular_" + i + "_timer", true )
					&& GetPlaylistVarString( playlistName, "ui_slot", "" ) == "regular_" + i
					&& GetPlaylistVarBool( playlistName, "show_regular_mode_button_timer", false ) )
			{
				TimestampRange ornull playlistTimeRange = Playlist_GetPlaylistScheduledTimeRange( playlistName )
				if ( playlistTimeRange != null )
				{
					takeoverStruct.endTime = expect TimestampRange( playlistTimeRange ).endUnixTime
				}
				else
				{
					takeoverStruct.endTime = RotationTimeLeft + GetUnixTimestamp()
				}
			}
			else
			{
				takeoverStruct.endTime = 0
			}

			rtk_struct playMenuModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "play", "RTKPlayMenuModelStruct" )
			rtk_struct takeoverSlotModelStruct = RTKStruct_GetOrCreateScriptStruct( playMenuModel, "takeoverSlot" + i, "RTKPlayMenuTakeoverModelStruct" )
			RTKStruct_SetValue( takeoverSlotModelStruct, takeoverStruct )
		}
	}
}

void function GameModeSelect_OnPartyChanged()
{
	UpdateGameModes()
}

void function GamemodeSelect_UpdateMixtapePreview( string playlistName, string slotKey )
{
	int mapsCount = 4
	var rui = Hud_GetRui( file.mixtapePreview )

	
	for( int i = 1; i <= mapsCount; i++ )
	{
		RuiSetString( rui, "map" + i + "Name", "" )
		RuiSetString( rui, "map" + i + "Mode", $"" )
		RuiSetImage( rui, "map" + i + "Image", $"" )
	}

	string ornull rotationID
	if( slotKey == "regular_0" || slotKey == "regular_1" || slotKey == "regular_2" || slotKey == "regular_3" )
	{
		string pubsPlaylistName = GetCurrentPlaylistInUiSlot( "regular_1" )
		rotationID = GetPlaylistRotationNameFromPlaylist( pubsPlaylistName )
	}
	else
		rotationID = GetPlaylistRotationNameFromPlaylist( playlistName )

	int mapNumber = 0
	while ( mapNumber < mapsCount && rotationID != null )
	{
		expect string( rotationID )
		string nextName = playlistName

		if( mapNumber != 0 )
			nextName = GetNextPlaylistFromRotationAndUISlotAndSkip( rotationID, slotKey, mapNumber - 1 )

		string mapName = GetPlaylistMapVarString( nextName, 0, "map_name", "" )
		string modeName = GamemodeSelect_GetModeName( nextName, 0 )
		asset thumbnailAsset

		if( slotKey == "regular_0" || slotKey == "regular_1" || slotKey == "regular_2" || slotKey == "regular_3" )
		{
			string imageKey  = GetPlaylistMapVarString( nextName, 0, "panel_image", "" )
			thumbnailAsset = GetThumbnailImageFromImageMap( imageKey )
		}
		else
		{
			string imageKey  = GetPlaylistMapVarString( nextName, 0, "image", "" )
			thumbnailAsset = GetThumbnailImageFromImageMap( imageKey )
		}

		RuiSetString( rui, "map" + ( mapNumber + 1 ) + "Name", mapName )
		RuiSetString( rui, "map" + ( mapNumber + 1 ) + "Mode", modeName)
		RuiSetImage( rui, "map" + ( mapNumber + 1 ) + "Image", thumbnailAsset )

		mapNumber++
	}
}

string function GamemodeSelect_GetModeName( string playlistName, int index, string defaultName = "" )
{

	if ( RankedRumble_IsRankedRumblePlaylist( playlistName ) )
		return "#RANKED_RUMBLE"
	else

	return GetPlaylistMapVarString( playlistName, index, "name", defaultName )
	unreachable
}





void function GamemodeSelect_PlayVideo( var button, string playlistName )
{
	string videoKey         = GetPlaylistVarString( playlistName, "video", "" )
	asset desiredVideoAsset = GetBinkFromBinkMap( videoKey )

	if ( desiredVideoAsset != $"" )
		file.currentVideoAsset = $"" 
	Signal( uiGlobal.signalDummy, "GamemodeSelect_EndVideoStopThread" )
	Assert( file.currentVideoAsset == $"" )

	if ( desiredVideoAsset != $"" )
	{
		if ( file.videoChannel == -1 )
			file.videoChannel = ReserveVideoChannel()

		StartVideoOnChannel( file.videoChannel, desiredVideoAsset, true, 0.0 )
		file.currentVideoAsset = desiredVideoAsset
	}

	var rui = Hud_GetRui( button )
	RuiSetBool( rui, "hasVideo", videoKey != "" )
	RuiSetInt( rui, "channel", file.videoChannel )
	if ( file.currentVideoAsset != $"" )
		thread VideoStopThread( button )
}

void function VideoStopThread( var button )
{
	EndSignal( uiGlobal.signalDummy, "GamemodeSelect_EndVideoStopThread" )

	OnThreadEnd( function() : ( button ) {
		if ( IsValid( button ) )
		{
			var rui = Hud_GetRui( button )
			RuiSetInt( rui, "channel", -1 )
		}
		if ( file.currentVideoAsset != $"" )
		{
			StopVideoOnChannel( file.videoChannel )
			file.currentVideoAsset = $""
		}
	} )

	while ( GetFocus() == button )
		WaitFrame()

	wait 0.3
}





void function ClearFeaturedSlotAfterDelay()
{
	float startTime = UITime()
	while ( UITime() - startTime < 3.0 && GetActiveMenu() == file.panel )
	{
		WaitFrame()
	}

	GamemodeSelect_SetFeaturedSlot( "" )
	if ( GetActiveMenu() == GetParentMenu( file.panel ) )
		UpdateOpenModeSelectDialog()
}

void function Ranked_OnUserInfoUpdatedInGameModeSelect( string hardware, string id )
{
	if ( !IsConnected() )
		return

	if ( !IsLobby() )
		return

	if ( hardware == "" && id == "" )
		return

	CommunityUserInfo ornull cui = GetUserInfo( hardware, id )

	if ( cui == null )
		return

	expect CommunityUserInfo( cui )

	if ( cui.hardware == GetPlayerHardware() && cui.uid == GetPlayerUID() ) 
	{
		if ( file.rankedRUIToUpdate != null  ) 
		{
			PopulateRuiWithRankedBadgeDetails( file.rankedRUIToUpdate, cui.rankScore, cui.rankedLadderPos )
		}
	}
}

array<string> function GetPlaylistsInRegularSlots()
{
	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	array<string> regularList
	foreach ( string plName in playlistNames )
	{
		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )

		if ( uiSlot.find( "regular" ) == 0 )
			regularList.append( plName )
	}

	return regularList
}


void function NavigateBackToFTUEModal( var button )
{
	FTUEFlow_OpenCYOAMenu()
}





void function GamemodeSelect_SetFeaturedSlot( string slot, string modeString = "#HEADER_NEW_MODE" )
{
	file.featuredSlot = slot
	file.featuredSlotString = modeString
}

