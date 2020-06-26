// Insurgency's Lee-Enfield No.IV Mk.I
/* Model Credits
/ Model: McGibs (Forgotten Hope 2), Norman The Loli Pirate (Clip)
/ Textures: McGibs (Forgotten Hope 2), Norman The Loli Pirate (Clip)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (World Model UVs, UV Chop), D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_ENFIELD
{

// Animations
enum INS2_ENFIELD_Animations
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
	RELOAD_1CLIP,
	RELOAD_1CLIP_EMPTY,
	RELOAD_2CLIP,
	RELOAD_2CLIP_EMPTY,
	RELOAD_START,
	RELOAD_INSERT,
	RELOAD_END,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY,
	BOLT
};

enum ENFIELD_Bodygroups
{
	ARMS = 0,
	ENFIELD_STUDIO0,
	BULLETS
};

// Models
string W_MODEL = "models/ins2/wpn/enfield/w_enfield.mdl";
string V_MODEL = "models/ins2/wpn/enfield/v_enfield.mdl";
string P_MODEL = "models/ins2/wpn/enfield/p_enfield.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 41;
// Sprites
string SPR_CAT = "ins2/rfl/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/enfield/shoot.ogg";
string EMPTY_S = "ins2/wpn/enfield/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 10;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 55;
uint SLOT       	= 6;
uint POSITION   	= 7;
float RPM_AIR   	= 1.26f; //Rounds per minute in air
string AMMO_TYPE 	= "ins2_303brit";

class weapon_ins2enfield : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn, m_fRifleReload, m_bCanBolt;
	private float m_flNextReload;
	private CScheduledFunction@ CSRemoveBullet = null; //2 think functions can't work at the same time on the same object
	private int GetBodygroup()
	{
		return 0;
	}
	private int SetBodygroup()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= MAX_CLIP || (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) >= MAX_CLIP )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS, 9 );
			else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) < MAX_CLIP && (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) < MAX_CLIP )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + (self.m_iClip - 1) );
		}
		//g_Game.AlertMessage( at_console, "Current Bodygroup Config: " + m_iCurBodyConfig + "\n" );

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/enfield/bltbk.ogg",
		"ins2/wpn/enfield/bltfd.ogg",
		"ins2/wpn/enfield/bltlat.ogg",
		"ins2/wpn/enfield/bltrel.ogg",
		"ins2/wpn/enfield/ins.ogg",
		"ins2/wpn/enfield/clip.ogg",
		"ins2/wpn/enfield/magin.ogg",
		"ins2/wpn/enfield/ammoin.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_303 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
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
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "sniper", GetBodygroup(), (109.0/37.0) );
		}
		else
		{
			if( m_bCanBolt )
			{
				SetThink( ThinkFunction( this.BoltBackThink ) );
				self.pev.nextthink = g_Engine.time + (22.0/31.0);
			}
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip <= 0 || m_bCanBolt) ? DRAW_EMPTY : DRAW , "sniper", GetBodygroup(), (23.0/31.0) );
		}
	}

	void BoltBackThink()
	{
		SetThink( null );

		if( self.m_iClip > 0 ) //Checking again in case the player depleted the ammo and didn't let go of the attack button
		{
			self.SendWeaponAnim( BOLT, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (38.0/38.0);
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (43.0/38.0);

			SetThink( ThinkFunction( this.ShellEjectThink ) );
			self.pev.nextthink = WeaponTimeBase() + 0.447;
		}
		m_bCanBolt = false;
	}

	void Holster( int skipLocal = 0 )
	{
		m_pPlayer.m_szAnimExtension = "sniper";
		m_fRifleReload = false;
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack =  WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 2.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 4.5f, 0.5f, 2.0f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 16384, DAMAGE, true, DMG_SNIPER | DMG_NEVERGIB );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -6.4, -5.5 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -2.0f : 3.2f, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FIRE : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? FIRE : FIRE_LAST, 0, GetBodygroup() );

		if( self.m_iClip > 0 )
		{
			m_bCanBolt = true;
			SetThink( ThinkFunction( this.ShellEjectThink ) );
			self.pev.nextthink = WeaponTimeBase() + (29.0/38.0);
		}
		else
			SetThink( null );
	}

	void ShellEjectThink() //For the think function used in shoot
	{
		SetThink( null );
		m_bCanBolt = false;
		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 17, 4.5, -6.5 ) : Vector( 17, 0, -1.5 ) );
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
				EffectsFOVON( 37 );
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

	void ItemPostFrame()
	{
		// Checks if the player pressed one of the attack buttons, stops the reload and then attack
		if( m_fRifleReload )
		{
			if( (CheckButton() || (self.m_iClip >= MAX_CLIP && m_pPlayer.pev.button & IN_RELOAD != 0)) && m_flNextReload <= g_Engine.time )
			{
				self.SendWeaponAnim( RELOAD_END, 0, GetBodygroup() );

				self.m_flTimeWeaponIdle = g_Engine.time + (48.0/38.50);
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (48.0/38.50);
				m_fRifleReload = false;
				m_bCanBolt = false;
			}
		}
		BaseClass.ItemPostFrame();
	}

	void RemovePrimAmmo()
	{
		g_Scheduler.RemoveTimer( CSRemoveBullet );
		@CSRemoveBullet = @null;

		if( self.m_iClip > 0 )
		{
			self.m_iClip -= 1;
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + 1 );
		}

		ShellEject( m_pPlayer, m_iShell, Vector( 16.5, 4.5, -6 ), false, false );
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

		int iAmmo = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );

		if( (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) <= 4 || self.m_iClip >= 7 || m_fRifleReload )
		{
			if( m_reloadTimer < g_Engine.time )
			{
				if( m_flNextReload > WeaponTimeBase() )
					return;

				// don't reload until recoil is done
				if( self.m_flNextPrimaryAttack > WeaponTimeBase() && !m_fRifleReload )
				{
					m_fRifleReload = false;
					return;
				}
				if( !m_fRifleReload )
				{
					self.SendWeaponAnim( RELOAD_START, 0, GetBodygroup() );

					SetThink( ThinkFunction( RemovePrimAmmo ) );
					self.pev.nextthink = g_Engine.time + 0.83;

					m_pPlayer.m_flNextAttack = (43.0/38.50); //Always uses a relative time due to prediction
					self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (43.0/38.50);

					canReload = false;
					m_fRifleReload = true;
					return;
				}
				else if( m_fRifleReload )
				{
					if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
						return;

					if( self.m_iClip == MAX_CLIP )
					{
						m_fRifleReload = false;
						return;
					}

					self.SendWeaponAnim( RELOAD_INSERT, 0, GetBodygroup() );

					m_pPlayer.m_flNextAttack = (37.0/40.20);
					m_flNextReload = WeaponTimeBase() + (37.0/40.20);
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (37.0/40.20);

					self.m_iClip += 1;
					iAmmo -= 1;
				}
			}
		}
		else if( (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) >= 5 && !m_fRifleReload )
		{
			if( m_reloadTimer < g_Engine.time )
			{
				@CSRemoveBullet = @g_Scheduler.SetTimeout( @this, "RemovePrimAmmo", 0.83f );

				if( self.m_iClip <= 1 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 5 )
					Reload( MAX_CLIP, (self.m_iClip > 0) ? RELOAD_2CLIP : RELOAD_2CLIP_EMPTY, (266.0/38.0), SetBodygroup() );
				else if( self.m_iClip <= 6 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip >= 4 )
				{
					SetThink( ThinkFunction( this.SetCorrectAmmo ) );
					self.pev.nextthink = g_Engine.time + (172.50/38.0);

					self.SendWeaponAnim( (self.m_iClip > 0) ? RELOAD_1CLIP : RELOAD_1CLIP_EMPTY, 0, SetBodygroup() );
					m_pPlayer.m_flNextAttack = (173.0/38.0);
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (173.0/38.0);
				}

				canReload = false;
			}
		}

		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, iAmmo );
		BaseClass.Reload();
	}

	void SetCorrectAmmo()
	{
		SetThink( null );
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= 5 )
		{
			self.m_iClip += 5;
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 5 );
		}
		else
		{
			self.m_iClip += m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) );
		}
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle < g_Engine.time )
		{
			if( self.m_iClip == 0 && !m_fRifleReload && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) != 0 )
			{
				//self.Reload();
			}
			else if( m_fRifleReload )
			{
				if( self.m_iClip != MAX_CLIP && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
				{
					self.Reload();
				}
				else
				{
					// reload debounce has timed out
					self.SendWeaponAnim( RELOAD_END, 0, GetBodygroup() );

					m_fRifleReload = false;
					m_bCanBolt = false;
					self.m_flTimeWeaponIdle = g_Engine.time + (48.0/38.50);
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (48.0/38.50);
				}
			}
			else
			{
				m_bCanBolt = false;
				if( WeaponADSMode == INS2BASE::IRON_IN )
				{
					if( WeaponADSMode == INS2BASE::IRON_IN )
						self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() );
					else
						self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() );

					self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
				}
			}
		}
	}
}

class ENFIELD_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2enfield";
}

string GetName()
{
	return "weapon_ins2enfield";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_ENFIELD::weapon_ins2enfield", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_ENFIELD::ENFIELD_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}