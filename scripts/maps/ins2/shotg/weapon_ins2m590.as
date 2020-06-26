// Insurgency's Mossberg M590
/* Model Credits
/ Model: Pete3D, Norman The Loli Pirates (Edits)
/ Textures: Pete3D, Norman The Loli Pirates (Edits)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (UV Chop, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_M590
{

// Animations
enum INS2_M590_Animations
{
	IDLE = 0,
	DRAW,
	HOLSTER,
	DRAW_FIRST,
	FIRE1,
	FIRE2,
	FIRE_LAST,
	DRYFIRE,
	RELOAD_START,
	RELOAD_START_EMPTY,
	RELOAD_INSERT,
	RELOAD_END,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM,
	PUMP1,
	PUMP2
};

// Models
string W_MODEL = "models/ins2/wpn/m590/w_m590.mdl";
string V_MODEL = "models/ins2/wpn/m590/v_m590.mdl";
string P_MODEL = "models/ins2/wpn/m590/p_m590.mdl";
string A_MODEL = "models/ins2/ammo/12gbox.mdl";
int MAG_BDYGRP = 1;
int MAG_SKIN   = 0;
// Sprites
string SPR_CAT = "ins2/shg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/m590/shoot.ogg";
string EMPTY_S = "ins2/wpn/m590/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 8;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 10;
uint SLOT       	= 3;
uint POSITION   	= 12;
float RPM_AIR   	= 0.77f; //Rounds per minute in air
string AMMO_TYPE 	= "ins2_12x70buckshot";
uint PELLETCOUNT 	= 8;
Vector VECTOR_CONE( 0.04362, 0.04362, 0.0 ); //5 DEGREES

class weapon_ins2m590 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn, m_fShotgunReload, m_bCanPump;
	private float m_flNextReload;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/m590/ins.ogg",
		"ins2/wpn/m590/sins.ogg",
		"ins2/wpn/m590/pmpbk.ogg",
		"ins2/wpn/m590/pmpfd.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::SHELL_12GREEN );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "shotgun", GetBodygroup(), (65.0/30.0) );
		}
		else
		{
			if( m_bCanPump )
			{
				SetThink( ThinkFunction( this.PumpBackThink ) );
				self.pev.nextthink = g_Engine.time + (21.0/31.0);
			}
			return Deploy( V_MODEL, P_MODEL, DRAW, "shotgun", GetBodygroup(), (22.0/31.0) );
		}
	}

	void PumpBackThink()
	{
		SetThink( null );

		if( self.m_iClip > 0 ) //Checking again in case the player depleted the ammo and didn't let go of the attack button
		{
			self.SendWeaponAnim( Math.RandomLong( PUMP1, PUMP2 ), 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (18.0/40.0);
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (24.0/40.0);

			SetThink( ThinkFunction( this.ShellShotEjectThink ) );
			self.pev.nextthink = WeaponTimeBase() + 0.25;
		}
		m_bCanPump = false;
	}

	void Holster( int skipLocal = 0 )
	{
		m_fShotgunReload = false;
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, PELLETCOUNT, VECTOR_CONE, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 448 : 4096, DAMAGE, false, DMG_LAUNCH );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -10.5, -9.75 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.0 : 1.25, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( IRON_FIRE1, IRON_FIRE2 ) : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( FIRE1, FIRE2 ) : FIRE_LAST, 0, GetBodygroup() );

		if( self.m_iClip > 0 )
		{
			m_bCanPump = true;
			SetThink( ThinkFunction( this.ShellShotEjectThink ) );
			self.pev.nextthink = WeaponTimeBase() + 0.525;
		}
		else
			SetThink( null );
	}

	void ShellShotEjectThink()
	{
		SetThink( null );
		m_bCanPump = false;
		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 16, 6.75, -8 ) : Vector( 18.5, 1.6, -4 ), false, false, TE_BOUNCE_SHOTSHELL );
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
				EffectsFOVON( 45 );
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

	void ItemPostFrame()
	{
		// Checks if the player pressed one of the attack buttons, stops the reload and then attack
		if( m_fShotgunReload )
		{
			if( (CheckButton() || (self.m_iClip >= MAX_CLIP && m_pPlayer.pev.button & IN_RELOAD != 0)) && m_flNextReload <= g_Engine.time )
			{
				self.SendWeaponAnim( RELOAD_END, 0, GetBodygroup() );

				self.m_flTimeWeaponIdle = g_Engine.time + (21.0/35.0);
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (21.0/35.0);
				m_fShotgunReload = false;
				m_bCanPump = false;
			}
		}

		BaseClass.ItemPostFrame();
	}

	void ShellReloadEjectThink() //For the think function used in reload
	{
		SetThink( null );
		ShellEject( m_pPlayer, m_iShell, Vector( 17, 2.5, -6.5 ), false, false, TE_BOUNCE_SHOTSHELL );

		SetThink( ThinkFunction( this.SetAmmo ) );
		self.pev.nextthink = g_Engine.time + ((79.0/46.0) - (24.0/46.0));
	}

	void SetAmmo()
	{
		SetThink( null );
		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
		self.m_iClip = 1;
	}

	void Reload()
	{
		int iAmmo = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );

		if( iAmmo <= 0 || self.m_iClip == MAX_CLIP )
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
			if( m_flNextReload > WeaponTimeBase() )
				return;

			// don't reload until recoil is done
			if( self.m_flNextPrimaryAttack > WeaponTimeBase() && !m_fShotgunReload )
			{
				m_fShotgunReload = false;
				return;
			}
			if( !m_fShotgunReload )
			{
				if( self.m_iClip <= 0 )
				{
					self.SendWeaponAnim( RELOAD_START_EMPTY, 0, GetBodygroup() );
					SetThink( ThinkFunction( ShellReloadEjectThink ) );
					self.pev.nextthink = WeaponTimeBase() + (24.0/46.0);

					m_pPlayer.m_flNextAttack = (101.0/46.0); //Always uses a relative time due to prediction
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (101.0/46.0);
				}
				else
				{
					self.SendWeaponAnim( RELOAD_START, 0, GetBodygroup() );

					m_pPlayer.m_flNextAttack = (21.0/30.0); //Always uses a relative time due to prediction
					self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (21.0/30.0);
				}

				canReload = false;
				m_fShotgunReload = true;
				return;
			}
			else if( m_fShotgunReload )
			{
				if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
					return;

				if( self.m_iClip == MAX_CLIP )
				{
					m_fShotgunReload = false;
					return;
				}

				self.SendWeaponAnim( RELOAD_INSERT, 0, GetBodygroup() );

				m_flNextReload = WeaponTimeBase() + (26.0/46.0);
				self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (26.0/46.0);

				self.m_iClip += 1;
				iAmmo -= 1;
			}
		}

		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, iAmmo );
		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle < g_Engine.time )
		{
			if( self.m_iClip == 0 && !m_fShotgunReload && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) != 0 )
			{
				//self.Reload();
			}
			else if( m_fShotgunReload )
			{
				if( self.m_iClip != MAX_CLIP && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
				{
					self.Reload();
				}
				else
				{
					// reload debounce has timed out
					self.SendWeaponAnim( RELOAD_END, 0, GetBodygroup() );

					m_fShotgunReload = false;
					m_bCanPump = false;
					self.m_flTimeWeaponIdle = g_Engine.time + (21.0/35.0);
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (19.0/35.0);
				}
			}
			else
			{
				m_bCanPump = false;
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE : IDLE, 0, GetBodygroup() );
				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
			}
		}
	}
}

class M590_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_BUCK, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_BUCK );
	}
}

string GetAmmoName()
{
	return "ammo_ins2m590";
}

string GetName()
{
	return "weapon_ins2m590";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M590::weapon_ins2m590", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M590::M590_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_BUCK, "", GetAmmoName() ); // Register the weapon
}

}