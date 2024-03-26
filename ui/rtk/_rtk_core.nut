globalize_all_functions

global const string RTK_ON_DISABLE_SIGNAL = "RTKOnDisable"
global const string RTK_ON_DESTROY_SIGNAL = "RTKOnDestroy"

void function RTKCore_RegisterSignals()
{
	RegisterSignal( RTK_ON_DISABLE_SIGNAL )
	RegisterSignal( RTK_ON_DESTROY_SIGNAL )
}