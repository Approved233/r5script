global function ExtraShields_Init










global const string EXTRA_SHIELDS_DURATION_NETFLOAT = "extra_shields_duration"
global const float EXTRA_SHIELDS_TOTAL_DURATION = 28.0
global const int EXTRA_SHIELD_DECAY_RATE = 2







struct
{
	float totalShieldDuration






}file


void function ExtraShields_Init()
{
	file.totalShieldDuration = GetCurrentPlaylistVarFloat( "extra_shield_total_shield_duration", EXTRA_SHIELDS_TOTAL_DURATION )

	RegisterNetworkedVariable( EXTRA_SHIELDS_DURATION_NETFLOAT, SNDC_PLAYER_EXCLUSIVE, SNVT_FLOAT_RANGE , file.totalShieldDuration, 0.0, file.totalShieldDuration )












}



















































































































































