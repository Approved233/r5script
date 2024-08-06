global function OnBattlepassCarouselPakLoaded

global function RTKBattlepassCarouselController_OnInitialize
global function RTKBattlepassCarouselController_OnDestroy
global function RTKBattlepassCarouselController_AdvanceCarousel
global function RTKBattlepassCarouselController_InitMetaData

global struct RTKBattlepassCarouselController_Properties
{
	rtk_behavior button
	int passType = 0 
}

global struct RTKBattlepassCarouselController_ModelStruct
{

}

global struct RTKBattlepassCarouselInfo
{
	string name = ""
	string description = ""
	asset image = $""
	string imageName
	array<float> progress
	bool showProgress
	string linkType
	string link
	array<string> linkData
	string fromPageId
	string trackingId = ""
	int carouselIndex
	int messageType
}

struct PrivateData
{
	void functionref() OnGRXStateChanged

	array< RTKBattlepassCarouselInfo > carouselInfos
	int        currentCarouselItemIndex = 0
	float      offerChangeStartTime = 0
	float      lastOfferChangeTimeUpdate = -1
	float      nextOfferChangeTime = 0
	bool       callbacksInitialised = false
}

struct FileStruct_SessionPersistence
{
	string lastLoadedPakName = ""
}
FileStruct_SessionPersistence& file

const float CAROUSEL_DELAY = 5.0

void function OnBattlepassCarouselPakLoaded( string pakName = "" )
{
	file.lastLoadedPakName = pakName
	Signal( uiGlobal.signalDummy, "RTKBattlepassCarouselPakLoaded" )
}

void function RTKBattlepassCarouselController_WaitPakLoaded( rtk_behavior self )
{
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassCarouselDestroyed" )

	int passType = self.PropGetInt( "passType" )
	rtk_struct battlepassModelStruct = GetPassModel( passType )
	PrivateData p
	self.Private( p )

	while ( true )
	{
		WaitSignal( uiGlobal.signalDummy, "RTKBattlepassCarouselPakLoaded" )
		WaitFrame()

		if ( p.carouselInfos.len() == 0 || p.currentCarouselItemIndex >= p.carouselInfos.len() )
			continue

		if ( p.carouselInfos[ p.currentCarouselItemIndex ].imageName != file.lastLoadedPakName)
			continue

		BuildCarouselInfo( self, battlepassModelStruct, p.carouselInfos[ p.currentCarouselItemIndex ] )
	}

}

void function RTKBattlepassCarouselController_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "RTKBattlepassCarouselPakLoaded" )
	RegisterSignal( "RTKBattlepassCarouselDestroyed" )
	RegisterSignal( "RTKBattlepassEndAutoAdvance" )
}

void function RTKBattlepassCarouselController_OnInitialize( rtk_behavior self )
{
	int passType = self.PropGetInt( "passType" )
	rtk_struct battlepassModelStruct = GetPassModel( passType )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, GetPassModelName( passType ) + ".carouselInfo", true ) )

	thread function() : ( self, battlepassModelStruct )
	{
		while ( !IsFullyConnected() )
			WaitFrame()

		RTKBattlepassControllerPanel_OnInitializedAndConnected( self, battlepassModelStruct )
	}()
}

void function RTKBattlepassControllerPanel_OnInitializedAndConnected( rtk_behavior self, rtk_struct battlepassModelStruct )
{
	ItemFlavor ornull activePass = GetActiveBattlePass()
	if ( activePass == null )
	{
		return
	}
	expect ItemFlavor( activePass )

	asset battlePassAsset = ItemFlavor_GetAsset( activePass )

	PrivateData p
	self.Private( p )
	p.OnGRXStateChanged = (void function() : (self, battlepassModelStruct, activePass, battlePassAsset)
	{
		if ( !GRX_IsInventoryReady() )
			return

		if ( !GRX_AreOffersReady() )
			return

		thread AutoAdvanceCarousel( self, battlepassModelStruct, battlePassAsset )
	})

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )

	rtk_behavior ornull button = self.PropGetBehavior( "button" )
	if ( button != null )
	{
		expect rtk_behavior( button )
		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, battlepassModelStruct ) {
			int passType = self.PropGetInt( "passType" )
			PrivateData p
			self.Private( p )
			rtk_struct carouselInfo = RTKStruct_GetOrCreateScriptStruct( battlepassModelStruct, "carouselInfo", "RTKBattlepassCarouselInfo" )

			PIN_UM_Message( RTKStruct_GetString( carouselInfo, "name" ),
				RTKStruct_GetString( carouselInfo, "trackingId" ),
				GetPassModelName( passType ) + "_um",
				ePINPromoMessageStatus.CLICK,
				p.currentCarouselItemIndex
			)
		} )
	}

	p.callbacksInitialised = true
}

void function RTKBattlepassCarouselController_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	if ( p.callbacksInitialised )
	{
		RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
		RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
		p.callbacksInitialised = false
	}
	Signal( uiGlobal.signalDummy, "RTKBattlepassEndAutoAdvance" )
	Signal( uiGlobal.signalDummy, "RTKBattlepassCarouselDestroyed" )
}

void function AutoAdvanceCarousel( rtk_behavior self, rtk_struct battlepassModelStruct, asset battlePassAsset )
{
	Signal( uiGlobal.signalDummy, "RTKBattlepassEndAutoAdvance" )
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassEndAutoAdvance" )

	PrivateData p
	self.Private( p )

	UMData um = EADP_UM_GetPromoData()

	int passType = self.PropGetInt( "passType" )
	int motdIndex = 0

	foreach ( int i, UMAction action in um.actions )
	{
		if ( ( passType == ePassType.BATTLEPASS && !IsValidUMAction( action, UM_LOCATION_BATTLEPASS ) ) ||
		   ( passType == ePassType.NEWPLAYER && !IsValidUMAction( action, UM_LOCATION_NEW_PLAYER_BATTLEPASS )) ||
		   ( passType == ePassType.INVALID ) )
		{
			continue
		}

		RTKBattlepassCarouselInfo itemInfo
		itemInfo.fromPageId = "battlepass"
		itemInfo.trackingId = action.trackingId

		foreach ( int j, UMItem item in action.items )
		{
			if ( item.name == "MiniPromoText" )
			{
				itemInfo.name = item.value
			}
			else if ( item.name == "MiniPromoExtraText" )
			{
				itemInfo.description = item.value
			}
			else if ( item.name == "Link" )
			{
				itemInfo.linkData.append( item.value )
				foreach ( attr in item.attributes )
				{
					if ( attr.key == "LinkType" )
						itemInfo.linkType = attr.value
				}
				itemInfo.link = itemInfo.linkData[0]
			}
			else if ( item.name == "ImageRef" )
			{
				itemInfo.imageName = item.value
				if ( !GetConVarBool( "assetdownloads_enabled" ) )
				{
					itemInfo.image = GetPromoImage( item.value )
				}
				else
				{
					itemInfo.image = GetDownloadedImageAsset( item.value, item.value, ePakType.DL_BATTLEPASS_UM )
				}
			}
			else if ( item.name == "MessageType" )
			{
				if ( item.value == "message" )
				{
					itemInfo.messageType = eBattlepassUMType.MESSAGE
				}
				else if ( item.value == "deeplink" )
				{
					itemInfo.messageType = eBattlepassUMType.DEEPLINK
				}
			}
		}

		if ( itemInfo.linkType == "" )
			itemInfo.linkType = "openmotd"

		if ( itemInfo.messageType == eBattlepassUMType.MESSAGE )
		{
			itemInfo.carouselIndex = motdIndex++
		}

		p.carouselInfos.push(itemInfo)
	}

	if ( p.carouselInfos.len() <= p.currentCarouselItemIndex )
	{
		RTKBattlepassCarouselInfo itemInfo
		itemInfo.name = ""
		itemInfo.description = ""
		itemInfo.image = $"rui/menu/battlepass/battlepass_new/bp_backup_display_image"
		itemInfo.linkType = "challenges"
		itemInfo.link = ""
		itemInfo.fromPageId = "battlepass"
		p.carouselInfos.push(itemInfo)
	}

	BuildCarouselInfo( self, battlepassModelStruct, p.carouselInfos[ p.currentCarouselItemIndex ] )

	if ( p.carouselInfos.len() <= 1 )
		return

	thread RTKBattlepassCarouselController_WaitPakLoaded( self )

	string passModelName = GetPassModelName( passType )

	while ( true )
	{

		if ( !RTKDataModel_HasDataModel( "&menus." + passModelName + ".carouselInfo.progress" ) )
			return

		if ( p.nextOfferChangeTime != p.lastOfferChangeTimeUpdate )
		{
			p.nextOfferChangeTime = ClientTime() + CAROUSEL_DELAY
			p.offerChangeStartTime = ClientTime()
			p.lastOfferChangeTimeUpdate = p.nextOfferChangeTime
		}

		float remainingTime = p.nextOfferChangeTime - ClientTime()
		float totalTime = p.nextOfferChangeTime - p.offerChangeStartTime
		float progress = remainingTime/totalTime
		rtk_array arr = RTKDataModel_GetArray( "&menus." + passModelName + ".carouselInfo.progress" )
		RTKArray_SetFloat( arr, p.currentCarouselItemIndex, progress )

		if ( progress < 0.0 )
		{
			p.currentCarouselItemIndex++
			if ( p.currentCarouselItemIndex > p.carouselInfos.len() - 1 || p.currentCarouselItemIndex > 5 )
				p.currentCarouselItemIndex = 0

			if ( GRX_IsInventoryReady() )
				BuildCarouselInfo( self, battlepassModelStruct, p.carouselInfos[p.currentCarouselItemIndex] )
			p.nextOfferChangeTime = ClientTime() + CAROUSEL_DELAY
		}

		WaitFrame()
	}
}

void function RTKBattlepassCarouselController_AdvanceCarousel( rtk_behavior self, int direction = 1 )
{
	PrivateData p
	self.Private( p )
	p.nextOfferChangeTime = ClientTime() + CAROUSEL_DELAY

	p.currentCarouselItemIndex += direction
	if ( p.currentCarouselItemIndex < 0 )
	{
		p.currentCarouselItemIndex = p.carouselInfos.len() - 1
	}

	if ( p.currentCarouselItemIndex > p.carouselInfos.len() - 1 || p.currentCarouselItemIndex > 5 )
	{
		p.currentCarouselItemIndex = 0
	}

	if ( GRX_IsInventoryReady() )
	{
		int passType = self.PropGetInt( "passType" )
		rtk_struct battlepassModelStruct = GetPassModel( passType )
		BuildCarouselInfo( self, battlepassModelStruct, p.carouselInfos[p.currentCarouselItemIndex] )
	}
}

void function BuildCarouselInfo( rtk_behavior self, rtk_struct battlepassModelStruct, RTKBattlepassCarouselInfo carouselItemInstance )
{
	PrivateData p
	self.Private( p )

	RTKBattlepassCarouselInfo itemInfo
	itemInfo.name = carouselItemInstance.name
	itemInfo.description = carouselItemInstance.description
	itemInfo.linkType = carouselItemInstance.linkType
	itemInfo.link = carouselItemInstance.link
	itemInfo.fromPageId = carouselItemInstance.fromPageId
	itemInfo.carouselIndex = carouselItemInstance.carouselIndex
	itemInfo.messageType = carouselItemInstance.messageType

	if ( carouselItemInstance.imageName != "" )
	{
		if ( !GetConVarBool( "assetdownloads_enabled" ) )
		{
			itemInfo.image = GetPromoImage( carouselItemInstance.imageName )
		}
		else
		{
			itemInfo.image = GetDownloadedImageAsset( carouselItemInstance.imageName, carouselItemInstance.imageName, ePakType.DL_BATTLEPASS_UM )
		}
	}

	if ( itemInfo.image == $"" )
	{
		itemInfo.image = carouselItemInstance.image
	}

	foreach ( featuredItem in p.carouselInfos )
	{
		itemInfo.progress.append( 0 )
	}

	rtk_struct carouselInfo = RTKStruct_GetOrCreateScriptStruct( battlepassModelStruct, "carouselInfo", "RTKBattlepassCarouselInfo" )
	RTKStruct_SetValue( carouselInfo, itemInfo )
	RTKStruct_SetBool( carouselInfo, "showProgress", p.carouselInfos.len() > 1 )
}
