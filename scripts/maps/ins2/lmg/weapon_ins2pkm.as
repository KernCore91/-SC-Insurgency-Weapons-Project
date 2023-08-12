// Insurgency's PKM
/* Model Credits
/ Model: Sasha, Ohnomelon, Chuc, Pharoahe Zephyrus, Norman The Loli Pirate (Edits, Belt, Bullets)
/ Textures: Sasha, Ohnomelon, Chuc, Pharoahe Zephyrus, Norman The Loli Pirate (Edits)
/ Animations: New World Interactive, D.N.I.O. 071 (Major Edits)
/ Sounds: New World Interactive
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (Compile)
/ Script: KernCore, D.N.I.O. 071
*/

#include "../base"

namespace INS2_PKM
{

// Animations
enum INS2_PKM_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE1,
	FIRE2,
	FIRE3,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE3,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM,
	BIPOD_IN,
	BIPOD_OUT,
	BIPOD_IDLE,
	BIPOD_FIRE1,
	BIPOD_FIRE2,
	BIPOD_FIRE3,
	BIPOD_DRYFIRE,
	BIPOD_RELOAD,
	BIPOD_RELOAD_EMPTY,
	BIPOD_IRON_IDLE,
	BIPOD_IRON_FIRE1,
	BIPOD_IRON_FIRE2,
	BIPOD_IRON_FIRE3,
	BIPOD_IRON_DRYFIRE,
	BIPOD_IRON_TO,
	BIPOD_IRON_FROM,
	BIPOD_IRON_IN,
	BIPOD_IRON_OUT
};

enum PKM_Bodygroups
{
	ARMS = 0,
	PKM_STUDIO0,
	PKM_STUDIO1,
	PKM_STUDIO2,
	MAIN_BULLETS,
	HELPER_BULLETS
};

// Models
string W_MODEL = "models/ins2/wpn/pkm/w_pkm.mdl";
string V_MODEL = "models/ins2/wpn/pkm/v_pkm.mdl";
string P_MODEL = "models/ins2/wpn/pkm/p_pkm.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 11;
// Sprites
string SPR_CAT = "ins2/lmg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/pkm/shoot.ogg";
string EMPTY_S = "ins2/wpn/pkm/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 100;
int DEFAULT_GIVE 	= MAX_CLIP * 3;
int WEIGHT      	= 55;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY | ITEM_FLAG_ESSENTIAL;
uint DAMAGE     	= 30;
uint SLOT       	= 7;
uint POSITION   	= 14;
float RPM_AIR   	= 652; //Rounds per minute in air
float RPM_WTR   	= 522; //Rounds per minute in water
uint AIM_FOV    	= 40; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_7.62x54mm";

class weapon_ins2pkm : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::BipodWeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn, m_bInReload;
	private int GetBodygroup()
	{
		if( self.m_iClip >= 13 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_BULLETS, 13 );
		else if( self.m_iClip <= 0 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_BULLETS, 0 );
		else
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, MAIN_BULLETS, self.m_iClip );

		return m_iCurBodyConfig;
	}
	private int SetBodygroup()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= 13 || (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) >= 13 )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_BULLETS, 13 );
			else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) < 13 && (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) < 13 )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, HELPER_BULLETS, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip );
		}

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/pkm/bdply.ogg",
		"ins2/wpn/pkm/belt.ogg",
		"ins2/wpn/pkm/bltbk.ogg",
		"ins2/wpn/pkm/bltfd.ogg",
		"ins2/wpn/pkm/brtrct.ogg",
		"ins2/wpn/pkm/liddn.ogg",
		"ins2/wpn/pkm/lidup.ogg",
		"ins2/wpn/pkm/magin.ogg",
		"ins2/wpn/pkm/magout.ogg",
		"ins2/wpn/sks/magrel.ogg",
		"ins2/wpn/uni/bground.ogg",
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		m_bInReload = false;
		WeaponBipodMode = INS2BASE::BIPOD_UNDEPLOYED;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( A_MODEL );
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_762x54 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_MGs_big.txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_556;
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
		m_bInReload = false;

		SetThink( ThinkFunction( ShowBipodSpriteThink ) );
		self.pev.nextthink = g_Engine.time + 0.2;

		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "saw", GetBodygroup(), (119.0/37.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "saw", GetBodygroup(), (42.0/37.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_bInReload = false;
		WeaponBipodMode = INS2BASE::BIPOD_UNDEPLOYED;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? BIPOD_IRON_DRYFIRE : BIPOD_DRYFIRE, 0, GetBodygroup() );

			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_2DEGREES, 1.4f, 0.5f, 1.05f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN && WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
			{
				KickBack( 2.0, 0.65, 0.45, 0.125, 9.0, 3.5, 8 );
			}
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
			{
				KickBack( 1.2, 0.5, 0.3, 0.06, 8.0, 3.0, 8 );
			}
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
			{
				KickBack( 0.95, 0.325, 0.25, 0.025, 4.5, 2.5, 9 );
			}
			else
			{
				KickBack( 1.05, 0.35, 0.3, 0.03, 5.75, 3.0, 9 );
			}
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -2.15f, -2.85f ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.6f : 0.9f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ), 0, GetBodygroup() );
			else
				self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE3 ), 0, GetBodygroup() );

			ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 18, 4.3, -10 ) : Vector( 26, -5, -7 ), true );
		}
		else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( Math.RandomLong( BIPOD_IRON_FIRE1, BIPOD_IRON_FIRE3 ), 0, GetBodygroup() );
			else
				self.SendWeaponAnim( Math.RandomLong( BIPOD_FIRE1, BIPOD_FIRE3 ), 0, GetBodygroup() );

			ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 20, 4.2, -10 ) : Vector( 26, -5, -7 ), true );
		}
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				self.SendWeaponAnim( (WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED) ? IRON_TO : BIPOD_IRON_TO, 0, GetBodygroup() );
				EffectsFOVON( AIM_FOV );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED) ? IRON_FROM : BIPOD_IRON_FROM, 0, GetBodygroup() );
				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( WeaponADSMode == INS2BASE::IRON_IN )
			DeployBipod( BIPOD_IRON_IN, BIPOD_IRON_OUT, GetBodygroup(), (68.0/36.0), (80.0/36.0) );
		else
			DeployBipod( BIPOD_IN, BIPOD_OUT, GetBodygroup(), (68.0/36.0), (80.0/36.0) );
	}

	void ItemPostFrame()
	{
		BaseClass.ItemPostFrame();
	}

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		if( m_bInReload )
			m_bInReload = false;

		BaseClass.ItemPreFrame();
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			self.SendWeaponAnim( (WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED) ? IRON_FROM : BIPOD_IRON_FROM, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			m_bInReload = true;
			if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
			{
				if( self.m_iClip == 0 )
				{
					Reload( MAX_CLIP, RELOAD_EMPTY, (201.0/18.75), SetBodygroup() );
					
				}
				else
				{
					Reload( MAX_CLIP, RELOAD, (169.0/18.75), SetBodygroup() );
				}
			}
			else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
			{
				if( self.m_iClip == 0 )
					Reload( MAX_CLIP, BIPOD_RELOAD_EMPTY, (201.0/18.75), SetBodygroup() );
				else
					Reload( MAX_CLIP, BIPOD_RELOAD, (169.0/18.75), SetBodygroup() );
			}
			canReload = false;
		}

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		if( self.m_flNextPrimaryAttack < g_Engine.time )
			m_iShotsFired = 0;

		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
		{
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE : IDLE, 0, GetBodygroup() );
		}
		else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
		{
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? BIPOD_IRON_IDLE : BIPOD_IDLE, 0, GetBodygroup() );
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class PKM_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_556, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556 );
	}
}

string GetAmmoName()
{
	return "ammo_ins2pkm";
}

string GetName()
{
	return "weapon_ins2pkm";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PKM::weapon_ins2pkm", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PKM::PKM_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, "", GetAmmoName() ); // Register the weapon
}

}