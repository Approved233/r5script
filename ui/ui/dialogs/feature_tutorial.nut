global function InitFeatureTutorialDialog

global function OpenFeatureTutorialDialog
global function FeatureHasTutorialTabs
global function FeatureTutorial_GetGameModeName
global function GetPlaylist_UIRules
global function GetCurrentPlaylist_UIRules
global function OpenPlaylistTutorialDialog

global function UI_OpenFeatureTutorialDialog
global function UI_CloseFeatureTutorialDialog
global function AddCallback_UI_FeatureTutorialDialog_PopulateTabsForMode
global function AddCallback_UI_FeatureTutorialDialog_SetTitle
global function AddCallback_UI_FeatureTutorialDialog_SetHeader
global function AddCallback_UI_FeatureTutorialDialog_OnClose
global function UI_FeatureTutorialDialog_BuildDetailsData

global function RTKFeatureTutorialDialog_OnInitialize
global function RTKFeatureTutorialDialog_OnDestroy

const string SFX_MENU_OPENED = "UI_Menu_Focus_Large"


const int MAX_ARG_COUNT 	 = 6

global struct RTKFeatureTutorialDialog_Properties
{
	rtk_panel footers
}

global struct featureTutorialTableData
{
	string leftString
	string rightString
}

global struct featureTutorialData
{
	string          title
	string		 	description
	asset			image
	array< string >	descArgs
	array< featureTutorialTableData > tableData

	
	bool 			hasImage
}

global struct featureTutorialFooterData
{
	string             title
	string             titleGamepad
	void functionref( var ) callbackFunc
}


global struct featureTutorialTab
{
	string                       tabName
	array< featureTutorialData > rules
	array< featureTutorialFooterData > footerData
}

global struct dialogFooterData
{
	string label
}

global struct featureTutorialTabDataModel
{
	string                       tabName
	array< featureTutorialData > rules
	array< dialogFooterData > dialogFooterData
}

struct PrivateData
{
	void functionref( bool input ) inputChangedFunc
	void functionref() tabChangedFunc
}
struct {
	var                         menu
	bool                        tabsInitialized = false
	array< featureTutorialTab > tabs
	var                         contentElm
	string                      feature = ""

	
	string						playlist = ""

	table < string, array< featureTutorialTab > functionref() > featureTutorialPopulateTabsFunction
	table < string, string functionref() > featureTutorialSetTitleFunction
	table < string, string functionref() > featureTutorialSetHeaderFunction
	table < string, void functionref( string ) > featureTutorialOnClosed
	bool isControllerActive

} file

void function InitFeatureTutorialDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetPopup( menu, true )
	file.contentElm = Hud_GetChild( menu, "DialogContent" )
}

void function RTKFeatureTutorialDialog_OnInitialize( rtk_behavior self )
{
	
	file.tabs = GetFeatureTutorial()

	if( file.tabs.len() == 0 ) 
	{
		if ( GetActiveMenu() == file.menu )
		{
			printf( "menu_FeatureTutorialDialog: Attempted to Open About Screen with empty Tabs, Closing" )
			CloseActiveMenu()
		}
		return
	}
	else
	{
		if ( !file.tabsInitialized )
		{
			TabData tabData = GetTabDataForPanel( file.menu )
			tabData.centerTabs = true

			foreach( int idx, tab in file.tabs)
			{
				if( tab.rules.len() > 0 )
					AddTab( file.menu, null, tab.tabName )
			}

			file.tabsInitialized = true
		}

		rtk_struct featureTutorialModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "featureTutorial", "featureTutorialTabDataModel" )
		self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "featureTutorial", true ) )

		TabData tabData        = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		SetTabDefsToSeasonal( tabData )
		SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )
		if ( file.tabs.len() > 1 )
			ActivateTab( tabData, 0 )

		UpdateMenuTabs()

		SetTitles()
		SetFooterOption( self )
		SetRTKDataModel( 0 )
		EmitUISound( SFX_MENU_OPENED )

		PrivateData p
		self.Private( p )
		file.isControllerActive = IsControllerModeActive()
		p.inputChangedFunc = void function( bool input ) : ( self ) { FeatureTutorialDialog_OnInputModeUpdated( self ) }
		p.tabChangedFunc = void function() : ( self ) { FeatureTutorialDialog_OnTabChanged( self ) }
		AddUICallback_InputModeChanged( p.inputChangedFunc )
		AddCallback_OnTabChanged( p.tabChangedFunc )
	}
}

void function SetTitles()
{
	string title = ""
	if( FeatureHasTutorialTitle( file.feature ) )
	{
		string functionref() populateTitleFunc = file.featureTutorialSetTitleFunction[ file.feature ]
		title = populateTitleFunc()
	}

	string header = "#ABOUT_GAMEMODE"
	if ( FeatureHasTutorialHeader( file.feature ) )
	{
		string functionref() populateHeaderFunc = file.featureTutorialSetHeaderFunction[ file.feature ]
		header = populateHeaderFunc()
	}

	RuiSetString( Hud_GetRui( file.contentElm ), "messageText", title )
	RuiSetString( Hud_GetRui( file.contentElm ), "headerText", header )
}

void function FeatureTutorialDialog_OnInputModeUpdated( rtk_behavior self )
{
	file.isControllerActive = IsControllerModeActive()
	TabData tabData = GetTabDataForPanel( file.menu )
	int index = tabData.activeTabIdx
	rtk_struct featureTutorialModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "featureTutorial", "featureTutorialTabDataModel" )
	if ( index <= file.tabs.len() - 1 )
	{
		rtk_array ornull footers = RTKStruct_GetArray( featureTutorialModel, "dialogFooterData" )
		if ( footers == null )
			return
		expect rtk_array( footers )
		featureTutorialTab tab = file.tabs[index]
		foreach ( int i, featureTutorialFooterData footerData in file.tabs[index].footerData )
		{
			if ( i <= RTKArray_GetCount( footers ) )
			{
				rtk_struct footerStruct = RTKArray_GetStruct( footers, i )
				RTKStruct_SetString( footerStruct, "label", file.isControllerActive ? footerData.titleGamepad : footerData.title )
			}
		}
	}
}

void function RTKFeatureTutorialDialog_OnDestroy( rtk_behavior self )
{
	ClearTabs( file.menu )
	UpdateMenuTabs()

	file.tabs.clear()
	file.tabsInitialized = false
	PrivateData p
	self.Private( p )
	RemoveUICallback_InputModeChanged( p.inputChangedFunc )
	RemoveCallback_OnTabChanged( p.tabChangedFunc )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "featureTutorial" )

	if ( FeatureHasOnClosedCallback( file.feature ) )
	{
		void functionref( string ) OnClosedCallback = file.featureTutorialOnClosed[ file.feature ]
		OnClosedCallback( file.feature )
	}
}

void function FeatureTutorialDialog_OnTabChanged( rtk_behavior self )
{
	if ( GetActiveMenu() != file.menu )
		return

	TabData tabData = GetTabDataForPanel( file.menu )
	SetRTKDataModel( tabData.activeTabIdx )
}

void function SetRTKDataModel( int index )
{
	rtk_struct featureTutorialModel = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "featureTutorial", "featureTutorialTabDataModel" )
	if ( index <= file.tabs.len() - 1 )
	{
		featureTutorialTabDataModel dataModel
		featureTutorialTab tab = file.tabs[index]
		dataModel.rules = tab.rules
		dataModel.tabName = tab.tabName

		if ( tab.footerData.len() == 0 )
		{
			dialogFooterData footerModel
			footerModel.label = "#B_BUTTON_BACK"
			dataModel.dialogFooterData.append( footerModel )
		}
		else
		{
			foreach ( featureTutorialFooterData footerData in file.tabs[index].footerData )
			{
				dialogFooterData footerModel
				footerModel.label = file.isControllerActive ? footerData.titleGamepad : footerData.title
				dataModel.dialogFooterData.append( footerModel )
			}
		}
		RTKStruct_SetValue( featureTutorialModel, dataModel )
	}
}
void function SetFooterOption( rtk_behavior self )
{
	rtk_panel footersContainer = self.PropGetPanel( "footers" )
	self.AutoSubscribe( footersContainer, "onChildAdded", function( rtk_panel newChild, int newChildIndex ) : ( self )
	{
		rtk_behavior button = newChild.FindBehaviorByTypeName( "Button" )
		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex )
		{
			TabData tabData = GetTabDataForPanel( file.menu )
			if ( tabData.activeTabIdx <= file.tabs.len() - 1 )
			{
				featureTutorialTab tab = file.tabs[tabData.activeTabIdx]

				if ( tab.footerData.len() == 0 )
				{
					UICodeCallback_NavigateBack()
				}
				else
				{
					if ( newChildIndex <= tab.footerData.len() )
					{
						tab.footerData[newChildIndex].callbackFunc( null )
					}
				}
			}
		} )
	})
}

string function FeatureTutorial_GetGameModeName()
{
	return GetPlaylistVarString( file.playlist, "name", "" )
}


void function AddCallback_UI_FeatureTutorialDialog_PopulateTabsForMode( array< featureTutorialTab > functionref() func, string ruleSet )
{
	file.featureTutorialPopulateTabsFunction[ ruleSet ] <- func
}

void function AddCallback_UI_FeatureTutorialDialog_SetTitle( string functionref() func, string ruleSet )
{
	file.featureTutorialSetTitleFunction[ ruleSet ] <- func
}

void function AddCallback_UI_FeatureTutorialDialog_SetHeader( string functionref() func, string ruleSet )
{
	file.featureTutorialSetHeaderFunction[ ruleSet ] <- func
}

void function AddCallback_UI_FeatureTutorialDialog_OnClose( void functionref( string ) func, string ruleSet)
{
	file.featureTutorialOnClosed[ ruleSet ] <- func
}

void function OpenFeatureTutorialDialog( var button, string feature = "" )
{
	UI_OpenFeatureTutorialDialog( feature )
}

void function OpenPlaylistTutorialDialog( string playlist = "" )
{
	if ( !IsFullyConnected() )
		return

	file.playlist = playlist
	file.feature = GetPlaylist_UIRules( playlist )

	if( !FeatureHasTutorialTabs( file.feature ) )
		return

	AdvanceMenu( GetMenu( "FeatureTutorialDialog" ) )

}

void function UI_OpenFeatureTutorialDialog( string feature = "" )
{
	if ( !IsFullyConnected() )
		return

	file.playlist = GamemodeUtility_GetPlaylist()
	file.feature = feature

	if( !FeatureHasTutorialTabs( file.feature ) )
		return

	AdvanceMenu( GetMenu( "FeatureTutorialDialog" ) )
}


void function UI_CloseFeatureTutorialDialog()
{
	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
	}
	else if ( MenuStack_Contains( file.menu ) )
	{
		if( IsDialog( GetActiveMenu() ) )
		{
			
			CloseAllMenus()
		}
		else
		{
			
			MenuStack_Remove( file.menu )
		}
	}
}


void function FeatureTutorialDialog_Cancel( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}

string function GetPlaylist_UIRules( string playlist )
{
	if( !IsFullyConnected() )
		return ""
	return GetPlaylistVarString( playlist, "ui_rules", "" )
}

string function GetCurrentPlaylist_UIRules()
{
	if( !IsFullyConnected() )
		return ""

	return GetPlaylistVarString( file.playlist, "ui_rules", "" )
}

bool function FeatureHasTutorialTabs( string feature )
{
	return (feature in file.featureTutorialPopulateTabsFunction)
}

bool function FeatureHasTutorialTitle( string feature )
{
	return (feature in file.featureTutorialSetTitleFunction)
}

bool function FeatureHasTutorialHeader( string feature )
{
	return (feature in file.featureTutorialSetHeaderFunction)
}

bool function FeatureHasOnClosedCallback( string feature )
{
	return (feature in file.featureTutorialOnClosed)
}

array< featureTutorialTab > function GetFeatureTutorial()
{
	array< featureTutorialTab > tabs

	if ( !FeatureHasTutorialTabs( file.feature ) )
		return tabs

	array< featureTutorialTab > functionref() populateTabsFunc = file.featureTutorialPopulateTabsFunction[ file.feature ]
	tabs = populateTabsFunc()
	return tabs
}

featureTutorialData function UI_FeatureTutorialDialog_BuildDetailsData( string title = "", string description = "", asset image = $"", array< string > descArgs = ["", "", "", "", "", ""], table< string, string > tableData = {} )
{
	featureTutorialData data
	data.title = title
	data.description = description
	data.image = image
	for ( int i = 0; i < MAX_ARG_COUNT; i++ )
		data.descArgs.append( ( descArgs.len() > i ) ? descArgs[i] : "" )

	foreach ( string leftString, string rightString in tableData )
	{
		featureTutorialTableData td
		td.leftString = leftString
		td.rightString = tableData[leftString]
		data.tableData.append( td )
	}

	
	data.hasImage = image != $""

	return data
}
