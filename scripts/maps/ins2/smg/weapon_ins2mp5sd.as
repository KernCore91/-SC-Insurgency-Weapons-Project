// Insurgency's H&K MP5SD3
/* Model Credits
/ Model: Twinke Masta, New World Interactive (Magazine), D.N.I.O. 071 (Edits)
/ Textures: Geno, Norman The Loli Pirate (Magazine heavy edits), D.N.I.O. 071 (Edits)
/ Animations: D.N.I.O. 071
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc:  Norman The Loli Pirate (World Model), KernCore (World Model UVs), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_MP5SD
{

// Animations
enum INS2_MP5SD_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE1,
	FIRE2,
	FIRE3,
	DRYFIRE,
	FIRESELECT,
	RELOAD,
	RELOAD_EMPTY_SLAP,
	RELOAD_EMPTY_PULL,
	RELOAD_EMPTY_PUNCH,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE3,
	IRON_DRYFIRE,
	IRON_FIRESELECT,
	IRON_TO,
	IRON_FROM
};

// Models
string W_MODEL = "models/ins2/wpn/mp5sd/w_mp5sd.mdl";
string V_MODEL = "models/ins2/wpn/mp5sd/v_mp5sd.mdl";
string P_MODEL = "models/ins2/wpn/mp5sd/p_mp5sd.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 10;
// Sprites
string SPR_CAT = "ins2/smg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/mp5sd/shoot.ogg";
string EMPTY_S = "ins2/wpn/mp5sd/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 30;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 14;
uint SLOT       	= 2;
uint POSITION   	= 9;
float RPM_AIR   	= 800; //Rounds per minute in air
float RPM_WTR   	= 600; //Rounds per minute in water
uint AIM_FOV    	= 45; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_9x19mm";

class weapon_ins2mp5sd : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
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
		"ins2/wpn/mp5sd/bltbk.ogg",
		"ins2/wpn/mp5sd/bltlck.ogg",
		"ins2/wpn/mp5sd/bltrel.ogg",
		"ins2/wpn/mp5sd/magin.ogg",
		"ins2/wpn/mp5sd/magout.ogg",
		"ins2/wpn/mp5sd/magrel.ogg",
		"ins2/wpn/mp5sd/stock.ogg",
		"ins2/wpn/mp5k/rof.ogg",
		EMPTY_S,
		SHOOT_S
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_9x19 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
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
		PlayDeploySound( 3 );
		DisplayFiremodeSprite();
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "bow", GetBodygroup(), (90.0/33.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "bow", GetBodygroup(), (25.0/31.0) );
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

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 1.9f, 0.75f, 1.6f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, false, DMG_BULLET | DMG_NEVERGIB );

		m_pPlayer.m_iWeaponVolume = 0;
		m_pPlayer.m_iWeaponFlash = 0;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
				KickBack( 0.9, 0.475, 0.35, 0.0425, 5.0, 3.0, 6 );
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
				KickBack( 0.5, 0.275, 0.2, 0.03, 3.0, 2.0, 10 );
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
				KickBack( 0.225, 0.15, 0.1, 0.015, 2.0, 1.0, 10 );
			else
				KickBack( 0.35, 0.175, 0.125, 0.02, 2.5, 1.5, 10 );
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -1.875, -2.475 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.7f : 0.6f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ), 0, GetBodygroup() );
		else
			self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE3 ), 0, GetBodygroup() );

	//	Old ejection vectors
	//	ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 18.5, 6.5, -7.1 ) : Vector( 18.5, 1.6, -3.55 ) );
		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 18.5, 6, -6.7 ) : Vector( 18.5, 1.6, -4 ) );
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
				EffectsFOVON( AIM_FOV );
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
		ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_SEMI, (30.0/33.0) );

		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || m_pPlayer.pev.button & IN_USE != 0 )
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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, Math.RandomLong( RELOAD_EMPTY_SLAP, RELOAD_EMPTY_PUNCH ), (150.0/35.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (100.0/35.0), GetBodygroup() );
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
			self.SendWeaponAnim( IRON_IDLE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class MP5SD_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2mp5sd";
}

string GetName()
{
	return "weapon_ins2mp5sd";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_MP5SD::weapon_ins2mp5sd", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_MP5SD::MP5SD_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM, "", GetAmmoName() ); // Register the weapon
}

}