global function RTKSelectableButton_OnInitialize
global function RTKSelectableButton_SetOnSelectedCallbackFunc
global function RTKSelectableButton_SetSelected
global function RTKSelectableButton_UpdateIndex

global struct RTKSelectableButton_Properties
{
	int index
	void functionref( int ) onSelectedFunc
	rtk_panel activePanel
	rtk_behavior buttonBehavior
}

void function RTKSelectableButton_OnInitialize( rtk_behavior self )
{
	if ( self.rtkprops.buttonBehavior != null)
	{
		rtk_behavior button = expect rtk_behavior( self.rtkprops.buttonBehavior )
		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : (self) {
			{
				self.InvokeEvent( "onSelectedFunc", self.PropGetInt( "index" ) )
			}
		} )
	}
}

void function RTKSelectableButton_SetOnSelectedCallbackFunc( rtk_behavior self, void functionref( int ) onSelectedCallback )
{
	self.AddEventListener( "onSelectedFunc", onSelectedCallback )
}

void function RTKSelectableButton_SetSelected( rtk_behavior self, bool selected )
{
	if ( self.rtkprops.activePanel != null )
	{
		rtk_panel activePanel = expect rtk_panel( self.rtkprops.activePanel )
		activePanel.SetVisible( selected )
	}
}

void function RTKSelectableButton_UpdateIndex( rtk_behavior self, int index )
{
	self.rtkprops.index = index
}