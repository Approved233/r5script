globalize_all_functions

global struct TestVars
{
	vector v
	float  f
	int    i
	var    vr
	var    rui
	entity ent
}
TestVars s_testVars

TestVars function TV()
{
	return s_testVars
}

struct
{
	float dev_finisherFOV = 0.0
} file


void function ShDevUtility_Init()
{
	RegisterSignal( "DevSignal1" )
	RegisterSignal( "DevSignal2" )















}

void function DEV_PrintItemFlavorsOfType( int itemFlavType = eItemType.account_pack )
{
	

	foreach ( ItemFlavor itemFlav in GetAllItemFlavorsOfType( itemFlavType ) )
	{
		printt( ItemFlavor_GetAsset( itemFlav ), ItemFlavor_GetGUIDString( itemFlav ) )

		if ( itemFlavType == eItemType.account_pack )
		{
			array< ItemFlavor > packContents = GRXPack_GetPackContents( itemFlav )
			printt( "\tPackContentsCount", packContents.len() )
		}
	}
}













































































void function PrintStringArray( array<string> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach ( int index, string str in arr )
		printf( " [%d] - \"%s\"", index, str )
}


void function PrintIntArray( array<int> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach ( int index, int intVal in arr )
		printf( " [%d] - %d", index, intVal )
}



































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































