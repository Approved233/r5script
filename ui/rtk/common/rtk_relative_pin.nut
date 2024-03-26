global function RTKRelativePin_OnVisualChange

global struct RTKRelativePin_Properties
{
	vector pin
}

void function RTKRelativePin_OnVisualChange( rtk_behavior self )
{
	vector pin = self.PropGetFloat3( "pin" )
	rtk_panel panel = self.GetPanel()
	vector size = self.GetPanel().GetParent().GetSize()

	panel.SetAnchor( RTKANCHOR_TOP_LEFT )
	panel.SetPositionXY( size.x * pin.x, size.y * pin.y )
}