// Insurgency's Makarov PM
/* Model Credits
/ Model: Woody, Norman The Loli Pirate
/ Textures: Millenia, Norman The Loli Pirate
/ Animations: New World Interactive, D.N.I.O. 071 (Minor Edits)
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (World Model UVs), Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_MAKAROV
{

// Animations
enum INS2_MAKAROV_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
	DRAW_FIRST,
	DRAW,
	DRAW_EMPTY,
	HOLSTER,
	HOLSTER_EMPTY,
	FIRE1,
	FIRE2,
	FIRE3,
	FIRE_LAST,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE3,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY
};

enum MAKAROV_Bodygroups
{
	ARMS = 0,
	MAKAROV_STUDIO0,
	HELPER_MAGFEED,
	MAIN_MAGFEED,
	HELPER_ROUND,
	MAIN_ROUND
};

// Models
string W_MODEL = "models/ins2/wpn/pm/w_pm.mdl";
string V_MODEL = "models/ins2/wpn/pm/v_pm.mdl";
string P_MODEL = "models/ins2/wpn/pm/p_pm.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 28;
// Sprites
string SPR_CAT = "ins2/hdg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/pm/shoot.ogg";
string EMPTY_S = "ins2/wpn/pm/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 8;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 15;
uint SLOT       	= 1;
uint POSITION   	= 4;
float RPM_AIR   	= 0.1f; //Rounds per minute in air
float RPM_WTR   	= 0.2f; //Rounds per minute in water
uint AIM_FOV    	= 49; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_9x18mm";

class weapon_ins2makarov : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
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
		if( self.m_iClip >= MAX_CLIP )
		{
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_MAGFEED, 7 );
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUND, 0 ); // Show bullet
		}
		else if( self.m_iClip <= 0 )
		{
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_MAGFEED, 0 );
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUND, 0 ); // Show bullet
		}
		else
		{
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_MAGFEED, self.m_iClip - 1 );
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_ROUND, (self.m_iClip == 1) ? 1 : 0 ); // Hide bullet if clip is 1, show if 0
		}

		// g_Game.AlertMessage( at_console, "Current Bodygroup Config: " + m_iCurBodyConfig + "\n" );

		return m_iCurBodyConfig;
	}
	//Optimization: SetBodygroup only plays on Reload functions
	private int SetBodygroup()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= MAX_CLIP || (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) >= MAX_CLIP )
			{
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_MAGFEED, 7 );
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_ROUND, (self.m_iClip == 1) ? 1 : 0 ); // Show bullet if clip is 1, hide if 0
			}
			else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) < MAX_CLIP && (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) < MAX_CLIP )
			{
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_MAGFEED, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + (self.m_iClip - 1) );
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_ROUND, (self.m_iClip == 1) ? 1 : 0 ); // Show bullet if clip is 1, hide if 0
			}
		}

		// g_Game.AlertMessage( at_console, "SET Bodygroup Config: " + m_iCurBodyConfig + "\n" );

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/pm/sldbk.ogg",
		"ins2/wpn/pm/sldrel.ogg",
		"ins2/wpn/pm/hit.ogg",
		"ins2/wpn/pm/magin.ogg",
		"ins2/wpn/pm/magout.ogg",
		"ins2/wpn/pm/magrel.ogg",
		"ins2/wpn/pm/safe.ogg",
		SHOOT_S,
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_9x18 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployPistolSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_9MM;
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "onehanded", GetBodygroup(), (38.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip == 0) ? DRAW_EMPTY : DRAW, "onehanded", GetBodygroup(), (15.0/35.0) );
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

		if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + RPM_WTR : WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 2.9f, 0.75f, 1.45f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -2.1, -2.5 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.65f : 0.65f, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ) : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( FIRE1, FIRE3 ) : FIRE_LAST, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 23, 5, -7 ) : Vector( 23, 0.45, -1.65 ) );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_TO : IRON_TO_EMPTY, 0, GetBodygroup() );
				EffectsFOVON( AIM_FOV );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
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
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (85.0/35.0), SetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (80.0/35.0), SetBodygroup() );
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
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class MAKAROV_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_9MM, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM );
	}
}

string GetAmmoName()
{
	return "ammo_ins2makarov";
}

string GetName()
{
	return "weapon_ins2makarov";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_MAKAROV::weapon_ins2makarov", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_MAKAROV::MAKAROV_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM, "", GetAmmoName() ); // Register the weapon
}

}