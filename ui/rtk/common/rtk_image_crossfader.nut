global function RTKImageCrossfader_SetImage
global function RTKImageCrossfader_FadeNewImage
global function RTKImageCrossfader_FadeScrollNewImage

global struct RTKImageCrossfader_Properties
{
	rtk_behavior animator
	rtk_behavior imageBottom
	rtk_behavior imageTop
}

void function RTKImageCrossfader_SetImage( rtk_behavior self, asset imageAsset, vector color = <1.0, 1.0, 1.0> )
{
	rtk_behavior ornull imageBottom = self.PropGetBehavior( "imageBottom" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )

	if ( imageBottom != null )
	{
		expect rtk_behavior( imageBottom )
		imageBottom.PropSetAssetPath( "assetPath", imageAsset )
		imageBottom.PropSetFloat3( "colorRGB", color )
	}

	if ( imageTop != null )
	{
		expect rtk_behavior( imageTop )
		imageTop.PropSetAssetPath( "assetPath", imageAsset )
		imageTop.PropSetFloat3( "colorRGB", color )
		imageTop.PropSetFloat( "alpha", 0 )
	}
}


void function RTKImageCrossfader_FadeNewImage( rtk_behavior self, asset imageAsset, vector color = <1.0, 1.0, 1.0>, float duration = 0.5 )
{
	rtk_behavior ornull animator = self.PropGetBehavior( "animator" )
	if ( animator == null )
		return

	expect rtk_behavior( animator )
	string animName = imageAsset != $"" ? "FadeIn" : "FadeOut"

	RTKImageCrossfader_SwapImage( self, imageAsset, color )
	RTKAnim_SetAnimationDuration( animator, animName, duration )
	RTKAnimator_PlayAnimation( animator, animName )
}


void function RTKImageCrossfader_FadeScrollNewImage( rtk_behavior self, asset imageAsset, vector color = <1.0, 1.0, 1.0>, float duration = 0.5, bool scrollDown = true )
{
	rtk_behavior ornull animator = self.PropGetBehavior( "animator" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )
	if ( animator == null || imageTop == null )
		return

	expect rtk_behavior( animator )
	expect rtk_behavior( imageTop )

	if ( imageAsset == imageTop.PropGetAssetPath( "assetPath" ) )
	{
		if ( color != imageTop.PropGetFloat3( "colorRGB" ) )
		{
			RTKImageCrossfader_FadeNewImage( self, imageAsset, color, duration )
		}

		return
	}

	string animName = imageAsset != $"" ? ( scrollDown ? "FadeInDown" : "FadeInUp" ) : "FadeOut"

	RTKImageCrossfader_SwapImage( self, imageAsset, color )
	RTKAnim_SetAnimationDuration( animator, animName, duration )
	RTKAnimator_PlayAnimation( animator, animName )
}

void function RTKImageCrossfader_SwapImage( rtk_behavior self, asset imageAsset, vector color = <1.0, 1.0, 1.0> )
{
	rtk_behavior ornull imageBottom = self.PropGetBehavior( "imageBottom" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )
	if ( imageBottom == null || imageTop == null )
		return

	expect rtk_behavior( imageBottom )
	expect rtk_behavior( imageTop )

	imageBottom.PropSetAssetPath( "assetPath", imageTop.PropGetAssetPath( "assetPath" ) )
	imageBottom.PropSetFloat3( "colorRGB", imageTop.PropGetFloat3( "colorRGB" ) )
	imageTop.PropSetAssetPath( "assetPath", imageAsset )
	imageTop.PropSetFloat3( "colorRGB", color )
}