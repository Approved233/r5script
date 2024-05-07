global function RTKMilestoneEventController_OnInitialize
global function RTKMilestoneEventController_OnDestroy

global struct RTKMilestoneEventController_Properties
{
	rtk_panel contentPanel
	rtk_behavior paginationBehavior
	bool isStoreEventsPanel
	rtk_panel loadingSpinner
}

struct
{

} file

void function RTKMilestoneEventController_OnInitialize( rtk_behavior self )
{
	if ( !GRX_AreOffersReady() )
	{
		thread InstantiateStoreEventPanelWhenGRXIsReady( self )
	}
	else
	{
		InstantiateStoreEventPanel( self )
	}
}

void function RTKMilestoneEventController_OnDestroy( rtk_behavior self )
{

}

void function InstantiateStoreEventPanelWhenGRXIsReady( rtk_behavior self )
{
	if ( GetActiveMenu() != GetMenu( "StoreOnlyMilestoneEventsMenu" ) )
		return

	
	if ( MilestoneEvent_IsMilestoneRewardCeremonyDue() )
	{
		if ( DisplayQueuedRewardsGiven() )
			return
	}

	bool hasInstantiated = false
	SetLoadingSpinnerVisibility( self, true )

	while ( !hasInstantiated )
	{
		if ( GRX_AreOffersReady() )
		{
			SetLoadingSpinnerVisibility( self, false )
			InstantiateStoreEventPanel( self )
			hasInstantiated = true
		}
		else
			wait( 0.1 )
	}
}

void function InstantiateStoreEventPanel( rtk_behavior self )
{
	if ( GetActiveMenu() != GetMenu( "StoreOnlyMilestoneEventsMenu" ) )
		return

	
	if ( MilestoneEvent_IsMilestoneRewardCeremonyDue() )
	{
		if ( DisplayQueuedRewardsGiven() )
			return
	}

	rtk_panel ornull context = self.PropGetPanel( "contentPanel" )
	if ( context != null )
	{
		expect rtk_panel( context )

			bool getStoreOnlyEvents = self.PropGetBool( "isStoreEventsPanel" )
			SetStoreOnlyEventsFilter( getStoreOnlyEvents )
			if ( GetActiveMilestoneEvent( GetUnixTimestamp() ) != null )
			{
				RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_panel.rpak", context, "Milestone Event" )
			}

	}
}

void function SetLoadingSpinnerVisibility( rtk_behavior self, bool visible )
{
	if ( GetActiveMenu() != GetMenu( "StoreOnlyMilestoneEventsMenu" ) )
		return

	if ( self == null || !IsValid( self ) )
		return

	rtk_panel ornull loadingSpinner = self.PropGetPanel( "loadingSpinner" )
	if ( loadingSpinner != null )
	{
		expect rtk_panel( loadingSpinner )
		loadingSpinner.SetVisible( visible )
	}
}