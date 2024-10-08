globalize_all_functions

string function RTKMutator_FormatFloat( float input, string formatString )
{
	return format( formatString, input )
}

string function RTKMutator_FormatVector( vector input, string formatString )
{
	return format( formatString, format( "<%g, %g, %g>", input.x, input.y, input.z ) )
}

string function RTKMutator_FormatString( string input, string formatString )
{
	return format( formatString, input )
}

string function RTKMutator_ToUpper( string input )
{
	return input.toupper();
}

string function RTKMutator_FormatNumberFloat( float input, int maxIntegers = 3, int maxDecimals = 0 )
{
	return LocalizeAndShortenNumber_Float( input, maxIntegers, maxDecimals )
}

string function RTKMutator_FormatNumberInt( int input, int maxIntegers = 3, int maxDecimals = 0 )
{
	return LocalizeAndShortenNumber_Int( input, maxIntegers, maxDecimals )
}

string function RTKMutator_PickStringFromTwo( int input, string option0, string option1 )
{
	return input == 1 ? option1 : option0
}

string function RTKMutator_PickStringFromThree( int input, string param0, string param1,string param2 )
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
	Warning( "RTKMutator_PickStringFromThree : Invalid index" )
	return ""
	
}

string function RTKMutator_LocalizeString( string input1 )
{
	return Localize( input1 )
}

string function RTKMutator_LocalizeStringInAnother( string input1, string input2 )
{
	return Localize( input2, Localize( input1 ) )
}

string function RTKMutator_FormatTimeProperty( float input1 )
{
	string timeRemaining = ""
	int inputAsInt = input1.tointeger()

	if ( inputAsInt < 60 ) 
	{
		timeRemaining = Localize( "#TIME_REMAINING_SECONDS" , inputAsInt)
	}
	else if ( inputAsInt < 3600 )  
	{
		timeRemaining = Localize( "#TIME_REMAINING_MINUTES_SECONDS", inputAsInt / 60, inputAsInt % 60 )
	}
	else if ( inputAsInt < 86400 ) 
	{
		timeRemaining = Localize( "#TIME_REMAINING_HOURS_MINUTES", inputAsInt / 3600, ( inputAsInt % 3600 ) / 60)
	}
	else 
	{
		timeRemaining = Localize( "#TIME_REMAINING_DAYS_HOURS", inputAsInt / 86400, ( inputAsInt % 86400 ) / 3600 )
	}

	return timeRemaining
}

string function RTKMutator_FormatTimeLong( float input1 )
{
	string timeRemaining = ""
	int inputAsInt = input1.tointeger()

	if ( inputAsInt < 60 ) 
	{
		timeRemaining = inputAsInt != 1 ? Localize( "#TIME_REMAINING_SECONDS_LONG" , inputAsInt) : Localize( "#TIME_REMAINING_SECOND_LONG" , inputAsInt)
	}
	else if ( inputAsInt < 3600 )  
	{
		string secondKey = inputAsInt % 60  != 1 ? "SECONDS" : "SECOND"
		string minuteKey = inputAsInt / 60 != 1 ? "MINUTES" : "MINUTE"
		timeRemaining = Localize( "#TIME_REMAINING_" + minuteKey + "_" + secondKey + "_LONG", inputAsInt / 60, inputAsInt % 60 )
	}
	else if ( inputAsInt < 86400 ) 
	{
		string minuteKey = ( inputAsInt % 3600 ) / 60 != 1 ? "MINUTES" : "MINUTE"
		string hoursKey = inputAsInt / 3600  != 1 ? "HOURS" : "HOUR"
		timeRemaining = Localize( "#TIME_REMAINING_" + hoursKey + "_" + minuteKey + "_LONG", inputAsInt / 3600, ( inputAsInt % 3600 ) / 60, inputAsInt % 60 )
	}
	else 
	{
		string hoursKey = ( inputAsInt % 86400 ) / 3600  != 1 ? "HOURS" : "HOUR"
		string daysKey = inputAsInt / 86400  != 1 ? "DAYS" : "DAY"
		timeRemaining = Localize( "#TIME_REMAINING_" + daysKey + "_" + hoursKey + "_LONG", inputAsInt / 86400, ( inputAsInt % 86400 ) / 3600 )
	}

	return timeRemaining
}

string function RTKMutator_FormatAndLocalizeNumber( float input, string format, bool addThousandsSeparator )
{
	return FormatAndLocalizeNumber(format, input, addThousandsSeparator)
}

bool function RTKMutator_IsEmpty( string input )
{
	return input == "" || input.len() == 0
}

string function RTKMutator_IfEmpty( string input, string p0 )
{
	return RTKMutator_IsEmpty( input ) ? p0 : input
}
