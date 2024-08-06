global function RTKMilestoneEventPackInfoPanel_OnInitialize
global function RTKMilestoneEventPackInfoPanel_OnDestroy
global function InitMilestonePackInfoDialog
global function OpenMilestonePackInfoDialog

global struct RTKMilestoneEventPackInfoPanel_Properties
{
	rtk_behavior cancelButton
}

global struct RTKMilestonePackInfoModel
{
	string title
	string guaranteedInfo
	RTKPurchasePackRateSectionInfo& eventItemsSection
	RTKPurchasePackRateSectionInfo& standardItemsSection
	RTKPurchasePackRateSectionInfo& multiItemsSection
	RTKPurchasePackPriceSectionInfo& priceSection
	array<RTKPurchasePackInformationLines> infoLines
}

struct
{
	ItemFlavor& activeEvent
	var menu
} file

const int MAX_INFO_SIDES = 2 

void function InitMilestonePackInfoDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu
}

void function RTKMilestoneEventPackInfoPanel_OnInitialize( rtk_behavior self )
{
	ItemFlavor ornull event = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( event == null )
	{
		return
	}
	expect ItemFlavor( event )
	file.activeEvent = event

	rtk_struct packInfoPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "milestonePackInfo", "RTKMilestonePackInfoModel" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "milestonePackInfo", true ) )
	SetUpDialogDataModel( packInfoPanel )
	SetUpFooterButtons( self )
}

void function RTKMilestoneEventPackInfoPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "milestonePackInfo" )
}

void function SetUpDialogDataModel( rtk_struct infoPanel )
{
	RTKMilestonePackInfoModel model
	model.eventItemsSection.title = MilestoneEvent_GetEventItemsRatesSectionHeader( file.activeEvent )
	model.eventItemsSection.color = <0.83, 0.66, 0.15>
	model.standardItemsSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_STANDARD_LABEL" )
	model.standardItemsSection.color = <0.7, 0.7, 0.7>
	model.multiItemsSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_MULTIDRAW_LABEL" )
	model.multiItemsSection.color = <0.7, 0.7, 0.7>
	model.priceSection.title = Localize( "#MILESTONE_BUNDLE_EVENT_SINGLE_PACK_LABEL" )
	model.priceSection.color = <0.7, 0.7, 0.7>

	model.title = MilestoneEvent_GetMainPackShortPluralName( file.activeEvent )
	model.guaranteedInfo = MilestoneEvent_GetGuaranteedPackText( file.activeEvent )
	model.eventItemsSection.rows = MilestoneEvent_GetEventItemRatesData( file.activeEvent )
	model.standardItemsSection.rows = MilestoneEvent_GetStandardItemRatesData( file.activeEvent )
	if ( GRX_EventHasMultiPackOffers( file.activeEvent ) )
	{
		model.multiItemsSection.rows = MilestoneEvent_GetMultiItemRatesData( file.activeEvent )
	}
	model.priceSection.rows.append( MilestoneEvent_GetPricePackRangesData( file.activeEvent ) )
	model.infoLines = MilestoneEvent_GetLegalTextData( file.activeEvent )
	Assert( model.infoLines.len() <= MAX_INFO_SIDES )
	RTKStruct_SetValue( infoPanel, model )
}

void function SetUpFooterButtons( rtk_behavior self )
{
	rtk_behavior ornull cancelButton = self.PropGetBehavior( "cancelButton" )
	expect rtk_behavior( cancelButton )
	self.AutoSubscribe( cancelButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( ) {
		UICodeCallback_NavigateBack()
	} )
}

void function OpenMilestonePackInfoDialog( var button = null )
{
	if ( GetActiveMenu() != file.menu )
	{
		AdvanceMenu( GetMenu( "MilestonePackInfoDialog" ) )
	}
}