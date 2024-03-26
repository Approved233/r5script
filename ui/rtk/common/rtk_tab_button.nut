global struct RTKTabButton_Properties
{
	int index
	void functionref( int ) onPressedFunc
	rtk_panel activePanel
	rtk_panel inactivePanel
	rtk_behavior buttonBehavior
}

global function RTKTabButton_OnInitialize
global function RTKTabButton_InitProps
global function RTKTabButton_SetSelected

void function RTKTabButton_OnInitialize( rtk_behavior self )
{
	if ( self.rtkprops.buttonBehavior != null)
	{
		rtk_behavior button = expect rtk_behavior( self.rtkprops.buttonBehavior )
		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : (self) {
			{
				self.InvokeEvent( "onPressedFunc", self.PropGetInt( "index" ) )
			}
		} )
	}
}

void function RTKTabButton_InitProps( rtk_behavior self, int index, bool selected, void functionref( int ) pressedHandler )
{
	self.rtkprops.index = index;
	self.AddEventListener( "onPressedFunc", pressedHandler )

	RTKTabButton_SetSelected( self, selected )
}

void function RTKTabButton_SetSelected( rtk_behavior self, bool selected )
{
	if ( self.rtkprops.activePanel != null )
	{
		rtk_panel activePanel = expect rtk_panel( self.rtkprops.activePanel )
		activePanel.SetVisible( selected )
	}
	if ( self.rtkprops.inactivePanel != null )
	{
		rtk_panel inactivePanel = expect rtk_panel( self.rtkprops.inactivePanel )
		inactivePanel.SetVisible( !selected )
	}
}
