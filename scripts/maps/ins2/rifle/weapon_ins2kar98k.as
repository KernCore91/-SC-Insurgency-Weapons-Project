// Insurgency's Karabiner 98K + Schießbecher
/* Model Credits
/ Model: McGibs (Forgotten Hope 2), New World Interactive (Schießbecher), Norman The Loli Pirate
/ Textures: McGibs (Forgotten Hope 2), New World Interactive (Schießbecher), Norman The Loli Pirate
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model, UV Chop), KernCore (Schießbecher UV Chop), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"

namespace INS2_K98K
{

// Animations
enum INS2_K98K_Animations
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
	BOLT,
	RELOAD_CLIP,
	RELOAD_CLIP_EMPTY,
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
	GL_IN,
	GL_IN_EMPTY,
	GL_OUT,
	GL_OUT_EMPTY_CLIP1,
	GL_OUT_EMPTY_CLIP2,
	GL_OUT_EMPTY_BOTH,
	GL_IDLE,
	GL_IDLE_EMPTY,
	GL_DRAW,
	GL_DRAW_EMPTY,
	GL_HOLSTER,
	GL_HOLSTER_EMPTY,
	GL_FIRE,
	GL_DRYFIRE,
	GL_RELOAD,
	GL_IRON_IDLE,
	GL_IRON_IDLE_EMPTY,
	GL_IRON_FIRE,
	GL_IRON_DRYFIRE,
	GL_IRON_TO,
	GL_IRON_TO_EMPTY,
	GL_IRON_FROM,
	GL_IRON_FROM_EMPTY
};

enum K98K_Bodygroups
{
	ARMS = 0,
	K98K_STUDIO0,
	K98K_STUDIO1,
	CLIP_ROUNDS
};

// Models
string W_MODEL = "models/ins2/wpn/kar98/w_k98.mdl";
string V_MODEL = "models/ins2/wpn/kar98/v_k98.mdl";
string P_MODEL = "models/ins2/wpn/kar98/p_k98.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 29;
string G_MODEL = "models/ins2/wpn/kar98/30mm.mdl";
// Sprites
string SPR_CAT = "ins2/rfl/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/kar98/shoot.ogg";
string EMPTY_S = "ins2/wpn/kar98/empty.ogg";
string SHOOTGL = "ins2/wpn/kar98/glshoot.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 5;
int MAX_CARRY2  	= 1000;
int MAX_CLIP2   	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int DEFAULT_GIVE2	= MAX_CLIP2 * 3;
int WEIGHT      	= 100;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 65;
uint DAMAGE_GL  	= 155;
uint SLOT       	= 6;
uint POSITION   	= 4;
float RPM_AIR   	= 1.3; //Rounds per minute in air
uint AIM_FOV    	= 37; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_7.92x57mm";
string AMMO_TYPE2	= "ins2_30x250mm";
string PROJ_NAME 	= "proj_ins2kar98k";

class weapon_ins2kar98k : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn, m_fRifleReload, m_bCanBolt, m_bIsSwitching;
	private float m_flNextReload;
	private int GetBodygroup()
	{
		return 0;
	}
	private int SetBodygroup()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= 5 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CLIP_ROUNDS, 4 );
		else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CLIP_ROUNDS, 0 );
		else
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CLIP_ROUNDS, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) < 5 )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip >= 5 )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CLIP_ROUNDS, 4 );
			else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip < 5 )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, CLIP_ROUNDS, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + (self.m_iClip - 1) );
		}

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/kar98/bltbk.ogg",
		"ins2/wpn/kar98/bltfd.ogg",
		"ins2/wpn/kar98/bltfd2.ogg",
		"ins2/wpn/kar98/bltlat.ogg",
		"ins2/wpn/kar98/bltrel.ogg",
		"ins2/wpn/kar98/gload1.ogg",
		"ins2/wpn/kar98/gload2.ogg",
		"ins2/wpn/kar98/grem.ogg",
		"ins2/wpn/kar98/magin.ogg",
		"ins2/wpn/kar98/ins.ogg",
		"ins2/wpn/kar98/ammoin.ogg",
		"ins2/wpn/kar98/clip.ogg",
		SHOOTGL,
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		m_bIsSwitching = false;
		WeaponADSMode = INS2BASE::IRON_OUT;
		WeaponGLMode = INS2BASE::GL_NOTAIMED;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
		self.m_iClip2 = 0;
		self.m_iDefaultSecAmmo = DEFAULT_GIVE2;
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( A_MODEL );
		g_Game.PrecacheModel( G_MODEL );
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_792x57 );

		g_Game.PrecacheOther( PROJ_NAME );
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
		info.iMaxAmmo2 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY2 : INS2BASE::DF_MAX_CARRY_ARGR;
		info.iAmmo2Drop	= MAX_CLIP2;
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

		/*//Workaround for a ammo bug
		if( WeaponGLMode == INS2BASE::GL_NOTAIMED && self.m_iClip2 > 0 )
		{
			m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
			self.m_iClip2 = 0;
		}*/

		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "sniper", GetBodygroup(), (121.0/35.0) );
		}
		else
		{
			if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
			{
				if( m_bCanBolt )
				{
					SetThink( ThinkFunction( this.BoltBackThink ) );
					self.pev.nextthink = g_Engine.time + (21.0/31.0);
				}
				return Deploy( V_MODEL, P_MODEL, (self.m_iClip <= 0 || m_bCanBolt) ? DRAW_EMPTY : DRAW, "sniper", GetBodygroup(), (22.0/31.0) );
			}
			else
				return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? GL_DRAW : GL_DRAW_EMPTY, "sniper", GetBodygroup(), (29.0/32.0) );
		}
	}

	void BoltBackThink()
	{
		SetThink( null );

		if( self.m_iClip > 0 ) //Checking again in case the player depleted the ammo and didn't let go of the attack button
		{
			self.SendWeaponAnim( BOLT, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (36.0/35.0);
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (43.0/35.0);

			SetThink( ThinkFunction( this.ShellEjectThink ) );
			self.pev.nextthink = WeaponTimeBase() + 0.514;
		}
		m_bCanBolt = false;
	}

	void Holster( int skipLocal = 0 )
	{
		if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
		{
			if( self.m_iClip2 > 0 )
			{
				WeaponGLMode = INS2BASE::GL_AIMED;
				//m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
				//self.m_iClip2 = 0;
			}
		}

		m_pPlayer.m_szAnimExtension = "sniper";
		m_fRifleReload = false;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
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
	
			ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 3.0f, 0.3f, 1.5f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 16384, DAMAGE, true, DMG_SNIPER | DMG_NEVERGIB );
	
			m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;
	
			PunchAngle( Vector( Math.RandomFloat( -2.775, -3.225 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.75 : 1.0, Math.RandomFloat( -0.5, 0.5 ) ) );
	
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
		else
		{
			if( self.m_iClip2 <= 0 )
			{
				self.PlayEmptySound();
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? GL_IRON_DRYFIRE : GL_DRYFIRE, 0, GetBodygroup() );
				self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
				return;
			}

			Vector ang_Aim = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
			Math.MakeVectors( ang_Aim + Vector( -2, 0, 0 ) );
			--self.m_iClip2;

			Vector vecStart;
			if( WeaponADSMode != INS2BASE::IRON_IN )
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -1 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -2 + m_pPlayer.pev.view_ofs * 0.25;
			else
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 3 + g_Engine.v_right * 5 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 3 + g_Engine.v_right * 5 + m_pPlayer.pev.view_ofs * 0.01;
			
			Vector vecVeloc = g_Engine.v_forward * 1500 + g_Engine.v_up * 32;

			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOTGL, Math.RandomFloat( 0.95, 1.0 ), 0.7, 0, 95 + Math.RandomLong( 0, 0x9 ) );
			INS2GLPROJECTILE::CIns2GL@ pGL = INS2GLPROJECTILE::ShootGrenade( m_pPlayer.pev, vecStart, vecVeloc, DAMAGE_GL, G_MODEL, false, PROJ_NAME );

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? GL_IRON_FIRE : GL_FIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.5;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0;

			PunchAngle( Vector( Math.RandomFloat( -7, -8 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.15f : 1.45f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}
	}

	void ShellEjectThink() //For the think function used in shoot
	{
		SetThink( null );
		m_bCanBolt = false;
		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 16, 6.3, -6.5 ) : Vector( 15, 0, -3.5 ) );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				if( self.m_iClip > 0 )
					self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_TO : IRON_TO, 0, GetBodygroup() );
				else
					self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_TO_EMPTY : IRON_TO_EMPTY, 0, GetBodygroup() );

				m_pPlayer.m_szAnimExtension = "sniperscope";
				EffectsFOVON( AIM_FOV );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				if( self.m_iClip > 0 )
					self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_FROM : IRON_FROM, 0, GetBodygroup() );
				else
					self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_FROM_EMPTY : IRON_FROM_EMPTY, 0, GetBodygroup() );

				m_pPlayer.m_szAnimExtension = "sniper";
				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) == 0 && WeaponGLMode == INS2BASE::GL_NOTAIMED )
			return;

		m_bIsSwitching = true;

		self.Reload();
		self.m_flTimeWeaponIdle = self.m_flNextTertiaryAttack = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + 1;
	}

	void ItemPostFrame()
	{
		// Checks if the player pressed one of the attack buttons, stops the reload and then attack
		if( m_fRifleReload )
		{
			if( (CheckButton() || (self.m_iClip >= MAX_CLIP && m_pPlayer.pev.button & IN_RELOAD != 0)) && m_flNextReload <= g_Engine.time )
			{
				self.SendWeaponAnim( RELOAD_END, 0, GetBodygroup() );

				self.m_flTimeWeaponIdle = g_Engine.time + (48.0/36.0);
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + (48.0/36.0);
				m_fRifleReload = false;
			}
		}
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
		if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
		{
			if( !m_bIsSwitching )
			{
				if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
					return;
			}

			//Get out of Iron Sights
			if( WeaponADSMode == INS2BASE::IRON_IN )
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
				m_reloadTimer = g_Engine.time + 0.16;
				m_pPlayer.m_flNextAttack = 0.16;
				m_pPlayer.m_szAnimExtension = "sniper";
				canReload = true;
				EffectsFOVOFF();
			}

			int iAmmo = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );

			if( m_reloadTimer < g_Engine.time )
			{
				//Check if we're switching to grenade mode
				if( m_bIsSwitching )
				{
					if( self.m_iClip2 == 0 )
					{
						GrenadeLauncherSwitch( (self.m_iClip > 0) ? GL_IN : GL_IN_EMPTY, (self.m_iClip == 0) ? GL_OUT_EMPTY_BOTH : GL_OUT_EMPTY_CLIP2, GetBodygroup(), (235.0/39.0), (79.0/35.0) );
					}
					else
					{
						GrenadeLauncherSwitch( (self.m_iClip > 0) ? GL_IN : GL_IN_EMPTY, (self.m_iClip == 0) ? GL_OUT_EMPTY_CLIP1 : GL_OUT, GetBodygroup(), (235.0/39.0), (178.0/39.0) );
					}

					SetThink( ThinkFunction( this.GiveAmmo ) );
					self.pev.nextthink = g_Engine.time + (181.0/39.0);
					m_bIsSwitching = false;
					//Doing Reload Stuff here just so you don't reload the weapon without your own input
					m_reloadTimer = 0;
					canReload = false;
					BaseClass.Reload();
					return;
				}

				if( self.m_iClip <= 1 && !m_fRifleReload )				
				{
					Reload( MAX_CLIP, (self.m_iClip > 0) ? RELOAD_CLIP : RELOAD_CLIP_EMPTY, (150.0/39.0), SetBodygroup() );
					SetThink( ThinkFunction( this.RemovePrimAmmo ) );
					self.pev.nextthink = g_Engine.time + 0.81;
					canReload = false;
				}
				else
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
						SetThink( ThinkFunction( this.RemovePrimAmmo ) );
						self.pev.nextthink = g_Engine.time + 0.83;

						m_pPlayer.m_flNextAttack = (43.0/36.0); //Always uses a relative time due to prediction
						self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (43.0/36.0);

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
						m_pPlayer.m_flNextAttack = (37.0/38.0);
						m_flNextReload = WeaponTimeBase() + (37.0/38.0);
						self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (37.0/38.0);

						self.m_iClip += 1;
						iAmmo -= 1;
					}
				}
			}
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, iAmmo );
			BaseClass.Reload();
		}
		else
		{
			if( !m_bIsSwitching )
			{
				if( self.m_iClip2 == MAX_CLIP2 || m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) <= 0 )
					return;
			}

			//Get out of Iron Sights
			if( WeaponADSMode == INS2BASE::IRON_IN )
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? GL_IRON_FROM : GL_IRON_FROM_EMPTY, 0, GetBodygroup() );
				m_reloadTimer = g_Engine.time + 0.16;
				m_pPlayer.m_flNextAttack = 0.16;
				m_pPlayer.m_szAnimExtension = "sniper";
				canReload = true;
				EffectsFOVOFF();
			}

			if( m_reloadTimer < g_Engine.time )
			{
				//Check if we're switching to grenade mode
				if( m_bIsSwitching )
				{
					if( self.m_iClip2 == 0 )
					{
						GrenadeLauncherSwitch( (self.m_iClip > 0) ? GL_IN : GL_IN_EMPTY, (self.m_iClip == 0) ? GL_OUT_EMPTY_BOTH : GL_OUT_EMPTY_CLIP2, GetBodygroup(), (235.0/39.0), (79.0/35.0) );
					}
					else
					{
						GrenadeLauncherSwitch( (self.m_iClip > 0) ? GL_IN : GL_IN_EMPTY, (self.m_iClip == 0) ? GL_OUT_EMPTY_CLIP1 : GL_OUT, GetBodygroup(), (235.0/39.0), (178.0/39.0) );
					}

					SetThink( ThinkFunction( this.GiveAmmo ) );
					self.pev.nextthink = g_Engine.time + (121.0/39.0);
					m_bIsSwitching = false;
					//Doing Reload Stuff here just so you don't reload the weapon without your own input
					m_reloadTimer = 0;
					canReload = false;
					BaseClass.Reload();
					return;
				}

				ReloadSecondary( MAX_CLIP2, GL_RELOAD, (182.0/39.0), GetBodygroup() );
				canReload = false;
			}
			BaseClass.Reload();
		}
	}

	void RemovePrimAmmo()
	{
		if( self.m_iClip > 0 )
		{
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + 1 );
			--self.m_iClip;
		}
		else
			ShellEject( m_pPlayer, m_iShell, Vector( 16.5, 4.5, -6 ) );
	}

	void GiveAmmo()
	{
		SetThink( null );
		if( WeaponGLMode == INS2BASE::GL_AIMED )
		{
			if( self.m_iClip2 <= 0 && m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) > 0 )
			{
				m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) - MAX_CLIP2 );
				self.m_iClip2 = MAX_CLIP2;
			}
			else if( self.m_iClip2 > 0 )
			{
				m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
				self.m_iClip2 = 0;
			}
		}
		else if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
		{
			m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
			self.m_iClip2 = 0;
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
					self.m_flTimeWeaponIdle = g_Engine.time + (48.0/36.0);
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + (48.0/35.0);
				}
			}
			else
			{
				if( WeaponADSMode == INS2BASE::IRON_IN )
				{
					if( self.m_iClip > 0 )
						self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_NOTAIMED) ? IRON_IDLE : GL_IRON_IDLE, 0, GetBodygroup() );
					else
						self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_NOTAIMED) ? IRON_IDLE_EMPTY : GL_IRON_IDLE_EMPTY, 0, GetBodygroup() );
				}
				else
				{
					if( self.m_iClip > 0 )
						self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_NOTAIMED) ? IDLE : GL_IDLE, 0, GetBodygroup() );
					else
						self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_NOTAIMED) ? IDLE_EMPTY : GL_IDLE_EMPTY, 0, GetBodygroup() );
				}
				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
			}
		}
	}
}

class K98K_CLIP : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		//g_SoundSystem.PrecacheSound( CoFCOMMON::ITEM_SOUND_PICK );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_357, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357 );
	}
}

class SCHIESSBECHER_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, G_MODEL );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( G_MODEL );
		CommonPrecache();
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP2, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY2 : INS2BASE::DF_MAX_CARRY_ARGR, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_ARGR );
	}
}

string GetAmmoName()
{
	return "ammo_ins2kar98k";
}

string GetGLName()
{
	return "ammo_ins2kar98kgl";
}

string GetName()
{
	return "weapon_ins2kar98k";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_K98K::weapon_ins2kar98k", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_K98K::K98K_CLIP", GetAmmoName() ); // Register the ammo entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_K98K::SCHIESSBECHER_MAG", GetGLName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_ARGR, GetAmmoName(), GetGLName() ); // Register the weapon
}

}