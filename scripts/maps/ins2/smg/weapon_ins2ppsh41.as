// Insurgency's PPSh-41
/* Model Credits
/ Model: Contract Wars, Norman The Loli Pirate (Edits, 7.62x25mm bullet)
/ Textures: Contract Wars, Norman The Loli Pirate (Edits, 7.62x25mm bullet)
/ Animations: MyZombieKillerz, D.N.I.O. 071 (Edits)
/ Sounds: New World Interactive, Navaro, D.N.I.O. 071 (Conversion to .ogg format, Edits by R4to0)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"

namespace INS2_PPSH41
{

// Animations
enum INS2_PPSH41_Animations
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
	FIRESELECT,
	FIRESELECT_EMPTY,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_FIRESELECT,
	IRON_FIRESELECT_EMPTY,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY
};

// Models
string W_MODEL = "models/ins2/wpn/ppsh41/w_ppsh41.mdl";
string V_MODEL = "models/ins2/wpn/ppsh41/v_ppsh41.mdl";
string P_MODEL = "models/ins2/wpn/ppsh41/p_ppsh41.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 11;
// Sprites
string SPR_CAT = "ins2/smg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/ppsh41/shoot.ogg";
string EMPTY_S = "ins2/wpn/ppsh41/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 71;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 15;
uint SLOT       	= 2;
uint POSITION   	= 12;
float RPM_AIR   	= 900; //Rounds per minute in air
float RPM_WTR   	= 775; //Rounds per minute in water
uint AIM_FOV    	= 45; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_7.62x25mm";

class weapon_ins2ppsh41 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
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
		"ins2/wpn/ppsh41/bltbk.ogg",
		"ins2/wpn/ppsh41/rof.ogg",
		"ins2/wpn/ppsh41/hit.ogg",
		"ins2/wpn/ppsh41/magin.ogg",
		"ins2/wpn/ppsh41/magout.ogg",
		"ins2/wpn/ppsh41/magrel.ogg",
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		WeaponSelectFireMode = INS2BASE::SELECTFIRE_AUTO;
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_762x25 );

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
		DisplayFiremodeSprite();
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "mp5", GetBodygroup(), (47.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "mp5", GetBodygroup(), (21.0/31.0) );
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

		if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_SEMI && m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 2.4f, 0.9f, 1.75f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
				KickBack( 0.9, 0.475, 0.35, 0.0425, 5.0, 3.0, 6 );
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
				KickBack( 0.425, 0.25, 0.2, 0.03, 3.0, 2.0, 7 );
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
				KickBack( 0.325, 0.175, 0.1, 0.015, 2.0, 1.0, 9 );
			else
				KickBack( 0.5, 0.275, 0.125, 0.02, 2.5, 1.5, 8 );
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -1.85, -2.25 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.8f : 0.8f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip <= 0) ? IRON_FIRE_LAST : IRON_FIRE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip <= 0) ? FIRE_LAST : FIRE, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 25, 6.5, -7 ) : Vector( 26, 1.25, -3.45 ), true );
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
		if( self.m_iClip > 0 )
			ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_SEMI, (19.0/30.0) );
		else
			ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT_EMPTY : FIRESELECT_EMPTY, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_SEMI, (19.0/30.0) );

		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || m_pPlayer.pev.button & IN_USE != 0 )
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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (199.0/35.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (170.0/35.0), GetBodygroup() );
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

class PPSH41_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2ppsh41";
}

string GetName()
{
	return "weapon_ins2ppsh41";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PPSH41::weapon_ins2ppsh41", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PPSH41::PPSH41_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM, "", GetAmmoName() ); // Register the weapon
}

}