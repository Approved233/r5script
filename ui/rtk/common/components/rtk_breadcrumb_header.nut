global function RTKBreadcrumbHeader_OnInitialize
global function RTKBreadcrumbHeader_OnDestroy
global function RTKBreadcrumbHeader_PushStep
global function RTKBreadcrumbHeader_RemoveStep
global function RTKBreakcrumbHeader_RemoveAllSteps
global function RTKBreakcrumbHeader_GetTotalStepsNumber

global struct RTKBreadcrumbHeader_Properties
{
	bool seasonalColors
	rtk_panel leftImage
	rtk_panel rightImage
}

global function RTKBreadcrumbStep_OnInitialize

global struct RTKBreadcrumbStep_Properties
{
	rtk_behavior buttonBehavior
	int stepIndex
	bool seasonalColors
	rtk_behavior stepTitle
}

global struct RTKBreadcrumbStepModel
{
	rtk_behavior behaviorRef

	int stepIndex
	string title
	bool isLastStep

	
}

global struct RTKBreadcrumbHeaderModel
{
	array<RTKBreadcrumbStepModel> breadcrumbSteps
}

const string RTK_BREADCRUMB_HEADER_MODEL_NAME = "breadcrumbHeader"

void function RTKBreadcrumbHeader_OnInitialize( rtk_behavior self )
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()
	string pathToModel = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, RTK_BREADCRUMB_HEADER_MODEL_NAME )

	if ( self.PropGetBool( "seasonalColors" ) )
		RTKBreadcrumbHeader_SetSeasonalColors( self )

	self.GetPanel().SetBindingRootPath( pathToModel )
}

void function RTKBreadcrumbHeader_OnDestroy( rtk_behavior self )
{
}

void function RTKBreadcrumbHeader_PushStep( RTKBreadcrumbStepModel step )
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()

	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	rtk_struct newStep = RTKArray_PushNewStruct( stepArray )
	step.stepIndex = RTKArray_GetCount( stepArray ) - 1
	RTKStruct_SetValue( newStep, step )

	RTKBreadcrumbHeader_RefreshLastStepStatus()
}

void function RTKBreadcrumbHeader_RemoveStep( int numSteps = 1 )
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()

	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	while ( numSteps > 0 && RTKArray_GetCount( stepArray ) > 0 )
	{
		RTKArray_RemoveAt( stepArray, RTKArray_GetCount( stepArray ) - 1 )
		numSteps--
	}

	RTKBreadcrumbHeader_RefreshLastStepStatus()
}

void function RTKBreadcrumbHeader_ReturnToStep( int stepIndex )
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()

	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	if ( stepIndex >= RTKArray_GetCount( stepArray ) - 1 )
		return

	while ( stepIndex < RTKArray_GetCount( stepArray ) - 1 )
	{
		
		RTKBreadcrumbHeader_RemoveStep()
	}
}

void function RTKBreadcrumbHeader_RefreshLastStepStatus()
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()

	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	int stepCount = RTKArray_GetCount( stepArray )
	for ( int i = 0; i < stepCount; i++ )
	{
		RTKStruct_SetBool( RTKArray_GetStruct( stepArray, i ), "isLastStep", i == stepCount - 1 )
	}
}

void function RTKBreadcrumbStep_OnInitialize( rtk_behavior self )
{
	rtk_behavior button = self.PropGetBehavior( "buttonBehavior" )
	if ( button == null )
		return

	if ( self.PropGetBool( "seasonalColors" ) )
	{
		rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()
		RTKStruct_AddPropertyListener( self.GetProperties(), "stepIndex", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
			RTKBreadcrumbStep_SetSeasonalColors( self, propValue )
		} )
	}
	
	
	
	
	
}

void function RTKBreadcrumbStep_OnClick( rtk_behavior self )
{
	int stepIndex = self.PropGetInt( "stepIndex" )
	RTKBreadcrumbHeader_ReturnToStep( stepIndex )
}

void function RTKBreakcrumbHeader_RemoveAllSteps()
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()
	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	while ( RTKArray_GetCount( stepArray ) > 0 )
	{
		RTKArray_RemoveAt( stepArray, RTKArray_GetCount( stepArray ) - 1 )
	}

	RTKBreadcrumbHeader_RefreshLastStepStatus()
}
int function RTKBreakcrumbHeader_GetTotalStepsNumber()
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()
	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	return RTKArray_GetCount( stepArray )
}

rtk_struct function RTKBreadcrumbHeader_GetOrCreateStruct()
{
	return RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, RTK_BREADCRUMB_HEADER_MODEL_NAME, "RTKBreadcrumbHeaderModel" )
}

void function RTKBreadcrumbHeader_SetSeasonalColors( rtk_behavior self )
{
	SeasonStyleData seasonStyle = GetSeasonStyle()
	rtk_panel rightImage = self.PropGetPanel( "rightImage" )
	rightImage.SetVisible( true )
	rightImage.FindBehaviorByTypeName( "Image" ).PropSetAssetPath( "assetPath", seasonStyle.seasonBannerRightImage )
}

void function RTKBreadcrumbStep_SetSeasonalColors( rtk_behavior self, var propValue )
{
	rtk_struct headerStruct = RTKBreadcrumbHeader_GetOrCreateStruct()
	rtk_array stepArray = RTKStruct_GetArray( headerStruct, "breadcrumbSteps" )
	int stepCount = RTKArray_GetCount( stepArray )
	bool isLastStep = expect int(propValue) == stepCount - 1

	rtk_behavior text = self.PropGetBehavior( "stepTitle" )
	SeasonStyleData seasonStyle = GetSeasonStyle()
	if ( isLastStep )
		text.PropSetFloat3( "colorRGB", seasonStyle.titleTextColor )
	else
		text.PropSetFloat3( "colorRGB", <1, 1, 1> )
}