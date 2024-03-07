




global function RTKAnimatorAutoPlay_OnEnable
global function RTKAnimatorAutoPlay_InitMetaData

global struct RTKAnimatorAutoPlay_Properties
{
	string animation
}
void function RTKAnimatorAutoPlay_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "Animator" )
}

void function RTKAnimatorAutoPlay_OnEnable( rtk_behavior self )
{
	rtk_behavior ornull animator = self.GetPanel().FindBehaviorByTypeName( "Animator" )
	Assert( animator != null, "Missing animator" )

	expect rtk_behavior( animator )

	string animation = self.PropGetString( "animation" )
	if ( RTKAnimator_HasAnimation( animator, animation ) )
	{
		RTKAnimator_PlayAnimation( animator, animation )
	}
}
