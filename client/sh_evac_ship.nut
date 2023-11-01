global function Sh_EvacShip_Init
global function EvacShip_RegisterNetworking




















	global function EvacShip_ServerCallback_DisplayShipFullHint


global const string EVAC_DROPSHIP_TARGETNAME = "evac_dropship"

















global const int	EVAC_SHIP_PASSENGERS_MAX = 6
const float DEFAULT_TIME_UNTIL_SHIP_ARRIVES = 60
const float DEFAULT_TIME_UNTIL_SHIP_DEPARTS = 30
const float DEFAULT_EVAC_RADIUS = 256
const float EVAC_SHIP_Z_OFFSET = 128


const float EVACSHIP_ANNOUNCEMENT_DURATION = 5.0



































struct
{



} file

void function Sh_EvacShip_Init()
{







}

void function EvacShip_RegisterNetworking()
{
	Remote_RegisterClientFunction( "EvacShip_ServerCallback_DisplayShipFullHint" )
}






































































































































































































































































































































































































































































































































































































































































































































































void function EvacShip_ServerCallback_DisplayShipFullHint()
{
	AddPlayerHint( EVACSHIP_ANNOUNCEMENT_DURATION, 0.5, $"", Localize( "#EVAC_SHIP_FULL_HINT" ) )
}


























































































































































































