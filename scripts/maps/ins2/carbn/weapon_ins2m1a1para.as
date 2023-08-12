// Insurgency's M1A1 Paratrooper Carbine
/* Model Credits
/ Model: Seth Soldier (Forgotten Hope 2, M1A1), Z3RO! (Bayonet), Norman The Loli Pirate (Bayonet Lug)
/ Textures: Seth Soldier (Forgotten Hope 2, M1A1), Sargent Bash (Bayonet), Norman The Loli Pirate (Heavy Edits, Bayonet Lug)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Z3RO! (Bayonet UVs), Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_M1A1PARA
{

// Animations
enum INS2_M1A1PARA_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM,
	MELEE
};

// Models
string W_MODEL = "models/ins2/wpn/m1a1p/w_m1a1p.mdl";
string V_MODEL = "models/ins2/wpn/m1a1p/v_m1a1p.mdl";
string P_MODEL = "models/ins2/wpn/m1a1p/p_m1a1p.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 50;
// Sprites
string SPR_CAT = "ins2/cbn/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/m1a1p/shoot.ogg";
string EMPTY_S = "ins2/wpn/m1a1p/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 15;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY | ITEM_FLAG_SELECTONEMPTY;
uint DAMAGE     	= 30;
uint DAMAGE_MELEE 	= 15;
uint SLOT       	= 3;
uint POSITION   	= 9;
float RPM_AIR   	= 0.12f; //Rounds per minute in air
float RPM_WTR   	= 0.22f; //Rounds per minute in water
uint AIM_FOV    	= 40; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_7.62x33mm";

class weapon_ins2m1a1para : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::MeleeWeaponBase
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
		"ins2/wpn/m1a1p/bltbk.ogg",
		"ins2/wpn/m1a1p/bltrel.ogg",
		"ins2/wpn/m1a1p/magin.ogg",
		"ins2/wpn/m1a1p/magout.ogg",
		"ins2/wpn/m1a1p/magrel.ogg",
		"ins2/wpn/m1a1p/stk1.ogg",
		"ins2/wpn/m1a1p/stk2.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_762x33 );

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

	bool CanDeploy()
	{
		return true;
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (86.0/32.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "m16", GetBodygroup(), (22.0/30.0) );
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

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 3.0f, 0.9f, 1.0f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -3.0, -2.75 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.3 : 0.4, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( IRON_FIRE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( FIRE, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 18, 4.5, -7 ) : Vector( 18.5, 0, -1.5 ) );
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

	void TertiaryAttack()
	{
		if( !Swing( 1, 46.25, MELEE, GetBodygroup(), 0.63f, DAMAGE_MELEE ) )
		{
			SetThink( ThinkFunction( this.SwingAgain ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}
	}

	void SwingAgain()
	{
		Swing( 0, 46.25, MELEE, GetBodygroup(), 0.6f, DAMAGE_MELEE );
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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (170.0/40.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (115.0/40.0), GetBodygroup() );
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

class M1A1PARA_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2m1a1para";
}

string GetName()
{
	return "weapon_ins2m1a1para";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M1A1PARA::weapon_ins2m1a1para", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M1A1PARA::M1A1PARA_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}