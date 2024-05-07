



global function RTKAutoCrossfader_InitMetaData
global function RTKAutoCrossfader_OnInitialize
global function RTKAutoCrossfader_OnDestroy

const float AUTO_CROSSFADE_TIME = 3.0

global struct RTKAutoCrossfaderImageModel
{
	asset	image
	bool	active
}

global struct RTKAutoCrossfader_Properties
{
	rtk_behavior imageFader
}

struct PrivateData
{
	int activeIndex = 0
}

void function RTKAutoCrossfader_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "KillExistingAutoCrossfaderThreads" )
}

void function RTKAutoCrossfader_OnInitialize( rtk_behavior self )
{
	thread UpdateAutoCrossfader_Thread( self )
}

void function RTKAutoCrossfader_OnDestroy( rtk_behavior self )
{
	Signal( self, "KillExistingAutoCrossfaderThreads" )
}

void function UpdateAutoCrossfader_Thread( rtk_behavior self )
{
	Signal( self, "KillExistingAutoCrossfaderThreads" )
	EndSignal( self, "KillExistingAutoCrossfaderThreads" )

	PrivateData p
	self.Private( p )
	p.activeIndex = 0

	rtk_array images = RTKDataModel_GetArray( self.GetPanel().GetBindingRootPath() )
	int imageCount = RTKArray_GetCount( images )
	if ( imageCount == 0 )
		return

	
	rtk_struct entry = RTKArray_GetStruct( images, p.activeIndex )
	RTKStruct_SetBool( entry, "active", true )

	
	rtk_behavior imageFader = self.PropGetBehavior( "imageFader" )
	RTKImageCrossfader_SetImage( imageFader, RTKStruct_GetAssetPath( entry, "image" ) )

	while ( true )
	{
		wait AUTO_CROSSFADE_TIME

		
		RTKStruct_SetBool( entry, "active", false )

		if ( p.activeIndex < imageCount - 1 )
			p.activeIndex++
		else
			p.activeIndex = 0

		
		entry = RTKArray_GetStruct( images, p.activeIndex )
		RTKStruct_SetBool( entry, "active", true )

		
		RTKImageCrossfader_FadeNewImage( imageFader, RTKStruct_GetAssetPath( entry, "image" ) )
	}
}
