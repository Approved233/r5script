global function RTKPaginationNavController_OnInitialize
global function RTKPaginationNavController_SetInitPageIndex

global struct RTKPaginationNavController_Properties
{
	
	string pathToModel
	rtk_behavior paginationBehavior
	string indexPropName

	rtk_panel    pipParentPanel
	string	     pathToPipModel
	rtk_behavior cursorInteractBehavior
	rtk_behavior cursorInteractBehaviorExtra
	rtk_behavior hintAnimatorBehavior
	rtk_behavior pipListBinder

	rtk_behavior nextButton
	rtk_behavior prevButton
	rtk_behavior nextButtonAlt
	rtk_behavior prevButtonAlt

	bool isVertical
	bool canWrap
	float updateDelay = 0.1

	int maxPips

	void functionref() onPageChange
}

global struct RTKPaginationPipModel
{
	int buttonState
}

struct PrivateData
{
	int pageIndex
	int pageCount
	float lastUpdate

	int currentPipRangeStart
	int currentPipRangeEnd
}


void function RTKPaginationNavController_OnInitialize( rtk_behavior self )
{
	rtk_panel pipParent 			= self.PropGetPanel( "pipParentPanel" )
	rtk_behavior pipListBinder 		= self.PropGetBehavior( "pipListBinder" )
	rtk_behavior nextButton 		= self.PropGetBehavior( "nextButton" )
	rtk_behavior nextButtonAlt 		= self.PropGetBehavior( "nextButtonAlt" )
	rtk_behavior prevButton 		= self.PropGetBehavior( "prevButton" )
	rtk_behavior prevButtonAlt 		= self.PropGetBehavior( "prevButtonAlt" )
	rtk_behavior cursorZone 		= self.PropGetBehavior( "cursorInteractBehavior" )
	rtk_behavior cursorZoneExtra 	= self.PropGetBehavior( "cursorInteractBehaviorExtra" )

	self.AutoSubscribe( pipParent, "onChildAdded", function( rtk_panel newChild, int newChildIndex ) : ( pipParent, self )
	{
		PrivateData p
		self.Private( p )
		p.pageCount = pipParent.GetChildCount()

		rtk_behavior button = newChild.FindBehaviorByTypeName( "Button" )
		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex )
		{
			RTKPaginationNavController_SetPageIndex( self, newChildIndex )
		} )
	})

	self.AutoSubscribe( pipListBinder, "onUpdatedList", function( ) : ( self )
	{
		PrivateData p
		self.Private( p )
		self.GetPanel().SetVisible( p.pageCount > 1 )
		RTKPaginationNavController_UpdateNavArrowsState( self )
	})

	if ( nextButton != null )
	{
		self.AutoSubscribe( nextButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKPaginationNavController_NextPage( self )
		} )
	}

	if ( nextButtonAlt != null )
	{
		self.AutoSubscribe( nextButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKPaginationNavController_NextPage( self )
		} )
	}

	if ( prevButton != null )
	{
		self.AutoSubscribe( prevButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKPaginationNavController_PrevPage( self )
		} )
	}

	if ( prevButtonAlt != null )
	{
		self.AutoSubscribe( prevButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKPaginationNavController_PrevPage( self )
		} )
	}

	if ( cursorZone != null )
	{
		RTKPaginationNavController_SetupCursorInteractArea( self, cursorZone )
	}

	if ( cursorZoneExtra != null )
	{
		RTKPaginationNavController_SetupCursorInteractArea( self, cursorZoneExtra )
	}
}

void function RTKPaginationNavController_SetPageIndex( rtk_behavior self, int pageIndex )
{
	PrivateData p
	self.Private( p )

	if ( !RTKPaginationNavController_CanUpdate( self ) )
		return

	pageIndex = ClampInt ( pageIndex, 0, p.pageCount - 1 )
	if ( p.pageIndex == pageIndex )
		return

	p.pageIndex = pageIndex
	p.lastUpdate = UITime()

	string pathToModel = self.PropGetString( "pathToModel" )
	string indexPropName = self.PropGetString( "indexPropName" )
	rtk_behavior targetBehavior = self.PropGetBehavior( "paginationBehavior" )
	rtk_struct dataStruct = RTKDataModel_GetStruct( pathToModel )

	if ( targetBehavior != null && RTKStruct_HasProperty( targetBehavior.GetProperties(), indexPropName ) )
	{
		targetBehavior.PropSetInt( indexPropName, pageIndex )
	}

	if ( dataStruct != null && RTKStruct_HasProperty( dataStruct, indexPropName ) )
	{
		RTKStruct_SetInt( dataStruct, indexPropName, pageIndex )
	}
	RTKPaginationNavController_UpdateNavArrowsState( self )
	EmitUISound( "UI_Menu_BattlePass_LevelTab" )
	self.InvokeEvent( "OnPageChange", pageIndex )
}

void function RTKPaginationNavController_NextPage( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	bool canWrap = self.PropGetBool( "canWrap" )
	bool isLastPage = p.pageIndex >= p.pageCount - 1

	if ( isLastPage && !canWrap )
		return

	int targetPage =  isLastPage ? 0 : p.pageIndex + 1
	if ( !RTKPaginationNavController_IsTargetPageLocked( self, targetPage ) )
	{
		RTKPaginationNavController_SetPageIndex( self, targetPage )
		p.lastUpdate = UITime()
	}
}

void function RTKPaginationNavController_PrevPage( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	bool canWrap     = self.PropGetBool( "canWrap" )
	bool isFirstPage = p.pageIndex <= 0

	if ( isFirstPage && !canWrap )
		return

	int targetPage =  isFirstPage ? 0 : p.pageIndex - 1
	if ( !RTKPaginationNavController_IsTargetPageLocked( self, targetPage ) )
	{
		RTKPaginationNavController_SetPageIndex( self, targetPage )
		p.lastUpdate = UITime()
	}
}

void function RTKPaginationNavController_OnMouseWheeled( rtk_behavior self, float delta )
{
	if( IsControllerModeActive() && !self.PropGetBool( "isVertical" ) )
		return

	if( delta > 0 )
	{
		RTKPaginationNavController_PrevPage( self )
	}
	else if( delta < 0 )
	{
		RTKPaginationNavController_NextPage( self )
	}
}

void function RTKPaginationNavController_OnKeyCodePressed( rtk_behavior self, int keycode )
{
	if ( self.PropGetBool( "isVertical" ) )
	{
		if( keycode == STICK2_DOWN || keycode == KEY_DOWN ) 
		{
			RTKPaginationNavController_NextPage( self )
		}
		else if( keycode == STICK2_UP || keycode == KEY_UP ) 
		{
			RTKPaginationNavController_PrevPage( self )
		}
	}
	else
	{
		if( keycode == STICK2_RIGHT || keycode == KEY_RIGHT || keycode == BUTTON_SHOULDER_RIGHT ) 
		{
			if ( !IsRTL() )
			{
				RTKPaginationNavController_NextPage( self )
			}
			else 
			{
				RTKPaginationNavController_PrevPage( self )
			}
		}
		else if( keycode == STICK2_LEFT  || keycode == KEY_LEFT || keycode == BUTTON_SHOULDER_LEFT ) 
		{
			if ( !IsRTL() )
			{
				RTKPaginationNavController_PrevPage( self )
			}
			else 
			{
				RTKPaginationNavController_NextPage( self )
			}
		}
	}
}

void function RTKPaginationNavController_OnHoverEnter( rtk_behavior self, rtk_behavior cursorZone )
{
	bool controlTypeIsActive = cursorZone.PropGetBool( IsControllerModeActive() ? "controllerEnabled" : "mouseEnabled" )
	if ( !controlTypeIsActive )
		return

	rtk_behavior animator = self.PropGetBehavior( "hintAnimatorBehavior" )
	if( animator != null && RTKAnimator_HasAnimation( animator, "FadeIn" ) )
	{
		RTKAnimator_PlayAnimation( animator, "FadeIn" )
	}
}

void function RTKPaginationNavController_OnHoverLeave( rtk_behavior self, rtk_behavior cursorZone )
{
	bool controlTypeIsActive = cursorZone.PropGetBool( IsControllerModeActive() ? "controllerEnabled" : "mouseEnabled" )
	if ( !controlTypeIsActive )
		return

	rtk_behavior animator = self.PropGetBehavior( "hintAnimatorBehavior" )
	if( animator != null && RTKAnimator_HasAnimation( animator, "FadeOut" ) )
	{
		RTKAnimator_PlayAnimation( animator, "FadeOut" )
	}
}

void function RTKPaginationNavController_SetupCursorInteractArea( rtk_behavior self, rtk_behavior cursorZone )
{
	array< int > keycodes = [ STICK2_LEFT, STICK2_RIGHT, STICK2_UP, STICK2_DOWN, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN ]
	rtk_array rtk_keycodes = cursorZone.PropGetArray( "keycodes" )
	RTKArray_SetValue( rtk_keycodes, keycodes )

	RTKCursorInteract_AutoSubscribeMouseWheeledListener( self, cursorZone,
		void function( float delta ) : ( self )
		{
			RTKPaginationNavController_OnMouseWheeled( self, delta )
		}
	)

	RTKCursorInteract_AutoSubscribeOnKeyCodePressedListener( self, cursorZone,
		void function( int keycode ) : ( self )
		{
			RTKPaginationNavController_OnKeyCodePressed( self, keycode )
		}
	)

	RTKCursorInteract_AutoSubscribeOnHoverEnterListener( self, cursorZone,
		void function() : ( self, cursorZone )
		{
			RTKPaginationNavController_OnHoverEnter( self, cursorZone )
		}
	)

	RTKCursorInteract_AutoSubscribeOnHoverLeaveListener( self, cursorZone,
		void function() : ( self, cursorZone )
		{
			RTKPaginationNavController_OnHoverLeave( self, cursorZone )
		}
	)
}

bool function RTKPaginationNavController_IsTargetPageLocked( rtk_behavior self, int targetPage )
{
	string pipModelPath = self.PropGetString( "pathToPipModel" )
	if ( RTKDataModel_HasDataModel( pipModelPath ) )
	{
		rtk_array pipArray = RTKDataModel_GetArray( pipModelPath )
		if ( RTKArray_GetCount( pipArray ) == 0 )
			return false
		rtk_struct ornull pipStruct = RTKArray_GetStruct( pipArray, targetPage )
		if ( pipStruct != null )
		{
			expect rtk_struct( pipStruct )
			if ( RTKStruct_HasProperty( pipStruct, "isLocked" ) )
				return RTKStruct_GetBool( pipStruct, "isLocked" )
		}
	}
	return false
}

void function RTKPaginationNavController_SetInitPageIndex( rtk_behavior self, int pageIndex )
{
	PrivateData p
	self.Private( p )
	p.pageIndex = pageIndex
}

bool function RTKPaginationNavController_CanUpdate( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	return UITime() > p.lastUpdate + self.PropGetFloat( "updateDelay" )
}

void function RTKPaginationNavController_UpdateNavArrowsState( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	rtk_behavior nextButton = self.PropGetBehavior( "nextButton" )
	rtk_behavior prevButton = self.PropGetBehavior( "prevButton" )
	nextButton.PropSetBool( "interactive", !RTKPaginationNavController_IsNextPageLocked( self ) )
	prevButton.PropSetBool( "interactive", !RTKPaginationNavController_IsPrevPageLocked( self ) )
}

bool function RTKPaginationNavController_IsPrevPageLocked( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	int prevPage = ClampInt( p.pageIndex - 1, 0, p.pageCount - 1 )
	return RTKPaginationNavController_IsTargetPageLocked( self, prevPage ) || p.pageIndex == 0
}

bool function RTKPaginationNavController_IsNextPageLocked( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	int nextPage = ClampInt( p.pageIndex + 1, 0, p.pageCount - 1 )
	return RTKPaginationNavController_IsTargetPageLocked( self, nextPage ) || p.pageIndex == p.pageCount - 1
}