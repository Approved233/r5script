global function RTKSelectableButtonContainer_OnInitialize
global function RTKSelectableButtonContainer_UpdateSelectedButton

global struct RTKSelectableButtonContainer_Properties
{
	int initialButton = 0
}

void function RTKSelectableButtonContainer_OnInitialize( rtk_behavior self )
{

	rtk_panel panel = self.GetPanel()
	self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel p0, int p1 ) : ( self )
	{
		rtk_behavior addedSelectableButton = p0.FindBehaviorByTypeName( "SelectableButton" )
		RTKSelectableButton_SetOnSelectedCallbackFunc( addedSelectableButton, void function( int buttonIndex ) : ( self )
		{
			RTKSelectableButtonContainer_UpdateSelectedButton( self, buttonIndex )
		})

		
		int initialButton = expect int( self.rtkprops.initialButton )
		array<rtk_panel> packSelectionButtons = self.GetPanel().GetChildren()
		int buttonCount = packSelectionButtons.len()
		for ( int i = 0; i < buttonCount; i++ )
		{
			rtk_panel packSelectionButton = packSelectionButtons[i]
			rtk_behavior currentSelectableButton = packSelectionButton.FindBehaviorByTypeName( "SelectableButton" )
			bool selected = i == initialButton
			RTKSelectableButton_UpdateIndex( currentSelectableButton, i )
			RTKSelectableButton_SetSelected( currentSelectableButton, selected )
		}
	} )
}

void function RTKSelectableButtonContainer_UpdateSelectedButton( rtk_behavior self, int selectedIndex )
{
	array<rtk_panel> selectionButtons = self.GetPanel().GetChildren()
	int buttonCount = selectionButtons.len()
	for ( int i = 0; i < buttonCount; i++ )
	{
		rtk_panel button = selectionButtons[i]
		rtk_behavior selectableButton = button.FindBehaviorByTypeName( "SelectableButton" )
		bool selected = i == selectedIndex
		RTKSelectableButton_SetSelected( selectableButton, selected )
	}
}
