global function RTKMinMaxDimensions_OnVisualChange

global struct RTKMinMaxDimensions_Properties
{
	float minWidth = 0
	float minHeight = 0
	float maxWidth = FLT_MAX
	float maxHeight = FLT_MAX

	bool runOnce = true
}

void function RTKMinMaxDimensions_OnVisualChange( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()
	float minWidth  = self.PropGetFloat( "minWidth" )
	float minHeight = self.PropGetFloat( "minHeight" )
	float maxWidth  = self.PropGetFloat( "maxWidth" )
	float maxHeight = self.PropGetFloat( "maxHeight" )

	float currentWidth = panel.GetWidth()
	float targetWidth = Clamp( currentWidth, minWidth, maxWidth )
	if ( currentWidth != targetWidth )
	{
		panel.SetWidth( targetWidth )
	}

	float currentHeight = panel.GetHeight()
	float targetHeight = Clamp( currentHeight, minHeight, maxHeight )
	if ( currentHeight != targetHeight )
	{
		panel.SetHeight( targetHeight )
	}

	if ( self.PropGetBool( "runOnce" ) )
	{
		self.SetActive( false )
	}
}