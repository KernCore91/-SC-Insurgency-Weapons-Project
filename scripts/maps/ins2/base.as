// Usage suited for Insurgency Weapons in Sven Co-op
// Author: KernCore, Firemodes Sprite function by D.N.I.O. 071, Speed modifier and bodygroup calculation by GeckoN

namespace INS2BASE
{ //Namespace start

bool ShouldUseCustomAmmo = true; // true = Uses custom ammo values; false = Uses SC's default ammo values.

enum INS2_IRON_OPTIONS // Iron sights options
{
	IRON_OUT = 0,
	IRON_IN
};

enum INS2_SELECTFIRE_OPTIONS // Select fire options
{
	SELECTFIRE_SEMI = 0,
	SELECTFIRE_3XBURST,
	SELECTFIRE_AUTO,
	SELECTFIRE_2XBURST,
	SELECTFIRE_4XAUTO
};

enum INS2_BIPOD_OPTIONS // Bipod Options
{
	BIPOD_UNDEPLOYED = 0,
	BIPOD_DEPLOYED
};

enum INS2_GL_OPTIONS // Grenade Launcher options
{
	GL_NOTAIMED = 0,
	GL_AIMED
};

//default Ammo
//9mm
const string DF_AMMO_9MM	= "9mm";
const int DF_MAX_CARRY_9MM	= 250;
//buckshot
const string DF_AMMO_BUCK	= "buckshot";
const int DF_MAX_CARRY_BUCK	= 125;
//357
const string DF_AMMO_357	= "357";
const int DF_MAX_CARRY_357	= 36;
//m40a1
const string DF_AMMO_M40A1	= "m40a1";
const int DF_MAX_CARRY_M40A1= 15;
//556
const string DF_AMMO_556	= "556";
const int DF_MAX_CARRY_556	= 600;
//rockets
const string DF_AMMO_RKT	= "rockets";
const int DF_MAX_CARRY_RKT	= 5;
const int DF_MAX_CARRY_RKT2	= 10;
//uranium
const string DF_AMMO_URAN	= "uranium";
const int DF_MAX_CARRY_URAN	= 100;
//ARgrenades
const string DF_AMMO_ARGR	= "ARgrenades";
const int DF_MAX_CARRY_ARGR	= 10;
//sporeclip
const string DF_AMMO_SPOR	= "sporeclip";
const int DF_MAX_CARRY_SPOR	= 30;


const string EMPTY_SHOOT_S = "ins2/wpn/empty.ogg"; //Default Empty shoot sound, if your weapons doesn't have any empty sound, it will use this
const string AMMO_PICKUP_S = "ins2/wpn/ammo.ogg"; //Default ammo pickup sound
const string FIREMODE_SPRT = "ins2/firemodes.spr"; //Default firemodes sprite for weapons that support it
const string BIPODMOD_SPRT = "ins2/bipod.spr";
const string WEAP_SPRT_S01 = "ins2/wpn1024.spr"; //Sprite file that the weapon will precache
//const string WEAP_SPRT_S02 = "ins2/wpn05.spr"; //Sprite file that the weapon will precache

//Bullet types
//Pistols
const string BULLET_9x18 	= "models/ins2/shells/9x18.mdl";
const string BULLET_9x19 	= "models/ins2/shells/9mm.mdl";
const string BULLET_45ACP 	= "models/ins2/shells/45acp.mdl";
const string BULLET_763x25 	= "models/ins2/shells/763.mdl";
const string BULLET_50AE 	= "models/ins2/shells/50ae.mdl";
//SMGs
const string BULLET_762x25 	= "models/ins2/shells/762t.mdl";
const string BULLET_46x30 	= "models/ins2/shells/46x30.mdl";
//Rifles
const string BULLET_30_06 	= "models/ins2/shells/30cal.mdl";
const string BULLET_762x39 	= "models/ins2/shells/762.mdl";
const string BULLET_303 	= "models/ins2/shells/303.mdl";
const string BULLET_762x51 	= "models/ins2/shells/308.mdl";
const string BULLET_792x57 	= "models/ins2/shells/792x57.mdl";
const string BULLET_792x33 	= "models/ins2/shells/792k.mdl";
const string BULLET_556x45 	= "models/ins2/shells/556.mdl";
const string BULLET_556AP 	= "models/ins2/shells/556ap.mdl";
const string BULLET_545x39 	= "models/ins2/shells/545.mdl";
const string BULLET_762x54 	= "models/ins2/shells/762x54.mdl";
const string BULLET_762x33 	= "models/ins2/shells/762x33.mdl";
const string BULLET_9x39 	= "models/ins2/shells/9x39.mdl";
const string BULLET_300WM 	= "models/ins2/shells/300wm.mdl";
const string BULLET_50BMG 	= "models/ins2/shells/50bmg.mdl";
//Shotguns
const string SHELL_12GREEN 	= "models/ins2/shells/12g_g.mdl";
const string SHELL_12BLUE 	= "models/ins2/shells/12g_b.mdl";

// For Deploy Sounds
const array<string> DeployFirearmSounds = {
	"ins2/wpn/fdraw1.ogg",
	"ins2/wpn/fdraw2.ogg",
	"ins2/wpn/fdraw3.ogg",
	"ins2/wpn/fdraw4.ogg",
	"ins2/wpn/fdraw5.ogg",
	"ins2/wpn/fdraw6.ogg"
};
const array<string> DeployPistolSounds = {
	"ins2/wpn/pdraw1.ogg",
	"ins2/wpn/pdraw2.ogg",
	"ins2/wpn/pdraw3.ogg",
	"ins2/wpn/pdraw4.ogg",
	"ins2/wpn/pdraw5.ogg"
};
const array<string> DeployGrenadeSounds = {
	"ins2/wpn/gdraw1.ogg",
	"ins2/wpn/gdraw2.ogg",
	"ins2/wpn/gdraw3.ogg",
	"ins2/wpn/gdraw4.ogg"
};
const array<string> DeployBayonetSounds = {
	"ins2/wpn/bdraw1.ogg",
	"ins2/wpn/bdraw2.ogg",
	"ins2/wpn/bdraw3.ogg"
};
const array<string> DeployRandomSounds = {
	"ins2/wpn/rdraw1.ogg",
	"ins2/wpn/rdraw2.ogg",
	"ins2/wpn/rdraw3.ogg"
};
// For ADS Sounds
const array<string> AimDownSights_in = {
	"ins2/wpn/in1.ogg",
	"ins2/wpn/in2.ogg",
	"ins2/wpn/in3.ogg"
};
const array<string> AimDownSights_out = {
	"ins2/wpn/out1.ogg",
	"ins2/wpn/out2.ogg",
	"ins2/wpn/out3.ogg"
};

// Precaches an array of sounds
void PrecacheSound( const array<string> pSound )
{
	for( uint i = 0; i < pSound.length(); i++ )
	{
		g_SoundSystem.PrecacheSound( pSound[i] );
		g_Game.PrecacheGeneric( "sound/" + pSound[i] );
		//g_Game.AlertMessage( at_console, "Precached: sound/" + pSound[i] + "\n" );
	}
}

edict_t@ ENT( const entvars_t@ pev )
{
	return pev.pContainingEntity;
}

mixin class WeaponBase
{
	protected int WeaponADSMode; //Aim Down Sights mode
	protected int WeaponBipodMode; //Bipod mode
	protected int WeaponSelectFireMode; //Selective Fire Modes
	protected int WeaponGLMode; //Grenade Launcher mode
	protected uint m_iShotsFired;
	private bool m_iDirection = true;
	private Vector2D FiremodesPos( -5, -60 );
	private Vector2D BipodStatePos( -85, -50 ); //Bipod test
	protected float m_reloadTimer = 0, m_useTimer = 0;
	protected bool canReload;
	// GeckoN: Movement speed modifier
	protected int m_iSpeedType;
	protected float m_flSpeedModifier;

	// Geckon start
	/*int GetBodypartBase( int iGroup )
	{
		if( iGroup < 0 || iGroup >= int( m_bodyparts.length() ) )
		{
			return -1;
		}
		
		int iBase = 1;
		for( int i = 1; i <= iGroup; i++ )
		{
			iBase = iBase * m_bodyparts[ i - 1 ];
		}
		
		return iBase;
	}

	int SetBodygroup( int iGroup, int iSubmodel ) 
	{
		if( iGroup < 0 || iGroup >= int(m_bodyparts.length()) )
		{
			return -1;
		}
		
		int iNumSubmodels = m_bodyparts[ iGroup ];
		int iBodypartBase = GetBodypartBase( iGroup );
		
		if( iNumSubmodels == 0 || iBodypartBase < 0 )
		{
			return -1;
		}
		
		int iCurrent = (m_iCurBodyConfig / iBodypartBase) % iNumSubmodels;
		m_iCurBodyConfig = (m_iCurBodyConfig - (iCurrent * iBodypartBase) + (iSubmodel * iBodypartBase));
		
		return m_iCurBodyConfig;
	}
	protected array<int> m_bodyparts;*/

	protected int m_iCurBodyConfig = 0;
	// Geckon end

	void PlayDeploySound( int weapontype )
	{
		// weapon types: 0 for melees, 1 for grenades, 2 for pistols, 3 for most weapons, 4 for random weapons
		switch( weapontype )
		{
			case 0: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, DeployBayonetSounds[ Math.RandomLong( 0, DeployBayonetSounds.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				break;
			case 1: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, DeployGrenadeSounds[ Math.RandomLong( 0, DeployGrenadeSounds.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				break;
			case 2: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, DeployPistolSounds[ Math.RandomLong( 0, DeployPistolSounds.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				break;
			case 3: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, DeployFirearmSounds[ Math.RandomLong( 0, DeployFirearmSounds.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				break;
			case 4: 
			default: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, DeployRandomSounds[ Math.RandomLong( 0, DeployRandomSounds.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
		}
	}

	void CommonPrecache()
	{
		// Arrays
		INS2BASE::PrecacheSound( AimDownSights_in );
		INS2BASE::PrecacheSound( AimDownSights_out );

		// Sprites
		g_Game.PrecacheModel( "sprites/" + FIREMODE_SPRT );
		g_Game.PrecacheModel( "sprites/" + BIPODMOD_SPRT );
		g_Game.PrecacheModel( "sprites/" + WEAP_SPRT_S01 );
		//g_Game.PrecacheModel( "sprites/" + WEAP_SPRT_S02 );

		// Strings
		g_SoundSystem.PrecacheSound( EMPTY_SHOOT_S );
		g_Game.PrecacheGeneric( "sound/" + EMPTY_SHOOT_S );
		g_SoundSystem.PrecacheSound( AMMO_PICKUP_S );
		g_Game.PrecacheGeneric( "sound/" + AMMO_PICKUP_S );
	}

	string g_watersplash_spr = "sprites/wep_smoke_01.spr";
	void te_bubbletrail( Vector start, Vector end, string sprite = "sprites/bubble.spr", float height = 128.0f, uint8 count = 16, float speed = 16.0f, NetworkMessageDest msgType = MSG_BROADCAST )
	{
		NetworkMessage BTrail( msgType, NetworkMessages::SVC_TEMPENTITY, null );
			BTrail.WriteByte( TE_BUBBLETRAIL);
			BTrail.WriteCoord( start.x );
			BTrail.WriteCoord( start.y );
			BTrail.WriteCoord( start.z );
			BTrail.WriteCoord( end.x );
			BTrail.WriteCoord( end.y );
			BTrail.WriteCoord( end.z );
			BTrail.WriteCoord( height );
			BTrail.WriteShort( g_EngineFuncs.ModelIndex( sprite ) );
			BTrail.WriteByte( count );
			BTrail.WriteCoord( speed );
		BTrail.End();
	}

	void te_spritespray( Vector pos, Vector velocity, string sprite = "sprites/bubble.spr", uint8 count = 8, uint8 speed = 16, uint8 noise = 255, NetworkMessageDest msgType = MSG_BROADCAST )
	{
		NetworkMessage SSpray( msgType, NetworkMessages::SVC_TEMPENTITY, null );
			SSpray.WriteByte( TE_SPRITE_SPRAY );
			SSpray.WriteCoord( pos.x );
			SSpray.WriteCoord( pos.y );
			SSpray.WriteCoord( pos.z );
			SSpray.WriteCoord( velocity.x );
			SSpray.WriteCoord( velocity.y );
			SSpray.WriteCoord( velocity.z );
			SSpray.WriteShort( g_EngineFuncs.ModelIndex( sprite ) );
			SSpray.WriteByte( count );
			SSpray.WriteByte( speed );
			SSpray.WriteByte( noise );
		SSpray.End();

		switch( Math.RandomLong( 0, 2 ) )
		{
			case 0: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh1.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
			case 1: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh2.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
			case 2: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh3.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
		}
	}

	// water splashes and bubble trails for bullets
	void water_bullet_effects( Vector vecSrc, Vector vecEnd )
	{
		// bubble trails
		bool startInWater   	= g_EngineFuncs.PointContents( vecSrc ) == CONTENTS_WATER;
		bool endInWater     	= g_EngineFuncs.PointContents( vecEnd ) == CONTENTS_WATER;

		if( startInWater or endInWater )
		{
			Vector bubbleStart	= vecSrc;
			Vector bubbleEnd	= vecEnd;
			Vector bubbleDir	= bubbleEnd - bubbleStart;
			float waterLevel;

			// find water level relative to trace start
			Vector waterPos 	= (startInWater) ? bubbleStart : bubbleEnd;
			waterLevel      	= g_Utility.WaterLevel( waterPos, waterPos.z, waterPos.z + 1024 );
			waterLevel      	-= bubbleStart.z;

			// get percentage of distance travelled through water
			float waterDist	= 1.0f; 
			if( !startInWater or !endInWater )
				waterDist	-= waterLevel / (bubbleEnd.z - bubbleStart.z);
			if( !endInWater )
				waterDist	= 1.0f - waterDist;

			// clip trace to just the water portion
			if( !startInWater )
				bubbleStart	= bubbleEnd - bubbleDir*waterDist;
			else if( !endInWater )
				bubbleEnd 	= bubbleStart + bubbleDir*waterDist;

			// a shitty attempt at recreating the splash effect
			Vector waterEntry = (endInWater) ? bubbleStart : bubbleEnd;
			if( !startInWater or !endInWater )
			{
				te_spritespray( waterEntry, Vector( 0, 0, 1 ), g_watersplash_spr, 1, 64, 0);
			}

			// waterlevel must be relative to the starting point
			if( !startInWater or !endInWater )
				waterLevel = (bubbleStart.z > bubbleEnd.z) ? 0 : bubbleEnd.z - bubbleStart.z;

			// calculate bubbles needed for an even distribution
			int numBubbles = int( ( bubbleEnd - bubbleStart ).Length() / 128.0f );
			numBubbles = Math.max( 1, Math.min( 255, numBubbles ) );

			if( m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD )
				te_bubbletrail( bubbleStart, bubbleEnd, "sprites/bubble.spr", waterLevel, numBubbles, 16.0f );
		}
	}

	void CommonSpawn( const string worldModel, const int GiveDefaultAmmo ) // things that are commonly executed in spawn
	{
		m_iShotsFired = 0;
		g_EntityFuncs.SetModel( self, self.GetW_Model( worldModel ) );
		self.m_iDefaultAmmo = GiveDefaultAmmo;
		//self.pev.scale = 1.3;

		self.FallInit();
	}

	bool CommonAddToPlayer( CBasePlayer@ pPlayer ) // adds a weapon to the player
	{
		if( !BaseClass.AddToPlayer( pPlayer ) )
			return false;

		NetworkMessage weapon( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
			weapon.WriteLong( g_ItemRegistry.GetIdForName( self.pev.classname ) );
		weapon.End();

		return true;
	}

	bool CheckButton() // returns which key the player is pressing (that might interrupt the reload)
	{
		return m_pPlayer.pev.button & (IN_ATTACK | IN_ATTACK2 | IN_ALT1) != 0;
	}

	bool CommonPlayEmptySound( const string emptySound = EMPTY_SHOOT_S ) // plays a empty sound when the player has no ammo left in the magazine
	{
		if( self.m_bPlayEmptySound )
		{
			//self.m_bPlayEmptySound = false;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_STREAM, emptySound, 0.9, 1.5, 0, PITCH_NORM );
		}

		return false;
	}

	float WeaponTimeBase() // map time
	{
		return g_Engine.time;
	}

	private int SaveSecAmmo, ReloadedSecAmmo;
	void ReloadSecondary( int iAmmo, int iAnim, float flTimer, int iBodygroup ) //sets timer to remove secondary ammo
	{
		if( self.m_fInReload )
			return;

		SetThink( null );

		ReloadedSecAmmo = iAmmo;

		self.m_fInReload = true;

		self.SendWeaponAnim( iAnim, 0, iBodygroup );
		m_pPlayer.m_flNextAttack = flTimer;
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + flTimer;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + flTimer;

		SetThink( ThinkFunction( this.RemoveSecAmmo ) );
		self.pev.nextthink = g_Engine.time + flTimer - 0.2;
	}

	void RemoveSecAmmo() // removes secondary ammo
	{
		SetThink( null );
		SaveSecAmmo = m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType );
		SaveSecAmmo -= ReloadedSecAmmo;
		self.m_iClip2 = ReloadedSecAmmo;
		self.m_fInReload = false;
		m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, SaveSecAmmo );
	}

	void Reload( int iAmmo, int iAnim, float iTimer, int iBodygroup ) // things commonly executed in reloads
	{
		self.m_fInReload = true;
		self.DefaultReload( iAmmo, iAnim, iTimer, iBodygroup );
		m_iShotsFired = 0;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + iTimer;
	}

	protected bool m_fDropped;
	CBasePlayerItem@ DropItem() // drops the item
	{
		m_fDropped = true;
		WeaponGLMode = GL_NOTAIMED;
		//self.pev.scale = 1.3;
		//SetThink( null );
		return self;
	}

	bool Deploy( string vmodel, string pmodel, int iAnim, string pAnim, int iBodygroup, float deployTime ) // deploys the weapon
	{
		m_fDropped = false;
		//self.pev.scale = 0;
		self.DefaultDeploy( self.GetV_Model( vmodel ), self.GetP_Model( pmodel ), iAnim, pAnim, 0, iBodygroup );
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + deployTime;
		return true;
	}

	void DestroyThink() // destroys the item
	{
		SetThink( null );
		self.DestroyItem();
		//g_Game.AlertMessage( at_console, "Item Destroyed.\n" );
	}

	// Precise shell casting
	void GetDefaultShellInfo( CBasePlayer@ pPlayer, Vector& out ShellVelocity, Vector& out ShellOrigin, float forwardScale, float rightScale, float upScale, bool leftShell, bool downShell )
	{
		Vector vecForward, vecRight, vecUp;

		g_EngineFuncs.AngleVectors( pPlayer.pev.v_angle, vecForward, vecRight, vecUp );

		const float fR = (leftShell == true) ? Math.RandomFloat( -120, -60 ) : Math.RandomFloat( 60, 120 );
		const float fU = (downShell == true) ? Math.RandomFloat( -150, -90 ) : Math.RandomFloat( 90, 150 );

		for( int i = 0; i < 3; ++i )
		{
			ShellVelocity[i] = pPlayer.pev.velocity[i] + vecRight[i] * fR + vecUp[i] * fU + vecForward[i] * Math.RandomFloat( 1, 50 );
			ShellOrigin[i]   = pPlayer.pev.origin[i] + pPlayer.pev.view_ofs[i] + vecUp[i] * upScale + vecForward[i] * forwardScale + vecRight[i] * rightScale;
		}
	}

	void CommonHolster() // things that plays on holster
	{
		self.m_fInReload = false;
		canReload = false;
		SetThink( null );
		ToggleZoom( 0 );
		m_iShotsFired = 0;
		WeaponADSMode = IRON_OUT;
		m_pPlayer.ResetVModelPos();
		SetPlayerSpeed();
		m_pPlayer.pev.fuser4 = 0;
		m_pPlayer.pev.maxspeed = 0;
		FiremodesSpr( FiremodesPos, 0, 0, 0 );
	}

	// Realistic Firerate
	double GetFireRate( double& in roundspmin )
	{
		double firerate;
		roundspmin = (roundspmin / 60.0);
		firerate = (1.0 / roundspmin);
		return firerate;
	}

	// Dynamic light effects
	void DynamicLight( Vector& in vecPos, int& in radius, Vector& in RGB, int8& in life, int& in decay ) 
	{
		NetworkMessage DLight( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY );
			DLight.WriteByte( TE_DLIGHT );
			DLight.WriteCoord( vecPos.x );
			DLight.WriteCoord( vecPos.y );
			DLight.WriteCoord( vecPos.z );
			DLight.WriteByte( radius );
			DLight.WriteByte( int(RGB.x) );
			DLight.WriteByte( int(RGB.y) );
			DLight.WriteByte( int(RGB.z) );
			DLight.WriteByte( life );
			DLight.WriteByte( decay );
		DLight.End();
	}

	void SetFOV( int fov ) // FoV related method
	{
		m_pPlayer.pev.fov = m_pPlayer.m_iFOV = fov;
	}
	
	void ToggleZoom( int zoomedFOV ) // FoV related method
	{
		if ( self.m_fInZoom == true )
		{
			SetFOV( 0 ); // 0 means reset to default fov
		}
		else if ( self.m_fInZoom == false )
		{
			SetFOV( zoomedFOV );
		}
	}

	// GeckoN: Movement speed modifier
	void SetPlayerSpeed()
	{
		const int iType = WeaponADSMode;

		// Do we even need to change the speed?
		if( WeaponADSMode == m_iSpeedType )
			return;

		// Remove previous speed reduction we applied
		m_pPlayer.m_flEffectSpeed += m_flSpeedModifier;

		if( WeaponBipodMode == BIPOD_UNDEPLOYED )
		{
			if( WeaponADSMode == IRON_IN )
				m_flSpeedModifier = 0.35f; // Scoped, 35% speed reduction
			else if( WeaponADSMode == IRON_OUT )
				m_flSpeedModifier = 0.0f; // Not holding or dropping weapon
			else
				m_flSpeedModifier = 0.0f; // Not holding or dropping weapon

			m_pPlayer.m_flEffectSpeed -= m_flSpeedModifier;

			//Do not let the player lose these effects when applying the speed modifier - KernCore
			m_pPlayer.m_iEffectInvulnerable = (m_pPlayer.pev.flags & FL_GODMODE != 0) ? 1 : 0;
			m_pPlayer.m_iEffectNonSolid = (m_pPlayer.pev.solid == SOLID_NOT) ? 1 : 0;

			if( m_pPlayer.pev.flags & FL_NOTARGET != 0 ) // Has notarget on
			{
				int rendermode = m_pPlayer.pev.rendermode;
				float renderamt = m_pPlayer.pev.renderamt;
				m_pPlayer.ApplyEffects();
				m_pPlayer.pev.flags |= FL_NOTARGET;
				m_pPlayer.pev.rendermode = rendermode;
				m_pPlayer.pev.renderamt = renderamt;
			}
			else
			{
				m_pPlayer.ApplyEffects();
			}
			//KernCore end
		}
		m_iSpeedType = WeaponADSMode;
	}

	void EffectsFOVON( int value ) // apply FoV effects on the player
	{
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, AimDownSights_in[ Math.RandomLong( 0, AimDownSights_in.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
		ToggleZoom( value );
		WeaponADSMode = IRON_IN;
		m_pPlayer.SetVModelPos( Vector( 0, 0, 0 ) );
		SetPlayerSpeed();
	}

	void EffectsFOVOFF() // remove FoV effects from the player
	{
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, AimDownSights_out[ Math.RandomLong( 0, AimDownSights_out.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
		ToggleZoom( 0 );
		WeaponADSMode = IRON_OUT;
		m_pPlayer.ResetVModelPos();
		SetPlayerSpeed();
	}

	void DisplayFiremodeSprite() // displays the fire mode sprite in the HUD
	{
		switch( WeaponSelectFireMode )
		{
			case SELECTFIRE_AUTO:
				FiremodesSpr( FiremodesPos, 0, -1 );
				break;
			
			case SELECTFIRE_3XBURST:
				FiremodesSpr( FiremodesPos, 1, -1 );
				break;

			case SELECTFIRE_SEMI:
				FiremodesSpr( FiremodesPos, 2, -1 );
				break;

			case SELECTFIRE_2XBURST:
				FiremodesSpr( FiremodesPos, 3, -1 );
				break;

			case SELECTFIRE_4XAUTO:
				FiremodesSpr( FiremodesPos, 4, -1 );
				break;
		}
		FiremodesTxt();
	}

	void ChangeFireMode( int iAnim, int iBodygroup, int FirstFireMode, int SecondFireMode, float flTimer ) // switch fire modes (support for only 2 modes)
	{
		if( m_pPlayer.pev.button & IN_USE == 0 || m_pPlayer.pev.button & IN_RELOAD == 0 )
			return;
		else if( (m_pPlayer.pev.button & IN_USE != 0) && (m_pPlayer.pev.button & IN_RELOAD != 0) )
		{
			if( m_useTimer < g_Engine.time )
			{
				if( WeaponSelectFireMode == FirstFireMode )
				{
					self.SendWeaponAnim( iAnim, 0, iBodygroup );
					WeaponSelectFireMode = SecondFireMode;
					//m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, (g_iMode_burst == CoF_MODE_AUTO) ? 5 : 1 );
				}
				else if( WeaponSelectFireMode == SecondFireMode )
				{
					self.SendWeaponAnim( iAnim, 0, iBodygroup );
					WeaponSelectFireMode = FirstFireMode;
					//m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, (g_iMode_burst == CoF_MODE_AUTO) ? 5 : 1 );
				}
				DisplayFiremodeSprite();

				m_useTimer = g_Engine.time + flTimer;
				m_pPlayer.m_flNextAttack = flTimer;
				self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + flTimer;
			}
		}
	}

	void ShellEject( CBasePlayer@ pPlayer, int& in mShell, Vector& in Pos, bool leftShell = false, bool downShell = false, TE_BOUNCE shelltype = TE_BOUNCE_SHELL ) // eject spent shell casing
	{
		Vector vecShellVelocity, vecShellOrigin;
		GetDefaultShellInfo( pPlayer, vecShellVelocity, vecShellOrigin, Pos.x, Pos.y, Pos.z, leftShell, downShell ); //23 4.75 -5.15
		vecShellVelocity.y *= 1;
		g_EntityFuncs.EjectBrass( vecShellOrigin, vecShellVelocity, pPlayer.pev.angles.y, mShell, shelltype );
	}

	void PunchAngle( Vector& in vPunch ) // aimed recoil
	{
		if( WeaponBipodMode == BIPOD_UNDEPLOYED )
		{
			m_pPlayer.pev.punchangle.x = (WeaponADSMode == IRON_IN) ? (vPunch.x*0.50) : vPunch.x;
			m_pPlayer.pev.punchangle.y = (WeaponADSMode == IRON_IN) ? (vPunch.y*0.75) : vPunch.y;
			m_pPlayer.pev.punchangle.z = (WeaponADSMode == IRON_IN) ? (vPunch.z*0.25) : vPunch.z;
		}
		else
		{
			m_pPlayer.pev.punchangle.x = (WeaponADSMode == IRON_IN) ? (vPunch.x*0.25) : (vPunch.x*0.40);
			m_pPlayer.pev.punchangle.y = (WeaponADSMode == IRON_IN) ? (vPunch.y*0.50) : (vPunch.y*0.60);
			m_pPlayer.pev.punchangle.z = (WeaponADSMode == IRON_IN) ? (vPunch.z*0.20) : (vPunch.z*0.25);
		}
	}

	void DynamicTracer( Vector start, Vector end ) // create tracer message
	{
		NetworkMessage DTracer( MSG_PVS, NetworkMessages::SVC_TEMPENTITY, null );
			DTracer.WriteByte( TE_TRACER );
			DTracer.WriteCoord( start.x );
			DTracer.WriteCoord( start.y );
			DTracer.WriteCoord( start.z );
			DTracer.WriteCoord( end.x );
			DTracer.WriteCoord( end.y );
			DTracer.WriteCoord( end.z );
		DTracer.End();
	}

	void PlayTracer( Vector& in vecAttachOrigin, Vector& in vecAttachAngles, TraceResult& in tr ) // play tracer message
	{
		g_EngineFuncs.GetAttachment( m_pPlayer.edict(), 0, vecAttachOrigin, vecAttachAngles );
		DynamicTracer( vecAttachOrigin + g_Engine.v_forward * 64, tr.vecEndPos );
	}

	//Accuracy Cone Modificator
	Vector VecModAcc( Vector& in VecCone, float flFlyMod, float flDuckMod, float flMovMod ) // accuracy modifier, depends on the player instance
	{
		//g_Game.AlertMessage( at_console, "Vector Accuracy X1: " + VecCone.x + "\n" + "Vector Accuracy Y1: " + VecCone.y + "\n" + "Vector Accuracy Z1: " + VecCone.z + "\n");

		if( m_pPlayer.pev.flags & FL_ONGROUND == 0 ) //Player is in the air, not touching the ground
		{
			VecCone = VecCone * flFlyMod;
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 || WeaponBipodMode == BIPOD_DEPLOYED ) //Player is ducking or has the bipod deployed
		{
			VecCone = VecCone * flDuckMod;
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 ) //Player is moving around
		{
			VecCone = VecCone * flMovMod;
		}

		if( WeaponSelectFireMode == SELECTFIRE_SEMI )
			VecCone = VecCone * 0.9f;

		if( WeaponADSMode == IRON_IN )
			VecCone = VecCone * 0.85f;

		if( m_pPlayer.pev.fov < 25 )
			VecCone = VecCone * 0.75f;

		//g_Game.AlertMessage( at_console, "Vector Accuracy X2: " + VecCone.x + "\n" + "Vector Accuracy Y2: " + VecCone.y + "\n" + "Vector Accuracy Z2: " + VecCone.z + "\n");

		return VecCone;
	}

	bool IsWeaponEmpty()
	{
		return self.m_iClip <= 0 && self.iMaxClip() != WEAPON_NOCLIP;
	}

	bool IsNoclipWeaponEmpty()
	{
		return m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 && self.iMaxClip() == WEAPON_NOCLIP;
	}

	void ShootWeapon( const string Sound, const uint numShots, Vector& in CONE, float maxDist, int Damage, const bool shouldTrace = false, const int DmgType = DMG_GENERIC ) // pew pew
	{
		if( Sound != string_t() || Sound != "" )
		{
			if( self.m_iClip != 0 && self.iMaxClip() != WEAPON_NOCLIP )
				--self.m_iClip;
			else if( self.iMaxClip() == WEAPON_NOCLIP )
				m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

			++m_iShotsFired;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, Sound, Math.RandomFloat( 0.95, 1.0 ), 0.55, 0, 93 + Math.RandomLong( 0, 0xf ) );
		}

		Vector vecSrc   	= m_pPlayer.GetGunPosition();
		Vector vecAiming 	= m_pPlayer.GetAutoaimVector( AUTOAIM_2DEGREES );

		//Math.MakeAimVectors( vecAiming );

		m_pPlayer.FireBullets( numShots, vecSrc, vecAiming, VECTOR_CONE_1DEGREES, maxDist, BULLET_PLAYER_CUSTOMDAMAGE, 2, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? int(Damage / 2) : Damage );

		if( IsWeaponEmpty() && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );

		m_pPlayer.pev.effects |= EF_MUZZLEFLASH;
		self.pev.effects |= EF_MUZZLEFLASH;
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		//g_PlayerFuncs.ConcussionEffect( m_pPlayer, 100, 1, 0.1 );
		if( DmgType & DMG_BULLET == 0 ) //For silenced weapons
			DynamicLight( m_pPlayer.EyePosition() + g_Engine.v_forward * 64, 18, Vector(255, 232, 156), 1, 100 );

		if( IsWeaponEmpty() )
			m_pPlayer.m_flNextAttack = 0.4;

		TraceResult tr;
		float x, y;

		for( uint uiPellet = 0; uiPellet < numShots; ++uiPellet )
		{
			g_Utility.GetCircularGaussianSpread( x, y );

			Vector vecDir = vecAiming + x * CONE.x * g_Engine.v_right + y * CONE.y * g_Engine.v_up;
			Vector vecEnd = vecSrc + vecDir * maxDist;

			g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

			if( shouldTrace )
			{
				if( Math.RandomLong( 0, 10 ) < 4 )
				{
					Vector vecTracerOr, vecTracerAn;
					PlayTracer( (WeaponADSMode == IRON_OUT) ? vecTracerOr : vecSrc, vecTracerAn, tr );
				}
			}

			if( tr.flFraction < 1.0 )
			{
				if( tr.pHit !is null )
				{
					CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );

					if( DmgType != DMG_GENERIC )
					{
						if( pHit !is null )
						{
							g_WeaponFuncs.ClearMultiDamage();
							pHit.TraceAttack( m_pPlayer.pev, (DmgType & DMG_BLAST != 0) ? (Damage * 0.2) : (Damage * 0.3636), vecEnd, tr, DmgType );
							g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );
						}
					}

					g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + (vecEnd - vecSrc) * 2, BULLET_PLAYER_CUSTOMDAMAGE );

					if( tr.fInWater == 0.0 )
						water_bullet_effects( vecSrc, tr.vecEndPos );
					
					if( pHit is null || pHit.IsBSPModel() == true )
					{
						g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_CUSTOMDAMAGE );
						//g_Utility.Sparks( tr.vecEndPos );
					}
				}
			}
		}
	}

	void ClipCasting( const Vector& in origin, const Vector& in velocity, int iModel, bool i_isRevolver, int quantity ) // drop magazines
	{
		int lifetime = 100;
		int i = 0;

		if( i_isRevolver == true )
		{
			while( i < quantity )
			{
				NetworkMessage buldrop( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY );
					buldrop.WriteByte( TE_MODEL );
					buldrop.WriteCoord( origin.x );
					buldrop.WriteCoord( origin.y );
					buldrop.WriteCoord( origin.z );
					buldrop.WriteCoord( velocity.x + Math.RandomLong( -20, 20 ) ); // velocity
					buldrop.WriteCoord( velocity.y + Math.RandomLong( -20, 20 ) ); // velocity
					buldrop.WriteCoord( velocity.z + Math.RandomLong( -20, 20 ) ); // velocity
					buldrop.WriteAngle( Math.RandomFloat( 0, 180 ) ); // yaw
					buldrop.WriteShort( iModel ); // model
					buldrop.WriteByte( 1 ); // bouncesound
					buldrop.WriteByte( int( lifetime ) ); // decay time
				buldrop.End();
				i++;
			}
		}
		else
		{
			NetworkMessage magdrop( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
				magdrop.WriteByte( TE_BREAKMODEL );
				magdrop.WriteCoord( origin.x + 2 );
				magdrop.WriteCoord( origin.y );
				magdrop.WriteCoord( origin.z + Math.RandomLong( 4, 6 ) );
				magdrop.WriteCoord( 0 ); //size
				magdrop.WriteCoord( 0 ); //size
				magdrop.WriteCoord( 0 ); //size
				magdrop.WriteCoord( velocity.x + Math.RandomLong( -10, 10 ) );
				magdrop.WriteCoord( velocity.y + Math.RandomLong( -10, 10 ) );
				magdrop.WriteCoord( velocity.z + Math.RandomLong( -10, 10 ) );
				magdrop.WriteByte( 2 ); //speedNoise
				magdrop.WriteShort( iModel );
				magdrop.WriteByte( 1 ); //count
				magdrop.WriteByte( lifetime ); //time
				magdrop.WriteByte( 2 ); //flags
			magdrop.End();
		}
	}

	void KickBack( float up_base, float lateral_base, float up_modifier, float lateral_modifier, float up_max, float lateral_max, int direction_change ) // cs1.6 like recoil
	{
		float flFront, flSide;

		if( m_iShotsFired == 1 )
		{
			flFront = up_base;
			flSide = lateral_base;
		}
		else
		{
			flFront = m_iShotsFired * up_modifier + up_base;
			flSide = m_iShotsFired * lateral_modifier + lateral_base;
		}

		m_pPlayer.pev.punchangle.x -= flFront;

		if( m_pPlayer.pev.punchangle.x < -up_max )
			m_pPlayer.pev.punchangle.x = -up_max;

		if( m_iDirection )
		{
			m_pPlayer.pev.punchangle.y += flSide;

			if( m_pPlayer.pev.punchangle.y > lateral_max )
				m_pPlayer.pev.punchangle.y = lateral_max;
		}
		else
		{
			m_pPlayer.pev.punchangle.y -= flSide;

			if( m_pPlayer.pev.punchangle.y < -lateral_max )
				m_pPlayer.pev.punchangle.y = -lateral_max;
		}

		if( Math.RandomLong( 0, direction_change ) == 0 )
		{
			m_iDirection = !m_iDirection;
		}
	}

	void FiremodesSpr( Vector2D POS, int frame, float holdTime = 1.0, int alpha = 255 ) // send firemode HUD sprites
	{
		HUDSpriteParams params;
		params.channel = 4;

		// Default mode is additive, so no flag is needed to assign it
		params.flags = HUD_ELEM_ABSOLUTE_X | HUD_ELEM_ABSOLUTE_Y | HUD_ELEM_DYNAMIC_ALPHA;
		params.spritename = FIREMODE_SPRT;
		params.left = 0; // Offset
		params.top = 0; // Offset
		params.width = 0; // 0: auto; use total width of the sprite
		params.height = 0; // 0: auto; use total height of the sprite

		// Pre-flag positions
		//params.x = 0.94;
		//params.y = 0.92;
		params.x = POS.x;
		params.y = POS.y;

		// Default Sven HUD colors
		params.color1 = RGBA( 100, 130, 200, alpha );
		params.color2 = RGBA( 255, 0, 0, alpha );
		// Frame management
		params.frame = frame;
		params.numframes = 3;
		params.framerate = 0;

		// Fading times, I expect the player to immediately see the icon (low fadeinTime) and slowly make it disappear (high fadeoutTime)
		params.fadeinTime = 0.2;
		params.fadeoutTime = 0.5;
		// Hold it on screen for a good amount of time (3 seconds)
		params.holdTime = holdTime;
		params.effect = HUD_EFFECT_NONE;

		g_PlayerFuncs.HudCustomSprite( m_pPlayer, params );
	}

	void FiremodesTxt() // displays text on the player's hud so he knows how to change the firemode
	{
		HUDTextParams params;
		params.channel = 4;
		params.fadeinTime = 0;
		params.fadeoutTime = 0.7;
		params.holdTime = 1.0;
		params.effect = 0;
		params.x = 0.9595f;
		params.y = 0.857f;
		params.r1 = RGBA_SVENCOOP.r;
		params.g1 = RGBA_SVENCOOP.g;
		params.b1 = RGBA_SVENCOOP.b;
		params.a1 = 255;
		g_PlayerFuncs.HudMessage( m_pPlayer, params, "E + R" );
	}

	void GrenadeLauncherSwitch( int iAnim, int iAnim2, int iBodygroup, float flTimer, float flTimer2 ) // switch to the Grenade Launcher
	{
		if( WeaponGLMode == GL_NOTAIMED )
		{
			self.SendWeaponAnim( iAnim, 0, iBodygroup );
			WeaponGLMode = GL_AIMED;
			m_pPlayer.m_flNextAttack = flTimer;
			self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + flTimer;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + flTimer;
		}
		else
		{
			self.SendWeaponAnim( iAnim2, 0, iBodygroup );
			WeaponGLMode = GL_NOTAIMED;
			m_pPlayer.m_flNextAttack = flTimer2;
			self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + flTimer2;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + flTimer2;
		}
		//EffectsFOVOFF();
	}
}

mixin class MeleeWeaponBase
{
	// For Bayonet Sounds
	protected array<string> BayoHitFlesh = {
		"ins2/wpn/hitb1.ogg",
		"ins2/wpn/hitb2.ogg",
		"ins2/wpn/hitb3.ogg",
		"ins2/wpn/hitb4.ogg"
	};
	protected array<string> BayoHitWorld = {
		"ins2/wpn/hitw1.ogg",
		"ins2/wpn/hitw2.ogg",
		"ins2/wpn/hitw3.ogg",
		"ins2/wpn/hitw4.ogg"
	};
	// For Knife Sounds
	protected array<string> KnifeHitFlesh = {
		"ins2/wpn/knife/hitb1.ogg",
		"ins2/wpn/knife/hitb2.ogg",
		"ins2/wpn/knife/hitb3.ogg",
		"ins2/wpn/knife/hitb4.ogg"
	};
	protected array<string> SwingMelee = {
		"ins2/wpn/knife/swg1.ogg",
		"ins2/wpn/knife/swg2.ogg",
		"ins2/wpn/knife/swg3.ogg",
		"ins2/wpn/knife/swg4.ogg"
	};

	protected TraceResult m_trHit;

	// For actual melee weapons
	bool Smack( float flDistance, float flAttSpd, float flDamage, float anim_time, string s_HitBody, string s_HitWall, int dmgBits )
	{
		TraceResult tr;
		bool fDidHit = false;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecEnd	= vecSrc + g_Engine.v_forward * flDistance;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if ( tr.flFraction >= 1.0 )
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
			if ( tr.flFraction < 1.0 )
			{
				// Calculate the point of intersection of the line (or hull) and the object we hit
				// This is and approximation of the "best" intersection
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				if ( pHit is null || pHit.IsBSPModel() == true )
					g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
				vecEnd = tr.vecEndPos;	// This is the point on the actual surface (the hull could have hit space)
			}
		}

		if ( tr.flFraction >= 1.0 )
		{
			// miss
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flAttSpd;
			self.m_flTimeWeaponIdle = g_Engine.time + anim_time;
			// player "shoot" animation
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		}
		else
		{
			// hit
			fDidHit = true;
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

			// player "shoot" animation
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

			// AdamR: Custom damage option
			if( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;
			// AdamR: End

			g_WeaponFuncs.ClearMultiDamage();

			if( self.m_flNextPrimaryAttack + flAttSpd < g_Engine.time )
			{
				// first swing does full damage
				pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, dmgBits );  
			}
			else
			{
				// subsequent swings do 75% (Changed -Sniper)
				pEntity.TraceAttack( m_pPlayer.pev, flDamage * 0.75, g_Engine.v_forward, tr, dmgBits | DMG_NEVERGIB );  
			}
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

			// play thwack, smack, or dong sound
			float flVol = 1.0;
			bool fHitWorld = true;

			if( pEntity !is null )
			{
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flAttSpd;
				self.m_flTimeWeaponIdle = g_Engine.time + anim_time;

				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
					if( pEntity.IsPlayer() == true )
					{
						pEntity.pev.velocity = pEntity.pev.velocity + ( self.pev.origin - pEntity.pev.origin ).Normalize() * 120;
					}

					// play thwack or smack sound
					g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, s_HitBody, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );

					m_pPlayer.m_iWeaponVolume = 128; 
					if( pEntity.IsAlive() == false )
					{
						return true;
					}
					else
						flVol = 0.1;

					fHitWorld = false;
				}
			}

			// play texture hit sound
			// UNDONE: Calculate the correct point of intersection when we hit with the hull instead of the line
			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + (vecEnd - vecSrc) * 2, BULLET_PLAYER_CUSTOMDAMAGE );

				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + flAttSpd;
				self.m_flTimeWeaponIdle = g_Engine.time + anim_time;

				// override the volume here, cause we don't play texture sounds in multiplayer, 
				// and fvolbar is going to be 0 from the above call.

				fvolbar = 1;
				// also play crowbar strike
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, s_HitWall, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0, 0xF ) );
			}

			m_trHit = tr;
			g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
			m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
		}

		return fDidHit;
	}

	// For weapon bayonets
	bool Swing( int fFirst, float fldistance, int ianimation, int ibodygroup, float flattack_speed, float flDamage )
	{
		bool fDidHit = false;

		TraceResult tr;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecEnd	= vecSrc + g_Engine.v_forward * fldistance;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if( tr.flFraction >= 1.0 )
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
			if ( tr.flFraction < 1.0 )
			{
				// Calculate the point of intersection of the line (or hull) and the object we hit
				// This is and approximation of the "best" intersection
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				if ( pHit is null || pHit.IsBSPModel() )
					g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );

				vecEnd = tr.vecEndPos;	// This is the point on the actual surface (the hull could have hit space)
			}
		}

		if( tr.flFraction >= 1.0 )
		{
			if( fFirst != 0 )
			{
				// miss
				self.SendWeaponAnim( ianimation, 0, ibodygroup );

				EffectsFOVOFF();
				//m_pPlayer.pev.punchangle.z = Math.RandomLong( -7, -5 );
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;
			}
		}
		else
		{
			// hit
			fDidHit = true;
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

			self.SendWeaponAnim( ianimation, 0, ibodygroup );
			EffectsFOVOFF();
			//m_pPlayer.pev.punchangle.z = Math.RandomLong( -7, -5 );

			if ( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;

			g_WeaponFuncs.ClearMultiDamage();
			if ( self.m_flNextTertiaryAttack + flattack_speed < g_Engine.time )
			{
				// first swing does full damage and will launch the enemy a bit
				pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB | DMG_LAUNCH );
			}
			else
			{
				// subsequent swings do 75% (Changed -Sniper/KernCore) (75% less damage)
				pEntity.TraceAttack( m_pPlayer.pev, flDamage * 0.75, g_Engine.v_forward, tr, DMG_CLUB | DMG_LAUNCH );
			}	
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

			float flVol = 1.0;
			bool fHitWorld = true;

			if( pEntity !is null )
			{
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;

				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
					if( pEntity.IsPlayer() )
					{
						pEntity.pev.velocity = pEntity.pev.velocity + (self.pev.origin - pEntity.pev.origin).Normalize() * 120;
					}

					g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_ITEM, BayoHitFlesh[ Math.RandomLong( 0, BayoHitFlesh.length() - 1 )], 1, ATTN_NORM );

					m_pPlayer.m_iWeaponVolume = 128; 
					if( !pEntity.IsAlive() )
						return true;
					else
						flVol = 0.1;

					fHitWorld = false;
				}
			}

			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + (vecEnd - vecSrc) * 2, BULLET_PLAYER_CROWBAR | BULLET_NONE );
				
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;
				
				// override the volume here, cause we don't play texture sounds in multiplayer, 
				// and fvolbar is going to be 0 from the above call.
				fvolbar = 1;

				// also play crowbar strike
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, BayoHitWorld[ Math.RandomLong( 0, BayoHitWorld.length() - 1 )], fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
			}

			// delay the decal a bit
			m_trHit = tr;
			g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
			m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
		}
		return fDidHit;
	}
}

mixin class BipodWeaponBase
{
	protected TraceResult trForward, trDown;

	void ShowBipodSpriteThink()
	{
		self.pev.nextthink = g_Engine.time + 0.2;

		if( m_pPlayer.pev.waterlevel > WATERLEVEL_FEET || m_pPlayer.IsOnLadder() || m_pPlayer.pev.flags & FL_ONGROUND == 0 )
			return;

		if( m_pPlayer.pev.v_angle.x <= -59.9f || m_pPlayer.pev.v_angle.x >= 76.70f )
			return;

		g_Utility.TraceLine( m_pPlayer.GetGunPosition(), m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32, ignore_monsters, m_pPlayer.edict(), trForward );
		g_Utility.TraceLine( trForward.vecEndPos, trForward.vecEndPos + g_Engine.v_up * -24, ignore_monsters, m_pPlayer.edict(), trDown );

		if( trForward.flFraction >= 1.0 || trDown.flFraction >= 1.0 )
		{
			if( trDown.flFraction < 1.0 )
				BipodSpr( BipodStatePos, 0.5f );
		}
	}

	void BipodSpr( Vector2D POS, float holdTime = 1.0, uint8 alpha = 255, Vector RGB = Vector( 100, 130, 200 ) ) // send sprites
	{
		HUDSpriteParams params;

		params.channel = 3;

		// Default mode is additive, so no flag is needed to assign it
		params.flags = HUD_ELEM_ABSOLUTE_X | HUD_ELEM_ABSOLUTE_Y | HUD_ELEM_DYNAMIC_ALPHA;
		params.spritename = BIPODMOD_SPRT;
		params.left = 0; // Offset
		params.top = 0; // Offset
		params.width = 0; // 0: auto; use total width of the sprite
		params.height = 0; // 0: auto; use total height of the sprite

		params.x = POS.x;
		params.y = POS.y;

		params.color1 = RGBA( uint8(RGB.x), uint8(RGB.y), uint8(RGB.z), alpha );
		//params.color2 = RGBA( RGB.x, RGB.y, RGB.z, alpha );

		// Frame management
		params.frame = 0;
		params.numframes = 1;
		params.framerate = 0;

		// Fading times, I expect the player to immediately see the icon (low fadeinTime) and slowly make it disappear (high fadeoutTime)
		params.fadeinTime = 0; // 0 prevents the sprite from disappearing if the some key is pressed
		params.fadeoutTime = 0.4;
		// Hold it on screen for a good amount of time (-1 = always)
		params.holdTime = holdTime;
		params.effect = HUD_EFFECT_NONE;

		g_PlayerFuncs.HudCustomSprite( m_pPlayer, params );
	}

	void DisplayBipodSprite()
	{
		BipodSpr( BipodStatePos, -1 );
	}

	void DeployBipod( int iAnimDeploy, int iAnimUndeploy, int iBodygroup, float flTimer, float flTimer2 )
	{
		if( WeaponBipodMode == BIPOD_DEPLOYED )
		{
			self.SendWeaponAnim( iAnimUndeploy, 0, iBodygroup );
			WeaponBipodMode = BIPOD_UNDEPLOYED;
			self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + flTimer;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + flTimer2;
			m_pPlayer.pev.fuser4 = 0;
			m_pPlayer.pev.maxspeed = 0;
			return;
		}

		//g_Game.AlertMessage( at_console, "Angle x: " + m_pPlayer.pev.v_angle.x + "\n" + "Angle y: " + m_pPlayer.pev.v_angle.y + "\n" + "Angle z: " + m_pPlayer.pev.v_angle.z + "\n" );
		if( m_pPlayer.pev.waterlevel > WATERLEVEL_FEET )
		{
			BipodSpr( BipodStatePos, 1, 255, Vector( 255, 0, 0 ) );
			g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Cannot deploy bipod while on the water\n" );
			return;
		}

		if( m_pPlayer.IsOnLadder() )
		{
			BipodSpr( BipodStatePos, 1, 255, Vector( 255, 0, 0 ) );
			g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Cannot deploy bipod on a ladder\n" );
			return;
		}

		if( m_pPlayer.pev.flags & FL_ONGROUND == 0 )
		{
			BipodSpr( BipodStatePos, 1, 255, Vector( 255, 0, 0 ) );
			g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Cannot deploy bipod while\nnot on the ground\n" );
			return;
		}

		g_Utility.TraceLine( m_pPlayer.GetGunPosition(), m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32, ignore_monsters, m_pPlayer.edict(), trForward );
		g_Utility.TraceLine( trForward.vecEndPos, trForward.vecEndPos + g_Engine.v_up * -24, ignore_monsters, m_pPlayer.edict(), trDown );

		if( trForward.flFraction >= 1.0 )
		{
			if( trDown.flFraction < 1.0 )
			{
				if( m_pPlayer.pev.v_angle.x < -59.9 || m_pPlayer.pev.v_angle.x > 76.70 )
				{
					BipodSpr( BipodStatePos, 1, 255, Vector( 255, 0, 0 ) );
					g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Cannot deploy bipod on \ncurrent view angle\n" );
					return;
				}

				if( WeaponBipodMode == BIPOD_UNDEPLOYED )
				{
					self.SendWeaponAnim( iAnimDeploy, 0, iBodygroup );
					WeaponBipodMode = BIPOD_DEPLOYED;
					self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + flTimer;
					self.m_flTimeWeaponIdle = WeaponTimeBase() + flTimer;
					m_pPlayer.pev.maxspeed = -1;
					m_pPlayer.pev.fuser4 = 1;
					return;
				}
			}
		}

		g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Find a surface to deploy the bipod\n" );
		BipodSpr( BipodStatePos, 1, 255, Vector( 255, 0, 0 ) );
	}
}

mixin class AmmoBase
{
	void CommonPrecache()
	{
		g_SoundSystem.PrecacheSound( AMMO_PICKUP_S );
		g_Game.PrecacheGeneric( "sound/" + AMMO_PICKUP_S );
	}
	
	bool CommonAddAmmo( CBaseEntity& inout pOther, int& in iAmmoClip, int& in iAmmoCarry, string& in iAmmoType )
	{
		if( pOther.GiveAmmo( iAmmoClip, iAmmoType, iAmmoCarry ) != -1 )
		{
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, AMMO_PICKUP_S, 1, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 0xa ) );
			return true;
		}
		return false;
	}
}

mixin class ExplosiveBase
{
	// For Grenade Explosion Sounds
	protected array<string> GrenadeExplode = {
		"ins2/wpn/gren/det1.ogg",
		"ins2/wpn/gren/det2.ogg",
		"ins2/wpn/gren/det3.ogg"
	};
	protected array<string> GrenadeWaterExplode = {
		"ins2/wpn/gren/wdet1.ogg",
		"ins2/wpn/gren/wdet2.ogg",
		"ins2/wpn/gren/wdet3.ogg"
	};
	// For Grenade Bounce Sounds
	protected array<string> GrenadeBounce = {
		"ins2/wpn/gren/hit1.ogg",
		"ins2/wpn/gren/hit2.ogg",
		"ins2/wpn/gren/hit3.ogg",
		"ins2/wpn/gren/hit4.ogg"
	};
	// For Rocket Explosion Sounds
	protected array<string> RocketExplode = {
		"ins2/wpn/rckt/det1.ogg",
		"ins2/wpn/rckt/det2.ogg",
		"ins2/wpn/rckt/det3.ogg"
	};
	protected array<string> RocketWaterExplode = {
		"ins2/wpn/rckt/wdet1.ogg",
		"ins2/wpn/rckt/wdet2.ogg",
		"ins2/wpn/rckt/wdet3.ogg"
	};
	// For C4s, Shaped Charges
	protected array<string> ChargeExplode = {
		"ins2/wpn/chrg/det1.ogg",
		"ins2/wpn/chrg/det2.ogg",
		"ins2/wpn/chrg/det3.ogg"
	};
	protected array<string> ChargeWaterExplode = {
		"ins2/wpn/chrg/wdet1.ogg",
		"ins2/wpn/chrg/wdet2.ogg",
		"ins2/wpn/chrg/wdet3.ogg"
	};
	// For C4/TNT Bounce Sounds
	protected array<string> C4Bounce = {
		"ins2/wpn/c4/hit1.ogg",
		"ins2/wpn/c4/hit2.ogg",
		"ins2/wpn/c4/hit3.ogg"
	};
	protected array<string> TNTBounce = {
		"ins2/wpn/tnt/hit1.ogg",
		"ins2/wpn/tnt/hit2.ogg",
		"ins2/wpn/tnt/hit3.ogg"
	};
	string FUSELOOP = "ins2/wpn/tnt/fuse.ogg";
	protected string SPR_EXPLOSION = "sprites/ins2/faexplode1.spr";

	void SelfExplode( CBasePlayer@ pPlayer )
	{
		g_PlayerFuncs.ScreenShake( pPlayer.pev.origin, 15.0, 50.0, 1.0, self.pev.dmg * 2.5 );
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		NetworkMessage exp_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			exp_msg.WriteByte( TE_EXPLOSION ); //MSG type enum
			exp_msg.WriteCoord( self.GetOrigin().x ); //pos
			exp_msg.WriteCoord( self.GetOrigin().y ); //pos
			exp_msg.WriteCoord( self.GetOrigin().z ); //pos
			if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA ) //check if entity is in a liquid
				exp_msg.WriteShort( g_Game.PrecacheModel( "sprites/WXplo1.spr" ) );
			else
				exp_msg.WriteShort( g_Game.PrecacheModel( "sprites/zerogxplode.spr" ) );
			exp_msg.WriteByte( int((pPlayer.HasNamedPlayerItem( self.pev.classname ).pev.dmg - 50) * 0.60) ); //scale
			exp_msg.WriteByte( 15 ); //framerate
			exp_msg.WriteByte( TE_EXPLFLAG_NOSOUND ); //flag
		exp_msg.End();

		g_SoundSystem.PlaySound( self.edict(), CHAN_WEAPON, (iContents == CONTENTS_WATER) ? GrenadeWaterExplode[ Math.RandomLong( 0, GrenadeWaterExplode.length() - 1 )] : 
			GrenadeExplode[ Math.RandomLong( 0, GrenadeExplode.length() - 1 )], 1.0f, ATTN_NORM, 0, PITCH_NORM, 0, false, self.pev.origin );

		g_WeaponFuncs.RadiusDamage( pPlayer.pev.origin, pPlayer.pev, self.pev.owner.vars, pPlayer.HasNamedPlayerItem( self.pev.classname ).pev.dmg, 
			pPlayer.HasNamedPlayerItem( self.pev.classname ).pev.dmg * 2.5, CLASS_NONE, DMG_BLAST );

		SetThink( ThinkFunction( Smoke ) );
		self.pev.nextthink = g_Engine.time + 0.3;

		g_Utility.Sparks( self.GetOrigin() );
		g_Utility.DecalTrace( g_Utility.GetGlobalTrace(), (Math.RandomLong( 0, 1 ) < 0.5) ? DECAL_SCORCH1 : DECAL_SCORCH2 );
		if( iContents != CONTENTS_WATER )
		{
			int sparkCount = Math.RandomLong( 1, 3 );
			for( int i = 0; i < sparkCount; i++ )
				g_EntityFuncs.Create( "spark_shower", self.pev.origin, g_Utility.GetGlobalTrace().vecPlaneNormal, false );
		}
	}

	/*void MsgTraceTexResult( Vector& in vecStart )
	{
		TraceResult tr;
		g_Utility.TraceLine( vecStart, vecStart + Vector( 0, 0, -30 ), ignore_monsters, dont_ignore_glass, self.pev.pContainingEntity, tr );

		string sTexture = g_Utility.TraceTexture( null, vecStart, vecStart + tr.vecEndPos );
		char cType = g_SoundSystem.FindMaterialType( sTexture );
		//g_Game.AlertMessage( at_console, "Texture: " + sTexture + "\n" + "Type: " + cType + "\n" );

		if( sTexture == "sky" || sTexture == "" || sTexture.IsEmpty() )
			return;

		string sGibModel;
		int iFlag;
		if( cType == CHAR_TEX_CONCRETE )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 64;
		}
		else if( cType == CHAR_TEX_METAL )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 2;
		}
		else if( cType == CHAR_TEX_DIRT )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 64;
		}
		else if( cType == CHAR_TEX_VENT )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 2;
		}
		else if( cType == CHAR_TEX_GRATE )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 2;
		}
		else if( cType == CHAR_TEX_TILE )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 0;
		}
		else if( cType == CHAR_TEX_SLOSH )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 0;
		}
		else if( cType == CHAR_TEX_WOOD )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 8;
		}
		else if( cType == CHAR_TEX_COMPUTER )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 2;
		}
		else if( cType == CHAR_TEX_GLASS )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 1;
		}
		else if( cType == CHAR_TEX_FLESH )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 4;
		}
		else if( cType == CHAR_TEX_SNOW )
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 32;
		}
		else
		{
			sGibModel = "models/concrete_gibs.mdl";
			iFlag = 0;
		}

		NetworkMessage m( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			m.WriteByte( TE_BREAKMODEL );
			m.WriteCoord( self.GetOrigin().x );
			m.WriteCoord( self.GetOrigin().y );
			m.WriteCoord( self.GetOrigin().z );
			m.WriteCoord( 1 ); //size
			m.WriteCoord( 1 ); //size
			m.WriteCoord( 1 ); //size
			m.WriteCoord( g_Engine.v_forward.x * 100 );
			m.WriteCoord( g_Engine.v_forward.y * 100 );
			m.WriteCoord( g_Engine.v_forward.z * 100 );
			m.WriteByte( Math.RandomLong( 24, 32 ) ); //SpeedNoise
			m.WriteShort( g_EngineFuncs.ModelIndex( sGibModel ) );
			m.WriteByte( Math.RandomLong( 6, 8 ) ); //count
			m.WriteByte( Math.RandomLong( 8, 12 ) ); //life
			m.WriteByte( iFlag | 16 ); //flags
		m.End();
	}*/

	void ExplodeMsg01( const Vector& in origin, float scale, int framerate )
	{
		int iContents = g_EngineFuncs.PointContents( origin );
		NetworkMessage exp_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			exp_msg.WriteByte( TE_EXPLOSION ); //MSG type enum
			exp_msg.WriteCoord( origin.x ); //pos
			exp_msg.WriteCoord( origin.y ); //pos
			exp_msg.WriteCoord( origin.z ); //pos
			if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA ) //check if entity is in a liquid
				exp_msg.WriteShort( g_Game.PrecacheModel( "sprites/WXplo1.spr" ) );
			else
				exp_msg.WriteShort( g_Game.PrecacheModel( "sprites/zerogxplode.spr" ) );
			exp_msg.WriteByte( int(scale) ); //scale
			exp_msg.WriteByte( framerate ); //framerate
			exp_msg.WriteByte( TE_EXPLFLAG_NOSOUND ); //flag
		exp_msg.End();
	}

	void ExplodeMsg02( const Vector& in origin, float scale, int framerate )
	{
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( !(iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA) )
		{
			NetworkMessage exp2_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
				exp2_msg.WriteByte( TE_EXPLOSION ); //MSG type enum
				exp2_msg.WriteCoord( origin.x ); //pos
				exp2_msg.WriteCoord( origin.y ); //pos
				exp2_msg.WriteCoord( origin.z ); //pos
				exp2_msg.WriteShort( g_Game.PrecacheModel( SPR_EXPLOSION ) );
				exp2_msg.WriteByte( int(scale) ); //scale
				exp2_msg.WriteByte( framerate ); //framerate
				exp2_msg.WriteByte( TE_EXPLFLAG_NOSOUND ); //flag
			exp2_msg.End();
		}
	}

	void SmokeMsg( const Vector& in origin, float scale, int framerate, string spr_path = "sprites/steam1.spr" )
	{
		NetworkMessage smk_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			smk_msg.WriteByte( TE_SMOKE ); //MSG type enum
			smk_msg.WriteCoord( origin.x ); //pos
			smk_msg.WriteCoord( origin.y ); //pos
			smk_msg.WriteCoord( origin.z ); //pos
			smk_msg.WriteShort( g_Game.PrecacheModel( spr_path ) );
			smk_msg.WriteByte( int(scale) ); //scale
			smk_msg.WriteByte( framerate ); //framerate
		smk_msg.End();
	}

	void Smoke()
	{
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		{
			g_Utility.Bubbles( self.GetOrigin() - Vector( 64, 64, 64 ), self.GetOrigin() + Vector( 64, 64, 64 ), 100 );
		}
		else
		{
			NetworkMessage smk_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
				smk_msg.WriteByte( TE_SMOKE ); //MSG type enum
				smk_msg.WriteCoord( self.GetOrigin().x ); //pos
				smk_msg.WriteCoord( self.GetOrigin().y ); //pos
				smk_msg.WriteCoord( self.GetOrigin().z ); //pos
				smk_msg.WriteShort( g_Game.PrecacheModel( "sprites/steam1.spr" ) );
				smk_msg.WriteByte( int((self.pev.dmg - 50) * 0.50) ); //scale
				smk_msg.WriteByte( 15 ); //framerate
			smk_msg.End();
		}
	}
}

}// Namespace end