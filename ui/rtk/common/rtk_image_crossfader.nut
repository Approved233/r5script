global function RTKImageCrossfader_InitMetaData
global function RTKImageCrossfader_OnDestroy

global function RTKImageCrossfader_SetImage
global function RTKImageCrossfader_FadeNewImage
global function RTKImageCrossfader_FadeScrollNewImage

global struct RTKImageCrossfader_Properties
{
	rtk_behavior animator
	rtk_behavior imageBottom
	rtk_behavior imageTop
}

void function RTKImageCrossfader_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "KillExistingImageCrossfaderThreads" )
}

void function RTKImageCrossfader_OnDestroy( rtk_behavior self )
{
	Signal( self, "KillExistingImageCrossfaderThreads" )
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
		imageBottom.PropSetFloat( "alpha", 1 )
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
	string animName = imageAsset != $"" ? "FadeIn" : "FadeOut"
	DoSwapAndFade( self, imageAsset, color, duration, animName )
}


void function RTKImageCrossfader_FadeScrollNewImage( rtk_behavior self, asset imageAsset, vector color = <1.0, 1.0, 1.0>, float duration = 0.5, bool scrollDown = true )
{
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )
	if ( imageTop == null )
		return

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
	DoSwapAndFade( self, imageAsset, color, duration, animName )
}

void function DoSwapAndFade( rtk_behavior self, asset imageAsset, vector color, float duration, string animName )
{
	rtk_behavior ornull imageBottom = self.PropGetBehavior( "imageBottom" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )
	rtk_behavior ornull animator = self.PropGetBehavior( "animator" )
	if ( imageBottom == null || imageTop == null || animator == null )
		return

	expect rtk_behavior( imageBottom )
	expect rtk_behavior( imageTop )
	expect rtk_behavior( animator )

	Signal( self, "KillExistingImageCrossfaderThreads" )

	
	imageBottom.PropSetFloat( "alpha", 1 )
	imageTop.PropSetAssetPath( "assetPath", imageAsset )
	imageTop.PropSetFloat3( "colorRGB", color )
	imageTop.PropSetFloat( "alpha", 0 )

	
	RTKAnim_SetAnimationDuration( animator, animName, duration )
	RTKAnimator_PlayAnimation( animator, animName )

	
	thread Fade_Thread( self, imageBottom, imageTop, animator, animName )
}

void function Fade_Thread( rtk_behavior self, rtk_behavior imageBottom, rtk_behavior imageTop, rtk_behavior animator, string animName )
{
	Signal( self, "KillExistingImageCrossfaderThreads" )
	EndSignal( self, "KillExistingImageCrossfaderThreads" )

	OnThreadEnd(
		function() : ( imageBottom, imageTop )
		{
			imageBottom.PropSetAssetPath( "assetPath", imageTop.PropGetAssetPath( "assetPath" ) )
			imageBottom.PropSetFloat3( "colorRGB", imageTop.PropGetFloat3( "colorRGB" ) )
		}
	)

	while ( RTKAnimator_IsPlayingAnimation( animator, animName ) )
		WaitFrame()

	imageBottom.PropSetAssetPath( "assetPath", imageTop.PropGetAssetPath( "assetPath" ) )
	imageBottom.PropSetFloat3( "colorRGB", imageTop.PropGetFloat3( "colorRGB" ) )
}