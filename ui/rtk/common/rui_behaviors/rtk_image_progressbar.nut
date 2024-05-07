global function RTKImageProgressBar_InitMetaData
global function RTKImageProgressBar_OnInitialize
global function RTKImageProgressBar_OnDrawBegin
global function RTKImageProgressBar_OnDestroy

global struct RTKImageProgressBar_Properties
{
	asset rui = $""

	float current = 0
	float max = 0

	vector progressBarColor
	vector progressBgColor

	float progressBarAlpha
	float progressBgAlpha

	asset bgImage = $"ui_image/white.rpak"
	asset fillImage = $"ui_image/white.rpak"
}

void function RTKImageProgressBar_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorIsRuiBehavior( behaviorType, true )
}

void function RTKImageProgressBar_OnInitialize( rtk_behavior self )
{
	self.AddPropertyCallback( "rui", UpdateRuiAsset )

	UpdateRuiAsset( self )
}

void function RTKImageProgressBar_OnDestroy( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	if ( panel.HasRui() )
		panel.DestroyRui()
}

void function UpdateRuiAsset( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	asset ruiAsset = $"ui/rtk_image_progressbar.rpak"

	if ( ruiAsset != "" )
		panel.CreateRui( ruiAsset )
	else if ( panel.HasRui() )
		panel.DestroyRui()
}

void function RTKImageProgressBar_OnDrawBegin( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	if ( panel.HasRui() )
	{
		panel.SetRuiArgFloat( "width", panel.GetWidth() )
		panel.SetRuiArgFloat( "height", panel.GetHeight() )
		panel.SetRuiArgFloat( "current", self.PropGetFloat( "current" ) )
		panel.SetRuiArgFloat( "max", self.PropGetFloat( "max" ) )

		panel.SetRuiArgColorRGB( "progressBarColor", self.PropGetFloat3( "progressBarColor" ) )
		panel.SetRuiArgColorRGB( "progressBgColor", self.PropGetFloat3( "progressBgColor" ) )
		panel.SetRuiArgFloat( "progressBarAlpha", self.PropGetFloat( "progressBarAlpha" ) )
		panel.SetRuiArgFloat( "progressBgAlpha", self.PropGetFloat( "progressBgAlpha" ) )

		asset ornull bgImage = self.PropGetAssetPath( "bgImage" )
		asset ornull fillImage = self.PropGetAssetPath( "fillImage" )

		panel.SetRuiArgImage( "progressBarBgImage", expect string( bgImage ) )
		panel.SetRuiArgImage( "progressBarFillImage", expect string( fillImage ) )
	}
}
