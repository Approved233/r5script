
global function BaseEvents_Init



global function GetActiveBaseEvent



global function BaseEvent_IsEnabled
global function BaseEvent_GetLandingPageImage
global function BaseEvent_GetLandingPageBGButtonImage
global function BaseEvent_GetLandingPageButtonData
global function BaseEvent_GetLandingPageTitleData
global function BaseEvent_GetLandingPageSubtitleData
global function BaseEvent_GetLandingPageTitleOutlineInnerColor
global function BaseEvent_GetLandingPageTitleOutlineInnerAlpha
global function BaseEvent_GetLandingPageTitleOutlineOuterColor
global function BaseEvent_GetLandingPageTitleOutlineOuterAlpha


global struct RTKBaseEventLandingTitleData
{
	string		text
	int 		pixelHeight
	vector		color
	float		outlineWidth
}

global struct RTKBaseEventLandingSubtitleData
{
	int 		pixelHeight
	vector		color
}

global enum eEventLandingPageButtonRedirect
{
	LANDING = 0
	MILESTONES = 1
	COLLECTION = 2
	EVENT_SHOP = 3
	COLLECTION_EVENT = 4
	EVENT_STORE = 5
	PLAY_MODE = 6
	VGUI_PRIZE_TRACKER = 7 
	CUSTOM_DEEPLINK = 8
}


global struct BaseEventLandingPageButtonData
{
	asset 		image
	string		name
	asset		backgroundImage
	int			pageRedirectEnum

	string customDeeplinkType
	string customDeeplink
}



struct FileStruct_LifetimeLevel
{
	EntitySet chasePackGrantQueued
}





FileStruct_LifetimeLevel& fileLevel 

struct {
	
} fileVM 



bool function BaseEvent_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "enable_base_event", true )
}



void function BaseEvents_Init()
{

		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel

}



ItemFlavor ornull function GetActiveBaseEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_base_event ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple base events are active!! (%s, %s)", string(ItemFlavor_GetAsset( expect ItemFlavor(event) )), string(ItemFlavor_GetAsset( ev )) ) )
		event = ev
	}
	return event
}



asset function BaseEvent_GetLandingPageImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainLandingImage" )
}



array<BaseEventLandingPageButtonData> function BaseEvent_GetLandingPageButtonData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	array<BaseEventLandingPageButtonData> groups = []
	bool isRestricted = GRX_IsOfferRestricted()
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "buttonData" ) )
	{
		BaseEventLandingPageButtonData group
		if ( isRestricted )
		{
			string name = GetSettingsBlockString( groupBlock, "buttonNameRestricted" )
			asset image = GetSettingsBlockAsset( groupBlock, "buttonImageRestricted" )

			group.name 	= name == "" ? GetSettingsBlockString( groupBlock, "buttonName" ) : name
			group.image = image == $"" ? GetSettingsBlockAsset( groupBlock, "buttonImage" ) : image
		}
		else
		{
			group.image = GetSettingsBlockAsset( groupBlock, "buttonImage" )
			group.name 	= GetSettingsBlockString( groupBlock, "buttonName" )
		}
		group.backgroundImage = BaseEvent_GetLandingPageBGButtonImage( event )
		group.pageRedirectEnum = GetSettingsBlockInt( groupBlock, "pageRedirect" )
		group.customDeeplinkType = GetSettingsBlockString( groupBlock, "customDeeplinkType" )
		group.customDeeplink = GetSettingsBlockString( groupBlock, "customDeeplink" )
		groups.append( group )
	}
	return groups
}



asset function BaseEvent_GetLandingPageBGButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "buttonBackgroundImage" )
}



int function BaseEvent_GetLandingPageTitleSize( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsInt( ItemFlavor_GetAsset( event ), "landingPageTitleSize" )
}



vector function BaseEvent_GetLandingPageTitleColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "landingPageTitleColor" )
}



vector function BaseEvent_GetLandingPageTitleOutlineInnerColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "landingPageTitleOutlineInnerColor" )
}



float function BaseEvent_GetLandingPageTitleOutlineInnerAlpha( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( event ), "landingPageTitleOutlineInnerAlpha" )
}



vector function BaseEvent_GetLandingPageTitleOutlineOuterColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "landingPageTitleOutlineOuterColor" )
}



float function BaseEvent_GetLandingPageTitleOutlineOuterAlpha( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( event ), "landingPageTitleOutlineOuterAlpha" )
}



float function BaseEvent_GetLandingPageTitleOutlineWith( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( event ), "landingPageTitleOutlineWidth" )
}



int function BaseEvent_GetLandingPageSubtitleSize( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsInt( ItemFlavor_GetAsset( event ), "landingPageSubtitleSize" )
}



vector function BaseEvent_GetLandingPageSubtitleColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "landingPageSubtitleColor" )
}



RTKBaseEventLandingTitleData function BaseEvent_GetLandingPageTitleData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	RTKBaseEventLandingTitleData data
	data.text	= ItemFlavor_GetLongName( event )
	data.color = BaseEvent_GetLandingPageTitleColor( event )
	data.pixelHeight = BaseEvent_GetLandingPageTitleSize( event )
	data.outlineWidth = BaseEvent_GetLandingPageTitleOutlineWith( event )
	return data
}



RTKBaseEventLandingSubtitleData function BaseEvent_GetLandingPageSubtitleData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_base_event )
	RTKBaseEventLandingSubtitleData data
	data.color = BaseEvent_GetLandingPageSubtitleColor( event )
	data.pixelHeight = BaseEvent_GetLandingPageSubtitleSize( event )
	return data
}

