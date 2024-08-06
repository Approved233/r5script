global function RTKPanelImageButtonModal_InitPanelImageButtonModal
global function RTKPanelImageButtonModal_Show
global function RTKPanelImageButtonModal_AddOption
global function RTKPanelImageButtonModal_OnInitialize
global function RTKPanelImageButtonModal_OnDestroy
global function RTKPanelImageButtonModal_CancelSelection
global function RTKPanelImageButtonModal_ChangeOptionStateById
global function RTKPanelImageButtonModal_ChangeBackButtonText
global function RTKPanelImageButtonModal_GetCurrentMenuId

global struct RTKPanelImageData
{
	int id
	asset image
	string title
	string description
	string lockDescription
	int state
}

global enum ePanelImageButtonState
{
	AVAILABLE,
	SELECTED,
	UNAVAILABLE,
	LOCKED
}

global struct RTKPanelImageButtonModel
{
	string title
	array<RTKPanelImageData> itemsArray
}

struct {
	var    menu
	string menuId = ""
	string title
	array<RTKPanelImageData> options
	array< void functionref() > onClickCallbacks
	void functionref() onInitialize
	void functionref() onNavigateBack
	InputDef ornull backButtonDef
} file


struct
{
	float initTimestamp

} fileTelemetry

void function RTKPanelImageButtonModal_InitPanelImageButtonModal( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetDialog( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, RTKPanelImageButtonModal_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, RTKPanelImageButtonModal_NavigateBack )
	file.backButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function RTKPanelImageButtonModal_Show( string menuId, string title = "", void functionref() onInitialize = null, void functionref() onNavigateBack = null)
{
	file.menuId = menuId
	file.title = title
	file.onInitialize = onInitialize
	file.onNavigateBack = onNavigateBack
	AdvanceMenu( GetMenu( "PanelImageButtonModal" ) )
	RTKPanelImageButtonModal_ChangeBackButtonText( "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function RTKPanelImageButtonModal_OnInitialize( rtk_behavior self )
{
	rtk_struct panelImageButtonModal = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "panelImageButtonModal", "RTKPanelImageButtonModel" )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "panelImageButtonModal", true ) )
	RTKPanelImageButtonModal_SubscribeClickListeners( self )

	file.options.clear()
	file.onClickCallbacks.clear()

	if (file.onInitialize != null)
	{
		file.onInitialize()
	}

	RTKPanelImageButtonModel model
	model.title = file.title
	model.itemsArray = file.options
	RTKStruct_SetValue( panelImageButtonModal, model )
	fileTelemetry.initTimestamp = UITime()
}

void function RTKPanelImageButtonModal_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "panelImageButtonModal" )
	float openDuration =  UITime() - fileTelemetry.initTimestamp
	PIN_PageView_ImageButtonModal( file.menuId, openDuration)
	fileTelemetry.initTimestamp = 0.0
}

void function RTKPanelImageButtonModal_SubscribeClickListeners( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel().FindChildByName( "Container" )
	self.AutoSubscribe( panel, "onChildAdded", function ( rtk_panel newChild, int childIndex ) : ( self ) {

		rtk_behavior button =  newChild.FindBehaviorByTypeName( "Button" )

		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, childIndex ) {

			rtk_struct model = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "panelImageButtonModal", "RTKPanelImageButtonModel" )
			rtk_array items = RTKStruct_GetArray( model, "itemsArray" )

			int state = RTKStruct_GetInt( RTKArray_GetStruct( items , childIndex ) , "state" )

			if ( state == ePanelImageButtonState.AVAILABLE )
			{
				for ( int i = 0; i < RTKArray_GetCount( items ); i++ )
				{
					if ( childIndex == i )
					{
						RTKStruct_SetInt( RTKArray_GetStruct( items , i ) , "state", ePanelImageButtonState.SELECTED )
					}
					else
					{
						RTKStruct_SetInt( RTKArray_GetStruct( items , i ) , "state", ePanelImageButtonState.UNAVAILABLE )
					}
				}
			}

			if ( childIndex < file.onClickCallbacks.len() && file.onClickCallbacks[childIndex] != null )
			{
				file.onClickCallbacks[childIndex]()
			}
		} )
	} )
}

void function RTKPanelImageButtonModal_OnClose()
{
	file.title = ""
	file.options.clear()
	file.onClickCallbacks.clear()
	file.onInitialize = null
	file.onNavigateBack = null
}

void function RTKPanelImageButtonModal_NavigateBack()
{
	if ( file.onNavigateBack != null )
	{
		file.onNavigateBack()
	}
	else
	{
		CloseActiveMenu()
	}
}

void function RTKPanelImageButtonModal_AddOption( int id, string title = "", string description = "", string lockDescription = "", asset image = $"", void functionref() onClick = null, int state = ePanelImageButtonState.AVAILABLE )
{
	RTKPanelImageData panelImageData

	panelImageData.id = id
	panelImageData.title = title
	panelImageData.description = description
	panelImageData.lockDescription = lockDescription
	panelImageData.image  = image
	panelImageData.state = state

	file.options.append( panelImageData )
	file.onClickCallbacks.append( onClick )
}

void function RTKPanelImageButtonModal_CancelSelection()
{
	rtk_struct model = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "panelImageButtonModal", "RTKPanelImageButtonModel" )
	rtk_array items = RTKStruct_GetArray( model, "itemsArray" )

	for ( int i = 0; i < RTKArray_GetCount( items ); i++ )
	{
		RTKStruct_SetInt( RTKArray_GetStruct( items , i ) , "state", ePanelImageButtonState.AVAILABLE )
	}
}

void function RTKPanelImageButtonModal_ChangeOptionStateById( int id, int state )
{
	rtk_struct model = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "panelImageButtonModal", "RTKPanelImageButtonModel" )
	rtk_array items = RTKStruct_GetArray( model, "itemsArray" )

	for ( int i = 0; i < RTKArray_GetCount( items ); i++ )
	{
		if ( RTKStruct_GetInt( RTKArray_GetStruct( items , i ) , "id" ) == id )
		{
			RTKStruct_SetInt( RTKArray_GetStruct( items , i ) , "state", state )
			break
		}
	}
}

void function RTKPanelImageButtonModal_ChangeBackButtonText( string gamepadLabel, string mouseLabel = "" )
{
	if ( file.backButtonDef != null )
	{
		InputDef def = expect InputDef ( file.backButtonDef )
		def.gamepadLabel = gamepadLabel
		def.mouseLabel = mouseLabel
		UpdateFooterLabels()
	}
}

string function RTKPanelImageButtonModal_GetCurrentMenuId()
{
	return file.menuId
}
