untyped

global const bool EDIT_LOADOUT_SELECTS = true
global const string PURCHASE_SUCCESS_SOUND = "UI_Menu_Store_Purchase_Success"
global const float LOADSCREEN_FINISHED_MAX_WAIT_TIME = 5.0

global function UICodeCallback_CloseAllMenus
global function UICodeCallback_ActivateMenus
global function UICodeCallback_LevelInit
global function UICodeCallback_LevelLoadingStarted
global function UICodeCallback_LevelLoadingFinished
global function UICodeCallback_LevelShutdown
global function UICodeCallback_FullyConnected
global function UICodeCallback_OnConnected
global function UICodeCallback_OnFocusChanged
global function Menus_SetNavigateBackDisabled
global function UICodeCallback_NavigateBack
global function UICodeCallback_ToggleInGameMenu
global function UICodeCallback_ToggleInventoryMenu
global function UICodeCallback_ToggleMap
global function UICodeCallback_TryCloseDialog
global function UICodeCallback_UpdateLoadingLevelName
global function UICodeCallback_ConsoleKeyboardClosed
global function UICodeCallback_ErrorDialog
global function UICodeCallback_AcceptInvite
global function UICodeCallback_OnDetenteDisplayed
global function UICodeCallback_OnSpLogDisplayed
global function UICodeCallback_KeyBindOverwritten
global function UICodeCallback_KeyBindSet
global function UICodeCallback_PartyUpdated
global function UICodeCallback_PartyMemberAdded
global function UICodeCallback_PartyMemberRemoved
global function UICodeCallback_CustomMatchLobbyJoin
global function UICodeCallback_CustomMatchDataChanged
global function UICodeCallback_CustomMatchStats
global function AddCallback_OnPartyUpdated
global function AddCallbackAndCallNow_OnPartyUpdated
global function RemoveCallback_OnPartyUpdated
global function AddCallback_OnPartyMemberAdded
global function RemoveCallback_OnPartyMemberAdded
global function AddCallback_OnPartyMemberRemoved
global function HasCallback_OnPartyMemberRemoved
global function RemoveCallback_OnPartyMemberRemoved
global function UICodeCallback_PartySpectateSlotUnavailableWaitlisted
global function AddCallback_PartySpectateSlotUnavailableWaitlisted
global function RemoveCallback_PartySpectateSlotUnavailableWaitlisted
global function UICodeCallback_PartySpectateSlotAvailable
global function AddCallback_PartySpectateSlotAvailable
global function RemoveCallback_PartySpectateSlotAvailable
global function AddCallback_OnTopLevelCustomizeContextChanged
global function RemoveCallback_OnTopLevelCustomizeContextChanged
global function AddUICallback_LevelLoadingFinished
global function AddUICallback_LevelShutdown
global function AddUICallback_OnResolutionChanged
global function UICodeCallback_UserInfoUpdated
global function UICodeCallback_UIScriptResetComplete
global function UICodeCallback_ReconnectFailed
global function UICodeCallback_LoadscreenFinished
global function UICodeCallback_MatchMakeExpired

global function UICodeCallback_ClubRequestFinished
global function UICodeCallback_ClubEventLogUpdate
global function UICodeCallback_ClubChatLogUpdate
global function UICodeCallback_ClubMembershipNotification
global function UICodeCallback_EadpSearchRequestFinished
global function UICodeCallback_EadpFriendsChanged
global function UICodeCallback_EadpClubMemberPresence
global function UICodeCallback_EadpInviteDataChanged
global function ShowPendingPurchaseDialog





global function UICodeCallback_IsInClubChat

global function TryRunDialogFlowThread
global function ShouldShowPremiumCurrencyDialog
global function ShowPremiumCurrencyDialog

global function AdvanceMenu
global function CloseActiveMenu
global function CloseActiveMenuNoParms
global function CloseAllMenus
global function CloseAllDialogs
global function CloseAllToTargetMenu
global function PrintMenuStack
global function OpenOverlay
global function CloseOverlay
global function GetActiveMenu
global function IsMenuVisible
global function IsPanelActive
global function GetActiveMenuName
global function GetMenu
global function GetPanel
global function GetAllMenuPanels
global function GetMenuTabBodyPanels
global function InitGamepadConfigs
global function InitMenus
global function AdvanceMenuEventHandler
global function PCSwitchTeamsButton_Activate
global function PCToggleSpectateButton_Activate
global function AddMenuElementsByClassname
global function SetPanelDefaultFocus
global function PanelFocusDefault
global function AddMenuEventHandler
global function AddPanelEventHandler
global function AddPanelEventHandler_FocusChanged
global function SetPanelInputHandler
global function AddButtonEventHandler
global function AddEventHandlerToButton
global function AddEventHandlerToButtonClass
global function RemoveEventHandlerFromButtonClass
global function GetTopNonDialogMenu
global function SetDialog
global function SetPopup
global function SetOverlay
global function SetClearBlur
global function SetFooterPanelVisibility
global function SetPanelClearBlur
global function ClearMenuBlur
global function UpdateMenuBlur
global function IsDialog
global function IsDialogOnlyActiveMenu
global function AddMenuThinkFunc
global function IsTopLevelCustomizeContextValid
global function GetTopLevelCustomizeContext
global function SetTopLevelCustomizeContext
global function SetGamepadCursorEnabled
global function IsGamepadCursorEnabled
global function SetLastMenuNavDirection
global function GetLastMenuNavDirection
global function IsCommsMenuOpen
global function SetModeSelectMenuOpen
global function IsModeSelectMenuOpen
global function SetShowingMap
global function IsShowingMap
global function SetIsSelfClosingMenu
global function IsSelfClosingMenu

global function ButtonClass_AddMenu

global function PCBackButton_Activate

global function RegisterMenuVarInt
global function GetMenuVarInt
global function SetMenuVarInt
global function RegisterMenuVarBool
global function GetMenuVarBool
global function SetMenuVarBool
global function RegisterMenuVarVar
global function GetMenuVarVar
global function SetMenuVarVar
global function AddMenuVarChangeHandler
global function EnterLobbySurveyReset

global function ClientToUI_SetCommsMenuOpen

global function InviteFriends
global function OpenInGameMenu

global function InitButtonRCP

global function AddCallbackAndCallNow_UserInfoUpdated
global function RemoveCallback_UserInfoUpdated

global function _IsMenuThinkActive
global function UpdateActiveMenuThink

global function DialogFlow
global function SetDialogFlowPersistenceTables
global function GetDialogFlowTablesValueOrPersistence
global function IsLoadScreenFinished

global function AttemptReconnect

global function IncrementNumDialogFlowDialogsDisplayed






#if DEV
global function OpenDevMenu
global function DEV_SetLoadScreenFinished
global function AutomateUi
global function AutomateUiWaitForPostmatch
global function AutomateUiRequeue
global function DEV_AdvanceToBattlePassMilestoneMenu
#endif

const string SOUND_MATCHMAKING_CANCELED = "ui_networks_invitation_canceled" 

struct
{
	array<void functionref()>                   partyUpdatedCallbacks
	array<void functionref()>                   partymemberAddedCallbacks
	array<void functionref()>                   partymemberRemovedCallbacks
	array<void functionref()>					partySpectateSlotUnavailableWaitlistedCallbacks
	array<void functionref()>					partySpectateSlotAvailableCallbacks
	table<var, array<void functionref( var )> > topLevelCustomizeContextChangedCallbacks
	array<void functionref()>                   levelLoadingFinishedCallbacks
	array<void functionref()>                   levelShutdownCallbacks

	array<void functionref( string, string )>   userInfoChangedCallbacks 

	int numDialogFlowDialogsDisplayed = 0

	bool menuThinkThreadActive = false

	bool TEMP_circularReferenceCleanupEnabled = true

	bool loadScreenFinished = false

	float reconnectStartTime

	table<string, var> dialogFlowPersistenceChecksValuesTable
	table<string, float> dialogFlowPersistenceChecksTimeTable

	bool dialogFlowComplete = false

	int partyMemberCount

	bool rankedSplitChangeAudioPlayed = false

	ItemFlavor ornull topLevelCustomizeContext

	bool lastMenuNavDirection = MENU_NAV_FORWARD

	bool commsMenuOpen = false
	bool isShowingMap = false 
	bool modeSelectMenuOpen = false
	var activeMenu = null
	var activeOverlay = null

#if DEV
	float uiAutomationLastTime = 0
	float uiAutomationExpiredTime = 0
	var uiAutomationCurrentMenu = null
	var uiAutomationTopActivePanel = null
	var uiAutomationCount = 0
#endif

	bool hasInitializedOnce = false
	bool currencyDialogShowed = false





	bool navigateBackDisabled = false

#if DEV
		int cachedFakeTime = -1
#endif
} file


void function UICodeCallback_CloseAllMenus()
{
	printt( "UICodeCallback_CloseAllMenus" )
	CloseAllMenus()
	
}


void function UICodeCallback_ActivateMenus()
{
	if ( IsConnected() )
		return

	var mainMenu = GetMenu( "MainMenu" )

	printt( "UICodeCallback_ActivateMenus:", GetActiveMenu() && Hud_GetHudName( GetActiveMenu() ) != "" )
	if ( MenuStack_GetLength() == 0 )
		AdvanceMenu( mainMenu )

	if ( GetActiveMenu() == mainMenu )
		Signal( uiGlobal.signalDummy, "OpenErrorDialog" )

	UIMusicUpdate()




}


void function UICodeCallback_ToggleInGameMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby )
	{
		if ( activeMenu == null )
		{
			if ( CustomMatch_IsInCustomMatch() )
			{
				AdvanceMenu( GetMenu( "CustomMatchLobbyMenu" ) )
				CustomMatch_RefreshLobby()
			}
			else
			{
				AdvanceMenu( GetMenu( "LobbyMenu" ) )
			}
		}
		else if ( activeMenu == GetMenu( "SystemMenu" ) )
		{
			CloseActiveMenu()
		}
		return
	}

	var ingameMenu = GetMenu( "SystemMenu" )

	
	if ( MenuStack_Contains( GetMenu( "CharacterSelectMenu" ) )



			|| MenuStack_Contains( GetMenu( "ScoreboardTransition" ) )
			|| MenuStack_Contains( GetMenu( "PrivateMatchSpectCharSelectMenu" ) ))
		return

	if ( IsDialog( activeMenu ) )
	{
		
	}
	else if ( IsSurvivalMenuEnabled() )
	{
		if ( activeMenu == null || SURVIVAL_IsAnInventoryMenuOpened() )
		{
			thread ToggleInventoryOrOpenOptions()
		}
		else if ( InputIsButtonDown( KEY_ESCAPE ) && uiGlobal.menuData[ file.activeMenu ].navBackFunc != null )
		{
			uiGlobal.menuData[ file.activeMenu ].navBackFunc()
		}
		else if ( DeathScreenIsOpen() )    
		{
			thread OpenOptionsOnHold()
		}
		else
		{

				if ( GameMode_IsActive( eGameModes.CONTROL ) )
				{
					if ( UI_IsSpawnMapOpen() || LoadoutSelectionMenu_IsLoadoutMenuOpen() )
						return
				}









			CloseActiveMenu()
		}
	}
	else if ( !isLobby )
	{
		if ( activeMenu == null )
			AdvanceMenu( ingameMenu )
		else
			CloseAllMenus()
	}
}


void function ToggleInventoryOrOpenOptions()
{
	if( !IsConnected() )
		 return

	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration

	bool doesPCUseHoldandIsDown = false

		doesPCUseHoldandIsDown = GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE )

	while ( ( InputIsButtonDown( BUTTON_START ) || ( InputIsButtonDown( KEY_ESCAPE ) && doesPCUseHoldandIsDown ) ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( InputIsButtonDown( KEY_ESCAPE ) && IsCommsMenuOpen() )
	{
		RunClientScript( "CommsMenu_HandleKeyInput", KEY_ESCAPE ) 
		return
	}


	if( UpgradeSelectionMenu_IsActive() && InputIsButtonDown( KEY_ESCAPE ) )
	{
		RunClientScript( "UpgradeSelectionMenu_HandleKeyInput", KEY_ESCAPE ) 
		return
	}


	if ( (UITime() >= endTIme && InputIsButtonDown( BUTTON_START )) || (InputIsButtonDown( KEY_ESCAPE ) && !SURVIVAL_IsAnInventoryMenuOpened()) )
	{
		if ( IsShowingMap() && InputIsButtonDown( KEY_ESCAPE ) )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
			return
		}


			if ( GameMode_IsActive( eGameModes.CONTROL ) )
			{
				if ( UI_IsSpawnMapOpen() || LoadoutSelectionMenu_IsLoadoutMenuOpen() )
					return
			}


		if( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) && !IsControllerModeActive() && !InputIsButtonDown( KEY_TAB ) )
		{
			RunClientScript( "UICallback_OpenCharacterSelectMenu" )
			return
		}




















		OpenSystemMenu()
	}
	else
	{
		if ( IsFullyConnected() )
		{
			if ( IsShowingMap() )
				RunClientScript( "ClientToUI_HideScoreboard" )


				
				if ( IsPrivateMatchGameStatusMenuOpen() )
					ClosePrivateMatchGameStatusMenu( null )

				if ( !IsPrivateMatchGameStatusMenuOpen() && IsPrivateMatch() )
				{
					RunClientScript( "PrivateMatch_OpenGameStatusMenu" )
					
				}

















			if ( SURVIVAL_IsAnInventoryMenuOpened() )
			{
				if ( uiGlobal.menuData[ file.activeMenu ].navBackFunc != null )
				{
					uiGlobal.menuData[ file.activeMenu ].navBackFunc()
				}
				else
				{
					CloseActiveMenu()
				}
			}
			else
			{
				if( IsControllerModeActive() )
					RunClientScript( "OpenSurvivalMenu" )
				else
					OpenSystemMenu()
			}
		}
	}
}


void function OpenOptionsOnHold()
{
	

	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( InputIsButtonDown( BUTTON_START ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	
	if ( InputIsButtonDown( KEY_ESCAPE ) && IsCommsMenuOpen() )
	{
		RunClientScript( "CommsMenu_HandleKeyInput", KEY_ESCAPE ) 
		return
	}

	if ( UITime() >= endTIme && InputIsButtonDown( BUTTON_START ) ) 
	{
		if ( IsShowingMap() && InputIsButtonDown( KEY_ESCAPE ) )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
			return
		}



















		OpenSystemMenu()
	}
}


void function UICodeCallback_ToggleInventoryMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby || IsDialog( activeMenu ) )
		return


	thread ToggleInventoryOrOpenOtherSettings()










}



void function ToggleInventoryOrOpenOtherSettings()
{
	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration




	if ( !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )

	{
			if ( !GetActiveMenu() )
			{
				RunClientScript( "PROTO_OpenInventoryOrSpecifiedMenu", GetLocalClientPlayer() )
			}
			else
			{
				CloseAllMenus()
			}
		return
	}

	int pcKeycode = GetKeyCodeForBinding( "toggle_inventory", 0 ) - 1
	bool pcKeyIsValid = ( pcKeycode > -1 )

	if ( pcKeyIsValid && !InputIsButtonDown( pcKeycode ) )
	{
		int alternatePCKeycode = GetSecondKeyCodeForBinding( "toggle_inventory", 0 ) - 1
		if ( alternatePCKeycode > 1 )
		{
			pcKeycode = alternatePCKeycode
		}
	}

	while ( (pcKeyIsValid && InputIsButtonDown( pcKeycode )) && UITime() < endTIme )
	{
		WaitFrame()
	}

	var activeMenu = GetActiveMenu()
	if ( activeMenu != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( UITime() >= endTIme && pcKeyIsValid && InputIsButtonDown( pcKeycode ) )
	{







		{
			RangeCustomizationMenu()
		}
	}
	else
	{
		if ( activeMenu == null )
		{
			RunClientScript( "PROTO_OpenInventoryOrSpecifiedMenu", GetLocalClientPlayer() )
		}
		else
		{
			CloseAllMenus()
		}
	}
}



void function UICodeCallback_ToggleMap()
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return













		thread ToggleMapOrOpenRangeSettings()




}


void function ToggleMapOrOpenRangeSettings()
{
	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration

	if ( !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
	{
		RunClientScript( "ClientToUI_ToggleScoreboard" )
		return
	}

	int pcKeycode = GetKeyCodeForBinding( "toggle_map", 0 ) - 1
	bool pcKeyIsValid = ( pcKeycode > -1 )

	if ( pcKeyIsValid && !InputIsButtonDown( pcKeycode ) )
	{
		int alternatePCKeycode = GetSecondKeyCodeForBinding( "toggle_map", 0 ) - 1
		if ( alternatePCKeycode > 1 )
		{
			pcKeycode = alternatePCKeycode
		}
	}

	while ( ( InputIsButtonDown( BUTTON_BACK ) || (pcKeyIsValid && InputIsButtonDown( pcKeycode ) ) ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( UITime() >= endTIme && ( InputIsButtonDown( BUTTON_BACK ) || (pcKeyIsValid && InputIsButtonDown( pcKeycode ) ) ) )
	{
		if ( IsShowingMap() )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
		}

		RangeCustomizationMenu()
	}
	else
	{
		if ( IsFullyConnected() )
		{
			RunClientScript( "ClientToUI_ToggleScoreboard" )
		}
	}
}


void function OpenInGameMenu( var button )
{
	var ingameMenu = GetMenu( "SystemMenu" )

	AdvanceMenu( ingameMenu )
}



bool function UICodeCallback_LevelLoadingStarted( string levelname )
{
	printt( "UICodeCallback_LevelLoadingStarted: " + levelname )

	CloseAllMenus()

	Signal( uiGlobal.signalDummy, "EndFooterUpdateFuncs" )
	Signal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )
	Signal( uiGlobal.signalDummy, "EndSetMainProfileForCrossProgressionTimeout" )
	Signal( uiGlobal.signalDummy, "EndMigrateFlow" )

	uiGlobal.loadingLevel = levelname

	if ( IsPlayVideoMenuPlayingVideo() )
		Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

	
	Signal( uiGlobal.signalDummy, "PGDisplay" )

	return true
}


bool function UICodeCallback_UpdateLoadingLevelName( string levelname )
{
	printt( "UICodeCallback_UpdateLoadingLevelName: " + levelname )

	return true
}


void function UICodeCallback_LevelLoadingFinished( bool error )
{
	uiGlobal.isLevelShuttingDown = false

	printt( "UICodeCallback_LevelLoadingFinished: " + uiGlobal.loadingLevel + " (" + error + ")" )

	UIMusicUpdate()

	if ( !IsLobby() )
		HudChat_ClearTextFromAllChatPanels()

	uiGlobal.loadingLevel = ""
	Signal( uiGlobal.signalDummy, "LevelFinishedLoading" )

	foreach ( callback in file.levelLoadingFinishedCallbacks )
		callback()

	TEMP_CircularReferenceCleanup()
}


void function UICodeCallback_LevelInit( string levelname )
{
	printt( "UICodeCallback_LevelInit: " + levelname + ", IsConnected(): ", IsConnected() )
	file.loadScreenFinished = false 
}

void function UIFullyConnectedInitialization_ForLevel( string levelname )
{
	bool isLobby = IsLobbyMapName( levelname )

	string gameModeString = GetConVarString( "mp_gamemode" )
	if ( gameModeString == "" )
		gameModeString = "<null>"

	Assert( gameModeString == GetConVarString( "mp_gamemode" ) )
	Assert( gameModeString != "" )

	int gameModeId        = GameMode_FindByDevName( gameModeString )
	int mapId             = -1
	int difficultyLevelId = 0
	int roundId           = 0
	if ( isLobby )
	{
		file.dialogFlowPersistenceChecksValuesTable.clear()
		file.dialogFlowPersistenceChecksTimeTable.clear()
		Durango_OnLobbySessionStart( gameModeId, difficultyLevelId )
	}
	else
	{
		Durango_OnMultiplayerRoundStart( gameModeId, mapId, difficultyLevelId, roundId, 0 )
	}

	foreach ( callbackFunc in uiGlobal.onLevelInitCallbacks )
	{
		callbackFunc()
	}
	thread UpdateMenusOnConnectThread( levelname )

	SetShowingMap( false )

	if ( !IsLobby() )
		ClearMatchPINData()

	file.TEMP_circularReferenceCleanupEnabled = GetCurrentPlaylistVarBool( "circular_reference_cleanup_enabled", true )
}

void function UIFullyConnectedInitialization()
{
#if DEV
		ShDevUtility_Init()
#endif



	ShEHI_LevelInit_Begin()
	ShPakRequests_LevelInit()
	ShPersistentData_LevelInit_Begin()
	ShItems_LevelInit_Begin()
	ShGRX_LevelInit()

		Perks_Init()
		Perk_BeaconScan_Init()
		Perk_BannerCrafting_Init()
		Perk_CarePackageInsight_Init()
		Perk_ExtraFirepower_Init()
		Perk_KillBoostUlt_Init()
		Perk_SupportLootbin_Init()
		Perk_MunitionsBox_Init()











	Perk_QuickPackup_Init()
	Perk_RingExpert_Init()
	Perk_ScoutExpert_Init()







	StorePanelHeirloomShopEvent_LevelInit()
	Entitlements_LevelInit()
	CustomizeCommon_Init()
	ShLoadouts_LevelInit_Begin()
	DeathBoxListPanel_VMInit()
	SurvivalGroundList_LevelInit()
	ShCharacters_LevelInit()
	ShSkydiveTrails_LevelInit()
	ShPassives_Init()
	ShCharacterAbilities_LevelInit()
	ShCharacterCosmetics_LevelInit()
	ShCalEvent_LevelInit()
	Vouchers_LevelInit()
	TimeGatedLoginRewards_Init()
	CollectionEvents_Init()
	ThemedShopEvents_Init()

		MilestoneEvents_Init()

	BuffetEvents_Init()
	RewardCampaign_Init()

	EventShop_Init()

	StoryChallengeEvents_Init()
	Sh_Ranked_ItemRegistrationInit()
	Sh_Ranked_Init()
	CLUI_Ranked_Init()


		Sh_ArenasRanked_ItemRegistrationInit()



		Sh_ArenasRanked_Init()






	ShWeapons_LevelInit()
	ShWeaponCosmetics_LevelInit()
	ShGladiatorCards_LevelInit()
	ShQuips_LevelInit()
	ShSkydiveEmotes_LevelInit()
	ShStickers_LevelInit()
	ShMythics_LevelInit()
	ShLoadscreen_LevelInit()
	ShImage2D_LevelInit()
	ShBattlepassPresaleVoucher_LevelInit()
	ShBattlepassPurchasableXP_LevelInit()



	Sh_Boosts_Init()
	ShMusic_LevelInit()
	ShBattlePass_LevelInit()

	ShNPP_LevelInit()


	ShCups_LevelInit()


	ShRankedRumble_Init()




	LobbyPlaylist_Init()
	PlayPanel_LevelInit()
	TreasureBox_SharedInit()
	SeasonQuest_SharedInit()
	MenuCamera_Init()
	MenuScene_Init()
	MeleeShared_Init()
	MeleeSyncedShared_Init()
	ShArtifacts_LevelInit()

	ShUniversalMelees_LevelInit()

	ShPing_Init()
	ShQuickchat_Init()
	ShChallenges_LevelInit_PreStats()
	Sh_Challenge_Sets_Init()

	Sh_Challenge_Tiles_Init()
	Sh_Narrative_Season_Init()

	AutogenStats_Init()
	Sh_Kepler_Init()

	ShRewardSetTracker_LevelInit()

	ShItems_LevelInit_Finish()
	ShItemPerPlayerState_LevelInit()
	UserInfoPanels_LevelInit()
	ShLoadouts_LevelInit_Finish()
	UiNewnessQueries_LevelInit()
	ShStatsInternals_LevelInit()
	ShStats_LevelInit()
	Sh_RankedTrials_Init() 
	ShChallenges_LevelInit_PostStats()

		ShCups_LevelInit_PostStats()

	ShPlaylist_Init()

	ShPersistentData_LevelInit_Finish()
	ShPassPanel_LevelInit()
	ShEHI_LevelInit_End()

	SURVIVAL_Loot_All_InitShared()

#if DEV
		UpdatePrecachedSPWeapons()
#endif






		PrivateMatch_Init()








	LoadoutSelection_Init()


		Gifting_LevelInit()


	Sh_Mastery_Init()
}

void function UICodeCallback_FullyConnected( string levelname )
{
	Assert( IsConnected() )

	StopVideos( eVideoPanelContext.ALL )

	uiGlobal.loadedLevel = levelname

	printt( "UICodeCallback_FullyConnected: " + uiGlobal.loadedLevel + ", IsFullyConnected(): ", IsFullyConnected() )

	InitXPData() 

	
	bool shouldFullyInitialize = !file.hasInitializedOnce || IsLobby() || IsPrivateMatch()
	if ( shouldFullyInitialize )
	{
		UIFullyConnectedInitialization()
		ForceRefreshVisiblePlaylists()
		file.hasInitializedOnce = true
	}
	else
	{
		printt( "UICodeCallback_FullyConnected: Performing partial initialization" )
	}

#if DEV
		if ( GetCurrentPlaylistVarBool( "dev_assert_on_fake_time_mismatch", true ) )
		{
			int fakeTimeDays     = GetConVarInt( "test_fakeTimeDays" )
			int fakeTimeStamp    = GetConVarInt( "test_fakeTimeStamp" )
			bool useFakeTimeDays = (fakeTimeDays != 0)
			if ( shouldFullyInitialize )
			{
				file.cachedFakeTime = useFakeTimeDays ? fakeTimeDays : fakeTimeStamp
			}
			else
			{
				int fakeTimeToCheckAgainst = useFakeTimeDays ? fakeTimeDays : fakeTimeStamp
				Assert( file.cachedFakeTime == fakeTimeToCheckAgainst )
			}
		}
#endif

	UIFullyConnectedInitialization_ForLevel( levelname )
}


void function UICodeCallback_LevelShutdown()
{
	uiGlobal.isLevelShuttingDown = true

	ShutdownAllPanels()
	CloseAllMenus()

	ShGladiatorCards_LevelShutdown()
	ShLoadouts_LevelShutdown()
	VideoChannelManager_OnLevelShutdown()
	ImagePakLoad_OnLevelShutdown()
	ShGRX_LevelShutdown()
	Kepler_LevelShutdown()
	StorePanelHeirloomShopEvent_LevelShutdown()
	PlayPanel_LevelShutdown()
	OffersPanel_LevelShutdown()
	Gifting_LevelShutdown()
	LeaveMatch_ResetInitiated()

	Signal( uiGlobal.signalDummy, "LevelShutdown" )

	printt( "UICodeCallback_LevelShutdown: " + uiGlobal.loadedLevel )

	StopVideos( eVideoPanelContext.ALL )

	if ( uiGlobal.loadedLevel != "" )
		Signal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	uiGlobal.loadedLevel = ""

	foreach ( callbackFunc in file.levelShutdownCallbacks )
	{
		callbackFunc()
	}

	UiNewnessQueries_LevelShutdown()

	TEMP_CircularReferenceCleanup()
}


void function Menus_SetNavigateBackDisabled( bool disabled )
{
	file.navigateBackDisabled = disabled
}

void function UICodeCallback_NavigateBack()
{
	if ( file.navigateBackDisabled )
		return

	var activeMenu = GetActiveMenu()
	if ( activeMenu == null )
		return

	if ( IsDialog( activeMenu ) )
	{
		if ( uiGlobal.menuData[ activeMenu ].dialogData.noChoice ||
		uiGlobal.menuData[ activeMenu ].dialogData.forceChoice ||
		UITime() < uiGlobal.dialogInputEnableTime )
			return
	}

	Assert( activeMenu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ activeMenu ].navBackFunc != null )
	{
		if ( IsPanelTabbed( activeMenu ) )
			_OnTab_NavigateBack( null )

		uiGlobal.menuData[ activeMenu ].navBackFunc()
		return
	}

	CloseActiveMenu()
}


void function UICodeCallback_OnConnected()
{
	
}


void function UICodeCallback_OnFocusChanged( var oldFocus, var newFocus )
{
	foreach ( panel in uiGlobal.activePanels )
	{
		foreach ( focusChangedFunc in uiGlobal.panelData[ panel ].focusChangedFuncs )
			focusChangedFunc( panel, oldFocus, newFocus )
	}
}


bool function UICodeCallback_TryCloseDialog()
{
	var activeMenu = GetActiveMenu()

	if ( !IsDialog( activeMenu ) )
		return true

	if ( uiGlobal.menuData[ activeMenu ].dialogData.forceChoice )
		return false

	CloseAllDialogs()
	Assert( !IsDialog( GetActiveMenu() ) )
	return true
}


void function UICodeCallback_ConsoleKeyboardClosed()
{
	switch ( GetActiveMenu() )
	{
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		default:
			break
	}
}


void function UICodeCallback_OnDetenteDisplayed()
{
	
	
	
	
	
	
	
	
}


void function UICodeCallback_OnSpLogDisplayed()
{
}


void function UICodeCallback_ErrorDialog( string errorDetails )
{
	printt( "UICodeCallback_ErrorDialog: " + errorDetails )
	thread OpenErrorDialogThread( errorDetails )
}


void function UICodeCallback_AcceptInviteThread( string accesstoken, string from, string from_hardware )
{
	printt( "UICodeCallback_AcceptInviteThread '" + accesstoken + "' from '" + from + "' " + from_hardware )











































	SubscribeToChatroomPartyChannel( accesstoken, from, from_hardware )
}


void function UICodeCallback_AcceptInvite( string accesstoken, string fromxid, string from_hardware )
{
	printt( "UICodeCallback_AcceptInvite '" + accesstoken + "' from '" + fromxid + "' " + from_hardware )
	thread    UICodeCallback_AcceptInviteThread( accesstoken, fromxid, from_hardware )
}














bool function UICodeCallback_IsInClubChat()
{



		return false

}

void function AdvanceMenu( var newMenu )
{
	
	
	
	
	
	

	
	if ( IsOverlay( newMenu ) )
		return

	var currentMenu = GetActiveMenu()

	if ( currentMenu )
	{
		
		if ( currentMenu == newMenu )
			return

		
		
		if ( !newMenu == GetMenu( "GiftInfoDialog" ) )
			Assert( !IsDialog( currentMenu ) || IsPopup( newMenu ), "Tried opening menu: " + Hud_GetHudName( newMenu ) + " when activeMenu was: " + Hud_GetHudName( currentMenu ) )
	}

	if ( currentMenu && !IsDialog( newMenu ) ) 
	{
		CloseMenu( currentMenu )
		ClearMenuBlur( currentMenu )

		if ( uiGlobal.menuData[ currentMenu ].loseTopLevelFunc != null )
			uiGlobal.menuData[ currentMenu ].loseTopLevelFunc()

		if ( uiGlobal.menuData[ currentMenu ].hideFunc != null )
			uiGlobal.menuData[ currentMenu ].hideFunc()

		foreach ( var panel in GetAllMenuPanels( currentMenu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	if ( IsDialog( newMenu ) && currentMenu )
	{
		SetFooterPanelVisibility( currentMenu, false )
		if ( ShouldClearBlur( newMenu ) )
			ClearMenuBlur( currentMenu )

		if ( uiGlobal.menuData[ currentMenu ].loseTopLevelFunc != null )
			uiGlobal.menuData[ currentMenu ].loseTopLevelFunc()
	}

	if ( file.activeMenu != null )
	{
		SetLastMenuIDForPIN( Hud_GetHudName( file.activeMenu ) )
	}
	MenuStack_Push( newMenu )
	file.activeMenu = newMenu

	SetLastMenuNavDirection( MENU_NAV_FORWARD )

	if ( file.activeMenu )
	{
		UpdateMenuBlur( file.activeMenu )
		OpenMenuWrapper( file.activeMenu, true )
	}

	Lobby_AdjustBlackBarsFrameToMaxSize( newMenu )

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function UpdateMenuBlur( var menu )
{
	if ( !Hud_HasChild( menu, "ScreenBlur" ) || menu != GetActiveMenu() )
	{
		Hud_SetAboveBlur( menu, false )
		return
	}

	bool enableBlur = IsConnected()

	if ( _HasActiveTabPanel( menu ) )
	{
		var panel = _GetActiveTabPanel( menu )
		if ( panel != null && uiGlobal.panelData[ panel ].panelClearBlur )
			enableBlur = false
	}

	if ( Hud_HasChild( menu, "ScreenBlur" ) )
	{
		Hud_SetVisible( Hud_GetChild( menu, "ScreenBlur" ), enableBlur )
		Hud_SetAboveBlur( menu, enableBlur )
	}

	
	if ( Hud_HasChild( menu, "DarkenBackground" ) )
		Hud_SetVisible( Hud_GetChild( menu, "DarkenBackground" ), enableBlur )
}


void function ClearMenuBlur( var menu )
{
	Hud_SetAboveBlur( menu, false )
}


void function SetFooterPanelVisibility( var menu, bool visible )
{
	if ( !Hud_HasChild( menu, "FooterButtons" ) )
		return

	var panel = Hud_GetChild( menu, "FooterButtons" )
	Hud_SetVisible( panel, visible )
}


void function CloseActiveMenuNoParms()
{
	CloseActiveMenu()
}


void function CloseActiveMenu( bool openStackMenu = true )
{
	bool wasDialog = false

	var currentActiveMenu = file.activeMenu
	var nextActiveMenu

	MenuStack_Pop()
	if ( MenuStack_GetLength() != 0 )
		nextActiveMenu = MenuStack_Top()
	else
		nextActiveMenu = null

	file.activeMenu = nextActiveMenu 

	if ( currentActiveMenu )
	{
		if ( IsDialog( currentActiveMenu ) )
		{
			wasDialog = true
			uiGlobal.dialogInputEnableTime = 0.0
		}

		CloseMenuWrapper( currentActiveMenu )
	}

	if( uiGlobal.isLevelShuttingDown )
		return

	SetLastMenuNavDirection( MENU_NAV_BACK )

	if ( wasDialog )
	{
		if ( nextActiveMenu )
		{
			SetFooterPanelVisibility( nextActiveMenu, true )
			UpdateFooterOptions()
			UpdateMenuTabs()
		}

		if ( IsDialog( nextActiveMenu ) )
			openStackMenu = true
		else
			openStackMenu = false
	}

	if ( nextActiveMenu )
	{
		UpdateMenuBlur( nextActiveMenu )

		if ( openStackMenu )
		{
			OpenMenuWrapper( nextActiveMenu, false )
		}
		else
		{
			if ( uiGlobal.menuData[ nextActiveMenu ].getTopLevelFunc != null )
				uiGlobal.menuData[ nextActiveMenu ].getTopLevelFunc()
		}
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function CloseAllMenus()
{
	while ( GetActiveMenu() )
		CloseActiveMenu( false )
}


void function CloseAllDialogs()
{
	while ( IsDialog( GetActiveMenu() ) || IsPopup( GetActiveMenu() ) )
		CloseActiveMenu()
}


void function CloseAllToTargetMenu( var targetMenu )
{
	while ( GetActiveMenu() != targetMenu && GetActiveMenu() != null )
		CloseActiveMenu( false )
}


void function PrintMenuStack()
{
	array<var> menuStack = MenuStack_GetCopy()
	menuStack.reverse()

	printt( "MENU STACK:" )

	foreach ( menu in menuStack )
	{
		if ( menu )
			printt( "   ", Hud_GetHudName( menu ) )
		else
			printt( "    null" )
	}
}


void function UpdateMenusOnConnectThread( string levelname )
{
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" ) 

	CloseAllMenus()
	Assert( GetActiveMenu() != null || MenuStack_GetLength() == 0 )

	bool isLobby        = IsLobbyMapName( levelname )
	bool isPrivateMatch = IsPrivateMatch()

	
	string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()

	if ( selectedPlaylist == PLAYLIST_TRAINING || selectedPlaylist == PLAYLIST_NEW_PLAYER_ORIENTATION )



		LobbyPlaylist_ClearSelectedPlaylist()


	if ( isLobby && FTUEFlow_IsInFTUEFlow( GetLocalClientPlayer() ) )
	{
		
		LobbyPlaylist_ClearSelectedPlaylist()
		LobbyPlaylist_ClearSelectedUISlot()
	}


	if ( isLobby )
	{
		if ( CustomMatch_IsInCustomMatch() )
		{
			AdvanceMenu( GetMenu( "CustomMatchLobbyMenu" ) )
			CustomMatch_JoinLobby( GetConVarString( "match_roleToken" ) )
		}
		else
		{

			thread RTKStatsScreen_PreCacheData_Thread()

			AdvanceMenu( GetMenu( "LobbyMenu" ) )
		}
		UIMusicUpdate()

		if ( IsFullyConnected() )
		{
			if ( GetCurrentPlaylistVarBool( "force_level_loadscreen", false ) )
			{
				SetCustomLoadScreen( $"" )
			}
			else
			{
				thread Loadscreen_SetEquppedLoadscreenAsActive()
			}
		}

		
		

		
		ShouldReconnect()
		thread ShowGameSummaryIfNeeded()
	}
}


bool function ShouldReconnect()
{
	string reconnectParams = expect string( GetPersistentVar( "reconnectParams" ) )

	if ( reconnectParams != "" && !GetCurrentPlaylistVarBool( "reconnectCheckStatus_disabled", false ) )
	{
		
		printt( "ShouldReconnect ReconnectCheckStatus because " + reconnectParams )
		Remote_ServerCallFunction( "ClientCallback_ReconnectCheckStatus" ) 
		return false
	}

	printt( "ShouldReconnect NO because " + reconnectParams )
	return false
}


void function AttemptReconnect()
{
	string reconnectParams = expect string( GetPersistentVar( "reconnectParams" ) )
	ClientCommand( "reconnect " + reconnectParams )
}


void function ReconnectDialogYes()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#RECONNECT_TO_GAME"
	dialogData.messageText = ""
	dialogData.okText = ["", ""]
	OpenOKDialogFromData( dialogData )
}


void function UICodeCallback_ReconnectFailed( string reason )
{
	printt( "ReconnectFailed " + reason )
	Signal( uiGlobal.signalDummy, "ReconnectFailed" )

	if ( reason == "cancelled" )
		return 

	Remote_ServerCallFunction( "ClientCallback_ResetReconnectParams" )
	CloseAllDialogs()

	thread ShowGameSummaryIfNeeded()
}


void function UICodeCallback_LoadscreenFinished()
{
	printt( "UICodeCallback_LoadscreenFinished" )
	file.loadScreenFinished = true
}























void function UICodeCallback_MatchMakeExpired()
{
	printt( "UICodeCallback_MatchMakeExpired" )
	EmitUISound( SOUND_MATCHMAKING_CANCELED )
}


void function UICodeCallback_EadpSearchRequestFinished( int error, string reason, array<EadpQuerryPlayerData> results )
{
	printt( "UICodeCallback_EadpSearchRequestFinished", error, reason, results.len() )
	for ( int i = 0; i < results.len(); i++ )
		printt( results[i].eaid, " ", results[i].name, " ", results[i].hardware, " ", GetNameFromHardware( results[i].hardware ) )

	FindFriendDialog_OnSearchResult( error, reason, results )



}

void function UICodeCallback_EadpInviteDataChanged()
{
	printt( "UICodeCallback_EadpInviteDataChanged" )

	
	SocialEventUpdate()
}

void function UICodeCallback_EadpFriendsChanged()
{
	ForceSocialMenuUpdate()
}

void function UICodeCallback_EadpClubMemberPresence( EadpPresenceData presence )
{








}

void function UICodeCallback_ClubRequestFinished( int operation, int errorCode, string errorMsg )
{






































































































































































}


void function UICodeCallback_ClubEventLogUpdate( int eventLogIndex )
{








































}

void function UICodeCallback_ClubChatLogUpdate( int chatLogIndex )
{





}


void function UICodeCallback_ClubMembershipNotification( int notification, string clubID, string clubName, string userName )
{


























}


void function ShowGameSummaryIfNeeded()
{
	Signal( uiGlobal.signalDummy, "EndShowGameSummaryIfNeeded" )
	EndSignal( uiGlobal.signalDummy, "EndShowGameSummaryIfNeeded" )



	bool weaponTrialsBecameUnlockedOrCompleted = Mastery_WeaponTrialsBecameUnlockedOrCompleted()
	if ( weaponTrialsBecameUnlockedOrCompleted )
	{
		while ( !Mastery_IsLocalPlayerInfoReady() )
			WaitFrame()
	}


	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) && IsPlayPanelCurrentlyTopLevel() )
	{
#if DEV
			printt( "Postgame menu debug: Calling OpenPostGameMenu()" )
#endif
		OpenPostGameMenu( null )

		if ( GetActiveBattlePass() != null )
		{
#if DEV
				printt( "Postgame menu debug: Calling OpenPostGameBattlePassMenu( true )" )
#endif
			OpenPostGameBattlePassMenu( true )
		}


		if ( weaponTrialsBecameUnlockedOrCompleted )
		{
#if DEV
				printt( "Postgame menu debug: Calling OpenPostGameWeaponTrialCelebrationsMenu()" )
#endif
			OpenPostGameWeaponTrialCelebrationsMenu()
		}


		bool showRankedSummary = Ranked_ShowRankedSummary()
		bool showCupSummary = Cups_ShowCupSummary()
		if ( showRankedSummary && !showCupSummary )
		{
#if DEV
				printt( "Postgame menu debug: Calling OpenRankedSummary( true )" )
#endif
			OpenRankedSummary( true )
		}

		if ( showCupSummary && Cups_IsCupForLatestMatchActive( GetLocalClientPlayer() ) )
		{
#if DEV
				printt( "Postgame menu debug: Calling OpenCupsSummary()" )
#endif
			OpenCupsSummary()
		}

		
		
		
		
		
		
	}
	else
	{
		DialogFlow()
	}
}


bool function IsLoadScreenFinished()
{
	return file.loadScreenFinished
}

#if DEV
void function DEV_AdvanceToBattlePassMilestoneMenu()
{

	if ( IsLobby() && IsBattlePassEnabled() )
	{
		AdvanceMenu( GetMenu( "BattlePassMilestoneMenu" ) )
	}

}
#endif

#if DEV
void function DEV_SetLoadScreenFinished()
{
	file.loadScreenFinished = true
}
#endif


bool function AreDialogFlowPersistenceValuesSet( string persistenceVar, var value = true, float timeBeforeNextCheckAllowed = 9999  )
{
	if ( !(persistenceVar in file.dialogFlowPersistenceChecksValuesTable ) )
		return false

	if ( file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ] != value )
		return false

	Assert( persistenceVar in file.dialogFlowPersistenceChecksTimeTable )

	if ( file.dialogFlowPersistenceChecksTimeTable[ persistenceVar] + timeBeforeNextCheckAllowed < UITime() )
		return false

	return true
}



var function GetDialogFlowTablesValueOrPersistence( string persistenceVar, bool useScriptTable = false, float timeBeforeDialogFlowTableValuesAreOutdated = 5.0 )
{
	if ( useScriptTable )
	{
		timeBeforeDialogFlowTableValuesAreOutdated = 9999
	}

	if ( (persistenceVar in file.dialogFlowPersistenceChecksValuesTable ) )
	{
		Assert( persistenceVar in file.dialogFlowPersistenceChecksTimeTable )

		if ( file.dialogFlowPersistenceChecksTimeTable[ persistenceVar ] + timeBeforeDialogFlowTableValuesAreOutdated > UITime() )
		{
			return file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ]
		}
	}

	return GetPersistentVar( persistenceVar )
}

void function SetDialogFlowPersistenceTables( string persistenceVar, var value = true )
{
	file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ] <- value
	file.dialogFlowPersistenceChecksTimeTable[ persistenceVar ] <- UITime()
}


void function DialogFlow()
{
	if ( !IsPlayPanelCurrentlyTopLevel() )
		return

	bool persistenceAvailable = IsPersistenceAvailable()
	bool hasActiveBattlePass = GetActiveBattlePass() != null


	if ( FTUEFlow_DialogFlowCheck( GetLocalClientPlayer() ) )
	{
		FTUEFlow_DialogFlow()
	}
	else

	if ( DialogFlow_ShouldOpenPromoDialog() )
	{
		
		OpenPromoDialogIfNewUM()
	}
	else if ( DisplayQueuedRewardsGiven() )
	{
		
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( hasActiveBattlePass && DisplayTreasureBoxRewards() )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}

	else if ( hasActiveBattlePass && DisplayQuestFinalRewards() )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}

	else if ( persistenceAvailable && TryEntitlementMenus() )
	{
	}
	else if ( PlayerHasStarterPack( null ) && persistenceAvailable && ( GetDialogFlowTablesValueOrPersistence ( "starterAcknowledged", true )  == false ) )
	{
		SetDialogFlowPersistenceTables( "starterAcknowledged", true )
		Remote_ServerCallFunction( "ClientCallback_MarkEntitlementMenuSeen", STARTER_PACK )
		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )

		PromoDialog_OpenHijackedUM( Localize( "#ORIGIN_ACCESS_STARTER" ), Localize( "#STARTER_ENTITLEMENT_OWNED" ), "starter" )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( PlayerHasFoundersPack( null ) && persistenceAvailable && ( GetDialogFlowTablesValueOrPersistence( "founderAcknowledged", true ) == false )  )
	{
		SetDialogFlowPersistenceTables( "founderAcknowledged", true )
		Remote_ServerCallFunction( "ClientCallback_MarkEntitlementMenuSeen", FOUNDERS_PACK )
		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )

		PromoDialog_OpenHijackedUM( Localize( "#ORIGIN_ACCESS_FOUNDER" ), Localize( "#FOUNDER_ENTITLEMENT_OWNED" ), "founder" )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( Ranked_ManageDialogFlow(file.rankedSplitChangeAudioPlayed) )
	{
		
		file.rankedSplitChangeAudioPlayed = true
	}

	else if ( ArenasRanked_ManageDialogFlow(file.rankedSplitChangeAudioPlayed) )
	{
		
		file.rankedSplitChangeAudioPlayed = true
	}































	else if ( ShouldShowPremiumCurrencyDialog( true ) )
	{
		ShowPremiumCurrencyDialog( true )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( ShouldShowMatchmakingDelayDialog() )
	{
		ShowMatchmakingDelayDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( ShouldShowLastGameRankedAbandonForgivenessDialog() )
	{
		ShowLastGameRankedAbandonForgivenessDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( !DialogFlow_ShouldOpenPromoDialog() && file.numDialogFlowDialogsDisplayed == 0 && TryOpenSurvey( eSurveyType.ENTER_LOBBY ) )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( hasActiveBattlePass && IsBattlepassMilestoneEnabled() && persistenceAvailable && OpenBattlePassMilestoneDialog() )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else
	{
		file.dialogFlowComplete = true
		thread Lobby_ShowCallToActionPopup( false )
	}
}


void function TryRunDialogFlowThread()
{
	WaitEndFrame()
	DialogFlow()
}


bool function ShouldShowPremiumCurrencyDialog( bool dialogFlow = false, bool resetCurrencyDialogShowed = false )
{
	if( !dialogFlow && !file.dialogFlowComplete )
		return false

	if ( !GRX_IsInventoryReady() )
		return false

	if ( IsDialog( GetActiveMenu() ) )
		return false

	if ( GetActiveMenu() == GetMenu( "LootBoxOpen" ) )
		return false

	if ( resetCurrencyDialogShowed )
	{
		file.currencyDialogShowed = false
	}
	else if ( file.currencyDialogShowed ) 
	{
		return false
	}

	int premiumBalance  = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance =  expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenPremiumCurrency" ) )

	int exoticBalance  = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	int lastSeenExoticBalance =  expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenExoticCurrency" ) )

	return ( premiumBalance > lastSeenBalance || exoticBalance > lastSeenExoticBalance )
}


void function ShowPremiumCurrencyDialog( bool dialogFlow )
{
	int premiumBalance  = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance = expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenPremiumCurrency" ) )

	int exoticBalance  = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_EXOTIC] )
	int lastSeenExoticBalance = expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenExoticCurrency" ) )

	
	

	Assert( premiumBalance > lastSeenBalance || exoticBalance > lastSeenExoticBalance)
	Assert( GRX_IsInventoryReady() )

	ItemFlavor premiumCurrency = GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]
	ItemFlavor exoticCurrency = GRX_CURRENCIES[GRX_CURRENCY_EXOTIC]
	ConfirmDialogData dialogData
	dialogData.headerText = "#RECEIVED_PREMIUM_CURRENCY"
	dialogData.messageText = Localize( "#RECEIVED_PREMIUM_CURRENCY_DESC")

	if ( premiumBalance > lastSeenBalance)
		dialogData.messageText = dialogData.messageText + FormatAndLocalizeNumber( "1", float( premiumBalance - lastSeenBalance ), true ) + " " + "%$" + ItemFlavor_GetIcon( premiumCurrency ) + "%" + "\n"

	if ( exoticBalance > lastSeenExoticBalance )
		dialogData.messageText = dialogData.messageText + FormatAndLocalizeNumber( "1", float( exoticBalance - lastSeenExoticBalance ), true ) + " " + "%$" + ItemFlavor_GetIcon( exoticCurrency ) + "%"

	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	SetDialogFlowPersistenceTables( "lastSeenPremiumCurrency", premiumBalance )
	SetDialogFlowPersistenceTables( "lastSeenExoticCurrency", exoticBalance )

	Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )
	OpenOKDialogFromData( dialogData )
	EmitUISound( "UI_Menu_Purchase_Coins" )
	file.currencyDialogShowed = true
}

void function ShowPendingPurchaseDialog()
{
	ConfirmDialogData dialogData

	if ( IsSteamDelayFulfilment() )
	{
		dialogData.headerText = Localize("#STEAM_DELAY_FULFILMENT")
		dialogData.messageText = Localize( "#STEAM_DELAY_FULFILMENT_DESC")
	}

	OpenOKDialogFromData( dialogData )
}

var function GetTopNonDialogMenu()
{
	array<var> menuStack = MenuStack_GetCopy()
	menuStack.reverse()

	foreach ( menu in menuStack )
	{
		if ( menu == null || IsDialog( menu ) )
			continue

		return menu
	}

	return null
}


var function GetActiveMenu()
{
	return file.activeMenu
}


bool function IsMenuVisible( var menu )
{
	return Hud_IsVisible( menu )
}











bool function IsPanelActive( var panel )
{
	return uiGlobal.activePanels.contains( panel )
}


string function GetActiveMenuName()
{
	return expect string( GetActiveMenu()._name )
}


var function GetMenu( string menuName )
{
	return uiGlobal.menus[ menuName ]
}


var function GetPanel( string panelName )
{
	return uiGlobal.panels[ panelName ]
}


array<var> function GetAllMenuPanels( var menu )
{
	array<var> menuPanels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			menuPanels.append( panel )
	}

	return menuPanels
}


array<var> function GetMenuTabBodyPanels( var menu )
{
	array<var> panels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			panels.append( panel )
	}

	return panels
}


void function InitGamepadConfigs()
{
	uiGlobal.buttonConfigs = [ { orthodox = "gamepad_button_layout_custom.cfg", southpaw = "gamepad_button_layout_custom.cfg" } ]

	uiGlobal.stickConfigs = []
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_default.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_southpaw.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy_southpaw.cfg" )

	foreach ( key, val in uiGlobal.buttonConfigs )
	{
		VPKNotifyFile( "cfg/" + val.orthodox )
		VPKNotifyFile( "cfg/" + val.southpaw )
	}

	foreach ( key, val in uiGlobal.stickConfigs )
		VPKNotifyFile( "cfg/" + val )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()

	SetStandardAbilityBindingsForPilot( GetLocalClientPlayer() )
}

void function InitMenus()
{
	RegisterSignal( "EndShowGameSummaryIfNeeded" )
	RTKCore_RegisterSignals()

	InitGlobalMenuVars()
	








	var mainMenu = AddMenu( "MainMenu", $"resource/ui/menus/main.menu", InitMainMenu, "#MAIN" )
	AddPanel( mainMenu, "EstablishUserPanel", InitEstablishUserPanel )
	AddPanel( mainMenu, "MainMenuPanel", InitMainMenuPanel )

	var crossProgressionDialog = AddMenu( "CrossProgressionDialog", $"resource/ui/menus/dialog_cross_progression.menu", InitCrossProgressionDialog )
	var tabbedModal = AddMenu( "TabbedModal", $"resource/ui/menus/tabbed_modal.menu", RTKTabbedModal_InitTabbedModal )


		var panelImageButtonModal = AddMenu( "PanelImageButtonModal", $"resource/ui/menus/panel_image_button_modal.menu", RTKPanelImageButtonModal_InitPanelImageButtonModal )


	
	
	
	

	AddMenu( "PlayVideoMenu", $"resource/ui/menus/play_video.menu", InitPlayVideoMenu )

	var lobbyMenu   = AddMenu( "LobbyMenu", $"resource/ui/menus/lobby.menu", InitLobbyMenu )

	AddPanel( lobbyMenu, "PlayPanel", InitPlayPanel )

	var seasonPanel = AddPanel( lobbyMenu, "SeasonPanel", InitSeasonPanel )





		AddPanel( seasonPanel, "RTKBattlepassPanel", InitBattlepassPanel )



		AddPanel( seasonPanel, "RTKNewplayerpassPanel", InitNewplayerpassPanel )



	AddMenu( "NewPlayerPassInfoMenu", $"resource/ui/menus/new_player_pass_info.menu", NewPlayerPassInfoInitMenu )


	var eventPanel = AddPanel( lobbyMenu, "EventPanel", InitRTKEventsPanel )


		var challengesPanel = AddPanel( lobbyMenu, "ChallengesPanel", InitChallengesPanel )
		AddMenu( "ChallengesGenericInspectMenu", $"resource/ui/menus/rtk_challenges_generic_inspect.menu", InitChallengesGenericInspectMenu )
		AddMenu( "ChallengesKeyArtInspectMenu", $"resource/ui/menus/rtk_challenges_key_art_inspect.menu", InitChallengesKeyArtInspectMenu )






	var armoryPanel = AddPanel( lobbyMenu, "ArmoryPanel", InitArmoryPanel )

	AddPanel( armoryPanel, "CharactersPanel", InitCharactersPanel )

		AddPanel( armoryPanel, "ArmoryWeaponsPanel", InitRTKArmoryCategoriesPanel )
		AddPanel( armoryPanel, "ArmoryMorePanel", InitRTKArmoryMorePanel )





	var storePanel = AddPanel( lobbyMenu, "StorePanel", InitStorePanel )
	AddPanel( storePanel, "LootPanel", InitLootPanel )
	AddMenu( "PackInfoDialog", $"resource/ui/menus/dialogs/pack_information_dialog.menu", InitPackInfoDialog )

		AddMenu( "MilestonePackInfoDialog", $"resource/ui/menus/dialogs/milestone_information_dialog.menu", InitMilestonePackInfoDialog )

	AddPanel( storePanel, "HeirloomShopPanel", HeirloomShopPanel_Init )
	AddPanel( storePanel, FEATURED_STORE_PANEL, InitOffersPanel )
	AddPanel( storePanel, SPECIALS_STORE_PANEL, InitSpecialsPanel )
	AddPanel( storePanel, SEASONAL_STORE_PANEL, InitSpecialsPanel )

		AddPanel( storePanel, PERSONALIZED_STORE_PANEL, InitPersonalizedStore )


		AddPanel( storePanel, "StoreItemShop", InitStoreItemShop )


		AddPanel( storePanel, STORE_MYTHIC_SHOP, InitStoreItemShop )


		AddPanel( storePanel, RTK_APEX_PACKS_PANEL, InitApexPacksPanelFooterOptions )






	AddMenu( "GiftInfoDialog", $"resource/ui/menus/dialogs/gift_information_dialog.menu", InitGiftInformationDialog )
	AddMenu( "TwoFactorInfoDialog", $"resource/ui/menus/dialogs/two_factor_information_dialog.menu", InitTwoFactorInformationDialog )

	AddMenu( "StoreInspectMenu", $"resource/ui/menus/store_inspect.menu", InitStoreInspectMenu )
	AddMenu( "StoreMythicInspectMenu", $"resource/ui/menus/store_mythic_inspect.menu", InitStoreMythicInspectMenu )
	AddMenu( "ArtifactsInspectMenu", $"resource/ui/menus/artifacts_inspect.menu", InitArtifactsInspectMenu )




		AddMenu( "UniversalMeleeInspectMenu", $"resource/ui/menus/universal_melee_inspect.menu", InitUniversalMeleeInspectMenu )

	var storeOfferSetItemsMenu = AddMenu( "StoreOfferSetItemsMenu", $"resource/ui/menus/store_offer_set_items.menu", InitStoreOfferSetItemsMenu )
	AddPanel( storeOfferSetItemsMenu, "StoreOfferSetItemsPanel", InitStoreOfferSetItemsPanel )

	
	var customMatchDashboard			= AddMenu( "CustomMatchLobbyMenu", $"resource/ui/menus/custom_match_dashboard.menu", InitCustomMatchDashboardMenu )
	var customMatchLobbyPanel       	= AddPanel( customMatchDashboard, "LobbyPanel", InitCustomMatchLobbyPanel )
	var customMatchShareToken 			= AddPanel( customMatchDashboard, "ShareTokenPanel", InitCustomMatchShareTokenPanel )
	var customMatchLobbyRoster       	= AddPanel( customMatchLobbyPanel, "LobbyRosterPanel", InitCustomMatchLobbyRosterPanel )
	var customMatchPlayerRoster       	= AddPanel( customMatchLobbyPanel, "PrivateMatchScoreboardPanel", InitTeamsScoreboardPanel )
	var customMatchSummaryPanel       	= AddPanel( customMatchDashboard, "SummaryPanel", InitCustomMatchSummaryPanel )

	
	var customMatchSettingsPanel	= AddPanel(  customMatchDashboard, "SettingsPanel", InitCustomMatchSettingsPanel )
	AddPanel( customMatchSettingsPanel, "ModeSelectPanel", InitCustomMatchModeSelectPanel )

	var customMatchSettingsListPanel 	= AddPanel( customMatchSettingsPanel, "SettingsSelectPanel", InitCustomMatchSettingsListPanel )

	var customMatchScrollableSettingsPanel = AddPanel( customMatchSettingsListPanel, "SelectOptions", InitCustomMatchScrollableSettingsPanel )
	var customMatchScrollableSettingsInternalPanel = AddPanel( customMatchScrollableSettingsPanel, "ContentPanel", InitCustomMatchScrollableSettingsInternalPanel )

	AddPanel( customMatchScrollableSettingsInternalPanel, "MapSelectPanel", InitCustomMatchMapSelectPanel )
	AddPanel( customMatchScrollableSettingsInternalPanel, "OptionsSelectPanel", InitCustomMatchOptionsSelectPanel )

	
	AddMenu( "CustomMatchKickDialog", $"resource/ui/menus/dialogs/custom_match_kick_players.menu", InitCustomMatchKickPlayersDialog )
	AddMenu( "SetTeamNameDialog", $"resource/ui/menus/dialogs/setteamname_dialog.menu", InitSetTeamNameDialogMenu )

	
	var PrivateMatchSpectCharSelect = AddMenu( "PrivateMatchSpectCharSelectMenu", $"resource/ui/menus/private_match_spec_char_select.menu", InitPrivateMatchSpectCharSelectMenu )
	AddPanel( PrivateMatchSpectCharSelect, "PrivateMatchScoreboardPanel", InitTeamsScoreboardPanel ) 

	
	var privateGameStatusMenu = AddMenu( "PrivateMatchGameStatusMenu", $"resource/ui/menus/private_match_game_status.menu", InitPrivateMatchGameStatusMenu )
	AddPanel( privateGameStatusMenu, "PrivateMatchScoreboardPanel", InitTeamsScoreboardPanel )
	AddPanel( privateGameStatusMenu, "PrivateMatchOverviewPanel", InitPrivateMatchOverviewPanel )
	AddPanel( privateGameStatusMenu, "PrivateMatchSummaryPanel", InitPrivateMatchSummaryPanel )
	AddPanel( privateGameStatusMenu, "PrivateMatchAdminPanel", InitPrivateMatchAdminPanel )

	AddMenu( "PlayerTagDialog", $"resource/ui/menus/dialog_player_tag.menu", InitPlayerTagDialog )



































	AddMenu( "RequeueDialog", $"resource/ui/menus/dialogs/requeue.menu", InitRequeueDialog )







	AddMenu( "SystemMenu", $"resource/ui/menus/system.menu", InitSystemMenu )

	var miscMenu      = AddMenu( "MiscMenu", $"resource/ui/menus/misc.menu", InitMiscMenu )
	var settingsPanel = AddPanel( miscMenu, "SettingsPanel", InitSettingsPanel )


		var controlsPCContainer = AddPanel( settingsPanel, "ControlsPCPanelContainer", InitControlsPCPanel )
		InitControlsPCPanelForCode( controlsPCContainer )

	AddPanel( settingsPanel, "ControlsGamepadPanel", InitControlsGamepadPanel )

	var videoPanelContainer = AddPanel( settingsPanel, "VideoPanelContainer", InitVideoPanel )
	InitVideoPanelForCode( videoPanelContainer )
	AddPanel( settingsPanel, "SoundPanel", InitSoundPanel )
	AddPanel( settingsPanel, "HudOptionsPanel", InitHudOptionsPanel )

	var customizeCharacterMenu = AddMenu( "CustomizeCharacterMenu", $"resource/ui/menus/customize_character.menu", InitCustomizeCharacterMenu )
	AddPanel( customizeCharacterMenu, "CharacterSkinsPanel", InitCharacterSkinsPanel )

	var cardPanel = AddPanel( customizeCharacterMenu, "CharacterCardsPanelV2", InitCharacterCardsPanel )
	AddPanel( cardPanel, "CardFramesPanel", InitCardFramesPanel )
	AddPanel( cardPanel, "CardPosesPanel", InitCardPosesPanel )
	AddPanel( cardPanel, "CardBadgesPanel", InitCardBadgesPanel )
	AddPanel( cardPanel, "CardTrackersPanel", InitCardTrackersPanel )
	AddPanel( cardPanel, "IntroQuipsPanel", InitIntroQuipsPanel )
	AddPanel( cardPanel, "KillQuipsPanel", InitKillQuipsPanel )

	var emotesPanel = AddPanel( customizeCharacterMenu, "CharacterEmotesPanel", InitCharacterEmotesPanel )
	AddPanel( emotesPanel, "LinePanel", InitQuipsPanel )
	AddPanel( emotesPanel, "EmotesPanel", InitEmotesPanel )
	AddPanel( emotesPanel, "HoloSpraysPanel", InitEmotesPanel )
	AddPanel( emotesPanel, "SkydiveEmotesPanel", InitSkydiveEmotesPanel )

	AddPanel( customizeCharacterMenu, "CharacterExecutionsPanel", InitCharacterExecutionsPanel )


		AddPanel( customizeCharacterMenu, "LegendMeleePanel", InitRTKLegendMeleePanel )
		AddPanel( customizeCharacterMenu, "LegendLorePanel", InitRTKLegendLorePanel )

		var meleeCustomizationMenu = AddMenu( "MeleeCustomizationMenu", $"resource/ui/menus/customize_melee.menu", InitMeleeCustomizationMenu )
		AddPanel( meleeCustomizationMenu, "ArtifactCustomizationPanel", InitMeleeCustomizationPanel )


	var customizeWeaponMenu = AddMenu( "CustomizeWeaponMenu", $"resource/ui/menus/customize_weapon.menu", InitCustomizeWeaponMenu )

	var categoryWeaponPanel0 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel0", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel0, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel0, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel0, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel0, "WeaponLorePanel", InitRTKWeaponLorePanel )


	var categoryWeaponPanel1 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel1", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel1, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel1, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel1, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel1, "WeaponLorePanel", InitRTKWeaponLorePanel )


	var categoryWeaponPanel2 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel2", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel2, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel2, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel2, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel2, "WeaponLorePanel", InitRTKWeaponLorePanel )


	var categoryWeaponPanel3 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel3", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel3, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel3, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel3, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel3, "WeaponLorePanel", InitRTKWeaponLorePanel )


	var categoryWeaponPanel4 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel4", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel4, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel4, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel4, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel4, "WeaponLorePanel", InitRTKWeaponLorePanel )


	var categoryWeaponPanel5 = AddPanel( customizeWeaponMenu, "CategoryWeaponPanel5", InitCategoryWeaponPanel )

		AddPanel( categoryWeaponPanel5, "WeaponMasteryPanel", InitRTKWeaponMasteryPanel )

	AddPanel( categoryWeaponPanel5, "WeaponSkinsPanel", InitWeaponSkinsPanel )
	AddPanel( categoryWeaponPanel5, "WeaponCharmsPanel", InitWeaponCharmsPanel )

		AddPanel( categoryWeaponPanel5, "WeaponLorePanel", InitRTKWeaponLorePanel )




		AddMenu( "WeaponMasteryTrialsMenu", $"resource/ui/menus/weapon_mastery_trials.menu", InitWeaponMasteryTrialsMenu )


	var miscCustomizeMenu = AddMenu( "MiscCustomizeMenu", $"resource/ui/menus/misc_customize.menu", InitMiscCustomizeMenu )
	AddPanel( miscCustomizeMenu, "LoadscreenPanel", InitLoadscreenPanel )
	AddPanel( miscCustomizeMenu, "MusicPackPanel", InitMusicPackPanel )
	AddPanel( miscCustomizeMenu, "SkydiveTrailPanel", InitSkydiveTrailPanel )

	var customizeConsumablesMenu = AddMenu( "CustomizeConsumablesMenu", $"resource/ui/menus/customize_consumables.menu", InitCustomizeConsumablesMenu )
	AddPanel( customizeConsumablesMenu, "StickersPanel0", InitConsumableStickersPanel )
	AddPanel( customizeConsumablesMenu, "StickersPanel1", InitConsumableStickersPanel )
	AddPanel( customizeConsumablesMenu, "StickersPanel2", InitConsumableStickersPanel )
	AddPanel( customizeConsumablesMenu, "StickersPanel3", InitConsumableStickersPanel )

	AddMenu( "CharacterSelectMenu", $"resource/ui/menus/character_select.menu", UI_InitCharacterSelectMenu )




	var deathScreenMenu = AddMenu( "DeathScreenMenu", $"resource/ui/menus/death_screen.menu", InitDeathScreenMenu )
	AddPanel( deathScreenMenu, "DeathScreenGenericScoreboardPanel", InitTeamsScoreboardPanel )
	AddPanel( deathScreenMenu, "DeathScreenRecap", InitDeathScreenRecapPanel )
	AddPanel( deathScreenMenu, "DeathScreenSpectate", InitDeathScreenSpectatePanel )

	AddPanel( deathScreenMenu, "DeathScreenSquadSummary", DeathScreenSquadSummary_RTKInitialize )




		AddPanel( deathScreenMenu, "RTKDeathScreenSquadPanel", InitRTKSquadPanel )

	AddPanel( deathScreenMenu, "DeathScreenSquadPanel", InitSquadPanelInventory )


		AddPanel( deathScreenMenu, "DeathScreenRankedMatchSummaryPanel", InitRTKRankedMatchSummary )


		AddPanel( deathScreenMenu, "DeathScreenPostGameCupsPanel", InitRTKPostGameCups )

	AddPanel( deathScreenMenu, "DeathScreenKillreplay", InitDeathScreenKillreplayPanel )

	var postGameRankedMenu = AddMenu( "PostGameRankedMenu", $"resource/ui/menus/post_game_ranked.menu", InitPostGameRankedMenu )
	AddPanel( postGameRankedMenu, "MatchSummaryPanel", InitPostGameRankedSummaryPanel )

	var postGameCupsMenu = AddMenu( "PostGameCupsMenu", $"resource/ui/menus/post_game_cups.menu", InitPostGameCupsMenu )
	AddPanel( postGameCupsMenu, "PostGameCupsPanel", InitPostGameCupsPanel )

	AddMenu( "RankedInfoMenu", $"resource/ui/menus/ranked_info.menu", InitRankedInfoMenu )
	AddMenu( "RankedInfoMoreMenu", $"resource/ui/menus/ranked_info_more.menu", InitRankedInfoMoreMenu ) 

	AddMenu( "PostGameWeaponTrialCelebrationsMenu", $"resource/ui/menus/postgame_weapon_trial_celebrations.menu", InitPostGameWeaponTrialCelebrationsMenu )







	var progressionModifiersMenu = AddMenu( "ProgressionModifiersMenu", $"resource/ui/menus/progression_modifiers.menu", InitRTKProgressionModifiersMenu )
	AddPanel( progressionModifiersMenu, "ProgressionModifiersInfoPanel", InitRTKProgressionModifiersInfoPanel )
	AddPanel( progressionModifiersMenu, "ProgressionModifiersBoostPanel", InitRTKProgressionModifiersBoostPanel )

	AddMenu( "BattlePassMilestoneMenu", $"resource/ui/menus/battlepass_milestone.menu", InitBattlepassMilestoneMenu )

	var inventoryMenu = AddMenu( "SurvivalInventoryMenu", $"resource/ui/menus/survival_inventory.menu", InitSurvivalInventoryMenu )
	AddPanel( inventoryMenu, "SurvivalQuickInventoryPanel", InitSurvivalQuickInventoryPanel )
	AddPanel( inventoryMenu, "GenericScoreboardPanel", InitTeamsScoreboardPanel )

		AddPanel( inventoryMenu, "RTKSquadPanel", InitRTKSquadPanel )


	AddPanel( inventoryMenu, "SquadPanel", InitSquadPanelInventory )


	var rangeSettingsPanel = AddPanel( inventoryMenu, "FiringRangeSettingsPanel", InitFiringRangeSettingsPanel )
	AddPanel( rangeSettingsPanel, "FiringRangeSettingsGeneralPanel", InitFiringRangeSettingsGeneralPanel )

	AddPanel( inventoryMenu, "CharacterDetailsPanel", InitCharacterAbilitiesPanel )

	AddMenu( "SurvivalGroundListMenu", $"resource/ui/menus/survival_ground_list.menu", InitSurvivalGroundList )
	AddMenu( "SurvivalQuickSwapMenu", $"resource/ui/menus/survival_quick_swap.menu", InitQuickSwapMenu )






	AddMenu( "GammaMenu", $"resource/ui/menus/gamma.menu", InitGammaMenu, "#BRIGHTNESS" )

	AddMenu( "Notifications", $"resource/ui/menus/notifications.menu", InitNotificationsMenu )

	var postGameMenu = AddMenu( "PostGameMenu", $"resource/ui/menus/postgame.menu", InitPostGameMenu )
	AddPanel( postGameMenu, "PostGameGeneral", InitRTKPostGameSummary )

		AddPanel( postGameMenu, "PostGameWeapons", InitRTKPostGameWeaponsPanel )


	AddMenu( "Dialog", $"resource/ui/menus/dialog.menu", InitDialogMenu )
	var promoDialog = AddMenu( "PromoDialogUM", $"resource/ui/menus/dialogs/promoUM.menu", InitPromoDialogUM )
	AddPanel( promoDialog, "PromoPanel", InitPromoPanel )
	AddPanel( promoDialog, "InboxPanel", InitInboxPanel )

	AddMenu( "StoryEventAboutDialog", $"resource/ui/menus/dialogs/story_event_about.menu", InitStoryEventAboutDialog )

	AddMenu( "RadioPlayDialog", $"resource/ui/menus/dialogs/radio_play.menu", InitRadioPlayDialog )

	var selectSlot = AddMenu( "SlotSelectDialog", $"resource/ui/menus/dialogs/select_slot.menu", InitSelectSlotDialog )
	AddPanel( selectSlot, "SelectSlotDefault", InitSelectSlotDefaultPanel )
	AddPanel( selectSlot, "SelectSlotEmotes", InitSelectSlotEmotesPanel )

	var characterSkillsDialog = AddMenu( "CharacterSkillsDialog", $"resource/ui/menus/dialogs/character_skills.menu", InitCharacterSkillsDialog )
	AddPanel( characterSkillsDialog,"CharacterAbilitiesPanel", InitCharacterAbilitiesPanel )

		AddPanel( characterSkillsDialog,"LegendUpgradesPanel", InitRTKLegendUpgradePanel )


		AddPanel( characterSkillsDialog,"CharacterRolesPanel", InitCharacterRolesPanel )

	
	
	AddMenu( "ConfirmDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmDialog )

	var gamemodeSelectDialog = AddMenu( "GamemodeSelectDialog", $"resource/ui/menus/dialog_gamemode_select.menu", InitGamemodeSelectDialog )
	AddPanel( gamemodeSelectDialog, "GamemodeSelectDialogPublicPanel", InitGameModeSelectPublicPanel )
	AddPanel( gamemodeSelectDialog, "GamemodeSelectDialogPrivatePanel", InitGameModeSelectPrivatePanel )

		AddPanel( gamemodeSelectDialog, "RTKGamemodeSelectApexCups", InitRTKGameModeSelectApexCups )

		var CupInfoDialog = AddMenu( "RTKCupInfoDialog", $"resource/ui/menus/apex_cups/dialog_cup_breakdown.menu", InitCupInfoDialog )
		AddPanel( CupInfoDialog, "RTKCupInfoPoints", InitRTKCupInfoPoints )
		AddPanel( CupInfoDialog, "RTKCupInfoTiers", InitRTKCupInfoTiers )

		
		var apexCupMenu = AddMenu( "RTKApexCupMenu", $"resource/ui/menus/apex_cups/rtk_cups_tab_screen.menu", InitRTKApexCupMenu )
		AddPanel( apexCupMenu, "RTKApexCupsOverview", InitRTKApexCupsOverview )
		AddPanel( apexCupMenu, "RTKApexCupsHistory", InitRTKApexCupHistory )
		AddPanel( apexCupMenu, "RTKApexCupsLeaderboard", InitRTKApexCupLeaderboard )


	
	

		var controlSpawnSelectorMenu = AddMenu( "ControlSpawnSelector", $"resource/ui/menus/control_respawn_menu.menu", InitControlSpawnMenu )
		AddPanel( controlSpawnSelectorMenu, "ControlRespawn_GenericScoreboardPanel", InitTeamsScoreboardPanel )






	var scoreboardTransitionsMenu = AddMenu( "ScoreboardTransition", $"resource/ui/menus/scoreboard_transition.menu", InitScoreboardTransition )
	

	AddMenu( "LoadoutSelectionSystemLoadoutSelector", $"resource/ui/menus/loadout_selection_system_select.menu", LoadoutSelectionMenu_InitLoadoutMenu )
	AddMenu( "LoadoutSelectionSystemSelectOptic", $"resource/ui/menus/dialogs/loadoutselection_select_optic.menu", LoadoutSelectionOptics_InitSelectOpticDialog )

	AddMenu( "OKDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitOKDialog )
	AddMenu( "TextEntryDialog", $"resource/ui/menus/dialogs/text_entry_dialog.menu", InitTextEntryDialog )
	AddMenu( "ConfirmExitToDesktopDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmExitToDesktopDialog )
	AddMenu( "ConfirmLeaveMatchDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmLeaveMatchDialog )
	AddMenu( "ConfirmKeepVideoChangesDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmKeepVideoChangesDialog )
	if ( GetConVarBool( "grx_vertical_dialogue_confirmation" ) ) 
		AddMenu( "ConfirmPurchaseDialog", $"resource/ui/menus/dialogs/confirm_purchase.menu", InitConfirmPurchaseDialog )
	else
		AddMenu( "ConfirmPurchaseDialog", $"resource/ui/menus/dialogs/confirm_purchase_horizontal.menu", InitConfirmPurchaseDialog )
	AddMenu( "ConfirmPackBundlePurchaseDialog", $"resource/ui/menus/dialogs/confirm_pack_bundle_purchase.menu", InitConfirmPackBundlePurchaseDialog )


	var confirmMultiPackBundlePurchaseDialogMenu = AddMenu( "ConfirmMultiPackBundlePurchaseDialog", $"resource/ui/menus/dialogs/confirm_multi_pack_bundle_purchase.menu", InitConfirmMultiPackBundlePurchaseDialog )

	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentPackHeader", InitMultiPackDisclosureHeaderPanel )
	
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentApexPackContent", InitApexPackDisclosureDialogContentPanel )
	
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentEventPackContent", InitEventPackDisclosureDialogContentPanel )
	
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentThematicPackContent0", InitThematicPackDisclosureDialogContentPanel0 )
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentThematicPackContent1", InitThematicPackDisclosureDialogContentPanel1 )
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentThematicPackContent2", InitThematicPackDisclosureDialogContentPanel2 )
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentThematicPackContent3", InitThematicPackDisclosureDialogContentPanel3 )
	
	AddPanel( confirmMultiPackBundlePurchaseDialogMenu, "DialogContentEventThematicPackContent", InitEventThematicPackDisclosureDialogContentPanel )


	AddMenu( "ConfirmBattlepassPurchaseDialog", $"resource/ui/menus/dialogs/confirm_battle_pass_purchase.menu", InitBattlepassPurchaseDialog )
	AddMenu( "ConfirmPackPurchaseDialog", $"resource/ui/menus/dialogs/confirm_pack_purchase.menu", InitConfirmPackPurchaseDialog )
	AddMenu( "GiftingFriendDialog", $"resource/ui/menus/dialogs/gift_friend_dialog.menu", InitGiftingDialog )
	AddMenu( "DataCenterDialog", $"resource/ui/menus/dialog_datacenter.menu", InitDataCenterDialogMenu )
	AddMenu( "EULADialog", $"resource/ui/menus/dialog_eula.menu", InitEULADialog )




	AddMenu( "ModeSelectDialog", $"resource/ui/menus/dialog_mode_select.menu", InitModeSelectDialog )

	AddMenu( "ErrorDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitErrorDialog )
	AddMenu( "AccessibilityDialog", $"resource/ui/menus/dialogs/accessibility_dialog.menu", InitAccessibilityDialog )

	AddMenu( "ReportPlayerDialog", $"resource/ui/menus/dialog_report_player.menu", InitReportPlayerDialog )
	AddMenu( "ReportPlayerReasonPopup", $"resource/ui/menus/dialog_report_player_reason.menu", InitReportReasonPopup )
	AddMenu( "ProcessingDialog", $"resource/ui/menus/dialog_processing.menu", InitProcessingDialog )

	AddMenu( "CodeRedemptionDialog", $"resource/ui/menus/dialog_code_redemption.menu", InitCodeRedemptionDialog )

	AddMenu( "RewardPurchaseDialog", $"resource/ui/menus/dialogs/pass_dialog.menu", InitRewardPurchaseDialog )
	AddMenu( "PassPurchaseMenu", $"resource/ui/menus/pass_purchase.menu", InitPassPurchaseMenu )

	AddMenu( "RewardCeremonyMenu", $"resource/ui/menus/reward_ceremony.menu", InitRewardCeremonyMenu )
	AddMenu( "LoadscreenPreviewMenu", $"resource/ui/menus/loadscreen_preview.menu", InitLoadscreenPreviewMenu )

	AddMenu( "PostGameBattlePassMenu", $"resource/ui/menus/post_game_battlepass.menu", InitPostGameBattlePassMenu )
	AddMenu( "BattlePassAboutPage1", $"resource/ui/menus/dialogs/battle_pass_about_1.menu", InitAboutBattlePass1Dialog )

		AddMenu( "RTKBattlePassMoreInfoMenu", $"resource/ui/menus/dialogs/rtk_battlepass_more_info.menu", InitRTKBattlePassMoreInfoMenu )
		AddMenu( "RTKBattlepassPurchaseMenu", $"resource/ui/menus/dialogs/rtk_battlepass_purchase.menu", InitRTKBattlePassPurchaseMenu )



	AddMenu( "CollectionEventAboutPage", $"resource/ui/menus/dialogs/collection_event_about.menu", CollectionEventAboutPage_Init )

	var controlsAdvancedLookMenu = AddMenu( "ControlsAdvancedLookMenu", $"resource/ui/menus/controls_advanced_look.menu", InitControlsAdvancedLookMenu, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsAdvancedLookMenu, "AdvancedLookControlsPanel", InitAdvancedLookControlsPanel )
	AddMenu( "GamepadLayoutMenu", $"resource/ui/menus/gamepadlayout.menu", InitGamepadLayoutMenu )

	var FirstPersonReticlOptionseMenu = AddMenu( "FirstPersonReticleOptionsMenu", $"resource/ui/menus/first_person_reticle_options.menu", InitFirstPersonReticleOptionsMenu )
	AddPanel( FirstPersonReticlOptionseMenu, "FirstPersonReticleOptionsColorPanel", InitFirstPersonReticleOptionsColorPanel )

	var LaserSightOptionseMenu = AddMenu( "LaserSightOptionsMenu", $"resource/ui/menus/laser_sight_options.menu", InitLaserSightOptionsMenu )
	AddPanel( LaserSightOptionseMenu, "LaserSightOptionsColorPanel", InitLaserSightOptionsColorPanel )

	AddMenu( "LoreReaderMenu", $"resource/ui/menus/lore_reader.menu", InitLoreReaderMenu )














		var controlsADSPC = AddMenu( "ControlsAdvancedLookMenuPC", $"resource/ui/menus/controls_ads_pc.menu", InitADSControlsMenuPC, "#CONTROLS_ADVANCED_LOOK" )
		AddPanel( controlsADSPC, "ADSControlsPanel", InitADSControlsPanelPC )


	var controlsADSConsole = AddMenu( "ControlsAdvancedLookMenuConsole", $"resource/ui/menus/controls_ads_console.menu", InitADSControlsMenuConsole, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsADSConsole, "ADSControlsPanel", InitADSControlsPanelConsole )

	var controlsADSAdvancedConsole = AddMenu( "ControlsAdsAdvancedLookMenuConsole", $"resource/ui/menus/controls_ads_advanced_console.menu", InitADSAdvancedControlsMenuConsole, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsADSAdvancedConsole, "ADSAdvancedControlsPanel", InitADSAdvancedControlsPanelConsole )







	AddMenu( "LootBoxOpen", $"resource/ui/menus/loot_box.menu", InitLootBoxMenu )

	var socialMenu = AddMenu( "SocialMenu", $"resource/ui/menus/social.menu", InitSocialMenu )
	AddPanel( socialMenu, "FriendsPanel", InitFriendsPanel )
	AddPanel( socialMenu, "FriendsOtherPanel", InitFriendsOtherPanel )
	AddPanel( socialMenu, "FriendRequestsPanel", InitFriendRequestsPanel )

	AddMenu( "FindFriendDialog", $"resource/ui/menus/dialog_find_friend.menu", InitFindFriendDialog )

	var inspectMenu = AddMenu( "InspectMenu", $"resource/ui/menus/inspect.menu", InitInspectMenu )
	AddPanel( inspectMenu, "StatsSummaryPanel", InitStatsSummaryPanel )
	AddMenu( "StatsSeasonSelectPopUp", $"resource/ui/menus/dialog_player_stats_season_select.menu", InitSeasonSelectPopUp ) 
	AddMenu( "StatsModeSelectPopUp", $"resource/ui/menus/dialog_player_stats_mode_select.menu", InitModeSelectPopUp ) 


		AddMenu( "RTKInspectMenu", $"resource/ui/menus/rtk_inspect.menu", InitRTKInspectMenu )





	var FeatureTutorialDialog = AddMenu( "FeatureTutorialDialog", $"resource/ui/menus/dialog_feature_tutorial.menu", InitFeatureTutorialDialog )
	AddMenu( "PurchasePackSelectionDialog", $"resource/ui/menus/dialog_purchase_pack_selection.menu", InitPurchasePackSelectionDialog )


	var EventShopTierDialog = AddMenu( "EventShopTierDialog", $"resource/ui/menus/dialog_event_shop.menu", InitEventShopTierDialog )
	var SweepstakesFlowDialog = AddMenu( "SweepstakesFlowDialog", $"resource/ui/menus/dialog_sweepstakes_flow.menu", InitSweepstakesFlowDialog )
	var SweepstakesRulesDialog = AddMenu( "SweepstakesRulesDialog", $"resource/ui/menus/dialog_sweepstakes_rules.menu", InitSweepstakesRulesDialog )

	var storeOnlyMilestoneEventsMenu = AddMenu( "StoreOnlyMilestoneEventsMenu", $"resource/ui/menus/store_only_milestone_events.menu", InitStoreOnlyMilestoneEventsMenu )
	AddPanel( storeOnlyMilestoneEventsMenu, "StoreOnlyMilestoneEventsPanel", InitStoreOnlyMilestoneEventsPanel )





#if DEV
		
		AddMenu( "DevMenu", $"resource/ui/menus/dev.menu", InitDevMenu, "Dev" )
#endif

	InitTabs()
	InitSurveys()
	ShMenuModels_UIInit()

	foreach ( var menu in uiGlobal.allMenus )
	{
		if ( uiGlobal.menuData[ menu ].initFunc != null )
			uiGlobal.menuData[ menu ].initFunc( menu )

		array<var> elems = GetElementsByClassname( menu, "TabsCommonClass" )
		if ( elems.len() > 0 )
			uiGlobal.menuData[ menu ].hasTabs = true

		elems = GetElementsByClassname( menu, "EnableKeyBindingIcons" )
		foreach ( elem in elems )
			Hud_EnableKeyBindingIcons( elem )
	}

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( uiGlobal.panelData[ panel ].initFunc != null )
			uiGlobal.panelData[ panel ].initFunc( panel )

		array<var> elems = GetPanelElementsByClassname( panel, "TabsPanelClass" )
		if ( elems.len() > 0 )
			uiGlobal.panelData[ panel ].hasTabs = true
	}

	
	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> buttons = GetElementsByClassname( menu, "DefaultFocus" )
		foreach ( button in buttons )
		{
			var panel = Hud_GetParent( button )

			
			Assert( panel != null, "no parent panel found for button " + Hud_GetHudName( button ) )
			Assert( panel in uiGlobal.panelData, "panel " + Hud_GetHudName( panel ) + " isn't in uiGlobal.panelData, but button " + Hud_GetHudName( button ) + " has defaultFocus set!" )
			uiGlobal.panelData[ panel ].defaultFocus = button
			
		}
	}

	InitFooterOptions()

	RTKFooters_Init()

	InitMatchmakingOverlay()
	InitRespawnOverlay()
	InitPromoData()

	RegisterTabNavigationInput()
	thread UpdateGamepadCursorEnabledThread()

	GamemodeSurvivalShared_UI_Init()
}


void functionref( var ) function AdvanceMenuEventHandler( var menu )
{
	return void function( var item ) : ( menu )
	{
		if ( Hud_IsLocked( item ) )
			return

		AdvanceMenu( menu )
	}
}


void function PCBackButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}


void function PCSwitchTeamsButton_Activate( var button )
{
	ClientCommand( "PrivateMatchSwitchTeams" )
}


void function PCToggleSpectateButton_Activate( var button )
{
	ClientCommand( "PrivateMatchToggleSpectate" )
}


void function AddMenuElementsByClassname( var menu, string classname )
{
	array<var> elements = GetElementsByClassname( menu, classname )

	if ( !(classname in menu.classElements) )
		menu.classElements[classname] <- []

	menu.classElements[classname].extend( elements )
}


void function SetPanelDefaultFocus( var panel, var button )
{
	uiGlobal.panelData[ panel ].defaultFocus = button
}


void function PanelFocusDefault( var panel )
{
	
	if ( uiGlobal.panelData[ panel ].defaultFocus )
	{
		Hud_SetFocused( uiGlobal.panelData[ panel ].defaultFocus )
		
	}
}


void function AddMenuThinkFunc( var menu, void functionref( var ) func )
{
	uiGlobal.menuData[ menu ].thinkFuncs.append( func )
}


void function AddMenuEventHandler( var menu, int event, void functionref() func )
{
	if ( event == eUIEvent.MENU_OPEN )
	{
		Assert( uiGlobal.menuData[ menu ].openFunc == null )
		uiGlobal.menuData[ menu ].openFunc = func
	}
	else if ( event == eUIEvent.MENU_PRECLOSE )
	{
		Assert( uiGlobal.menuData[ menu ].preCloseFunc == null )
		uiGlobal.menuData[ menu ].preCloseFunc = func
	}
	else if ( event == eUIEvent.MENU_CLOSE )
	{
		Assert( uiGlobal.menuData[ menu ].closeFunc == null )
		uiGlobal.menuData[ menu ].closeFunc = func
	}
	else if ( event == eUIEvent.MENU_SHOW )
	{
		Assert( uiGlobal.menuData[ menu ].showFunc == null )
		uiGlobal.menuData[ menu ].showFunc = func
	}
	else if ( event == eUIEvent.MENU_HIDE )
	{
		Assert( uiGlobal.menuData[ menu ].hideFunc == null )
		uiGlobal.menuData[ menu ].hideFunc = func
	}
	else if ( event == eUIEvent.MENU_GET_TOP_LEVEL )
	{
		Assert( uiGlobal.menuData[ menu ].getTopLevelFunc == null )
		uiGlobal.menuData[ menu ].getTopLevelFunc = func
	}
	else if ( event == eUIEvent.MENU_LOSE_TOP_LEVEL )
	{
		Assert( uiGlobal.menuData[ menu ].loseTopLevelFunc == null )
		uiGlobal.menuData[ menu ].loseTopLevelFunc = func
	}
	else if ( event == eUIEvent.MENU_NAVIGATE_BACK )
	{
		Assert( uiGlobal.menuData[ menu ].navBackFunc == null )
		uiGlobal.menuData[ menu ].navBackFunc = func
	}
	
	
	
	
	
	else if ( event == eUIEvent.MENU_INPUT_MODE_CHANGED )
	{
		Assert( uiGlobal.menuData[ menu ].inputModeChangedFunc == null )
		uiGlobal.menuData[ menu ].inputModeChangedFunc = func
	}
}


void function AddPanelEventHandler( var panel, int event, void functionref( var panel ) func )
{
	if ( event == eUIEvent.PANEL_SHOW )
		uiGlobal.panelData[ panel ].showFuncs.append( func )
	else if ( event == eUIEvent.PANEL_HIDE )
		uiGlobal.panelData[ panel ].hideFuncs.append( func )
	else if ( event == eUIEvent.PANEL_NAVUP )
		uiGlobal.panelData[ panel ].navUpFunc = func
	else if ( event == eUIEvent.PANEL_NAVDOWN )
		uiGlobal.panelData[ panel ].navDownFunc = func
	else if ( event == eUIEvent.PANEL_NAVBACK )
		uiGlobal.panelData[ panel ].navBackFunc = func
}


void function AddPanelEventHandler_FocusChanged( var panel, void functionref( var panel, var oldFocus, var newFocus ) func )
{
	uiGlobal.panelData[ panel ].focusChangedFuncs.append( func )
}


void function SetPanelInputHandler( var panel, int inputID, bool functionref( var panel ) func )
{
	Assert( !(inputID in uiGlobal.panelData[ panel ].panelInputs), "Panels may only register a single handler for button input" )
	uiGlobal.panelData[ panel ].panelInputs[ inputID ] <- func
}



void function OpenMenuWrapper( var menu, bool isFirstOpen )
{
	OpenMenu( menu )
	printt( FUNC_NAME(), Hud_GetHudName( menu ) )

	Assert( menu in uiGlobal.menuData )

	if ( isFirstOpen )
	{
		if ( uiGlobal.menuData[ menu ].openFunc != null )
		{
			uiGlobal.menuData[ menu ].openFunc()
			
		}
		FocusDefaultMenuItem( menu )
	}

	if ( uiGlobal.menuData[ menu ].showFunc != null )
		uiGlobal.menuData[ menu ].showFunc()

	if ( uiGlobal.menuData[ menu ].getTopLevelFunc != null )
		uiGlobal.menuData[ menu ].getTopLevelFunc()

	PIN_PageView( Hud_GetHudName( menu ), UITime() - uiGlobal.menuData[ menu ].enterTime, GetLastMenuIDForPIN(), IsDialog( menu ), uiGlobal.menuData[ menu ].pin_metaData )
	

	uiGlobal.menuData[ menu ].enterTime = UITime()

	foreach ( var panel in GetAllMenuPanels( menu ) )
	{
		PanelDef panelData = uiGlobal.panelData[panel]
		if ( panelData.isActive && !panelData.isCurrentlyShown )
			ShowPanelInternal( panel )
	}

	ToolTips_MenuOpened( menu )

	UpdateFooterOptions()
	UpdateMenuTabs()
}


void function CloseMenuWrapper( var menu )
{
	if ( uiGlobal.menuData[ menu ].preCloseFunc != null )
	{
		uiGlobal.menuData[ menu ].preCloseFunc()
		
	}

	bool wasVisible = Hud_IsVisible( menu )
	CloseMenu( menu )
	ClearMenuBlur( menu )
	printt( FUNC_NAME(), Hud_GetHudName( menu ) )

	ToolTips_MenuClosed( menu )

	if ( wasVisible )
	{
		if ( uiGlobal.menuData[ menu ].hideFunc != null )
			uiGlobal.menuData[ menu ].hideFunc()

		PIN_PageView( Hud_GetHudName( menu ), UITime() - uiGlobal.menuData[ menu ].enterTime, GetLastMenuIDForPIN(), IsDialog( menu ), uiGlobal.menuData[ menu ].pin_metaData ) 
		SetLastMenuIDForPIN( Hud_GetHudName( menu ) )

		foreach ( var panel in GetAllMenuPanels( menu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	Assert( menu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ menu ].closeFunc != null )
	{
		uiGlobal.menuData[ menu ].closeFunc()
		
	}
}

void function OpenOverlay( var overlay )
{
	if ( !IsOverlay( overlay ) )
		return

	
	if ( file.activeOverlay != null )
		return

	UpdateMenuBlur( overlay )
	OpenMenuWrapper( overlay, true )

	file.activeOverlay = overlay
}

void function CloseOverlay( var overlay )
{
	if ( !IsOverlay( overlay ) )
		return

	
	if ( file.activeOverlay != overlay )
		return

	CloseMenuWrapper( overlay )
	if ( file.activeMenu )
		UpdateMenuBlur( file.activeMenu )

	file.activeOverlay = null
}


void function AddButtonEventHandler( var button, int event, void functionref( var ) func )
{
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButton( var menu, string buttonName, int event, void functionref( var ) func )
{
	var button = Hud_GetChild( menu, buttonName )
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		
		Hud_AddEventHandler( button, event, func )
	}
}


void function RemoveEventHandlerFromButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		
		Hud_RemoveEventHandler( button, event, func )
	}
}


void function RegisterMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( !(varName in intVars) )

	intVars[varName] <- value
}


void function RegisterMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( !(varName in boolVars) )

	boolVars[varName] <- value
}


void function RegisterMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( !(varName in varVars) )

	varVars[varName] <- value
}


int function GetMenuVarInt( string varName )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	return intVars[varName]
}


bool function GetMenuVarBool( string varName )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	return boolVars[varName]
}


var function GetMenuVarVar( string varName )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	return varVars[varName]
}


void function SetMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	if ( intVars[varName] == value )
		return

	intVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			
			func()
		}
	}
}


void function SetMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	if ( boolVars[varName] == value )
		return

	boolVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			
			func()
		}
	}
}


void function SetMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	if ( varVars[varName] == value )
		return

	varVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			
			func()
		}
	}
}


void function AddMenuVarChangeHandler( string varName, void functionref() func )
{
	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( !(varName in varChangeFuncs) )
		varChangeFuncs[varName] <- []

	
	varChangeFuncs[varName].append( func )
}



void function InitGlobalMenuVars()
{
	RegisterMenuVarBool( "isFullyConnected", false )
	RegisterMenuVarBool( "isPartyLeader", false )
	RegisterMenuVarBool( "isGamepadActive", IsControllerModeActive() )
	RegisterMenuVarBool( "isMatchmaking", false )











		RegisterMenuVarBool( "ORIGIN_isEnabled", false )
		RegisterMenuVarBool( "ORIGIN_isJoinable", false )




	thread UpdateIsFullyConnected()
	thread UpdateAmIPartyLeader()
	thread UpdateActiveMenuThink()
	thread UpdateIsMatchmaking()










		thread UpdatePCPlat_IsEnabled()
		thread UpdatePCPlat_IsJoinable()
		thread UpdateIsGamepadActive()



}








bool function _IsMenuThinkActive()
{
	return file.menuThinkThreadActive
}


void function UpdateActiveMenuThink()
{
	OnThreadEnd(
		function() : ()
		{
			Assert( false, "This thread should not have ended" )
			file.menuThinkThreadActive = false
		}
	)

	file.menuThinkThreadActive = true
	while ( true )
	{
		var menu = GetActiveMenu()
		if ( menu )
		{
			Assert( menu in uiGlobal.menuData )
			foreach ( func in uiGlobal.menuData[ menu ].thinkFuncs )
				func( menu )

#if DEV
			AddNetPanelDiagnostics()
#endif
		}

		WaitFrame()
	}
}


#if DEV
void function AddNetPanelDiagnostics()
{
	AddNetPanelText( "uiAutomationCount = " + file.uiAutomationCount )
	AddNetPanelText( "uiAutomationExpiredTime = " + file.uiAutomationExpiredTime )

	AddNetPanelText( "menuStack:" );
	array<var> menuStack = MenuStack_GetCopy()
	foreach ( index, menu in menuStack )
	{
		string text = "  " +  index + "  " + Hud_GetHudName( menu ) + " "
		if (IsDialog(menu))
		{
			text += "(dialog) "
		}
		if (IsPopup(menu))
		{
			text += "(popup) "
		}
		if (IsMenuVisible(menu))
		{
			text += "(visible) "
		}
		if (menu == GetActiveMenu())
		{
			text += "(active) "
		}
		AddNetPanelText( text );
	}

	AddNetPanelText( "uiGlobal.activePanels:");
	foreach ( var panel in uiGlobal.activePanels )
	{
		var parentMenu = GetParentMenu( panel )

		string text = "  " + Hud_GetHudName(panel) + "  (parent=" + Hud_GetHudName(parentMenu) + ") "
		if ( uiGlobal.panelData[ panel ].isActive )
		{
			text += "(active) "
		}
		if ( uiGlobal.panelData[ panel ].isCurrentlyShown )
		{
			text += "(isCurrentlyShown) "
		}
		AddNetPanelText( text )
	}
}
#endif


void function UpdateIsFullyConnected()
{
	while ( true )
	{
		SetMenuVarBool( "isFullyConnected", IsFullyConnected() )
		WaitFrame()
	}
}


void function UpdateAmIPartyLeader()
{
	while ( true )
	{
		SetMenuVarBool( "isPartyLeader", AmIPartyLeader() )
		WaitFrame()
	}
}


void function UpdateIsMatchmaking()
{
	while ( true )
	{
		SetMenuVarBool( "isMatchmaking", (IsConnected() && AreWeMatchmaking()) )
		WaitFrame()
	}
}
























































void function UpdatePCPlat_IsEnabled()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isEnabled", PCPlat_IsEnabled() )
		WaitFrame()
	}
}

void function UpdatePCPlat_IsJoinable()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isJoinable", PCPlat_IsJoinable() )
		WaitFrame()
	}
}

void function UpdateIsGamepadActive()
{
	while ( true )
	{
		SetMenuVarBool( "isGamepadActive", IsControllerModeActive() )
		WaitFrame()
	}
}


void function InviteFriends()
{

		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}


	AdvanceMenu( GetMenu( "SocialMenu" ) )
}













#if DEV
void function OpenDevMenu( var button )
{
	AdvanceMenu( GetMenu( "DevMenu" ) )
}
#endif

void function SetDialog( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isDialog = val
}


void function SetPopup( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isDialog = val
	uiGlobal.menuData[ menu ].isPopup = val
	uiGlobal.menuData[ menu ].clearBlur = false
}

void function SetOverlay( var menu, bool val )
{
	if ( menu == null )
		return

	uiGlobal.menuData[ menu ].isOverlay = val
}


void function SetClearBlur( var menu, bool val )
{
	uiGlobal.menuData[ menu ].clearBlur = val
}


void function SetPanelClearBlur( var panel, bool val )
{
	uiGlobal.panelData[ panel ].panelClearBlur = val
}


bool function IsDialog( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isDialog
}


bool function IsPopup( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isPopup
}

bool function IsOverlay( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isOverlay
}

bool function ShouldClearBlur( var menu )
{
	if ( menu == null )
		return true

	return uiGlobal.menuData[ menu ].clearBlur
}


void function SetGamepadCursorEnabled( var menu, bool val )
{
	uiGlobal.menuData[ menu ].gamepadCursorEnabled = val
}


bool function IsGamepadCursorEnabled( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].gamepadCursorEnabled
}


void function UpdateGamepadCursorEnabledThread()
{
	for ( ; ; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( IsGamepadCursorEnabled( GetActiveMenu() ) )
			ShowGameCursor()
		else
			HideGameCursor()
	}
}


bool function IsDialogOnlyActiveMenu()
{
	if ( !IsDialog( GetActiveMenu() ) )
		return false

	array<var> menuStack = MenuStack_GetCopy()
	int stackLen = menuStack.len()
	if ( stackLen < 1 )
		return false

	if ( menuStack[stackLen - 1] != GetActiveMenu() )
		return false

	if ( stackLen == 1 )
		return true

	if ( menuStack[stackLen - 2] == null )
		return true

	return false
}


void function AddCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( !file.partyUpdatedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyUpdated" )
	file.partyUpdatedCallbacks.append( callbackFunc )
}

void function AddCallbackAndCallNow_OnPartyUpdated( void functionref() callbackFunc )
{
	AddCallback_OnPartyUpdated( callbackFunc )
	callbackFunc()
}

void function RemoveCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( file.partyUpdatedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partyUpdatedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_PartyUpdated()
{
	foreach ( callbackFunc in file.partyUpdatedCallbacks )
		callbackFunc()

	if ( CanShowNotification() )
		ShowNotification()

	if ( AmIPartyLeader() )
	{
		string activeSearchingPlaylist = GetActiveSearchingPlaylist()
		if ( activeSearchingPlaylist != "" && !CanPlaylistFitPartySize( activeSearchingPlaylist, GetPartySize(), IsSendOpenInviteTrue() ) )
			CancelMatchSearch()

		if ( LobbyPlaylist_GetSelectedPlaylist() == PRIVATE_MATCH_PLAYLIST && GetPartySize() > PRIVATE_MATCH_MAX_PARTY_SIZE )
			LobbyPlaylist_SetSelectedPlaylist( GetDefaultPlaylist() )
	}

	if ( IsFullyConnected() )
	{
		
		Party myParty = GetParty()

		int partyMemberCount = myParty.members.len()
		if ( AreWeMatchmaking() && partyMemberCount < file.partyMemberCount )
		{
			CancelMatchSearch()
			EmitUISound( "UI_Menu_ReadyUp_Cancel_1P" )
		}

		file.partyMemberCount = partyMemberCount
	}
}

bool function CanShowNotification()
{





	return IsLobby()
}

bool function HasCallback_OnPartyMemberRemoved( void functionref() callbackFunc )
{
	return file.partymemberRemovedCallbacks.contains( callbackFunc )
}

void function AddCallback_OnPartyMemberRemoved( void functionref() callbackFunc )
{
	Assert( !file.partymemberRemovedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyMemberRemoved" )
	file.partymemberRemovedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyMemberRemoved( void functionref() callbackFunc )
{
	Assert( file.partymemberRemovedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partymemberRemovedCallbacks.fastremovebyvalue( callbackFunc )
}


void function AddCallback_OnPartyMemberAdded( void functionref() callbackFunc )
{
	Assert( !file.partymemberAddedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyMemberAdded" )
	file.partymemberAddedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyMemberAdded( void functionref() callbackFunc )
{
	Assert( file.partymemberAddedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partymemberAddedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_PartyMemberAdded()
{
	
	foreach ( callbackFunc in file.partymemberAddedCallbacks )
		callbackFunc()
}

void function UICodeCallback_PartySpectateSlotUnavailableWaitlisted()
{
	foreach ( callbackFunc in file.partySpectateSlotUnavailableWaitlistedCallbacks )
		callbackFunc()
}

function AddCallback_PartySpectateSlotUnavailableWaitlisted( void functionref() callbackFunc )
{
	Assert( !file.partySpectateSlotUnavailableWaitlistedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_PartySpectateSlotUnavailableWaitlistedCallbacks" )
	file.partySpectateSlotUnavailableWaitlistedCallbacks.append( callbackFunc )
}

function RemoveCallback_PartySpectateSlotUnavailableWaitlisted( void functionref() callbackFunc )
{
	Assert( file.partySpectateSlotUnavailableWaitlistedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partySpectateSlotUnavailableWaitlistedCallbacks.fastremovebyvalue( callbackFunc )
}

void function UICodeCallback_PartySpectateSlotAvailable()
{
	foreach ( callbackFunc in file.partySpectateSlotAvailableCallbacks )
		callbackFunc()
}

function AddCallback_PartySpectateSlotAvailable( void functionref() callbackFunc )
{
	Assert( !file.partySpectateSlotAvailableCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_PartySpectateSlotAvailable" )
	file.partySpectateSlotAvailableCallbacks.append( callbackFunc )
}

function RemoveCallback_PartySpectateSlotAvailable( void functionref() callbackFunc )
{
	Assert( file.partySpectateSlotAvailableCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partySpectateSlotAvailableCallbacks.fastremovebyvalue( callbackFunc )
}

void function UICodeCallback_PartyMemberRemoved()
{
	
	foreach ( callbackFunc in file.partymemberRemovedCallbacks )
		callbackFunc()
}


void function UICodeCallback_UserInfoUpdated( string hardware, string uid )
{
	
	foreach ( callbackFunc in file.userInfoChangedCallbacks )
	{
		callbackFunc( hardware, uid )
	}
}


void function UICodeCallback_UIScriptResetComplete()
{
	printf( "UICodeCallback_UIScriptResetComplete()" )
	ShGRX_UIScriptResetComplete()
	ImagePakLoad_UIScriptResetComplete()

	
	if ( IsLobby() && CanRunClientScript() )
		RunClientScript( "UICallback_MenuModels_UIScriptHasReset" )
}


void function UICodeCallback_CustomMatchLobbyJoin( bool joinSucceeded, string playerToken )
{
	if ( joinSucceeded && IsLobby() )
	{
		if ( !MenuStack_Contains( GetMenu( "CustomMatchLobbyMenu" ) ) )
		{
			CloseActiveMenu()
			AdvanceMenu( GetMenu( "CustomMatchLobbyMenu" ) )
		}
		printf( "DBG - Custom Match Player Token: %s", playerToken )
	}
}


void function UICodeCallback_CustomMatchDataChanged( CustomMatch_LobbyState data )
{
	CustomMatch_DataChanged( data )
}


void function UICodeCallback_CustomMatchStats( int endTime, CustomMatch_MatchSummary summary )
{
	CustomMatch_PushMatchStats( endTime, summary )
	printf( "DBG - UICodeCallback_CustomMatchStats endTime: %i", endTime )
}


void function AddCallbackAndCallNow_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( !file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.append( callbackFunc )

	callbackFunc( "", "" )
}


void function RemoveCallback_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_KeyBindOverwritten( string key, string oldBinding, string newBinding )
{
	AddKeyBindEvent( key, newBinding, oldBinding )
	
}


void function UICodeCallback_KeyBindSet( string key, string newBinding )
{
	foreach ( callbackFunc in uiGlobal.keyBindSetCallbacks )
	{
		callbackFunc( key, newBinding )
	}

	AddKeyBindEvent( key, newBinding )
}


void function AddUICallback_OnResolutionChanged( void functionref() callbackFunc )
{
	Assert( !uiGlobal.resolutionChangedCallbacks.contains( callbackFunc ) )
	uiGlobal.resolutionChangedCallbacks.append( callbackFunc )
}


void function AddCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
	{
		file.topLevelCustomizeContextChangedCallbacks[ panel ] <- [ callbackFunc ]
		return
	}
	else
	{
		Assert( !file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomizeContextChanged for panel " + Hud_GetHudName( panel ) )
		file.topLevelCustomizeContextChangedCallbacks[ panel ].append( callbackFunc )
	}
}


void function RemoveCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	Assert( panel in file.topLevelCustomizeContextChangedCallbacks )
	Assert( file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Callback " + string( callbackFunc ) + " for panel " + Hud_GetHudName( panel ) + " doesn't exist" )
	file.topLevelCustomizeContextChangedCallbacks[ panel ].fastremovebyvalue( callbackFunc )
}


bool function IsTopLevelCustomizeContextValid()
{
	return (file.topLevelCustomizeContext != null)
}


ItemFlavor function GetTopLevelCustomizeContext()
{
	Assert( file.topLevelCustomizeContext != null, "Tried using GetCustomizeContext() when it wasn't set to a valid value." )

	return expect ItemFlavor( file.topLevelCustomizeContext )
}


void function SetTopLevelCustomizeContext( ItemFlavor ornull item )
{
	file.topLevelCustomizeContext = item

	array<var> panels = []
	var activeMenu    = GetActiveMenu()
	if ( activeMenu != null )
		panels.append( activeMenu )
	panels.extend( uiGlobal.activePanels )

	foreach ( panel in panels )
	{
		if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
			continue

		foreach ( callbackFunc in file.topLevelCustomizeContextChangedCallbacks[ panel ] )
			callbackFunc( panel )
	}
}

void function AddUICallback_LevelLoadingFinished( void functionref() callback )
{
	file.levelLoadingFinishedCallbacks.append( callback )
}


void function AddUICallback_LevelShutdown( void functionref() callback )
{
	file.levelShutdownCallbacks.append( callback )
}


void function ButtonClass_AddMenu( var menu )
{
	array<var> buttons = GetElementsByClassname( menu, "MenuButton" )
	foreach ( button in buttons )
	{
		InitButtonRCP( button )
	}
}


void function InitButtonRCP( var button )
{
	UIScaleFactor scaleFactor = GetContentScaleFactor( GetMenu( "MainMenu" ) )
	int width                 = int( float( Hud_GetWidth( button ) ) / scaleFactor.x )
	int height                = int( float( Hud_GetHeight( button ) ) / scaleFactor.y )
	RuiSetFloat2( Hud_GetRui( button ), "actualRes", <width, height, 0> )
}


void function SetLastMenuNavDirection( bool val )
{
	file.lastMenuNavDirection = val
}


bool function GetLastMenuNavDirection()
{
	return file.lastMenuNavDirection
}


void function ClientToUI_SetCommsMenuOpen( bool state )
{
	file.commsMenuOpen = state
}


bool function IsCommsMenuOpen()
{
	return file.commsMenuOpen
}


void function SetModeSelectMenuOpen( bool val )
{
	file.modeSelectMenuOpen = val
}


bool function IsModeSelectMenuOpen()
{
	return file.modeSelectMenuOpen
}


void function SetShowingMap( bool val )
{
	file.isShowingMap = val
}


bool function IsShowingMap()
{
	return file.isShowingMap
}

void function SetIsSelfClosingMenu( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isSelfClosing = val
}

bool function IsSelfClosingMenu( var menu )
{
	if ( menu != null )
	{
		return uiGlobal.menuData[ menu ].isSelfClosing
	}
	return false
}


void function IncrementNumDialogFlowDialogsDisplayed()
{
	file.numDialogFlowDialogsDisplayed++
}


void function EnterLobbySurveyReset()
{
	file.numDialogFlowDialogsDisplayed = 0
}



void function TEMP_CircularReferenceCleanup()
{
	if ( !file.TEMP_circularReferenceCleanupEnabled )
		return

	collectgarbage()
}

#if DEV
bool function AutomateUi(float delayFactor = 1)
{
	if ( !GetConVarBool( "ui_automation_enabled" ) )
	{
		return false
	}

	float timeNow = UITime()
	if ( file.uiAutomationLastTime == 0 )
	{
		file.uiAutomationLastTime = timeNow
	}
	file.uiAutomationExpiredTime += (timeNow - file.uiAutomationLastTime);
	file.uiAutomationLastTime = timeNow

	file.uiAutomationCount++

	var currentActiveMenu = GetActiveMenu()
	var currentTopActivePanel = null
	if ( uiGlobal.activePanels.len() > 0 )
	{
		currentTopActivePanel = uiGlobal.activePanels.top()
	}

	if (( file.uiAutomationCurrentMenu != currentActiveMenu ) || ( file.uiAutomationTopActivePanel != currentTopActivePanel ))
	{
		file.uiAutomationCurrentMenu = currentActiveMenu
		file.uiAutomationTopActivePanel = currentTopActivePanel
		file.uiAutomationExpiredTime = 0
	}

	if ( IsConnected() && AreWeMatchmaking() )
	{
		file.uiAutomationExpiredTime = 0
		return false
	}

	if ( file.uiAutomationExpiredTime > delayFactor * GetConVarFloat( "ui_automation_delay_s" ) )
	{
		file.uiAutomationExpiredTime = 0
		return true
	}

	return false
}

bool function AutomateUiWaitForPostmatch()
{
	return GetConVarBool( "ui_automation_wait_for_postmatch" )
}

bool function AutomateUiRequeue()
{
	return GetConVarBool( "ui_automation_requeue" )
}
#endif
