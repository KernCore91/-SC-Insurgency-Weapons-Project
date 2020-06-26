// Insurgency's Webley Mk.VI
/* Model Credits
/ Model: McGibs (Forgotten Hope 2), Norman The Loli Pirate
/ Textures: McGibs (Forgotten Hope 2), Norman The Loli Pirate
/ Animations: New World Interactive 
/ Sounds: New World Interactive, Magmacow, Navaro, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"

namespace INS2_WEBLEY
{

// Animations
enum INS2_WEBLEY_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW_RARE,
	DRAW,
	HOLSTER,
	FIRE1,
	FIRE2,
	DRYFIRE,
	RELOAD,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM
};

enum WEBLEY_Bodygroups
{
	ARMS = 0,
	WEBLEY_STUDIO0,
	MAIN_ROUNDS,
	MAIN_CASINGS,
	HELPER_BULLETS
};

// Models
string W_MODEL = "models/ins2/wpn/webley/w_webley.mdl";
string V_MODEL = "models/ins2/wpn/webley/v_webley.mdl";
string P_MODEL = "models/ins2/wpn/webley/p_webley.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 34;
// Sprites
string SPR_CAT = "ins2/hdg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/webley/shoot.ogg";
string EMPTY_S = "ins2/wpn/webley/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 6;
int DEFAULT_GIVE 	= MAX_CLIP * 6;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 38;
uint SLOT       	= 1;
uint POSITION   	= 13;
float RPM_AIR   	= 0.16f; //Rounds per minute in air
float RPM_WTR   	= 0.19f; //Rounds per minute in water
float SHOOT_DELAY 	= 0.06; //Shooting delay
float EMPTY_DELAY 	= 0.1; //Shooting delay for dryfire
string AMMO_TYPE 	= "ins2_455brit";

class weapon_ins2webley : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn;
	private int iBody;
	private int GetBodygroup()
	{
		m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_CASINGS, iBody );
		return m_iCurBodyConfig;
	}
	private int SetBodygroup()
	{
		if( self.m_iClip >= 6 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUNDS, 6 );
		else if( self.m_iClip <= 0 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUNDS, 0 );
		else
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUNDS, self.m_iClip );

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip >= 6 )
		{
			iBody = 5;
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_BULLETS, iBody );
		}
		else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip <= 1 )
		{
			iBody = 0;
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_BULLETS, iBody );
		}
		else
		{
			iBody = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + (self.m_iClip - 1);
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_BULLETS, iBody );
		}

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/webley/close.ogg",
		"ins2/wpn/webley/hammer.ogg",
		"ins2/wpn/webley/open.ogg",
		"ins2/wpn/webley/rare.ogg",
		"ins2/wpn/webley/speed.ogg",
		"ins2/wpn/webley/rounds.ogg",
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		iBody = 5;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( A_MODEL );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployPistolSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_357;
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
		PlayDeploySound( 2 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			if( Math.RandomLong( 0, 1 ) < 0.5 )
				return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "python", GetBodygroup(), (50.0/30.0) );
			else
				return Deploy( V_MODEL, P_MODEL, DRAW_RARE, "python", GetBodygroup(), (50.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "python", GetBodygroup(), (15.0/35.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void ShootThink()
	{
		SetThink( null );

		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 3.15f, 0.7f, 1.7f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, false, DMG_SNIPER );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -3.25, -3.00f ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.7f : 0.95f, Math.RandomFloat( -0.5, 0.5 ) ) );
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + RPM_WTR : WeaponTimeBase() + RPM_AIR;
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			//self.PlayEmptySound();
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;

			SetThink( ThinkFunction( this.ShootThink ) );
			self.pev.nextthink = g_Engine.time + EMPTY_DELAY;
			return;
		}

		if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
			return;

		SetThink( ThinkFunction( this.ShootThink ) );
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (SHOOT_DELAY * 2);
		self.pev.nextthink = g_Engine.time + SHOOT_DELAY;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE2 ), 0, GetBodygroup() );
		else
			self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE2 ), 0, GetBodygroup() );
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
				EffectsFOVON( 49 );
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

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		BaseClass.ItemPreFrame();
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			self.SendWeaponAnim( IRON_FROM, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			Reload( MAX_CLIP, RELOAD, (120.0/33.0), SetBodygroup() );
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

class WEBLEY_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, A_MODEL );
		self.pev.body = MAG_BDYGRP;
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( A_MODEL );
		CommonPrecache();
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_357, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357 );
	}
}

string GetAmmoName()
{
	return "ammo_ins2webley";
}

string GetName()
{
	return "weapon_ins2webley";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_WEBLEY::weapon_ins2webley", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_WEBLEY::WEBLEY_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}