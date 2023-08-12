// Insurgency's M3 Grease Gun
/* Model Credits
/ Model: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits, interior)
/ Textures: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits, interior)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), KernCore (World Model UVs), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_GREASEGUN
{

// Animations
enum INS2_GREASEGUN_Animations
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

// Models
string W_MODEL = "models/ins2/wpn/grease/w_grease.mdl";
string V_MODEL = "models/ins2/wpn/grease/v_grease.mdl";
string P_MODEL = "models/ins2/wpn/grease/p_grease.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 8;
// Sprites
string SPR_CAT = "ins2/smg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/grease/shoot.ogg";
string EMPTY_S = "ins2/wpn/grease/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 30;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 18;
uint SLOT       	= 2;
uint POSITION   	= 5;
float RPM_AIR   	= 450; //Rounds per minute in air
float RPM_WTR   	= 425; //Rounds per minute in water
uint AIM_FOV    	= 45; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_45acp";

class weapon_ins2greasegun : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
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
		"ins2/wpn/grease/bltbk.ogg",
		"ins2/wpn/grease/bltfd.ogg",
		"ins2/wpn/grease/hit.ogg",
		"ins2/wpn/grease/magin.ogg",
		"ins2/wpn/grease/magout.ogg",
		"ins2/wpn/grease/magrel.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_45ACP );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_SMGs_big.txt" );
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
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "mp5", GetBodygroup(), (74.0/32.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "mp5", GetBodygroup(), (25.0/32.0) );
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 2.3f, 0.9f, 1.9f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
				KickBack( 1.25f, 0.50f, 0.4, 0.045, 5.0, 3.0, 6 );
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
				KickBack( 1.20f, 0.23f, 0.25, 0.04, 3.0, 2.0, 10 );
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
				KickBack( 0.50f, 0.25f, 0.15, 0.02, 2.0, 1.0, 10 );
			else
				KickBack( 0.70f, 0.25f, 0.15, 0.025, 2.5, 1.5, 10 );
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -1.875, -2.475 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.7f : 0.5f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ) : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( FIRE1, FIRE3 ) : FIRE_LAST, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 29, 8.5, -7 ) : Vector( 29, 1, -2 ) );
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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (155.0/35.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (109.0/35.0), GetBodygroup() );
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

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class GREASEGUN_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2greasegun";
}

string GetName()
{
	return "weapon_ins2greasegun";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_GREASEGUN::weapon_ins2greasegun", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_GREASEGUN::GREASEGUN_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM, "", GetAmmoName() ); // Register the weapon
}

}