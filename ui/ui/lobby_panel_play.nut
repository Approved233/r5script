global function InitPlayPanel
global function PlayPanel_LevelInit
global function PlayPanel_LevelShutdown

global function IsPlayPanelCurrentlyTopLevel
global function PlayPanelUpdate
global function ClientToUI_PartyMemberJoinedOrLeft
global function GetModeSelectButton
global function GetLobbyChatBox

global function Lobby_OnGamemodeSelectClose
global function Lobby_UpdateLoadscreenFromPlaylist

global function Lobby_ResetAreLobbyButtonsUpdating

global function Lobby_UpdatePlayPanelPlaylists

global function UpdateMiniPromoPinning

global function UpdateLootBoxButton
global function UpdateLobbyButtons

global function ShouldShowMatchmakingDelayDialog
global function ShowMatchmakingDelayDialog
global function ShouldShowLastGameRankedAbandonForgivenessDialog
global function ShowLastGameRankedAbandonForgivenessDialog

global function ReadyShortcut_OnActivate

global function IsLocalPlayerExemptFromTraining

global function DialogFlow_DidCausePotentiallyInterruptingPopup

global function Lobby_ShowCallToActionPopup

global function OpenGameModeSelectDialog

global function JoinMatchAsPartySpectatorFailedAddedToWaitlistDialog

global function JoinMatchAsWaitlistedPartySpectatorDialog

global function UICodeCallback_PlayerCanJoinParty

global function ServerCallback_GamemodeSelectorInitialize
global function GetGamemodeSelectorPlaylist
global function DismissGamemodeSelector
global function DismissGamemodeSelectorModal
global function HasGamemodeSelector
global function UpdateButtonsPositions
#if DEV
global function DEV_PrintPartyInfo
global function DEV_PrintUserInfo
global function Lobby_MovePopupMessage
global function Lobby_ShowBattlePassPopup
global function Lobby_ShowHeirloomShopPopup
global function Lobby_ShowLegendsTokenPopup
global function Lobby_ShowStoryEventChallengesPopup
global function Lobby_ShowStoryEventAutoplayDialoguePopup
global function FillButton_Toggle
global function FillButton_SetState
global function ReadyButtonActivate
#endif


global function ServerCallback_SetPlaylistById


global struct RTKPlayMenuTakeoverModelStruct
{
	int endTime = 0
}

global struct RTKPlayMenuModelStruct
{
	RTKPlayMenuTakeoverModelStruct& aboutModeTimer
	RTKPlayMenuTakeoverModelStruct& takeoverSlot1
	RTKPlayMenuTakeoverModelStruct& takeoverSlot2
}

const asset RANKED_DECAY_ICON = $"rui/menu/ranked/extrainfo_icon_small"

const string SOUND_BP_POPUP = "UI_Menu_BattlePass_PopUp"

const string SOUND_START_MATCHMAKING_1P = "UI_Menu_ReadyUp_1P"
const string SOUND_STOP_MATCHMAKING_1P = "UI_Menu_ReadyUp_Cancel_1P"
const string SOUND_START_MATCHMAKING_3P = "UI_Menu_ReadyUp_3P"
const string SOUND_STOP_MATCHMAKING_3P = "UI_Menu_ReadyUp_Cancel_3P"

const float INVITE_LAST_TIMEOUT = 15.0
const float INVITE_LAST_PANEL_EXPIRATION = 1 * MINUTES_PER_HOUR * SECONDS_PER_MINUTE

const int FEATURED_NONE = 0
const int FEATURED_ACTIVE = 1

struct BattlePassInfo
{
	ItemFlavor ornull battlePassOrNull
	int bpExpirationTimestamp
}

const vector TOOLTIP_COLOR_RED = <226, 55, 62>

#if DEV
int automateUIMatchCount = 0
#endif

struct
{
	var panel
	var chatBox
	var chatroomMenu
	var chatroomMenu_chatroomWidget

	var fillButton
	var modeButton
	var gamemodeSelectButton
	var readyButton
	var trainingButton
	var inviteFriendsButton0
	var inviteFriendsButton1
	var inviteLastPlayedHeader
	var inviteLastPlayedUnitFrame0
	var inviteLastPlayedUnitFrame1
	var friendButton0
	var friendButton1
	var selfButton

	var allChallengesButton
	var viewEventButton
	var storyPrizeTrackButton

	var miniPromoButton




	var challengesRightButton
	var challengesLeftButton

	bool newModesAcknowledged = false

	var hdTextureProgress

	int lastExpireTime

	string lastVisiblePlaylistValue
	int lastPartySize = 0
	bool lastCuiIsValid = false
	int lastMaxTeamSize = 0

	bool personInLeftSpot = false
	bool personInRightSlot = false

	Friend& friendInLeftSpot
	Friend& friendInRightSpot

	string lastPlayedPlayerUID0 = ""
	string lastPlayedPlayerNucleusID0 = ""
	int    lastPlayedPlayerHardwareID0 = -1
	string lastPlayedPlayerUID1 = ""
	string lastPlayedPlayerNucleusID1 = ""
	int    lastPlayedPlayerHardwareID1 = -1
	int    lastPlayedPlayerPersistenceIndex0 = -1
	int    lastPlayedPlayerPersistenceIndex1 = -1
	float  lastPlayedPlayerInviteSentTimestamp0 = -1
	float  lastPlayedPlayerInviteSentTimestamp1 = -1


	bool leftWasReady = false
	bool rightWasReady = false

	var inviteFriendsButton2
	var inviteLastPlayedUnitFrame2
	var friendButton2

	bool personInFourthSlot = false

	Friend& friendInFourthSpot

	string lastPlayedPlayerUID2 = ""
	string lastPlayedPlayerNucleusID2 = ""
	int    lastPlayedPlayerHardwareID2 = -1
	int    lastPlayedPlayerPersistenceIndex2 = -1
	float  lastPlayedPlayerInviteSentTimestamp2 = -1

	bool fourthWasReady = false

	bool fullInstallNotification = false
	bool skipDialogCheckForActivateReadyButton = false

	bool wasReady = false

	float showReadyReminderTime = 0

	bool  haveShownSelfMatchmakingDelay = false
	bool  haveShownPartyMemberMatchmakingDelay = false
	bool  haveShownLastGameRankedAbandonForgivenessDialog = false
	int   lobbyRankTier = -1
	bool  rankedInitialized = false
	var   rankedRUIToUpdate = null




	void functionref() onCallToActionFunc

	string lastPlaylistDisplayed

	table<string, float> s_cachedAccountXPFrac

	bool dialogFlowDidCausePotentiallyInterruptingPopup = false

	var  challengeCategorySelection
	bool challengeInputCallbacksRegistered = false
	int  challengeLastStickState = eStickState.NEUTRAL

	float nextAllowFriendsUpdateTime

	
	bool fillButtonWasFullSquad = false
	bool fillButtonWasHidden = false
	bool fillButtonState = true

	bool isShowing = false

	BattlePassInfo currentBPInfo

	bool areLobbyButtonsUpdating
	int  isLocalPlayerExemptFromTraining = eTrainingExemptionState.UNINITIALIZED


	var partyMemberNotice


	var gamemodeSelectorModalPanel
	string gamemodeSelectorPlaylist = ""
	int selectedPlaylistIndex = 0
	bool gamemodeSelectorModalDismissed = false
} file

void function InitPlayPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PlayPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PlayPanel_OnHide )
	AddPanelEventHandler( panel, eUIEvent.PANEL_NAVBACK, PlayPanel_OnNavBack )

	SetPanelInputHandler( panel, BUTTON_Y, ReadyShortcut_OnActivate )

	rtk_struct playMenuModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "play", "RTKPlayMenuModelStruct" ) 

	file.fillButton = Hud_GetChild( panel, "FillButton" )
	Hud_AddEventHandler( file.fillButton, UIE_CLICK, FillButton_OnActivate )

	file.modeButton = Hud_GetChild( panel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeButton_OnActivate )

	file.gamemodeSelectButton = Hud_GetChild( panel, "gamemodeSelectButton" )
	Hud_AddEventHandler( file.gamemodeSelectButton, UIE_CLICK, GamemodeSelectButton_OnActivate )
	Hud_AddEventHandler( file.gamemodeSelectButton, UIE_GET_FOCUS, GamemodeSelectButton_OnGetFocus )
	Hud_SetVisible( file.gamemodeSelectButton, false )
	file.gamemodeSelectorModalPanel = Hud_GetChild( panel, "GamemodeSelectorModalPanel" )
	Hud_AddEventHandler( file.gamemodeSelectorModalPanel, UIE_CLICK, DismissGamemodeSelectorModal )
	file.readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( file.readyButton, UIE_CLICK, ReadyButton_OnActivate )

	file.inviteFriendsButton0 = Hud_GetChild( panel, "InviteFriendsButton0" )
	Hud_AddEventHandler( file.inviteFriendsButton0, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteFriendsButton1 = Hud_GetChild( panel, "InviteFriendsButton1" )
	Hud_AddEventHandler( file.inviteFriendsButton1, UIE_CLICK, InviteFriendsButton_OnActivate )


	file.inviteFriendsButton2 = Hud_GetChild( panel, "InviteFriendsButton2" )
	Hud_AddEventHandler( file.inviteFriendsButton2, UIE_CLICK, InviteFriendsButton_OnActivate )

	RuiSetBool( Hud_GetRui( file.inviteFriendsButton0 ), "useNarrowLinebreak", true )
	RuiSetBool( Hud_GetRui( file.inviteFriendsButton1 ), "useNarrowLinebreak", true )
	RuiSetBool( Hud_GetRui( file.inviteFriendsButton2 ), "useNarrowLinebreak", true )


	file.inviteLastPlayedHeader = Hud_GetChild( panel, "InviteLastSquadHeader" )
	Hud_Hide( file.inviteLastPlayedHeader )

	file.inviteLastPlayedUnitFrame0 = Hud_GetChild( panel, "InviteLastPlayedUnitframe0" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddKeyPressHandler( file.inviteLastPlayedUnitFrame0, InviteLastPlayedButton_OnKeyPress )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame0 )

	file.inviteLastPlayedUnitFrame1 = Hud_GetChild( panel, "InviteLastPlayedUnitframe1" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddKeyPressHandler( file.inviteLastPlayedUnitFrame1, InviteLastPlayedButton_OnKeyPress )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame1 )


	file.inviteLastPlayedUnitFrame2 = Hud_GetChild( panel, "InviteLastPlayedUnitframe2" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame2, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddKeyPressHandler( file.inviteLastPlayedUnitFrame2, InviteLastPlayedButton_OnKeyPress )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame2, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame2 )


	file.selfButton = Hud_GetChild( panel, "SelfButton" )
	Hud_AddEventHandler( file.selfButton, UIE_CLICK, SelfButton_OnActivate )

#if PC_PROG_NX_UI
		RuiSetFloat( Hud_GetRui( file.selfButton ), "lobbyNXOffset", 1.0 )
#endif

	file.friendButton0 = Hud_GetChild( panel, "FriendButton0" )
	Hud_AddKeyPressHandler( file.friendButton0, FriendButton_OnKeyPress )

	file.friendButton1 = Hud_GetChild( panel, "FriendButton1" )
	Hud_AddKeyPressHandler( file.friendButton1, FriendButton_OnKeyPress )


	file.friendButton2 = Hud_GetChild( panel, "FriendButton2" )
	Hud_AddKeyPressHandler( file.friendButton2, FriendButton_OnKeyPress )


	file.allChallengesButton = Hud_GetChild( panel, "AllChallengesButton" )
	Hud_SetVisible( file.allChallengesButton, true )
	Hud_SetEnabled( file.allChallengesButton, true )

	var nextBPRewardButton = Hud_GetChild( panel, "ChallengesNextBPReward" )
	Hud_AddEventHandler( nextBPRewardButton, UIE_CLICK, ChallengeInspectNextReward )

	HudElem_SetRuiArg( file.allChallengesButton, "buttonText", Localize( "#CHALLENGES_LOBBY_BUTTON_SHORT" ) )
	Hud_AddEventHandler( file.allChallengesButton, UIE_CLICK, AllChallengesButton_OnActivate )

	file.viewEventButton = Hud_GetChild( panel, "ViewEventButton" )
	Hud_SetVisible( file.viewEventButton, true )
	Hud_SetEnabled( file.viewEventButton, true )

	file.storyPrizeTrackButton = Hud_GetChild( panel, "StoryPrizeTrackButton" )
	Hud_SetVisible( file.storyPrizeTrackButton, true )
	Hud_SetEnabled( file.storyPrizeTrackButton, true )

	Hud_AddEventHandler( Hud_GetChild( file.panel, "PopupMessage" ), UIE_CLICK, OnClickCallToActionPopup )

	file.challengeCategorySelection = Hud_GetChild( file.panel, "ChallengeCatergorySelection" )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ), UIE_CLICK, IsRTL() ? ChallengeSwitchRight_OnClick : ChallengeSwitchLeft_OnClick )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryRightButton" ), UIE_CLICK, IsRTL() ? ChallengeSwitchLeft_OnClick : ChallengeSwitchRight_OnClick )

	AddMenuVarChangeHandler( "isMatchmaking", UpdateLobbyButtons )

	file.chatBox = Hud_GetChild( panel, "ChatRoomTextChat" )
	file.hdTextureProgress = Hud_GetChild( panel, "HDTextureProgress" )

	file.partyMemberNotice = Hud_GetChild( panel, "PartyMemberNotice" )


	
	
	var chatTextEntry = Hud_GetChild( Hud_GetChild( file.chatBox, "ChatInputLine" ), "ChatInputTextEntry" )
	Hud_SetNavUp( chatTextEntry, chatTextEntry )

	file.miniPromoButton = ( Hud_GetChild( panel, "MiniPromo" ) )
	file.challengesLeftButton = Hud_GetChild( panel, "ChallengeCatergoryLeftButton" )
	file.challengesRightButton = Hud_GetChild( panel, "ChallengeCatergoryRightButton" )
	InitMiniPromo( file.miniPromoButton )

	RegisterSignal( "UpdateFriendButtons" )
	RegisterSignal( "CallToActionPopupThink" )
	RegisterSignal( "Lobby_ShowCallToActionPopup" )

	RegisterSignal( "CallToActionPopupAudioThink" )
	RegisterSignal( "CallToActionPopupAudioCancel" )

	var aboutButton = Hud_GetChild( file.panel, "AboutButton" )
	Hud_AddEventHandler( aboutButton, UIE_CLICK, Lobby_OnClickPlaylistAboutButton )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_AddEventHandler( rankedBadge, UIE_CLICK, OpenRankedInfoPage )















	AddUICallback_OnLevelInit( SharedRanked_OnLevelInit )
	AddCallback_OnPartyMemberAdded( TryShowMatchmakingDelayDialog )
	AddCallback_PartySpectateSlotUnavailableWaitlisted( OnPartySpectateSlotUnavailableWaitlisted )
	AddCallback_PartySpectateSlotAvailable( OnPartySpectateSlotAvailable )
	AddCallback_LobbyPlaylist_OnSelectedPlaylistChanged( Callback_PlayPanel_SetSelectedPlaylist )
	AddCallback_LobbyPlaylist_OnSelectedPlaylistModsChanged( Callback_PlayPanel_SetSelectedPlaylistMods )

#if DEV
	AddMenuThinkFunc( Hud_GetParent( file.panel ), LobbyAutomationThink )
#endif
}

void function Lobby_OnClickPlaylistAboutButton( var button )
{
	string modeRules = GetPlaylist_UIRules()
	if( FeatureHasTutorialTabs( modeRules ) )
		OpenFeatureTutorialDialog( button, modeRules )
}

void function PlayPanel_LevelInit()
{
	if ( IsLobby() == false )
		return

	file.currentBPInfo.battlePassOrNull = GetActiveBattlePass()
	if ( file.currentBPInfo.battlePassOrNull != null )
		file.currentBPInfo.bpExpirationTimestamp = CalEvent_GetFinishUnixTime( expect ItemFlavor( GetActiveSeason( GetUnixTimestamp() ) ) )

	ResetFillButton()
}

void function PlayPanel_LevelShutdown()
{
	if ( file.isShowing )
		PlayPanel_OnHide( file.panel )
}


bool function IsPlayPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}


void function UpdateLastPlayedPlayerInfo()
{
	string oldUid0 = file.lastPlayedPlayerUID0
	string oldUid1 = file.lastPlayedPlayerUID1

	array<string> curPartyMemberUids
	file.lastPlayedPlayerUID0 = ""
	file.lastPlayedPlayerNucleusID0 = ""
	file.lastPlayedPlayerHardwareID0 = -1
	file.lastPlayedPlayerPersistenceIndex0 = -1

	file.lastPlayedPlayerUID1 = ""
	file.lastPlayedPlayerNucleusID1 = ""
	file.lastPlayedPlayerHardwareID1 = -1
	file.lastPlayedPlayerPersistenceIndex1 = -1


	string oldUid2 = file.lastPlayedPlayerUID2
	file.lastPlayedPlayerUID2 = ""
	file.lastPlayedPlayerNucleusID2 = ""
	file.lastPlayedPlayerHardwareID2 = -1
	file.lastPlayedPlayerPersistenceIndex2 = -1


	if ( !IsPersistenceAvailable() || !InviteLastPlayedPanelShouldBeVisible() )
	{
		return
	}

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	foreach ( index, member in GetParty().members )
	{
		curPartyMemberUids.append( member.uid )
	}

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		string lastPlayedPlayerUid     = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].platformUid" ) )
		string lastPlayedNucleusID     = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].nucleusId" ) )
		int lastPlayedPlayerHardwareID = expect int( GetPersistentVar( "lastGameSquadStats[" + i + "].hardwareID" ) )

		if ( lastPlayedPlayerUid == "" || lastPlayedPlayerHardwareID < 0 )
		{
			continue
		}

		
		
		
		if ( !curPartyMemberUids.contains( lastPlayedPlayerUid ) && !curPartyMemberUids.contains( lastPlayedNucleusID ) )
		{

			if ( file.lastPlayedPlayerUID0 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerUID1 && lastPlayedPlayerUid != file.lastPlayedPlayerUID2 )
			{
				file.lastPlayedPlayerUID0 = lastPlayedPlayerUid
				file.lastPlayedPlayerNucleusID0 = lastPlayedNucleusID
				file.lastPlayedPlayerHardwareID0 = lastPlayedPlayerHardwareID
				file.lastPlayedPlayerPersistenceIndex0 = i
			}
			else if ( file.lastPlayedPlayerUID1 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerUID0 && lastPlayedPlayerUid != file.lastPlayedPlayerUID2 )
			{
				file.lastPlayedPlayerUID1 = lastPlayedPlayerUid
				file.lastPlayedPlayerNucleusID1 = lastPlayedNucleusID
				file.lastPlayedPlayerHardwareID1 = lastPlayedPlayerHardwareID
				file.lastPlayedPlayerPersistenceIndex1 = i
			}
			else if ( file.lastPlayedPlayerUID2 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerUID0 && lastPlayedPlayerUid != file.lastPlayedPlayerUID1 )
			{
				file.lastPlayedPlayerUID2 = lastPlayedPlayerUid
				file.lastPlayedPlayerNucleusID2 = lastPlayedNucleusID
				file.lastPlayedPlayerHardwareID2 = lastPlayedPlayerHardwareID
				file.lastPlayedPlayerPersistenceIndex2 = i
			}
















		}
	}

	if ( file.lastPlayedPlayerUID0 == oldUid1 )
	{
		file.lastPlayedPlayerInviteSentTimestamp0 = file.lastPlayedPlayerInviteSentTimestamp1
	}

	if ( file.lastPlayedPlayerUID1 == oldUid0 )
	{
		file.lastPlayedPlayerInviteSentTimestamp1 = file.lastPlayedPlayerInviteSentTimestamp0
	}

	if ( file.lastPlayedPlayerUID0 == oldUid2 )
	{
		file.lastPlayedPlayerInviteSentTimestamp0 = file.lastPlayedPlayerInviteSentTimestamp2
	}

	if ( file.lastPlayedPlayerUID1 == oldUid2 )
	{
		file.lastPlayedPlayerInviteSentTimestamp1 = file.lastPlayedPlayerInviteSentTimestamp2
	}

	if ( file.lastPlayedPlayerUID2 == oldUid0 )
	{
		file.lastPlayedPlayerInviteSentTimestamp2 = file.lastPlayedPlayerInviteSentTimestamp0
	}

	if ( file.lastPlayedPlayerUID2 == oldUid1 )
	{
		file.lastPlayedPlayerInviteSentTimestamp2 = file.lastPlayedPlayerInviteSentTimestamp1
	}

}


bool function InviteLastPlayedPanelShouldBeVisible()
{
	if ( GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" ) > INVITE_LAST_PANEL_EXPIRATION )
		return false

	if ( GetPersistentVarAsInt( "lastGamePlayers" ) == 0 && GetPersistentVarAsInt( "lastGameSquads" ) == 0 )
		return false

	return true
}


bool function LastPlayedPlayerIsInMatch( string playerUID, int playerHardwareID )
{
	string hardware                         = GetNameFromHardware( playerHardwareID )
	CommunityUserInfo ornull userInfoOrNull = GetUserInfo( hardware, playerUID )
	if ( userInfoOrNull != null )
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		return userInfo.charData[ePlayerStryderCharDataArraySlots.PLAYER_IN_MATCH] == 1
	}
	return false
}


void function WatchForLTMModeExpiring( string plName )
{
	RegisterSignal( "WatchForLTMModeExpiring" )

	thread function() : (plName)
	{
		Signal( uiGlobal.signalDummy, "WatchForLTMModeExpiring" )
		EndSignal( uiGlobal.signalDummy, "WatchForLTMModeExpiring" )
		EndSignal( uiGlobal.signalDummy, "LevelShutdown" )
		EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

		while ( !IsFullyConnected() )
			WaitFrame()

		TimestampRange ornull playlistTimeRange = Playlist_GetPlaylistScheduledTimeRange( plName )
		if ( playlistTimeRange == null )
			return 

		int endTime = expect TimestampRange( playlistTimeRange ).endUnixTime
		WaitForUnixTime( endTime )

		printf( "%s() - Playlist '%s' has expired, so refreshing all.", FUNC_NAME(), plName )
		if ( AreWeMatchmaking() )
		{
			CancelMatchmaking()
			Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
			EmitUISound( SOUND_STOP_MATCHMAKING_1P )
			while( AreWeMatchmaking() )
				WaitFrame()
		}
		Lobby_UpdatePlayPanelPlaylists()
		UpdateLobbyButtons()
	}()
}


var function GetModeSelectButton()
{
	return file.modeButton
}


var function GetLobbyChatBox()
{
	return file.chatBox
}


void function PlayPanel_OnShow( var panel )
{
	if ( IsFullyConnected() )
	{
		AccessibilityHint( eAccessibilityHint.LOBBY_CHAT )
		Lobby_UpdatePlayPanelPlaylists()
	}
	UpdateLobbyButtons()

	if ( file.chatroomMenu )
	{
		Hud_Hide( file.chatroomMenu )
		Hud_Hide( file.chatroomMenu_chatroomWidget )
	}
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateFriendButtons )

	AddCallback_OnGRXOffersRefreshed( UpdateViewEventButtonReady )

	Remote_ServerCallFunction( "ClientCallback_ViewingMainLobbyPage" )

	MiniPromo_Start()
	PromoDialog_InitPages()

	UI_ClearRespawnOverlay() 


		UI_SetPresentationType( ePresentationType.PLAY_QUADS )




	bool v3PlaylistSelect = GamemodeSelect_IsEnabled()

	if ( v3PlaylistSelect )
	{
		Hud_SetNavUp( file.readyButton, file.gamemodeSelectButton )
	}
	else
	{
		Hud_SetNavUp( file.readyButton, file.modeButton )
	}

	KeepUnixTimeDebugDisplayUpdated()




	thread TryRunDialogFlowThread()

	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPanelPlay )

	file.nextAllowFriendsUpdateTime = UITime()

	ChallengeSwitch_RegisterInputCallbacks()

	file.isShowing = true

}

void function Thread_UpdateLobbyButtons()
{
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	if( !IsLobby() || !IsConnectedServerInfo() )
		return

	file.areLobbyButtonsUpdating = true

	UpdateFillButton()
	WaitFrame()

	UpdateReadyButton()
	WaitFrame()

	UpdateModeButton()
	WaitFrame()

	UpdateLTMButton()
	WaitFrame()

	UpdateFriendButtons()
	WaitFrame()

	UpdateLastPlayedButtons()
	WaitFrame()

	UpdateLowerLeftButtonPositions()
	WaitFrame()

	UpdateFooterOptions()

	file.areLobbyButtonsUpdating = false
}

void function UpdateLobbyButtons()
{
	rtk_struct playMenuModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "play", "RTKPlayMenuModelStruct" )

	if ( !IsConnectedServerInfo() )
		return

	if ( !IsLobby() )
		return

	if ( GetCurrentPlaylistVarBool( "thread_lobby_updates", true ) )
	{
		if ( file.areLobbyButtonsUpdating == false )
			thread Thread_UpdateLobbyButtons()
	}
	else
	{
		UpdateFillButton()
		UpdateReadyButton()
		UpdateModeButton()
		UpdateLTMButton()
		UpdateFriendButtons()
		UpdateLastPlayedButtons()
		UpdateLowerLeftButtonPositions()
		UpdateFooterOptions()
	}


	if ( AreLanguagePacksSupported() && !IsLanguageInBaseGame() )
	{
		CheckAndShowLanguageDLCDialog()
	}







}

void function UpdateLTMButton()
{
	if( !IsLobby() || !IsConnected() )
		return

	bool LTMisTakeover = GetPlaylistVarBool( LobbyPlaylist_GetSelectedPlaylist(), "show_ltm_about_button_is_takeover", false )
	var aboutButton = Hud_GetChild( file.panel, "AboutButton" )
	Hud_ClearToolTipData( aboutButton )
	if ( LTMisTakeover )
	{
		string takeoverAbout = GetPlaylistVarString( LobbyPlaylist_GetSelectedPlaylist(), "survival_takeover_about", "" )
		if ( takeoverAbout != "" )
		{
			ToolTipData td
			td.titleText = GetPlaylistVarString( LobbyPlaylist_GetSelectedPlaylist(), "survival_takeover_title", "#PL_PLAY_APEX" )
			td.descText = takeoverAbout
			Hud_SetToolTipData( aboutButton, td )
		}
	}
}

void function KeepUnixTimeDebugDisplayUpdated()
{
	RegisterSignal( "KeepFakeDaysDebugDisplayUpdated" )

	thread function() : ()
	{
		Signal( uiGlobal.signalDummy, "KeepFakeDaysDebugDisplayUpdated" )
		EndSignal( uiGlobal.signalDummy, "KeepFakeDaysDebugDisplayUpdated" )
		EndSignal( uiGlobal.signalDummy, "LevelShutdown" )
		EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

		var textLabel = Hud_GetChild( file.panel, "LobbyDebugText" )

		int devLevelPrev = -99
		for ( ; ; )
		{
			WaitFrame()

			if ( !IsFullyConnected() )
				continue

			int devLevel = GetDeveloperLevel()
			if ( (devLevel == 0) && (devLevel == devLevelPrev) )
				continue

			string str = ((devLevel == 0) ? "" : GetDebugTimeString())
			Hud_SetText( textLabel, str )
			devLevelPrev = devLevel
		}
	}()
}


void function UpdateHDTextureProgress()
{
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureProgress", GetGameFullyInstalledProgress() )
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureNeedsReboot", HasNonFullyInstalledAssetsLoaded() )

	if ( ShowDownloadCompleteDialog() )
	{
		ConfirmDialogData data
		data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
		data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
		data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
		data.noText = ["#B_BUTTON_CANCEL", "#CANCEL"]

		data.resultCallback = void function ( int result ) : ()
		{
			if ( result == eDialogResult.YES )
			{
				
				ClientCommand( "disconnect" )
			}

			return
		}

		OpenConfirmDialogFromData( data )
		file.fullInstallNotification = true
	}
}


void function UpdateLastSquadDpadNav()
{
	var buttonBeneathLastSquadPanel = file.modeButton
	var buttonRightOfLastSquadPanel = Hud_IsVisible( file.friendButton0 ) ? file.friendButton0 : file.inviteFriendsButton0

	if ( Hud_IsVisible( file.gamemodeSelectButton ) )
	{
		buttonBeneathLastSquadPanel = file.gamemodeSelectButton
	}

	if ( Hud_IsVisible( file.fillButton ) )
	{
		buttonBeneathLastSquadPanel = file.fillButton
	}

	bool isVisibleButton0 = Hud_IsVisible( file.inviteLastPlayedUnitFrame0 )
	bool isVisibleButton1 = Hud_IsVisible( file.inviteLastPlayedUnitFrame1 )

	if ( isVisibleButton0 )
	{
		Hud_SetNavUp( buttonBeneathLastSquadPanel, isVisibleButton1 ? file.inviteLastPlayedUnitFrame1 : file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, isVisibleButton1 ? file.inviteLastPlayedUnitFrame1 : buttonBeneathLastSquadPanel )
		Hud_SetNavDown( file.inviteLastPlayedUnitFrame1, buttonBeneathLastSquadPanel )
		Hud_SetNavLeft( buttonRightOfLastSquadPanel, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavRight( file.inviteLastPlayedUnitFrame0, buttonRightOfLastSquadPanel )
		Hud_SetNavRight( file.inviteLastPlayedUnitFrame1, buttonRightOfLastSquadPanel )
	}
	else
	{
		Hud_SetNavUp( buttonBeneathLastSquadPanel, buttonRightOfLastSquadPanel )
		Hud_SetNavDown( buttonRightOfLastSquadPanel, buttonBeneathLastSquadPanel )
		Hud_SetNavLeft( buttonRightOfLastSquadPanel, buttonBeneathLastSquadPanel )
		Hud_SetNavRight( buttonBeneathLastSquadPanel, buttonRightOfLastSquadPanel )
	}
}


bool function ShowDownloadCompleteDialog()
{
	if ( GetGameFullyInstalledProgress() != 1 )
		return false

	if ( !HasNonFullyInstalledAssetsLoaded() )
		return false

	if ( file.fullInstallNotification )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return false

	return true
}

void function Callback_PlayPanel_SetSelectedPlaylistMods( string playlistModNames )
{
	UpdateLobbyButtons()
	UpdateLobbyChallengeMenu( true )
	Lobby_UpdateLoadscreenFromPlaylist()

	string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()
	if ( selectedPlaylist.len() > 0 )
		SetMatchmakingPlaylist( selectedPlaylist + playlistModNames )
}

void function Callback_PlayPanel_SetSelectedPlaylist( string playlistName )
{
	printt( "Lobby_SetSelectedPlaylist " + playlistName )

	UpdateLobbyButtons()
	Lobby_UpdateLoadscreenFromPlaylist()

	if ( playlistName.len() > 0 )
		SetMatchmakingPlaylist( playlistName + LobbyPlaylist_GetSelectedPlaylistMods() )

	if( IsConnected() && IsLobby() && IsLocalClientEHIValid() )
		UpdateLobbyChallengeMenu( true )

	WatchForLTMModeExpiring( playlistName )
}

void function Lobby_UpdateLoadscreenFromPlaylist()
{
	if ( GetPlaylistVarBool( LobbyPlaylist_GetSelectedPlaylist(), "force_level_loadscreen", false ) )
	{
		SetCustomLoadScreen( $"" )
	}
	else
	{
		thread Loadscreen_SetEquppedLoadscreenAsActive()
	}
}

void function PlayPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )
	Hud_ClearToolTipData( file.modeButton )

	RemoveCallback_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateFriendButtons )

	RemoveCallback_OnGRXOffersRefreshed( UpdateViewEventButtonReady )

	MiniPromo_Stop()
	file.rankedRUIToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPanelPlay )

	ChallengeSwitch_RemoveInputCallbacks()

	RTKTutorialOverlay_Deactivate( eTutorialOverlayID.READY_UP )

	file.isShowing = false
}


void function UpdateFriendButton( var rui, PartyMember info, bool inMatch )
{
	Party party = GetParty()

	RuiSetBool( rui, "isLeader", party.originatorUID == info.uid && GetPartySize() > 1 )
	RuiSetBool( rui, "isReady", info.ready )
	RuiSetBool( rui, "inMatch", inMatch )
	if ( inMatch )
	{
		RuiSetString( rui, "footerText", "#PROMPT_IN_MATCH" )
	}
	else
	{
		RuiSetString( rui, "footerText", "" )
	}

	thread KeepMicIconUpdated( info, rui )

	int rankScore       = 0 
	int ladderPosition  = SHARED_RANKED_INVALID_LADDER_POSITION






	string playerName = info.name

	CommunityUserInfo ornull userInfo = GetUserInfo( info.hardware, info.uid )
	if ( userInfo == null )
	{
		if ( info.uid in file.s_cachedAccountXPFrac )
			RuiSetFloat( rui, "accountXPFrac", file.s_cachedAccountXPFrac[info.uid] )
		else
			RuiSetFloat( rui, "accountXPFrac", 0 )

		int accountLevel = 0
		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			accountLevel = GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) )

		var nestedAccountBadge = CreateNestedAccountDisplayBadge( rui, "accountBadgeHandle", accountLevel )

		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
		{

			if ( RankedRumble_IsRunningRankedRumble() )
			{
				table scorePosition = RankedRumble_GetHighestRankedScoreAndPositionAcrossPlatforms( GetLocalClientPlayer() )
				rankScore = expect int( scorePosition.score )
				ladderPosition = expect int( scorePosition.position )
			}
			else

			{
				rankScore = GetPlayerRankScore( GetLocalClientPlayer() )
			}



		}
	}
	else
	{
		expect CommunityUserInfo( userInfo )

		float accountXPFrac = userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_PROGRESS_INT] / 100.0


		if ( userInfo.tag != "" )
		{
			playerName = "[" + userInfo.tag + "] " + playerName
		}


		file.s_cachedAccountXPFrac[info.uid] <- accountXPFrac
		RuiSetFloat( rui, "accountXPFrac", accountXPFrac )

		var accountBadge = CreateNestedAccountDisplayBadge( rui, "accountBadgeHandle", userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] )


		if ( RankedRumble_IsRunningRankedRumble() )
		{
			rankScore = userInfo.rumbleRankScore
			ladderPosition = userInfo.rumbleRankedLadderPos
		}
		else

		{
			rankScore = userInfo.rankScore
			ladderPosition = userInfo.rankedLadderPos
		}

		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( GetHardwareFromName( info.hardware ) ) : ""
		RuiSetString( rui, "platformString", platformString )
	}

	RuiSetString( rui, "playerName", playerName )
	RuiSetBool( rui, "showRanked", false )

	bool isRanked = GameModeVariant_IsActiveForPlaylist( LobbyPlaylist_GetSelectedPlaylist(), eGameModeVariants.SURVIVAL_RANKED )
	if ( isRanked )
	{
		RuiSetBool( rui, "showRanked", isRanked )
		PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
		float frac = 0.0

		SharedRankedDivisionData currentRank     = GetCurrentRankedDivisionFromScoreAndLadderPosition( rankScore, ladderPosition )
		SharedRankedDivisionData ornull nextRank = GetNextRankedDivisionFromScore( rankScore )

		if ( nextRank == null )
		{
			frac = 1.0
		}
		else
		{
			expect SharedRankedDivisionData( nextRank )
			if ( nextRank != currentRank )
			{
				frac = GraphCapped( float( rankScore ), currentRank.scoreMin, nextRank.scoreMin, 0.0, 1.0 )
			}
		}

		RuiSetBool( rui, "isLadderRank", currentRank.tier.isLadderOnlyTier )
		RuiSetFloat( rui, "accountXPFrac", frac )
	}






























}


void function KeepMicIconUpdated( PartyMember info, var rui )
{
	EndSignal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	while ( true )
	{
		RuiSetInt( rui, "micStatus", GetChatroomMicStatus( info.uid, info.hardware ) )
		WaitFrame()
	}
}

void function UpdateViewEventButtonReady()
{
	Hud_SetEnabled( file.viewEventButton, IsLobby() && GRX_IsInventoryReady() && GRX_AreOffersReady())
}

void function UpdateFriendButtons()
{
	if( !IsLobby() || !IsConnected() )
		return

	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	Hud_SetVisible( file.inviteFriendsButton0, false )
	Hud_SetVisible( file.inviteFriendsButton1, false )
	Hud_SetVisible( file.friendButton0, false )
	Hud_SetVisible( file.friendButton1, false )

	Hud_SetVisible( file.inviteFriendsButton2, false )
	Hud_SetVisible( file.friendButton2, false )


	if( IsDialog( GetActiveMenu() ) )
		return

	Hud_SetVisible( file.inviteFriendsButton0, !file.personInLeftSpot )
	Hud_SetVisible( file.inviteFriendsButton1, !file.personInRightSlot )

	var leftButton = file.personInLeftSpot ? file.friendButton0 : file.inviteFriendsButton0
	var rightButton = file.personInRightSlot ? file.friendButton1 : file.inviteFriendsButton1

	Hud_SetNavRight( file.inviteLastPlayedUnitFrame0, leftButton )
	Hud_SetNavRight( file.inviteLastPlayedUnitFrame1, leftButton )

	int maxTeamSize = GetMaxTeamSizeForAllPlaylistsInRotation()


	Hud_SetVisible( file.inviteFriendsButton2, !file.personInFourthSlot && maxTeamSize >= 4 )
	var fourthSlotButton = file.personInFourthSlot ? file.friendButton2 : file.inviteFriendsButton2
	Hud_SetNavRight( file.inviteLastPlayedUnitFrame2, leftButton )


	UpdateButtonsPositions( maxTeamSize )

	Hud_SetNavDown( file.selfButton, leftButton )
	Hud_SetNavLeft( file.selfButton, leftButton )
	Hud_SetNavRight( file.selfButton, rightButton )

	Hud_SetNavLeft( file.miniPromoButton, rightButton )

	Hud_SetNavLeft( file.viewEventButton , rightButton )
	Hud_SetNavLeft( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ), rightButton )

	if ( file.nextAllowFriendsUpdateTime < UITime() )
	{
		int count = GetInGameFriendCount( true )
		RuiSetInt( Hud_GetRui( file.inviteFriendsButton0 ), "onlineFriendCount", count )
		RuiSetInt( Hud_GetRui( file.inviteFriendsButton1 ), "onlineFriendCount", count )

			RuiSetInt( Hud_GetRui( file.inviteFriendsButton2 ), "onlineFriendCount", count )

		file.nextAllowFriendsUpdateTime = UITime() + 5.0
	}

	Party party = GetParty()
	string playerUID = GetPlayerUID()
	foreach ( PartyMember partyMember in party.members )
	{
		if ( partyMember.uid == playerUID )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"

			int blockSecondsLeft = CommunicationBlockGetBlockSeconds()
			if ( blockSecondsLeft > 0 )
			{
				int minutes = int( ceil( blockSecondsLeft / 60 ) );
				toolTipData.descText = format( Localize( "#TOXIC_CHAT_BLOCKED" ), minutes )
			}

			Hud_SetToolTipData( file.selfButton, toolTipData )

			var friendRui = Hud_GetRui( file.selfButton )
			RuiSetBool( friendRui, "canViewStats", true )
			UpdateFriendButton( friendRui, partyMember, false )

			if ( !Hud_IsVisible( file.selfButton ) )
				Hud_SetVisible( file.selfButton, true )
		}
		else if ( partyMember.uid == file.friendInLeftSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = ""
			toolTipData.actionHint2 = IsPlayerVoiceAndTextMutedForUID( partyMember.uid, partyMember.hardware ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"

			EadpPeopleData friendData = expect EadpPeopleData(file.friendInLeftSpot.eadpData)
			string friendNucleus = friendData.eaid
			string clubInviteTooltip = ""





			if(toolTipData.actionHint2 == "")
			toolTipData.actionHint2 = clubInviteTooltip
			else toolTipData.actionHint3 = clubInviteTooltip
			Hud_SetToolTipData( file.friendButton0, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton0 )
			UpdateFriendButton( friendRui, partyMember, file.friendInLeftSpot.ingame )
			Hud_SetVisible( file.friendButton0, true )
			if ( file.leftWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.leftWasReady = partyMember.ready
		}
		else if ( partyMember.uid == file.friendInRightSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceAndTextMutedForUID( partyMember.uid, partyMember.hardware ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"

			EadpPeopleData friendData = expect EadpPeopleData(file.friendInRightSpot.eadpData)
			string friendNucleus = friendData.eaid
			string clubInviteTooltip = ""





			if(toolTipData.actionHint2 == "")
				toolTipData.actionHint2 = clubInviteTooltip
			else toolTipData.actionHint3 = clubInviteTooltip
			Hud_SetToolTipData( file.friendButton1, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton1 )
			UpdateFriendButton( friendRui, partyMember, file.friendInRightSpot.ingame )
			Hud_SetVisible( file.friendButton1, true )

			if ( file.rightWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.rightWasReady = partyMember.ready
		}

		else if ( partyMember.uid == file.friendInFourthSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceAndTextMutedForUID( partyMember.uid, partyMember.hardware ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"

			EadpPeopleData friendData = expect EadpPeopleData(file.friendInFourthSpot.eadpData)
			string friendNucleus = friendData.eaid
			string clubInviteTooltip = ""





			if(toolTipData.actionHint2 == "")
				toolTipData.actionHint2 = clubInviteTooltip
			else toolTipData.actionHint3 = clubInviteTooltip
			Hud_SetToolTipData( file.friendButton2, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton2 )
			UpdateFriendButton( friendRui, partyMember, file.friendInFourthSpot.ingame )
			Hud_SetVisible( file.friendButton2, true )

			if ( file.fourthWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.fourthWasReady = partyMember.ready
		}

	}

	ToolTipData toolTipData
	toolTipData.titleText = "#INVITE"
	toolTipData.descText = "#INVITE_HINT"

	entity player = GetLocalClientPlayer()
	if ( IsLocalClientEHIValid() && IsValid( player ) )
	{
		bool hasPremiumPass                = false
		if ( file.currentBPInfo.bpExpirationTimestamp < GetUnixTimestamp() )
		{
			file.currentBPInfo.battlePassOrNull = GetActiveBattlePass()
			if ( file.currentBPInfo.battlePassOrNull != null )
				file.currentBPInfo.bpExpirationTimestamp = CalEvent_GetFinishUnixTime( expect ItemFlavor( GetActiveSeason( GetUnixTimestamp() ) ) )
		}
		ItemFlavor ornull activeBattlePass = file.currentBPInfo.battlePassOrNull
		bool hasActiveBattlePass           = activeBattlePass != null
		if ( hasActiveBattlePass && GRX_IsInventoryReady() )
		{
			expect ItemFlavor( activeBattlePass )
			hasPremiumPass = DoesPlayerOwnBattlePass( player, activeBattlePass )
			if ( hasPremiumPass )
				toolTipData.descText = Localize( "#INVITE_HINT_BP" )
		}
	}


		if ( !PCPlat_IsOverlayAvailable() && !GetCurrentPlaylistVarBool( "social_menu_enabled", true ) )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			toolTipData.descText = "#" + platname + "_INGAME_REQUIRED"
			Hud_SetLocked( file.inviteFriendsButton0, true )
			Hud_SetLocked( file.inviteFriendsButton1, true )

				Hud_SetLocked( file.inviteFriendsButton2, true )

		}


	Hud_SetToolTipData( file.inviteFriendsButton0, toolTipData )
	Hud_SetToolTipData( file.inviteFriendsButton1, toolTipData )

		Hud_SetToolTipData( file.inviteFriendsButton2, toolTipData )

}


void function UpdateLowerLeftButtonPositions()
{
	if( !IsLobby() || !IsConnected() )
		return

	bool v3PlaylistSelect = GamemodeSelect_IsEnabled()

	bool showLTMAboutButton = GetPlaylistVarBool( LobbyPlaylist_GetSelectedPlaylist(), "show_ltm_about_button", false )
	var aboutButton         = Hud_GetChild( file.panel, "AboutButton" )
	var aboutButtonTimer    = Hud_GetChild( file.panel, "RTKAboutButtonTimer" )
	Hud_SetVisible( aboutButton, false )

	bool shouldShowRankedBadge = GameModeVariant_IsActiveForPlaylist( LobbyPlaylist_GetSelectedPlaylist(), eGameModeVariants.SURVIVAL_RANKED )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_SetVisible( rankedBadge, false )

	Hud_SetY( file.fillButton, 16 )







	var buttonToTheRight = Hud_IsVisible( file.friendButton0 ) ? file.friendButton0 : file.inviteFriendsButton0
	Hud_SetNavRight( rankedBadge, buttonToTheRight )



	Hud_SetNavRight( aboutButton, buttonToTheRight )
	Hud_SetNavRight( file.fillButton, buttonToTheRight )

	if ( v3PlaylistSelect )
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.gamemodeSelectButton ) )



		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.gamemodeSelectButton ) )
		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( file.gamemodeSelectButton ) )

		Hud_SetNavUp( file.gamemodeSelectButton, file.inviteFriendsButton0 )

		Hud_SetNavDown( rankedBadge, file.gamemodeSelectButton )



		Hud_SetNavDown( aboutButton, file.gamemodeSelectButton )
		Hud_SetNavDown( file.fillButton, file.gamemodeSelectButton )
	}
	else
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.modeButton ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.modeButton ) )
		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( file.modeButton ) )

		Hud_SetNavDown( rankedBadge, file.modeButton )
		Hud_SetNavDown( aboutButton, file.modeButton )
		Hud_SetNavDown( file.fillButton, file.modeButton )
	}

	var msgLabel = Hud_GetChild( file.panel, "PlaylistNotificationMessage" )
	Hud_SetVisible( msgLabel, false )

	if ( v3PlaylistSelect )
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.gamemodeSelectButton ) )
	}
	else
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.modeButton ) )
	}

	bool hasPromoTrial = RankedTrials_PlayerHasIncompleteTrial( GetLocalClientPlayer() )
	bool shouldShowRankedPromoPanel = GameModeVariant_IsActiveForPlaylist( LobbyPlaylist_GetSelectedPlaylist(), eGameModeVariants.SURVIVAL_RANKED ) && hasPromoTrial
	var rankedPromosPanel = Hud_GetChild( file.panel, "RTKRankedPromosTrials" )
	Hud_SetVisible( rankedPromosPanel, shouldShowRankedPromoPanel )

	if ( shouldShowRankedBadge )
	{
		Hud_SetVisible( rankedBadge, shouldShowRankedBadge )

		if ( v3PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectButton, rankedBadge )
		}

		var rui = Hud_GetRui( rankedBadge )

		bool isRankedRumble = false
		int score = 0
		int ladderPosition = 0


		if ( RankedRumble_IsRunningRankedRumble() )
		{
			isRankedRumble = true
			table scorePosition = RankedRumble_GetHighestRankedScoreAndPositionAcrossPlatforms( GetLocalClientPlayer() )
			score = expect int( scorePosition.score )
			ladderPosition = expect int( scorePosition.position )
#if DEV
				if ( GetConVarBool( "enableRankedRumblePositionLog" ) )
					printt( "lobby_panel_play bottom left mode select is RR", score, ladderPosition )
#endif
		}
		else

		{
			score = GetPlayerRankScore( GetLocalClientPlayer() )
			ladderPosition = Ranked_GetLadderPosition( GetLocalClientPlayer() )
#if DEV
				if ( GetConVarBool( "enableRankedRumblePositionLog" ) )
					printt( "lobby_panel_play bottom left mode select NOT RR", score, ladderPosition )
#endif
		}

		bool isProvisional = Ranked_GetNumProvisionalMatchesCompleted( GetLocalClientPlayer() ) < Ranked_GetNumProvisionalMatchesRequired()

		if ( score == SHARED_RANKED_INVALID_RANK_SCORE ) 
			score = 0

		if ( Ranked_ShouldUpdateWithComnunityUserInfo( score, ladderPosition ) )
			file.rankedRUIToUpdate = rui

		SharedRankedDivisionData data = GetCurrentRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
		SharedRankedTierData currentTier = data.tier
		SharedRankedDivisionData ornull nextData = GetNextRankedDivisionFromScore( score )

		RuiSetInt( rui, "score", score )
		RuiSetInt( rui, "scoreMax", 0 )
		RuiSetFloat( rui, "scoreFrac", 1.0 )
		RuiSetString( rui, "rankName", data.divisionName )
		PopulateRuiWithRankedBadgeDetails( rui, score, ladderPosition )

		if ( isRankedRumble )
		{
			
			RuiSetString( rui, "rankName", currentTier.name )

			
			RuiSetBool( rui, "showScore", false )
			RuiSetString( rui, "scoreAltString", Localize( "#RANKED_RUMBLE_POST_SEASON" ) )
			ItemFlavor ornull activeRankedPeriod = Ranked_GetCurrentActiveRankedPeriod()
			if ( activeRankedPeriod != null )
			{
				expect ItemFlavor ( activeRankedPeriod )
				if ( Ranked_IsRankedV2FirstSplit( activeRankedPeriod ) )
					RuiSetString( rui, "scoreAltString", Localize( "#RANKED_RUMBLE_MID_SEASON" ) )
			}
		}
		else
		{
			RuiSetBool( rui, "showScore", true )
		}

		SharedRankedDivisionData currentRank = GetCurrentRankedDivisionFromScore ( score )  


			int entryCost = Ranked_GetCostForEntry ( currentRank )









		int tierFloor = currentRank.tier.scoreMin
		bool showDemotionProtection = ((score - tierFloor) <= entryCost && currentRank.tier.allowsDemotion ) && !isProvisional

		RuiSetBool ( rui, "showProtection" , showDemotionProtection )

		if (showDemotionProtection)
		{
			RuiSetInt ( rui, "protectionCurrent" , GetDemotionProtectionBuffer ( GetLocalClientPlayer() ) )
		}

		RuiSetBool( rui, "inSeason", IsRankedInSeason() )
		RuiSetBool( rui, "inProvisional", isProvisional )
		RuiSetBool( rui, "inPromoTrials", hasPromoTrial && !RankedTrials_IsKillswitchEnabled() )
		RuiSetBool( rui, "showPromoPip", RankedTrials_NextRankHasTrial( data, nextData ) && !RankedTrials_IsKillswitchEnabled() )

		asset promoCapImage = $""
		if ( nextData != null )
		{
			expect SharedRankedDivisionData( nextData )
			promoCapImage = nextData.tier.promotionalMetallicImage
		}
		RuiSetAsset( rui, "promoCapImage", promoCapImage )

		switch ( data.emblemDisplayMode )
		{
			case emblemDisplayMode.DISPLAY_RP:
				RuiSetFloat( rui, "iconTextScale", 0.8 )
				break

			case emblemDisplayMode.DISPLAY_LADDER_POSITION:
				RuiSetFloat( rui, "iconTextScale", 0.7 )
				break

			case emblemDisplayMode.DISPLAY_DIVISION:
			default:
				RuiSetFloat( rui, "iconTextScale", 1.0 )
				break
		}

		if ( data.tier.index != file.lobbyRankTier )
		{
			RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" )
			CreateNestedRankedRui( rui, data.tier, "rankedBadgeHandle", score, ladderPosition )
			file.lobbyRankTier = data.tier.index
		}

		ToolTipData tooltip
		if ( isRankedRumble )
			tooltip.titleText = currentTier.name
		else
			tooltip.titleText = data.divisionName

		if ( isProvisional )
		{
			tooltip.descText = Localize( "#RANKED_PLACEMENT_TOOLTIP")
			tooltip.titleText = ""

			RuiSetInt( rui, "score", Ranked_GetNumProvisionalMatchesCompleted( GetLocalClientPlayer() ) )
			RuiSetInt( rui, "scoreMax", Ranked_GetNumProvisionalMatchesRequired() )
			RuiSetString( rui, "rankName", Localize( "#RANKED_TIER_PROVISIONAL"))

		}
		else if ( hasPromoTrial )
		{
			entity player            	= GetLocalClientPlayer()
			ItemFlavor currentTrial  	= RankedTrials_GetAssignedTrial( player )
			int trialsAttempts 		 	= RankedTrials_GetGamesPlayedInTrialsState( player )
			int maxAttempts 			= RankedTrials_GetGamesAllowedInTrialsState( player, currentTrial )
			int attemptsRemaining = maxAttempts - trialsAttempts

			RuiSetInt( rui, "score", trialsAttempts )
			RuiSetInt( rui, "scoreMax", maxAttempts )
			RuiSetString( rui, "rankName", Localize( "#RANKED_PROMOTION_FINALS") )
			tooltip.descText += Localize( "#RANKED_PROMOTION_ACTIVE_TOOLTIP", attemptsRemaining )
		}
		else if ( nextData != null )
		{
			expect SharedRankedDivisionData( nextData )

			if ( isRankedRumble )
				tooltip.descText = Localize( "#RANKED_RUMBLE" )
			else
				tooltip.descText = Localize( "#RANKED_TOOLTIP_NEXT", Localize( nextData.divisionName ).toupper(), (nextData.scoreMin - score) )

			RuiSetInt( rui, "score", score - data.scoreMin )
			RuiSetInt( rui, "scoreMax", nextData.scoreMin - data.scoreMin )
			RuiSetFloat( rui, "scoreFrac", float( score - data.scoreMin ) / float( nextData.scoreMin - data.scoreMin ) )
		}

		if ( !hasPromoTrial && nextData != null )
		{
			if ( !RankedTrials_IsKillswitchEnabled() )
			{
				tooltip.descText += Localize( "#RANKED_PROMOTION_NOT_ACTIVE_TOOLTIP_ENABLED" )
			}
		}

		Hud_SetToolTipData( rankedBadge, tooltip )
		return
	}










































































	if ( showLTMAboutButton )
	{
		Hud_SetVisible( aboutButton, showLTMAboutButton )

		if ( v3PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectButton, aboutButton )
		}

		if ( DoesPlaylistSupportNoFill( LobbyPlaylist_GetSelectedPlaylist() ) )
			Hud_SetNavUp( aboutButton, file.fillButton )

		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( aboutButton ) )
		Hud_SetY( file.fillButton, 10 )
		Hud_SetNavDown( file.fillButton, aboutButton )

		array<int> emblemColor = GetEmblemColor( LobbyPlaylist_GetSelectedPlaylist() )

		var rui = Hud_GetRui( aboutButton )

		bool LTMisTakeover = GetPlaylistVarBool( LobbyPlaylist_GetSelectedPlaylist(), "show_ltm_about_button_is_takeover", false )
		var aboutButtonRui         = Hud_GetRui( Hud_GetChild( file.panel, "AboutButton" ) )
		if ( LTMisTakeover )
		{
			RuiSetBool( aboutButtonRui, "extendBorder", true )
			RuiSetString( aboutButtonRui, "buttonText", GetPlaylistVarString( LobbyPlaylist_GetSelectedPlaylist(), "override_takeover_about_button_text", "#ABOUT_TAKEOVER" ) )
		}
		else
		{
			RuiSetBool( aboutButtonRui, "extendBorder", false )
			RuiSetString( aboutButtonRui, "buttonText", "#ABOUT_GAMEMODE" )
		}

		asset emblemImage = GetModeEmblemImage( LobbyPlaylist_GetSelectedPlaylist() )
		RuiSetImage( rui, "emblemImage", emblemImage )
		RuiSetColorAlpha( rui, "emblemColor", SrgbToLinear( <emblemColor[0], emblemColor[1], emblemColor[2]> / 255.0 ), emblemColor[3] / 255.0 )

		return
	}
	else
	{
		if ( Hud_IsVisible( aboutButtonTimer ) )
		{
			Hud_SetVisible( aboutButtonTimer, false )
		}
	}
}



















void function UpdateLastPlayedButtons()
{
	if( !IsLobby() || !IsConnected() )
		return

	UpdateLastPlayedPlayerInfo()

	bool isVisibleButton0 = file.lastPlayedPlayerUID0 != "" &&
		!LastPlayedPlayerIsInMatch( file.lastPlayedPlayerUID0, file.lastPlayedPlayerHardwareID0 ) &&
		!EADP_IsBlockedByEAID( file.lastPlayedPlayerNucleusID0 )

	bool isVisibleButton1 = file.lastPlayedPlayerUID1 != "" &&
		!LastPlayedPlayerIsInMatch( file.lastPlayedPlayerUID1, file.lastPlayedPlayerHardwareID1 ) &&
		!EADP_IsBlockedByEAID( file.lastPlayedPlayerNucleusID1 )


	bool isVisibleButton2 = file.lastPlayedPlayerUID2 != "" &&
	!LastPlayedPlayerIsInMatch( file.lastPlayedPlayerUID2, file.lastPlayedPlayerHardwareID2 ) &&
	!EADP_IsBlockedByEAID( file.lastPlayedPlayerNucleusID2 )


	bool shouldUpdateDpadNav = false


	if ( isVisibleButton0 != Hud_IsVisible( file.inviteLastPlayedUnitFrame0 ) || isVisibleButton1 != Hud_IsVisible( file.inviteLastPlayedUnitFrame1 ) || isVisibleButton2 != Hud_IsVisible( file.inviteLastPlayedUnitFrame2 ) )
	{
		shouldUpdateDpadNav = true
	}







	isVisibleButton0 = isVisibleButton0 && CanInvite()
	isVisibleButton1 = isVisibleButton1 && CanInvite()

	isVisibleButton2 = isVisibleButton2 && CanInvite()


	bool canInviteUserOne = true
	bool canInviteUserTwo = true

	bool canInviteUserThree = true










	if ( isVisibleButton0 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex0 == -1 )
			return

		string namePlayer0 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "name", namePlayer0 )


		int characterGUID = GetPersistentVarAsInt( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].character" )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			if( canInviteUserOne )
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame0, false )
			}
			else
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "unitframeFooterText", "" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame0, true )
			}
		}

		int hardwareID        = expect int( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].hardwareID" ) )
		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( hardwareID ) : ""
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "platformString", platformString )
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame0, isVisibleButton0 )


	if ( isVisibleButton1 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex1 == -1 )
			return

		string namePlayer1 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "name", namePlayer1 )

		int characterGUID = GetPersistentVarAsInt( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].character" )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			if( canInviteUserTwo )
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame1, false )
			}
			else
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "unitframeFooterText", "" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame1, true )
			}
		}

		int hardwareID        = expect int( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].hardwareID" ) )
		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( hardwareID ) : ""
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "platformString", platformString )
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame1, isVisibleButton1 )
	Hud_SetVisible( file.inviteLastPlayedHeader, isVisibleButton0 || isVisibleButton1 )


	if ( isVisibleButton2 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex2 == -1 )
			return

		string namePlayer2 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex2 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame2, "name", namePlayer2 )

		int characterGUID = GetPersistentVarAsInt( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex2 + "].character" )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame2, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp2 > INVITE_LAST_TIMEOUT )
		{
			if( canInviteUserThree )
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame2, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame2, false )
			}
			else
			{
				HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame2, "unitframeFooterText", "" )
				Hud_SetLocked( file.inviteLastPlayedUnitFrame2, true )
			}
		}

		int hardwareID        = expect int( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex2 + "].hardwareID" ) )
		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( hardwareID ) : ""
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame2, "platformString", platformString )
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame2, isVisibleButton2 )
	Hud_SetVisible( file.inviteLastPlayedHeader, isVisibleButton0 || isVisibleButton1 || isVisibleButton2 )


	if ( shouldUpdateDpadNav )
	{
		UpdateLastSquadDpadNav()
	}

	

	ToolTipData toolTipData0
	toolTipData0.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	ToolTipData toolTipData1
	toolTipData1.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	ToolTipData toolTipData2
	toolTipData2.tooltipStyle = eTooltipStyle.BUTTON_PROMPT


	if ( !IsSocialPopupActive() )
	{
		if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			if( canInviteUserOne )
			{
				toolTipData0.actionHint1 = "#A_BUTTON_INVITE"
				toolTipData0.actionHint2 = "#X_BUTTON_INSPECT"






			}
			else
			{
				toolTipData0.actionHint1 = "#X_BUTTON_INSPECT"





			}

			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
		}
		else if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp0 <= INVITE_LAST_TIMEOUT )
		{
			toolTipData0.actionHint1 = "#X_BUTTON_INSPECT"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
		}

		if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			if( canInviteUserTwo )
			{
				toolTipData1.actionHint1 = "#A_BUTTON_INVITE"
				toolTipData1.actionHint2 = "#X_BUTTON_INSPECT"






			}
			else
			{
				toolTipData1.actionHint1 = "#X_BUTTON_INSPECT"





			}

			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
		}
		else if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp1 <= INVITE_LAST_TIMEOUT )
		{
			toolTipData1.actionHint1 = "#X_BUTTON_INSPECT"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
		}


			if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp2 > INVITE_LAST_TIMEOUT )
			{
				if( canInviteUserThree )
				{
					toolTipData2.actionHint1 = "#A_BUTTON_INVITE"
					toolTipData2.actionHint2 = "#X_BUTTON_INSPECT"






				}
				else
				{
					toolTipData2.actionHint1 = "#X_BUTTON_INSPECT"





				}

				Hud_SetToolTipData( file.inviteLastPlayedUnitFrame2, toolTipData2 )
			}
			else if ( UITime() - file.lastPlayedPlayerInviteSentTimestamp2 <= INVITE_LAST_TIMEOUT )
			{
				toolTipData2.actionHint1 = "#X_BUTTON_INSPECT"
				Hud_SetToolTipData( file.inviteLastPlayedUnitFrame2, toolTipData2 )
			}

	}
	else
	{
		Hud_ClearToolTipData( file.inviteLastPlayedUnitFrame1 )
		Hud_ClearToolTipData( file.inviteLastPlayedUnitFrame0 )

		Hud_ClearToolTipData( file.inviteLastPlayedUnitFrame2 )


	}
}

void function ClientToUI_PartyMemberJoinedOrLeft( string leftSpotUID, string leftSpotEAID, string leftSpotHardware, string leftSpotUnspoofedUID, string leftSpotName, bool leftSpotInMatch,
												  string rightSpotUID, string rightSpotEAID, string rightSpotHardware, string rightSpotUnspoofedUID, string rightSpotName, bool rightSpotInMatch,
												  string fourthSpotUID, string fourthSpotEAID, string fourthSpotHardware, string fourthSpotUnspoofedUID, string fourthSpotName, bool fourthSpotInMatch)
	{
		bool personInLeftSpot  = leftSpotUID.len() > 0
		bool persinInRightSpot = rightSpotUID.len() > 0
		bool persinInFourthSpot = fourthSpotUID.len() > 0

		file.friendInLeftSpot.id = leftSpotUID
		file.friendInLeftSpot.hardware = leftSpotHardware
		file.friendInLeftSpot.name = leftSpotName
		file.friendInLeftSpot.ingame = leftSpotInMatch
		file.friendInLeftSpot.eadpData = CreateEADPDataFromEAID( leftSpotEAID )
		file.friendInLeftSpot.unspoofedid = leftSpotUnspoofedUID

		file.friendInRightSpot.id = rightSpotUID
		file.friendInRightSpot.hardware = rightSpotHardware
		file.friendInRightSpot.name = rightSpotName
		file.friendInRightSpot.ingame = rightSpotInMatch
		file.friendInRightSpot.eadpData = CreateEADPDataFromEAID( rightSpotEAID )
		file.friendInRightSpot.unspoofedid = rightSpotUnspoofedUID

		file.friendInFourthSpot.id = fourthSpotUID
		file.friendInFourthSpot.hardware = fourthSpotHardware
		file.friendInFourthSpot.name = fourthSpotName
		file.friendInFourthSpot.ingame = fourthSpotInMatch
		file.friendInFourthSpot.eadpData = CreateEADPDataFromEAID( fourthSpotEAID )
		file.friendInFourthSpot.unspoofedid = fourthSpotUnspoofedUID

		file.personInLeftSpot = personInLeftSpot
		file.personInRightSlot = persinInRightSpot
		file.personInFourthSlot = persinInFourthSpot

		file.leftWasReady = file.leftWasReady && personInLeftSpot
		file.rightWasReady = file.rightWasReady && persinInRightSpot
		file.fourthWasReady = file.fourthWasReady && persinInFourthSpot

		UpdateLobbyButtons()
		GameModeSelect_OnPartyChanged()


		if ( FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
			FTUEFlow_PartyMemberJoinedOrLeft()

	}






































bool function CanActivateReadyButton()
{
	if ( IsConnectingToMatch() )
		return false

	
	
	if ( !file.skipDialogCheckForActivateReadyButton && IsDialog( GetActiveMenu() ) )
		return false

	bool isReady = GetConVarBool( "party_readyToSearch" )

	
	if ( isReady )
		return true

	if ( !Lobby_IsPlaylistAvailable( LobbyPlaylist_GetSelectedPlaylist() ) )
		return false







	return true
}

void function UpdateReadyButton()
{
	if( !IsLobby() || !IsConnectedServerInfo() )
		return

	bool isLeader = IsPartyLeader()

	bool isReady               = GetConVarBool( "party_readyToSearch" )
	string buttonText
	string buttonDescText
	float buttonDescFontHeight = 0.0

	float timeRemaining = 0
	float currentMaxMatchmakingDelayEndTime = LobbyPlaylist_GetCurrentMaxMatchmakingDelayEndTime()
	if ( currentMaxMatchmakingDelayEndTime > 0 )
		timeRemaining = currentMaxMatchmakingDelayEndTime - UITime()

	if ( timeRemaining > 0 )
	{
		buttonText = "#RANKED_ABANDON_PENALTY_PLAY_BUTTON_LABEL"
		HudElem_SetRuiArg( file.readyButton, "expireTime", ClientTime() + timeRemaining, eRuiArgType.GAMETIME )
	}
	else
	{
		LobbyPlaylist_SetCurrentMaxMatchmakingDelayEndTime( 0 )
		if ( isReady )
		{
			buttonText = IsControllerModeActive() ? "#B_BUTTON_CANCEL" : "#CANCEL"
		}
		else if ( ShouldForceShowModeSelection() )
		{
			buttonText = IsControllerModeActive() ? "#Y_BUTTON_SELECT" : "#SELECT"
		}
		else
		{
			buttonText = IsControllerModeActive() ? "#Y_BUTTON_READY" : "#READY"
		}

		if ( Dev_CommandLineHasParm( "-auto_ezlaunch" ) )
		{
			buttonDescText = "-auto_ezlaunch"
			buttonDescFontHeight = 24
		}

		HudElem_SetRuiArg( file.readyButton, "expireTime", RUI_BADGAMETIME, eRuiArgType.GAMETIME )
	}

	HudElem_SetRuiArg( file.readyButton, "isLeader", isLeader )
	HudElem_SetRuiArg( file.readyButton, "isReady", isReady )
	HudElem_SetRuiArg( file.readyButton, "buttonText", Localize( buttonText ) )
	HudElem_SetRuiArg( file.readyButton, "buttonDescText", buttonDescText )
	HudElem_SetRuiArg( file.readyButton, "buttonDescFontHeight", buttonDescFontHeight )

	bool canActivateReadyButton = CanActivateReadyButton()

	Hud_SetLocked( file.readyButton, !canActivateReadyButton )
	Hud_SetEnabled( file.readyButton, canActivateReadyButton )

	if ( !canActivateReadyButton )
	{
		ToolTipData toolTipData
		toolTipData.titleText = IsConnectingToMatch() ? "#UNAVAILABLE" : "#READY_UNAVAILABLE"
		toolTipData.descText = IsConnectingToMatch() ? "#LOADINGPROGRESS_CONNECTING" : LobbyPlaylist_GetPlaylistStateString( LobbyPlaylist_GetPlaylistState( LobbyPlaylist_GetSelectedPlaylist() ) )

		Hud_SetToolTipData( file.readyButton, toolTipData )
	}
	else
	{
		Hud_ClearToolTipData( file.readyButton )
	}

	
	if ( file.isShowing && canActivateReadyButton && !isReady && !RTKTutorialOverlay_IsActive() )
	{
		if ( file.showReadyReminderTime == 0 )
		{
			float reminderDelay = HasLocalPlayerCompletedTraining() ? 10.0 : 3.0
			file.showReadyReminderTime = UITime() + reminderDelay
		}
		else if ( UITime() > file.showReadyReminderTime )
		{
			file.showReadyReminderTime = 0

			RTKTutorialOverlay_Activate( eTutorialOverlayID.READY_UP )
		}
	}
	else
	{
		file.showReadyReminderTime = 0
	}
}

bool function CanActivateModeButton()
{
	bool isReady  = GetConVarBool( "party_readyToSearch" )
	bool isLeader = IsPartyLeader()

	return !isReady && isLeader
}

bool function HasNewModes()
{
	if ( !IsFullyConnected() )
		return false

	if ( Playlist_GetNewModeVersion() > GetPersistentVarAsInt( "newModeVersion" ) )
		return true

	string currentLTM = Playlist_GetLTMSlotPlaylist()
	
	if ( ( currentLTM != "" ) && !IsPlaylistBeingRotated( currentLTM ) && ( currentLTM != GetPersistentVar( "lastSeenLobbyLTM" ) ) && Lobby_IsPlaylistAvailable( currentLTM ) )
		return true

	return false
}

string function GetCrossplayStatus()
{
	





	
	if ( GetPlayerHardware() == "" )
	{
		return ""
	}

	if ( !CrossplayEnabled() )
	{
		return ""
	}

	if ( !CrossplayUserOptIn() || !IsPartyAllowedCrossplay() )
	{
		
		
		return Localize( "#CROSSPLAY_N_ONLY", Localize( PlatformIDToIconString( GetHardwareFromName( GetPlayerHardware() ) ) ) )
	}

	foreach ( index, member in GetParty().members )
	{
		if ( IsPCPlatform( GetHardwareFromName( member.hardware ) ) )
			return Localize( "#CROSSPLAY_N", Localize( PlatformIDToIconString( HARDWARE_PC ) ) )
	}


		return Localize( "#CROSSPLAY_N", Localize( "#CROSSPLAY_ICON_PC" ) )



}

void function RestartMatchmakingAfterRotation( string previousPlaylistName )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	int retryCount = 5
	string activeUISlot = GetPlaylistVarString( previousPlaylistName, "ui_slot", "" )
	string nextUISlot = ""

	
	if ( IsPartyLeader() )
	{
		while ( activeUISlot != nextUISlot && retryCount > 0 )
		{
			WaitFrame()
			Lobby_UpdateSelectedPlaylistUsingUISlot( previousPlaylistName )
			nextUISlot = GetPlaylistVarString( LobbyPlaylist_GetSelectedPlaylist(), "ui_slot", "" )
			--retryCount
		}
	}

	
	
	if ( activeUISlot == nextUISlot )
	{
		printf( "Automatically trying to resume matchmaking with playlist '%s' (previously '%s' in ui_slot '%s')", LobbyPlaylist_GetSelectedPlaylist(), previousPlaylistName, activeUISlot )
		Lobby_StartMatchmaking()
	}
	else
	{
		printf( "Could not find playlist for ui_slot '%s' to replace '%s'", activeUISlot, previousPlaylistName )
	}
}

void function UpdateModeButton()
{
	if ( !IsConnected() )
		return

	if( !IsLobby() )
		return

	string visiblePlaylistValue = GetConVarString( "match_visiblePlaylists" )
	int partySize = GetPartySize()
	bool cuiIsValid = false




	{
		cuiIsValid = GetUserInfo( GetPlayerHardware(), GetPlayerUID() ) != null
	}

	if ( visiblePlaylistValue != file.lastVisiblePlaylistValue || partySize != file.lastPartySize || cuiIsValid != file.lastCuiIsValid )
	{
		Lobby_UpdatePlayPanelPlaylists()
		file.lastVisiblePlaylistValue = visiblePlaylistValue
		file.lastPartySize = partySize
		file.lastCuiIsValid = cuiIsValid
	}

	if ( CanRunClientScript() )
	{
		int maxTeamSize = GetMaxTeamSizeForAllPlaylistsInRotation()
		if ( file.lastMaxTeamSize != maxTeamSize )
		{
			file.lastMaxTeamSize = maxTeamSize
			RunClientScript( "LSS_UpdateLobbyStage", LobbyPlaylist_GetSelectedPlaylist() )
		}
	}

	Hud_SetLocked( file.modeButton, !CanActivateModeButton() )

	bool isReady = GetConVarBool( "party_readyToSearch" )
	Hud_SetEnabled( file.modeButton, !isReady && CanActivateModeButton() )
	HudElem_SetRuiArg( file.modeButton, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectButton, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectButton, "crossplayStatus", GetCrossplayStatus() )

	bool hasNewModes = HasNewModes()

	Hud_SetNew( file.gamemodeSelectButton, hasNewModes && (HasLocalPlayerCompletedNewPlayerOrientation() || IsLocalPlayerExemptFromNewPlayerOrientation()) )



	HudElem_SetRuiArg( file.gamemodeSelectButton, "isNew", HasGamemodeSelector() )
	HudElem_SetRuiArg( file.gamemodeSelectButton, "featuredString", "#HEADER_NEW_MODE" )
	Hud_SetEnabled( file.gamemodeSelectorModalPanel, HasGamemodeSelector() && !file.gamemodeSelectorModalDismissed )
	Hud_SetVisible( file.gamemodeSelectorModalPanel, HasGamemodeSelector() && !file.gamemodeSelectorModalDismissed )
	if ( file.wasReady != isReady )
	{
		UISize screenSize = GetScreenSize()

		float scale   = float( GetScreenSize().width ) / 1920.0
		int maxDist   = int( screenSize.height * 0.08 )
		int maxDistNX = int( screenSize.height * 0.1 )

		int x   = Hud_GetX( file.modeButton )
		int y   = isReady ? Hud_GetBaseY( file.modeButton ) + maxDist : Hud_GetBaseY( file.modeButton )
		int yNX = isReady ? Hud_GetBaseY( file.modeButton ) + maxDistNX : Hud_GetBaseY( file.modeButton )

		int currentY = Hud_GetY( file.modeButton )
		int diff     = abs( currentY - y )

#if PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				float duration = 0.15 * (float( diff ) / (float( maxDistNX ) * scale))
				Hud_MoveOverTime( file.modeButton, x, yNX, 0.15 )
			}
			else
			{
				float duration = 0.15 * (float( diff ) / float( maxDist ))
				Hud_MoveOverTime( file.modeButton, x, y, 0.15 )
			}
#else
			float duration = 0.15 * (float( diff ) / float( maxDist ))
			Hud_MoveOverTime( file.modeButton, x, y, 0.15 )
#endif

		file.wasReady = isReady
	}

	bool isLeader = IsPartyLeader()
	string playlistName        = isLeader ? (isReady ? GetConVarString( "match_playlist" ) : LobbyPlaylist_GetSelectedPlaylist()) : GetParty().playlistName

	UpdatePartyMemberNotice( playlistName, isLeader )


	string invalidPlaylistText = isLeader ? "#SELECT_PLAYLIST" : "#PARTY_LEADER_CHOICE"
	string name = GetPlaylistVarString( playlistName, "name", invalidPlaylistText )
	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( name ) + LobbyPlaylist_GetSelectedPlaylistMods() )

	HudElem_SetRuiArg( file.gamemodeSelectorModalPanel, "descriptionText", GetPlaylistVarString( playlistName, "modeDescriptionString", "#HEADER_NEW_MODE_DESCRIPTION" ) )





	bool useGamemodeSelect = GamemodeSelect_IsEnabled() && !(ShouldDisplayOptInOptions() && IsOptInEnabled())

	Hud_SetVisible( file.modeButton, !useGamemodeSelect )
	Hud_SetVisible( file.gamemodeSelectButton, useGamemodeSelect )

	RuiSetBool( Hud_GetRui( file.readyButton ), "showReadyFrame", !useGamemodeSelect )

	if ( useGamemodeSelect && playlistName != "" )
	{
		if ( ShouldTryToCancelMatchmakingFromInvalidPlaylistChange( playlistName, isReady ) )
		{
			CancelMatchmaking()
			Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
			EmitUISound( SOUND_STOP_MATCHMAKING_1P )

			
			
			thread RestartMatchmakingAfterRotation( playlistName )
		}

		GamemodeSelect_UpdateSelectButton( file.gamemodeSelectButton, playlistName )
		HudElem_SetRuiArg( file.gamemodeSelectButton, "alwaysShowDesc", true )
		HudElem_SetRuiArg( file.gamemodeSelectButton, "isPartyLeader", isLeader )

		HudElem_SetRuiArg( file.gamemodeSelectButton, "modeLockedReason", "" )



			
			if ( GetConVarBool( "cups_enabled" ) )
			{
				Hud_SetLocked( file.gamemodeSelectButton, false )
				Hud_SetEnabled( file.gamemodeSelectButton, true )
			}
			else

			{
				Hud_SetLocked( file.gamemodeSelectButton, !CanActivateModeButton() )
				Hud_SetEnabled( file.gamemodeSelectButton, CanActivateModeButton() )
			}

		
		int mapIdx = playlistName != "" ? GetPlaylistActiveMapRotationIndex( playlistName ) : -1
		string rotationMapName = GetPlaylistMapVarString( playlistName, mapIdx, "map_name", "" )
		int rotationTimeLeft = -1

		string currentPlaylist = LobbyPlaylist_GetSelectedPlaylist()
		if ( IsPlaylistBeingRotated( playlistName ) )
		{
			string ornull rotationName = GetPlaylistRotationNameFromPlaylist( playlistName )
			rotationTimeLeft = GetPlaylistRotationNextTime( rotationName ? expect string( rotationName ) : "" ) - GetUnixTimestamp()
		}
		else if ( rotationMapName != "" ) 
		{
			rotationTimeLeft = GetPlaylistActiveMapRotationTimeLeft( playlistName )
		}

		if ( rotationTimeLeft > 0 )
		{
			string nextRotationTime = GetPlaylistRotationNextTimeFormatedString( rotationTimeLeft )
			HudElem_SetRuiArg( file.gamemodeSelectButton, "modeDescText", Localize( rotationMapName ).toupper() )
			HudElem_SetRuiArg( file.gamemodeSelectButton, "modeRotationTime", nextRotationTime )

#if PC_PROG_NX_UI
			Hud_ClearToolTipData( file.gamemodeSelectButton )
#endif

		}
		else
		{
			
			
			HudElem_SetRuiArg( file.gamemodeSelectButton, "modeRotationTime", "" )
			string modeDescText = ""
			HudElem_SetRuiArg( file.gamemodeSelectButton, "modeDescText", modeDescText )

#if PC_PROG_NX_UI
			ToolTipData td
			td.titleText = Localize( GetPlaylistMapVarString( playlistName, mapIdx, "name", "#HUD_UNKNOWN" ) ).toupper()
			td.descText = Localize( GetPlaylistMapVarString( playlistName, mapIdx, "description", "#HUD_UNKNOWN" ) )
			Hud_SetToolTipData( file.gamemodeSelectButton, td )
#endif
		}

		rtk_struct playMenuModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "play", "RTKPlayMenuModelStruct" )
		rtk_struct aboutModeTimerModelStruct = RTKStruct_GetOrCreateScriptStruct( playMenuModel, "aboutModeTimer", "RTKPlayMenuTakeoverModelStruct" )
		RTKPlayMenuTakeoverModelStruct takeoverStruct

		if ( GetPlaylistVarBool( playlistName, "show_ltm_about_button", false ) && GetPlaylistVarBool( playlistName, "show_ltm_about_button_timer", false  ) )
		{
			TimestampRange ornull playlistTimeRange = Playlist_GetPlaylistScheduledTimeRange( playlistName )
			if ( playlistTimeRange != null )
			{
				takeoverStruct.endTime = expect TimestampRange( playlistTimeRange ).endUnixTime
			}
			else if ( rotationTimeLeft > 0 )
			{
				takeoverStruct.endTime = GetUnixTimestamp() + rotationTimeLeft
			}
			else
			{
				takeoverStruct.endTime = 0
			}
		}
		else
		{
			takeoverStruct.endTime = 0
		}
		RTKStruct_SetValue( aboutModeTimerModelStruct, takeoverStruct )

		var aboutButtonTimer    = Hud_GetChild( file.panel, "RTKAboutButtonTimer" )
		Hud_SetVisible( aboutButtonTimer, takeoverStruct.endTime > GetUnixTimestamp() )
	}

	if ( file.lastPlaylistDisplayed != playlistName )
	{
		Lobby_UpdateLoadscreenFromPlaylist()
	}

	if ( CanRunClientScript() )
		RunClientScript( "Lobby_SetBannerSkin", playlistName )

	file.lastPlaylistDisplayed = playlistName


	if ( FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
	{
		if ( FTUEFlow_GetLobbyPlaylistRecommendation() == playlistName && IsPartyLeader() )
		{
			HudElem_SetRuiArg( file.gamemodeSelectButton, "featuredState", FEATURED_ACTIVE )
			HudElem_SetRuiArg( file.gamemodeSelectButton, "featuredString", "#MENU_RETICLE_RECOMMENDED" )
			HudElem_SetRuiArg( file.gamemodeSelectButton, "featuredIsFTUE", true )
			RTKFTUEMessage_SetData( FTUEFlow_GetLobbyMessage() )
		}
		else
		{
			RTKFTUEMessageModel model
			model.description = ""
			RTKFTUEMessage_SetData( model )
		}
	}


}



void function UpdatePartyMemberNotice( string playlistName, bool isLeader )
{
	if ( playlistName == PLAYLIST_NEW_PLAYER_ORIENTATION && GetPartySize() > 1 && HasLocalPlayerCompletedNewPlayerOrientation() )
	{
		string header
		string message

		if ( isLeader )
		{
			header = "#PARTY_MEMBER_NOTICE_NEW_PLAYER_HEADER"
			message = "#PARTY_MEMBER_NOTICE_NEW_PLAYER_MESSAGE"
		}
		else
		{
			header = "#PARTY_MEMBER_NOTICE_NO_PROGRESSION_HEADER"
			message = "#PARTY_MEMBER_NOTICE_NO_PROGRESSION_MESSAGE"
		}

		HudElem_SetRuiArg( file.partyMemberNotice, "header", Localize( header ) )
		HudElem_SetRuiArg( file.partyMemberNotice, "message", Localize( message ) )
		Hud_SetVisible( file.partyMemberNotice, true )
	}
	else
	{
		Hud_SetVisible( file.partyMemberNotice, false )
	}
}



bool function ShouldTryToCancelMatchmakingFromInvalidPlaylistChange( string playlistName, bool isReady  )
{
	
	if ( IsConnectingToMatch() )
		return false

	if ( GetCurrentPlaylistVarBool( "cancel_matchmaking_after_invalid_playlist_change", false  ) )
		return false

	if ( Lobby_IsPlaylistAvailable( playlistName ) ) 
		return false

	if ( !IsFullyConnected() || !IsPersistenceAvailable() ) 
		   return false

	if ( (!AreWeMatchmaking() && !isReady ) )
		return false

	if ( !IsPartyLeader() ) 
		return false

	return true
}


void function ResetFillButton()
{
	if ( !IsLobby() )
		return

	Hud_SetSelected( file.fillButton, file.fillButtonState )
	SetConVarBool( "party_nofill_selected", !file.fillButtonState ) 
	file.fillButtonWasFullSquad = false
	file.fillButtonWasHidden = false
}

void function UpdateFillButton()
{
	if( !IsLobby() || !IsConnectedServerInfo() )
		return

	Hud_ClearToolTipData( file.fillButton )

	
	bool shouldShowFillButton = DoesPlaylistSupportNoFill( LobbyPlaylist_GetSelectedPlaylist() ) && IsPartyLeader()
	bool shouldLockFillButton = false

	if ( shouldShowFillButton )
	{
		string fillButtonToolTipText = "#MATCH_TEAM_FILL_DESC"

		if ( file.fillButtonWasHidden )
		{
			ResetFillButton()
		}

		if ( AreWeMatchmaking() || IsPreloadingMap() )
		{
			fillButtonToolTipText = "#MATCH_TEAM_FILL_MATCHMAKING"
			shouldLockFillButton = true
		}
		else if ( GetPartySize() >= LobbyPlaylist_GetSelectedPlaylistExpectedSquadSize() )
		{
			fillButtonToolTipText = "#MATCH_TEAM_FILL_ALREADY_FULL"
			shouldLockFillButton = true
			Hud_SetSelected( file.fillButton, false )
			SetConVarBool( "party_nofill_selected", false ) 
			file.fillButtonWasFullSquad = true
		}
		else if ( GetPartySize() < LobbyPlaylist_GetSelectedPlaylistExpectedSquadSize() && file.fillButtonWasFullSquad )
		{
			ResetFillButton()
		}
		else
		{
			Hud_SetSelected( file.fillButton, file.fillButtonState )
			SetConVarBool( "party_nofill_selected", !file.fillButtonState ) 
		}

		ToolTipData td
		td.descText = fillButtonToolTipText
		Hud_SetToolTipData( file.fillButton, td )

	}
	else
	{
		shouldLockFillButton = true
		Hud_SetSelected( file.fillButton, false )
		SetConVarBool( "party_nofill_selected", false )
		file.fillButtonWasHidden = true
	}

	Hud_SetVisible( file.fillButton, shouldShowFillButton )
	Hud_SetEnabled( file.fillButton, !shouldLockFillButton )
	Hud_SetLocked( file.fillButton, shouldLockFillButton )
}

#if DEV
void function FillButton_Toggle()
{
	FillButton_OnActivate( file.fillButton )
}


void function FillButton_SetState( bool state )
{
	file.fillButtonState = state
	Hud_SetSelected( file.fillButton, file.fillButtonState )

	SetConVarBool( "party_nofill_selected", !file.fillButtonState )
	printt( "SHOULD WE FILL THE SQUAD? " + file.fillButtonState )
}
#endif

void function FillButton_OnActivate( var button )
{
	file.fillButtonState = !( Hud_IsSelected( button ) ) 
	Hud_SetSelected( button, file.fillButtonState )

	SetConVarBool( "party_nofill_selected", !file.fillButtonState ) 
	printt( "SHOULD WE FILL THE SQUAD? " + file.fillButtonState )
}


void function ModeButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Remote_ServerCallFunction( "ClientCallback_ViewedModes" )
	file.newModesAcknowledged = true

	AdvanceMenu( GetMenu( "ModeSelectDialog" ) )
}


void function GamemodeSelectButton_OnActivate( var button )
{

	if ( !GetConVarBool( "cups_enabled" ) )
	{
		if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
			return
	}





	Hud_SetVisible( file.gamemodeSelectButton, false )
	Hud_SetVisible( file.readyButton, false )

	string currentLTM = Playlist_GetLTMSlotPlaylist()
	bool resetMode = Lobby_IsPlaylistAvailable( currentLTM )
	if ( (currentLTM != "") && (currentLTM != GetPersistentVar( "lastSeenLobbyLTM" )) && Lobby_IsPlaylistAvailable( currentLTM ) )
	{
		GamemodeSelect_SetFeaturedSlot( "ltm", "#HEADER_NEW_MODE" )
	}
	else
	{
		array<ItemFlavor> currentEvents = GetActiveBuffetEventArray( GetUnixTimestamp() )
		foreach ( event in currentEvents )
		{
			var sBlock         = ItemFlavor_GetSettingsBlock( event )
			string highlight = GetSettingsBlockString( sBlock, "highlightGamemodeSelectorSlot" )
			if ( highlight != "" && highlight != GetPersistentVar( "lastSeenLobbyLTM" ) )
			{
				GamemodeSelect_SetFeaturedSlot( highlight, "#HEADER_NEW_EVENT" )
				resetMode = true
				break
			}
		}
	}

	if ( resetMode )
		Remote_ServerCallFunction( "ClientCallback_ViewedModes" )

	AdvanceMenu( GetMenu( "GamemodeSelectDialog" ) )
}


void function GamemodeSelectButton_OnGetFocus( var button )
{
	GamemodeSelect_PlayVideo( button, LobbyPlaylist_GetSelectedPlaylist() )
}

void function Lobby_OnGamemodeSelectClose()
{
	Hud_SetVisible( file.gamemodeSelectButton, true )
	Hud_SetVisible( file.readyButton, true )

	SocialEventUpdate()
}


void function PlayPanel_OnNavBack( var panel )
{
	if ( !IsControllerModeActive() )
		return

	bool isReady = GetConVarBool( "party_readyToSearch" )
	if ( !AreWeMatchmaking() && !isReady )
		return

	CancelMatchmaking()
	Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
}


bool function ReadyShortcut_OnActivate( var panel )
{
	if ( AreWeMatchmaking() )
		return false

	ReadyButton_OnActivate( file.readyButton )
	return true
}

bool function ShouldForceShowModeSelection()
{
	if ( !GetCurrentPlaylistVarBool( "force_show_mode_selection", true ) )
		return false

	if ( Hud_IsLocked( file.modeButton ) )
		return false

	if ( !CanActivateModeButton() )
		return false

	if ( !HasNewModes() )
		return false

	if ( file.newModesAcknowledged )
		return false

	if ( !HasLocalPlayerCompletedTraining() && !IsLocalPlayerExemptFromTraining() )
		return false


	if ( !HasLocalPlayerCompletedNewPlayerOrientation() && !IsLocalPlayerExemptFromNewPlayerOrientation() )
		return false


	if ( IsSelectedPlaylistQuestMission() )
		return false

	return true
}


void function ReadyButton_OnActivate( var button )
{
	if ( ShouldForceShowModeSelection() )
	{
		if ( GamemodeSelect_IsEnabled() )
			GamemodeSelectButton_OnActivate( file.gamemodeSelectButton )
		else
			ModeButton_OnActivate( file.modeButton )
		return
	}

	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	bool isReady                   = GetConVarBool( "party_readyToSearch" )
	bool requireConsensusForSearch = GetConVarBool( "party_requireConsensusForSearch" )

	if ( AreWeMatchmaking() || isReady )
	{
		CancelMatchmaking()
		Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
		EmitUISound( SOUND_STOP_MATCHMAKING_1P )

		if ( CanRunClientScript() )
		{
			RunClientScript("Lobby_OnReadyFX", false)
			RunClientScript( "OnReady_PLAY", false )
		}
	}
	else
	{
		if ( !IsGameFullyInstalled() || HasNonFullyInstalledAssetsLoaded() )
		{
			ConfirmDialogData data
			data.headerText = "#TEXTURE_STREAM_HEADER"
			data.messageText = Localize( "#TEXTURE_STREAM_MESSAGE", floor( GetGameFullyInstalledProgress() * 100 ) )
			data.yesText = ["#TEXTURE_STREAM_PLAY", "#TEXTURE_STREAM_PLAY_PC"]
			data.noText = ["#TEXTURE_STREAM_WAIT", "#TEXTURE_STREAM_WAIT_PC"]
			if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
			{
				
				data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
				data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
				data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
				data.noText = ["#TEXTURE_STREAM_PLAY_ON_NO", "#TEXTURE_STREAM_PLAY_PC"]
			}

			data.resultCallback = void function ( int result ) : ()
			{
				if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
				{
					
					if ( result == eDialogResult.YES )
					{
						
						ClientCommand( "disconnect" )
						return
					}
				}
				else if ( result != eDialogResult.YES )
				{
					
					return
				}

				
				ReadyButtonActivate()

				
				file.skipDialogCheckForActivateReadyButton = false
			}

			if ( !IsDialog( GetActiveMenu() ) )
			{
				
				
				file.skipDialogCheckForActivateReadyButton = true
				OpenConfirmDialogFromData( data )
			}
			return
		}

		ReadyButtonActivate()
	}
}

void function Lobby_StartMatchmaking()
{
	var jsonTable = {
		map = GetPlaylistRotationGroup()
		next_map_time = GetPlaylistRotationNextTime()
	}
	PIN_UIInteraction_Select( GetActiveMenuName(), "readybutton", jsonTable );

	string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()
	if ( GetConVarBool( "match_teamNoFill" ) && DoesPlaylistSupportNoFillTeams( selectedPlaylist ) )
		StartMatchmakingWithNoFillTeams( selectedPlaylist )
	else
		StartMatchmakingStandard( selectedPlaylist )
}

void function ReadyButtonActivate()
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
	{
		return
	}

	else if ( RankedRumble_GamemodeButtonActivateCheck( LobbyPlaylist_GetSelectedPlaylist() ) )
		return

	else
	{
		EmitUISound( SOUND_START_MATCHMAKING_1P )
		Lobby_StartMatchmaking()

		if ( CanRunClientScript() )
		{
			RunClientScript("Lobby_OnReadyFX", true)
			RunClientScript( "OnReady_PLAY", true )
		}

		RTKTutorialOverlay_Deactivate( eTutorialOverlayID.READY_UP )
	}
}


void function InviteFriendsButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return


		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}


	thread CreatePartyAndInviteFriends()
}


void function InviteLastPlayedButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	int scriptID = int( Hud_GetScriptID( button ) )


		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}


	InviteLastPlayedToParty( scriptID )
	if ( button == file.inviteLastPlayedUnitFrame0 )
		file.lastPlayedPlayerInviteSentTimestamp0 = UITime()
	if ( button == file.inviteLastPlayedUnitFrame1 )
		file.lastPlayedPlayerInviteSentTimestamp1 = UITime()

	HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
	Hud_SetLocked( button, true )
}

bool function IsSamePlatform(int hardwareID1, int hardwareID2 )
{










	return false
}

bool function UICodeCallback_PlayerCanJoinParty( string eaid, string firstPartyHardware, string firstPartyID )
{
	if ( file.lastPlayedPlayerNucleusID0 == eaid )
		return true

	if ( file.lastPlayedPlayerNucleusID1 == eaid )
		return true

	if ( file.lastPlayedPlayerNucleusID2 == eaid )
		return true


	return false
}

void function InviteLastPlayedToParty( int scriptID )
{

	Assert( scriptID == 0 || scriptID == 1 || scriptID == 2 )




	string nucleusID
	string playerUID
	int hardwardID

	switch( scriptID )
	{
		case 0:
			nucleusID = file.lastPlayedPlayerNucleusID0
			playerUID = file.lastPlayedPlayerUID0
			hardwardID = file.lastPlayedPlayerHardwareID0
			break

		case 1:
			nucleusID = file.lastPlayedPlayerNucleusID1
			playerUID = file.lastPlayedPlayerUID1
			hardwardID = file.lastPlayedPlayerHardwareID1
			break

		case 2:
			nucleusID = file.lastPlayedPlayerNucleusID2
			playerUID = file.lastPlayedPlayerUID2
			hardwardID = file.lastPlayedPlayerHardwareID2
			break

	}

	int localHardwareID = GetHardwareFromName( GetPlayerHardware() )
	bool isEADPFriend   = localHardwareID != hardwardID 


		if ( PCPlat_IsSteam() )
			isEADPFriend = true




















	if ( isEADPFriend )
	{
		printt( " InviteEADPFriend id:", nucleusID )
		EADP_InviteToPlayByEAID( nucleusID, 0 )
	}
	else
	{
		printt( " InviteFriend id:", playerUID )
		DoInviteToParty( [playerUID] )
	}
}

bool function InviteLastPlayedButton_OnKeyPress( var button, int keyId, bool isDown )
{
	printf( "LastSquadInputDebug: OnKeyPress" )
	if ( Hud_IsLocked( button ) )
		return false







	if ( !isDown )
		return false

	switch ( keyId )
	{
		case MOUSE_MIDDLE:
		case BUTTON_STICK_LEFT:
			break

		default:
			return false
	}

	int scriptID = int( Hud_GetScriptID( button ) )


		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return false
		}



		Assert( scriptID == 0 || scriptID == 1 || scriptID == 2 )



	printf( "LastSquadInputDebug: OnKeyPress: Club Invite Input Detected" )

	string nucleusID

	switch( scriptID )
	{
		case 0:
			nucleusID = file.lastPlayedPlayerNucleusID0
			break

		case 1:
			nucleusID = file.lastPlayedPlayerNucleusID1
			break

			case 2:
				nucleusID = file.lastPlayedPlayerNucleusID2
				break

	}

	if ( nucleusID == "" )
		return false









	return true
}

void function ServerCallback_GamemodeSelectorInitialize()
{
	if ( HasEventTakeOverActive() )
		return

	if ( GetPartySize() == 1 )
	{
		if ( !IsLocalPlayerExemptFromTraining() && !HasLocalPlayerCompletedTraining() )
			return

		if ( !IsLocalPlayerExemptFromNewPlayerOrientation() && !HasLocalPlayerCompletedNewPlayerOrientation() )
			return
	}
	else if ( DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation() )
	{
		return
	}

	file.gamemodeSelectorPlaylist = ""
	foreach ( string plName in GetVisiblePlaylistNames( IsPrivateMatchLobby() ) )
	{
		int currentPlaylistIndex = GetPlaylistVarInt( plName, "gamemode_selector_index", GAMEMODE_INVALID_INDEX )
		if ( currentPlaylistIndex != GAMEMODE_INVALID_INDEX && currentPlaylistIndex >= 0 && currentPlaylistIndex <= GAMEMODE_MAX_SEEN_INDEX )
		{
			if ( !(expect bool( GetPersistentVar( format( "gamemodeSelectorSeenIndex[%d]", currentPlaylistIndex ) ) )) )
			{
				file.selectedPlaylistIndex    = currentPlaylistIndex
				file.gamemodeSelectorPlaylist = plName

				if ( file.gamemodeSelectorModalDismissed ==  true )
				{
					file.gamemodeSelectorModalDismissed = false
				}

				if ( GetPlaylistVarBool( plName, "gamemode_selector_should_force_selection", true ) )
					LobbyPlaylist_SetSelectedPlaylist( plName )
						break
					}
				}
			}
	ModeSelectorHighlight()
}

string function GetGamemodeSelectorPlaylist()
{
	return file.gamemodeSelectorPlaylist
}

void function DismissGamemodeSelector()
{
	Remote_ServerCallFunction( "ClientCallback_GamemodeSelectorDismiss", file.selectedPlaylistIndex )
	file.gamemodeSelectorPlaylist = ""
}

void function DismissGamemodeSelectorModal( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( file.gamemodeSelectorModalDismissed == true )
		return

	if ( file.isShowing && HasGamemodeSelector() )
		file.gamemodeSelectorModalDismissed = true

	EmitUISound( "UI_Menu_Accept" )
}

bool function HasGamemodeSelector()
{
	if ( AmIPartyMember() && !AmIPartyLeader() )
		return false

	if ( HasEventTakeOverActive() )
		return false

	if ( GetPartySize() == 1 && !IsLocalPlayerExemptFromTraining() && !HasLocalPlayerCompletedTraining() )
		return false


	if ( FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
		return false


	return file.gamemodeSelectorPlaylist.len() > 0
}

void function InviteLastPlayedButton_OnRightClick( var button )
{
	if ( IsSocialPopupActive() )
		return

	int scriptID   = int( Hud_GetScriptID( button ) )
	int hardwareID = GetHardwareFromName( GetPlayerHardware() )

	Friend friend

	if ( scriptID == 0 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		friend.hardware = GetNameFromHardware( file.lastPlayedPlayerHardwareID0 )
		friend.id = file.lastPlayedPlayerUID0
		friend.eadpData = CreateEADPDataFromEAID( file.lastPlayedPlayerNucleusID0 )
	}

	if ( scriptID == 1 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		friend.hardware = GetNameFromHardware( file.lastPlayedPlayerHardwareID1 )
		friend.id = file.lastPlayedPlayerUID1
		friend.eadpData = CreateEADPDataFromEAID( file.lastPlayedPlayerNucleusID1 )
	}

	if ( scriptID == 2 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex2 + "].playerName" ) )
		friend.hardware = GetNameFromHardware( file.lastPlayedPlayerHardwareID2 )
		friend.id = file.lastPlayedPlayerUID2
		friend.eadpData = CreateEADPDataFromEAID( file.lastPlayedPlayerNucleusID2 )
	}


	if ( friend.id == "" )
		return

	InspectFriendForceEADP( friend, PCPlat_IsSteam() )
}


void function SelfButton_OnActivate( var button )
{
	Friend friend
	friend.status = eFriendStatus.ONLINE_INGAME
	friend.name = GetPlayerName()
	friend.hardware = GetPlayerHardware()
	friend.ingame = true
	friend.id = GetPlayerUID()
	friend.unspoofedid = GetPlayerUnSpoofedUID()

	Party party = GetParty()
	friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
	friend.inparty = party.numClaimedSlots > 0

	InspectFriend( friend, true )
}

bool function FriendButton_OnKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	int scriptID = int( Hud_GetScriptID( button ) )

		Assert( scriptID == 0 || scriptID == 1 || scriptID == 2 )














































	
	if ( keyId == BUTTON_A || keyId == MOUSE_LEFT )
	{
		Friend friendToInspect
		switch( scriptID )
		{
			case 0:
				friendToInspect = file.friendInLeftSpot
				break

			case 1:
				friendToInspect = file.friendInRightSpot
				break

			case 2:
				friendToInspect = file.friendInFourthSpot
				break

		}
		InspectFriend( friendToInspect, false )
	}

	
	if ( keyId == BUTTON_X || keyId == MOUSE_RIGHT )
	{
		
		if ( scriptID == 0 )
		{
			string eadpid = GetFriendNucleusID( file.friendInLeftSpot );
			TogglePlayerVoiceAndTextMuteForUID( file.friendInLeftSpot.id, file.friendInLeftSpot.hardware, eadpid )
		}
		else if ( scriptID == 1 )
		{
			string eadpid = GetFriendNucleusID( file.friendInRightSpot );
			TogglePlayerVoiceAndTextMuteForUID( file.friendInRightSpot.id, file.friendInRightSpot.hardware, eadpid )
		}

		else
		{
			string eadpid = GetFriendNucleusID( file.friendInFourthSpot );
			TogglePlayerVoiceAndTextMuteForUID( file.friendInFourthSpot.id, file.friendInFourthSpot.hardware, eadpid )
		}

	}

	return true
}

string function GetFriendNucleusID( Friend friend )
{
	string friendNucleusID = ""
	string friendEadpHardwareName =""
	if( friend.eadpData != null )
	{
		EadpPeopleData friendEadpData = expect EadpPeopleData( friend.eadpData )
		friendNucleusID = friendEadpData.eaid
	}
	else
	{
		friendNucleusID = EADP_GetEadpIdFromFirstPartyID( friend.id, GetHardwareFromName( friend.hardware ) )
	}
	return friendNucleusID
}


void function CreatePartyAndInviteFriends()
{
	if ( CanInvite() )
	{
		while ( !PartyHasMembers() && !AmIPartyLeader() )
		{
			printt( "creating a party in CreatePartyAndInviteFriends" )
			ClientCommand( "createparty" )
			WaitFrameOrUntilLevelLoaded()
		}

		InviteFriends()
	}
	else
	{
		printt( "Not inviting friends - CanInvite() returned false" )
	}
}

void function UpdatePlayPanelGRXDependantElements()
{
	if ( GRX_IsInventoryReady() && IsLobby() )
		UpdateLobbyChallengeMenu( true )

	if ( !IsLobby() )
		Warning( "Called UpdatePlayPanelGRXDependantElements() from a map other than mp_lobby. This should not happen; UIVM cleanup isn't working correctly."  )

#if PC_PROG_NX_UI
		if ( !IsNxHandheldMode() )
			UpdateMiniPromoPinning()
#else
		UpdateMiniPromoPinning()
#endif

	UpdateViewEventButtonReady()
}

void function UpdateMiniPromoPinning()
{
	var miniPromoButton = Hud_GetChild( file.panel, "MiniPromo" )

	array<var> pinCandidates
	pinCandidates.append( Hud_GetChild( file.panel, "ViewEventButton" ) )
	pinCandidates.append( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ) )

	array<var> challengeButtons = GetLobbyChallengeButtons()
	array<var> storyChallengeButtons = GetLobbyStoryChallengeButtons()

	
	challengeButtons.reverse()
	pinCandidates.extend( challengeButtons )
	storyChallengeButtons.reverse()
	pinCandidates.extend( storyChallengeButtons )

	pinCandidates.append( Hud_GetChild( file.panel, "TopRightContentAnchor" ) )

	var anchor = Hud_GetChild( file.panel, "TopRightContentAnchor" )

	foreach ( pinCandidate in pinCandidates )
	{
		if ( !Hud_IsVisible( pinCandidate ) )
			continue

		printt( "Pinning to:", Hud_GetHudName( pinCandidate ) )
		Hud_SetPinSibling( miniPromoButton, Hud_GetHudName( pinCandidate ) )

		int vOffset = pinCandidate == anchor ? 0 : ContentScaledYAsInt( 24 )
		Hud_SetY( miniPromoButton, vOffset )
		break
	}
}

void function UpdateLootBoxButton( var button, array<ItemFlavor> specificPackFlavs = [], bool defaultToFirstSpecificPack = false )
{
	ItemFlavor ornull packFlav
	int lootBoxCount    = 0
	int totalPackCount  = 0
	string buttonText   = "#APEX_PACKS"
	string descText     = "#UNAVAILABLE"
	int nextRarity      = -1
	asset rarityIcon    = $""
	vector themeCol     = <1, 1, 1>
	vector countTextCol = SrgbToLinear( <255, 78, 29> * 1.0 / 255.0 )

	bool nextPackIsSpecial = false
	asset packIcon = $""
	int specialPackCount = 0

	if ( GRX_IsInventoryReady() )
	{
		ItemFlavor ornull nextPack = GetNextLootBox()
		totalPackCount = GRX_GetTotalPackCount()
		if ( totalPackCount > 0 )
		{
			expect ItemFlavor( nextPack )
			packIcon = GRXPack_GetOpenButtonIcon( nextPack )
			if ( packIcon != "" )
			{
				specialPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( nextPack ) )
			}
		}

		descText = "#REMAINING"

		if ( specificPackFlavs.len() > 0 )
		{
			foreach ( ItemFlavor specificPackFlav in specificPackFlavs )
			{
				int count = GRX_GetPackCount( ItemFlavor_GetGRXIndex( specificPackFlav ) )
				if ( packFlav == null && count > 0 )
				{
					packFlav = specificPackFlav
				}
				lootBoxCount += count
			}

			if ( defaultToFirstSpecificPack && packFlav == null)
			{
				packFlav = specificPackFlavs[0]
			}
		}

		if ( packFlav == null )
		{
			if ( specialPackCount > 0 )
			{
				lootBoxCount = specialPackCount
				packFlav = nextPack
			}
			else
			{
				lootBoxCount = totalPackCount
				if ( lootBoxCount > 0 )
				{
					packFlav = nextPack
				}
			}
		}
	}

	if ( packFlav != null )
	{
		expect ItemFlavor( packFlav )

		if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.EVENT )
		{
			buttonText = ItemFlavor_GetShortName( packFlav )
			descText = (lootBoxCount == 1 ? "#EVENT_PACK" : "#EVENT_PACKS")
		}
		else if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.SIRNGE )
		{
			if ( MilestoneEvent_IsMilestonePackFlav( packFlav, false, true ) )
				buttonText = (lootBoxCount == 1 ? "#PACK_MILESTONE_TEXT" : "#PACK_MILESTONE_TEXT_PLURAL" )
			else
				buttonText = (lootBoxCount == 1 ? "#EVENT_PACK" : "#EVENT_PACKS")

			ItemFlavor ornull milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
			if ( milestoneEvent != null )
			{
				expect ItemFlavor( milestoneEvent )
				lootBoxCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( MilestoneEvent_GetMainPackFlav( milestoneEvent ) ) ) +
							   GRX_GetPackCount( ItemFlavor_GetGRXIndex( MilestoneEvent_GetGuaranteedPackFlav( milestoneEvent ) ) )
			}
		}
		else if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.THEMATIC || ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.EVENT_THEMATIC )
		{
			buttonText = ItemFlavor_GetShortName( packFlav )
			descText = (lootBoxCount == 1 ? "#THEMATIC_PACK" : "#THEMATIC_PACKS")
		}
		else
		{
			int packRarity = ItemFlavor_GetQuality( packFlav )
			if ( packRarity > 1 )
			{
				string packTier = ItemFlavor_GetQualityName( packFlav )
				buttonText = ( lootBoxCount == 1 ? Localize( "#APEX_PACK_WITH_TIER", Localize( packTier ) ) : Localize( "#APEX_PACKS_WITH_TIER", Localize ( packTier ) ) )
			}
			else
			{
				buttonText = (lootBoxCount == 1 ? "#APEX_PACK" : "#APEX_PACKS")
			}
		}

		nextRarity = ItemFlavor_GetQuality( packFlav )
		rarityIcon = GRXPack_GetOpenButtonIcon( packFlav )

		vector ornull customCol0 = GRXPack_GetCustomColor( packFlav, 0 )
		if ( customCol0 != null )
			themeCol = SrgbToLinear( expect vector(customCol0) )
		else if ( nextRarity >= 2 )
			themeCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, nextRarity + 1 ) / 255.0 )

		vector ornull customCountTextCol = GRXPack_GetCustomCountTextCol( packFlav )
		if ( customCountTextCol != null )
			countTextCol = SrgbToLinear( expect vector(customCountTextCol) )
	}

	HudElem_SetRuiArg( button, "bigText", string( lootBoxCount ) )
	HudElem_SetRuiArg( button, "buttonText", buttonText )
	HudElem_SetRuiArg( button, "descText", descText )
	HudElem_SetRuiArg( button, "descTextRarity", nextRarity )
	HudElem_SetRuiArg( button, "rarityIcon", rarityIcon, eRuiArgType.ASSET )
	if ( lootBoxCount < totalPackCount )
		HudElem_SetRuiArg( button, "totalPackCount", totalPackCount )
	else
		HudElem_SetRuiArg( button, "totalPackCount", 0 )
	RuiSetColorAlpha( Hud_GetRui( button ), "themeCol", themeCol, 1.0 )
	RuiSetColorAlpha( Hud_GetRui( button ), "countTextCol", countTextCol, 1.0 )

	Hud_SetLocked( button, lootBoxCount == 0 )

	Hud_SetEnabled( button, lootBoxCount > 0 )
}

void function PlayPanelUpdate()
{
	UpdateLobbyButtons()
	UpdateHDTextureProgress()
}


#if DEV
void function LobbyAutomationThink( var menu )
{
	const float delayFactor = 2		
	if ( AutomateUi( delayFactor ) )
	{
		string playlist = GetConVarString( "ui_automation_playlist" )
		if (playlist.len() > 0)
			LobbyPlaylist_SetSelectedPlaylist( playlist )

		int desiredMatchCount = GetConVarInt( "ui_automation_match_count" )
		if ( desiredMatchCount == -1 )
		{
			ReadyShortcut_OnActivate( null )
		}
		else if ( ( automateUIMatchCount < desiredMatchCount ) && ReadyShortcut_OnActivate( null ) )
		{
			automateUIMatchCount += 1
		}
	}
}
#endif

bool function IsLocalPlayerExemptFromTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false


		if ( LobbyPlaylist_IsTournamentMatchmaking() )
			return true


	if ( file.isLocalPlayerExemptFromTraining == eTrainingExemptionState.UNINITIALIZED )
	{
		bool isLevelHighEnough = ( GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) ) >= TRAINING_REQUIRED_BELOW_LEVEL_0_BASE )
		if ( isLevelHighEnough )
			file.isLocalPlayerExemptFromTraining = eTrainingExemptionState.TRUE
		else
			file.isLocalPlayerExemptFromTraining = eTrainingExemptionState.FALSE
	}

	return ( file.isLocalPlayerExemptFromTraining == eTrainingExemptionState.TRUE )
}


void function ServerCallback_SetPlaylistById( int playlistId )
{
	switch( playlistId )
	{
		case PLAYLIST_ID_SURVIVAL:
			LobbyPlaylist_SetSelectedPlaylist( GetDefaultPlaylist() )
			break

		case PLAYLIST_ID_NEW_PLAYER_ORIENTATION:
			LobbyPlaylist_SetSelectedPlaylist( PLAYLIST_NEW_PLAYER_ORIENTATION )
			break
	}
}


#if DEV
void function DEV_PrintPartyInfo()
{
	Party party = GetParty()
	printt( "party.playlistName", party.playlistName )
	printt( "party.originatorName", party.originatorName )
	printt( "party.originatorUID", party.originatorUID )
	printt( "party.numSlots", party.numSlots )
	printt( "party.numClaimedSlots", party.numClaimedSlots )
	printt( "party.numFreeSlots", party.numFreeSlots )
	printt( "party.amIInThis", party.amIInThis )
	printt( "party.amILeader", party.amILeader )
	printt( "party.searching", party.searching )

	foreach ( member in party.members )
	{
		printt( "\tmember.name", member.name )
		printt( "\tmember.uid", member.uid )
		printt( "\tmember.hardware", member.hardware )
		printt( "\tmember.ready", member.ready )

		CommunityUserInfo ornull userInfo = GetUserInfo( member.hardware, member.uid )
		if ( userInfo == null )
			continue

		expect CommunityUserInfo( userInfo )

		DEV_PrintUserInfo( userInfo, "\t\t" )
	}
}

void function DEV_PrintUserInfo( CommunityUserInfo userInfo, string prefix = "" )
{
	printt( prefix + "userInfo.hardware", userInfo.hardware )
	printt( prefix + "userInfo.uid", userInfo.uid )
	printt( prefix + "userInfo.name", userInfo.name )

		printt( prefix + "userInfo.tag", userInfo.tag )

	printt( prefix + "userInfo.kills", userInfo.kills )
	printt( prefix + "userInfo.wins", userInfo.wins )
	printt( prefix + "userInfo.matches", userInfo.matches )
	printt( prefix + "userInfo.banReason", userInfo.banReason, "(see MATCHBANREASON_)" )
	printt( prefix + "userInfo.banSeconds", userInfo.banSeconds )
	printt( prefix + "userInfo.eliteStreak", userInfo.eliteStreak )
	printt( prefix + "userInfo.rankScore", userInfo.rankScore )
	printt( prefix + "userInfo.lastCharIdx", userInfo.lastCharIdx )
	printt( prefix + "userInfo.isLivestreaming", userInfo.isLivestreaming )
	printt( prefix + "userInfo.isOnline", userInfo.isOnline )
	printt( prefix + "userInfo.isJoinable", userInfo.isJoinable )
	printt( prefix + "userInfo.privacySetting", userInfo.privacySetting )
	printt( prefix + "userInfo.partyFull", userInfo.partyFull )
	printt( prefix + "userInfo.partyInMatch", userInfo.partyInMatch )
	printt( prefix + "userInfo.lastServerChangeTime", userInfo.lastServerChangeTime )

	foreach ( int index, data in userInfo.charData )
	{
		printt( prefix + "\tuserInfo.charData[" + index + "]", data, "\t" + DEV_GetEnumStringSafe( "ePlayerStryderCharDataArraySlots", index ) )
	}
}
#endif

void function AllChallengesButton_OnActivate( var button )
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	JumpToChallenges( "" )
}


void function ChallengeSwitchLeft_OnClick( var button )
{
	if ( !IsConnected() )
		return

	Assert( file.challengeCategorySelection != null )
	DecrementCategorySelection()
	UpdateLobbyChallengeMenu( false )
	if( button != null )
		PIN_UIInteraction_OnClick( Hud_GetHudName( file.panel ), Hud_GetHudName( button ) )
}


void function ChallengeSwitchRight_OnClick( var button )
{
	if ( !IsConnected() )
		return

	Assert( file.challengeCategorySelection != null )
	IncrementCategorySelection()
	UpdateLobbyChallengeMenu( false )
	if( button != null )
		PIN_UIInteraction_OnClick( Hud_GetHudName( file.panel ), Hud_GetHudName( button ) )
}


void function ChallengeSwitch_RegisterInputCallbacks()
{
	if ( file.challengeInputCallbacksRegistered )
		return
	file.challengeInputCallbacksRegistered = true

	file.challengeLastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, ChallengeSwitchOnStickMoved )
	AddCallback_OnMouseWheelUp( ChallengeMouseUp )
	AddCallback_OnMouseWheelDown( ChallengeMouseDown )
}


void function ChallengeSwitch_RemoveInputCallbacks()
{
	if ( !file.challengeInputCallbacksRegistered )
		return
	file.challengeInputCallbacksRegistered = false

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, ChallengeSwitchOnStickMoved )
	RemoveCallback_OnMouseWheelUp( ChallengeMouseUp )
	RemoveCallback_OnMouseWheelDown( ChallengeMouseDown )
}

bool function ChallengeSwitch_CanChangeCategory()
{
	return Hud_IsCursorOver( Hud_GetChild( file.panel, "ChallengesBounds" ) ) && !Hud_IsFocused( Hud_GetChild( file.panel, "MiniPromo" ) )
}

void function ChallengeMouseUp()
{
	if ( !ChallengeSwitch_CanChangeCategory() )
		return

	EmitUISound( "UI_Menu_BattlePass_LevelTab" )
	ChallengeSwitchLeft_OnClick( null )

	PIN_UIInteraction_OnScroll( Hud_GetHudName( file.panel ), Hud_GetHudName( file.challengesLeftButton ) )
}

void function ChallengeMouseDown()
{
	if ( !ChallengeSwitch_CanChangeCategory() )
		return

	EmitUISound( "UI_Menu_BattlePass_LevelTab" )
	ChallengeSwitchRight_OnClick( null )
	PIN_UIInteraction_OnScroll( Hud_GetHudName( file.panel ), Hud_GetHudName( file.challengesRightButton ) )
}

void function ChallengeSwitchOnStickMoved( ... )
{
	float stickDeflection = expect float( vargv[1] )

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != file.challengeLastStickState && ChallengeSwitch_CanChangeCategory() )
	{
		if ( stickState == eStickState.RIGHT )
		{
			EmitUISound( "UI_Menu_BattlePass_LevelTab" )
			ChallengeSwitchRight_OnClick( null )
		}
		else if ( stickState == eStickState.LEFT )
		{
			EmitUISound( "UI_Menu_BattlePass_LevelTab" )
			ChallengeSwitchLeft_OnClick( null )
		}
	}

	file.challengeLastStickState = stickState
}

void function Lobby_UpdatePlayPanelPlaylists()
{
	LobbyPlaylist_SetPlaylistMods( GetPlaylistModNames() )
	LobbyPlaylist_SetPlaylists( GetVisiblePlaylistNames() )

	if ( !IsFullyConnected() )
		return

	if ( AreWeMatchmaking() )
		return

	if ( IsPreloadingMap() )
		return

	bool isPartyLeader = IsPartyLeader()
	string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()

	if ( isPartyLeader )
	{
		if ( HasEventTakeOverActive() )
		{
			LobbyPlaylist_SetSelectedPlaylist( GetEventTakeoverPlaylist() )
			return
		}

		if ( GetPartySize() == 1 && !IsLocalPlayerExemptFromTraining() && !HasLocalPlayerCompletedTraining() )
		{
			LobbyPlaylist_SetSelectedPlaylist( PLAYLIST_TRAINING )
				return
		}


		bool mustLocalPlayerDoOrientation = (!IsLocalPlayerExemptFromNewPlayerOrientation() && !HasLocalPlayerCompletedNewPlayerOrientation())
		if ( mustLocalPlayerDoOrientation || DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation() )
		{
			string currentSelectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()
			if ( currentSelectedPlaylist != PLAYLIST_TRAINING && currentSelectedPlaylist != PLAYLIST_FIRING_RANGE )
			{
				printt( "Chosing playlist for new player bot queue. Previous playlist was:" + currentSelectedPlaylist + "\n")
				printt( "mustLocalPlayerDoOrientation:" + string(mustLocalPlayerDoOrientation) + " DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation():" + string(DoNonlocalPlayerPartyMembersNeedToCompleteNewPlayerOrientation()) +"\n")
				LobbyPlaylist_SetSelectedPlaylist( PLAYLIST_NEW_PLAYER_ORIENTATION )
			}

			return
		}

	}

	if ( LobbyPlaylist_GetPlaylists().contains( selectedPlaylist ) && selectedPlaylist != PLAYLIST_NEW_PLAYER_ORIENTATION )
	{
		if ( CustomMatch_IsInCustomMatch() )
			return

		bool isMatchPlaylistCustomMatch = GetPlaylistVarBool( GetConVarString( "match_playlist" ), "private_match", false )
		if ( !isMatchPlaylistCustomMatch )
			return
	}


	if ( LobbyPlaylist_IsTournamentMatchmaking() )
		return


	
	
	string newPlaylist = GetDefaultPlaylist()
	string selectedUISlot = LobbyPlaylist_GetSelectedUISlot()
	bool foundOtherPlaylist = false
	if ( selectedUISlot != "" )
	{
		printt( "Attempting to select playlist based on UI slot: " + selectedUISlot )
		string playlistInSlot = GetCurrentPlaylistInUiSlot( selectedUISlot )
		if ( playlistInSlot != "" )
		{
			foundOtherPlaylist = true
			newPlaylist = playlistInSlot
			printt("UISlot -> Playlist", newPlaylist )
		}
	}
	if ( !foundOtherPlaylist && selectedPlaylist != "" )
	{
		printt( "Attempting to select playlist based on previous playlist: " + selectedPlaylist )
		string uiSlot         = GetPlaylistVarString( selectedPlaylist, "ui_slot", "" )
		string playlistInSlot = GetCurrentPlaylistInUiSlot( uiSlot )
		if ( playlistInSlot != "" )
		{
			foundOtherPlaylist = true
			newPlaylist = playlistInSlot
		}
	}

	Party party = GetParty()
	if ( !foundOtherPlaylist && IsValid ( party ) && party.playlistName != "" )
	{
		foundOtherPlaylist = true
		newPlaylist = party.playlistName
		printt( "Attempting to select playlist based on party data!", party.playlistName, isPartyLeader )
	}

	if ( !foundOtherPlaylist )
		printt( "Could not find suitable playlist through UI Slot or previously selected playlist!" )

	if ( isPartyLeader )
		LobbyPlaylist_SetSelectedPlaylist( newPlaylist )
}

void function OnPartySpectateSlotUnavailableWaitlisted()
{
	JoinMatchAsPartySpectatorFailedAddedToWaitlistDialog()
}

void function JoinMatchAsPartySpectatorFailedAddedToWaitlistDialog()
{
	if ( !AmIPartyMember() || AmIPartyLeader() )
		return

	ConfirmDialogData data
	data.headerText =  "#JOIN_MATCH_AS_PARTY_SPECTATOR_ADDED_TO_WAITLIST"
	data.messageText = "#JOIN_MATCH_AS_PARTY_SPECTATOR_ADDED_TO_WAITLIST_DESC"

	OpenOKDialogFromData( data )
}

void function OnPartySpectateSlotAvailable()
{
	if( CanPromptUserToSpectatePartyInGame() )
	{
		JoinMatchAsWaitlistedPartySpectatorDialog()
	}
}

void function JoinMatchAsWaitlistedPartySpectatorDialog()
{
	if ( !AmIPartyMember() || AmIPartyLeader() )
		return

	ConfirmDialogData data
	data.headerText =  "#JOIN_MATCH_AS_WAITLISTED_PARTY_SPECTATOR"
	data.messageText = "#JOIN_MATCH_AS_WAITLISTED_PARTY_SPECTATOR_DESC"
	data.resultCallback = OnJoinMatchAsWaitlistedPartySpectatorDialogResult

	OpenConfirmDialogFromData( data )
}

void function OnJoinMatchAsWaitlistedPartySpectatorDialogResult( int result )
{
	if ( result != eDialogResult.YES )
		return

	Party_JoinUserPartyGame()
}

void function TryShowMatchmakingDelayDialog()
{
	if ( !ShouldShowMatchmakingDelayDialog() )
		return

	DialogFlow()
}


bool function ShouldShowMatchmakingDelayDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = SharedRanked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid )
				{
					amIbanned = true
				}
			}
		}
	}

	if ( bannedPartyMembers.len() == 0 )
		return false

	if ( amIbanned && bannedPartyMembers.len() == 1 && file.haveShownSelfMatchmakingDelay )
		return false

	return !(file.haveShownPartyMemberMatchmakingDelay)
}


void function ShowMatchmakingDelayDialog()
{
	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	int maxDelayTime = -1
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = SharedRanked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid )
				{
					amIbanned = true
				}

				if ( matchMakingDelay > maxDelayTime )
					maxDelayTime = matchMakingDelay
			}
		}
	}

	Assert( bannedPartyMembers.len() > 0 )
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	if ( amIbanned && bannedPartyMembers.len() == 1 )
	{
		if ( !file.haveShownSelfMatchmakingDelay )
		{
			dialogData.headerText = "#RANKED_ABANDON_PENALTY_HEADER"
			dialogData.messageText = "#RANKED_ABANDON_PENALTY_MESSAGE"
			file.haveShownSelfMatchmakingDelay = true
		}
	}
	else
	{
		file.haveShownPartyMemberMatchmakingDelay = true
		switch( bannedPartyMembers.len() ) 
		{
			case 1:
				dialogData.headerText = "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name )
				break

			case 2:
				dialogData.headerText = "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name )
				break

			case 3:
				dialogData.headerText = "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name, bannedPartyMembers[ 2 ].name )
				break

			default:
				unreachable
		}
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"
	dialogData.timerEndTime = ClientTime() + maxDelayTime

	OpenOKDialogFromData( dialogData )
}


bool function ShouldShowLastGameRankedAbandonForgivenessDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	if ( file.haveShownLastGameRankedAbandonForgivenessDialog )
		return false

	return bool ( GetPersistentVarAsInt( "rankedGameData.lastGameAbandonForgiveness" ) )
}


void function ShowLastGameRankedAbandonForgivenessDialog()
{
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	int numUsedForgivenessAbandons = expect int ( GetPersistentVar( "numUsedForgivenessAbandons" ) )

	if ( numUsedForgivenessAbandons == GetCurrentPlaylistVarInt( "ranked_num_abandon_forgiveness_games", SHARED_RANKED_NUM_ABANDON_FORGIVENESS_GAMES ) )
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_MESSAGE"
	}
	else
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_MESSAGE"
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"

	file.haveShownLastGameRankedAbandonForgivenessDialog = true

	OpenOKDialogFromData( dialogData )
}


void function SharedRanked_OnLevelInit()
{
	if ( !IsLobby() )
		return

	file.haveShownSelfMatchmakingDelay = false
	file.haveShownLastGameRankedAbandonForgivenessDialog = false
	file.haveShownPartyMemberMatchmakingDelay = false
	LobbyPlaylist_SetCurrentMaxMatchmakingDelayEndTime( -1 )

	if ( !file.rankedInitialized ) 
	{
		AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedForMatchmakingDelay )
		file.rankedInitialized = true
	}

	LobbyPlaylist_GetCurrentMaxMatchmakingDelayEndTime()
	TryShowMatchmakingDelayDialog()
}


void function Ranked_OnUserInfoUpdatedForMatchmakingDelay( string hardware, string id )
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

	bool foundPartyMember = false

	foreach ( index, member in GetParty().members )
	{
		if ( cui.hardware != member.hardware && cui.uid != member.uid )
			continue

		foundPartyMember = true
		break
	}

	if ( !foundPartyMember )
		return

	int matchMakingDelay = SharedRanked_GetMaxPartyMatchmakingDelay()

	if ( matchMakingDelay > 0 )
	{
		LobbyPlaylist_SetCurrentMaxMatchmakingDelayEndTime( matchMakingDelay + UITime() )
		TryShowMatchmakingDelayDialog()
	}
}


void function Ranked_OnUserInfoUpdatedInPanelPlay( string hardware, string id )
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
		if ( file.rankedRUIToUpdate != null ) 
		{
			PopulateRuiWithRankedBadgeDetails( file.rankedRUIToUpdate, cui.rankScore, cui.rankedLadderPos )
		}






	}
}

void function Lobby_ShowCallToActionPopup( bool challengesOnly )
{
	Signal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )
	EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

	file.dialogFlowDidCausePotentiallyInterruptingPopup = false

	while( !EventChallengesDidRefreshOnUI() )
		WaitFrame()

	while ( !GRX_IsInventoryReady() )
		WaitFrame()

	if ( Lobby_ShowStoryEventChallengesPopup() ) 
		return

	if ( !challengesOnly )
	{
		if( Lobby_ShowLegendsTokenPopup() )
			return

		if( Lobby_ShowCurrencyExpirationPopup() )
			return

		if ( Lobby_ShowStoryEventAutoplayDialoguePopup() )
			return

		if ( Lobby_ShowBattlePassPopup() )
			return

		if ( Lobby_ShowHeirloomShopPopup() )
			return
	}
}


void function Lobby_HideCallToActionPopup()
{
	var popup = Hud_GetChild( file.panel, "PopupMessage" )
	Hud_Hide( popup )
}


bool function Lobby_ShowBattlePassPopup( bool forceShow = false )
{
	if ( IsBattlepassMilestoneEnabled() )
		return false

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( activeBattlePass == null )
		return false

	expect ItemFlavor( activeBattlePass )

	entity player = GetLocalClientPlayer()

	if( IsFeatureSuppressed( eFeatureSuppressionFlags.BATTLE_PASS_POPUP ) && !forceShow )
		return false

	if ( DoesPlayerOwnBattlePass( player, activeBattlePass ) && !forceShow )
		return false

	int currentXPProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	int bpLevel           = GetBattlePassLevelForXP( activeBattlePass, currentXPProgress )

	BattlePassReward ornull rewardToShow = null

	
	array<int> popupLevelMarkers_intArray

	
	string popupLevelMarkers_stringOverride = GetCurrentPlaylistVarString( "battlepass_popup_level_markers", "" )
	
	if ( popupLevelMarkers_stringOverride != "" )
	{
		array<string> popupLevelMarkers_stringArray = split( popupLevelMarkers_stringOverride, WHITESPACE_CHARACTERS )
		foreach ( levelString in popupLevelMarkers_stringArray )
		{
			popupLevelMarkers_intArray.append( int( levelString ) )
		}
	}
	else
	{
		
		popupLevelMarkers_intArray = GetRewardPromptLevelArray( activeBattlePass )
	}

#if DEV
	{ 
		foreach (int i in popupLevelMarkers_intArray )
		{
			printf( "popup level marker: " + string(i) )
		}
	}
#endif
	int markerLevel = 0

	foreach ( level in popupLevelMarkers_intArray )
	{
		if ( level - 1 <= bpLevel )
			markerLevel = level - 1
	}

	if ( markerLevel <= 0 && !forceShow )
		return false

	string bpString = ItemFlavor_GetGUIDString( activeBattlePass )

	if ( markerLevel <= player.GetPersistentVar( format( "battlePasses[%s].lastPopupLevel", bpString ) ) && !forceShow )
		return false

	array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, markerLevel )

	foreach ( reward in rewards )
	{
		if ( !reward.isPremium )
			continue

		rewardToShow = reward
		break
	}

	if ( rewardToShow == null )
		return false

	expect BattlePassReward( rewardToShow )

	file.onCallToActionFunc = void function() : ()
	{

			JumpToSeasonTab( "RTKBattlepassPanel" )



		TabData tabData = GetTabDataForPanel( Hud_GetParent( file.panel ) )

			AdvanceMenu( GetMenu( "RTKBattlepassPurchaseMenu" ) )



		PIN_LobbyPopUp_Event( "battle_pass_pop_up", ePINPromoMessageStatus.CLICK )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ( rewardToShow, bpLevel, markerLevel )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		var popup = Hud_GetChild( file.panel, "PopupMessage" )
		Lobby_MovePopupMessage( 1 )
		RuiSetImage( Hud_GetRui( popup ), "buttonImage", CustomizeMenu_GetRewardButtonImage( rewardToShow.flav ) )
		int rarity = ItemFlavor_HasQuality( rewardToShow.flav ) ? ItemFlavor_GetQuality( rewardToShow.flav ) : 0
		RuiSetInt( Hud_GetRui( popup ), "rarity", rarity )
		RuiSetInt( Hud_GetRui( popup ), "level", bpLevel + 1 )
		BattlePass_SetRewardButtonIconSettings( rewardToShow.flav, Hud_GetRui( popup ), null, false )
		BattlePass_SetUnlockedString( popup, bpLevel + 1 )

		HudElem_SetRuiArg( popup, "titleText", Localize( "#BATTLEPASS_POPUP_TITLE" ) )
		HudElem_SetRuiArg( popup, "subText", Localize( "#BATTLEPASS_POPUP_BODY", bpLevel + 1 ) )
		HudElem_SetRuiArg( popup, "detailText", Localize( "#BATTLEPASS_POPUP_UNLOCK" ) )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", ClientTime() )
		Remote_ServerCallFunction( "ClientCallback_MarkBattlePassPopupAsSeen", markerLevel )
		PIN_LobbyPopUp_Event( "battle_pass_pop_up", ePINPromoMessageStatus.IMPRESSION )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}


bool function Lobby_ShowHeirloomShopPopup( bool forceShow = false )
{
	if( IsFeatureSuppressed( eFeatureSuppressionFlags.HEIRLOOM_SHOP_POPUP ) && !forceShow )
		return false

	if ( !GRX_AreOffersReady() && !forceShow  )
		return false

	int heirloomShardBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	int priceOfHeirloom      = GetCurrentPlaylistVarInt( "grx_currency_bundle_heirloom_count", 50 ) * 3
	if ( heirloomShardBalance < priceOfHeirloom && !forceShow )
		return false

	if ( GetUnixTimestamp() - expect int( GetPersistentVar( "heirloomShopLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
		return false

	
	bool hasHeirloomsToCraft = false
	foreach( scriptOffer in GRX_GetLocationOffers( "heirloom_set_shop" ) )
	{
		if( !scriptOffer.isAvailable )
			continue

		Assert( scriptOffer.prices.len() == 1 )
		Assert( scriptOffer.prices[0].flavors.len() == 1 && scriptOffer.prices[0].flavors[0] == GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
		Assert( scriptOffer.prices[0].quantities.len() == 1)

		if ( heirloomShardBalance < scriptOffer.prices[0].quantities[0] )
			continue

		ItemFlavor outputFlav = ItemFlavorBag_GetMeleeSkinItem( scriptOffer.output )

		if ( !GRX_IsItemOwnedByPlayer_AllowOutOfDateData( outputFlav ) )
		{
			hasHeirloomsToCraft = true
			break
		}
	}
	if( !hasHeirloomsToCraft )
		return false

	file.onCallToActionFunc = void function() : ()
	{
		JumpToHeirloomShop()
		PIN_LobbyPopUp_Event( "heirloom_crafting_pop_up", ePINPromoMessageStatus.CLICK )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ()
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		int idx              = Tab_GetTabIndexByBodyName( lobbyTabData, "PassPanelV2" )
		var popup            = Hud_GetChild( file.panel, "PopupMessage" )

		HudElem_SetRuiArg( popup, "titleText", "#CTA_HEIRLOOM_SHOP_TITLE" )
		HudElem_SetRuiArg( popup, "subText", "#CTA_HEIRLOOM_SHOP_SUBTEXT" )
		HudElem_SetRuiArg( popup, "detailText", "#CTA_HEIRLOOM_SHOP_DETAIL" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )
		HudElem_SetRuiArg( popup, "buttonImage", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ), eRuiArgType.IMAGE )
		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		HudElem_SetRuiArg( popup, "rarity", eRarityTier.MYTHIC )

		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.MYTHIC ) / 255.0 ) )

		Lobby_MovePopupMessage( 2 )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", ClientTime() )
		Remote_ServerCallFunction( "ClientCallback_MarkHeirloomShopPopupAsSeen" )
		PIN_LobbyPopUp_Event( "heirloom_crafting_pop_up", ePINPromoMessageStatus.IMPRESSION )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}

bool function Lobby_ShowLegendsTokenPopup( bool forceShow = false )
{
	if( ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() ) && !forceShow )
		return false


	if ( !GetConVarBool( "ftue_flow_enabled" ) && GetFirstTimePlayerState() >= eNewPlayerState.FIRST_MATCH_PLAYED && !forceShow )
		return false




	if( expect int( GetPersistentVar( "legendTokensPopupLastSeen" ) ) > 0 && !forceShow )
		return false

	int playerBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
	int legendTokensCost = -1
	foreach ( ItemFlavor character in GetAllCharacters() )
	{
		int ItemFlavourGRXMode = ItemFlavor_GetGRXMode( character )
		if( ItemFlavourGRXMode == GRX_ITEMFLAVORMODE_NONE )
			continue

		if ( ItemFlavor_IsItemDisabledForGRX( character ) )
			continue

		if ( ItemFlavourGRXMode == GRX_ITEMFLAVORMODE_REGULAR && Character_IsCharacterOwnedByPlayer( character ) )
			continue

		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( character )
		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
		{
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
			{
				if ( locationOffer.isAvailable && locationOffer.offerType != GRX_OFFERTYPE_BUNDLE && locationOffer.output.flavors.len() == 1 )
				{
					foreach ( ItemFlavorBag price in locationOffer.prices )
					{
						if ( GRX_IsPremiumPrice( price ) || (!GRX_CanAfford( price, 1 )) )
							continue

						array<int> priceArray = GRX_GetCurrencyArrayFromBag( price )
						int craftingPrice     = priceArray[GRX_CURRENCY_CREDITS]
						if ( legendTokensCost < 0 || legendTokensCost > craftingPrice )
							legendTokensCost = craftingPrice
					}
				}
			}
		}
	}

	if( ( legendTokensCost < 0 || playerBalance < legendTokensCost ) && !forceShow )
		return false


	file.onCallToActionFunc = void function() : ()
	{
		JumpToCharactersTab()
		PIN_LobbyPopUp_Event( "legend_token_pop_up", ePINPromoMessageStatus.CLICK )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ()
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		var popup           	= Hud_GetChild( file.panel, "PopupMessage" )
		var popupRui			= Hud_GetRui( popup )

		HudElem_SetRuiArg( popup, "titleText", "#CTA_LEGEND_TOKENS_TITLE" )
		HudElem_SetRuiArg( popup, "subText", "#CTA_LEGEND_TOKENS_SUBTEXT" )
		HudElem_SetRuiArg( popup, "detailText", "#CTA_LEGEND_TOKENS_DETAIL" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )
		HudElem_SetRuiArg( popup, "buttonImage", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] ), eRuiArgType.IMAGE )
		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		HudElem_SetRuiArg( popup, "rarity", eRarityTier.RARE )

		HudElem_SetRuiArg( popup, "showArrow", true )

#if PC_PROG_NX_UI
		RuiSetFloat2( popupRui, "arrowOffset", <0.32, 0.0, 0.0> )
#else
		RuiSetFloat2( popupRui, "arrowOffset", <0.39, 0.0, 0.0> )
#endif


		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.RARE ) / 255.0 ) )

		Lobby_MovePopupMessage( 2 )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", ClientTime() )
		Remote_ServerCallFunction( "ClientCallback_MarkLegendTokensPopupAsSeen" )
		PIN_LobbyPopUp_Event( "legend_token_pop_up", ePINPromoMessageStatus.IMPRESSION )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )

	}()
	return true
}

bool function Lobby_ShowCurrencyExpirationPopup( bool forceShow = false )
{
	array< int > showPriority = [GRX_CURRENCY_EXOTIC, GRX_CURRENCY_PREMIUM]

	int nextExpirationType, nextExpirationTime, auxExpirationTime

	for ( int i = 0; i < showPriority.len(); i++ )
	{
		if (i == 0 )
		{
			nextExpirationType = showPriority[i]
			nextExpirationTime = GRX_GetNextCurrencyExpirationTime( GRX_CURRENCIES[nextExpirationType] )
		}
		else
		{
			auxExpirationTime = GRX_GetNextCurrencyExpirationTime( GRX_CURRENCIES[showPriority[i]] )
			if ( auxExpirationTime > 0 && (auxExpirationTime < nextExpirationTime || nextExpirationTime == 0))
			{
				nextExpirationType = showPriority[i]
				nextExpirationTime = auxExpirationTime
			}
		}
	}

	if( IsFeatureSuppressed( eFeatureSuppressionFlags.CURRENCY_EXPIRATION_POPUP ) && !forceShow )
		return false

	if( !forceShow && ( expect int( GetPersistentVar( "currencyExpPopupLastExpTime" ) ) == nextExpirationTime || nextExpirationTime - GetUnixTimestamp() > SECONDS_PER_DAY * 30 ) )
		return false

	entity player = GetLocalClientPlayer()

	file.onCallToActionFunc = void function() : ()
	{
		PIN_LobbyPopUp_Event( "currency_expiration_pop_up", ePINPromoMessageStatus.CLICK )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ( nextExpirationTime, nextExpirationType )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		var popup            = Hud_GetChild( file.panel, "PopupMessage" )

		if ( nextExpirationType == GRX_CURRENCY_PREMIUM )
		{
			HudElem_SetRuiArg( popup, "titleText", "#EXPIRING_CURRENCY_HEADER" )
			HudElem_SetRuiArg( popup, "subText", "#EXPIRING_CURRENCY_BODY" )
			HudElem_SetRuiArg( popup, "buttonImage", $"rui/menu/common/apex_coins_button_sq_112", eRuiArgType.IMAGE )
		}
		else if ( nextExpirationType == GRX_CURRENCY_EXOTIC )
		{
			HudElem_SetRuiArg( popup, "titleText", "#EXPIRING_CURRENCY_EXOTIC_HEADER" )
			HudElem_SetRuiArg( popup, "subText", "#EXPIRING_CURRENCY_EXOTIC_BODY" )
			HudElem_SetRuiArg( popup, "buttonImage", $"rui/menu/common/exotic_shards_button_sq_112", eRuiArgType.IMAGE )
		}

		HudElem_SetRuiArg( popup, "detailText", "" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )

		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.MYTHIC ) / 255.0 ) )

		Lobby_MovePopupMessage( 0, 0.288 )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) || IsDialog( GetActiveMenu() ) )
			wait 0.2

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", ClientTime() )
		Remote_ServerCallFunction( "ClientCallback_MarkCurrencyExpirationPopupAsSeen", nextExpirationTime )
		PIN_LobbyPopUp_Event( "currency_expiration_pop_up", ePINPromoMessageStatus.IMPRESSION )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}

bool function Lobby_ShowStoryEventAutoplayDialoguePopup( bool forceShow = false )
{
	if( IsFeatureSuppressed( eFeatureSuppressionFlags.STORY_EVENT_AUTOPLAY_DIALOGUE_POPUP ) && !forceShow )
		return false

	array<ItemFlavor> storyChallengeEvents  = GetActiveStoryChallengeEvents( GetUnixTimestamp() )
	if ( storyChallengeEvents.len() <= 0 )
		return false

	entity player = GetLocalClientPlayer()

	
	
	if( ( GetUnixTimestamp() - expect int( GetPersistentVar( "storyEventDialoguePopupLastSeen" ) ) < SECONDS_PER_DAY * 2 ) && !forceShow )
		return false

	array<StoryEventDialogueData> dialogueDatas
	foreach ( event in storyChallengeEvents )
	{
		array<StoryEventDialogueData> temp =  StoryChallengeEvent_GetAutoplayDialogueDataForPlayer( event, player )
		dialogueDatas.extend( temp )
	}

	
	if ( dialogueDatas.len() > 0 )
	{
		Remote_ServerCallFunction ("ClientCallback_MarkStoryEventDialoguePopupAsAttempted")
		thread Lobby_ShowDialoguePopupFromData( dialogueDatas )
		return true
	}

	return false
}

void function Lobby_ShowDialoguePopupFromData( array<StoryEventDialogueData> dialogueDatas )
{
	Signal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" ) 
	EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

	var popup = Hud_GetChild( file.panel, "StoryEventsMessage" )
	var rui   = Hud_GetRui( popup )

	foreach ( StoryEventDialogueData data in dialogueDatas )
	{
		RuiSetBool( rui, "shouldHideInMenu", false )
		RuiSetString( rui, "displayText", data.bodyText )
		RuiSetString( rui, "speakerName", data.speakerName )
		RuiSetImage( rui, "portraitImage", data.speakerIcon )

		wait 0.5

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetFloat( rui, "soundDuration", data.duration )
		RuiSetGameTime( rui, "startTimeOverride", ClientTime() )

		thread CallToActionDialoguePopupAudioThink( popup, data )
		waitthread CallToActionDialoguePopupThink( popup, data )
	}
}

bool function Lobby_ShowStoryEventChallengesPopup( bool forceShow = false )
{
	array< ItemFlavor > storyChallengeEvents = GetActiveStoryChallengeEvents( GetUnixTimestamp() )
	if ( storyChallengeEvents.len() <= 0 )
		return false

	entity player = GetLocalClientPlayer()

	foreach ( event in storyChallengeEvents )
	{
		array<ItemFlavor> appropriateSpecialEventChallenges = StoryChallengeEvent_GetActiveChallengesForPlayer( event, player )
		bool hasSeenPopupForSomeChallenges                  = false
		array<ItemFlavor> activeChallenges
		array<StoryEventGroupChallengeData> challengeDataForSeenPersistenceVarNames

		foreach ( ItemFlavor challenge in appropriateSpecialEventChallenges )
		{
			
			if ( Challenge_IsAssigned( player, challenge ) && !Challenge_IsComplete( player, challenge ) )
			{
				activeChallenges.append( challenge )

				StoryEventGroupChallengeData challengeData = StoryChallengeEvent_GetHasChallengesData( challenge, player )
				string ornull hasSeenPersistenceVarNameOrNull = challengeData.persistenceVarNameHasSeenOrNull
				if ( hasSeenPersistenceVarNameOrNull != null && !challengeDataForSeenPersistenceVarNames.contains( challengeData ) )
					challengeDataForSeenPersistenceVarNames.append( challengeData )

				if ( StoryChallengeEvent_HasChallengesPopupBeenSeen( challenge, player ) )
					hasSeenPopupForSomeChallenges = true
			}
		}

		if ( activeChallenges.len() == 0 )
			continue

		if ( challengeDataForSeenPersistenceVarNames.len() == 0 )
			continue

		
		if ( hasSeenPopupForSomeChallenges )
		{
			if ( GetUnixTimestamp() - expect int( GetPersistentVar( "storyEventChallengesPopupLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
				continue
		}

		
		
		int kind = Challenge_GetTimeSpanKind( activeChallenges[0] )
		if ( kind == eChallengeTimeSpanKind.EVENT_SPECIAL )
		{
			file.onCallToActionFunc = void function() : ()
			{
				JumpToChallenges( "" )
				AllChallengesMenu_ForceClickSpecialEventButton( eChallengeTimeSpanKind.EVENT_SPECIAL )
				Lobby_HideCallToActionPopup()
			}
		}
		else if ( kind == eChallengeTimeSpanKind.EVENT_SPECIAL_2 )
		{
			ItemFlavor storyEvent = event
			file.onCallToActionFunc = void function() : ( storyEvent )
			{
				StoryEventAboutDialog_SetEvent( storyEvent )
				AdvanceMenu( GetMenu( "StoryEventAboutDialog" ) )
				Lobby_HideCallToActionPopup()
			}
		}
		else
		{
			Assert( false, "StoryChallengeEvent challenges only support all EVENT_SPECIAL or all EVENT_SPECIAL_2 kinds" )
		}

		string eventTitle = ItemFlavor_GetShortName( event )
		string eventDesc = ItemFlavor_GetShortDescription( event )
		
		int eventType  = ItemFlavor_GetType( event )
		thread function() : ( challengeDataForSeenPersistenceVarNames, eventTitle, eventDesc, eventType )
		{
			EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

			TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
			var popup            = Hud_GetChild( file.panel, "PopupMessage" )

			HudElem_SetRuiArg( popup, "titleText", eventTitle )
			HudElem_SetRuiArg( popup, "subText", "#S08E04_CHALLENGES_NOTIFICATION" )
			HudElem_SetRuiArg( popup, "detailText", "" )
			HudElem_SetRuiArg( popup, "unlockedString", "" )
			HudElem_SetRuiArg( popup, "buttonImage", $"rui/events/s12e04/challenges_logo", eRuiArgType.IMAGE ) 
			HudElem_SetRuiArg( popup, "forceFullIcon", false )

			HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
			HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
			HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.MYTHIC ) / 255.0 ) )

			Lobby_MovePopupMessage( 0, 0.288 )

			wait 0.2

			while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
				WaitFrame()

			RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", ClientTime() )

			if( eventType == eItemType.calevent_story_challenges )
				EmitUISound( "UI_Menu_StoryEvent_PopUp" )
			else
				EmitUISound( SOUND_BP_POPUP )

			foreach ( StoryEventGroupChallengeData data in challengeDataForSeenPersistenceVarNames )
				Remote_ServerCallFunction( "ClientCallback_MarkStoryEventChallengesPopupAsSeen", data.challengeGroupGuid, data.challengeBlockIndex )

			thread CallToActionPopupThink( popup, 10.0 )
		}()

		return true 
	}

	return false
}

void function CallToActionPopupThink( var popup, float timeout )
{
	Signal( uiGlobal.signalDummy, "CallToActionPopupThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupThink" )

	OnThreadEnd(
		function() : ( popup )
		{
			Hud_Hide( popup )
		}
	)

	Hud_Show( popup )

	float showedTime = 0
	while ( showedTime < timeout )
	{
		wait 0.25

		if( GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel ) && !IsDialog( GetActiveMenu() ) )
			showedTime += 0.25
	}

	while ( GetFocus() == popup )
		wait 0.25
}


void function CallToActionDialoguePopupAudioThink( var popup, StoryEventDialogueData data )
{
	Signal( uiGlobal.signalDummy, "CallToActionPopupAudioThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupAudioThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupAudioCancel" )

	OnThreadEnd(
		function() : ( data )
		{
			foreach ( string alias in data.audioAliases )
				StopUISoundByName( alias )
		}
	)

	EmitUISound( "SQ_UI_InGame_CommChime" )

	foreach ( string alias in data.audioAliases )
	{
		var handle = EmitUISound( alias )

		WaitSignal( handle, "OnSoundFinished" )
	}
}


void function CallToActionDialoguePopupThink( var popup, StoryEventDialogueData data )
{
	const float DIALOGUE_FADE_OUT_TIME = 1.0

	Signal( uiGlobal.signalDummy, "CallToActionPopupThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupThink" )

	table<string, bool> results = { hasSeen = false }

	OnThreadEnd(
		function() : ( popup, data, results )
		{
			if ( results.hasSeen && !file.dialogFlowDidCausePotentiallyInterruptingPopup )
			{
				int guid = data.dialogueGroupGuid
				int index = data.dialogueBlockIndex
				Remote_ServerCallFunction( "ClientCallback_MarkStoryEventDialoguePopupAsSeen", guid, index )
			}

			Hud_Hide( popup )
			Signal( uiGlobal.signalDummy, "CallToActionPopupAudioCancel" )
		}
	)

	Hud_Show( popup )

	float totalDuration = data.duration + DIALOGUE_FADE_OUT_TIME
	float startTime     = UITime()

	float timeToWaitForMarkedAsSeen = data.duration

	
	while ( true )
	{
		if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			break

		WaitFrame()

		float elapsedTime = UITime() - startTime

		if ( !results.hasSeen && elapsedTime >= timeToWaitForMarkedAsSeen )
			results.hasSeen = true

		if ( elapsedTime >= totalDuration )
			break
	}
}


void function DialogFlow_DidCausePotentiallyInterruptingPopup()
{
	file.dialogFlowDidCausePotentiallyInterruptingPopup = true
}


void function OnClickCallToActionPopup( var button )
{
	file.onCallToActionFunc()
}


void function Lobby_MovePopupMessage( int tabIndex, float additionalOffsetFrac = 0.0 )
{
	var button = Hud_GetChild( file.panel, "PopupMessage" )

	var lobbyTabs = Hud_GetChild( GetMenu( "LobbyMenu" ), "TabsCommon" )

	var tabButton = Hud_GetChild( lobbyTabs, "Tab0" )

	int offset = 0
	if ( tabIndex==0 )
	{
		offset += Hud_GetX( tabButton )
		offset += int( Hud_GetWidth( tabButton ) * additionalOffsetFrac )
	}
	else
	{
		for ( int i = 0; i < tabIndex; i++ )
		{
			var bt = Hud_GetChild( lobbyTabs, "Tab" + i )
			offset += Hud_GetWidth( bt )
			offset += Hud_GetX( bt )
			offset += int( Hud_GetWidth( tabButton ) * additionalOffsetFrac )
		}
	}

	Hud_SetX( button, offset )
}


void function OpenGameModeSelectDialog()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" ) )

	Remote_ServerCallFunction( "ClientCallback_ViewedModes" )
	file.newModesAcknowledged = true

	AdvanceMenu( GetMenu( "GamemodeSelectDialog" ) )
}

void function Lobby_ResetAreLobbyButtonsUpdating()
{
	file.areLobbyButtonsUpdating = false
}

void function StoryModeButton_OnGetFocus( var button )
{
	if( CanRunClientScript() )
		RunClientScript( "ToggleHighlightOnRadioPlayProp", true )
}

void function StoryModeButton_OnLoseFocus( var button )
{
	if( CanRunClientScript() )
		RunClientScript( "ToggleHighlightOnRadioPlayProp", false )
}

void function StoryModeButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	thread function() : ( button )
	{
		
	}()
}

void function UpdateButtonsPositions( int maxTeamSize )
{
	float scaleFrac = GetScreenScaleFrac()

	if ( maxTeamSize >= 4 )
	{
		

		Hud_SetX( file.selfButton, -125 * scaleFrac )

		Hud_SetX( file.friendButton0, -405 * scaleFrac )
		Hud_SetX( file.friendButton1, 210 * scaleFrac )
		Hud_SetX( file.friendButton2, 405 * scaleFrac )

		Hud_SetX( file.inviteFriendsButton0, -400 * scaleFrac )
		Hud_SetX( file.inviteFriendsButton1, 210 * scaleFrac )
		Hud_SetX( file.inviteFriendsButton2, 405 * scaleFrac )

		

		Hud_SetY( file.selfButton, -30 * scaleFrac )

		Hud_SetY( file.friendButton0, -120 * scaleFrac )
		Hud_SetY( file.friendButton1, -60 * scaleFrac )
		Hud_SetY( file.friendButton2, -120 * scaleFrac )

		Hud_SetY( file.inviteFriendsButton0, -90 * scaleFrac )
		Hud_SetY( file.inviteFriendsButton1, -90 * scaleFrac )
		Hud_SetY( file.inviteFriendsButton2, -90 * scaleFrac )

		
#if PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				Hud_SetX( file.friendButton0, -354 * scaleFrac )
				Hud_SetX( file.friendButton1, -346 * scaleFrac )
				Hud_SetX( file.friendButton2, 150 * scaleFrac )

				Hud_SetY( file.selfButton, -18 * scaleFrac )
				Hud_SetY( file.friendButton0, -70 * scaleFrac )
				Hud_SetY( file.friendButton1, -18 * scaleFrac )
				Hud_SetY( file.friendButton2, -70 * scaleFrac )
			}
#endif
	}
	else
	{
		

		Hud_SetX( file.selfButton, 0 * scaleFrac )

		Hud_SetX( file.friendButton0, -376 * scaleFrac )
		Hud_SetX( file.friendButton1, 376 * scaleFrac )

		Hud_SetX( file.inviteFriendsButton0, -374 * scaleFrac )
		Hud_SetX( file.inviteFriendsButton1, 374 * scaleFrac )

		

		Hud_SetY( file.selfButton, -30 * scaleFrac )

		Hud_SetY( file.friendButton0, -74 * scaleFrac )
		Hud_SetY( file.friendButton1, -74 * scaleFrac )

		Hud_SetY( file.inviteFriendsButton0, -90 * scaleFrac )
		Hud_SetY( file.inviteFriendsButton1, -90 * scaleFrac )

		
#if PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				Hud_SetX( file.friendButton0, -350 * scaleFrac )
				Hud_SetX( file.friendButton1, 350 * scaleFrac )

				Hud_SetY( file.selfButton, -18 * scaleFrac )
				Hud_SetY( file.friendButton0, -40 * scaleFrac )
				Hud_SetY( file.friendButton1, -40 * scaleFrac )
			}
#endif
	}
}