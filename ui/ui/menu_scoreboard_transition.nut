global function InitScoreboardTransition
global function ShowScoreboardTransition
global function HideScoreboardTransition


struct
{
	var menu
	var screenFrame
	
	var screenBlur

	bool useBlur = false
}
file

void function InitScoreboardTransition( var newMenuArg )
{
	var menu = newMenuArg
	SetBlurEnabled( true )

	file.menu = menu
	
	file.screenFrame = Hud_GetChild( file.menu, "ScreenFrame" )
	file.screenBlur = Hud_GetChild( file.menu, "ScreenBlur" )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, ScoreboardTransition_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ScoreboardTransition_OnClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ScoreboardTransition_NavigateBack )
}

void function ScoreboardTransition_OnShow()
{
	SetMouseCursorVisible( false )
	ScoreboardTransition_AnimateIn()
}

void function ScoreboardTransition_OnClose()
{
	SetMouseCursorVisible( true )
}

void function ScoreboardTransition_NavigateBack()
{
	AdvanceMenu( GetMenu( "SystemMenu" ) )
}

void function ScoreboardTransition_AnimateIn()
{
	
	Hud_SetVisible( file.screenBlur, file.useBlur )
	var screenBlurRui = Hud_GetRui( file.screenBlur )

	if( file.useBlur )
	{
		RuiSetWallTimeWithNow( screenBlurRui, "animateStartTime" )
		RuiSetFloat( screenBlurRui, "darkenAlpha", 0.7 )
		RuiSetFloat( screenBlurRui, "alpha", 1.0 )
		
	}
	else
	{
		RuiSetFloat( screenBlurRui, "darkenAlpha", 0.0 )
		RuiSetFloat( screenBlurRui, "alpha", 0.0 )
	}
}

void function ShowScoreboardTransition_Internal()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ShowScoreboardTransition( vector scoreboardMaxSize = < 1920, 1080, 0 >,  vector offset = < 0, 0, 0 >, bool useBlur = true )
{
	file.useBlur = useBlur
	float screenSizeYFrac =  GetScreenSize().height / 1080.0
	
	

	Hud_SetX( file.screenFrame,  offset.x * screenSizeYFrac  )
	Hud_SetY( file.screenFrame,  offset.y * screenSizeYFrac  )

	thread ShowScoreboardTransition_Internal()
}

float TRANSITION_TIME_OUT = 0.15
void function HideScoreboardTransition()
{
	
	RuiSetWallTimeBad(  Hud_GetRui( file.screenBlur ), "animateStartTime" )

	thread function ():( ) {
		wait TRANSITION_TIME_OUT

		CloseMenu( file.menu )
	}()
}