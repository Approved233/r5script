global function InitDeathScreenSpectatePanel
global function UI_UpdateDeathScreenSpectatePanel



global function UI_InitFreespawnPrompt
global function UI_Freespawns_LockoutTimer_Set
global function UI_Freespawns_LockoutTime_AggroReward_Give
global function UI_Freespawns_LockoutTime_AggroReward_Notification
global function UI_Freespawns_LockoutStartTime_SetNow

global function FreespawnPrompt_SetVisible
global function FreespawnPrompt_SetDisabled
global function FreespawnPrompt_SetText
global function FreespawnPrompt_SetColor
global function UI_Freespawns_SetEnabled

global function FreespawnPrompt_KillUpdateThread

const float LOCKOUTTIME_FINISHED = 0.01
const float NOTIFY_DURATION = 3.0



struct
{
	var panel


	var freespawnPrompt
	float lockoutStartTime = 0.0
	bool freespawnPromptDisabled = true

	float freespawnsV2_LockoutTimer = 20.0

	bool freespawns_Enabled = true
	bool freespawnPrompt_ProgressPastDisable = false

	string aggroRewardNotification
	vector aggroRewardNotification_Color


} file

void function InitDeathScreenSpectatePanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SpectateOnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SpectateOnClosePanel )

	SetPanelClearBlur( panel, true )


		file.freespawnPrompt = Hud_GetChild( panel, "FreespawnPrompt" )
		RegisterSignal( "ResetFreespawnPrompt" )
		RegisterSignal( "FreespawnAggroRewardShow" )


	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SPECTATE)
}


void function UI_InitFreespawnPrompt()
{
	bool freerespawns_feature_exists = FreeRespawns_Feature_Exists()

#if DEV
		printt( FUNC_NAME() + "(): FreeRespawns_Feature_Exists() == " + freerespawns_feature_exists )
		printt( FUNC_NAME() + "(): file.freespawns_Enabled == " + file.freespawns_Enabled )
#endif

	if( !freerespawns_feature_exists )
		return

	if( !file.freespawns_Enabled )
		return

	file.freespawnPrompt_ProgressPastDisable = Freespawns_PLV_LockoutTime_Progress_PastDisable()

	UI_Freespawns_LockoutStartTime_SetNow()

	FreespawnPrompt_SetDisabled( true )
	FreespawnPrompt_SetVisible( true )
	FreespawnPrompt_SetColor( FREESPAWN_PROMPT_COLOR )

	thread UpdateFreespawnPrompt_Thread()
}

void function UI_Freespawns_LockoutStartTime_SetNow( float startTimeParm = -1 )
{
	float startTime = startTimeParm > 0 ? startTimeParm : ClientTime()

#if DEV
		printt( FUNC_NAME() + "(): Lockout Timer Start: " + startTime )
#endif

	file.lockoutStartTime = startTime
}

void function UI_Freespawns_LockoutTimer_Set( float newTime )
{
#if DEV
		printt( FUNC_NAME() + "(): Lockout Timer Set: " + newTime )
#endif
	file.freespawnsV2_LockoutTimer = max( LOCKOUTTIME_FINISHED , newTime )
}


void function UI_Freespawns_LockoutTime_AggroReward_Give( int aggroType )
{
	float modTime = Freespawns_AggroReward_Get_ByType( aggroType )
#if DEV
		printt( FUNC_NAME() + "(): AggroReward Given for index " + aggroType )
		printt( FUNC_NAME() + "(): AggroReward == " + modTime )
#endif

	file.freespawnsV2_LockoutTimer += modTime
	file.freespawnsV2_LockoutTimer = max( LOCKOUTTIME_FINISHED, file.freespawnsV2_LockoutTimer )

	if( modTime != 0.0 )
	{
		
		UI_Freespawns_LockoutTime_AggroReward_Notification( aggroType )
	}
}

void function UI_Freespawns_LockoutTime_AggroReward_Notification( int aggroType )
{
	float modTime = Freespawns_AggroReward_Get_ByType( aggroType )
	table< int, string > aggroRewardStrings
	aggroRewardStrings[ eFreespawns_AggroType.DAMAGE_CHUNK ] 	<- "#FREESPAWNSV3_AGGRO_DAMAGECHUNK_SHORT"
	aggroRewardStrings[ eFreespawns_AggroType.DOWNED_ENEMY ] 	<- "#FREESPAWNSV3_AGGRO_DOWNEDENEMY_SHORT"
	aggroRewardStrings[ eFreespawns_AggroType.KILLED_ENEMY ] 	<- "#FREESPAWNSV3_AGGRO_KILLEDENEMY_SHORT"
	aggroRewardStrings[ eFreespawns_AggroType.EXECUTED_ENEMY ] 	<- "#FREESPAWNSV3_AGGRO_EXECUTEDENEMY_SHORT"
	aggroRewardStrings[ eFreespawns_AggroType.PENALTY_ALLYDEATH ] <- "#FREESPAWNSV3_AGGRO_PENALTY_ALLYDEATH_SHORT"

	table< int, vector > aggroRewardColors
	aggroRewardColors[ eFreespawns_AggroType.DAMAGE_CHUNK ] <- FREESPAWN_AGRROREWARD_COLOR
	aggroRewardColors[ eFreespawns_AggroType.DOWNED_ENEMY ] <- FREESPAWN_AGRROREWARD_COLOR
	aggroRewardColors[ eFreespawns_AggroType.KILLED_ENEMY ] <- FREESPAWN_AGRROREWARD_COLOR
	aggroRewardColors[ eFreespawns_AggroType.EXECUTED_ENEMY ] <- FREESPAWN_AGRROREWARD_COLOR
	aggroRewardColors[ eFreespawns_AggroType.PENALTY_ALLYDEATH ] <- FREESPAWN_AGGROREWARD_PENALTY_COLOR

	string aggroRewardStringToUse = aggroRewardStrings[ aggroType ]
	if( aggroType == eFreespawns_AggroType.DAMAGE_CHUNK )
	{
		aggroRewardStringToUse = Localize( aggroRewardStringToUse, Freespawns_PLV_AggroRewards_DamageChunk_Threshold(), modTime )
	}
	else
	{
		aggroRewardStringToUse = Localize( aggroRewardStringToUse, modTime )
	}

	file.aggroRewardNotification_Color = aggroRewardColors[ aggroType ]

	thread UI_Freespawns_LockoutTime_AggroReward_Notification_Thread( aggroRewardStringToUse, NOTIFY_DURATION )
}

void function UI_Freespawns_LockoutTime_AggroReward_Notification_Thread( string aggroRewardString, float duration )
{
	Signal( uiGlobal.signalDummy, "FreespawnAggroRewardShow" )
	EndSignal( uiGlobal.signalDummy, "FreespawnAggroRewardShow" )

#if DEV
		printt( FUNC_NAME() + "(): *** aggroRewardString == " + aggroRewardString )
#endif

	file.aggroRewardNotification = aggroRewardString
	EmitUISound( "Survival_Freespawn_TokenCountdownUpdate_1P" )

	wait( duration )

	file.aggroRewardNotification = ""

#if DEV
		printt( FUNC_NAME() + "(): *** aggroRewardString Cleared of " + aggroRewardString )
#endif
}

void function FreespawnPrompt_OnActivate( var Prompt )
{
	if ( file.freespawnPromptDisabled )
		return

	FreespawnPrompt_Activated()
}

void function FreespawnPrompt_Activated()
{
	FreespawnPrompt_SetVisible( false )
	FreespawnPrompt_SetDisabled( true )
}

void function FreespawnPrompt_KillUpdateThread()
{
	Signal( uiGlobal.signalDummy, "ResetFreespawnPrompt" )
}

void function UpdateFreespawnPrompt_Thread()
{
	Signal( uiGlobal.signalDummy, "ResetFreespawnPrompt" )
	EndSignal( uiGlobal.signalDummy, "ResetFreespawnPrompt" )

	WaitFrame() 
	float lockoutTimer = file.freespawnsV2_LockoutTimer

#if DEV
		printt( FUNC_NAME() + "(): Lockout Timer == " + lockoutTimer )
#endif

	bool LastSecondsCountdown_Initiated = false

	while (( lockoutTimer > LOCKOUTTIME_FINISHED  ) && ( FreespawnPrompt_CanDo() ))
	{
		float lockoutTimeTotal = file.freespawnsV2_LockoutTimer
		string promptText
		{
			promptText = file.aggroRewardNotification
			FreespawnPrompt_SetColor( file.aggroRewardNotification_Color )
			FreespawnPrompt_SetText( promptText )
		}

		float startTime = file.lockoutStartTime
		float time = ClientTime()
		float timePassed = time - startTime
		float frac = 1 - timePassed / lockoutTimeTotal
		lockoutTimer = lockoutTimeTotal * frac

		float timeLeft = lockoutTimeTotal - timePassed

		WaitFrame()
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	

	

	FreespawnPrompt_SetText( "" )
	FreespawnPrompt_SetDisabled( true )
	FreespawnPrompt_SetVisible( false )
}

bool function FreespawnPrompt_CanDo()
{
	return( file.freespawns_Enabled || file.freespawnPrompt_ProgressPastDisable )
}

void function FreespawnPrompt_SetVisible( bool visible )
{
	if ( file.freespawnPrompt == null )
		return

	if( !visible )
	{
		FreespawnPrompt_SetText( "" )
	}
	Hud_SetVisible( file.freespawnPrompt, visible )
}

void function FreespawnPrompt_SetDisabled( bool disabled )
{
	file.freespawnPromptDisabled = disabled
}

void function FreespawnPrompt_SetText( string text )
{
	if ( file.freespawnPrompt == null )
		return

	var btnRui = Hud_GetRui( file.freespawnPrompt )

	if ( !RuiIsAlive( btnRui ) )
		return

	RuiSetString( btnRui, "promptText", text )

	RuiSetGameTime( btnRui, "startTime", ClientTime() )
	RuiSetFloat( btnRui, "duration", NOTIFY_DURATION )
}

void function FreespawnPrompt_SetColor( vector color )
{
	if ( file.freespawnPrompt == null )
		return

	var btnRui = Hud_GetRui( file.freespawnPrompt )

	if ( !RuiIsAlive( btnRui ) )
		return

	RuiSetColorAlpha( btnRui, "style1Color", color, 1.0 )
}

void function UI_Freespawns_SetEnabled( bool isOn )
{
	file.freespawns_Enabled = isOn
}



void function SpectateOnOpenPanel( var panel )
{
	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	RunClientScript( "UICallback_ShowSpectateTab", headerElement )

	RegisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	RegisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )

	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, DeathScreenTryToggleUpgradesOnGladCard )
	RegisterButtonPressedCallback( KEY_V, DeathScreenTryToggleUpgradesOnGladCard )

	RegisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	RegisterButtonPressedCallback( GetPCReportKey(), DeathScreenOnReportButtonClick )
	
	RegisterButtonPressedCallback( MOUSE_MIDDLE, DeathScreenSpectateNext )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenSpectateNext )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenSpectateNext )


	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, FreespawnPrompt_OnActivate )
	RegisterButtonPressedCallback( KEY_B, FreespawnPrompt_OnActivate )


	if ( GetTeamSize( GetTeam() ) > 3)
	{
		Hud_SetY( Hud_GetChild( panel, "LobbyChatBox" ), 0 )
	}

	UpdateFooterOptions()

	DeathScreenUpdateCursor()
}


void function UI_UpdateDeathScreenSpectatePanel()
{
	var menu = GetParentMenu( file.panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	RunClientScript( "UICallback_ShowSpectateTab", headerElement )
}


void function SpectateOnClosePanel( var panel )
{
	DeregisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	DeregisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )

	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, DeathScreenTryToggleUpgradesOnGladCard )
	DeregisterButtonPressedCallback( KEY_V, DeathScreenTryToggleUpgradesOnGladCard )

	DeregisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	DeregisterButtonPressedCallback( GetPCReportKey(), DeathScreenOnReportButtonClick )
	
	DeregisterButtonPressedCallback( MOUSE_MIDDLE, DeathScreenSpectateNext )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenSpectateNext )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenSpectateNext )


	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, FreespawnPrompt_OnActivate )
	DeregisterButtonPressedCallback( KEY_B, FreespawnPrompt_OnActivate )

}
