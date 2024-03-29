global function InitStoreItemShop

global function RTKStoreItemShop_OnInitialize
global function RTKStoreItemShop_OnDestroy
global function RTKStoreGridSection_OnInitialize
global function RTKStoreGridItem_OnInitialize
global function RTKStoreGridItem_SetItemSize

global function RTKStore_RegisterOffer
global function RTKStore_GetOfferFromIndex
global function RTKStore_RevealPersonalizedOffer
global function RTKStore_SetOverrideStartingSection
global function RTKStore_SetStartingSection
global function RTKStore_InspectOffer
global function RTKStore_InspectOffer_SaveTelemetryData

global function StoreTelemetry_SendOferPageViewEvent
global function StoreTelemetry_SaveDeepLink

global function RTKMutator_GetLoadAssetFromGridItemType
global function RTKMutator_GetGradientAssetFromGridItemType

const asset DEFAULT_BG_ASSET = $"ui_image/rui/menu/store/backgrounds/store_background_default.rpak"

global enum eStoreGridItemType
{
	OFFER_1_1 	= 0,
	OFFER_2_1 	= 1,
	OFFER_1_2 	= 2,
	OFFER_2_2 	= 3,
	DIVIDER		= 4,
	INFO_PANEL	= 5,
	INFO_BUTTON = 6,
	BLANK		= 7,
	BUNDLE		= 8,
	TAKEOVER	= 9,
	OFFER_PERSONAL = 10,
	OFFER_3_2	= 11,
}

const table<string, asset> STORE_SECTION_BG_MAP =
{
	
	[ "#STORE_V2_SECTION_FEATURED" ] 			= $"ui_image/rui/menu/store/backgrounds/store_background_default.rpak",
	[ "#FIFTH_ANNIVERSARY_COLLECTION_EVENT" ] 	= $"ui_image/rui/menu/store/backgrounds/store_background_fifth_anni.rpak",
	[ "#INNER_BEAST_COLLECTION_EVENT" ] 		= $"ui_image/rui/menu/store/backgrounds/store_background_inner_beast.rpak",
	[ "#VALENTINES_DAY" ] 						= $"ui_image/rui/menu/store/backgrounds/store_background_vday.rpak",
	[ "#STEELED_DEMON_STORE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_steeled_demon.rpak",
	[ "#MOLTEN_MAYHEM_PACK_SALE" ] 				= $"ui_image/rui/menu/store/backgrounds/store_background_molten_mayhem.rpak",
	[ "#MOLTEN_MAYHEM_STORE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_molten_mayhem.rpak",

	
	[ "#NOIR_MOBSTERS_MILESTONE_EVENT" ] 		= $"ui_image/rui/menu/store/backgrounds/store_background_noir_mobsters.rpak",
	[ "#URBAN_ASSAULT_COLLECTION_EVENT" ] 		= $"ui_image/rui/menu/store/backgrounds/store_background_urban_assault.rpak",
	[ "#SUN_WARRIOR_STORE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_sun_warrior.rpak",
	[ "#VIVID_NIGHTS_STORE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_vivid_nights.rpak",
	[ "#POLY_PROWLER_STORE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_poly_prowlers.rpak",
	[ "#GOLDEN_WEEK_SALE" ] 					= $"ui_image/rui/menu/store/backgrounds/store_background_golden_week.rpak",
	[ "#GOLDEN_WEEK_ORIGINALS" ] 				= $"ui_image/rui/menu/store/backgrounds/store_background_golden_week.rpak",

}

const table<string, vector> STORE_SECTION_BG_TINT_MAP =
{
	[ "#THIRD_ANNIVERSARY_SQUADS" ] 		= <206, 163, 54>,
	[ "#FOURTH_ANNIVERSARY_SQUADS" ] 		= <206, 163, 54>,
	[ "#STORE_V2_SECTION_PERSONALIZED" ]	= <511, 0, 0>,
	[ "#STORE_V2_SECTION_MONTHLY" ] 		= <280, 268, 247>,
	[ "#STORE_V2_SECTION_RECOLORS" ] 		= <204, 204, 204>,
	[ "#STORE_V2_SECTION_BATTLEPASS" ] 		= <0,0,230>,
}

const array<string> STORE_SECTION_KEY_ART_LIST =
[
	"#STEELED_DEMON_STORE",
	"#SUN_WARRIOR_STORE",
]

global struct RTKStoreGridItem_Properties
{
	int 			gridItemType
	rtk_behavior 	gridContainerElement
}

global struct RTKStoreGridSection_Properties
{
	string			sectionName
	rtk_behavior	paginationBehavior
	rtk_behavior 	paginationAnimBehavior
}

global struct RTKStoreItemShop_Properties
{
	rtk_behavior 	paginationBehavior
	rtk_behavior 	paginationAnimBehavior
	rtk_behavior 	backgroundImageFader

	rtk_panel		contentPanel
}

global struct RTKStoreGridItemModel
{
	
	int 	slotIndex
	int 	gridItemType
	asset 	mainImage
	string 	mainText 		
	string 	subText			
	string 	miscText1		
	string 	miscText2		
	string 	miscText3		
	bool	miscBool		

	
	int 	offerIndex = -1
	string  imageRef
	int 	rarity
	bool 	newPriceShow
	string 	discount
	vector 	priceColor
	vector 	newPriceColor
	bool 	isOnlyGiftable
	asset 	sourceIcon
}

global struct RTKStoreSectionModel
{
	int								sectionEnum = -1
	int                             sectionId = 0
	string                          sectionName
	int                             endTime
	int								startPageIndex
	array<RTKStoreGridItemModel> 	itemsArray
	asset                           bgAsset = DEFAULT_BG_ASSET
	vector							bgTint = <1.0, 1.0, 1.0>
	bool                            sectionVisible
}

global struct RTKStoreModel
{
	array<RTKStoreSectionModel>	sections
	string 						prevSection
	string						nextSection
	int							startPageIndex
}

struct PrivateData
{
	int         menuGUID = -1
	rtk_struct	storeItemShopModel
}

struct
{
	RTKStoreModel &fullStoreModel
	int personalizedSectionIndex
	array<GRXScriptOffer> allCurrentOffers

	bool overrideStartingSection = false
	string startingSectionOverride = ""
	int startingPageOverride = 0
} file

struct
{
	string pageName
	string prevPage
	int prevPageDuration
	int prevPageTimeStamp
	int pageNum
	int sectionNum
	string linkName
	string clickType

	string offerName
	int offerPriority
	string slotType
} fileTelemetry

const string SECTIONS 		= "sections"
const string PREV_SECTION 	= "prevSection"
const string NEXT_SECTION 	= "nextSection"

void function RTKStoreItemShop_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	
	if ( file.fullStoreModel.sections.len() <= 0 )
		return

	
	int sectionIndex = RTKPagination_GetCurrentPage( self.PropGetBehavior( "paginationBehavior" ) )
	rtk_panel contentPanel = self.PropGetPanel( "contentPanel" )
	rtk_behavior sectionBehavior = contentPanel.GetChildren()[sectionIndex].FindBehaviorByTypeName( "StoreGridSection" )
	string lastViewedSectionName = file.fullStoreModel.sections[sectionIndex].sectionName
	int lastViewedSectionPage = RTKStoreGridSection_GetCurrentPage( sectionBehavior )
	RTKStore_SetStartingSection( lastViewedSectionName, lastViewedSectionPage )
	UpdateSmartMerchandisingData()

	
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "storeItemShop" )
	file.allCurrentOffers.clear()

	if ( GetActiveMenu() != null )
	{
		var menu = GetActiveMenu()
		MenuDisableDpad( menu, false)
	}
}

void function RTKStoreItemShop_OnInitialize( rtk_behavior self )
{
	var menu = GetActiveMenu()
	MenuDisableDpad( menu, true )

	PrivateData p
	self.Private( p )

	if ( RTKDataModel_HasDataModel( "menus.storeItemShop" ) )
	{
		RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "storeItemShop" )
	}

	p.storeItemShopModel = RTKDataModel_CreateStruct( RTK_MODELTYPE_MENUS, "storeItemShop", "RTKStoreModel" )
	self.GetPanel().SetBindingRootPath( "&menus.storeItemShop" )
	RTKStoreItemShop_GetStoreData( self )

	
	if ( file.fullStoreModel.sections.len() <= 0 )
	{
		rtk_behavior backgroundFader = self.PropGetBehavior( "backgroundImageFader" )
		RTKImageCrossfader_SetImage( backgroundFader, DEFAULT_BG_ASSET )
		return
	}

	GoToStartingSection( self )

	
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )
	self.AutoSubscribe( pagination, "onScrollStarted", function () : ( self ) {
		RTKStoreItemShop_OnScrollStarted( self )
	} )
	self.AutoSubscribe( pagination, "onScrollFinished", function () : ( self ) {
		RTKStoreItemShop_OnScrollFinished( self )
	} )

	
	int currentPageIndex = RTKStruct_GetInt( p.storeItemShopModel, "startPageIndex" )
	asset backgroundAsset = GetBackgroundAssetFromSectionIndex( currentPageIndex )
	vector backgroundTint = GetBackgroundTintFromSectionIndex( currentPageIndex )
	rtk_behavior backgroundFader = self.PropGetBehavior( "backgroundImageFader" )
	RTKImageCrossfader_SetImage( backgroundFader, backgroundAsset, backgroundTint )
}

void function RTKStoreItemShop_GetStoreData( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKStoreModel storeModel
	rtk_array storeSectionsArray = RTKStruct_GetArray( p.storeItemShopModel, SECTIONS )

	table<int, StoreSectionInfo> storeData = GetSortedStoreSectionData()

	for ( int sectionEnum = 0; sectionEnum < eStoreSections._COUNT; sectionEnum++ )
	{
		RTKStoreSectionModel section
		StoreSectionInfo sectionInfo
		if ( sectionEnum in storeData )
			sectionInfo = storeData[sectionEnum]

		switch( sectionEnum )
		{
			case eStoreSections.Personalized:
				section = GetPersonalizedSection()
				break

			case eStoreSections.Event:
				if ( sectionEnum in storeData )
					section = GetEventSection( sectionInfo.offers )
				else if ( GetActiveMilestoneEvent( GetUnixTimestamp() ) != null )
				{
					array<GRXScriptOffer> offers
					section = GetEventSection( offers )
				}
				break

			case eStoreSections.Flex1:
			case eStoreSections.Flex2:
			case eStoreSections.Flex3:
				if ( sectionEnum in storeData )
					section = GetFlexSection( sectionInfo.offers, sectionInfo.sectionName )
				break

			case eStoreSections.BattlepasShop:
				if ( sectionEnum in storeData )
					section = GetBattlePassSection( sectionInfo.offers )
				break

			case eStoreSections.Recolor:
				if ( sectionEnum in storeData )
					section = GetRecolorSection( sectionInfo.offers )
				break

			default:
				if ( sectionEnum in storeData )
					section = GetSectionFromOffers( sectionInfo.offers )
				break
		}

		if ( section.itemsArray.len() <= 0 )
			continue

		section.sectionEnum = sectionEnum
		if ( sectionEnum in storeData )
		{
			section.sectionId   = sectionInfo.sectionId
			section.sectionName = sectionInfo.sectionName
			if ( SectionShouldBeMarkedAsNew( sectionInfo ) )
				ClearHighestPageSeenForSection( sectionInfo.sectionId )
		}
		if ( section.sectionName in STORE_SECTION_BG_MAP )
		{
			section.bgAsset = STORE_SECTION_BG_MAP[section.sectionName]
		}
		if ( section.sectionName in STORE_SECTION_BG_TINT_MAP )
		{
			section.bgTint = STORE_SECTION_BG_TINT_MAP[section.sectionName] / 255
		}

		storeModel.sections.append( section )

		rtk_struct rtkSection = RTKArray_PushNewStruct( storeSectionsArray )
		RTKStruct_SetInt( rtkSection, "endTime", section.endTime )
		RTKStruct_SetString( rtkSection, "sectionName", section.sectionName )
	}

	file.fullStoreModel = storeModel
}

void function RTKStore_SetOverrideStartingSection( bool override = true )
{
	file.overrideStartingSection = override
}

void function RTKStore_SetStartingSection( string sectionName, int startingPage = 0 )
{
	file.startingSectionOverride = sectionName
	file.startingPageOverride = startingPage
}

void function RTKStore_InspectOffer( int offerIndex, int slotIndex )
{
	EmitUISound( "UI_Menu_Accept" )
	GRXScriptOffer offer = RTKStore_GetOfferFromIndex( offerIndex )
	if ( offer.output.flavors.len() <= 0 )
		return

	
	StoreInspectMenu_AttemptOpenWithOffer( offer )
	RTKStore_SetOverrideStartingSection()

	
	RTKStore_InspectOffer_SaveTelemetryData( offer, slotIndex )
	StoreTelemetry_SendOferPageViewEvent()
}

void function RTKStore_InspectOffer_SaveTelemetryData( GRXScriptOffer offer, int slotIndex )
{
	fileTelemetry.prevPageDuration = int( UITime() ) - fileTelemetry.prevPageTimeStamp
	fileTelemetry.prevPageTimeStamp = int ( UITime() )
	fileTelemetry.offerName = offer.offerAlias
	fileTelemetry.offerPriority = slotIndex
}

void function GoToStartingSection( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	int startingSectionIndex = RTKStoreItemShop_GetStartingSectionIndex( self )
	rtk_array storeSectionsArray = RTKStruct_GetArray( p.storeItemShopModel, SECTIONS )
	rtk_struct storeSection = RTKArray_GetStruct( storeSectionsArray, startingSectionIndex )
	int startingSectionPage = file.startingPageOverride 

	RTKStruct_SetInt( p.storeItemShopModel, "startPageIndex", startingSectionIndex )
	RTKStruct_SetInt( storeSection, "startPageIndex", startingSectionPage )
	RTKStoreItemShop_SetCurrentSectionsInfo( self, startingSectionIndex )
	SetOnlySectionVisible( self, startingSectionIndex )

	
	RTKStoreItemShop_UpdateSmartMerchandisingData( self, startingSectionIndex, startingSectionPage + 1 )

	
	fileTelemetry.sectionNum = startingSectionIndex
	int pageNum = startingSectionPage
	string pageName = file.fullStoreModel.sections[startingSectionIndex].sectionName

	fileTelemetry.prevPage = fileTelemetry.pageName
	fileTelemetry.pageName = pageName + "_" + string( pageNum )
	fileTelemetry.prevPageDuration = int( UITime() ) - fileTelemetry.prevPageTimeStamp
	fileTelemetry.prevPageTimeStamp = int ( UITime() )
	fileTelemetry.pageNum = pageNum

	if ( fileTelemetry.linkName != "" )
		fileTelemetry.clickType = "deeplink"
	StoreTelemetry_SendStorePageViewEvent()
	fileTelemetry.linkName = ""
}

int function RTKStoreItemShop_GetStartingSectionIndex( rtk_behavior self )
{
	int startingSectionIndex = 0

	
	if ( file.overrideStartingSection )
	{
		foreach ( int index, section in file.fullStoreModel.sections )
		{
			if ( section.sectionName == file.startingSectionOverride )
				startingSectionIndex = index
		}

		file.overrideStartingSection = false
		return startingSectionIndex
	}

	
	array<int> unseenSections
	foreach ( int index, section in file.fullStoreModel.sections )
	{
		if ( !HasSectionBeenSeen( section.sectionId ) )
			unseenSections.append( index )
	}

	
	if ( unseenSections.len() >= file.fullStoreModel.sections.len() )
		return startingSectionIndex


	
	if ( unseenSections.len() > 0 )
	{
		int randResult = RandomIntRange( 0, unseenSections.len() )
		startingSectionIndex = unseenSections[randResult]
		file.startingPageOverride = 0
	}
	else
	{
		int lastViewedSectionId  = GetMostRecentlySeenSection()
		foreach ( int index, section in file.fullStoreModel.sections )
		{
			if ( section.sectionId == lastViewedSectionId )
			{
				startingSectionIndex = index
				break
			}
		}
	}

	return startingSectionIndex
}

void function RTKStoreItemShop_OnScrollStarted( rtk_behavior self )
{
	
	rtk_behavior paginationBehavior = self.PropGetBehavior( "paginationBehavior" )
	int currentPageIndex = RTKPagination_GetCurrentPage( paginationBehavior )
	int targetPageIndex = RTKPagination_GetTargetPage( paginationBehavior )
	if ( targetPageIndex != currentPageIndex )
	{
		asset backgroundAsset = GetBackgroundAssetFromSectionIndex( targetPageIndex )
		vector backgroundTint = GetBackgroundTintFromSectionIndex( targetPageIndex )
		rtk_behavior backgroundFader = self.PropGetBehavior( "backgroundImageFader" )
		RTKImageCrossfader_FadeScrollNewImage( backgroundFader, backgroundAsset, backgroundTint, 0.35, targetPageIndex < currentPageIndex )
	}

	RTKStoreItemShop_SetCurrentSectionsInfo( self, targetPageIndex )
	SetSectionVisible( self, targetPageIndex, true )
}

void function RTKStoreItemShop_OnScrollFinished( rtk_behavior self )
{
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )
	int pageIndex = RTKPagination_GetCurrentPage( pagination )
	SetOnlySectionVisible( self, pageIndex )

	
	RTKStoreItemShop_UpdateSmartMerchandisingData( self )

	
	fileTelemetry.clickType = RTKPagination_GetLastNavType( pagination )
	fileTelemetry.linkName = ""
	RTKStoreItemShop_SaveTelemetryData( self )
	StoreTelemetry_SendStorePageViewEvent()
}

void function RTKStoreItemShop_UpdateSmartMerchandisingData( rtk_behavior self, int currentSectionIndex = -1, int currentSectionPage = -1 )
{
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )

	if ( currentSectionIndex == -1 )
	{
		currentSectionIndex = RTKPagination_GetCurrentPage( pagination )
	}

	if ( currentSectionPage == -1 )
	{
		rtk_behavior sectionBehavior = self.PropGetPanel( "contentPanel" ).GetChildByIndex( currentSectionIndex ).FindBehaviorByTypeName( "StoreGridSection" )
		currentSectionPage = RTKPagination_GetCurrentPage( sectionBehavior.PropGetBehavior( "paginationBehavior" ) ) + 1
	}

	int sectionId = file.fullStoreModel.sections[currentSectionIndex].sectionId
	SetLastSectionVisited( sectionId )

	if ( currentSectionPage > GetHighestPageForSection( sectionId ) )
	{
		SetHighestPageSeenForSection( sectionId, currentSectionPage )
	}
	RTKArray_SetValue( pagination.PropGetArray( "pipMiscBools" ), RTKStoreItemShop_GetSectionNewness( self ) )
}

void function RTKStoreItemShop_SaveTelemetryData( rtk_behavior self )
{
	int pageIndex                = RTKPagination_GetCurrentPage( self.PropGetBehavior( "paginationBehavior" ) )
	rtk_behavior sectionBehavior = self.PropGetPanel( "contentPanel" ).GetChildByIndex( pageIndex ).FindBehaviorByTypeName( "StoreGridSection" )

	fileTelemetry.sectionNum = pageIndex
	RTKStoreGridSection_SaveTelemetryData( sectionBehavior )
}

void function RTKStoreItemShop_SetCurrentSectionsInfo( rtk_behavior self, int pageIndex )
{
	PrivateData p
	self.Private( p )

	int sectionCount             = file.fullStoreModel.sections.len()
	int prevSectionIndex         = pageIndex <= 0 ? sectionCount - 1 : pageIndex - 1
	int nextSectionIndex         = pageIndex + 1 >= sectionCount ? 0 : pageIndex + 1

	RTKStruct_SetString( p.storeItemShopModel, PREV_SECTION, file.fullStoreModel.sections[prevSectionIndex].sectionName )
	RTKStruct_SetString( p.storeItemShopModel, NEXT_SECTION, file.fullStoreModel.sections[nextSectionIndex].sectionName )
}

array<bool> function RTKStoreItemShop_GetSectionNewness( rtk_behavior self )
{
	array<bool> sectionNewness

	foreach ( section in file.fullStoreModel.sections )
	{
		sectionNewness.append( !HasSectionBeenSeen( section.sectionId ) )
	}

	return sectionNewness
}

asset function GetBackgroundAssetFromSectionIndex( int index )
{
	if ( index < 0 || index >= file.fullStoreModel.sections.len() )
		return DEFAULT_BG_ASSET

	return file.fullStoreModel.sections[index].bgAsset
}

vector function GetBackgroundTintFromSectionIndex( int index )
{
	if ( index < 0 || index >= file.fullStoreModel.sections.len() )
		return <1.0, 1.0, 1.0>

	return file.fullStoreModel.sections[index].bgTint
}

void function RTKStoreGridSection_OnInitialize( rtk_behavior self )
{
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )
	self.AutoSubscribe( pagination, "onScrollFinished", function () : ( self ) {
		RTKStoreGridSection_OnScrollFinished( self )
	} )
}

void function RTKStoreGridSection_OnScrollFinished( rtk_behavior self )
{
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )

	int sectionId = GetMostRecentlySeenSection()
	int currentPage = RTKPagination_GetCurrentPage( pagination ) + 1
	if ( GetHighestPageForSection( sectionId ) > currentPage )
	{
		SetHighestPageSeenForSection( sectionId, currentPage )
	}

	fileTelemetry.clickType = RTKPagination_GetLastNavType( pagination )
	fileTelemetry.linkName = ""
	RTKStoreGridSection_SaveTelemetryData( self )
	StoreTelemetry_SendStorePageViewEvent()
}

void function RTKStoreGridSection_SaveTelemetryData( rtk_behavior self )
{
	int pageNum = RTKPagination_GetCurrentPage( self.PropGetBehavior( "paginationBehavior" ) )
	string pageName = self.PropGetString( "sectionName" )

	fileTelemetry.prevPage = fileTelemetry.pageName
	fileTelemetry.pageName = pageName + "_" + string( pageNum )
	fileTelemetry.prevPageDuration = int( UITime() ) - fileTelemetry.prevPageTimeStamp
	fileTelemetry.prevPageTimeStamp = int ( UITime() )
	fileTelemetry.pageNum = pageNum
}

int function RTKStoreGridSection_GetCurrentPage( rtk_behavior self )
{
	rtk_behavior ornull paginationBehavior = self.PropGetBehavior( "paginationBehavior" )
	if ( paginationBehavior == null )
		return 0

	expect rtk_behavior( paginationBehavior )

	return RTKPagination_GetCurrentPage( paginationBehavior )
}

void function RTKStoreGridItem_OnInitialize( rtk_behavior self )
{
	RTKStruct_AddPropertyListener( self.GetProperties(), "gridItemType", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKStoreGridItem_SetItemSize( self )
	} )
}

void function RTKStoreGridItem_SetItemSize( rtk_behavior self )
{
	rtk_struct panelProps = self.GetPanel().GetProperties()
	int gridItemType = self.PropGetInt( "gridItemType" )
	rtk_behavior gridContainerElement = self.PropGetBehavior( "gridContainerElement" )

	gridContainerElement.PropSetBool( "hasCustomSize", IsGridItemCustomSize( gridItemType ) )
	gridContainerElement.PropSetInt( "spanCellsHorizontal", GetGridItemSpanHorizontalFromType( gridItemType ) )
	gridContainerElement.PropSetInt( "spanCellsVertical", GetGridItemSpanVerticalFromType( gridItemType ) )

	RTKStruct_SetFloat( panelProps, "width", GetGridItemWidthFromType( gridItemType ) )
	RTKStruct_SetFloat( panelProps, "height", GetGridItemHeightFromType( gridItemType ) )
}

void function InitStoreItemShop( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUp )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
}

int function RTKStore_RegisterOffer( GRXScriptOffer offer )
{
	file.allCurrentOffers.append( offer )

	return file.allCurrentOffers.len() - 1
}

GRXScriptOffer function RTKStore_GetOfferFromIndex( int index )
{
	if ( index < 0 || index >= file.allCurrentOffers.len() )
	{
		GRXScriptOffer blank
		return blank
	}

	return file.allCurrentOffers[index]
}

void function RTKStore_RevealPersonalizedOffer( int offerIndex )
{
	RTKStoreSectionModel personalizedSection

	foreach ( section in file.fullStoreModel.sections )
	{
		if ( section.sectionName == "#STORE_V2_SECTION_PERSONALIZED" )
		{
			personalizedSection = section
		}
	}

	if ( personalizedSection.sectionEnum == -1 )
	{
		return
	}

	array<bool> slotsRevealStatus
	foreach ( int slotIndex, offer in personalizedSection.itemsArray )
	{
		if ( offer.offerIndex == offerIndex )
		{
			offer.miscBool = false
			GRXPersonalizedStoreSlotData slotData = GetPersonalizedStoreSlotData()[slotIndex]
			slotData.revealStatus = true
		}
		slotsRevealStatus.append( !offer.miscBool )
	}

	UpdatePersonalizedStoreSlotsRevealStatus( slotsRevealStatus )
}

RTKStoreGridItemModel function GetItemModelFromOffer( GRXScriptOffer offer, int slotIndex, int gridItemType = -1, bool miscBool = false )
{
	RTKStoreGridItemModel itemModel
	RTKOfferButtonModel offerButtonModel = RTKStore_CreateOfferButtonModel( offer )

	if ( gridItemType == -1 )
		itemModel.gridItemType = GetGridItemTypeFromRowColumn( int( offer.attributes["storerow"] ), int( offer.attributes["storecolumn"] ) )
	else
		itemModel.gridItemType = gridItemType

	itemModel.slotIndex		= slotIndex
	itemModel.mainImage 	= offerButtonModel.offerImage
	itemModel.mainText 		= offerButtonModel.offerName
	itemModel.subText 		= offerButtonModel.offerType
	itemModel.miscText1 	= offerButtonModel.price
	itemModel.miscText2 	= offerButtonModel.newPrice
	itemModel.miscText3		= offerButtonModel.purchaseLimit
	itemModel.miscBool		= miscBool

	itemModel.offerIndex 		= offerButtonModel.offerIndex
	itemModel.imageRef			= offerButtonModel.imageRef
	itemModel.newPriceShow 		= offerButtonModel.newPriceShow
	itemModel.rarity       		= offerButtonModel.rarity
	itemModel.discount  		= offerButtonModel.discount
	itemModel.priceColor    	= offerButtonModel.priceColor
	itemModel.newPriceColor 	= offerButtonModel.newPriceColor
	itemModel.isOnlyGiftable    = offerButtonModel.isOnlyGiftable

	itemModel.sourceIcon		= offerButtonModel.sourceIcon

	return itemModel
}

RTKStoreSectionModel function GetSectionFromOffers( array<GRXScriptOffer> offers )
{
	RTKStoreSectionModel section
	int sectionExpireTime = INT_MAX

	foreach ( int index, offer in offers )
	{
		RTKStoreGridItemModel itemModel = GetItemModelFromOffer( offer, index )
		if ( offer.expireTime < sectionExpireTime && offer.expireTime != 0 )
		{
			sectionExpireTime = offer.expireTime
		}
		section.itemsArray.append( itemModel )
	}

	section.endTime = sectionExpireTime

	return section
}

RTKStoreSectionModel function GetEventSection( array<GRXScriptOffer> offers )
{
	RTKStoreSectionModel section = GetSectionFromOffers( offers )

	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	if ( activeCollectionEvent != null )
	{
		expect ItemFlavor( activeCollectionEvent )

		RTKStoreGridItemModel gridItem
		gridItem.gridItemType = eStoreGridItemType.INFO_BUTTON
		gridItem.mainImage     = CollectionEvent_GetStoreEventSectionMainImage( activeCollectionEvent )
		gridItem.mainText      = CollectionEvent_GetStoreEventSectionMainText( activeCollectionEvent )
		gridItem.subText       = CollectionEvent_GetStoreEventSectionSubText( activeCollectionEvent )
		gridItem.priceColor    = <1.0, 1.0, 1.0>
		gridItem.newPriceColor = <1.0, 1.0, 1.0>

		gridItem.miscText1    = "collectionevent"
		section.itemsArray.insert( 0, gridItem )
	}

	ItemFlavor ornull activeMilestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( activeMilestoneEvent != null )
	{
		expect ItemFlavor( activeMilestoneEvent )

		section.sectionId = 0
		section.sectionName = "#NOIR_MOBSTERS_MILESTONE_EVENT"
		section.endTime = CalEvent_GetFinishUnixTime( activeMilestoneEvent )

		RTKStoreGridItemModel gridItem
		gridItem.gridItemType = eStoreGridItemType.TAKEOVER
		gridItem.mainImage     = MilestoneEvent_GetStoreEventSectionMainImage( activeMilestoneEvent )
		gridItem.mainText      = MilestoneEvent_GetStoreEventSectionMainText( activeMilestoneEvent )
		gridItem.subText       = MilestoneEvent_GetStoreEventSectionSubText( activeMilestoneEvent )
		gridItem.priceColor    = <1.0, 1.0, 1.0>
		gridItem.newPriceColor = <1.0, 1.0, 1.0>

		gridItem.miscText1    = "milestoneevent"
		section.itemsArray.insert( 0, gridItem )
	}

	return section
}

RTKStoreSectionModel function GetFlexSection( array<GRXScriptOffer> offers, string sectionName )
{
	RTKStoreSectionModel section = GetSectionFromOffers( offers )

	if ( STORE_SECTION_KEY_ART_LIST.contains( sectionName ) )
	{
		RTKStoreGridItemModel gridItem
		gridItem.gridItemType = eStoreGridItemType.BLANK
		section.itemsArray.insert( 0, gridItem )
	}

	return section
}

RTKStoreSectionModel function GetRecolorSection( array<GRXScriptOffer> offers )
{
	RTKStoreSectionModel section = GetSectionFromOffers( offers )

	for ( int index = offers.len() - 1; index >= 0; index-- )
	{
		bool isRecolor = offers[index].prereq != null
		ItemFlavor baseItemFlav = isRecolor ? expect ItemFlavor( offers[index].prereq ) : offers[index].output.flavors[0]
		bool isBaseItemOwned = GRX_IsItemOwnedByPlayer( baseItemFlav )

		section.itemsArray[index].sourceIcon = $""
		section.itemsArray[index].subText = isRecolor ?
				( isBaseItemOwned ? "#STORE_V2_RECOLOR_UNLOCKED" : "#STORE_V2_RECOLOR_LOCKED" ) :
				( isBaseItemOwned ? "#STORE_V2_BASE_SKIN_UNLOCKED" : "#STORE_V2_BASE_SKIN_LOCKED" )

		if ( isRecolor && index > 0 )
		{
			RTKStoreGridItemModel gridItem
			gridItem.gridItemType = eStoreGridItemType.DIVIDER
			section.itemsArray.insert( index, gridItem )
		}
	}

	return section
}

RTKStoreSectionModel function GetBattlePassSection( array<GRXScriptOffer> offers )
{
	RTKStoreSectionModel section = GetSectionFromOffers( offers )

	foreach ( item in section.itemsArray )
		item.subText = ""

	RTKStoreGridItemModel gridItem
	gridItem.gridItemType = eStoreGridItemType.BUNDLE
	gridItem.mainImage    = $"ui_image/rui/menu/store/grid_item_art/store_grid_image_battle_pass.rpak"
	gridItem.mainText = "#BATTLE_PASS_INFO_TITLE"
	gridItem.subText = "#BATTLE_PASS_INFO_TEXT"
	gridItem.priceColor = <1.0, 1.0, 1.0>
	gridItem.newPriceColor = <1.0, 1.0, 1.0>
	gridItem.miscText1    = "battlepass"

	section.itemsArray.insert( 0, gridItem )

	ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )
	section.endTime = CalEvent_GetFinishUnixTime( season )

	return section
}

RTKStoreSectionModel function GetPersonalizedSection()
{
	RTKStoreSectionModel section
	array<GRXPersonalizedStoreSlotData> personalizedOffers = GetPersonalizedStoreSlotData()

	foreach ( int index, personalizedOffer in personalizedOffers )
	{
		RTKStoreGridItemModel itemModel = GetItemModelFromOffer( personalizedOffer.offer, index, eStoreGridItemType.OFFER_PERSONAL, !personalizedOffer.revealStatus )
		section.itemsArray.append( itemModel )
	}

	
	section.endTime = 1713891600
	section.sectionName = "#STORE_V2_SECTION_PERSONALIZED"

	return section
}

void function SetOnlySectionVisible( rtk_behavior self, int pageIndex )
{
	int sectionCount = file.fullStoreModel.sections.len()

	for ( int i = 0; i < sectionCount; i++ )
	{
		SetSectionVisible( self, i, i == pageIndex )
	}
}

void function SetSectionVisible( rtk_behavior self, int pageIndex, bool visible )
{
	PrivateData p
	self.Private( p )

	rtk_array storeSectionsArray = RTKStruct_GetArray( p.storeItemShopModel, SECTIONS )
	rtk_struct section = RTKArray_GetStruct( storeSectionsArray, pageIndex )

	if ( visible == RTKStruct_GetBool( section, "sectionVisible" ) )
		return

	array<RTKStoreGridItemModel> blank
	rtk_array itemsArray = RTKStruct_GetArray( section, "itemsArray" )
	RTKArray_SetValue( itemsArray, visible ? file.fullStoreModel.sections[pageIndex].itemsArray : blank )
	RTKStruct_SetBool( section, "sectionVisible", visible )
}

void function StoreTelemetry_SaveDeepLink( string link )
{
	fileTelemetry.linkName = link
}

void function StoreTelemetry_SendStorePageViewEvent()
{
	PIN_PageView_Store( fileTelemetry.pageName, fileTelemetry.prevPage, fileTelemetry.prevPageDuration,
		fileTelemetry.sectionNum, fileTelemetry.pageNum, fileTelemetry.linkName, fileTelemetry.clickType )
}

void function StoreTelemetry_SendOferPageViewEvent()
{
	PIN_PageView_Offer( fileTelemetry.pageName, fileTelemetry.prevPage, fileTelemetry.prevPageDuration,
		fileTelemetry.sectionNum, fileTelemetry.pageNum, fileTelemetry.linkName, fileTelemetry.clickType,
		fileTelemetry.offerName, fileTelemetry.offerPriority, fileTelemetry.slotType )
}

asset function RTKMutator_GetLoadAssetFromGridItemType( int input )
{
	switch ( input )
	{
		case eStoreGridItemType.OFFER_1_1:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_square.rpak"
			break

		case eStoreGridItemType.OFFER_2_1:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_wide.rpak"
			break

		case eStoreGridItemType.OFFER_1_2:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_vertical.rpak"
			break

		case eStoreGridItemType.OFFER_2_2:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_large.rpak"
			break

		case eStoreGridItemType.OFFER_3_2:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_large.rpak"
			break

		default:
			return $"ui_image/rui/menu/image_download/image_load_failed_store_vertical.rpak"
			break
	}

	unreachable
}

asset function RTKMutator_GetGradientAssetFromGridItemType( int input )
{
	switch ( input )
	{
		case eStoreGridItemType.OFFER_1_1:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_short.rpak"
			break

		case eStoreGridItemType.OFFER_2_1:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_short.rpak"
			break

		case eStoreGridItemType.OFFER_1_2:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_tall.rpak"
			break

		case eStoreGridItemType.OFFER_2_2:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_tall.rpak"
			break

		case eStoreGridItemType.OFFER_3_2:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_tall.rpak"
			break

		default:
			return $"ui_image/rui/menu/store/common/store_offer_gradient_tall.rpak"
			break
	}

	unreachable
}

int function GetGridItemTypeFromRowColumn( int row, int column )
{
	if ( row == 1 && column == 1 )
		return eStoreGridItemType.OFFER_1_1

	if ( row == 2 && column == 1 )
		return eStoreGridItemType.OFFER_1_2

	if ( row == 1 && column == 2 )
		return eStoreGridItemType.OFFER_2_1

	if ( row == 2 && column == 2 )
		return eStoreGridItemType.OFFER_2_2

	if ( row == 2 && column == 3 )
		return eStoreGridItemType.OFFER_3_2

	return 0
}

int function GetGridItemSpanHorizontalFromType( int gridItemType )
{
	switch ( gridItemType )
	{
		case eStoreGridItemType.OFFER_1_1:
		case eStoreGridItemType.OFFER_1_2:
		case eStoreGridItemType.DIVIDER:
		case eStoreGridItemType.TAKEOVER:
		case eStoreGridItemType.BUNDLE:
		case eStoreGridItemType.OFFER_PERSONAL:
		case eStoreGridItemType.OFFER_3_2:
			return 1
		case eStoreGridItemType.OFFER_2_1:
		case eStoreGridItemType.OFFER_2_2:
		case eStoreGridItemType.INFO_PANEL:
		case eStoreGridItemType.INFO_BUTTON:
		case eStoreGridItemType.BLANK:
			return 2
	}

	unreachable
}

int function GetGridItemSpanVerticalFromType( int gridItemType )
{
	switch ( gridItemType )
	{
		case eStoreGridItemType.OFFER_1_1:
		case eStoreGridItemType.OFFER_2_1:
			return 1
		case eStoreGridItemType.OFFER_1_2:
		case eStoreGridItemType.OFFER_2_2:
		case eStoreGridItemType.DIVIDER:
		case eStoreGridItemType.INFO_PANEL:
		case eStoreGridItemType.INFO_BUTTON:
		case eStoreGridItemType.BLANK:
		case eStoreGridItemType.TAKEOVER:
		case eStoreGridItemType.BUNDLE:
		case eStoreGridItemType.OFFER_PERSONAL:
		case eStoreGridItemType.OFFER_3_2:
			return 2
	}

	unreachable
}

float function GetGridItemWidthFromType( int gridItemType )
{
	switch ( gridItemType )
	{
		case eStoreGridItemType.DIVIDER:
			return 2
		case eStoreGridItemType.OFFER_1_1:
		case eStoreGridItemType.OFFER_1_2:
		case eStoreGridItemType.OFFER_PERSONAL:
			return 320
		case eStoreGridItemType.OFFER_2_1:
		case eStoreGridItemType.OFFER_2_2:
		case eStoreGridItemType.INFO_PANEL:
		case eStoreGridItemType.INFO_BUTTON:
		case eStoreGridItemType.BLANK:
			return 664
		case eStoreGridItemType.BUNDLE:
		case eStoreGridItemType.OFFER_3_2:
			return 836
		case eStoreGridItemType.TAKEOVER:
			return 1696
	}

	unreachable
}

float function GetGridItemHeightFromType( int gridItemType )
{
	switch ( gridItemType )
	{
		case eStoreGridItemType.OFFER_1_1:
		case eStoreGridItemType.OFFER_2_1:
			return 288
		case eStoreGridItemType.OFFER_1_2:
		case eStoreGridItemType.OFFER_2_2:
		case eStoreGridItemType.OFFER_3_2:
		case eStoreGridItemType.DIVIDER:
		case eStoreGridItemType.INFO_PANEL:
		case eStoreGridItemType.INFO_BUTTON:
		case eStoreGridItemType.BLANK:
		case eStoreGridItemType.TAKEOVER:
		case eStoreGridItemType.BUNDLE:
		case eStoreGridItemType.OFFER_PERSONAL:
			return 600
	}

	unreachable
}

bool function IsGridItemCustomSize( int gridItemType )
{
	switch ( gridItemType )
	{
		case eStoreGridItemType.DIVIDER:
		case eStoreGridItemType.TAKEOVER:
		case eStoreGridItemType.BUNDLE:
		case eStoreGridItemType.OFFER_3_2:
			return true
	}

	return false
}