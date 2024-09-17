

















































untyped

globalize_all_functions

global const TRIG_FLAG_NONE = 0
global const TRIG_FLAG_PLAYERONLY = 0x0001



global const TRIG_FLAG_EXCLUSIVE = 0x0010 
global const TRIG_FLAG_DEVDRAW = 0x0020
global const TRIG_FLAG_START_DISABLED = 0x0040
global const TRIG_FLAG_NO_PHASE_SHIFT = 0x0080
global const float MAP_EXTENTS = 128 * 128




global const TRIGGER_INTERNAL_SIGNAL = "OnTrigger"

global const CALCULATE_SEQUENCE_BLEND_TIME = -1.0

global const string SILENT_PLAYER_VOICE = "_silent"

global struct GravityLandData
{
	array<vector> points
	TraceResults& traceResults
	float         elapsedTime
}

global struct FirstPersonSequenceStruct
{
	string                     firstPersonAnim = ""
	string                     thirdPersonAnim = ""
	string                     firstPersonAnimIdle = ""
	string                     thirdPersonAnimIdle = ""
	string                     relativeAnim = ""
	string                     attachment = ""
	bool                       teleport = false
	bool                       noParent = false
	float                      blendTime = CALCULATE_SEQUENCE_BLEND_TIME
	float                      thirdPersonBlendInTime = -1.0
	float                      firstPersonBlendInTime = -1.0
	float                      firstPersonBlendOutTime = -1.0
	float                      thirdPersonBlendOutTime = -1.0
	bool                       noViewLerp = false
	bool                       hideProxy = false
	void functionref( entity ) viewConeFunction = null
	vector ornull              origin = null
	vector ornull              angles = null
	bool                       enablePlanting = false
	bool                       enableRelativeToGround = false
	bool                       enableCollision = false
	float                      setStartTime = -1 
	float                      setInitialTime = 0.0 
	bool                       useAnimatedRefAttachment = false 
	bool                       renderWithViewModels = false
	bool                       gravity = false 
	bool                       playerPushable = false
	array<string>              thirdPersonCameraAttachments = []
	bool                       thirdPersonCameraVisibilityChecks = false
	entity                     thirdPersonCameraEntity = null
	bool                       snapPlayerFeetToEyes = true
	bool                       prediction = false
	bool                       setVelocityOnEnd = false
	bool                       snapForLocalPlayer = false
}

global enum eGradeFlags
{
	IS_OPEN = (1 << 0),
	IS_BUSY = (1 << 1),
	IS_OPEN_SECRET = (1 << 2),
	IS_LOCKED = (1 << 3),
}

global enum eEntitiesDidLoadPriority
{
	
	LOW,
	MEDIUM,
	HIGH
}

global struct PotentialTargetData
{
	entity target
	float score
}

const array<string> ALLOWED_SCRIPT_PARENT_ENTS = [
	"hatch_bunker_entrance_model_z16",
	"hatch_bunker_entrance_model_z6",
	"hatch_bunker_entrance_model_z5",
	"hatch_bunker_entrance_model_z12",
	"hatch_bunker_entrance_model_z12_treasure",
]

struct RefEntAreaData
{
	vector areaMin
	vector areaMax
}

struct
{
	array<entity>                 invalidEntsForPlacingPermanentsOnto
	table<entity, RefEntAreaData> invalidAreasRelativeToEntForPlacingPermanentsOnto

	int functionref()            getNumTeamsRemainingCallback
	float functionref()			 getDeathCamTimeOverride
	float functionref()			 getDeathCamSpectateTimeOverride
	array<string>				 nonInstalledModsTracked
} file

void function Utility_Shared_Init()
{
	PrecacheModel( $"mdl/weapons/arms/human_pov_cockpit.rmdl" ) 

	RegisterSignal( TRIGGER_INTERNAL_SIGNAL )
	RegisterSignal( "devForcedWin" )
	RegisterSignal( "OnContinousUseStopped" )
	RegisterSignal( "OnChargeEnd" )
	RegisterSignal( "FadeModelIntensityOverTime" )
	RegisterSignal( "FadeModelColorOverTime" )
	RegisterSignal( "FadeModelAlphaOverTime" )
	RegisterSignal( "StopCamPosBlend" )
	RegisterSignal( "StopCamAngBlend" )

	#document( "IsAlive", "Returns true if the given ent is not null, and is alive." )
}


void function InitWeaponScripts()
{
	SmartAmmo_Init()

	



	Grenade_FileInit()
	Vortex_Init()
	Weapon_Cubemap_Init()

	
	
	
	

	Lifesteal_Init()












		HopupGoldenHorse_Init()

































	
	MpWeaponDefenderRailgun_Init()





	MpWeaponSentinel_Init()



	



	MpWeaponBow_Init()






	MpWeaponDmr_Init()






	MpWeaponSniper_Init()
	MpWeaponLSTAR_Init()







		MpWeaponTitanSword_Init()

	MpWeaponAlternatorSMG_Init()
	MpWeaponShotgun_Init()

		MpWeaponShotgunPistol_Init()

	MpWeaponThermiteGrenade_Init()
	MeleeWraithKunai_Init()
	MpWeaponWraithKunaiPrimary_Init()
	MeleeBloodhoundAxe_Init()
	MpWeaponBloodhoundAxePrimary_Init()
	MeleeCausticHammer_Init()
	MpWeaponCausticHammerPrimary_Init()
	MeleeLifelineBaton_Init()
	MpWeaponLifelineBatonPrimary_Init()
	MeleePathfinderGloves_Init()
	MpWeaponPathfinderGlovesPrimary_Init()
	MeleeOctaneKnife_Init()
	MpWeaponOctaneKnifePrimary_Init()
	MeleeMirageStatue_Init()
	MpWeaponMirageStatuePrimary_Init()
	MeleeWattsonGadget_Init()
	MpWeaponWattsonGadgetPrimary_Init()
	MeleeCryptoHeirloom_Init()
	MpWeaponCryptoHeirloomPrimary_Init()
	MeleeValkyrieSpear_Init()
	MpWeaponValkyrieSpearPrimary_Init()
	MeleeLobaHeirloom_Init()
	MpWeaponLobaHeirloomPrimary_Init()
	MeleeSeerHeirloom_Init()
	MpWeaponSeerHeirloomPrimary_Init()
	MeleeWraithKunai_rt01_Init()
	MpWeaponWraithKunai_rt01_Primary_Init()
	MeleeAshHeirloom_Init()
	MpWeaponAshHeirloomPrimary_Init()
	MeleeHorizonHeirloom_Init()
	MpWeaponHorizonHeirloomPrimary_Init()
	
	MeleeRevenantScythe_rt01_Init()
	MpWeaponRevenantScythePrimary_rt01_Init()
	MeleeFuseHeirloom_Init()
	MpWeaponFuseHeirloomPrimary_Init()

	MeleeArtifactDagger_Init()
	MpWeaponArtifactDaggerPrimary_Init()


		MeleeArtifactSword_Init()
		MpWeaponArtifactSwordPrimary_Init()






	MeleeCryptoHeirloomRt01_Init()
	MpWeaponCryptoHeirloomRt01Primary_Init()
	MeleeOctaneKnifeRt01_Init()
	MpWeaponOctaneKnifePrimaryRt01_Init()
	MeleeGibraltarClub_Init()
	MpWeaponGibraltarClubPrimary_Init()
	MeleeRampartWrench_Init()
	MpWeaponRampartWrenchPrimary_Init()
	MeleeRevenantScythe_Init()
	MpWeaponRevenantScythePrimary_Init()





		MeleeBoxingRing_Init()
		MpWeaponMeleeBoxingRing_Init()


	MpWeaponEmoteProjector_Init()
	MpGenericOffhand_Init()





	MpAbilityHuntModeWeapon_Init()
	MpWeaponIncapShield_Init()

















	MpWeapon3030_Init()
	MpWeaponDragon_LMG_Init()









		MpAbilityRedeployBalloon_Init()















		MpAbilityCopycatKit_Init()


	VOID_RING_Init()
	MpWeaponCar_Init()

	MpWeaponNemesis_Init()









	MpWeaponBasicBolt_Init()
	MpWeaponLmg_Init()




















	HopupGunshield_Init()





		MeleeHookSword_Init()
		MpWeaponHookSwordPrimary_Init()












}

void function InitAbilityScripts()
{
	
	MpAbilityNone_Init()								
	MpAbilityShifter_Init() 							
	MpAbilitySharedSilence_Init()						
	ShShellShock_Init()									
	ShGas_Init()										
	Sh_PassiveVoices_Init()								
	MpWeaponPhaseTunnel_Init()							
	MpWeaponZipline_Init() 								
	MpAbilityGibraltarShield_Init()						
	MpWeaponBubbleBunker_Init()							
	MpWeaponGrenadeDefensiveBombardment_Init()			
	MpAbilityAreaSonarScan_Init()						
	PassiveMedic_Init()									
	MpWeaponDeployableMedic_Init()						
	MpWeaponGrenadeBangalore_Init()						
	MpWeaponGrenadeCreepingBombardment_Init()			
	MpWeaponGrenadeCreepingBombardmentWeapon_Init()		
	MpAbilityMirageUltimate_Init()						
	MpWeaponDirtyBomb_Init()							
	MpWeaponGrenadeGas_Init()							
	PassiveOctane_Init()								
	Sh_JumpPad_Init()									
	MpWeaponTeslaTrap_Init()							
	MpWeaponTrophy_Init()								
	MpAbilityCryptoDrone_Init()							
	MpAbilityCryptoDroneEMP_Init()						
	MpAbilitySilence_Init()								
	MpAbilityRevenantDeathTotem_Init()					
	ShLobaPassiveEyeForQuality_LevelInit()				
	LobaTacticalTranslocation_LevelInit()				
	LobaUltimateBlackMarket_LevelInit()					
	PassiveGunner_Init()								
	MpWeaponCoverWall_Init()							
	MpWeaponMountedTurretPlaceable_Init()				
	MpWeaponMountedTurretWeapon_Init()					
	MpWeaponMobileHMG_Init()							
	MpSpaceElevatorAbility_Init()						
	MpSpaceElevator_Init()								
	MpWeaponBlackHole_Init()							
	PassiveGrenadier_Init()								
	MpWeaponClusterBombLauncher_Init()					
	MpWeapon_Mortar_Ring_Init()							
	MpWeapon_Mortar_Ring_Missile_Init()					
	MpAbilityValkJets_Init()							
	MpAbilityValkClusterMissile_Init()					
	MpAbilityValkSkyward_Init()							
	PassiveHeartbeatSensor_Init()						
	MpAbilitySonicBlast_Init()							
	MpWeaponEchoLocator_Init()							
	MpWeaponAshDataknife_Init()							
	MpWeaponArcBolt_Init()								
	MpWeaponPhaseBreach_Init()							
	MpMaggieCommon_Init()								
	ShPassiveWarlordsIre_Init()							
	MpWeaponRiotDrill_Init()							
	MpAbilityWreckingBall_Init()						
	MpWeaponReviveShield_Init()							
	MpAbilityShieldThrow_Init()							
	MpAbilityArmoredLeap_Init()							
	PassiveVantage_Init()								
	SniperRecon_Init()									
	Companion_Launch_Init()								
	VantageCompanion_Init()								
	MpWeaponVantageRecall_Init()						
	SniperUlt_Init()									
	ShResin_Init()										
	MpAbilityReinforce_Init()							
	PassiveReinforce_Init()								
	MpAbilitySpikeStrip_Init()							
	MpWeaponFerroWall_Init()							
	ShPassiveSling_Init()								
	MpWeaponDebuffZone_Init()							
	MpAbilityPortableAutoLoader_Init()					
	MpAbilityExectioner_Init()							
	MpAbilityShadowPounceFree_Init()					
	MpAbilityShadowForm_Init()							

		ShPassiveConduit_Init()							
		MpAbilityConduitArcFlash_Init()					
		Mp_ability_shield_mines_init()					
		Mp_ability_shield_mines_line_init()				



		ExtraShields_Init()

		ShPassiveUpgradeCore_Init()
		ShPassiveTacCooldownExtra_Init()
		ShPassiveExplosiveSpeedBoost_Init()
		ShPassiveAirborneHealthRegen_Init()
		ShPassiveBoostedHealthRegen_Init()
		ShPassiveSquadwipeSquadCount_Init()
		ShPassiveKnockShotgunAutoReload_Init()
		ShPassiveZiplineShield_Init()
		PhysicalOvershield_Init()
		ShPassiveKnockTacReset_Init()
		ShPassiveFasterTacWindup_Init()

		UpgradedClusterMissile_Init()
		UpgradedJets_Init()

		

		UpgradeSelectionMenu_Init()









































	
































































	







		EnemyAssistHighlight_Init()



















































































		AlterExtraScript_Init()
		MpAbilityPhaseDoor_Init()
		MpAbilityTransportPortal_Init()
		MpAbilityTransportPortalDatapad_Init()





		PassiveRemoteDeathboxInteract_Init()


		PassiveVoidVision_Init()



















}

bool function GetReplayDisabled()
{
	return GetGlobalNonRewindNetBool( "replayDisabled" )
}

bool function IsRoundWinningKillReplayEnabled()
{
	return GetGlobalNonRewindNetBool("roundWinningKillReplayEnabled")
}

bool function IsRoundWinningKillReplayPlaying()
{
	return GetGlobalNonRewindNetBool( "roundWinningKillReplayPlaying" )
}

float function GetRoundWinningKillReplayStartupWait()
{
	return GetCurrentPlaylistVarFloat( "round_winning_kill_replay_startup_wait", 2.1 )
}

float function GetRoundWinningKillReplayLength()
{
	return GetCurrentPlaylistVarFloat( "round_winning_kill_replay_length", 5.9 )
}

float function GetRoundWinningKillReplayTotalLength()
{
	return GetRoundWinningKillReplayStartupWait() + GetRoundWinningKillReplayLength()
}

bool function IsValid_ThisFrame( entity ent )
{
	if ( ent == null )
		return false

	return expect bool( ent.IsValidInternal() )
}


bool function IsAlive( entity ent )
{
	if ( ent == null )
		return false

	if ( !ent.IsValidInternal() )
		return false

	return ent.IsEntAlive()
}


bool function ControlPanel_IsValidModel( entity controlPanel )
{
	array<string> validModels
	validModels.append( "mdl/communication/terminal_usable_imc_01.rmdl" )
	validModels.append( "mdl/communication/terminal_usable_imc_02.rmdl" )
	validModels.append( "mdl/props/terminal_usable_wall_01_animated/terminal_usable_wall_01_animated.rmdl" )
	validModels.append( "mdl/props/terminal_usable_cpit_01_animated/terminal_usable_cpit_01_animated.rmdl" )
	validModels.append( "mdl/props/pathfinder_beacon_radar/pathfinder_beacon_radar_animated.rmdl" )
	validModels.append( "mdl/props/specter_shack_control/specter_shack_control.rmdl" )


		validModels.append( "mdl/props/recon_beacon_dish/recon_beacon_dish.rmdl" )
		validModels.append( "mdl/props/controller_console/controller_console.rmdl" )


	return validModels.contains( string( controlPanel.GetModelName() ) )
}


bool function ControlPanel_CanUseFunction( entity playerUser, entity controlPanel, int useFlags )
{
	if ( Bleedout_IsBleedingOut( playerUser ) || playerUser.p.isInExtendedUse )
		return false

	bool canUseWhileParented = EntIsHoverVehicle( playerUser.GetParent() ) && StatusEffect_HasSeverity( playerUser, eStatusEffect.camera_view )	
	if ( IsValid( playerUser.GetParent() ) && !canUseWhileParented )
		return false

	entity activeWeapon = playerUser.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) )
	{
		if( activeWeapon.IsWeaponOffhand() )
		{
			var offhandAllowsPickups = activeWeapon.GetWeaponInfoFileKeyField( "offhand_allow_player_interact" )
			if ( !offhandAllowsPickups || offhandAllowsPickups <= 0 )
				return false
		}
	}


		if ( TitanSword_Super_BlockAction( playerUser, "control_panel" ) )
			return false


	
	if ( !IsPlayerInCryptoDroneCameraView( playerUser ) )
	{
		float verticalOffset = playerUser.GetOrigin().z - controlPanel.GetOrigin().z
		if ( verticalOffset > 50 || verticalOffset < -50 )
			return false
	}

	
	int maxAngleToAxisAllowedDegrees = 60

	vector playerEyePos = playerUser.EyePosition()
	int attachmentIndex = controlPanel.LookupAttachment( "PANEL_SCREEN_MIDDLE" )

	Assert( attachmentIndex != 0 )
	vector controlPanelScreenPosition = controlPanel.GetAttachmentOrigin( attachmentIndex )
	vector controlPanelScreenAngles   = controlPanel.GetAttachmentAngles( attachmentIndex )
	vector controlPanelScreenForward  = AnglesToForward( controlPanelScreenAngles )

	vector screenToPlayerEyes = Normalize( playerEyePos - controlPanelScreenPosition )

	return DotProduct( screenToPlayerEyes, controlPanelScreenForward ) > deg_cos( maxAngleToAxisAllowedDegrees )
}


bool function SentryTurret_CanUseFunction( entity playerUser, entity sentryTurret )
{
	
	int maxAngleToAxisAllowedDegrees = 90

	vector playerEyePos = playerUser.EyePosition()
	int attachmentIndex = sentryTurret.LookupAttachment( "turret_player_use" )

	Assert( attachmentIndex != 0 )
	vector sentryTurretUsePosition = sentryTurret.GetAttachmentOrigin( attachmentIndex )
	vector sentryTurretUseAngles   = sentryTurret.GetAttachmentAngles( attachmentIndex )
	vector sentryTurretUseForward  = AnglesToForward( sentryTurretUseAngles )

	vector useToPlayerEyes = Normalize( playerEyePos - sentryTurretUsePosition )

	return DotProduct( useToPlayerEyes, sentryTurretUseForward ) > deg_cos( maxAngleToAxisAllowedDegrees )
}


void function ArrayRemoveInvalid( array<entity> ents )
{
	for ( int i = ents.len() - 1; i >= 0; i-- )
	{
		if ( !IsValid( ents[ i ] ) )
			ents.remove( i )
	}
}

float function GetGameStateChangeTime()
{
	return GetGlobalNonRewindNetTime( "gameStateChangeTime" )
}


float function TimeSpentInCurrentState()
{
	return Time() - GetGameStateChangeTime()
}

int function GetGameState()
{
	return GetGlobalNonRewindNetInt( "gameState" )
}


bool function GamePlaying()
{
	return GetGameState() == eGameState.Playing
}


bool function GameEpilogue()
{
	return GetGameState() == eGameState.Epilogue
}


bool function GamePlayingOrSuddenDeath()
{
	int gameState = GetGameState()
	return gameState == eGameState.Playing || gameState == eGameState.SuddenDeath
}

bool function GetForcedDialogueOnly()
{
	return GetGlobalNonRewindNetBool( "forcedDialogueOnly" )
}


bool function IsMatchOver()
{
	float gameEndTime = GetGameEndTime()
	if ( IsRoundBased() && gameEndTime > 0.0 )
		return true
	else if ( !IsRoundBased() && gameEndTime > 0.0 && Time() > gameEndTime )
		return true

	return false
}


bool function IsRoundBased()
{
	return GetGlobalNonRewindNetBool( "roundBased" )
}

bool function IsLootRoundBased()
{

		if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_EXPLORE ) )
			return true

	return IsRoundBased()
}


int function GetRoundsPlayed()
{
	return GetGlobalNonRewindNetInt( "roundsPlayed" )
}


int function GetNetWinningTeam()

{
	return GetGlobalNonRewindNetInt( "winningTeam" )
}

int function CompareTeamScore( int teamA, int teamB )
{
	int aVal = GameRules_GetTeamScore( teamA )
	int bVal = GameRules_GetTeamScore( teamB )








	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	
	if ( teamA < teamB )
		return 1
	else
		return -1

	return 0
}


int function GetSwitchedSides()
{
	return GetGlobalNonRewindNetInt( "switchedSides" )
}


bool function IsSwitchSidesBased()
{
	return GetSwitchedSides() != -1
}


int function HasSwitchedSides()

{
	return GetSwitchedSides()
}


bool function IsFirstRoundAfterSwitchingSides()
{
	if ( !IsSwitchSidesBased() )
		return false

	int switchedSide = GetSwitchedSides()

	if ( IsRoundBased() )
		return  switchedSide > 0 && GetRoundsPlayed() == switchedSide
	else
		return  switchedSide > 0

	unreachable
}

struct PlaneVisibility
{
	float value
	vector connectPoint
}

vector function FindBestDeathboxEdgeForVFX_WorldSpace( entity deathbox, entity player )
{
	vector endPoint = FindBestDeathboxEdgeForVFX_LocalSpace( deathbox, player )
	endPoint = RotateVector( endPoint, deathbox.GetAngles() )
	endPoint += deathbox.GetOrigin()

	return endPoint
}
vector function FindBestDeathboxEdgeForVFX_LocalSpace( entity deathbox, entity player )
{
	vector mins = deathbox.GetBoundingMins()
	vector maxs = deathbox.GetBoundingMaxs()
	vector boxToPlayer = player.EyePosition() - deathbox.GetOrigin()
	vector fwd = deathbox.GetForwardVector()
	vector rgt = deathbox.GetRightVector()
	vector up  = deathbox.GetUpVector()

	
	array<PlaneVisibility> planeArray

	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( fwd, boxToPlayer - maxs.x * fwd )
		testPlane.connectPoint = <maxs.x, 0, maxs.z * 0.5>
		planeArray.append( testPlane )
	}

	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( -fwd, boxToPlayer - mins.x * fwd )
		testPlane.connectPoint = <mins.x, 0, maxs.z * 0.5>
		planeArray.append( testPlane )
	}
	
	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( rgt, boxToPlayer - maxs.y * rgt )
		testPlane.connectPoint = <0, mins.y, maxs.z * 0.5>
		planeArray.append( testPlane )
	}

	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( -rgt, boxToPlayer - mins.y * rgt )
		testPlane.connectPoint = <0, maxs.y, maxs.z * 0.5>
		planeArray.append( testPlane )
	}

	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( up, boxToPlayer - maxs.z * up )
		testPlane.connectPoint = <0, 0, maxs.z>
		planeArray.append( testPlane )
	}

	{
		PlaneVisibility testPlane
		testPlane.value = DotProduct( -up, boxToPlayer )
		testPlane.connectPoint = <0, 0, mins.z>
		planeArray.append( testPlane )
	}

	planeArray.sort( int function( PlaneVisibility a, PlaneVisibility b ) : ()
	{
		if ( a.value > b.value )
			return -1
		else if( a.value < b.value )
			return 1

		return 0
	} )

	return planeArray[0].connectPoint
}

GravityLandData function GetGravityLandData( vector startPos, vector parentVelocity, vector objectVelocity, float timeLimit, bool bDrawPath = false, int traceMask = TRACE_MASK_NPCWORLDSTATIC, float bDrawPathDuration = 0.0, array pathColor = [ 255, 255, 0 ] )
{
	GravityLandData returnData

	Assert( timeLimit > 0 )

	
	float timeElapsePerTrace = 0.1

	float sv_gravity   = 750.0
	float ent_gravity  = 1.0
	float gravityScale = 1.0

	vector traceStart = startPos
	vector traceEnd   = traceStart
	float traceFrac
	int traceCount    = 0

	objectVelocity += parentVelocity

	while ( returnData.elapsedTime <= timeLimit )
	{
		objectVelocity.z -= (ent_gravity * sv_gravity * timeElapsePerTrace * gravityScale)

		traceEnd += objectVelocity * timeElapsePerTrace
		returnData.points.append( traceEnd )
		if ( bDrawPath )
			DebugDrawLine( traceStart, traceEnd, <pathColor[0], pathColor[1], pathColor[2]>, false, bDrawPathDuration )

		traceFrac = TraceLineSimple( traceStart, traceEnd, null )
		traceCount++
		if ( traceFrac < 1.0 )
		{
			returnData.traceResults = TraceLine( traceStart, traceEnd, null, traceMask, TRACE_COLLISION_GROUP_NONE )
			return returnData
		}
		traceStart = traceEnd
		returnData.elapsedTime += timeElapsePerTrace
	}

	return returnData
}

TraceResults function GetViewTrace( entity ent )
{
	vector traceStart        = ent.EyePosition()
	vector traceEnd          = traceStart + (ent.GetPlayerOrNPCViewVector() * 56756) 
	array<entity> ignoreEnts = [ ent ]

	return TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
}


void function ArrayRemoveDead( array<entity> entArray )
{
	for ( int i = entArray.len() - 1; i >= 0; i-- )
	{
		if ( !IsAlive( entArray[ i ] ) )
			entArray.remove( i )
	}
}

void function TableRemoveInvalid( table<entity, entity> Table )
{
	array<entity> deleteKey = []

	foreach ( entity key, entity value in Table )
	{
		if ( !IsValid_ThisFrame( key ) )
			deleteKey.append( key )

		if ( !IsValid_ThisFrame( value ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		
		if ( key in Table )
			delete Table[ key ]
	}
}

void function TableRemoveInvalidByValue( table<entity, entity> Table )
{
	array<entity> deleteKey = []

	foreach ( key, entity value in Table )
	{
		if ( !IsValid_ThisFrame( value ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		delete Table[ key ]
	}
}

void function TableRemoveDeadByKey( table<entity, entity> Table )
{
	array<entity> deleteKey = []

	foreach ( key, value in Table )
	{
		if ( !IsAlive( key ) )
			deleteKey.append( key )
	}

	foreach ( key in deleteKey )
	{
		delete Table[ key ]
	}
}


void function FadeOutSoundOnEntityAfterDelay( entity ent, string soundAlias, float delay, float fadeTime )
{
	if ( !IsValid( ent ) )
		return

	ent.EndSignal( "OnDestroy" )
	wait delay
	FadeOutSoundOnEntity( ent, soundAlias, fadeTime )
}

void function __WarpInEffectShared( vector origin, vector angles, string sfx, entity vehicle, float preWaitOverride = -1.0 )
{
	float preWait   = 2.0
	float sfxWait   = 0.1
	float totalTime = WARPINFXTIME

	if ( sfx == "" )
		sfx = "dropship_warpin"

	if ( preWaitOverride >= 0.0 )
		wait preWaitOverride
	else
		wait preWait  


		int fxIndex = GetParticleSystemIndex( FX_GUNSHIP_CRASH_EXPLOSION_ENTRANCE )
		StartParticleEffectInWorld( fxIndex, origin, angles )











	wait sfxWait

	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, sfx )






	wait totalTime - preWait - sfxWait
}


void function __WarpOutEffectShared( entity dropship )
{
	int attach    = dropship.LookupAttachment( "origin" )
	vector origin = dropship.GetAttachmentOrigin( attach )
	vector angles = dropship.GetAttachmentAngles( attach )


		int fxIndex = GetParticleSystemIndex( FX_GUNSHIP_CRASH_EXPLOSION_EXIT )
		StartParticleEffectInWorld( fxIndex, origin, angles )












		EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "dropship_warpout" )




}

void function CamBlendFov( entity cam, float oldFov, float newFov, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		float interp = Interpolate( startTime, endTime - startTime, transAccel, transDecel )
		cam.SetFOV( GraphCapped( interp, 0.0, 1.0, oldFov, newFov ) )
		wait(0.0)
		currentTime = Time()
	}
}


void function CamFollowEnt( entity cam, entity ent, float duration, vector offset = <0, 0, 0>, string attachment = "", bool isInSkybox = false )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	vector camOrg = <0, 0, 0>

	vector targetPos  = <0, 0, 0>
	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + duration
	vector diff       = <0, 0, 0>
	int attachID      = ent.LookupAttachment( attachment )

	while ( endTime > currentTime )
	{
		camOrg = cam.GetOrigin()

		if ( attachID <= 0 )
			targetPos = ent.GetOrigin()
		else
			targetPos = ent.GetAttachmentOrigin( attachID )

		if ( isInSkybox )
			targetPos = SkyboxToWorldPosition( targetPos )
		diff = (targetPos + offset) - camOrg

		cam.SetAngles( VectorToAngles( diff ) )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamFacePos( entity cam, vector pos, float duration )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + duration
	vector diff       = <0, 0, 0>

	while ( endTime > currentTime )
	{
		diff = pos - cam.GetOrigin()

		cam.SetAngles( VectorToAngles( diff ) )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromFollowToAng( entity cam, entity ent, vector endAng, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	vector camOrg = cam.GetOrigin()

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		vector diff        = ent.GetOrigin() - camOrg
		vector anglesToEnt = VectorToAngles( diff )

		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = anglesToEnt + ShortestRotation( anglesToEnt, endAng ) * frac

		cam.SetAngles( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromPosToPos( entity cam, vector startPos, vector endPos, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.Signal( "StopCamPosBlend" )

	cam.EndSignal( "OnDestroy" )
	cam.EndSignal( "StopCamPosBlend" )

	OnThreadEnd(
		function () : ( cam, endPos )
		{
			if ( IsValid( cam ) )
				cam.SetOrigin( endPos )
		}
	)

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime
	vector diff       = endPos - startPos

	while ( endTime > currentTime )
	{
		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = startPos + diff * frac

		cam.SetOrigin( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromAngToAng( entity cam, vector startAng, vector endAng, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.Signal( "StopCamAngBlend" )

	cam.EndSignal( "OnDestroy" )
	cam.EndSignal( "StopCamAngBlend" )

	OnThreadEnd(
		function () : ( cam, endAng )
		{
			if ( IsValid( cam ) )
				cam.SetAngles( endAng )
		}
	)

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = startAng + ShortestRotation( startAng, endAng ) * frac

		cam.SetAngles( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}

void function SetDeathCamTimeOverride( float functionref() func )
{
	file.getDeathCamTimeOverride = func
}

float function GetDeathCamLength( entity player )
{
	if ( file.getDeathCamTimeOverride != null )
		return file.getDeathCamTimeOverride()

	
	if ( GetGameState() < eGameState.Playing )
		return DEATHCAM_TIME_SHORT

	return DEATHCAM_TIME
}


float function GetDeathCamLength_Freespawns( entity player )
{
	if ( file.getDeathCamTimeOverride != null )
		return file.getDeathCamTimeOverride()

	
	if ( GetGameState() < eGameState.Playing )
		return DEATHCAM_TIME_SHORT

	if ( !FreeRespawns_Feature_IsInEffect() )
		return DEATHCAM_TIME

	return Freespawns_PLV_DeathCam_Time( player )
}


void function SetDeathCamSpectateTimeOverride( float functionref() func )
{
	file.getDeathCamSpectateTimeOverride = func
}

float function GetDeathCamSpectateLength()
{
	if ( file.getDeathCamSpectateTimeOverride != null )
		return file.getDeathCamSpectateTimeOverride()

	return GetCurrentPlaylistVarFloat( "min_deathcam_spectate_length", 0.0 )
}

float function GetRespawnButtonCamTime( entity player )
{
	const float RESPAWN_BUTTON_BUFFER = 0.0
	return DEATHCAM_TIME + RESPAWN_BUTTON_BUFFER
}


bool function IntroPreviewOn()
{
	int bugnum = GetBugReproNum()
	switch ( bugnum )
	{
		case 1337:
		case 13371:
		case 13372:
		case 13373:
		case 1338:
		case 13381:
		case 13382:
		case 13383:
			return true
	}

	return false
}


bool function EntHasModelSet( entity ent )
{
	asset modelName = ent.GetModelName()

	if ( modelName == $"" || modelName == $"?" )
		return false

	return true
}




















void function AddCallback_OnUseEntity_ClientServer( entity ent, void functionref( entity, entity, int ) callbackFunc )
{
	ent.e.onUseEntityCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnUseEntity( entity ent, void functionref( entity, entity, int ) callbackFunc )
{
	int ornull funcPos = ent.e.onUseEntityCallbacks.find( callbackFunc )
	Assert( funcPos != null, "Cannot remove " + string( callbackFunc ) + " that was not added to entity" )
	ent.e.onUseEntityCallbacks.remove( expect int( funcPos ) )



}


bool function IsVortexSphere( entity ent )
{
	return ent.GetNetworkedClassName() == "vortex_sphere"
}


bool function IsPlayerWaypoint( entity ent )
{
	return ent.GetNetworkedClassName() == "player_waypoint"
}

typedef EntitiesDidLoadCallbackType void functionref()
struct EntityDidLoadCallback {
	EntitiesDidLoadCallbackType callbackFunc
	int priority
}
array< EntityDidLoadCallback > _EntitiesDidLoadTypedCallbacks


void function RunCallbacks_EntitiesDidLoad()
{
	
	if ( "forcedReloading" in level )
		return

	
	_EntitiesDidLoadTypedCallbacks.sort( int function( EntityDidLoadCallback a, EntityDidLoadCallback b ){
		if ( a.priority > b.priority )
			return -1
		else if (  a.priority < b.priority )
			return 1
		return 0
	} )

	foreach ( callback in _EntitiesDidLoadTypedCallbacks )
	{
		thread callback.callbackFunc()
	}
}





void function AddCallback_EntitiesDidLoad( EntitiesDidLoadCallbackType callbackFunc, int priority = eEntitiesDidLoadPriority.LOW )
{
	EntityDidLoadCallback callback
	callback.callbackFunc = callbackFunc
	callback.priority = priority

	_EntitiesDidLoadTypedCallbacks.append( callback )
}


string function GetPlayerBodyType( entity player )
{
	return player.GetPlayerSettingString( "weaponClass" )
}


string function GetPlayerVoice( entity player )
{
	return player.GetPlayerSettingString( "voice" )
}

entity function Get_Player_ByName( string playerName )
{
	entity result
	array< entity > players = GetPlayerArray()
	foreach( player in players )
	{
		if ( !IsValid( player ) )
			continue

		if ( player.GetPlayerName() == playerName )
		{
			result = player
			break
		}
	}

	return result
}

#if DEV
void function PrintFirstPersonSequenceStruct( FirstPersonSequenceStruct fpsStruct )
{
	printt( "Printing FirstPersonSequenceStruct:" )

	printt( "firstPersonAnim: " + fpsStruct.firstPersonAnim )
	printt( "thirdPersonAnim: " + fpsStruct.thirdPersonAnim )
	printt( "firstPersonAnimIdle: " + fpsStruct.firstPersonAnimIdle )
	printt( "thirdPersonAnimIdle: " + fpsStruct.thirdPersonAnimIdle )
	printt( "relativeAnim: " + fpsStruct.relativeAnim )
	printt( "attachment: " + fpsStruct.attachment )
	printt( "teleport: " + fpsStruct.teleport )
	printt( "noParent: " + fpsStruct.noParent )
	printt( "blendTime: " + fpsStruct.blendTime )
	printt( "noViewLerp: " + fpsStruct.noViewLerp )
	printt( "hideProxy: " + fpsStruct.hideProxy )
	printt( "viewConeFunction: " + string( fpsStruct.viewConeFunction ) )
	printt( "origin: " + string( fpsStruct.origin ) )
	printt( "angles: " + string( fpsStruct.angles ) )
	printt( "enablePlanting: " + fpsStruct.enablePlanting )
	printt( "setStartTime: " + fpsStruct.setStartTime )
	printt( "setInitialTime: " + fpsStruct.setInitialTime )
	printt( "useAnimatedRefAttachment: " + fpsStruct.useAnimatedRefAttachment )
	printt( "renderWithViewModels: " + fpsStruct.renderWithViewModels )
	printt( "gravity: " + fpsStruct.gravity )
}
#endif

string function GetEditorClass( entity ent )
{
	if ( ent.HasKey( "editorclass" ) )
		return ent.GetValueForKey( "editorclass" )

	return ""
}

bool function PlayerIsInADS( entity player, bool checkMelee = true )
{
	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( activeWeapon ) )
		return false

	if ( checkMelee )
	{
		if ( activeWeapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
			return false
	}

	return activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds()
}

float function GetCurrentPlayerFOV( entity player )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( weapon ) )
	{
		return weapon.GetWeaponZoomFOV()
	}

	return float( player.GetDefaultFOV() )
}



















bool function GradeFlagsHas( entity ent, int gradeFlags )
{
	return ((ent.GetGrade() & gradeFlags) != 0)
}


void function FadeModelIntensityOverTime( entity model, float duration = 1, float startIntensity = 1, float endIntensity = 10 )
{
	EndSignal( model, "OnDestroy" )

	Signal( model, "FadeModelIntensityOverTime" )
	EndSignal( model, "FadeModelIntensityOverTime" )

	float startTime       = Time()
	float endTime         = startTime + duration
	float intensityResult = startIntensity

	while ( Time() <= endTime )
	{
		intensityResult = GraphCapped( Time(), startTime, endTime, startIntensity, endIntensity )
		model.kv.intensity = intensityResult
		
		
		WaitFrame()
	}

	if ( intensityResult != endIntensity )
	{
		model.kv.intensity = endIntensity
		
	}
}


void function FadeModelColorOverTime( entity model, float duration, vector startColor = < 255, 255, 255 >, vector endColor = < 0, 0, 0 > )
{
	EndSignal( model, "OnDestroy" )

	Signal( model, "FadeModelColorOverTime" )
	EndSignal( model, "FadeModelColorOverTime" )

	float startTime = Time()
	float endTime   = startTime + duration

	while ( Time() <= endTime )
	{
		vector colorResult = GraphCappedVector( Time(), startTime, endTime, startColor, endColor )
		string colorString = colorResult.x + " " + colorResult.y + " " + colorResult.z
		model.kv.rendercolor = colorString
		model.kv.renderamt = 255
		
		WaitFrame()
	}

	string endColorString = endColor.x + " " + endColor.y + " " + endColor.z
	if ( model.kv.rendercolor != endColorString )
	{
		model.kv.rendercolor = endColorString
		
		
	}
}


void function FadeModelAlphaOverTime( entity ent, float duration, int startAlpha = 255, int endAlpha = 0 )
{
	EndSignal( ent, "OnDestroy" )

	Signal( ent, "FadeModelAlphaOverTime" )
	EndSignal( ent, "FadeModelAlphaOverTime" )

	OnThreadEnd( void function() : ( ent, endAlpha ) {
		if ( !IsValid( ent ) )
			return

		ent.kv.renderamt = endAlpha
		if ( endAlpha >= 255 )
			ent.kv.rendermode = 0
	} )

	ent.kv.rendermode = 4

	float startTime = Time()
	float endTime   = startTime + duration
	while ( Time() <= endTime )
	{
		ent.kv.renderamt = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		WaitFrame()
	}
}

array<entity> function GetEntityAndImmediateChildren( entity parentEnt )
{
	array<entity> out = []



		Assert( parentEnt.GetCodeClassName() == "dynamicprop" )

		out.extend( parentEnt.GetChildren() )

	out.append( parentEnt )
	return out
}


array<entity> function GetEntityAndAllChildren( entity parentEnt )
{
	array<entity> entList = [ parentEnt ]
	int entIdx            = 0
	while ( entIdx < entList.len() )
	{
		entity ent = entList[entIdx]

		entIdx++

		if ( IsValid( ent ) )
			entList.extend( ent.GetChildren() )
	}
	return entList
}


entity function GetPusherEnt( entity ent )
{
	entity pusher = ent
	while( IsValid( pusher ) && pusher.HasPusherAncestor() && !pusher.GetPusher() )
	{
		pusher = pusher.GetParent()
	}

	if ( IsValid( pusher ) && pusher.GetPusher() )
		return pusher

	return null
}

bool function PlayersInSameParty( entity player1, entity player2 )
{
	if ( player1.GetPartyLeaderClientIndex() < 0 )
		return false

	if ( player2.GetPartyLeaderClientIndex() < 0 )
		return false

	return (player1.GetPartyLeaderClientIndex() == player2.GetPartyLeaderClientIndex())
}

table< var, array< entity > > function GetAllMatchReservationParties()
{
	Assert( !IsLobby(), FUNC_NAME()+" is only to be used to get pre-reserved parties in a match" )

	table< var, array< entity > > out

	foreach( entity player in GetPlayerArray() )
	{
		var leaderIndex = player.GetPartyLeaderClientIndex()
		if( leaderIndex < 0 )
			out[ player.GetPlayerIndex() ] <- [ player ]
		else if( leaderIndex in out )
			out[leaderIndex].append( player )
		else
			out[leaderIndex] <- [ player ]
	}

	return out
}











void function GivePlayerSettingsMods( entity player, array<string> additionalMods )
{

		if ( !player.GetPredictable() )
			return


	int oldMaxHealth = player.GetMaxHealth()
	int oldHealth    = player.GetHealth()


	if ( InPrediction() )

	{

			Assert( additionalMods.len() == 1 )


		
		
		array<string> modsToAdd
		foreach( mod in additionalMods ) 
		{
			bool isModAvailable = player.IsClassModAvailableForPlayerSetting( mod )
			Assert( isModAvailable, "Undefined mod '" + mod + "' requested for player class '" + player.GetPlayerClass() + "'" )

			if( isModAvailable )
				modsToAdd.append( mod )
		}

		if( modsToAdd.len() > 0 )
		{
			if ( additionalMods.len() == 1 )
			{
				player.AddPlayerClassMod( additionalMods[ 0 ] )
			}
			else
			{





			}
		}
	}









}


void function TakePlayerSettingsMods( entity player, array<string> modsToTake, bool isHealthReset = true )
{
	array<string> mods = player.GetPlayerSettingsMods()
	int oldMaxHealth = player.GetMaxHealth()
	int oldHealth    = player.GetHealth()


	if ( InPrediction() )

	{

			Assert( modsToTake.len() == 1 )

		if ( modsToTake.len() == 1 && mods.contains( modsToTake[ 0 ] ) )
		{
			player.RemovePlayerClassMod( modsToTake[ 0 ] )
		}
		else
		{
			foreach ( string modToTake in modsToTake )
				mods.fastremovebyvalue( modToTake )




		}
	}










}


bool function Placement_IsHitEntScriptedPlaceable( entity hitEnt, int depth )
{
	if ( hitEnt.IsWorld() )
		return false

	var hitEntClassname = hitEnt.GetNetworkedClassName()
	if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" || hitEntClassname == "func_brush_lightweight" )
	{
		return true
	}

	if ( ALLOWED_SCRIPT_PARENT_ENTS.contains( hitEnt.GetScriptName() ) )
	{
		return true
	}

	if ( depth > 0 )
	{
		if ( IsValid( hitEnt.GetParent() ) )
		{
			return Placement_IsHitEntScriptedPlaceable( hitEnt.GetParent(), depth - 1 )
		}
	}

	return false
}

























void function AddEntToInvalidEntsForPlacingPermanentsOnto( entity ent )
{
	Assert( !file.invalidEntsForPlacingPermanentsOnto.contains( ent ) )
	file.invalidEntsForPlacingPermanentsOnto.append( ent )
}


void function RemoveEntFromInvalidEntsForPlacingPermanentsOnto( entity ent )
{
	Assert( file.invalidEntsForPlacingPermanentsOnto.contains( ent ) )
	file.invalidEntsForPlacingPermanentsOnto.removebyvalue( ent )
}


bool function IsEntInvalidForPlacingPermanentOnto( entity ent )
{
	return file.invalidEntsForPlacingPermanentsOnto.contains( ent )
}


void function AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( entity refEnt, vector areaMin, vector areaMax )
{
	Assert( !(refEnt in file.invalidAreasRelativeToEntForPlacingPermanentsOnto) )

	RefEntAreaData data
	data.areaMin = areaMin
	data.areaMax = areaMax

	file.invalidAreasRelativeToEntForPlacingPermanentsOnto[refEnt] <- data
}


void function RemoveRefEntAreaFromInvalidOriginsForPlacingPermanentsOnto( entity refEnt )
{
	if ( refEnt in file.invalidAreasRelativeToEntForPlacingPermanentsOnto )
	{
		delete file.invalidAreasRelativeToEntForPlacingPermanentsOnto[ refEnt ]
	}
	else
	{
		Assert( false, "Ref ent is not in table of ref ent areas." )
	}
}


bool function IsOriginInvalidForPlacingPermanentOnto( vector origin, entity realmEnt )
{
	foreach ( entity refEnt, RefEntAreaData data in file.invalidAreasRelativeToEntForPlacingPermanentsOnto )
	{
		if ( !IsValid( refEnt ) )
			continue

		if( IsValid( realmEnt ) && !refEnt.DoesShareRealms( realmEnt ) )
			continue

		vector localPos = WorldPosToLocalPos_NoEnt( origin, refEnt.GetOrigin(), refEnt.GetAngles() )

		if ( localPos.x > data.areaMin.x && localPos.x < data.areaMax.x
		&& localPos.y > data.areaMin.y && localPos.y < data.areaMax.y
		&& localPos.z > data.areaMin.z && localPos.z < data.areaMax.z )
			return true
	}

	return false
}

bool function IsUltimateOffCooldown( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return false

	entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	bool ultReady = false

	if ( IsValid( ultWeapon ) )
	{
		int ammoReq  = ultWeapon.GetAmmoPerShot()
		int currAmmo = ultWeapon.GetWeaponPrimaryClipCount()
		if ( currAmmo >= ammoReq )
		{
			ultReady = true
		}
	}

	return ultReady
}

int function SortByScore( PotentialTargetData a,  PotentialTargetData b )
{
	if ( a.score > b.score )
		return -1
	else if ( a.score < b.score )
		return 1

	return 0
}

float function GetEffectiveDeltaSince( float timeThen )
{
	if ( timeThen <= 0.0001 )
		return 999999.0

	return (Time() - timeThen)
}

string function TryGetValueForKey( entity ent, string key, string defaultValue )
{
	if ( ent.HasKey( key ) )
	{
		return ent.GetValueForKey( key )
	}

	return defaultValue
}

float function GetEntHeight( entity ent )
{
	return ent.GetBoundingMaxs().z - ent.GetBoundingMins().z
}

float function GetEntWidth( entity ent )
{
	return ent.GetBoundingMaxs().x - ent.GetBoundingMins().x
}

float function GetEntDepth( entity ent )
{
	return ent.GetBoundingMaxs().y - ent.GetBoundingMins().y
}

void function DestroyEntities( array<entity> ents )
{
	foreach ( entity ent in ents )
		if ( IsValid( ent ) )
			ent.Destroy()
}

FXHandle function StartWorldFXWithHandle( asset fxAsset, vector pos, vector ang )
{
	int fxAssetId = GetParticleSystemIndex( fxAsset )



		return StartParticleEffectInWorldWithHandle( fxAssetId, pos, ang )

}

FXHandle function StartEntityFXWithHandle( entity ent, asset fxAsset, int attachType, int attachData )
{
	int fxAssetId = GetParticleSystemIndex( fxAsset )



		return StartParticleEffectOnEntity( ent, fxAssetId, attachType, attachData )

}

FXHandle function CleanupFXHandle( FXHandle fxHandle, bool doRemoveAllParticlesNow = true, bool doPlayEndCap = false )
{




















		if ( EffectDoesExist( fxHandle ) )
			EffectStop( fxHandle, doRemoveAllParticlesNow, doPlayEndCap )

		return -1

}

void function CleanupFXArray( array<FXHandle> fxHandleArray, bool doRemoveAllParticlesNow, bool doPlayEndCap )
{
	string stopType
	if ( doRemoveAllParticlesNow )
	{
		Assert( !doPlayEndCap )
		stopType = "destroyImmediately"
	}
	else if ( doPlayEndCap )
		stopType = "playEndcap"
	else
		stopType = "normal"

	foreach ( FXHandle fxHandle in fxHandleArray )
	{








			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, doRemoveAllParticlesNow, doPlayEndCap )

	}
	fxHandleArray.clear()
}


int function GetSkinIndexByName_Safe( entity ent, string skinName )
{
	if ( ent.GetSkinCount() == 0 )
	{
		
		Warning( "GetSkinIndexByName_Safe called on ent with bad model. Callstack:\n%s", GetStack() )
		return -1
	}
	return ent.GetSkinIndexByName( skinName )
}

void function SetSkinByName_Safe( entity ent, string skinName )
{
	if ( ent.GetSkinCount() == 0 )
	{
		
		Warning( "SetSkinByName_Safe called on ent with bad model. Callstack:\n%s", GetStack() )
		return
	}
	int skinIdx = ent.GetSkinIndexByName( skinName )
	if ( skinIdx == -1 )
	{
		Warning( "SetSkinByName_Safe called with bad skin name (\"%s\"). Callstack:\n%s", skinName, GetStack() )
		return
	}
	ent.SetSkin( skinIdx )
}

bool function CanScriptPlaceableBePlacedOn( entity hitEnt )
{
	

	if ( hitEnt.IsWorld() )
		return true

	var hitEntClassname = hitEnt.GetNetworkedClassName()

	if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" )
		return true

	return false
}

bool function ShouldScriptedPlaceableParentTo( entity hitEnt )
{
	var hitEntClassname = hitEnt.GetNetworkedClassName()

	if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" )
		return true

	return false
}

bool function IsInBleedoutOrRevive( entity player )
{
	if( !player.IsPlayer() )
		return false

	bool bleedingOut = Bleedout_IsBleedingOut( player )
	bool reviveRelated = player.ContextAction_IsBeingRevived() || player.ContextAction_IsReviving()

	return( bleedingOut || reviveRelated )
}

bool function PlayerIsLinkedToDeathbox( entity player, entity deathbox )
{
	array<entity> linkedEntArray = player.GetLinkEntArray()
	foreach ( entity linkedEnt in linkedEntArray )
	{
		if ( linkedEnt.GetNetworkedClassName() != "prop_death_box" )
			continue

		if ( linkedEnt == deathbox )
			return true
	}

	return false
}

bool function IsPrivateMatchSpectator( entity player )
{
	





	if ( IsPrivateMatch() && player.GetPersistentVarAsInt( "privateMatchState" ) == 1 )
		return true

	return false
}