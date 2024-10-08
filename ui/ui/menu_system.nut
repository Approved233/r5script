global function InitSystemMenu
global function UpdateSystemMenu
global function OpenSystemMenu

global function ShouldDisplayOptInOptions
global function EnableCharacterChangeInFiringRange
global function SetFiringRangeChallengeInProgress
global function IsOptInEnabled

#if DEV
global function ToggleOptIn
global function SetOptIn
#endif


global function RangeCustomizationMenu


struct ButtonData
{
	string             label
	void functionref() activateFunc
}

struct
{
	var menu

	array<var>        buttons
	array<ButtonData> buttonDatas

	ButtonData settingsButtonData
	ButtonData leaveMatchButtonData
	ButtonData endMatchButtonData
	ButtonData exitButtonData
	ButtonData lobbyReturnButtonData
	ButtonData nullButtonData
	ButtonData leavePartyData
	ButtonData leaveCustomMatchData
	ButtonData abandonMissionButtonData
	ButtonData changeCharacterButtonData
	ButtonData friendlyFireButtonData
	ButtonData leaveChallengButtoneData

		ButtonData rangeCustomizationButtonData

	ButtonData suicideButtonData

	bool enableChangeCharacterButton = true
	bool challengeInProgress = false

	InputDef& qaFooter
	bool isOptInEnabled = false
} file

void function InitSystemMenu( var newMenuArg ) 
{
	var menu = GetMenu( "SystemMenu" )
	Hud_SetAboveBlur( menu, true )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSystemMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSystemMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSystemMenu_NavigateBack )


	file.buttons = GetElementsByClassname( menu, "SystemButtonClass" )
	file.buttonDatas.resize( file.buttons.len() )

	foreach ( index, button in file.buttons )
	{
		SetButtonData( index, file.nullButtonData )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}

	file.settingsButtonData.label = "#SETTINGS"
	file.settingsButtonData.activateFunc = OpenSettingsMenu


		file.rangeCustomizationButtonData.label = "#BUTTON_RANGE_CUSTOMIZE"
		file.rangeCustomizationButtonData.activateFunc = RangeCustomizationMenu


	file.leaveMatchButtonData.label = "#LEAVE_MATCH"
	file.leaveMatchButtonData.activateFunc = LeaveDialog

	file.endMatchButtonData.label = "#TOURNAMENT_END_MATCH"
	file.endMatchButtonData.activateFunc = EndMatchDialog

	file.exitButtonData.label = "#EXIT_TO_DESKTOP"
	file.exitButtonData.activateFunc = OpenConfirmExitToDesktopDialog

	file.lobbyReturnButtonData.label = "#RETURN_TO_LOBBY"
	file.lobbyReturnButtonData.activateFunc = LeaveDialog

	file.leavePartyData.label = "#LEAVE_PARTY"
	file.leavePartyData.activateFunc = LeavePartyDialog

	file.leaveCustomMatchData.label = "#CUSTOMMATCH_LEAVE"
	file.leaveCustomMatchData.activateFunc = LeaveCustomMatchDialog

	file.abandonMissionButtonData.label = "#QUEST_LEAVE_MATCH"
	file.abandonMissionButtonData.activateFunc = LeaveDialog

	file.changeCharacterButtonData.label = "#BUTTON_CHARACTER_CHANGE"
	file.changeCharacterButtonData.activateFunc = TryChangeCharacters

	file.leaveChallengButtoneData.label = "#LEAVE_CHALLENGE"
	file.leaveChallengButtoneData.activateFunc = TryLeaveChallenge

	file.friendlyFireButtonData.label = "#BUTTON_FRIENDLY_FIRE_TOGGLE"
	file.friendlyFireButtonData.activateFunc = ToggleFriendlyFire

	file.suicideButtonData.label = "#BUTTON_SUICIDE"
	file.suicideButtonData.activateFunc = TryRespawnAndChangeCharacters


	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

#if DEV
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_DEV_MENU", "#DEV_MENU", OpenDevMenu )
#else
		if ( GetConVarBool( "cl_ezlaunch_button" ) )
	 		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "EZ Launch", "EZ Launch", RunEZLaunch, ShouldDisplayOptInOptions )
#endif

	file.qaFooter = AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_QA", "QA", ToggleOptIn, ShouldDisplayOptInOptions )





		AddMenuFooterOption( menu, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_VIEW_CINEMATIC", "", ViewCinematic, CanViewCinematic )
		AddMenuFooterOption( menu, RIGHT, KEY_V, true, "", "#BUTTON_VIEW_CINEMATIC", ViewCinematic, CanViewCinematic )

		AddMenuFooterOption( menu, RIGHT, BUTTON_STICK_LEFT, true, "#BUTTON_VIEW_WELCOME_TRAILER", "", ViewWelcomeCinematic, IsLobby )
		AddMenuFooterOption( menu, RIGHT, KEY_B, true, "", "#BUTTON_VIEW_WELCOME_TRAILER", ViewWelcomeCinematic, IsLobby )


	AddMenuFooterOption( menu, RIGHT, BUTTON_BACK, true, "#BUTTON_RETURN_TO_MAIN", "", ReturnToMain_OnActivate, IsLobby )
	AddMenuFooterOption( menu, RIGHT, KEY_R, true, "", "#BUTTON_RETURN_TO_MAIN", ReturnToMain_OnActivate, IsLobby )
}

bool function CanViewCinematic()
{
	return HasSeasonalVideo() && IsLobby()
}

void function ViewWelcomeCinematic( var button )
{
	CloseActiveMenu()

	bool isEnglishLang = GetLanguage() == "english"

	VideoPlaySettings settings
	settings.video = isEnglishLang ? WELCOME_VIDEO : WELCOME_INT_VIDEO
	settings.milesAudio = WELCOME_AUDIO_EVENT
	settings.forceSubtitles = !isEnglishLang

	thread PlayVideoMenu( false, settings )
}

void function ViewCinematic( var button )
{
	CloseActiveMenu()

	VideoPlaySettings settings
	settings.video = GetIntroVideo()
	settings.milesAudio = GetIntroAudioEvent()
	settings.forceSubtitles = GetLanguage() != "english"

	thread PlayVideoMenu( false, settings )
}

void function TryChangeCharacters()
{
	if ( !file.enableChangeCharacterButton )
		return

	RunClientScript( "UICallback_OpenCharacterSelectMenu" )
}

void function TryLeaveChallenge()
{
	Remote_ServerCallFunction( "FRC_ClientToServer_TryLeaveChallenge" )
}

void function ToggleFriendlyFire()
{
	Remote_ServerCallFunction( "UCB_SV_FRSetting_FriendlyFire_Toggle" )
}


void function RangeCustomizationMenu()
{
	OpenSurvivalInventoryMenu( 2 )
}


void function TryRespawnAndChangeCharacters()
{
	RunClientScript( "UICallback_DieAndChangeCharacters" )
}

void function EnableCharacterChangeInFiringRange( bool enable )
{
	file.enableChangeCharacterButton = enable
	UpdateSystemMenu()
}

void function SetFiringRangeChallengeInProgress( bool isInProgress )
{
	file.challengeInProgress = isInProgress
}

void function OnSystemMenu_Open()
{
	UpdateSystemMenu()
	SetBlurEnabled( true )

	UpdateOptInFooter()
}

void function UpdateSystemMenu()
{
	foreach ( index, button in file.buttons )
		SetButtonData( index, file.nullButtonData )

	int buttonIndex = 0
	if ( IsConnected() && !IsLobby() )
	{
		
		SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

		SetButtonData( buttonIndex++, file.settingsButtonData )

		if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
		{

				if ( FiringRangeHasInfiniteClips() )
					SetButtonData( buttonIndex++, file.rangeCustomizationButtonData )





			if ( file.enableChangeCharacterButton )
				SetButtonData( buttonIndex++, file.changeCharacterButtonData )

			if( file.challengeInProgress )
				SetButtonData( buttonIndex++, file.leaveChallengButtoneData )

		}

		int gameState = GetGameState()
		{
			if ( IsPVEMode() )
			{
				SetButtonData( buttonIndex++, file.abandonMissionButtonData )
			}
			else if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_TRAINING ) || GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
			{
				SetButtonData( buttonIndex++, file.lobbyReturnButtonData )
			}
			else if( !MenuStack_Contains( GetMenu( "CharacterSelectMenu" ) )



			)
			{
				SetButtonData( buttonIndex++, file.leaveMatchButtonData )
			}
		}


		bool playingOrSuddenDeath = ( gameState == eGameState.Playing )  || ( gameState == eGameState.SuddenDeath )
		if ( IsPrivateMatch() && HasMatchAdminRole() && playingOrSuddenDeath )
			SetButtonData( buttonIndex++, file.endMatchButtonData )


			if ( GameMode_IsActive( eGameModes.CONTROL ) && gameState == eGameState.Playing && GetTeam() != TEAM_UNASSIGNED && GetTeam() != TEAM_SPECTATOR )
				SetButtonData( buttonIndex++, file.suicideButtonData )

	}
	else
	{
		if ( AmIPartyMember() || AmIPartyLeader() && GetPartySize() > 1 )
			SetButtonData( buttonIndex++, file.leavePartyData )

		if ( MenuStack_Contains( GetMenu( "CustomMatchLobbyMenu" ) ) )
			SetButtonData( buttonIndex++, file.leaveCustomMatchData )

		SetButtonData( buttonIndex++, file.settingsButtonData )

			SetButtonData( buttonIndex++, file.exitButtonData )


		if ( IsPrivateMatchLobby() && !MenuStack_Contains( GetMenu( "CharacterSelectMenu" ) )



		)
			SetButtonData( buttonIndex++, file.leaveMatchButtonData )
	}

	const int maxNumButtons = 4;
	for( int i = 0; i < maxNumButtons; i++ )
	{
		if( i > 0 && i < buttonIndex)
			Hud_SetNavUp( file.buttons[i], file.buttons[i - 1] )
		else
			Hud_SetNavUp( file.buttons[i], file.buttons[ minint(maxNumButtons, buttonIndex) - 1 ] )

		if( i < (buttonIndex - 1) )
			Hud_SetNavDown( file.buttons[i], file.buttons[i + 1] )
		else
			Hud_SetNavDown( file.buttons[i], null )
	}

	var dataCenterElem = Hud_GetChild( file.menu, "DataCenter" )
	Hud_SetText( dataCenterElem, Localize( "#SYSTEM_DATACENTER", GetMatchDatacenterName(), GetMatchDatacenterPing(), GetDatacenterSelectedReasonSymbol() ) )
}


void function SetButtonData( int buttonIndex, ButtonData buttonData )
{
	file.buttonDatas[buttonIndex] = buttonData

	var rui = Hud_GetRui( file.buttons[buttonIndex] )
	RHud_SetText( file.buttons[buttonIndex], buttonData.label )

	if ( buttonData.label == "" )
		Hud_SetVisible( file.buttons[buttonIndex], false )
	else
		Hud_SetVisible( file.buttons[buttonIndex], true )
}


void function OnSystemMenu_Close()
{













}


void function OnSystemMenu_NavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
}


void function OnButton_Activate( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	int buttonIndex = int( Hud_GetScriptID( button ) )

	file.buttonDatas[buttonIndex].activateFunc()
}

void function OpenSystemMenu()
{
	AdvanceMenu( file.menu )
}

void function OpenSettingsMenu()
{
	AdvanceMenu( GetMenu( "MiscMenu" ) )
}


void function ReturnToMain_OnActivate( var button )
{
	ConfirmDialogData data
	data.headerText = "#EXIT_TO_MAIN"
	data.messageText = ""
	data.resultCallback = OnReturnToMainMenu
	

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnReturnToMainMenu( int result )
{
	if ( result == eDialogResult.YES )
	{
		LeaveMatch()
		ClientCommand( "disconnect" )
	}
}


void function ToggleOptIn( var button )
{
	file.isOptInEnabled = !file.isOptInEnabled

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function SetOptIn( bool state )
{
	file.isOptInEnabled = state
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function RunEZLaunch( var _ )
{
	ClientCommand( "ezlaunch" )

	CloseActiveMenu()
}

bool function ShouldDisplayOptInOptions()
{
	if ( !IsFullyConnected() )
		return false

	if ( GRX_IsInventoryReady() && (GRX_HasItem( GRX_DEV_ITEM ) || GRX_HasItem( GRX_QA_ITEM )) )
		return true

	return GetGlobalNetBool( "isOptInServer" )
}


void function UpdateOptInFooter()
{
	if ( file.isOptInEnabled )
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_HIDE_OPT_IN"
		file.qaFooter.mouseLabel = "#HIDE_OPT_IN"
	}
	else
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_SHOW_OPT_IN"
		file.qaFooter.mouseLabel = "#SHOW_OPT_IN"
	}

	UpdateFooterOptions()
}


bool function IsOptInEnabled()
{
	return file.isOptInEnabled
}