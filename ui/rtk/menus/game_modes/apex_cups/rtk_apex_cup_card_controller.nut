global function RTKApexCupCardController_InitMetaData
global function RTKApexCupCardController_OnInitialize

global struct RTKCupCardEntry
{
	int  score
	int  lowerBound
	int  upperBound
	int	 gamesPlayed
	bool isTop100
}

global struct RTKApexCupCardController_Properties
{
	SettingsAssetGUID apexCup
	SettingsAssetGUID calEvent
	int lockState

	rtk_behavior timer
}

void function RTKApexCupCardController_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "Button" )
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "DataBindingRoot" )
	RTKMetaData_SetAllowedBehaviorTypes( structType, "timer", [ "Timer" ] )
}

void function RTKApexCupCardController_OnInitialize( rtk_behavior self )
{
	rtk_behavior timer = expect rtk_behavior( self.rtkprops.timer )
	self.AutoSubscribe( timer, "onFinish", function() : ( self ) {
		RTKApexCupCardController_OnTimerFinished( self )
	})

	rtk_behavior button = self.GetPanel().FindBehaviorByTypeName( "Button" )
	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		RTKApexCupCardController_OnButtonPressed( self )
	} )

	rtk_behavior bindingRoot = self.GetPanel().FindBehaviorByTypeName( "DataBindingRoot" )
	self.AutoSubscribe( bindingRoot, "onBindingChanged", function() : ( self ) {
		RTKApexCupCardController_OnBindingChanged( self )
	} )
}

void function RTKApexCupCardController_OnBindingChanged( rtk_behavior self )
{
	if ( !self.IsActiveInHierarchy() )
		return

	string bindingRoot = self.GetPanel().GetBindingRootPath()
	if ( !RTKDataModel_HasDataModel( bindingRoot ) )
	{
		self.Warn( "Unable to find data model: " + bindingRoot )
		return
	}

	rtk_struct root = RTKDataModel_GetStruct( bindingRoot )

	int apexCup = self.PropGetInt( "apexCup" )

	CupEntry ornull cupEntry = Cups_GetSquadCupData( apexCup )
	if ( cupEntry == null )
	{
		ItemFlavor flav = GetItemFlavorByGUID( self.PropGetInt( "calEvent" ) )
		if ( CalEvent_HasFinished( flav, GetUnixTimestamp() ) )
			RTKStruct_SetInt( root, "state", CUP_STATE_NOT_PARTICIPATE )
		if ( RTKStruct_HasProperty( root, "entry" ) )
			RTKStruct_RemoveProperty( root, "entry" )
		printt( "RTKApexCupCardController_OnBindingChanged cupEntry == null" )
		return
	}
	expect CupEntry( cupEntry )

	if ( cupEntry.active == false )
	{
		RTKStruct_SetInt( root, "state", CUP_STATE_FINISHED )
		if ( RTKStruct_HasProperty( root, "entry" ) )
			RTKStruct_RemoveProperty( root, "entry" )
		return
	}

	rtk_struct entry
	if ( RTKStruct_HasProperty( root, "entry" ) )
		entry = RTKStruct_GetStruct( root, "entry" )
	else
		entry = RTKStruct_AddStructProperty( root, "entry", "RTKCupCardEntry" )

	RTKCupCardEntry model
	model.gamesPlayed = cupEntry.matchSummaryData.len()

	int index = Cups_GetPlayerTierIndexForCup( apexCup )
	int indexPrev = maxint( 0, index - 1 )
	model.score = cupEntry.currSquadScore
	model.upperBound = indexPrev <  cupEntry.tierScoreBounds.len() ? cupEntry.tierScoreBounds[indexPrev] : 1
	model.lowerBound = index <  cupEntry.tierScoreBounds.len() ? cupEntry.tierScoreBounds[index] : 0
	model.isTop100 = index == 0

	RTKStruct_SetValue( entry, model )
}

void function RTKApexCupCardController_OnTimerFinished( rtk_behavior self )
{
	
	thread RTKApexCupCardController_ResetState( self )
}

void function RTKApexCupCardController_OnButtonPressed( rtk_behavior self )
{
#if DEV
		printt( "RTKApexCupCardController_OnButtonPressed:", self.PropGetInt( "lockState" ) )
#endif
	if ( self.PropGetInt( "lockState" ) == CUP_LOCK_NONE )
	{
		CloseActiveMenu()
		RTKApexCupsOverview_SetCup( self.PropGetInt( "apexCup" ) )
		AdvanceMenu( GetMenu( "RTKApexCupMenu" ) )
	}
}

void function RTKApexCupCardController_ResetState( rtk_behavior self )
{
	string bindingRoot = self.GetPanel().GetBindingRootPath()
	ItemFlavor flav = GetItemFlavorByGUID( self.PropGetInt( "calEvent" ) )

	WaitFrame()

	if ( !RTKDataModel_HasDataModel( bindingRoot ) )
		return

	rtk_struct root = RTKDataModel_GetStruct( bindingRoot )
	if ( CalEvent_HasFinished( flav, GetUnixTimestamp() ) )
		RTKStruct_SetInt( root, "state", CUP_STATE_FINISHED )
	else if ( CalEvent_HasStarted( flav, GetUnixTimestamp() ) )
		RTKStruct_SetInt( root, "state", CUP_STATE_IN_PROGESS )
	else
		RTKStruct_SetInt( root, "state", CUP_STATE_STARTING )
}
