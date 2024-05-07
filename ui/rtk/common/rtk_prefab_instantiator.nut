global function RTKPrefabInstantiator_OnInitialize
global function RTKPrefabInstantiator_Instantiate
global function RTKPrefabInstantiator_SetPrefabArray
global function RTKPrefabInstantiator_SetIndexManual
global function RTKPrefabInstantiator_OnDestroy

global struct RTKPrefabInstantiator_Properties
{
	int prefabIndex
	array<asset> prefabArray
	string instanceName = "PrefabInstance"
	string bindingPath = ""
	rtk_panel parentPanel
	rtk_panel prevInstance
	int prevIndex = -1
	int propertyListenerID
}

void function RTKPrefabInstantiator_OnInitialize( rtk_behavior self )
{
	int propertyListenerID = RTKStruct_AddPropertyListener( self.GetProperties(), "prefabIndex", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKPrefabInstantiator_Instantiate( self )
	} )

	self.PropSetInt( "propertyListenerID", propertyListenerID )
}

void function RTKPrefabInstantiator_Instantiate( rtk_behavior self )
{
	
	int index = self.PropGetInt( "prefabIndex" )
	int prevIndex = self.PropGetInt( "prevIndex" )

	if ( index == prevIndex )
		return

	rtk_array prefabs = self.PropGetArray( "prefabArray" )
	if ( index < 0 || index >= RTKArray_GetCount( prefabs ) )
		return

	
	rtk_panel ornull parentPanel = self.PropGetPanel( "parentPanel" )
	if ( parentPanel == null )
		parentPanel = self.GetPanel()
	expect rtk_panel ( parentPanel )

	
	rtk_panel ornull prevInstance = self.PropGetPanel( "prevInstance" )
	if ( prevInstance != null )
		RTKPanel_Destroy( expect rtk_panel( prevInstance ) )

	
	asset prefab = RTKArray_GetAssetPath( prefabs, index )
	string instanceName = self.PropGetString( "instanceName" )
	string bindingPath = self.PropGetString( "bindingPath" )
	rtk_panel newInstance = RTKPanel_Instantiate( prefab, parentPanel, instanceName )
	self.PropSetPanel( "prevInstance", newInstance )
	self.PropSetInt( "prevIndex", index )
	if (bindingPath != "")
	{
		newInstance.SetBindingRootPath( bindingPath )
	}
}


void function RTKPrefabInstantiator_SetPrefabArray( rtk_behavior self, array<asset> prefabs )
{
	rtk_array rtkArray
	RTKArray_SetValue( rtkArray , prefabs )
	self.PropSetArray( "prefabArray", rtkArray )
}


void function RTKPrefabInstantiator_SetIndexManual( rtk_behavior self, int index )
{
	self.PropSetInt( "prefabIndex", index )
}

void function RTKPrefabInstantiator_OnDestroy( rtk_behavior self )
{
	RTKStruct_RemovePropertyListener( self.GetProperties(), "prefabIndex", self.PropGetInt( "propertyListenerID" ))
}
