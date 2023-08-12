// Insurgency's Tokarev SVT-40
/* Model Credits
/ Model: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Textures: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Animations: MyZombieKillerz, D.N.I.O. 071 (Edits)
/ Sounds: Solarint, Falcre, Navaro
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), KernCore (World Model UVs), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_SVT40
{

// Animations
enum INS2_SVT40_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
	DRAW_FIRST,
	DRAW,
	DRAW_EMPTY,
	HOLSTER,
	HOLSTER_EMPTY,
	FIRE,
	FIRE_LAST,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY
};

// Models
string W_MODEL = "models/ins2/wpn/svt40/w_svt40.mdl";
string V_MODEL = "models/ins2/wpn/svt40/v_svt40.mdl";
string P_MODEL = "models/ins2/wpn/svt40/p_svt40.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 7;
// Sprites
string SPR_CAT = "ins2/rfl/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/svt40/shoot.ogg";
string EMPTY_S = "ins2/wpn/svt40/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 10;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 45;
uint SLOT       	= 6;
uint POSITION   	= 8;
float RPM_AIR   	= 0.135f; //Rounds per minute in air
float RPM_WTR   	= 0.275f; //Rounds per minute in water
uint AIM_FOV    	= 37; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_7.62x54mm";

class weapon_ins2svt40 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
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
		"ins2/wpn/svt40/bltbk.ogg",
		"ins2/wpn/svt40/bltrel.ogg",
		"ins2/wpn/svt40/magin.ogg",
		"ins2/wpn/svt40/magout.ogg",
		"ins2/wpn/svt40/maghit.ogg",
		"ins2/wpn/svt40/magrel.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_762x54 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_MGs.txt" );
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
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "sniper", GetBodygroup(), (45.0/25.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "sniper", GetBodygroup(), (21.0/28.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();
		m_pPlayer.m_szAnimExtension = "sniper";

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

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 4.25f, 0.475f, 1.85f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true, DMG_SNIPER | DMG_NEVERGIB );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -4.5, -3.5 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.75f : 0.75f, Math.RandomFloat( -1.5, 1.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FIRE : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? FIRE : FIRE_LAST, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 19, 4.5, -6.5 ) : Vector( 20, 0, -1.5 ) );
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
				m_pPlayer.m_szAnimExtension = "sniperscope";
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
				EffectsFOVOFF();
				m_pPlayer.m_szAnimExtension = "sniper";
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

		m_pPlayer.m_szAnimExtension = "sniper";
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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (139.0/30.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (99.0/30.0), GetBodygroup() );
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

class SVT40_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2svt40";
}

string GetName()
{
	return "weapon_ins2svt40";
}

void Register()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( GetAmmoName() ) )
	{
		g_CustomEntityFuncs.RegisterCustomEntity( "INS2_SVT40::SVT40_MAG", GetAmmoName() ); // Register the ammo entity
	}

	if( !g_CustomEntityFuncs.IsCustomEntity( GetName() ) )
	{
		g_CustomEntityFuncs.RegisterCustomEntity( "INS2_SVT40::weapon_ins2svt40", GetName() ); // Register the weapon entity
		g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
	}
}

}