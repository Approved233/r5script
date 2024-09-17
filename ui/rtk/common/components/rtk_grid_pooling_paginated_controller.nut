global function RTKGridPoolingPaginated_OnInitialize
global function RTKGridPoolingPaginated_OnDestroy

global struct RTKGridPoolingPaginated_Properties
{
	rtk_behavior paginationNav
	rtk_behavior listBinder
	int itemsPerPage = 1
	int defaultStartPage = 0
}

struct PrivateData
{
	int itemsQuantity
	int currentPage
	int pageQuantity

	
	int currentRangeStart
	int currentRangeEnd

	
	string paginationPipDataModelPath
}

const string GRID_POOLING_PAGINATED_PIP_ARRAY_MODEL = "grid_pooling_pip"

global struct RTKGridPoolingPaginationPip
{
	bool isActive = true
}

global struct RTKGridPoolingPaginatedPipModel
{
	array<RTKGridPoolingPaginationPip> navPipArray
}

void function RTKGridPoolingPaginated_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	p.currentPage =  self.PropGetInt( "defaultStartPage" )

	rtk_behavior listBinder = self.PropGetBehavior( "listBinder" )
	string modelPath = listBinder.PropGetString( "bindingPath" )
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_array listBinderArray = RTKDataModel_GetArray( modelPath )
		p.itemsQuantity = RTKArray_GetCount( listBinderArray )
	}

	RTKGridPoolingPaginated_SetGridItemRanges( self, listBinder )

	string uniqueModelName = GRID_POOLING_PAGINATED_PIP_ARRAY_MODEL + self.GetInternalId()
	rtk_struct panelStruct  = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, uniqueModelName, "RTKGridPoolingPaginatedPipModel" )
	p.paginationPipDataModelPath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, uniqueModelName, true )
	self.GetPanel().SetBindingRootPath( p.paginationPipDataModelPath )

	RTKGridPoolingPaginatedPipModel panelModel

	for ( int i = 0; i < p.pageQuantity; i++ )
	{
		RTKGridPoolingPaginationPip pip
		panelModel.navPipArray.append( pip )
	}
	RTKStruct_SetValue( panelStruct, panelModel )

	
	string pipModelPath = "&menus." + uniqueModelName + ".navPipArray"
	rtk_behavior paginationNav = self.PropGetBehavior( "paginationNav" )
	paginationNav.PropSetString( "pathToPipModel", pipModelPath )
	rtk_behavior pipListBinder = paginationNav.PropGetBehavior( "pipListBinder" )
	pipListBinder.PropSetString( "bindingPath", pipModelPath )

	rtk_panel listBinderPanel = listBinder.GetPanel()
	self.AutoSubscribe( paginationNav, "OnPageChange", function( int targetPage ) : ( self, listBinder )
	{
		PrivateData p
		self.Private( p )
		p.currentPage = targetPage
		RTKGridPoolingPaginated_SetGridItemRanges( self, listBinder )
	})
}

void function RTKGridPoolingPaginated_OnDestroy( rtk_behavior self )
{
	string uniqueModelName = GRID_POOLING_PAGINATED_PIP_ARRAY_MODEL + self.GetInternalId()
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "uniqueModelName" )
}

void function RTKGridPoolingPaginated_SetGridItemRanges( rtk_behavior self, rtk_behavior listBinder )
{
	PrivateData p
	self.Private( p )

	int itemsPerPage = self.PropGetInt( "itemsPerPage" )
	p.pageQuantity = int( ceil( float(p.itemsQuantity) / float(itemsPerPage) ) )
	p.currentRangeStart = p.currentPage * itemsPerPage
	p.currentRangeEnd = p.currentRangeStart + itemsPerPage - 1
	listBinder.PropSetInt( "rangeStart", p.currentRangeStart )
	listBinder.PropSetInt( "rangeEnd", p.currentRangeEnd )
}