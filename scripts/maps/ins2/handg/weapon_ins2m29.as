// Insurgency's Smith & Wesson Model 29
/* Model Credits
/ Model: Bingo Johnson
/ Textures: NZ-Reason, Norman The Loli Pirate (Edits)
/ Animations: New World Interactive, Norman The Loli Pirate (Edits), D.N.I.O. 071 (Edits)
/ Sounds: New World Interactive, Firearms Source Team (Shoot sound edited by KernCore), D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Schmung (UVs), Norman The Loli Pirate (UV Chop), D.N.I.O. 071 (Compile)
/ Script: KernCore
*/

#include "../base"

namespace INS2_M29
{

// Animations
enum INS2_M29_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
	DRAW_FIRST,
	DRAW,
	DRAW_TOHAMMER,
	DRAW_EMPTY,
	HOLSTER,
	HOLSTER_EMPTY,
	FIRE1,
	FIRE2,
	FIRE_LAST,
	DRYFIRE,
	HAMMER,
	RELOAD_START,
	RELOAD_START_EMPTY,
	RELOAD_INSERT_1,
	RELOAD_INSERT_2,
	RELOAD_INSERT_3,
	RELOAD_INSERT_4,
	RELOAD_INSERT_5,
	RELOAD_INSERT_6,
	RELOAD_END_FULL,
	RELOAD_END_1,
	RELOAD_END_2,
	RELOAD_END_3,
	RELOAD_END_4,
	RELOAD_END_5,
	RELOAD_END_EMPTY,
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

enum M29_Bodygroups
{
	ARMS = 0,
	M29_STUDIO0,
	ROUNDS,
	CASINGS
};

// Models
string W_MODEL = "models/ins2/wpn/m29/w_m29.mdl";
string V_MODEL = "models/ins2/wpn/m29/v_m29.mdl";
string P_MODEL = "models/ins2/wpn/m29/p_m29.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 38;
// Sprites
string SPR_CAT = "ins2/hdg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/m29/shoot.ogg";
string EMPTY_S = "ins2/wpn/m29/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 6;
int DEFAULT_GIVE 	= MAX_CLIP * 6;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 55;
uint SLOT       	= 1;
uint POSITION   	= 14;
float RPM_AIR   	= 1.0f; //Rounds per minute in air
float SHOOT_DELAY 	= 0.028; //Shooting delay
float EMPTY_DELAY 	= 0.1; //Shooting delay for dryfire
uint AIM_FOV    	= 49; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_44magnum";

class weapon_ins2m29 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn, m_fRevolverReload, m_bCanBolt;
	private float m_flNextReload;
	private int iBody;
	private int GetBodygroup()
	{
		m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CASINGS, iBody );
		m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, ROUNDS, (self.m_iClip >= 6) ? 6 : self.m_iClip );

		return m_iCurBodyConfig;
	}
	private int SetBodygroup()
	{
		m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CASINGS, (self.m_iClip <= 6) ? 1 + self.m_iClip : self.m_iClip );

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/m29/close.ogg",
		"ins2/wpn/m29/cock.ogg",
		"ins2/wpn/m29/dump.ogg",
		"ins2/wpn/m29/ins.ogg",
		"ins2/wpn/m29/open.ogg",
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		iBody = 6;
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

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployPistolSounds );
		
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "python", GetBodygroup(), (35.0/30.0) );
		}
		else
		{
			if( m_bCanBolt )
			{
				SetThink( ThinkFunction( this.HammerBackThink ) );
				self.pev.nextthink = g_Engine.time + (14.0/32.0);
				return Deploy( V_MODEL, P_MODEL, DRAW_TOHAMMER, "python", GetBodygroup(), (15.0/32.0) );
			}
			else
			{
				return Deploy( V_MODEL, P_MODEL, (self.m_iClip == 0) ? DRAW_EMPTY : DRAW, "python", GetBodygroup(), (15.0/32.0) );
			}
		}
	}

	void HammerBackThink()
	{
		SetThink( null );

		if( self.m_iClip > 0 ) //Checking again in case the player depleted the ammo and didn't let go of the attack button
		{
			self.SendWeaponAnim( HAMMER, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (28.0/35.0);
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (34.0/35.0);
		}
		m_bCanBolt = false;
	}

	void Holster( int skipLocal = 0 )
	{
		m_fRevolverReload = false;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void ShootThink()
	{
		SetThink( null );

		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (34.0/35.0);
			return;
		}

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 2.75f, 0.4f, 1.25f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, false, DMG_SNIPER );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -6.00f, -5.00f ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.00f : 1.00f, Math.RandomFloat( -0.75, 0.75 ) ) );
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + RPM_AIR;

		if( self.m_iClip > 0 )
		{
			m_bCanBolt = true;
			SetThink( ThinkFunction( this.HammerThink ) );
			self.pev.nextthink = WeaponTimeBase() + (25.0/35.0);
		}
		else
			SetThink( null );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			//self.PlayEmptySound();
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;

			SetThink( ThinkFunction( this.ShootThink ) );
			self.pev.nextthink = g_Engine.time + EMPTY_DELAY;
			return;
		}

		if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
			return;

		SetThink( ThinkFunction( this.ShootThink ) );
		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (SHOOT_DELAY * 2);
		self.pev.nextthink = g_Engine.time + SHOOT_DELAY;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 1) ? IRON_FIRE : IRON_FIRE_LAST, 0, GetBodygroup() ); //hack: self.m_iClip > 1 because it will get show the firelast anim a few moments after
		else
			self.SendWeaponAnim( (self.m_iClip > 1) ? Math.RandomLong( FIRE1, FIRE2 ) : FIRE_LAST, 0, GetBodygroup() ); //hack: self.m_iClip > 1 because it will get show the firelast anim a few moments after
	}

	void HammerThink() //For the think function used in shoot
	{
		SetThink( null );
		m_bCanBolt = false;
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

	void RemoveAmmoThink()
	{
		SetThink( null );
		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip );
		self.m_iClip = 0;
		iBody = 0;
		//g_Game.AlertMessage( at_console, "Save Ammo in ThinkFunction: " + saveammo + "\n" );
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
		if( m_fRevolverReload )
		{
			if( (CheckButton() || (self.m_iClip >= MAX_CLIP && m_pPlayer.pev.button & IN_RELOAD != 0)) && m_flNextReload <= g_Engine.time )
			{
				if( self.m_iClip == 0 )
				{
					//self.SendWeaponAnim( RELOAD_END_EMPTY, 0, GetBodygroup() );
					self.Reload(); // Continue reloading until there's 1 bullet in the cylinder
					BaseClass.ItemPostFrame();
					return;
				}
				else
					self.SendWeaponAnim( (self.m_iClip < 6) ? RELOAD_END_FULL + self.m_iClip : RELOAD_END_FULL, 0, GetBodygroup() );

				self.m_flTimeWeaponIdle = g_Engine.time + (69.0/40.0);
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (69.0/40.0);
				m_fRevolverReload = false;
				m_bCanBolt = false;
				//g_Game.AlertMessage( at_console, "Save Ammo in Reload End: " + GetBodygroup() + "\n" );
			}
		}
		BaseClass.ItemPostFrame();
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		int iAmmo = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );

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
			if( m_flNextReload > WeaponTimeBase() )
				return;

			// don't reload until recoil is done
			if( self.m_flNextPrimaryAttack > WeaponTimeBase() && !m_fRevolverReload )
			{
				m_fRevolverReload = false;
				return;
			}
			if( !m_fRevolverReload )
			{
				if( self.m_iClip <= 0 )
				{
					self.SendWeaponAnim( RELOAD_START_EMPTY, 0, GetBodygroup() );

					m_pPlayer.m_flNextAttack = (99.0/40.0); //Always uses a relative time due to prediction
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (100.0/40.0);
				}
				else
				{
					self.SendWeaponAnim( RELOAD_START, 0, GetBodygroup() );

					m_pPlayer.m_flNextAttack = (75.0/40.0); //Always uses a relative time due to prediction
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (76.0/40.0);
				}
				SetThink( ThinkFunction( this.RemoveAmmoThink ) );
				self.pev.nextthink = WeaponTimeBase() + (50.0/40.0);

				canReload = false;
				m_fRevolverReload = true;
				return;
			}
			else if( m_fRevolverReload )
			{
				if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
					return;

				if( self.m_iClip == MAX_CLIP )
				{
					m_fRevolverReload = false;
					return;
				}

				self.SendWeaponAnim( (self.m_iClip < 6) ? RELOAD_INSERT_1 + self.m_iClip : RELOAD_INSERT_6, 0, SetBodygroup() );

				m_flNextReload = WeaponTimeBase() + (38.0/40.0);
				self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (38.0/40.0);

				iBody += 1;
				//g_Game.AlertMessage( at_console, "Save Ammo in Reload Insert: " + iBody + "\n" );
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

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if( self.m_flTimeWeaponIdle < g_Engine.time )
		{
			if( self.m_iClip == 0 && !m_fRevolverReload && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) != 0 )
			{
				//self.Reload();
			}
			else if( m_fRevolverReload )
			{
				if( self.m_iClip != MAX_CLIP && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
				{
					self.Reload();
				}
				else
				{
					// reload debounce has timed out
					if( self.m_iClip == 0 )
						self.SendWeaponAnim( RELOAD_END_EMPTY, 0, GetBodygroup() );
					else
						self.SendWeaponAnim( (self.m_iClip < 6) ? RELOAD_END_FULL + self.m_iClip : RELOAD_END_FULL, 0, GetBodygroup() );

					m_fRevolverReload = false;
					m_bCanBolt = false;
					self.m_flTimeWeaponIdle = g_Engine.time + (69.0/40.0);
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + (69.0/40.0);
				}
			}
			else
			{
				m_bCanBolt = false;
				if( self.m_iClip > 0 )
					self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE : IDLE, 0, GetBodygroup() );
				else
					self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_IDLE_EMPTY : IDLE_EMPTY, 0, GetBodygroup() );

				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
			}
		}
	}
}

class M29_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2m29";
}

string GetName()
{
	return "weapon_ins2m29";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M29::weapon_ins2m29", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M29::M29_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}