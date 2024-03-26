global function RTKSinglePanelContainer_InitMetaData
global function RTKSinglePanelContainer_OnInitialize
global function RTKSinglePanelContainer_OnLayout

global struct RTKSinglePanelContainer_Properties
{
	float paddingTop = 0.0
	float paddingBottom = 0.0
	float paddingLeft = 0.0
	float paddingRight = 0.0

	bool hideWhenEmpty = false
}

void function RTKSinglePanelContainer_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorIsLayoutBehavior( behaviorType, true )
}

void function RTKSinglePanelContainer_OnInitialize( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()
	self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel p0, int p1 ) : ( self )
		{
			RTKSinglePanelContainer_OnPanelAdded( self )
		}
	)
	self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel p0, int p1 ) : ( self )
	{
		RTKSinglePanelContainer_OnPanelAdded( self )
	}
	)
}

void function RTKSinglePanelContainer_OnLayout( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()
	int count = panel.GetChildCount()

	if ( count != 1 )
		return

	rtk_panel child = panel.GetChildByIndex( 0 )

	float left = self.PropGetFloat( "paddingLeft" )
	float top = self.PropGetFloat( "paddingTop" )

	vector size = child.GetSize()
	size.x += left + self.PropGetFloat( "paddingRight" )
	size.y += top + self.PropGetFloat( "paddingBottom" )

	child.SetAnchor( RTKANCHOR_TOP_LEFT )
	child.SetPivot( <0, 0, 0> )
	child.SetPositionXY( left, top )

	panel.SetSize( size )
}

void function RTKSinglePanelContainer_OnPanelAdded( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()
	int count = panel.GetChildCount()

	if ( count > 1 )
		self.Warn( "Panel contains too many panels: " + count )

	if ( self.PropGetBool( "hideWhenEmpty" ) )
		panel.SetVisible( true )
}

void function RTKSinglePanelContainer_OnPanelRemoved( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()
	int count = panel.GetChildCount()

	if ( count > 0 )
		return

	if ( self.PropGetBool( "hideWhenEmpty" ) )
		panel.SetVisible( false )
}