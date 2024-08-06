
global function RTKDirectionalNavigation_OnRootFocused
global function RTKDirectionalNavigation_OnInitialize
global function RTKDirectionalNavigation_OnDestroy
global function RTKDirectionalNavigation_SetOutOfBoundsTopCallback
global function RTKDirectionalNavigation_SetOutOfBoundsBottomCallback
global function RTKDirectionalNavigation_SetOutOfBoundsLeftCallback
global function RTKDirectionalNavigation_SetOutOfBoundsRightCallback
global function RTKDirectionalNavigation_SetNavFailedTopCallback
global function RTKDirectionalNavigation_SetNavFailedBottomCallback
global function RTKDirectionalNavigation_SetNavFailedLeftCallback
global function RTKDirectionalNavigation_SetNavFailedRightCallback
global function RTKDirectionalNavigation_SetEnabled
global function RTKDirectionalNavigation_IsEnabled

global struct RTKDirectionalNavigation_Properties
{
	rtk_panel focusRoot
	rtk_panel visibleRoot
	rtk_panel buttonContainer1 
	rtk_panel buttonContainer2
	bool dpadEnabled = false
	bool rstickEnabled = false
	bool keyboardEnabled = false
	int yPositionFudge = 0
	int xOutOfBoundsFudge = 0
}

struct PrivateData
{
	bool enabled = true
	int focusedButtonIndex = -1
	array<int> keycodesUp
	array<int> keycodesDown
	array<int> keycodesLeft
	array<int> keycodesRight
	array<int> keycodesForward
	array<int> keycodesBack
	array< rtk_behavior > buttons
	void functionref( var button ) navUpFunc
	void functionref( var button ) navDownFunc
	void functionref( var button ) navRightFunc
	void functionref( var button ) navLeftFunc
	void functionref( var button ) navForwardFunc
	void functionref( var button ) navBackFunc
	bool inputRegistered = false
	bool callbacksRegistered = false
	void functionref( ) navFailedTopCallback
	void functionref( ) navFailedBottomCallback
	void functionref( ) navFailedRightCallback
	void functionref( ) navFailedLeftCallback
	void functionref( ) outOfBoundsTopCallback
	void functionref( ) outOfBoundsBottomCallback
	void functionref( ) outOfBoundsRightCallback
	void functionref( ) outOfBoundsLeftCallback
}

struct FileStruct_SessionPersistence
{
	array <rtk_behavior > behaviors
	
}
FileStruct_SessionPersistence& file

void function RTKDirectionalNavigation_OnInitialize( rtk_behavior self )
{
	array< rtk_panel > buttonContainers
	rtk_panel buttonContainer1 = self.PropGetPanel( "buttonContainer1" )
	rtk_panel buttonContainer2 = self.PropGetPanel( "buttonContainer2" )
	if ( buttonContainer1 != null )
	{
		buttonContainers.push( buttonContainer1 )
	}
	if ( buttonContainer2 != null )
	{
		buttonContainers.push( buttonContainer2 )
	}

	foreach( rtk_panel buttonContainer in buttonContainers )
	{
		self.AutoSubscribe( buttonContainer, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {
			RTKDirectionalNavigation_RegisterButtons( self )
			RTKDirectionalNavigation_EnsureChildButtonFocused( self, false )
		} )
	}

	if ( buttonContainers.len() == 0 )
	{
		rtk_panel ornull focusRoot = self.PropGetPanel( "focusRoot" )
		if ( focusRoot != null )
		{
			expect rtk_panel( focusRoot )

			self.AutoSubscribe( focusRoot, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {
				RTKDirectionalNavigation_RegisterButtons( self )
				RTKDirectionalNavigation_EnsureChildButtonFocused( self, false )
			} )
		}
	}

	file.behaviors.push( self )
}

void function RTKDirectionalNavigation_OnDestroy( rtk_behavior self )
{
	RTKDirectionalNavigation_DeregisterGlobalInput( self )
	file.behaviors.fastremovebyvalue( self )
}

void function RTKDirectionalNavigation_SetEnabled( rtk_behavior self, bool enabled )
{
	PrivateData p
	self.Private( p )
	p.enabled = enabled

	if ( !enabled )
	{
		RTKDirectionalNavigation_DeregisterGlobalInput( self )
	}
}

bool function RTKDirectionalNavigation_IsEnabled( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	return p.enabled
}

void function RTKDirectionalNavigation_RegisterButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	p.buttons.clear()

	array< rtk_panel > buttonContainers
	rtk_panel buttonContainer1 = self.PropGetPanel( "buttonContainer1" )
	rtk_panel buttonContainer2 = self.PropGetPanel( "buttonContainer2" )
	if ( buttonContainer1 != null )
	{
		buttonContainers.push( buttonContainer1 )
	}
	if ( buttonContainer2 != null )
	{
		buttonContainers.push( buttonContainer2 )
	}

	foreach( rtk_panel buttonContainer in buttonContainers )
	{
		array< rtk_behavior > childButtons
		RTKDirectionalNavigation_GetAllButtonChildren( self, buttonContainer, childButtons )

		foreach ( int i, button in childButtons )
		{
			p.buttons.push(button)

			
			
			
			
		}
	}

	if ( buttonContainers.len() == 0 )
	{
		rtk_panel ornull focusRoot = self.PropGetPanel( "focusRoot" )
		if ( focusRoot != null )
		{
			expect rtk_panel( focusRoot )

			array< rtk_behavior > childButtons
			RTKDirectionalNavigation_GetAllButtonChildren( self, focusRoot, childButtons )

			foreach ( int i, button in childButtons )
			{
				p.buttons.push( button )

				
				
				
				
			}
		}
	}
}

void function RTKDirectionalNavigation_OnRootFocused( rtk_behavior self, bool invokeEvent = false, bool resetFocusedButton = false )
{
	

	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	foreach( rtk_behavior behavior in file.behaviors)
	{
		RTKDirectionalNavigation_OnRootBlurred( behavior, false )
	}

	if ( resetFocusedButton )
	{
		PrivateData p
		self.Private( p )
		p.focusedButtonIndex = -1
	}

	RTKDirectionalNavigation_RegisterGlobalInput( self )

	RTKDirectionalNavigation_RegisterButtons( self )

	RTKDirectionalNavigation_EnsureChildButtonFocused( self, invokeEvent )

	string eventName = "onFocus"
	array< rtk_behavior > animators = self.GetPanel().FindBehaviorsByTypeName( "Animator" )
	foreach( rtk_behavior animator in animators)
	{
		if ( RTKAnimator_HasAnimation( animator, eventName ) )
			RTKAnimator_PlayAnimation( animator, eventName )
	}
}

void function RTKDirectionalNavigation_OnRootBlurred( rtk_behavior self, bool invokeEvent = false )
{
	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	PrivateData p
	self.Private( p )

	rtk_behavior ornull focusedButtonOrNull = RTKDirectionalNavigation_GetFocusedButton( self )

	if ( focusedButtonOrNull != null)
	{
		rtk_behavior focusedButton = expect rtk_behavior( focusedButtonOrNull )

		string eventName = "onIdle"
		focusedButton.InvokeEvent( eventName, focusedButton, 0 )
		array< rtk_behavior > animators = focusedButton.GetPanel().FindBehaviorsByTypeName( "Animator" )
		foreach( rtk_behavior animator in animators)
		{
			if ( RTKAnimator_HasAnimation( animator, eventName ) )
				RTKAnimator_PlayAnimation( animator, eventName )
		}
	}

	p.buttons.clear()

	RTKDirectionalNavigation_DeregisterGlobalInput( self )

	string eventName = "onBlur"
	array< rtk_behavior > animators = self.GetPanel().FindBehaviorsByTypeName( "Animator" )
	foreach( rtk_behavior animator in animators)
	{
		if ( RTKAnimator_HasAnimation( animator, eventName ) )
			RTKAnimator_PlayAnimation( animator, eventName )
	}
}

void function RTKDirectionalNavigation_RegisterGlobalInput( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.inputRegistered )
		return
	p.inputRegistered = true

	if ( !p.callbacksRegistered )
	{
		
		p.callbacksRegistered = true

		
		p.keycodesUp = []
		p.keycodesDown = []
		p.keycodesLeft = []
		p.keycodesRight = []
		p.keycodesForward = []
		p.keycodesBack = []

		if ( self.PropGetBool( "dpadEnabled" ) )
		{
			p.keycodesUp.push( BUTTON_DPAD_UP )
			p.keycodesDown.push( BUTTON_DPAD_DOWN )
			p.keycodesLeft.push( BUTTON_DPAD_LEFT )
			p.keycodesRight.push( BUTTON_DPAD_RIGHT )
			p.keycodesForward.push( BUTTON_A )
			p.keycodesBack.push( BUTTON_B )
			p.keycodesBack.push( BUTTON_BACK )
		}

		if ( self.PropGetBool( "rstickEnabled" ) )
		{
			p.keycodesUp.push( STICK2_UP )
			p.keycodesDown.push( STICK2_DOWN )
			p.keycodesLeft.push( STICK2_LEFT )
			p.keycodesRight.push( STICK2_RIGHT )
		}

		if ( self.PropGetBool( "keyboardEnabled" ) )
		{
			p.keycodesUp.push( KEY_UP )
			p.keycodesDown.push( KEY_DOWN )
			p.keycodesLeft.push( KEY_LEFT )
			p.keycodesRight.push( KEY_RIGHT )
			p.keycodesForward.push( KEY_ENTER )
			p.keycodesBack.push( KEY_ESCAPE )
			p.keycodesBack.push( MOUSE_4 )
		}

		p.navUpFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateDirection( self, 0, -1 ) }
		p.navDownFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateDirection( self, 0, 1 ) }
		p.navRightFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateDirection( self, 1, 0 ) }
		p.navLeftFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateDirection( self, -1, 0 ) }
		p.navForwardFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateForward( self ) }
		p.navBackFunc = void function( var button ) : ( self ) { RTKDirectionalNavigation_NavigateBackward( self ) }
	}

	foreach( keycode in p.keycodesUp )
	{
		RegisterButtonPressedCallback( keycode, p.navUpFunc )
	}
	foreach( keycode in p.keycodesDown )
	{
		RegisterButtonPressedCallback( keycode, p.navDownFunc )
	}
	foreach( keycode in p.keycodesRight )
	{
		RegisterButtonPressedCallback( keycode, p.navRightFunc )
	}
	foreach( keycode in p.keycodesLeft )
	{
		RegisterButtonPressedCallback( keycode, p.navLeftFunc )
	}
	foreach( keycode in p.keycodesForward )
	{
		RegisterButtonPressedCallback( keycode, p.navForwardFunc )
	}
	foreach( keycode in p.keycodesBack )
	{
		RegisterButtonPressedCallback( keycode, p.navBackFunc )
	}
}

void function RTKDirectionalNavigation_DeregisterGlobalInput( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( !p.inputRegistered )
		return
	p.inputRegistered = false

	foreach( keycode in p.keycodesUp )
	{
		DeregisterButtonPressedCallback( keycode, p.navUpFunc )
	}
	foreach( keycode in p.keycodesDown )
	{
		DeregisterButtonPressedCallback( keycode, p.navDownFunc )
	}
	foreach( keycode in p.keycodesRight )
	{
		DeregisterButtonPressedCallback( keycode, p.navRightFunc )
	}
	foreach( keycode in p.keycodesLeft )
	{
		DeregisterButtonPressedCallback( keycode, p.navLeftFunc )
	}
	foreach( keycode in p.keycodesForward )
	{
		DeregisterButtonPressedCallback( keycode, p.navForwardFunc )
	}
	foreach( keycode in p.keycodesBack )
	{
		DeregisterButtonPressedCallback( keycode, p.navBackFunc )
	}
}

void function RTKDirectionalNavigation_GetAllButtonChildren( rtk_behavior self, rtk_panel panel, array< rtk_behavior > allChildButtons  )
{
	array< rtk_behavior > childButtons = panel.FindBehaviorsByTypeName( "Button" )
	foreach ( button in childButtons )
	{
		allChildButtons.push(button)
	}

	array< rtk_panel > childPanels = panel.GetChildren()
	foreach ( childPanel in childPanels )
	{
		RTKDirectionalNavigation_GetAllButtonChildren( self, childPanel, allChildButtons )
	}
}

rtk_behavior ornull function RTKDirectionalNavigation_GetFocusedButton( rtk_behavior self )
{
	RTKDirectionalNavigation_RegisterButtons( self ) 

	PrivateData p
	self.Private( p )

	array< rtk_behavior > buttons = p.buttons
	if ( buttons.len() > p.focusedButtonIndex && p.focusedButtonIndex >= 0 )
	{
		return buttons[p.focusedButtonIndex]
	}
	return null
}

void function RTKDirectionalNavigation_EnsureChildButtonFocused( rtk_behavior self, bool invokeEvent = false )
{
	PrivateData p
	self.Private( p )

	if ( p.buttons.len() <= 0 )
		return

	rtk_behavior ornull focusedButtonOrNull = RTKDirectionalNavigation_GetFocusedButton( self )

	if ( focusedButtonOrNull != null )
	{
		
		RTKDirectionalNavigation_FocusButton( self, expect rtk_behavior( focusedButtonOrNull ), -1, invokeEvent )
	}
	else
	{
		
		RTKDirectionalNavigation_FocusButton( self, p.buttons[0], 0, invokeEvent )
	}
}

void function RTKDirectionalNavigation_FocusButton( rtk_behavior self, rtk_behavior button, int buttonIndex = -1, bool invokeEvent = true )
{
	 

	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	PrivateData p
	self.Private( p )

	rtk_behavior ornull focusedButtonOrNull = RTKDirectionalNavigation_GetFocusedButton( self )

	if ( focusedButtonOrNull != null )
	{
		rtk_behavior focusedButton = expect rtk_behavior( focusedButtonOrNull )
		string eventName = "onIdle"
		focusedButton.InvokeEvent( eventName, focusedButton, 0 )
		array< rtk_behavior > animators = focusedButton.GetPanel().FindBehaviorsByTypeName( "Animator" )
		foreach( rtk_behavior animator in animators)
		{
			if ( RTKAnimator_HasAnimation( animator, eventName ) )
				RTKAnimator_PlayAnimation( animator, eventName )
		}
	}

	if ( invokeEvent )
	{
		string eventName = "onHighlightedOrFocused"
		button.InvokeEvent( eventName, button, 0 )
		array< rtk_behavior > animators = button.GetPanel().FindBehaviorsByTypeName( "Animator" )
		foreach( rtk_behavior animator in animators)
		{
			if ( RTKAnimator_HasAnimation( animator, eventName ) )
				RTKAnimator_PlayAnimation( animator, eventName )
		}
	}

	if ( buttonIndex >= 0 )
	{
		p.focusedButtonIndex = buttonIndex
	}
}


vector function RTKDirectionalNavigation_GetPositionRelativeToRoot( rtk_behavior self, rtk_panel targetPanel, rtk_panel rootPanel )
{
	vector out
	out += targetPanel.GetPosition()
	rtk_panel ornull panelParent = targetPanel.GetParent()
	while ( panelParent != null && panelParent != rootPanel )
	{
		expect rtk_panel (panelParent)
		vector parentPosition = panelParent.GetPosition()
		out.x += parentPosition.x
		out.y += parentPosition.y
		panelParent = panelParent.GetParent()
	}
	return out
}


void function RTKDirectionalNavigation_NavigateDirection( rtk_behavior self, int xDirection = 0, int yDirection = 0 )
{
	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	if ( IsControllerModeActive() && !GetDpadNavigationActive() )
		return

	RTKDirectionalNavigation_RegisterButtons( self ) 

	PrivateData p
	self.Private( p )

	rtk_behavior ornull focusedButtonOrNull = RTKDirectionalNavigation_GetFocusedButton( self )

	if ( focusedButtonOrNull == null )
		return

	rtk_behavior focusedButton = expect rtk_behavior ( focusedButtonOrNull )

	rtk_panel focusRootPanel = self.PropGetPanel( "focusRoot" )
	if (focusRootPanel == null)
	{
		focusRootPanel = self.GetPanel()
	}
	
	float startingPositionX = focusedButton.GetPanel().GetAbsolutePositionX()
	float startingPositionY = focusedButton.GetPanel().GetAbsolutePositionY()
	
	

	

	array< rtk_behavior > buttons = p.buttons
	array< float > xPositions
	array< float > yPositions

	foreach ( int i, rtk_behavior button in buttons )
	{
		
		xPositions.push( button.GetPanel().GetAbsolutePositionX() )
		yPositions.push( button.GetPanel().GetAbsolutePositionY() )
		
		
		
		
		
		
		
		
		
	}

	float bestScore = FLOAT_INFINITY
	int bestScoreIndex = -1

	int yPositionFudge = self.PropGetInt( "yPositionFudge" ) 
	int xOutOfBoundsFudge = self.PropGetInt( "xOutOfBoundsFudge" )
	if ( xDirection > 0 )
	{
		foreach ( int i, float xPosition in xPositions )
		{
			float xOffset = xPosition - startingPositionX
			if ( xOffset > 0 && xOffset < bestScore && ( startingPositionY + yPositionFudge >= yPositions[i] && startingPositionY - yPositionFudge <= yPositions[i] )  )
			{
				bestScore = xOffset
				bestScoreIndex = i
			}
		}
	}
	else if ( xDirection < 0 )
	{
		foreach ( int i, float xPosition in xPositions )
		{
			float xOffset = startingPositionX - xPosition
			if ( xOffset > 0 && xOffset < bestScore  && ( startingPositionY + yPositionFudge >= yPositions[i] && startingPositionY - yPositionFudge <= yPositions[i] ) )
			{
				bestScore = xOffset
				bestScoreIndex = i
			}
		}
	}
	else if ( yDirection > 0 )
	{
		foreach ( int i, float yPosition in yPositions )
		{
			float yOffset = yPosition - startingPositionY
			if ( yOffset > 0 && yOffset < bestScore && startingPositionX == xPositions[i] )
			{
				bestScore = yOffset
				bestScoreIndex = i
			}
		}
	}
	else if ( yDirection < 0 )
	{
		foreach ( int i, float yPosition in yPositions )
		{
			float yOffset = startingPositionY - yPosition
			if ( yOffset > 0 && yOffset < bestScore && startingPositionX == xPositions[i] )
			{
				bestScore = yOffset
				bestScoreIndex = i
			}
		}
	}

	if ( bestScoreIndex >= 0 )
	{
		RTKDirectionalNavigation_FocusButton( self, buttons[bestScoreIndex], bestScoreIndex )

		vector newButtonPosition = RTKDirectionalNavigation_GetPositionRelativeToRoot( self, buttons[bestScoreIndex].GetPanel(), focusRootPanel )

		rtk_panel visibleParent = self.PropGetPanel( "visibleRoot" )
		if ( visibleParent == null )
		{
			visibleParent = self.GetPanel()
		}

		vector parentPosition = RTKDirectionalNavigation_GetPositionRelativeToRoot( self, visibleParent, focusRootPanel )

		bool buttonIsChildOfVisibleParent = false
		rtk_panel ornull parentPanel = buttons[bestScoreIndex].GetPanel().GetParent()
		while ( parentPanel != null )
		{
			expect rtk_panel (parentPanel)
			if ( parentPanel == visibleParent )
			{
				buttonIsChildOfVisibleParent = true
				break
			}
			parentPanel = parentPanel.GetParent()
		}

		if ( !buttonIsChildOfVisibleParent )
		{
			
		}
		else if ( newButtonPosition.x > ( parentPosition.x + visibleParent.GetWidth() ) - xOutOfBoundsFudge )
		{
			if ( p.outOfBoundsRightCallback != null )
			{
				p.outOfBoundsRightCallback()
			}
		}
		else if ( newButtonPosition.x < parentPosition.x )
		{
			if ( p.outOfBoundsLeftCallback != null )
			{
				p.outOfBoundsLeftCallback()
			}
		}
		else if ( newButtonPosition.y > parentPosition.y + visibleParent.GetHeight() )
		{
			if ( p.outOfBoundsBottomCallback != null )
			{
				p.outOfBoundsBottomCallback()
			}
		}
		else if ( newButtonPosition.y < parentPosition.y )
		{
			if ( p.outOfBoundsTopCallback != null )
			{
				p.outOfBoundsTopCallback()
			}
		}
	}
	else
	{
		if ( xDirection > 0 )
		{
			if ( p.navFailedRightCallback != null )
			{
				p.navFailedRightCallback()
			}
		} else if ( xDirection < 0 )
		{
			if ( p.navFailedLeftCallback != null )
			{
				p.navFailedLeftCallback()
			}
		} else if ( yDirection < 0 )
		{
			if ( p.navFailedTopCallback != null )
			{
				p.navFailedTopCallback()
			}
		} else if ( yDirection > 0 )
		{
			if ( p.navFailedBottomCallback != null )
			{
				p.navFailedBottomCallback()
			}
		}
	}
}

void function RTKDirectionalNavigation_SetNavFailedTopCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.navFailedTopCallback = callback
}

void function RTKDirectionalNavigation_SetNavFailedBottomCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.navFailedBottomCallback = callback
}

void function RTKDirectionalNavigation_SetNavFailedLeftCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.navFailedLeftCallback = callback
}

void function RTKDirectionalNavigation_SetNavFailedRightCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.navFailedRightCallback = callback
}

void function RTKDirectionalNavigation_SetOutOfBoundsTopCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.outOfBoundsTopCallback = callback
}

void function RTKDirectionalNavigation_SetOutOfBoundsBottomCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.outOfBoundsBottomCallback = callback
}

void function RTKDirectionalNavigation_SetOutOfBoundsLeftCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.outOfBoundsLeftCallback = callback
}

void function RTKDirectionalNavigation_SetOutOfBoundsRightCallback( rtk_behavior self, void functionref( ) callback )
{
	PrivateData p
	self.Private( p )
	p.outOfBoundsRightCallback = callback
}

void function RTKDirectionalNavigation_NavigateForward( rtk_behavior self )
{
	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	if ( IsControllerModeActive() && !GetDpadNavigationActive() )
		return

	PrivateData p
	self.Private( p )

	rtk_behavior ornull focusedButtonOrNull = RTKDirectionalNavigation_GetFocusedButton( self )

	if ( focusedButtonOrNull == null )
		return

	rtk_behavior focusedButton = expect rtk_behavior ( focusedButtonOrNull )

	string eventName = "onPressed"
	focusedButton.InvokeEvent( eventName, focusedButton, IsControllerModeActive() ? BUTTON_A : KEY_ENTER, 0 )
	array< rtk_behavior > animators = focusedButton.GetPanel().FindBehaviorsByTypeName( "Animator" )
	foreach( rtk_behavior animator in animators)
	{
		if ( RTKAnimator_HasAnimation( animator, eventName ) )
			RTKAnimator_PlayAnimation( animator, eventName )
	}
}

void function RTKDirectionalNavigation_NavigateBackward( rtk_behavior self )
{
	if ( !RTKDirectionalNavigation_IsEnabled( self ) )
		return

	
}