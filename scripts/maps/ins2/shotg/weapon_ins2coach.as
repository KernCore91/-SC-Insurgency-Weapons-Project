// Insurgency's Double Barrel (Coach Gun)
/* Model Credits
/ Model: Tripwire Interactive
/ Textures: Tripwire Interactive, Norman The Loli Pirate (Edits)
/ Animations: MyZombieKillerz
/ Sounds: GSC Game World (Reload), Navaro (Reload), Tripwire Interactive (Shoot), D.N.I.O. 071 (Conversion to .ogg format) 
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (UV Chop, World Model), D.N.I.O. 071 (Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_COACH
{

// Animations
enum INS2_COACH_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW_FIRST_ALT,
	DRAW,
	HOLSTER,
	FIRE,
	FIRE_LAST,
	FIRE_BOTH,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE,
	IRON_FIRE_LAST,
	IRON_FIRE_BOTH,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM
};

// Models
string W_MODEL = "models/ins2/wpn/coach/w_coach.mdl";
string V_MODEL = "models/ins2/wpn/coach/v_coach.mdl";
string P_MODEL = "models/ins2/wpn/coach/p_coach.mdl";
string A_MODEL = "models/ins2/ammo/12gbox.mdl";
int MAG_BDYGRP = 7;
int MAG_SKIN   = 1;
// Sprites
string SPR_CAT = "ins2/shg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/coach/shoot.ogg";
string EMPTY_S = "ins2/wpn/coach/empty.ogg";
string BOTH_S  = "ins2/wpn/coach/sboth.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 2;
int DEFAULT_GIVE 	= MAX_CLIP * 10;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGEPELLET 	= 8;
uint DAMAGESLUG 	= 50;
uint SLOT       	= 3;
uint POSITION   	= 13;
float RPM_AIR   	= 0.115f; //Rounds per minute in air
string AMMO_TYPE 	= "ins2_12x70buckball";
uint PELLETCOUNT 	= 6;
Vector VECTOR_CONE( 0.03490, 0.03490, 0.0 ); //4x4 DEGREES

class weapon_ins2coach : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/coach/close.ogg",
		"ins2/wpn/coach/open.ogg",
		"ins2/wpn/coach/grab.ogg",
		"ins2/wpn/coach/ins1.ogg",
		"ins2/wpn/coach/ins2.ogg",
		"ins2/wpn/coach/eject.ogg",
		SHOOT_S,
		BOTH_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( A_MODEL );
		m_iShell = g_Game.PrecacheModel( INS2BASE::SHELL_12BLUE );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_DSG.txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_DSG2.txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_BUCK;
		info.iAmmo1Drop	= MAX_CLIP;
		info.iMaxAmmo2 	= -1;
		info.iAmmo2Drop	= -1;
		info.iMaxClip 	= MAX_CLIP;
		info.iSlot  	= SLOT;
		info.iPosition 	= POSITION;
		info.iId     	= g_ItemRegistry.GetIdForName( self.pev.classname );
		info.iFlags 	= FLAGS;
		info.iWeight 	= WEIGHT;

		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		return CommonAddToPlayer( pPlayer );
	}

	bool PlayEmptySound()
	{
		return CommonPlayEmptySound( EMPTY_S );
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, (Math.RandomLong( 0, 1 ) > 0.5) ? DRAW_FIRST_ALT : DRAW_FIRST, "shotgun", GetBodygroup(), (40.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "shotgun", GetBodygroup(), (20.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}

		if( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.115f;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, (WeaponADSMode == INS2BASE::IRON_IN) ? g_vecZero : VECTOR_CONE_1DEGREES, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 3072, DAMAGESLUG, false, DMG_LAUNCH );
		ShootWeapon( string_t(), PELLETCOUNT, VECTOR_CONE, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 384 : 2048, DAMAGEPELLET, false, DMG_LAUNCH );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -7.5, -6.75 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.0 : 1.25, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip == 0) ? IRON_FIRE_LAST : IRON_FIRE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip == 0) ? FIRE_LAST : FIRE, 0, GetBodygroup() );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				self.SendWeaponAnim( IRON_TO, 0, GetBodygroup() );
				EffectsFOVON( 40 );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( IRON_FROM, 0, GetBodygroup() );
				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( self.m_iClip == 1 )
		{
			self.PlayEmptySound();
			self.Reload();
			self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}
		else if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}

		if( m_pPlayer.pev.button & IN_ALT1 != 0 )
			return;

		self.m_flNextTertiaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		for( uint i = 0; i <= 1; i++ )
			ShootWeapon( BOTH_S, 1, VECTOR_CONE_1DEGREES, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 3072, DAMAGESLUG, false, DMG_LAUNCH );

		ShootWeapon( string_t(), PELLETCOUNT * 2, VECTOR_CONE * 2, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 384 : 3072, DAMAGEPELLET, false, DMG_LAUNCH );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -10.5, -9.75 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.0 : 1.25, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( IRON_FIRE_BOTH, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( FIRE_BOTH, 0, GetBodygroup() );
	}

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		BaseClass.ItemPreFrame();
	}

	void ItemPostFrame()
	{
		BaseClass.ItemPostFrame();
	}

	void SetAmmo()
	{
		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
		self.m_iClip = 1;
	}

	void ReloadThink()
	{
		SetThink( null );
		if( self.m_iClip == 1 || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 1 )
			ShellEject( m_pPlayer, m_iShell, Vector( 0, 8, -8 ), false, true, TE_BOUNCE_SHOTSHELL );
		else if( self.m_iClip <= 0 )
		{
			ShellEject( m_pPlayer, m_iShell, Vector( 0, 8, -8 ), false, true, TE_BOUNCE_SHOTSHELL );
			ShellEject( m_pPlayer, m_iShell, Vector( 0, 8, -8 ), false, true, TE_BOUNCE_SHOTSHELL );
		}
	}

	void Reload()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || self.m_iClip == MAX_CLIP )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			self.SendWeaponAnim( IRON_FROM, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			EffectsFOVOFF();
			canReload = true;
		}

		if( m_reloadTimer < g_Engine.time )
		{
			SetThink( ThinkFunction( this.ReloadThink ) );
			if ( self.m_iClip == 1 || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 1 )
			{
				Reload( MAX_CLIP, RELOAD, (130.0/37.0), GetBodygroup() );
				self.pev.nextthink = g_Engine.time + 1.42;
			}
			else
			{
				Reload( MAX_CLIP, RELOAD_EMPTY, (177.0/37.0), GetBodygroup() );
				self.pev.nextthink = g_Engine.time + 1.28;
			}

			canReload = false;
		}

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( IRON_IDLE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class COACH_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, A_MODEL );
		self.pev.body = MAG_BDYGRP;
		self.pev.skin = MAG_SKIN;
		BaseClass.Spawn();
	}

	void Precache()
	{
		g_Game.PrecacheModel( A_MODEL );
		CommonPrecache();
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_BUCK, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_BUCK );
	}
}

string GetAmmoName()
{
	return "ammo_ins2coach";
}

string GetName()
{
	return "weapon_ins2coach";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_COACH::weapon_ins2coach", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_COACH::COACH_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_BUCK, "", GetAmmoName() ); // Register the weapon
}

}