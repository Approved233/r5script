globalize_all_functions

float function RTKMutator_Add( float input, float x )
{
	return input + x
}

float function RTKMutator_Subtract( float input, float x )
{
	return input - x
}

float function RTKMutator_Multiply( float input, float x )
{
	return input * x
}

vector function RTKMutator_MultiplyByVector( float input, vector x )
{
	return input * x
}

vector function RTKMutator_MultiplyByVectorX( float input, vector x )
{
	return <x.x * input, x.y, x.z>
}

vector function RTKMutator_MultiplyByVectorY( float input, vector x )
{
	return <x.x, x.y * input, x.z>
}

vector function RTKMutator_MultiplyByVectorZ( float input, vector x )
{
	return <x.x, x.y, x.z * input>
}

float function RTKMutator_Divide( float input, float x )
{
	if	( x == 0 )
		return 0
	return input / x
}

float function RTKMutator_Modulo( float input, float x )
{
	return input % x
}

float function RTKMutator_Abs( float input )
{
	return fabs( input )
}

float function RTKMutator_Lerp( float input, float a, float b )
{
	return a + ( ( b - a ) * input )
}

float function RTKMutator_Clamp( float input, float a, float b )
{
	return clamp( input, a, b )
}

float function RTKMutator_Clamp01( float input )
{
	return clamp( input, 0.0, 1.0 )
}

vector function RTKMutator_AddVectors( vector input, vector x )
{
	return input + x
}

vector function RTKMutator_SubtractVectors( vector input, vector x )
{
	return input - x
}

vector function RTKMutator_ScaleVector( vector input, float x )
{
	return input * x
}

vector function RTKMutator_VectorMultiplyVector( vector input, vector a )
{
	return < input.x * a.x, input.y * a.y, input.z * a.z >
}

vector function RTKMutator_LerpVector( float input, vector a, vector b )
{
	return a + ( ( b - a ) * input )
}

vector function RTKMutator_ClampVector( vector input, vector a, vector b )
{
	return < clamp( input.x, a.x, b.x ), clamp( input.y, a.y, b.y ), clamp( input.z, a.z, b.z ) >
}

int function RTKMutator_FloatToInt( float input )
{
	return int( input );
}

float function RTKMutator_IntToFloat( int input )
{
	return float( input );
}

vector function RTKMutator_PickVectorFromTwo( int input, vector option0, vector option1 )
{
	return input == 1 ? option1 : option0
}

float function RTKMutator_PickFloatFromTwo( int input, float option0, float option1 )
{
	return input == 1 ? option1 : option0
}

int function RTKMutator_PickIntFromTwo( int input, int option0, int option1 )
{
	return input == 1 ? option1 : option0
}

bool function RTKMutator_IsEven( int input )
{
	return input % 2 == 0
}

bool function RTKMutator_IsOdd( int input )
{
	return input % 2 == 1
}

bool function RTKMutator_IsNegative( int input )
{
	return input < 0
}

vector function RTKMutator_PickVectorFromThree( int input, vector param0, vector param1,vector param2 )
{
	switch ( input )
	{
		case (0):
			return param0
		case (1):
			return param1
		case (2):
			return param2
	}
	Warning( "RTKMutator_PickVectorFromThree : Invalid index" )
	return < 0,0,0 >
	
}

int function RTKMutator_PickIntFromFour( int input, int option0, int option1, int option2, int option3)
{
	switch ( input )
	{
		case (0):
			return option0
		case (1):
			return option1
		case (2):
			return option2
		case (3):
			return option3
	}
	Warning( "RTKMutator_PickIntFromFour : Invalid index" )
	return 0
	
}

int function RTKMutator_Minus( int input )
{
	return -input
}