





global function printl
global function CodeCallback_Precompile

global enum eScriptWindEvalStatus
{
	INCOMPLETE,
	COMPLETE,
	EXPIRED,
    INVALID
}

global struct ScriptWindEvalResult
{
    vector vec
	int status
}

global struct EchoTestStruct
{
	int test1
	bool test2
	bool test3
	float test4
	vector test5
	int[5] test6
}

global struct TraceResults
{
	entity hitEnt
	vector endPos
	vector surfaceNormal
	string surfaceName
	int surfaceProp
	float fraction
	float fractionLeftSolid
	int hitGroup
	int staticPropID
	bool startSolid
	bool allSolid
	bool hitSky
	bool hitBackFace
	int contents
}

global struct BreachTraceResults
{
	int result
	vector endPos
	vector surfaceNormal
}

global struct GrenadeIndicatorData
{
	vector hitPos
	vector hitNormal
	vector hitVelocity
	entity hitEnt
}

global struct VisibleEntityInCone
{
	entity ent
	vector visiblePosition
	int visibleHitbox
	bool solidBodyHit
	vector approxClosestHitboxPos
	int extraMods
}

global struct PlayerDidDamageParams
{
	entity victim
	vector damagePosition
	int hitBox
	int damageType
	float damageAmount
	int damageFlags
	int hitGroup
	entity weapon
	float distanceFromAttackOrigin
}

global struct Attachment
{
	vector position
	vector angle
}

global struct EntityScreenSpaceBounds
{
	float x0
	float y0
	float x1
	float y1
	bool outOfBorder
}

global struct BackendError
{
	int serialNum
	string errorString
}

global struct CommunityFriends
{
	bool isValid
	array<string> ids
	array<string> hardware
	array<string> names
}

global struct CupsMatchStatInformation
{
	string statRef
	int statChange
	int pointsGained
}

global struct CupsPlayerMatchSummary
{
	int									playerPlacement
	string								playerLegendName
	string								playerUID
	string								playerHardware
	int 								playerCalculatedScore
	array< CupsMatchStatInformation > 	statInformation
}

global struct CupMatchSummary
{
	int								squadCalculatedScore
	array< CupsPlayerMatchSummary >	playerSummaries
}

global struct CupEntry
{
	int cupID
	string squadID
	int currSquadPosition
	int leaderboardCount
	float positionPercentage
	int currSquadScore
	int reRollCount
	bool active
	array< CupMatchSummary > matchSummaryData
	array< int > tierScoreBounds
}

global struct CupPlayerMMRBucket
{
	int cupID
	int bucket
}

global struct UserFullCupData
{
	array< CupEntry > enteredCups
	array< CupPlayerMMRBucket > cupPlayerMMRData
}

global struct CupPlayerInfo
{
	string playerUID
	string hardware
	string name
}

global struct CupLeaderboardEntry
{
	string squadID
	array<CupPlayerInfo> squadInfo
	int squadScore
	array<CupMatchSummary> matchHistoryData
}

global struct CupTierRewardData
{
	asset		reward
	int        	quantity
}

global struct CupTierData
{
	int		tierType
	int		bound

	asset	icon

	array<CupTierRewardData> rewardData
}

global struct CommunityUserInfo
{
	string hardware
	string uid
	string name
	string tag
	string kills
	int wins
	int matches
	int banReason
	int banSeconds
	int eliteStreak
	int rankScore
	string rankedPeriodName
	int rankedLadderPos
	int lastCharIdx
	bool isLivestreaming
	bool isOnline
	bool isJoinable
	bool hasGraduatedBotsQueue
	bool partyFull
	bool partyInMatch
	float lastServerChangeTime
	string privacySetting
	array<int> charData
	int rumbleRankScore
	int rumbleRankedLadderPos
}

global struct PartyMember
{
	string name
	string uid
	string hardware
	bool ready
	bool present
	string eaid
	int boostCount
	string unspoofedUID
}

global struct Party
{
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	bool amIInThis
	bool amILeader
	bool searching
	array<PartyMember> members
}

global struct NetTraceRouteResults
{
	string address
	int sent
	int received
	int bestRttMs
	int worstRttMs
	int lastRttMs
	int averageRttMs
}

global struct EnemyDotDistanceSqrStruct
{
	entity enemy
	float viewCos
	float distanceSqr
	bool inPlayerFOV
	float score
}


global struct MatchmakingDatacenterETA
{
	int datacenterIdx
	string datacenterName
	int latency
	int packetLoss
	int etaSeconds
	int idealStartUTC
	int idealEndUTC
}



global struct GRXCraftingOffer
{
	int itemIdx
	int craftingPrice
}

global struct GRXStoreOfferItem
{
	int itemIdx
	int itemQuantity
	int itemType
}

global struct GRXStoreOfferPrice
{
	string priceAlias
	array< int > currencies
}

global struct GRXStoreOffer
{
	array< GRXStoreOfferItem > items
	array< GRXStoreOfferPrice > prices
	table< string, string > attrs
	int offerType
	string offerAlias
	bool isSparkable
	int purchaseCount
	int ineligibilityCode
}

global struct GRXGetOfferInfo
{
	bool isEligible
	array< array< int > > prices
}



global struct GRXScriptInboxMessage
{
	array<int> itemIndex
	array<int> itemCount
	bool       isNew
	int        timestamp
	string     senderNucleusPid
	string     gifterName
}
















































global struct GRXContainerInfo
{
	int type
	string containerId
	array< int > itemIndices
	array< int > itemCounts
	bool isNew
	int timestamp
	string senderNucleusPid
	string senderName
}

global struct GRXUserInfoBalances
{
	int balance
	int nextCurrencyExpirationAmt
	int nextCurrencyExpirationTime
}

global struct GRXUserInfo
{
	int inventoryState

	array<GRXUserInfoBalances> currencies

	int queryGoal
	int queryOwner
	int queryState
	int querySeqNum

	array< int > balances
	int nextCurrencyExpirationAmt
	int nextCurrencyExpirationTime

	array< GRXContainerInfo > containers

	int sparkleLimitCounter
	int sparkleLimitResetDate

	int marketplaceEdition

	bool isOfferRestricted
}


global struct ClubHeader
{
	string clubID
	string name
	string tag
	string logoString
	string creatorID
	string dataCenter
	int memberCount
	int privacySetting	
	int minLevel
	int minRating
	int searchTags
	int hardware
	bool allowCrossplay
	int lastActive
}

global struct ClubMember
{
	string memberID
	string memberName
	string platformUserID
	int memberHardware
	int rank
}

global struct ClubJoinRequest
{
	string userID
	string userName
	int userHardware
	string platformUid
	int expireTime
}

global struct ClubEvent
{
	int eventTime
	int eventType	
	int eventParam
	string eventText
	string memberName
	string memberID
}

global struct ClubData
{
	array< ClubMember > members
	array< ClubJoinRequest > joinRequests
	array< ClubEvent > eventLog
	array< ClubEvent > chatLog
}

global struct ClubInvite
{
	string clubID
	string name
}

global struct ClubDisplay{
	string clubID
	string name
	string tag
	string logoString
	string dataCenter
	int lastActive
	int numMembers
	int maxMembers
	float activityMetric
}



global struct VortexBulletHit
{
	entity vortex
	vector hitPos
}

global struct AnimRefPoint
{
	vector origin
	vector angles
}

global struct LevelTransitionStruct
{
	
	

	int startPointIndex

	int[3] ints

	int[2] pilot_mainWeapons = [-1,-1]
	int[2] pilot_offhandWeapons = [-1,-1]
	int ornull[2] pilot_weaponMods = [null,null]
	int pilot_ordnanceAmmo = -1

	int titan_mainWeapon = -1
	int titan_unlocksBitfield = 0

	int difficulty = 0
}

global struct WeaponOwnerChangedParams
{
	entity oldOwner
	entity newOwner
}

global struct WeaponTossPrepParams
{
	bool isPullout
}

global struct WeaponPrimaryAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
}

global struct WeaponRedirectParams
{
	entity projectile
	vector projectilePos
}

global struct WeaponBulletHitParams
{
	entity hitEnt
	vector startPos
	vector hitPos
	vector hitNormal
	vector dir
}

global struct WeaponFireBulletSpecialParams
{
	vector pos
	vector dir
	int bulletCount
	int scriptDamageType
	bool skipAntiLag
	bool dontApplySpread
	bool doDryFire
	bool noImpact
	bool noTracer
	bool activeShot
	bool doTraceBrushOnly
}

global struct WeaponFireBoltParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	int additionalRandomSeed
	bool dontApplySpread
	int projectileIndex
	bool deferred 
}

global struct WeaponFireGrenadeParams
{
	vector pos
	vector vel
	vector angVel
	float fuseTime
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	bool lagCompensated
	bool useScriptOnDamage
	bool isZiplineGrenade = false
	string ziplineGrenadeRopeMaterial = "cable/zipline"
	int projectileIndex
}

global struct WeaponFireMissileParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool doRandomVelocAndThinkVars
	bool clientPredicted
	int projectileIndex
}

global struct WeaponMissileMultipleTargetData
{
	vector pos
	vector normal
	float delay
}

global struct ModInventoryItem
{
	int slot
	string mod
	string weapon
	int count
}

global struct OpticAppearanceOverride
{
	array<string>	bodygroupNames
	array<int>		bodygroupValues
	array<string>	uiDataNames
}


global struct ArtifactViewmodelData
{
	int bladeGUID
	int powerSourceGUID
}


global struct ConsumableInventoryItem
{
	int slot
	int type
	int count
}

global struct OutsourceViewer_SkinDetails
{
	string skinName
	asset skinAssetName
	int skinTier
}

global struct PingCollection
{
	entity latestPing
	array<entity> locations
	array<entity> loots
}

global struct HudInputContext
{
	bool functionref(int) keyInputCallback
	bool functionref(float, float) viewInputCallback
	bool functionref(float, float) moveInputCallback
	int hudInputFlags
}

global struct SmartAmmoTarget
{
	entity ent
	float fraction
	float prevFraction
	bool visible
	float lastVisibleTime
	bool activeShot
	float trackTime
}

global struct StaticPropRui
{
	
	
	
	

	string scriptName           
	string mockupName           
	string modelName            
	vector spawnOrigin			
	vector spawnMins			
	vector spawnMaxs			

	vector spawnForward
	vector spawnRight
	vector spawnUp

	
	
	
	
	
	

	asset ruiName               
	table<string, string> args  

	
	
	
	
	
	

	int magicId
}

global struct ScriptAnimWindow
{
	entity ent
	asset settingsAsset
	string stringID
	string windowName
	float startCycle
	float endCycle
}

global struct ZiplineStationSpots
{
	asset beginStationModel
	vector beginStationOrigin
	vector beginStationAngles
	entity beginStationMoveParent
	string beginStationAnimation
	vector beginZiplineOrigin

	asset endStationModel
	vector endStationOrigin
	vector endStationAngles
	entity endStationMoveParent
	string endStationAnimation
	vector endZiplineOrigin
}

global struct WaypointClusterInfo
{
	vector clusterPos
	int numPointsNear
}

global struct EdgeGrappleResults
{
	bool edgeFound
	bool isValid
	vector grapplePos
	vector grappleNormal
	float distFrac
}

global struct PlayersInViewInfo
{
	entity player
	bool hasLOS
	float distanceSqr
	float dot
}

global struct NavMesh_FindMeshPath_Result
{
	bool navMeshOK
	bool startPolyOK
	bool goalPolyOK
	bool pathFound
	bool pathIsPartialPath
	array<vector> points
	float pathLength
}

global struct PrivateMatchStatsStruct
{
	string playerName
	string teamName
	string characterName
	string platformUid
	string hardware
	int survivalTime
	int kills
	int assists
	int knockdowns
	int damageDealt
	int shots
	int hits
	int headshots
	int revivesGiven
	int respawnsGiven
	int teamNum
	int teamPlacement
	bool alive
}

global struct PrivateMatchAdminChatConfigStruct
{
	int		chatMode
	int		targetIndex
	bool	spectatorChat
}

global struct PrivateMatchChatConfigStruct
{
	bool	adminOnly
}

global typedef SettingsAssetGUID int



global enum eRichPresenceSubstitutionMode
{												
	NONE,										
	MODE_MAP,									
	MODE_MAP_SQUADSLEFT,						
	MODE_MAP_FRIENDLYSCORE_ENEMYSCORE,			
	MODE_MAP_FRIENDLYSCORE_ENEMYSCORE_PERCENTAGE,
	PARTYSLOTSUSED_PARTYSLOTSMAX,				
}

global struct PresenceState
{
	string 			layout
	int				substitutionMode

	string 			mapName
	string 			gamemode
	int				matchStartTime
	int 			party_slotsUsed
	int 			party_slotsMax
	int 			survival_squadsRemaining
	int				teams_friendlyScore
	int				teams_enemyScore
}

global struct CustomMatch_LobbyPlayer
{
	string uid
	string uidHashed
	string eaid
	string firstPartyID
	string hardware
	string name
	string tag
	bool isAdmin = false
	int team = 1
	int flags = 0
}

global struct CustomMatch_MatchHistory
{
	int matchNumber
	int endTime
}

global struct CustomMatch_LobbyState
{
	
	int maxTeams = 20
	int maxPlayers = 60
	int maxSpectators = 20
	int matchState = 0
	int tokenVer = 1
	int selfIdx = -1
	string playlist
	bool adminChat = false
	bool teamRename = false
	bool selfAssign = true
	bool aimAssist = true
	bool anonMode = false
	array<CustomMatch_LobbyPlayer> players
	array<CustomMatch_MatchHistory> matches
	table<int, string> teamNames
}

global struct CustomMatch_MatchPlayer
{
	string uid
	string hardware
	string name
	string tag
	string character
	int status
	int kills
	int damageDealt
}

global struct CustomMatch_MatchTeam
{
	int index
	string name
	int placement
	int killCount
	array<CustomMatch_MatchPlayer> players
}

global struct CustomMatch_MatchSummary
{
	string gamemode
	bool inProgress
	array<CustomMatch_MatchTeam> teams
}

global struct CustomMatch_LobbyHistory
{
	array<CustomMatch_MatchHistory> matches
}




global struct CustomMatch_SettingsForUpdate
{
	string playlist
	bool adminChat
	bool teamRename
	bool selfAssign
	bool aimAssist
	bool anonMode
}

global struct  EadpPresenceData
{
	int			hardware
	PresenceState ornull 	presence
	bool		partyInMatch
	bool		partyIsFull
	string		privacySetting
	string		name
	bool		online
	bool		ingame
	bool		away
	string      firstPartyId
	bool        isJoinable
}

global struct EadpPeopleData
{
	string eaid
	string name
	string platformName
	string platformHardware
	string ea_pid
	string psn_pid
	string xbox_pid
	string steam_pid
	string switch_pid
	int ea_has_played
	int psn_has_played
	int xbox_has_played
	int steam_has_played
	int switch_has_played
	int friendCreationTime
	array< EadpPresenceData > presences
}

global struct EadpPeopleList
{
	bool   isValid
	array< EadpPeopleData > people
}

global struct EadpQuerryPlayerData
{
	string	eaid
	string	name
	int		hardware
}

global struct EadpQuerryPlayerDataList
{
	bool   isValid
	array< EadpQuerryPlayerData > players
}


global struct EadpInviteToPlayData
{
	string	eaid
	string	name
	int		hardware
	int		reason
	EadpPresenceData ornull eadpPresence
}

global struct EadpInviteToPlayList
{
	bool   isValid
	array< EadpInviteToPlayData > invitations
}

global const string DISCOVERABLE_EVERYONE = "EVERYONE"
global const string DISCOVERABLE_NOONE = "NO_ONE"

global struct EadpPrivacySetting
{
	bool	isValid
	string	psnIdDiscoverable
	string	xboxTagDiscoverable
	string	displayNameDiscoverable
	string	steamNameDiscoverable
	string	nintendoNameDiscoverable
}

global enum eFriendStatus
{
	ONLINE_INGAME,
	ONLINE,
	ONLINE_AWAY,
	OFFLINE,
	REQUEST,
	COUNT
}

global struct Friend
{
	string id
	string unspoofedid = ""
	string hardware
	string name = "Unknown"
	string presence = ""
	int    status = eFriendStatus.OFFLINE
	bool   ingame = false
	bool   inparty = false
	bool   away = false
	bool   inleaderboard = false

	EadpPresenceData ornull eadpPresenceData
	EadpPeopleData ornull eadpData
}

global struct FriendsData
{
	array<Friend> friends
	bool          isValid
}

global struct CodeRedemptionGrant
{
	string alias
	int qty
	int type
}

global struct CommunityFriendsData
{
	string id
	string hardware
	string name
	string presence
	bool online
	bool ingame
	bool away
	EadpPresenceData ornull eadpPresenceData
}

global struct CommunityFriendsWithPresence
{
	bool isValid
	array<CommunityFriendsData> friends
}

global struct XProgProfileInfo
{
	int    platformId
	string nickname
}

global struct XProgMigrateData
{
	bool coolingDown
	int retryMinutes
	int processStatus
	bool hasMultipleProfiles

	string nickname
	int level

	int apexPacks
	int cosmetics
	int credits
	int crafting
	int premium
	int premiumNx
	int heirloom
	int heirloomShards

	string eaId
	array<XProgProfileInfo> profiles
}

global struct UMAttribute
{
	string key
	string value
}

global struct UMItem
{
	string type
	string name
	string value
	array<UMAttribute> attributes
}

global struct UMAction
{
	string name
	string trackingId
	array<UMItem> items
}

global struct UMData
{
	string triggerId
	string triggerName
	array<UMAction> actions
}



global struct ChallengeDebugDataStruct 
{
	int guid
	int category
	bool complete
	string ref
	string debugInfo
}






void function printl( var text )
{
	return print( text + "\n" )
}

void function CodeCallback_Precompile()
{
#if DEV
	
	if ( hasscriptdocs() )
	{
		getroottable().originalConstTable <- clone getconsttable()
	}
#endif
}

