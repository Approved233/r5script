
const int RTKSTYLEPRIORITY_COLORBLIND = 200

const array<asset> RTKCOLORBLINDCONSTASSETS = [
	$"ui_rtk/styles/constants/default.rpak",
	$"ui_rtk/styles/constants/protanopia.rpak",
	$"ui_rtk/styles/constants/deuteranopia.rpak",
	$"ui_rtk/styles/constants/tritanopia.rpak"
]

const array<string> RTKCOLORBLINDNAMES = [
	"#SETTING_OFF",
	"#SETTING_PROTANOPIA",
	"#SETTING_DEUTERANOPIA",
	"#SETTING_TRITANOPIA"
]

global function RTKColorblindSettings_OnInitialize

global struct RTKColorblindSettings_Properties
{
	asset previewAsset
	rtk_behavior dropdown
	rtk_behavior outputLabel
}

struct
{
	int currentConstAssetIndex = 0
} file

void function RTKColorblindSettings_OnInitialize( rtk_behavior self )
{
	rtk_behavior ornull dropdown = self.PropGetBehavior( "dropdown" )
	if ( dropdown != null )
	{
		expect rtk_behavior( dropdown )
		self.AutoSubscribe( dropdown, "onItemPressed", function ( rtk_behavior behavior, int val ) : ( self )
		{
			RTKColorblindSettings_PreviewNewSetting( self, val )
		})
	}
	RTKConstants_AutoSubscribeConstantsLoaded( self, function() : ( self )
	{
		RTKColorblindSettings_RefreshPreview( self )
	} )

	
	int mode = GetConVarInt( "colorblind_mode" )
	file.currentConstAssetIndex = mode
	if ( mode != 0 ) 
		RTKConstants_ApplyAccessibilityConstants( RTKCOLORBLINDCONSTASSETS[mode], RTKSTYLEPRIORITY_COLORBLIND )

	
	if ( self.GetPanel().GetChildCount() == 0 )
		RTKColorblindSettings_RefreshPreview( self )
}

void function RTKColorblindSettings_PreviewNewSetting( rtk_behavior self, int setting )
{
	if ( GetConVarInt( "colorblind_mode" ) == setting )
		return

	SetConVarInt( "colorblind_mode", setting )
	Assert( setting < RTKCOLORBLINDCONSTASSETS.len() )
	asset path = RTKCOLORBLINDCONSTASSETS[setting]

	if ( file.currentConstAssetIndex != 0 ) 
		RTKConstants_RemoveStyle( RTKCOLORBLINDCONSTASSETS[file.currentConstAssetIndex] )

	file.currentConstAssetIndex = setting

	if ( setting != 0 ) 
		RTKConstants_ApplyAccessibilityConstants( path, RTKSTYLEPRIORITY_COLORBLIND )
	else
		RTKColorblindSettings_RefreshPreview( self )
}

void function RTKColorblindSettings_RefreshPreview( rtk_behavior self )
{
	
	rtk_panel owner           = self.GetPanel()
	string ornull previewAsset = self.PropGetAssetPath( "previewAsset" )
	if ( previewAsset == null )
	{
		Warning( "Colorblind settings page has no preview asset set" )
		return
	}

	expect string( previewAsset )
	if ( owner.GetChildCount() > 0 )
		owner.DestroyAllChildren()

	if ( owner.GetChildCount() == 0 )
		RTKPanel_Instantiate( previewAsset, owner, "ColorPreview")

	
	rtk_behavior ornull outputLabel = self.PropGetBehavior( "outputLabel" )
	int mode = file.currentConstAssetIndex
	if ( outputLabel != null )
	{
		expect rtk_behavior( outputLabel )
		outputLabel.PropSetString( "text", RTKCOLORBLINDNAMES[mode] )
	}
}

void function RTKColorblindSettings_Reset()
{
	int mode = GetConVarInt( "colorblind_mode" )
	RTKConstants_ApplyAccessibilityConstants( RTKCOLORBLINDCONSTASSETS[mode], RTKSTYLEPRIORITY_COLORBLIND )
}

