global function RTKAnimatorStates_OnEnable
global function RTKAnimatorStates_InitMetaData

global struct RTKAnimatorStates_Properties
{
	int state
	array<string> animations
}
void function RTKAnimatorStates_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "Animator" )
}

void function RTKAnimatorStates_OnEnable( rtk_behavior self )
{
	RTKStruct_AddPropertyListener( self.GetProperties(), "state", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKAnimatorStates_UpdateAnimation( self )
	} )

	RTKAnimatorStates_UpdateAnimation( self )
}

void function RTKAnimatorStates_UpdateAnimation( rtk_behavior self )
{
	rtk_behavior ornull animator = self.GetPanel().FindBehaviorByTypeName( "Animator" )
	Assert( animator != null, "Missing animator" )

	expect rtk_behavior( animator )

	int state = self.PropGetInt( "state" )
	rtk_array animations = self.PropGetArray( "animations" )
	int arrayCount = RTKArray_GetCount( animations )

	if ( arrayCount == 0 || state < 0 || state >= arrayCount )
		return

	string animation = RTKArray_GetString( self.PropGetArray( "animations" ), state )

	if ( RTKAnimator_HasAnimation( animator, animation ) )
	{
		RTKAnimator_PlayAnimation( animator, animation )
	}
}
