global function OnWeaponAttemptOffhandSwitch_Consumable
global function OnWeaponActivate_Consumable
global function OnWeaponDeactivate_Consumable
global function OnWeaponRaise_Consumable
global function OnWeaponChargeBegin_Consumable
global function OnWeaponChargeEnd_Consumable
global function OnWeaponPrimaryAttack_Consumable
global function OnWeaponOwnerChanged_Consumable

global function Consumable_Init
global function Consumable_PredictConsumableUse
global function Consumable_IsValidConsumableInfo
global function Consumable_GetConsumableInfo
global function Consumable_CanUseConsumable
global function Consumable_CreatePotentialHealData
global function Consumable_CanUseUltAccel
global function Consumable_CalculateTotalHealFromItem
global function Consumable_CalculateTotalShieldFromItem

global function OnCreateChargeEffect_Consumable
global function OnCreateMuzzleFlashEffect_Consumable

global function Consumable_UseItemByType
global function Consumable_UseItemByRef
global function Consumable_UseCurrentSelectedItem
global function Consumable_GetBestConsumableTypeForPlayer
global function TryUpdateCurrentSelectedConsumableToBest
global function Consumable_GetLocalViewPlayerSelectedConsumableType
global function Consumable_SetSelectedConsumableType
global function Consumable_OnSelectedConsumableTypeNetIntChanged
global function Consumable_GetClientSelectedConsumableType
global function Consumable_CancelHeal
global function Consumable_IsCurrentSelectedConsumableTypeUseful

global function Consumable_SetClientTypeOnly

global function Consumable_DoUltAccelScreenFx
global function Consumable_DoHealScreenFx

global function ServerCallback_TryUseConsumable
global function ServerToClient_DoUltAccelScreenFx
global function ServerToClient_SetClientChargeTime


















global function Consumable_IsValidModCommand
global function Consumable_IsHealthItem
global function Consumable_IsShieldItem

global enum eConsumableType
{
	HEALTH_SMALL
	HEALTH_LARGE
	SHIELD_LARGE
	SHIELD_SMALL
	COMBO_FULL
	








	ULTIMATE




	_count
}

const float UNSET_CHARGE_TIME = -1
global struct ConsumableInfo
{
	LootData&           lootData
	float               chargeTime = UNSET_CHARGE_TIME
	string              cancelSoundName = ""
	int					healAmount
	int					shieldAmount
	float               ultimateAmount
	float               healTime
	table< int, float > healBonus = {
		[ePassives.PAS_SYRINGE_BONUS] = 0.0,
		[ePassives.PAS_HEALTH_BONUS_MED] = 0.0,
		[ePassives.PAS_HEALTH_BONUS_ALL] = 0.0,
		[ePassives.PAS_BONUS_SMALL_HEAL] = 25.0
	}
	table< int, float > shieldBonus = {
		[ePassives.PAS_BONUS_SMALL_HEAL] = 25.0
	}
	float               healCap = 100

	string modName
	float shieldCapacitorCooldown = 0
}

global struct PotentialHealData
{
	ConsumableInfo & consumableInfo
	int              kitType
	int              count
	int              overHeal
	int              overShield

	int possibleHealthAdd
	int possibleShieldAdd

	float healthPerSecond

	int totalOverheal
	int totalAppliedHeal
}

enum eUseConsumableResult
{
	ALLOW,
	DENY_NONE,
	DENY_ULT_FULL,
	DENY_ULT_NOTREADY,
	DENY_HEALTH_FULL,
	DENY_SHIELD_FULL,
	DENY_NO_HEALTH_KIT,
	DENY_NO_SHIELD_KIT,
	DENY_NO_PHOENIX_KIT,
	DENY_NO_KITS,
	DENY_NO_SHIELDS,
	DENY_FULL,
	DENY_DEATH_TOTEM,

	DENY_SHIELD_HEAL_DENIED




	DENY_
	COUNT,
}

enum eConsumableRecoveryType
{
	HEALTH,
	SHIELDS,
	COMBINED,
	ULTIMATE,
}

struct ConsumablePersistentData
{
	bool useFinished = false
	int  healAmount = 0
	int  healAmountRemaining = 0	
	int  healthKitResourceId = 0
	int  shieldStatusHandle = 0
	int  healthStatusHandle = 0
	int  lastMissingHealth = -1
	int  lastMissingShields = -1
	int  lastCurrentHealth = -1

	array<int> statusEffectHandles
}

struct
{
	table< string, int > modNameToConsumableType

	table< int, ConsumableInfo >              consumableTypeToInfo
	table< entity, array<int> >               playerHealResourceIds
	table< entity, ConsumablePersistentData > weaponPersistentData

	array< int > consumableUseOrder = []

	array< void functionref(entity, float) >         Callbacks_OnPlayerHealingStarted
	array< void functionref(entity, string, bool) > Callbacks_OnPlayerHealingEnded

	bool chargeTimesInitialized = false

	table< entity, float > playerToLastHealChatterTime
	table< entity, float > playerToLastShieldChatterTime





		string clientPlayerNextMod

		bool healCompletedSuccessfully
		int  clientSelectedConsumableType
		int  healScreenFxHandle
		int  ultAccelScreenFxHandle


} file

const bool DEBUG_PRINTS = false

global const int OFFHAND_SLOT_FOR_CONSUMABLES = OFFHAND_ANTIRODEO
global const string CONSUMABLE_WEAPON_NAME = "mp_ability_consumable"










const string SHOW_ULT_ACCEL_FX_PLAYLIST_VAR = "ult_accel_vfx_enable"

const float HEAL_CHATTER_DEBOUNCE = 10.0
const RESTORE_HEALTH_COCKPIT_FX = $"P_heal_loop_screen"
const asset VFX_ULT_ACCEL_POP = $"P_UltAcc_screenSpace"
global const vector HEALTH_RGB = < 114, 245, 250 >


const string WATTSON_EXTRA_ULT_ACCEL_SFX = "Wattson_Xtra_A"



void function Consumable_Init()
{
	RegisterWeaponForUse( CONSUMABLE_WEAPON_NAME )
	RegisterSignal( "ConsumableDestroyRui" )

	PrecacheParticleSystem( VFX_ULT_ACCEL_POP )

	Remote_RegisterServerFunction( "ClientCallback_SetSelectedConsumableTypeNetInt", "int", INT_MIN, INT_MAX )
	Remote_RegisterServerFunction( "ClientCallback_SetNextHealModType", "int", 0, eConsumableType._count - 1 )

	{
		
		ConsumableInfo phoenixKit
		{
			phoenixKit.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_combo_full" )
			phoenixKit.healAmount = 100
			phoenixKit.shieldAmount = 999
			phoenixKit.cancelSoundName = "shield_battery_failure"
			phoenixKit.modName = "phoenix_kit"
		}
		file.consumableTypeToInfo[ eConsumableType.COMBO_FULL ] <- phoenixKit
	}

	{
		
		ConsumableInfo shieldLarge
		{
			shieldLarge.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_combo_large" )
			shieldLarge.healAmount = 0
			shieldLarge.shieldAmount = 999
			shieldLarge.healCap = 0.0
			shieldLarge.cancelSoundName = "shield_battery_failure"
			shieldLarge.modName = "shield_large"
		}
		file.consumableTypeToInfo[ eConsumableType.SHIELD_LARGE ] <- shieldLarge
	}














































	{
		
		ConsumableInfo shieldSmall
		{
			shieldSmall.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_combo_small" )
			shieldSmall.healAmount = 0
			shieldSmall.shieldAmount = 25
			shieldSmall.healCap = 0.0
			shieldSmall.cancelSoundName = "shield_battery_failure"
			shieldSmall.modName = "shield_small"
		}
		file.consumableTypeToInfo[ eConsumableType.SHIELD_SMALL ] <- shieldSmall
	}

	{
		
		ConsumableInfo healthLarge
		{
			healthLarge.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_health_large" )
			healthLarge.healAmount = 100
			healthLarge.shieldAmount = 0
			healthLarge.cancelSoundName = "Health_Syringe_Failure"
			healthLarge.modName = "health_large"
		}
		file.consumableTypeToInfo[ eConsumableType.HEALTH_LARGE ] <- healthLarge
	}

	{
		
		ConsumableInfo healthSmall
		{
			healthSmall.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_health_small" )
			healthSmall.healAmount = 25
			healthSmall.shieldAmount = 0
			healthSmall.cancelSoundName = "Health_Syringe_Failure"
			healthSmall.modName = "health_small"
		}
		file.consumableTypeToInfo[ eConsumableType.HEALTH_SMALL ] <- healthSmall
	}
















	{
		
		ConsumableInfo ultimateBattery
		{
			ultimateBattery.ultimateAmount = 35.0
			ultimateBattery.healAmount = 0
			ultimateBattery.healTime = 0.0
			ultimateBattery.lootData = SURVIVAL_Loot_GetLootDataByRef( "health_pickup_ultimate" )
			ultimateBattery.cancelSoundName = ""
			ultimateBattery.modName = "ultimate_battery"
		}
		file.consumableTypeToInfo[ eConsumableType.ULTIMATE ] <- ultimateBattery
	}















	file.modNameToConsumableType[ "health_small" ] <-        eConsumableType.HEALTH_SMALL
	file.modNameToConsumableType[ "health_large" ] <-        eConsumableType.HEALTH_LARGE
	file.modNameToConsumableType[ "shield_small" ] <-        eConsumableType.SHIELD_SMALL
	file.modNameToConsumableType[ "shield_large" ] <-        eConsumableType.SHIELD_LARGE





	file.modNameToConsumableType[ "phoenix_kit" ] <-        eConsumableType.COMBO_FULL
	file.modNameToConsumableType[ "ultimate_battery" ] <-    eConsumableType.ULTIMATE

	file.modNameToConsumableType[ "ultimate_battery_fast" ] <-    eConsumableType.ULTIMATE








	file.consumableUseOrder.append( eConsumableType.SHIELD_LARGE )





	file.consumableUseOrder.append( eConsumableType.SHIELD_SMALL )
	file.consumableUseOrder.append( eConsumableType.COMBO_FULL )
	file.consumableUseOrder.append( eConsumableType.HEALTH_LARGE )
	file.consumableUseOrder.append( eConsumableType.HEALTH_SMALL )







		AddCallback_OnPlayerConsumableInventoryChanged( SwitchSelectedConsumableIfEmptyAndPushClientSelectionToServer ) 

		SetCallback_UseConsumable( Consumable_HandleConsumableUseCommand )
		AddCallback_GameStateEnter( eGameState.Resolution, Consumable_OnGamestateEnterResolution )



		AddCallback_OnPassiveChanged( ePassives.PAS_ULT_ACCEL_CHARGE, UpgradedUltAccel_PassiveToggle ) 

}












bool function ShouldHaveFastUltAccel( entity player )
{
	bool shouldHaveFastUltAccel = false

	shouldHaveFastUltAccel = shouldHaveFastUltAccel || PlayerHasPassive( player, ePassives.PAS_ULT_ACCEL_CHARGE)


	return shouldHaveFastUltAccel
}

void function UpgradedUltAccel_PassiveToggle( entity player, int pas, bool didHave, bool nowHas )
{

		if ( !InPrediction() )
			return


	bool shouldToggleFastUltAccel = false

	shouldToggleFastUltAccel = shouldToggleFastUltAccel || pas == ePassives.PAS_ULT_ACCEL_CHARGE


	if ( shouldToggleFastUltAccel )
	{
		if ( nowHas )
		{
			entity weapon = player.GetOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
			if( IsValid( weapon ) )
			{
				if( weapon.HasMod( "ultimate_battery" ) )
				{
					weapon.RemoveMod( "ultimate_battery" )
					weapon.AddMod( "ultimate_battery_fast" )
				}
			}

		}
		if ( didHave )
		{
			entity weapon = player.GetOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
			if( IsValid( weapon ) )
			{
				if ( weapon.HasMod( "ultimate_battery_fast" ) )
				{
					weapon.RemoveMod( "ultimate_battery_fast" )
					weapon.AddMod( "ultimate_battery" )
				}
			}
		}
	}
}















void function TryAddWeaponPersistenceData( entity weapon )
{
	if (!( weapon in file.weaponPersistentData ))
	{
		ConsumablePersistentData data
		file.weaponPersistentData[ weapon ] <- data
	}
}

void function OnWeaponOwnerChanged_Consumable( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( changeParams.oldOwner ) )
	{

		if ( weaponOwner == GetLocalViewPlayer() )

		{
			TryAddWeaponPersistenceData( weapon )
		}
	}

	file.playerToLastHealChatterTime[ weaponOwner ] <- Time()
	file.playerToLastShieldChatterTime[ weaponOwner ] <- Time()

	if ( file.chargeTimesInitialized )
		return

	foreach ( string modName, int consumableType in file.modNameToConsumableType )
	{
		ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]
		if ( info.chargeTime == UNSET_CHARGE_TIME )
		{








				if ( weapon.GetOwner() != GetLocalClientPlayer() || !InPrediction() )
					return

				weapon.SetMods( [ modName ] )
				printt( format( "[CONSUMABlE-%s] OnWeaponOwnerChanged_Consumable: Add mod (%s)", weaponOwner.GetPlayerName(), modName ) )
				info.chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

		}
	}

	file.chargeTimesInitialized = true




		if( InPrediction()  )
			weapon.SetMods( [] )


	printt( format( "[CONSUMABlE-%s] OnWeaponOwnerChanged_Consumable: Remove mods", weaponOwner.GetPlayerName() ) )
}


bool function OnWeaponAttemptOffhandSwitch_Consumable( entity weapon )
{
	string nextMod










		nextMod = file.clientPlayerNextMod


	if ( !CanSwitchToWeapon( weapon, nextMod ) )
	{
		printt( format( "[CONSUMABlE-%s] Offhand switch NOT allowed for nextMod (%s)", weapon.GetOwner().GetPlayerName(), nextMod ) )
		return false
	}


	printt( format( "[CONSUMABlE-%s] Offhand switch allowed for nextMod (%s)", weapon.GetOwner().GetPlayerName(), nextMod ) )
	return true
}




















void function ApplyStickers( entity weapon )
{
	entity weaponOwner = weapon.GetOwner()
	string modName = GetConsumableModOnWeapon( weapon )

	entity weaponVm = weapon.GetWeaponViewmodel()
	if ( weaponVm )
	{
		DestroyAllStickersOnEntity( weaponVm )

		int stickerObjectType = GetStickerObjectType( modName )
		if ( stickerObjectType != -1 )
		{
			EHI weaponOwnerEHI = ToEHI( weaponOwner )
			int maxStickersForObjectType = GetMaxStickersForObjectType( stickerObjectType )

			for ( int stickerSlot = 0; stickerSlot < maxStickersForObjectType; ++stickerSlot )
			{
				SettingsAssetGUID stickerLoadoutSlotGuid = weaponOwner.GetStickerSlot( stickerObjectType * maxStickersForObjectType + stickerSlot )
				ItemFlavor ornull stickerItemOrNull = GetItemFlavorOrNullByGUID( stickerLoadoutSlotGuid )

				if (stickerItemOrNull == null)
					continue

				ItemFlavor stickerItem = expect ItemFlavor( stickerItemOrNull )

				if ( !Sticker_IsTheEmpty( stickerItem ) )
				{
					float scale = Sticker_GetDecalScale( stickerItem, stickerObjectType, stickerSlot + 1 )
					Sticker_PlaceDecalForLocalPlayer( weaponVm, Sticker_GetDecalMaterialAsset( stickerItem ), "STICKER_" + ( stickerSlot + 1 ), scale )
				}
			}
		}
	}
}


void function OnWeaponActivate_Consumable( entity weapon )
{
	entity weaponOwner = weapon.GetOwner()
	string modName

	TryAddWeaponPersistenceData( weapon )























		
		
		if ( weapon.GetOwner() != GetLocalClientPlayer() && GetLocalViewPlayer() == weapon.GetOwner() )		
		{
			ApplyStickers( weapon )
		}



		if ( weapon.GetOwner() != GetLocalViewPlayer() && !IsSpectatorSpectatingPlayer( weapon.GetOwner() ) )
			return


		if( file.clientPlayerNextMod == "ultimate_battery" )
		{
			if( ShouldHaveFastUltAccel( weapon.GetOwner() ) )
				file.clientPlayerNextMod = "ultimate_battery_fast"
		}

		modName = file.clientPlayerNextMod
		printt( format( "[CONSUMABlE] Activating consumable (%s)", modName ) )

		if ( IsSpectator( GetLocalClientPlayer() ) )
		{
			modName = GetConsumableModOnWeapon( weapon )
			Assert( modName != "", "No consumable mod on weapon for pure spectator" )
		}

		
		if ( modName == "" )
			return

		file.healCompletedSuccessfully = false




	if ( InPrediction() && weapon.IsPredicted())

	{
		if ( modName == "phoenix_kit" )
			weapon.SetWeaponSkin( 1 )
		else
			weapon.SetWeaponSkin( 0 )

		weapon.SetScriptTime0( Time() ) 
		weapon.SetMods( [ modName ] )
		printt( format( "[CONSUMABlE-%s] OnWeaponActivate_Consumable: Add mod (%s)", weaponOwner.GetPlayerName(), modName ) )
	}


	ApplyStickers( weapon )


	ConsumablePersistentData useData

	if ( IsSpectatorSpectatingPlayer( weapon.GetOwner() ) && (weapon in file.weaponPersistentData) )

	{
		useData = file.weaponPersistentData[ weapon ]
		ResetConsumableData( useData )
	}

	if ( GetCurrentPlaylistVarBool( "survival_healthkits_limit_movement", true ) )
	{

		if ( InPrediction() )

		{












				if( modName == "ultimate_battery")

				{
					useData.statusEffectHandles.append( StatusEffect_AddEndless( weaponOwner, eStatusEffect.move_slow, .06 ) )
				}
				else
				{
					useData.statusEffectHandles.append( StatusEffect_AddEndless( weaponOwner, eStatusEffect.move_slow, GetCurrentPlaylistVarFloat( "survival_healthkits_move_speed_reduction", 0.4 ) ) )
				}



			useData.statusEffectHandles.append( StatusEffect_AddEndless( weaponOwner, eStatusEffect.disable_wall_run, 1.0 ) )
			useData.statusEffectHandles.append( StatusEffect_AddEndless( weaponOwner, eStatusEffect.disable_double_jump, 1.0 ) )
		}
	}

	int consumableType  = file.modNameToConsumableType[ modName ]
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]




















		if ( SURVIVAL_CountItemsInInventory( weapon.GetOwner(), info.lootData.ref ) <= 0 )
		{
			printt( format( "[CONSUMABlE] Cancelling activation since we don't have required item (%s)", info.lootData.ref	) )
			Consumable_CancelHeal( weapon.GetOwner() )
		}

		Chroma_ConsumableBegin( weapon, info )








	if ( file.consumableTypeToInfo[ consumableType ].healAmount > 0 )
	{
		if ( (weaponOwner in file.playerToLastHealChatterTime) && Time() - file.playerToLastHealChatterTime[ weaponOwner ] > HEAL_CHATTER_DEBOUNCE )
		{

			if ( !IsSpectatorSpectatingPlayer( weaponOwner ) )

			{
				file.playerToLastHealChatterTime[ weaponOwner ] <- Time()
				if(modName == "phoenix_kit")
				{
					PlayBattleChatterToSelfOnClientAndTeamOnServer( weaponOwner, "bc_healingPhoenix" )
				}
				else
				{
					PlayBattleChatterToSelfOnClientAndTeamOnServer( weaponOwner, "bc_healing" )
				}
			}
		}
	}
	else if ( file.consumableTypeToInfo[ consumableType ].shieldAmount > 0 )
	{
		if ( (weaponOwner in file.playerToLastHealChatterTime) && Time() - file.playerToLastShieldChatterTime[ weaponOwner ] > HEAL_CHATTER_DEBOUNCE )
		{

			if ( !IsSpectatorSpectatingPlayer( weaponOwner ) )

			{
				file.playerToLastShieldChatterTime[ weaponOwner ] <- Time()
				PlayBattleChatterToSelfOnClientAndTeamOnServer( weaponOwner, "bc_usingShieldCell" )
			}
		}
	}

	int consumableRecoveryType = Consumable_GetConsumableRecoveryType( consumableType )


	if ( InPrediction() )

	{
		weapon.SetScriptInt0( consumableRecoveryType )
		printt( format( "[CONSUMABlE-%s] Done activating, setting consumable int to %d", weaponOwner.GetPlayerName(), consumableRecoveryType ) )
	}





















		thread Consumable_DisplayProgressBar( weaponOwner, weapon, consumableRecoveryType )

}


void function OnWeaponDeactivate_Consumable( entity weapon )
{
	entity weaponOwner = weapon.GetOwner()

	
	if ( !IsValid( weaponOwner ) )
		return

	ConsumablePersistentData useData






































































		if ( IsValid( weaponOwner ) && weaponOwner != GetLocalViewPlayer() )
			return

		Signal( weaponOwner, "ConsumableDestroyRui" )
		Chroma_ConsumableEnd()

		printt( format( "[CONSUMABLE] OnWeaponDeactivate, file struct's nextMod is (%s)", file.clientPlayerNextMod ) )

		if ( !InPrediction() )
			return

		useData = file.weaponPersistentData[ weapon ]

		string currentMod = GetConsumableModOnWeapon( weapon )
		if ( currentMod != "" )
		{
			int consumableType  = file.modNameToConsumableType[ currentMod ]
			ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]

			if ( !file.healCompletedSuccessfully && info.cancelSoundName != "" && DoesAliasExist( info.cancelSoundName ) )
			{
				EmitSoundOnEntity( weaponOwner, info.cancelSoundName )
			}
		}


	if ( IsValid( weaponOwner ) )
	{
		foreach ( effectHandle in useData.statusEffectHandles )
			StatusEffect_Stop( weaponOwner, effectHandle )
	}


	entity weaponVm = weapon.GetWeaponViewmodel()
	if ( IsValid( weaponVm ) && GetLocalViewPlayer() == weapon.GetOwner() )
	{
		thread function() : ( weaponVm, weapon )
		{
			
			while( IsValid( weapon ) && IsValid( weaponVm ) && GetLocalViewPlayer() == weapon.GetOwner() && weapon.GetOwner().GetActiveWeapon( eActiveInventorySlot.mainHand  ) == weapon )
			{
				WaitFrame()
			}

			printt( "[CONSUMABLE] Removing stickers" )

			
			if ( IsValid( weaponVm ) )
				DestroyAllStickersOnEntity( weaponVm )
		}()
	}

}


void function OnWeaponRaise_Consumable( entity weapon )
{
	string modName
	entity weaponOwner = weapon.GetOwner()






		Assert( weaponOwner == GetLocalClientPlayer() )
		Assert( InPrediction() )

		if ( !IsFirstTimePredicted() )
			return

		modName = file.clientPlayerNextMod


	printt( format( "[CONSUMABLE-%s] OnWeaponRaise for mod (%s)", weaponOwner.GetPlayerName(), modName ) )

	int consumableType = file.modNameToConsumableType[ modName ]

	if ( modName == "phoenix_kit" )
		weapon.SetWeaponSkin( 1 )
	else
		weapon.SetWeaponSkin( 0 )

	weapon.SetMods( [ modName ] )
	printt( format( "[CONSUMABlE-%s] OnWeaponRaise_Consumable: Add mod (%s)", weaponOwner.GetPlayerName(), modName ) )

	if ( file.consumableTypeToInfo[ consumableType ].ultimateAmount > 0 )
	{
		if ( ShouldPlayUltimateSuperchargedFX( weaponOwner ) )
			weapon.AddMod( "ultimate_battery_supercharged_fx" )
	}
}



void function Consumable_DisplayProgressBar( entity player, entity weapon, int consumableRecoveryType )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnChargeEnd" )
	player.EndSignal( "ConsumableDestroyRui" )

	string consumableName = weapon.GetWeaponSettingString( eWeaponVar.printname )
	asset hudIcon         = weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon )
	float raiseTime       = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )
	float chargeTime      = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

	var rui = CreateFullscreenRui( $"ui/consumable_progress.rpak" )

	RuiSetGameTime( rui, "healStartTime", Time() )
	RuiSetString( rui, "consumableName", consumableName )
	RuiSetFloat( rui, "raiseTime", raiseTime )
	RuiSetFloat( rui, "chargeTime", chargeTime )
	RuiSetImage( rui, "hudIcon", hudIcon )
	RuiSetInt( rui, "consumableType", consumableRecoveryType )

	OnThreadEnd(
		function() : ( rui, player )
		{
			RuiDestroy( rui )
		}
	)

	
	float startTime = Time()
	float endTime = startTime + raiseTime + chargeTime
	while ( Time() < endTime )
	{
		
		if ( IsPlayerInCryptoDroneCameraView( player ) )
		{
			RuiSetString( rui, "hintController", "" )
			RuiSetString( rui, "hintKeyboardMouse", "" )
		}
		else
		{
			RuiSetString( rui, "hintController", "#SURVIVAL_CANCEL_HEAL_GAMEPAD" )
			RuiSetString( rui, "hintKeyboardMouse", "#SURVIVAL_CANCEL_HEAL_PC" )
		}
		

		if( chargeTime != weapon.GetWeaponSettingFloat( eWeaponVar.charge_time ) )
		{
			
			raiseTime = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )
			chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
			endTime = startTime + raiseTime + chargeTime

			
			RuiSetFloat( rui, "raiseTime", raiseTime )
			RuiSetFloat( rui, "chargeTime", chargeTime )
		}

		RuiSetBool( rui, "isBoosted", PlayerHasPassive( player, ePassives.PAS_FAST_HEAL ) )


		wait 0.1
	}
}


void function OnCreateMuzzleFlashEffect_Consumable( entity weapon, int fxHandle )
{
	if ( !IsValid( weapon.GetOwner() ) )
		return

	string modName = GetConsumableModOnWeapon( weapon )

	if ( modName == "health_small" )
		return

	if ( modName == "health_large" )
		return

	int armorTier   = EquipmentSlot_GetEquipmentTier( weapon.GetOwner(), "armor" )
	vector colorVec = GetFXRarityColorForTier( armorTier )

	EffectSetControlPointVector( fxHandle, 2, colorVec )
}

void function OnCreateChargeEffect_Consumable( entity weapon, int fxHandle )
{
	
	if ( !IsValid( weapon.GetOwner() ) )
		return

	string modName = GetConsumableModOnWeapon( weapon )

	if ( modName == "health_small" )
		return

	if ( modName == "health_large" )
		return

	int armorTier   = EquipmentSlot_GetEquipmentTier( weapon.GetOwner(), "armor" )
	vector colorVec = GetFXRarityColorForTier( armorTier )

	if ( armorTier == 0 || weapon.GetOwner().GetShieldHealth() >= weapon.GetOwner().GetShieldHealthMax() )
		colorVec = HEALTH_RGB

	weapon.kv.renderColor = colorVec
	EffectSetControlPointVector( fxHandle, 2, colorVec )
}



bool function OnWeaponChargeBegin_Consumable( entity weapon )
{
	string currentMod = GetConsumableModOnWeapon( weapon )
	if( currentMod == "" )
	{
		foreach ( string mod in weapon.GetMods() )
		{
			printt( format( "[CONSUMABLE] OnWeaponChargeBegin: No consumable mods on weapon, print current weapon mods: %s", mod ) )
		}
	}

	Assert( currentMod != "", "[CONSUMABlE] No consumable mods on weapon" )
	if ( currentMod == "" )
		return false

	entity player = weapon.GetOwner()

	if ( IsValid( player ) )
		printt( format( "[CONSUMABLE-%s] OnWeaponChargeBegin (%s)", player.GetPlayerName(), currentMod ) )

	Assert( currentMod in file.modNameToConsumableType, "Invalid mod on consumable weapon: " + currentMod )
	if ( !(currentMod in file.modNameToConsumableType) )
		return false

	int consumableType  = file.modNameToConsumableType[ currentMod ]
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]

	string itemName = info.lootData.ref

	weapon.SetWeaponChargeFractionForced( 0.0 )

	TryAddWeaponPersistenceData( weapon )








		if ( player != GetLocalViewPlayer() || !(InPrediction() && IsFirstTimePredicted()) )
			return true

		if ( ShouldPlayUltimateSuperchargedFX( player ) && DoesAliasExist( WATTSON_EXTRA_ULT_ACCEL_SFX ) )
		{
			EmitSoundOnEntity( player, WATTSON_EXTRA_ULT_ACCEL_SFX )
		}










		if ( SURVIVAL_CountItemsInInventory( weapon.GetOwner(), info.lootData.ref ) <= 0 )
		{
			printt( format( "[CONSUMABlE] Cancelling charge since we don't have required item (%s)", info.lootData.ref	) )
			Consumable_CancelHeal( weapon.GetOwner() )
		}


	return true

}


void function OnWeaponChargeEnd_Consumable( entity weapon )
{
	string currentMod = GetConsumableModOnWeapon( weapon )
	if( currentMod == "" )
	{
		foreach ( string mod in weapon.GetMods() )
		{
			printt( format( "[CONSUMABLE] OnWeaponChargeBegin: No consumable mods on weapon, print current weapon mods: %s", mod ) )
		}
	}

	Assert( currentMod != "", "[CONSUMABlE] No consumable mod on weapon" )
	entity player = weapon.GetOwner()

	if ( IsValid( player ) )
		printt( format( "[CONSUMABLE-%s] OnWeaponChargeEnd (%s)", player.GetPlayerName(), currentMod ) )

	float chargeFracAtEnd = weapon.GetWeaponChargeFraction()
	if ( chargeFracAtEnd < 1.0 )
	{
		Signal( player, "OnChargeEnd" )
	}


	if ( player != GetLocalViewPlayer() )
		return

	if ( currentMod != "" ) 
	{
		if ( ShouldPlayUltimateSuperchargedFX( player ) )
		{
			StopSoundOnEntity( player, WATTSON_EXTRA_ULT_ACCEL_SFX )
		}
	}














}


var function OnWeaponPrimaryAttack_Consumable( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetOwner()

	if ( weapon.GetWeaponChargeFraction() < 1.0 )
		return 0

	string currentMod = GetConsumableModOnWeapon( weapon )

	if ( IsValid( player ) )
		printt( format( "[CONSUMABlE-%s] OnWeaponPrimaryAttack (%s)", player.GetPlayerName(), currentMod ) )

	if ( currentMod == "" )
		return 0

	int consumableType  = file.modNameToConsumableType[ currentMod ]
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]










	if ( SURVIVAL_CountItemsInInventory( weapon.GetOwner(), info.lootData.ref ) <= 0 )
	{
		return 1
	}
































		if ( player != GetLocalViewPlayer() )
			return

		file.healCompletedSuccessfully = true

		if ( !IsFirstTimePredicted() )
			return

		bool playerAtFullHealthAndShields = (player.GetHealth() + info.healAmount) >= player.GetMaxHealth() && (player.GetShieldHealth() + info.shieldAmount) >= player.GetShieldHealthMax()



		if ( !playerAtFullHealthAndShields && !IsConsumableTypeUsefulToPlayer( player, file.clientSelectedConsumableType, info.healAmount, info.shieldAmount ) )

		{
			TryUpdateCurrentSelectedConsumableToBest( player, info.healAmount, info.shieldAmount )
		}

		if ( info.healAmount > 0 && (info.shieldAmount == 0 || (player.GetShieldHealth() >= player.GetShieldHealthMax())) )
		{
			Consumable_DoHealScreenFx( player )
		}
		else if ( info.ultimateAmount > 0 )
		{
			Consumable_DoUltAccelScreenFx( player )
		}

		Chroma_ConsumableSucceeded( info )


	return 1
}


float function Consumable_CalculateTotalHealFromItem( entity player, ConsumableInfo info )
{
	if ( PlayerHasPassive( player, ePassives.PAS_SYRINGE_BONUS ) )
		return info.healAmount + info.healBonus[ ePassives.PAS_SYRINGE_BONUS ]

	if ( PlayerHasPassive( player, ePassives.PAS_HEALTH_BONUS_MED ) )
		return info.healAmount + info.healBonus[ ePassives.PAS_HEALTH_BONUS_MED ]

	if ( PlayerHasPassive( player, ePassives.PAS_HEALTH_BONUS_ALL ) )
		return info.healAmount + info.healBonus[ ePassives.PAS_HEALTH_BONUS_ALL ]

	if ( PlayerHasPassive( player, ePassives.PAS_BONUS_SMALL_HEAL ) && info.lootData.ref == "health_pickup_health_small" )
		return info.healAmount + info.healBonus[ ePassives.PAS_BONUS_SMALL_HEAL ]

	return float( info.healAmount )
}


float function Consumable_CalculateTotalShieldFromItem( entity player, ConsumableInfo info )
{
	if ( PlayerHasPassive( player, ePassives.PAS_BONUS_SMALL_HEAL ) && info.lootData.ref == "health_pickup_combo_small" )
		return info.shieldAmount + info.shieldBonus[ ePassives.PAS_BONUS_SMALL_HEAL ]

	return float( info.shieldAmount )
}

ConsumableInfo function GetConsumableInfoFromRef( string ref )
{
	foreach ( int consumableType, ConsumableInfo info in file.consumableTypeToInfo )
	{
		if ( info.lootData.ref == ref )
			return info
	}

	Assert( false, "Unknown ref \"" + ref + "\" used in mp_ability_consumable." )
	unreachable
}













void function Consumable_SetClientTypeOnly()
{
	file.clientSelectedConsumableType = eConsumableType.COMBO_FULL
}

void function Consumable_UseCurrentSelectedItem( entity player )
{
	int selectedPickupType = file.clientSelectedConsumableType
	if ( !Consumable_CanUseConsumable( player, selectedPickupType ) )
	{
		return
		
		
		
	}

	ConsumableInfo info = file.consumableTypeToInfo[ selectedPickupType ]

	thread AddModAndFireWeapon_Thread( player, info.modName )
}

void function Consumable_UseItemByRef( entity player, string itemName )
{
	ConsumableInfo info = GetConsumableInfoFromRef( itemName )

	thread AddModAndFireWeapon_Thread( player, info.modName )
}

void function Consumable_UseItemByType( entity player, int consumableType )
{
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]

	thread AddModAndFireWeapon_Thread( player, info.modName )
}

void function ServerCallback_TryUseConsumable( entity player, int consumableType )
{
	if ( !( consumableType in file.consumableTypeToInfo ) )
		return

	Consumable_UseItemByType( player, consumableType )
}

void function Consumable_HandleConsumableUseCommand( entity player, string consumableCommand )
{
	int consumableType = eConsumableType._count

	if ( consumableCommand == "HEALTH_SMALL" )
		consumableType = eConsumableType.HEALTH_SMALL
	if ( consumableCommand == "HEALTH_LARGE" )
		consumableType = eConsumableType.HEALTH_LARGE
	if ( consumableCommand == "SHIELD_SMALL" )
		consumableType = eConsumableType.SHIELD_SMALL
	if ( consumableCommand == "SHIELD_LARGE" )
		consumableType = eConsumableType.SHIELD_LARGE








	if ( consumableCommand == "PHOENIX_KIT" )
		consumableType = eConsumableType.COMBO_FULL

	if ( consumableType == eConsumableType._count )
		return

	Consumable_UseItemByType( player, consumableType )
}

void function AddModAndFireWeapon_Thread( entity player, string modName )
{
	if ( !( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() ) )
		return

	if ( player.IsBot() )
		return

	int consumableType  = file.modNameToConsumableType[ modName ]
	if ( !Consumable_CanUseConsumable( player, consumableType, true ) )
	{
		printt( format( "[CONSUMABLE] Not allowed to use consumable (%s), not activating offhand weapon", modName ) )
		return
	}

	entity selectedWeapon = player.GetSelectedWeapon( eActiveInventorySlot.mainHand )
	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( IsValid( selectedWeapon ) && selectedWeapon.GetWeaponClassName() == CONSUMABLE_WEAPON_NAME
			|| IsValid( activeWeapon ) && activeWeapon.GetWeaponClassName() == CONSUMABLE_WEAPON_NAME)
	{
		printt( format( "[CONSUMABLE] Already using consumable, not activating offhand weapon", modName ) )
		return
	}

	if ( !IsWatchingReplay() )
	{
		if ( CharacterSelect_MenuIsOpen() )
			CloseCharacterSelectMenu()

		RunUIScript( "CloseAllMenus" )
	}

	printt( format( "[CONSUMABLE] Activating offhand weapon, mod is %s", modName ) )
	file.clientPlayerNextMod = modName

	if( modName in file.modNameToConsumableType )
		Remote_ServerCallFunction( "ClientCallback_SetNextHealModType", file.modNameToConsumableType[ modName ] )

	ActivateOffhandWeaponByIndex( OFFHAND_SLOT_FOR_CONSUMABLES )
}

int function Consumable_GetLocalViewPlayerSelectedConsumableType()
{
	return GetSelectedConsumableTypeForPlayer( GetLocalViewPlayer() )
}

int function GetSelectedConsumableTypeForPlayer( entity player )
{
	if ( !IsValid( player ) )
		return eConsumableType.HEALTH_SMALL

	return player.GetPlayerNetInt( "selectedHealthPickupType" )
}

void function Consumable_SetSelectedConsumableType( int type )
{
	Remote_ServerCallFunction( "ClientCallback_SetSelectedConsumableTypeNetInt", type )
	file.clientSelectedConsumableType = type
}

void function Consumable_OnSelectedConsumableTypeNetIntChanged( entity player, int kitType )
{
	if ( player != GetLocalClientPlayer() )
		return

	file.clientSelectedConsumableType = kitType
}

int function Consumable_GetClientSelectedConsumableType( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return -1

	return file.clientSelectedConsumableType
}

void function SwitchSelectedConsumableIfEmptyAndPushClientSelectionToServer( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	ConsumableInfo kitInfo = Consumable_GetConsumableInfo( file.clientSelectedConsumableType )

	if ( SURVIVAL_CountItemsInInventory( player, kitInfo.lootData.ref ) == 0 )
	{
		file.clientSelectedConsumableType = Consumable_GetBestConsumableTypeForPlayer( player, 0, 0 )
	}

	Consumable_SetSelectedConsumableType( file.clientSelectedConsumableType )
}

void function TryUpdateCurrentSelectedConsumableToBest( entity player, int addedHealth, int addedShields )
{
	int healthPickupType = file.clientSelectedConsumableType

	if ( healthPickupType == -1 )
		return

	ConsumableInfo kitInfo = Consumable_GetConsumableInfo( healthPickupType )

	if ( SURVIVAL_CountItemsInInventory( player, kitInfo.lootData.ref ) > 0 )
	{
		
		if ( kitInfo.healAmount > 0 && ((player.GetHealth() + addedHealth) < player.GetMaxHealth()) )
			return

		
		if ( kitInfo.shieldAmount > 0 && player.GetShieldHealthMax() > 0 && ((player.GetShieldHealth() + addedShields) < player.GetShieldHealthMax()) )
			return
	}

	healthPickupType = Consumable_GetBestConsumableTypeForPlayer( player, addedHealth, addedShields )

	Consumable_SetSelectedConsumableType( healthPickupType )
}

int function Consumable_GetBestConsumableTypeForPlayer( entity player, int addedHealth, int addedShields )
{
	array< PotentialHealData > healthDataArray
	foreach ( int consumableType in file.consumableUseOrder )
	{
		PotentialHealData healData = Consumable_CreatePotentialHealData( player, consumableType, addedHealth, addedShields )
		healthDataArray.append( healData )
	}

	healthDataArray.sort( CompareHealData )

#if DEBUG_PRINTS
		foreach ( PotentialHealData healData in healthDataArray )
			printt( "Consumable_GetBestConsumableTypeForPlayer", Localize( healData.consumableInfo.lootData.pickupString ), healData.totalAppliedHeal, healData.healthPerSecond )
#endif

	foreach ( PotentialHealData healData in healthDataArray )
	{
		if ( healData.count > 0 && IsConsumableTypeUsefulToPlayer( player, healData.kitType, addedHealth, addedShields ) )
		{
			return healData.kitType
		}
	}

	
	return GetSelectedConsumableTypeForPlayer( player )
}

bool function Consumable_IsCurrentSelectedConsumableTypeUseful()
{
	entity player = GetLocalClientPlayer()

	return IsConsumableTypeUsefulToPlayer( player, file.clientSelectedConsumableType, 0, 0 )
}

bool function IsConsumableTypeUsefulToPlayer( entity player, int consumableType, int addedHealth, int addedShields )
{
	if ( !IsValid( player ) || !IsAlive( player ) )
		return false

	if ( ! (consumableType in file.consumableTypeToInfo) )
		return false

	if ( SURVIVAL_CountItemsInInventory( player, file.consumableTypeToInfo[ GetSelectedConsumableTypeForPlayer( player ) ].lootData.ref ) == 0 )
		return true

	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]

	return (info.shieldAmount > 0 && ((player.GetShieldHealth() + addedShields) < player.GetShieldHealthMax())) || (info.healAmount > 0 && ((player.GetHealth() + addedHealth) < player.GetMaxHealth()))
}

void function Consumable_DoHealScreenFx( entity player )
{
	thread DoHealScreenFx( player )
}

void function DoHealScreenFx( entity player )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	if ( EffectDoesExist( file.healScreenFxHandle ) )
		return

	int fxID = GetParticleSystemIndex( RESTORE_HEALTH_COCKPIT_FX )
	file.healScreenFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( file.healScreenFxHandle, true )

	OnThreadEnd( function() {
		if ( EffectDoesExist( file.healScreenFxHandle ) )
			EffectStop( file.healScreenFxHandle, false, true )
	} )

	WaitFrame()
}

void function Consumable_DoUltAccelScreenFx( entity player )
{
	if ( GetCurrentPlaylistVarBool( SHOW_ULT_ACCEL_FX_PLAYLIST_VAR, true ) )
	{
		thread DoUltAccelScreenFx( player )
	}
}

void function DoUltAccelScreenFx( entity player )
{
	EndSignal( player, "OnDeath", "OnDestroy" )

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	if ( EffectDoesExist( file.ultAccelScreenFxHandle ) )
		return

	int fxID = GetParticleSystemIndex( VFX_ULT_ACCEL_POP )
	file.ultAccelScreenFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( file.ultAccelScreenFxHandle, true )
	EffectSetControlPointVector( file.ultAccelScreenFxHandle, 1, <255, 208, 56> )

	OnThreadEnd( function() {
		if ( EffectDoesExist( file.ultAccelScreenFxHandle ) )
			EffectStop( file.ultAccelScreenFxHandle, false, true )
	} )

	wait 2
}

void function PlayConsumableUseChroma( entity weapon, ConsumableInfo info )
{
	EndSignal( weapon.GetOwner(), "EndChroma" )

	float raiseTime  = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

	Chroma_ConsumableBegin( weapon, info )

	OnThreadEnd(
		function() : ()
		{
			Chroma_ConsumableEnd()
		}
	)

	wait raiseTime + chargeTime
}

void function Consumable_CancelHeal( entity player )
{
	if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName() != CONSUMABLE_WEAPON_NAME )
		return

	player.ClientCommand( "invnext" )
}

bool function PlayerHasHealthKits( entity player )
{
	foreach ( int type, ConsumableInfo info in file.consumableTypeToInfo )
	{
		if ( info.healAmount > 0 )
		{
			if ( SURVIVAL_CountItemsInInventory( player, info.lootData.ref ) > 0 )
			{
				return true
			}
		}
	}

	return false
}

bool function PlayerHasShieldKits( entity player )
{
	foreach ( int type, ConsumableInfo info in file.consumableTypeToInfo )
	{
		if ( info.shieldAmount > 0 )
		{








			if ( SURVIVAL_CountItemsInInventory( player, info.lootData.ref ) > 0 )
			{
				return true
			}
		}
	}

	return false
}

bool function ShouldDisplayConsumableSwitchHint( entity player )
{
	if ( player.IsShadowForm() )
		return false


	return (PlayerHasHealthKits( player ) && player.GetHealth() < player.GetMaxHealth()) || (PlayerHasShieldKits( player ) && player.GetShieldHealth() < player.GetShieldHealthMax() && !StatusEffect_HasSeverity( player, eStatusEffect.healing_denied ))



}

string function GetCanUseResultString( int consumableUseActionResult )
{
	switch ( consumableUseActionResult )
	{
		case eUseConsumableResult.ALLOW:
		case eUseConsumableResult.DENY_NONE:
			return ""

		case eUseConsumableResult.DENY_SHIELD_HEAL_DENIED:
			return "#DENY_SHIELD_HEAL_DENIED"

		case eUseConsumableResult.DENY_ULT_FULL:
			return "#DENY_ULT_FULL"

		case eUseConsumableResult.DENY_ULT_NOTREADY:
			return "#DENY_ULT_NOTREADY"

		case eUseConsumableResult.DENY_HEALTH_FULL:
			return "#DENY_HEALTH_FULL"

		case eUseConsumableResult.DENY_SHIELD_FULL:
			return "#DENY_SHIELD_FULL"

		case eUseConsumableResult.DENY_NO_HEALTH_KIT:
			return "#DENY_NO_HEALTH_KIT"

		case eUseConsumableResult.DENY_NO_SHIELD_KIT:
			return "#DENY_NO_SHIELD_KIT"

		case eUseConsumableResult.DENY_NO_PHOENIX_KIT:
			return "#DENY_NO_PHOENIX_KIT"

		case eUseConsumableResult.DENY_NO_KITS:
			return "#DENY_NO_KITS"

		case eUseConsumableResult.DENY_NO_SHIELDS:
		{

				if( UpgradeCore_IsEnabled() )
					return "#DENY_NO_SHIELD_CORE"
				else
					return "#DENY_NO_SHIELDS"



		}

		case eUseConsumableResult.DENY_FULL:
			return "#DENY_FULL"

		case eUseConsumableResult.DENY_DEATH_TOTEM:
			return "#DENY_DEATH_TOTEM"









		default:
			return ""
	}

	unreachable
}

void function Consumable_OnGamestateEnterResolution()
{
	array<entity> livingPlayer = GetPlayerArray_Alive()
	foreach( player in livingPlayer )
		Signal( player, "ConsumableDestroyRui" )
}

void function ServerToClient_DoUltAccelScreenFx()
{
	Consumable_DoUltAccelScreenFx( GetLocalViewPlayer() )
}

void function ServerToClient_SetClientChargeTime( int consumableType, float chargeTime )
{
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]
	info.chargeTime = chargeTime
}






























































































































































































































































































































































































bool function Consumable_CanUseUltAccel( entity player , bool checkMinToFire = true )
{
	entity ult = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( !IsValid( ult ) )
		return false

	if ( checkMinToFire )
	{
		int minToFire = ult.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
		int burstCount = ult.GetWeaponSettingInt( eWeaponVar.burst_fire_count )
		if ( burstCount > 0 )
			minToFire *= burstCount

		if ( ult.GetWeaponPrimaryClipCount() >= minToFire )
			return false
	}

	int maxClipCount = ult.GetWeaponPrimaryClipCountMax()
	if ( ult.GetWeaponPrimaryClipCount() == maxClipCount )
		return false






	return true
}











bool function Consumable_IsValidModCommand( entity player, entity weapon, string mod, bool isAdd )
{
	if ( weapon.GetWeaponClassName() != CONSUMABLE_WEAPON_NAME )
		return false

	if ( ! (mod in file.modNameToConsumableType) )
		return false

	if ( isAdd )
	{
		if ( !Consumable_CanUseConsumable( player, file.modNameToConsumableType[ mod ], false ) )
			return false
	}

	return true
}

bool function Consumable_IsValidConsumableInfo( int consumableType )
{
	return (consumableType in file.consumableTypeToInfo)
}


ConsumableInfo function Consumable_GetConsumableInfo( int consumableType )
{
	Assert( consumableType in file.consumableTypeToInfo, "Invalid ConsumableType \"" + consumableType + "\" not present in table." )

	return file.consumableTypeToInfo[ consumableType ]
}


PotentialHealData function Consumable_CreatePotentialHealData( entity player, int consumableType, int addedHealth = 0, int addedShields = 0 )
{
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]
	string itemName     = info.lootData.ref

	PotentialHealData healData
	healData.kitType = consumableType
	healData.count = SURVIVAL_CountItemsInInventory( player, itemName )

	healData.possibleHealthAdd = info.healAmount
	healData.possibleShieldAdd = info.shieldAmount

	int health = player.GetHealth() + addedHealth
	int shields = player.GetShieldHealth() + addedShields
	health = minint( health, player.GetMaxHealth() )
	shields = minint( shields, player.GetShieldHealthMax() )

	int missingHealth  = player.GetMaxHealth() - health
	int missingShields = player.GetShieldHealthMax() - shields

	missingHealth = maxint( 0, missingHealth )
	missingShields = maxint( 0, missingShields )



	healData.consumableInfo = clone info


	int appliedHeal = minint( missingHealth, info.healAmount)
	healData.overHeal = maxint( info.healAmount - missingHealth, 0 )

	int appliedShields = minint( missingShields, info.shieldAmount)
	healData.overShield = maxint( info.shieldAmount  - missingShields, 0 )

	healData.totalAppliedHeal = appliedHeal + appliedShields
	healData.totalOverheal = (healData.overHeal + healData.overShield)

	healData.healthPerSecond = healData.totalAppliedHeal / info.chargeTime


	return healData
}


int function CompareHealData( PotentialHealData a, PotentialHealData b )
{

		
		if ( a.possibleShieldAdd > 0 && a.totalAppliedHeal == b.totalAppliedHeal && a.consumableInfo.chargeTime < b.consumableInfo.chargeTime )
			return -1
		else if ( b.possibleShieldAdd > 0 && b.totalAppliedHeal == a.totalAppliedHeal && b.consumableInfo.chargeTime < a.consumableInfo.chargeTime)
			return 1

		if ( a.possibleShieldAdd > 0  && a.overShield < a.possibleShieldAdd && a.healthPerSecond > b.healthPerSecond )
			return -1
		else if ( b.possibleShieldAdd > 0 && b.overShield < b.possibleShieldAdd && b.healthPerSecond > a.healthPerSecond )
			return 1

		
		if ( a.possibleHealthAdd > 0 && a.consumableInfo.chargeTime < b.consumableInfo.chargeTime )
			return -1
		else if( b.possibleHealthAdd > 0 && b.consumableInfo.chargeTime < a.consumableInfo.chargeTime  )
			return 1

		return 0


























}

int function Consumable_GetConsumableRecoveryType( int consumableType )
{
	int consumableRecoveryType

	if ( file.consumableTypeToInfo[ consumableType ].healAmount > 0 )
	{
		if ( file.consumableTypeToInfo[ consumableType ].shieldAmount > 0 )
			consumableRecoveryType = eConsumableRecoveryType.COMBINED
		else
			consumableRecoveryType = eConsumableRecoveryType.HEALTH
	}
	else if ( file.consumableTypeToInfo[ consumableType ].shieldAmount > 0 )
	{
		consumableRecoveryType = eConsumableRecoveryType.SHIELDS
	}
	if ( file.consumableTypeToInfo[ consumableType ].ultimateAmount > 0 )
	{
		consumableRecoveryType = eConsumableRecoveryType.ULTIMATE
	}

	return consumableRecoveryType
}

bool function Consumable_CanUseConsumable( entity player, int consumableType, bool printReason = true )
{






	int canUseResult = TryUseConsumable( player, consumableType )

	if ( canUseResult == eUseConsumableResult.ALLOW )
	{
		return true
	}


		if ( printReason && !player.GetPlayerNetBool( "isHealing" ) )
		{
			switch( canUseResult )
			{
				case eUseConsumableResult.DENY_NO_KITS:
				case eUseConsumableResult.DENY_NO_HEALTH_KIT:
				case eUseConsumableResult.DENY_NO_PHOENIX_KIT:
				case eUseConsumableResult.DENY_SHIELD_FULL:
				case eUseConsumableResult.DENY_NO_SHIELDS:
					if ( player.GetHealth() < player.GetMaxHealth() && !PlayerHasHealthKits( player ) )
					{
						Remote_ServerCallFunction( "ClientCallback_Quickchat", eCommsAction.INVENTORY_NEED_HEALTH, eCommsFlags.NONE )
					}
					else if ( player.GetShieldHealth() < player.GetShieldHealthMax() && !PlayerHasShieldKits( player ) )
					{
						Remote_ServerCallFunction( "ClientCallback_Quickchat", eCommsAction.INVENTORY_NEED_SHIELDS, eCommsFlags.NONE )
					}
					break

				case eUseConsumableResult.DENY_NO_SHIELD_KIT:
				case eUseConsumableResult.DENY_HEALTH_FULL:
					if ( player.GetShieldHealth() < player.GetShieldHealthMax() && !PlayerHasShieldKits( player ) )
					{
						Remote_ServerCallFunction( "ClientCallback_Quickchat", eCommsAction.INVENTORY_NEED_SHIELDS, eCommsFlags.NONE )
					}
					break

				case eUseConsumableResult.DENY_SHIELD_HEAL_DENIED:
					EmitSoundOnEntity( player, "crafting_replicator_menu_deny" )
					break


				default:
				}
			string reason = GetCanUseResultString( canUseResult )
			if ( reason == "" )
				return false

			if ( ShouldDisplayConsumableSwitchHint( player ) )
			{
				reason = Localize( "#SWITCH_HEALTH_KIT_ENTIRE", Localize ( GetCanUseResultString( canUseResult ) ), Localize( "#SWITCH_HEALTH_KIT" ) )
			}
			AnnouncementMessageRight( player, reason )
			return false
		}

	return false
}


int function TryUseConsumable( entity player, int consumableType )
{

	if ( player != GetLocalClientPlayer() )
		return eUseConsumableResult.DENY_NONE

	if ( player != GetLocalViewPlayer() )
		return eUseConsumableResult.DENY_NONE

	if ( IsWatchingReplay() )
		return eUseConsumableResult.DENY_NONE





	while ( player.ContextAction_IsActive() ) 
	{
		if ( player.ContextAction_IsRodeo() )
			break 

		return eUseConsumableResult.DENY_NONE
	}

	if ( Bleedout_IsBleedingOut( player ) )
		return eUseConsumableResult.DENY_NONE

	if ( !IsAlive( player ) )
		return eUseConsumableResult.DENY_NONE

	if ( player.IsPhaseShifted() )
		return eUseConsumableResult.DENY_NONE

	if ( StatusEffect_HasSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return eUseConsumableResult.DENY_NONE

	if ( StatusEffect_HasSeverity( player, eStatusEffect.healing_denied ) )
	{
		if ( consumableType == eConsumableType.SHIELD_LARGE || consumableType == eConsumableType.SHIELD_SMALL )
		{
			return eUseConsumableResult.DENY_SHIELD_HEAL_DENIED
		}
	}


	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return eUseConsumableResult.DENY_NONE

	if ( player.IsTitan() )
		return eUseConsumableResult.DENY_NONE

	if ( DeathTotem_PlayerCanRecall( player ) )
		return eUseConsumableResult.DENY_DEATH_TOTEM
	if ( consumableType == eConsumableType.ULTIMATE )
	{
		ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]
		int count           = SURVIVAL_CountItemsInInventory( player, info.lootData.ref )

		if ( count == 0 )
			return eUseConsumableResult.DENY_NONE

		entity ultimateAbility = player.GetOffhandWeapon( OFFHAND_INVENTORY )
		if ( !IsValid( ultimateAbility ) )
			return eUseConsumableResult.DENY_ULT_NOTREADY
		int ammo    = ultimateAbility.GetWeaponPrimaryClipCount()
		int maxAmmo = ultimateAbility.GetWeaponPrimaryClipCountMax()

		if ( ammo >= maxAmmo )
			return eUseConsumableResult.DENY_ULT_FULL
		if ( !ultimateAbility.IsReadyToFire() )
			return eUseConsumableResult.DENY_ULT_NOTREADY


			if( ultimateAbility.HasMod( ULTIMATE_ACTIVE_MOD_STRING ) )



				return eUseConsumableResult.DENY_ULT_NOTREADY
	}







	else
	{
		int currentHealth  = player.GetHealth()
		int currentShields = player.GetShieldHealth()
		int maxHealth  = player.GetMaxHealth()
		int maxShields = player.GetShieldHealthMax()
		bool canHeal       = false
		bool canShield     = false
		bool needHeal      = currentHealth < maxHealth
		bool needShield    = currentShields < maxShields



































		ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]

		int count = SURVIVAL_CountItemsInInventory( player, info.lootData.ref )



		if ( count == 0 )

		{
			if ( info.healAmount > 0 && info.shieldAmount > 0 )
				return eUseConsumableResult.DENY_NO_PHOENIX_KIT
			if ( info.healAmount > 0 )
				return eUseConsumableResult.DENY_NO_HEALTH_KIT
			if ( info.shieldAmount > 0 )
				return eUseConsumableResult.DENY_NO_SHIELD_KIT
		}

		if ( info.healAmount > 0 && info.shieldAmount == 0 && info.healCap <= 100 )
		{
			if ( !needHeal )
				return eUseConsumableResult.DENY_HEALTH_FULL
		}
		else if ( info.shieldAmount > 0 && info.healAmount == 0 )
		{
			if ( !needShield )
				return maxShields > 0 ? eUseConsumableResult.DENY_SHIELD_FULL : eUseConsumableResult.DENY_NO_SHIELDS
		}
		else
		{
			if ( info.healAmount > 0 && needHeal )
				canHeal = true

			if ( info.shieldAmount > 0 && needShield )
				canShield = true

			if ( info.healAmount > 0 && info.healCap > 100 )
			{
				int targetHealth = currentHealth + info.healAmount
				int overHeal     = targetHealth - maxHealth
				if ( overHeal != 0 && currentShields < maxShields )
					canShield = true
			}

			if ( !canHeal && !canShield )
			{
				if ( currentHealth == player.GetMaxHealth() && currentShields == maxShields )
					return eUseConsumableResult.DENY_FULL

				return eUseConsumableResult.DENY_NO_KITS
			}
		}
	}

	return eUseConsumableResult.ALLOW
}


bool function CanSwitchToWeapon( entity weapon, string modName )
{
	if ( !IsValid( weapon ) )
		return false

	if ( !(modName in file.modNameToConsumableType) )
		return false

	entity player = weapon.GetOwner()

	int consumableType  = file.modNameToConsumableType[ modName ]
	ConsumableInfo info = file.consumableTypeToInfo[ consumableType ]
	string itemName     = info.lootData.ref


	if ( !Consumable_CanUseConsumable( player, consumableType, true ) )
		return false

	if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) == weapon )
		return false

	return true
}


string function GetConsumableModOnWeapon( entity weapon )
{
	foreach ( string mod in weapon.GetMods() )
	{
		foreach ( int consumableType, ConsumableInfo info in file.consumableTypeToInfo )
		{
			if ( mod == info.modName )
			{
				return mod
			}

			else if( mod == "ultimate_battery_fast" && info.modName == "ultimate_battery" )
			{
				return mod
			}


		}
	}

	return ""
}


TargetKitHealthAmounts function Consumable_PredictConsumableUse( entity player, ConsumableInfo kitInfo )
{
	int currentHealth   = player.GetHealth()
	int maxHealth       = player.GetMaxHealth()
	int currentShields  = player.GetShieldHealth()
	int shieldHealthMax = player.GetShieldHealthMax()

	int resourceHealthRemaining = 0
	int virtualHealth           = minint( currentHealth + resourceHealthRemaining, maxHealth )
	int missingHealth           = maxHealth - virtualHealth
	int missingShields          = shieldHealthMax - currentShields

	TargetKitHealthAmounts targetValues

	float healAmount   = Consumable_CalculateTotalHealFromItem( player, kitInfo )
	float shieldAmount = Consumable_CalculateTotalShieldFromItem( player, kitInfo )

	if ( healAmount > 0 )
	{
		int healthToApply = minint( int( healAmount ), missingHealth )
		Assert( virtualHealth + healthToApply <= maxHealth, "Bad math: " + virtualHealth + " + " + healthToApply + " > max health of " + maxHealth )

		if ( healthToApply != 0 || kitInfo.healTime > 0 ) 
			targetValues.targetHealth = (healthToApply + resourceHealthRemaining) / float( maxHealth )
	}

	if ( shieldAmount > 0 && shieldHealthMax > 0 )
		targetValues.targetShields = shieldAmount / float( shieldHealthMax )

	return targetValues
}


void function ResetConsumableData( ConsumablePersistentData useData )
{
	useData.useFinished         = false
	useData.healAmount          = 0
	useData.healAmountRemaining = 0
	useData.healthKitResourceId = 0
	useData.shieldStatusHandle  = 0
	useData.healthStatusHandle  = 0
	useData.lastMissingHealth   = -1
	useData.lastMissingShields  = -1
	useData.lastCurrentHealth   = -1
	useData.statusEffectHandles = []
}

bool function Consumable_IsHealthItem( int consumableType )
{
	if ( !( consumableType in file.consumableTypeToInfo ) )
		return false

	if ( file.consumableTypeToInfo[ consumableType ].healAmount > 0 )
		return true

	return false
}

bool function Consumable_IsShieldItem( int consumableType )
{
	if ( !( consumableType in file.consumableTypeToInfo ) )
		return false

	if ( file.consumableTypeToInfo[ consumableType ].shieldAmount > 0 )
		return true

	return false
}

bool function ShouldPlayUltimateSuperchargedFX( entity player )
{
	if ( PlayerHasPassive( player, ePassives.PAS_BATTERY_POWERED ) )
		return true

	return false
}
















































































      