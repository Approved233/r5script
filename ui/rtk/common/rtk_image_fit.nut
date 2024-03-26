global function RTKImageFit_OnInitialize
global function RTKImageFit_OnVisualChange

global struct RTKImageFit_Properties
{
	vector pivot = < 0.5, 0.5, 0.0 >
	bool useImageMask = false
}

struct Private
{
	rtk_behavior image
}

void function RTKImageFit_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "Image" )
}

void function RTKImageFit_OnInitialize( rtk_behavior self )
{
	Private p
	self.Private( p )
	p.image = self.GetPanel().FindBehaviorByTypeName( "Image" )
}

void function RTKImageFit_OnVisualChange( rtk_behavior self )
{
	Private p
	self.Private( p )

	bool useMask = self.PropGetBool( "useImageMask" )
	string imageProperty = useMask ? "assetMaskPath" : "assetPath"

	asset image = p.image.PropGetAssetPath( imageProperty )
	vector imageSize = GetImageSize( image )
	if ( imageSize.x == 0 || imageSize.y == 0 )
		return
	float imageRatio = imageSize.x / imageSize.y

	rtk_panel panel = self.GetPanel()
	vector panelSize = panel.GetSize()
	if ( panelSize.x == 0 || panelSize.y == 0 )
		return
	float panelRatio = panelSize.x / panelSize.y

	vector uv_pivot = self.PropGetFloat3( "pivot" )
	vector uv_scale = < 1.0, 1.0, 0.0 >

	if ( imageRatio < panelRatio )
		uv_scale.y = imageRatio / panelRatio
	else if ( imageRatio > panelRatio )
		uv_scale.x = panelRatio / imageRatio

	if ( useMask )
	{
		RTKStruct_SetFloat2( p.image.GetProperties(), "uv1Scale", uv_scale )
		RTKStruct_SetFloat2( p.image.GetProperties(), "uvPivot", uv_pivot )
	}
	else
	{
		vector uv_min = < 0.0, 0.0, 0.0 >
		vector uv_max = < 1.0, 1.0, 0.0 >

		uv_min.x = ( 1 - uv_scale.x ) * uv_pivot.x
		uv_max.x = uv_min.x + uv_scale.x

		uv_min.y = ( 1 - uv_scale.y ) * uv_pivot.y
		uv_max.y = uv_min.y + uv_scale.y

		RTKStruct_SetFloat2( p.image.GetProperties(), "uv0Min", uv_min )
		RTKStruct_SetFloat2( p.image.GetProperties(), "uv0Max", uv_max )
	}

	



}