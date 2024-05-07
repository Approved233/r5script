global function RTKTabbedModal_InitTabbedModal
global function RTKTabbedModal_OnInitialize
global function RTKTabbedModal_OnDestroy
global function UI_RTKTabbedModal_Open

const string SFX_MENU_OPENED = "UI_Menu_Focus_Large"

global enum eTabbedModalType
{
	WALLET_INVENTORY,
	WALLET_APEX_COINS,
	WALLET_EXOTIC_SHARDS
}

global struct RTKTabbedModal_Properties
{
}

global struct RTKTabbedModalModel
{
	int tabType
}

struct {
	var    menu
	string rootPath
	string dialogTitle
	string dialogMessage
	array<int> tabsTypes
	array<string> tabsTitles
	int initialTabIndex
	void functionref() onOpenCallback
	void functionref() onCloseCallback
} file

void function RTKTabbedModal_InitTabbedModal( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetDialog( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, RTKTabbedModal_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, RTKTabbedModal_OnClose )

	AddCallback_OnTabChanged( RTKTabbedModal_OnTabChanged )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function RTKTabbedModal_OnInitialize( rtk_behavior self )
{
	rtk_struct tabbedModal = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "tabbedModal", "RTKTabbedModalModel" )
	file.rootPath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "tabbedModal", true )
	self.GetPanel().SetBindingRootPath( file.rootPath )

	RTKTabbedModalModel model
	model.tabType = file.tabsTypes[file.initialTabIndex]
	RTKStruct_SetValue( tabbedModal, model )
}

void function RTKTabbedModal_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "tabbedModal" )
}

void function RTKTabbedModal_OnOpen()
{
	var contentElm = Hud_GetChild( file.menu, "DialogContent" )
	RuiSetString( Hud_GetRui( contentElm ), "headerText", file.dialogTitle )
	RuiSetString( Hud_GetRui( contentElm ), "messageText", file.dialogMessage )

	for( int i = 0; i < file.tabsTitles.len(); ++i )
	{
		AddTab( file.menu, null, file.tabsTitles[i] )
	}

	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	SetTabDefsToSeasonal( tabData )
	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )

	ActivateTab( tabData, file.initialTabIndex )

	UpdateMenuTabs()

	EmitUISound( SFX_MENU_OPENED )

	if (file.onOpenCallback != null)
	{
		file.onOpenCallback()
		file.onOpenCallback = null
	}
}

void function RTKTabbedModal_OnClose()
{
	ClearTabs( file.menu )
	if (file.onCloseCallback != null)
	{
		file.onCloseCallback()
		file.onCloseCallback = null
	}
}

void function RTKTabbedModal_OnTabChanged()
{
	rtk_struct tabbedModal = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "tabbedModal", "RTKTabbedModalModel" )
	TabData tabData = GetTabDataForPanel( file.menu )

	if ( tabData.activeTabIdx >= 0 )
	{
		RTKTabbedModalModel model
		model.tabType = file.tabsTypes[tabData.activeTabIdx]
		RTKStruct_SetValue( tabbedModal, model )
	}
}

void function UI_RTKTabbedModal_Open( string dialogTitle, string dialogMessage, array<int> tabsTypes, array<string> tabsTitles , int initialTabIndex = 0, void functionref() onOpenCallback = null, void functionref() onCloseCallback = null )
{
	Assert(tabsTypes.len() == tabsTitles.len(), "Number of Tab Types and Titles should be the same")
	file.dialogTitle = dialogTitle
	file.dialogMessage = dialogMessage
	file.tabsTypes = tabsTypes
	file.tabsTitles = tabsTitles
	file.initialTabIndex = initialTabIndex
	file.onOpenCallback = onOpenCallback
	file.onCloseCallback = onCloseCallback

	AdvanceMenu( GetMenu( "TabbedModal" ) )
}