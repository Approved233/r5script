global function RTKImageCrossfader_SetImage
global function RTKImageCrossfader_FadeNewImage

global struct RTKImageCrossfader_Properties
{
	rtk_behavior animator
	rtk_behavior imageBottom
	rtk_behavior imageTop
}

void function RTKImageCrossfader_SetImage( rtk_behavior self, asset imageAsset )
{
	rtk_behavior ornull imageBottom = self.PropGetBehavior( "imageBottom" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )

	if ( imageBottom != null )
	{
		expect rtk_behavior( imageBottom )
		imageBottom.PropSetAssetPath( "assetPath", imageAsset )
	}

	if ( imageTop != null )
	{
		expect rtk_behavior( imageTop )
		imageTop.PropSetAssetPath( "assetPath", imageAsset )
		imageTop.PropSetFloat( "alpha", 0 )
	}
}


void function RTKImageCrossfader_FadeNewImage( rtk_behavior self, asset imageAsset, float duration = 0.5 )
{
	rtk_behavior ornull animator = self.PropGetBehavior( "animator" )
	rtk_behavior ornull imageBottom = self.PropGetBehavior( "imageBottom" )
	rtk_behavior ornull imageTop = self.PropGetBehavior( "imageTop" )
	if ( animator == null || imageBottom == null || imageTop == null )
		return

	expect rtk_behavior( animator )
	expect rtk_behavior( imageBottom )
	expect rtk_behavior( imageTop )

	asset imageAssetOld = imageTop.PropGetAssetPath( "assetPath" )
	imageBottom.PropSetAssetPath( "assetPath", imageAssetOld )
	imageTop.PropSetAssetPath( "assetPath", imageAsset )

	rtk_array anims  = animator.PropGetArray( "tweenAnimations" )
	int animCount = RTKArray_GetCount( anims )
	string animName = imageAsset != $"" ? "FadeIn" : "FadeOut"

	for ( int i = 0; i < animCount; i++ )
	{
		rtk_struct anim = RTKArray_GetStruct( anims, i )
		if ( RTKStruct_GetString( anim, "name" ) != animName )
			continue

		rtk_array tweens = RTKStruct_GetArray( anim, "tweens" )
		int tweenCount = RTKArray_GetCount( tweens )
		for ( int j = 0; j < tweenCount; j++ )
		{
			RTKStruct_SetFloat( RTKArray_GetStruct( tweens, j ), "duration", duration )
		}
	}

	RTKAnimator_PlayAnimation( animator, animName )
}