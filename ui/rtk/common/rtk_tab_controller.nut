global struct RTKTabControllerEntry
{
	rtk_behavior tabButton
	rtk_panel tabContent
}

global struct RTKTabController_Properties
{
	array< RTKTabControllerEntry > tabs
	int initialTab = 0
}

global function RTKTabController_OnInitialize
global function RTKTabController_OnTabButtonClick
global function RTKTabController_NextTab
global function RTKTabController_PrevTab
global function RTKTabController_GetCurrentTabIndex

struct PrivateData
{
	int currentTab = 0
}

void function RTKTabController_OnInitialize( rtk_behavior self )
{
	int initialTab = expect int( self.rtkprops.initialTab )
	rtk_array tabs = expect rtk_array( self.rtkprops.tabs )
	int tabCount = RTKArray_GetCount( tabs )
	for ( int i = 0; i < tabCount; i++ )
	{
		rtk_struct entry = RTKArray_GetStruct( tabs, i )
		rtk_behavior tabButton = RTKStruct_GetBehavior( entry, "tabButton" )
		rtk_panel tabContent = RTKStruct_GetPanel( entry, "tabContent" )

		bool selected = i == initialTab
		tabContent.rtkprops.active = selected
		tabContent.SetVisible( selected )

		if ( selected )
		{
			PrivateData p
			self.Private( p )
			p.currentTab = initialTab
		}

		RTKTabButton_InitProps( tabButton, i, selected, void function( int tabIndex ) : ( self )
		{
			RTKTabController_OnTabButtonClick( self, tabIndex )
		} )
	}
}

void function RTKTabController_OnTabButtonClick( rtk_behavior self, int tabIndex )
{
	rtk_array tabs = expect rtk_array( self.rtkprops.tabs )
	int tabCount = RTKArray_GetCount( tabs )
	for ( int i = 0; i < tabCount; i++ )
	{
		rtk_struct entry       = RTKArray_GetStruct( tabs, i )
		rtk_behavior tabButton = RTKStruct_GetBehavior( entry, "tabButton" )
		rtk_panel tabContent   = RTKStruct_GetPanel( entry, "tabContent" )

		bool selected = i == tabIndex
		tabContent.rtkprops.active = selected
		tabContent.SetVisible( selected )

		RTKTabButton_SetSelected( tabButton, selected )

		if ( selected )
		{
			PrivateData p
			self.Private( p )
			p.currentTab = tabIndex
		}
	}
}

void function RTKTabController_NextTab( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_array tabs = expect rtk_array( self.rtkprops.tabs )
	int tabCount = RTKArray_GetCount( tabs )

	if ( p.currentTab < tabCount - 1 )
		RTKTabController_OnTabButtonClick( self, p.currentTab + 1 )
}

void function RTKTabController_PrevTab( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.currentTab > 0 )
		RTKTabController_OnTabButtonClick( self, p.currentTab - 1 )
}

int function RTKTabController_GetCurrentTabIndex( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	return p.currentTab
}
