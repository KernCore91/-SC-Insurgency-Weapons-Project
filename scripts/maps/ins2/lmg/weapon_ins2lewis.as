// Insurgency's Lewis Model 1915 MK.I
/* Model Credits
/ Model: Rad (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Textures: Rad (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Animations: New World Interactive 
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"

namespace INS2_LEWIS
{

// Animations
enum INS2_LEWIS_Animations
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
	FIRE_LAST,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY,
	BIPOD_IN,
	BIPOD_IN_EMPTY,
	BIPOD_OUT,
	BIPOD_OUT_EMPTY,
	BIPOD_IDLE,
	BIPOD_IDLE_EMPTY,
	BIPOD_FIRE1,
	BIPOD_FIRE2,
	BIPOD_FIRE_LAST,
	BIPOD_DRYFIRE,
	BIPOD_RELOAD,
	BIPOD_RELOAD_EMPTY,
	BIPOD_IRON_IDLE,
	BIPOD_IRON_IDLE_EMPTY,
	BIPOD_IRON_FIRE1,
	BIPOD_IRON_FIRE2,
	BIPOD_IRON_FIRE_LAST,
	BIPOD_IRON_DRYFIRE,
	BIPOD_IRON_TO,
	BIPOD_IRON_TO_EMPTY,
	BIPOD_IRON_FROM,
	BIPOD_IRON_FROM_EMPTY,
	BIPOD_IRON_IN,
	BIPOD_IRON_IN_EMPTY,
	BIPOD_IRON_OUT,
	BIPOD_IRON_OUT_EMPTY
};

// Models
string W_MODEL = "models/ins2/wpn/lewis/w_lewis.mdl";
string V_MODEL = "models/ins2/wpn/lewis/v_lewis.mdl";
string P_MODEL = "models/ins2/wpn/lewis/p_lewis.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 30;
// Sprites
string SPR_CAT = "ins2/lmg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/lewis/shoot.ogg";
string EMPTY_S = "ins2/wpn/lewis/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 47;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 40;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY | ITEM_FLAG_ESSENTIAL;
uint DAMAGE     	= 28;
uint SLOT       	= 7;
uint POSITION   	= 9;
float RPM_AIR   	= 600; //Rounds per minute in air
float RPM_WTR   	= 500; //Rounds per minute in water
uint AIM_FOV    	= 40; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_303brit";

class weapon_ins2lewis : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::BipodWeaponBase
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
		"ins2/wpn/lewis/bltbk.ogg",
		"ins2/wpn/lewis/magfdl.ogg",
		"ins2/wpn/lewis/hit.ogg",
		"ins2/wpn/lewis/magin.ogg",
		"ins2/wpn/lewis/magemp.ogg",
		"ins2/wpn/lewis/magout.ogg",
		"ins2/wpn/lewis/magrel.ogg",
		"ins2/wpn/uni/bground.ogg",
		"ins2/wpn/uni/foley.ogg",
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_303 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_MGs.txt" );
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

		//g_Game.AlertMessage( at_console, "weapon id: " + info.iId + "\n" );

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

		SetThink( ThinkFunction( ShowBipodSpriteThink ) );
		self.pev.nextthink = g_Engine.time + 0.2;

		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "saw", GetBodygroup(), (109.0/35.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "saw", GetBodygroup(), (42.0/35.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		WeaponBipodMode = INS2BASE::BIPOD_UNDEPLOYED;
		//ShowPlayerHudMessage( Vector2D( -0.01, 0.825 ), Vector( 0, 255, 0 ), -1, -1, 0, 4, "" );
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

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_2DEGREES, 1.2f, 0.45f, 1.07f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN && WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
			{
				KickBack( 2.0, 0.65, 0.45, 0.125, 5.0, 3.5, 7 );
			}
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
			{
				KickBack( 1.10, 0.5, 0.3, 0.06, 4.0, 2.5, 8 );
			}
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
			{
				KickBack( 0.7, 0.325, 0.25, 0.025, 3.5, 2.0, 9 );
			}
			else
			{
				KickBack( 0.9, 0.35, 0.3, 0.03, 3.75, 3.0, 9 );
			}
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -2.5, -2.2 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.6f : 0.6f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( IRON_FIRE1, IRON_FIRE2 ) : IRON_FIRE_LAST, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( FIRE1, FIRE2 ) : FIRE_LAST, 0, GetBodygroup() );
		}
		else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( BIPOD_IRON_FIRE1, BIPOD_IRON_FIRE2 ) : BIPOD_IRON_FIRE_LAST, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( BIPOD_FIRE1, BIPOD_FIRE2 ) : BIPOD_FIRE_LAST, 0, GetBodygroup() );
		}

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 6, 4.5, -7.75 ) : Vector( 6.25, 2.55, -2.25 ) );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
					self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_TO : IRON_TO_EMPTY, GetBodygroup() );
				else
					self.SendWeaponAnim( (self.m_iClip > 0) ? BIPOD_IRON_TO : BIPOD_IRON_TO_EMPTY, GetBodygroup() );

				EffectsFOVON( AIM_FOV );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
					self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
				else
					self.SendWeaponAnim( (self.m_iClip > 0) ? BIPOD_IRON_FROM : BIPOD_IRON_FROM_EMPTY, 0, GetBodygroup() );

				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			if( self.m_iClip > 0 )
				DeployBipod( BIPOD_IRON_IN, BIPOD_IRON_OUT, GetBodygroup(), (64.0/36.0), (73.0/36.0) );
			else
				DeployBipod( BIPOD_IRON_IN_EMPTY, BIPOD_IRON_OUT_EMPTY, GetBodygroup(), (64.0/36.0), (73.0/36.0) );
		}
		else
		{
			if( self.m_iClip > 0 )
				DeployBipod( BIPOD_IN, BIPOD_OUT, GetBodygroup(), (64.0/36.0), (73.0/36.0) );
			else
				DeployBipod( BIPOD_IN_EMPTY, BIPOD_OUT_EMPTY, GetBodygroup(), (64.0/36.0), (73.0/36.0) );
		}
	}

	void ItemPostFrame()
	{
		BaseClass.ItemPostFrame();
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
			if( self.m_iClip > 0 )
				self.SendWeaponAnim( (WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED) ? IRON_FROM : BIPOD_IRON_FROM, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( (WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED) ? IRON_FROM_EMPTY : BIPOD_IRON_FROM_EMPTY, 0, GetBodygroup() );

			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			if( WeaponBipodMode == INS2BASE::BIPOD_UNDEPLOYED )
				(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (256.0/37.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (225.0/37.0), GetBodygroup() );
			else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
				(self.m_iClip == 0) ? Reload( MAX_CLIP, BIPOD_RELOAD_EMPTY, (256.0/37.0), GetBodygroup() ) : Reload( MAX_CLIP, BIPOD_RELOAD, (225.0/37.0), GetBodygroup() );
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
			if( self.m_iClip > 0 )
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE : IDLE, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE_EMPTY : IDLE_EMPTY, 0, GetBodygroup() );
		}
		else if( WeaponBipodMode == INS2BASE::BIPOD_DEPLOYED )
		{
			if( self.m_iClip > 0 )
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? BIPOD_IRON_IDLE : BIPOD_IDLE, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? BIPOD_IRON_IDLE_EMPTY : BIPOD_IDLE_EMPTY, 0, GetBodygroup() );
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class LEWIS_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2lewis";
}

string GetName()
{
	return "weapon_ins2lewis";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_LEWIS::weapon_ins2lewis", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_LEWIS::LEWIS_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, "", GetAmmoName() ); // Register the weapon
}

}