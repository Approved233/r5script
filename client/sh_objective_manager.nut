global function ObjectiveManager_RegisterObjectiveType

global function ObjectiveManager_AddCallback_OnRegisterObjectiveType


global function ObjectiveSystemCommonData_Sort_TimeLastActive_Oldest

















global enum eObjectiveSystem_ObjectiveType
{
	INVALID = -1,




		CAPTURE_ZONE,





	_count
}

global enum eObjectiveSystem_ObjectiveStatus
{
	INVALID = -1,
	INACTIVE,
	INCOMING,
	ACTIVE,
	COMPLETE,
	EXPIRED,

	_count
}

global struct ObjectiveSystem_CommonData
{
	entity																				objectiveEntity									= null
	int																					objectiveType 									= eObjectiveSystem_ObjectiveType.INVALID
	int																					objectiveStatus									= eObjectiveSystem_ObjectiveStatus.INVALID
	int																					objectiveScore									= 0
	int																					objectiveGoal									= 0
	float																				objectiveRadius									= 0.0
	vector																				objectiveCenter									= <0.0, 0.0, 0.0>
	float																				objectiveTimeLastActive							= 0.0
}

global struct ObjectiveSystem_Interface
{
	bool functionref()																	isEnabled										= null
	array< ObjectiveSystem_CommonData > functionref()									getObjectiveDataList							= null
	float functionref( ObjectiveSystem_CommonData )										getObjectiveMinimumActiveTimeRemaining			= null
	bool functionref( ObjectiveSystem_CommonData, int )									setObjectiveStatus								= null
}



struct
{









	table< int, ObjectiveSystem_Interface >												objectiveTypeToInterface

	
	array< void functionref( int ) >													callbacks_OnRegisterObjectiveType								= []
	array< void functionref( ObjectiveSystem_CommonData, int, int ) >					callbacks_OnObjectiveStatusChanged								= []
	
} file

void function ObjectiveManager_RegisterObjectiveType( int objectiveType, ObjectiveSystem_Interface objectiveInterface )
{
	Assert( (objectiveType > eObjectiveSystem_ObjectiveType.INVALID) && (objectiveType < eObjectiveSystem_ObjectiveType._count) )
	Assert( !(objectiveType in file.objectiveTypeToInterface) )

	file.objectiveTypeToInterface[ objectiveType ] <- objectiveInterface

	foreach ( void functionref( int ) callback in file.callbacks_OnRegisterObjectiveType )
	{
		callback( objectiveType )
	}
}




















































































bool function ObjectiveManager_AreObjectivesEnabled()
{
	return GetCurrentPlaylistVarBool( "objective_manager_enabled", true )
}


























































void function ObjectiveManager_AddCallback_OnRegisterObjectiveType( void functionref( int ) callback )
{
	Assert( !file.callbacks_OnRegisterObjectiveType.contains( callback ), "Already added " + string( callback ) + " to callbacks_OnRegisterObjectiveType" )
	file.callbacks_OnRegisterObjectiveType.append( callback )

	foreach ( int objectiveType, ObjectiveSystem_Interface objectiveInterface in file.objectiveTypeToInterface )
	{
		callback( objectiveType )
	}
}







int function ObjectiveSystemCommonData_Sort_TimeLastActive_Oldest( ObjectiveSystem_CommonData a, ObjectiveSystem_CommonData b )
{
	if ( a.objectiveTimeLastActive > b.objectiveTimeLastActive )
		return 1

	if ( a.objectiveTimeLastActive < b.objectiveTimeLastActive )
		return -1

	return 0
}

