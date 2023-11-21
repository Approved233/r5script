

global function ShSkydiveEmoteProjector_LevelInit







global function SkydiveEmoteProjector_ActivateEmoteProjector


const int SKYDIVE_EMOTE_GUID_INDEX = 0


const asset SKYDIVE_EMOTE_BASE = $"mdl/props/holo_drone/holo_drone_v.rmdl"
const asset SKYDIVE_EMOTE_ACTIVATE_FX = $"P_drone_holospray_activate"
const asset SKYDIVE_EMOTE_EXHAUST_FX_01 = $"P_drone_holospray_exhaust_01"


























void function ShSkydiveEmoteProjector_LevelInit()
{
	Remote_RegisterServerFunction( "ClientCallback_ThrowProjector" )


		PrecacheModel( SKYDIVE_EMOTE_BASE )
		PrecacheParticleSystem( SKYDIVE_EMOTE_ACTIVATE_FX )
		PrecacheParticleSystem( SKYDIVE_EMOTE_EXHAUST_FX_01 )







}

























































































































































void function SkydiveEmoteProjector_ActivateEmoteProjector( entity player, ItemFlavor quip )
{
	Remote_ServerCallFunction( "ClientCallback_ThrowProjector" )
}



