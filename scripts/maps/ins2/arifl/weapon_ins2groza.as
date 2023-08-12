// Insurgency's OTs-14-4A-04 9/40
/* Model Credits
/ Model: 1ns1debeast, Norman The Loli Pirate
/ Textures: 1ns1debeast, Norman The Loli Pirate
/ Animations: D.N.I.O. 071
/ Sounds: New World Interactive, Navaro, Magmacow, S.T.A.L.K.E.R. Anomaly Team
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"

namespace INS2_GROZA
{

// Animations
enum INS2_GROZA_Animations
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
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE3,
	IRON_DRYFIRE,
	IRON_FIRESELECT,
	IRON_TO,
	IRON_FROM,
	GL_IN,
	GL_OUT,
	GL_IDLE,
	GL_DRAW,
	GL_HOLSTER,
	GL_FIRE,
	GL_DRYFIRE,
	GL_RELOAD,
	GL_IRON_IDLE,
	GL_IRON_FIRE,
	GL_IRON_DRYFIRE,
	GL_IRON_TO,
	GL_IRON_FROM,
	GL_IRON_IN,
	GL_IRON_OUT
};

// Models
string W_MODEL = "models/ins2/wpn/groza/w_groza.mdl";
string V_MODEL = "models/ins2/wpn/groza/v_groza.mdl";
string P_MODEL = "models/ins2/wpn/groza/p_groza.mdl";
string G_MODEL = "models/ins2/wpn/akm/vog25.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 5;
// Sprites
string SPR_CAT = "ins2/arf/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/groza/shoot.ogg";
string EMPTY_S = "ins2/wpn/ak74/empty.ogg";
string SHOOTGL = "ins2/wpn/gp30/shoot.ogg";
string EMPTYGL = "ins2/wpn/gp30/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 20;
int MAX_CARRY2  	= 1000;
int MAX_CLIP2   	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int DEFAULT_GIVE2	= MAX_CLIP2 * 2;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 18;
uint DAMAGE_GL  	= 130;
float SPEED     	= 1325;
uint SLOT       	= 5;
uint POSITION   	= 12;
float RPM_AIR   	= 650; //Rounds per minute in air
float RPM_WTR   	= 550; //Rounds per minute in water
uint AIM_FOV    	= 40; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_9x39mm";
string AMMO_TYPE2	= "ins2_40x53mm";
string PROJ_NAME 	= "proj_ins2groza";

class weapon_ins2groza : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/groza/bltbk.ogg",
		"ins2/wpn/groza/bltfd.ogg",
		"ins2/wpn/groza/clik.ogg",
		"ins2/wpn/groza/desel.ogg",
		"ins2/wpn/groza/magin.ogg",
		"ins2/wpn/groza/magout.ogg",
		"ins2/wpn/groza/magrel.ogg",
		"ins2/wpn/groza/rof.ogg",
		"ins2/wpn/groza/sel.ogg",
		"ins2/wpn/groza/swtch.ogg",
		SHOOTGL,
		EMPTYGL,
		EMPTY_S,
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		WeaponADSMode = INS2BASE::IRON_OUT;
		WeaponSelectFireMode = INS2BASE::SELECTFIRE_AUTO;
		WeaponGLMode = INS2BASE::GL_NOTAIMED;
		self.m_iClip2 = MAX_CLIP2;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_9x39 );

		g_Game.PrecacheOther( PROJ_NAME );
		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( GrenadeExplode );
		INS2BASE::PrecacheSound( GrenadeWaterExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_MGs_big.txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_9MM;
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
		DisplayFiremodeSprite();
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (75.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_DRAW : DRAW, "m16", GetBodygroup(), (25.0/31.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( WeaponGLMode == INS2BASE::GL_AIMED )
		{
			if( self.m_iClip2 <= 0 )
			{
				self.PlayEmptySound();
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? GL_IRON_DRYFIRE : GL_DRYFIRE, 0, GetBodygroup() );
				self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
				return;
			}

			Vector ang_Aim = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
			Math.MakeVectors( ang_Aim );
			--self.m_iClip2;

			Vector vecStart;
			if( WeaponADSMode != INS2BASE::IRON_IN )
			{
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 4 + g_Engine.v_up * -4 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 4 + g_Engine.v_up * -4 + m_pPlayer.pev.view_ofs * 0.25;
			}
			else
			{
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * -2 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * -2 + m_pPlayer.pev.view_ofs * 0.01;
			}

			Vector vecVeloc = g_Engine.v_forward * SPEED + g_Engine.v_up * 8;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOTGL, Math.RandomFloat( 0.95, 1.0 ), 0.7, 0, 95 + Math.RandomLong( 0, 0x9 ) );
			INS2GLPROJECTILE::CIns2GL@ pGL = INS2GLPROJECTILE::ShootGrenade( m_pPlayer.pev, vecStart, vecVeloc, DAMAGE_GL, G_MODEL, false, PROJ_NAME );

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? GL_IRON_FIRE : GL_FIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.75;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0;
			PunchAngle( Vector( Math.RandomFloat( -3.0, -4.6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.5f : 1.5f, Math.RandomFloat( -1.5, 1.5 ) ) );

			//Manually set M203 Shoot animation on the player
			m_pPlayer.m_Activity = ACT_RELOAD;
			m_pPlayer.pev.frame = 0;
			m_pPlayer.pev.sequence = 148;
			m_pPlayer.ResetSequenceInfo();
		}
		else
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

			if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( RPM_WTR );
			else
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( RPM_AIR );

			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

			ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 1.4f, 0.7f, 1.8f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true, DMG_NEVERGIB );

			m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;

			if( WeaponADSMode != INS2BASE::IRON_IN )
			{
				if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
					KickBack( 1.0  , 0.3  , 0.45 , 0.04 , 5.5 , 2.75 , 8 );
				else if( m_pPlayer.pev.velocity.Length2D() > 0 )
					KickBack( 0.9  , 0.3  , 0.25 , 0.03 , 5.0 , 2.5  , 7 );
				else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
					KickBack( 0.45 , 0.175, 0.125, 0.02 , 2.2 , 1.25 , 5 );
				else
					KickBack( 0.75 , 0.25 , 0.10 , 0.025, 2.6 , 1.65 , 5 );
			}
			else
				PunchAngle( Vector( Math.RandomFloat( -2.775, -3.225 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.75 : 1.0, Math.RandomFloat( -0.5, 0.5 ) ) );

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ) : Math.RandomLong( FIRE1, FIRE3 ), 0, GetBodygroup() );
			ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 10, 6, -9 ) : Vector( 9, 0.75, -5 ) );
		}
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.13;
		
		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_TO : IRON_TO, 0, GetBodygroup() );
				EffectsFOVON( AIM_FOV );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_FROM : IRON_FROM, 0, GetBodygroup() );
				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( WeaponADSMode == INS2BASE::IRON_IN )
			GrenadeLauncherSwitch( GL_IRON_IN, GL_IRON_OUT, GetBodygroup(), (60.0/35.0), (60.0/32.0) );
		else
			GrenadeLauncherSwitch( GL_IN, GL_OUT, GetBodygroup(), (60.0/35.0), (60.0/32.0) );
	}

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		BaseClass.ItemPreFrame();
	}

	void Reload()
	{
		if( WeaponGLMode == INS2BASE::GL_AIMED )
		{
			if( self.m_iClip2 == MAX_CLIP2 || m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) <= 0 )
				return;

			if( WeaponADSMode == INS2BASE::IRON_IN )
			{
				self.SendWeaponAnim( GL_IRON_FROM, 0, GetBodygroup() );
				m_reloadTimer = g_Engine.time + 0.16;
				m_pPlayer.m_flNextAttack = 0.16;
				canReload = true;
				EffectsFOVOFF();
			}

			if( m_reloadTimer < g_Engine.time )
			{
				ReloadSecondary( MAX_CLIP2, GL_RELOAD, (85.0/32.0), GetBodygroup() );
				//Manually set M203 Reload animation on the player
				m_pPlayer.m_Activity = ACT_RELOAD;
				m_pPlayer.pev.frame = 0;
				m_pPlayer.pev.sequence = 150;
				m_pPlayer.ResetSequenceInfo();
				canReload = false;
			}
		}
		else
		{
			ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_SEMI, (37.0/35.0) );

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
				if( self.m_iClip <= 0 )
					Reload( MAX_CLIP, RELOAD_EMPTY, (175.0/37.0), GetBodygroup() );
				else
					Reload( MAX_CLIP, RELOAD, (126.0/37.0), GetBodygroup() );

				canReload = false;
			}

			BaseClass.Reload();
		}
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
			self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_IDLE : IRON_IDLE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IDLE : IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class GROZA_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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

class GP30_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2groza";
}

string GetGLName()
{
	return "ammo_ins2grozagl";
}

string GetName()
{
	return "weapon_ins2groza";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_GROZA::weapon_ins2groza", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_GROZA::GP30_MAG", GetGLName() ); // Register the ammo entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_GROZA::GROZA_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_ARGR, GetAmmoName(), GetGLName() ); // Register the weapon
}

}