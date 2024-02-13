global function RTKMaintainAspectRatio_OnVisualChange

global struct RTKMaintainAspectRatio_Properties
{
	float ratioWidth = 1
	float ratioHeight = 1

	bool shrinkToFit 
	bool runOnce = true
}

void function RTKMaintainAspectRatio_OnVisualChange( rtk_behavior self )
{
	float targetRatio = self.PropGetFloat( "ratioWidth" ) / self.PropGetFloat( "ratioHeight" )
	bool shrinkToFit = self.PropGetBool( "shrinkToFit" )
	rtk_panel panel   = self.GetPanel()

	float currentWidth = panel.GetWidth()
	float currentHeight = panel.GetHeight()

	if ( currentWidth/currentHeight > targetRatio )
	{
		if ( shrinkToFit )
		{
			panel.SetWidth( currentHeight * targetRatio )
		}
		else
		{
			panel.SetHeight( currentWidth / targetRatio )

		}
	}
	else if ( currentWidth/currentHeight < targetRatio )
	{
		if ( shrinkToFit )
		{
			panel.SetHeight( currentWidth / targetRatio )

		}
		else
		{
			panel.SetWidth( currentHeight * targetRatio )
		}
	}

	if ( self.PropGetBool( "runOnce" ) )
	{
		self.SetActive( false )
	}
}