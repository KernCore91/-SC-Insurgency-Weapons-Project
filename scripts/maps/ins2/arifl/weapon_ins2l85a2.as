// Insurgency's SA80 L85A2
/* Model Credits
/ Model: Milo (L85), B0T (PMag), Project Reality Team (AG-36, Heatguard), Norman The Loli Pirate (SUSAT Insides, 40mm Nade)
/ Textures: Milo (L85), B0T (PMag), Project Reality Team (AG-36, Heatguard), Norman The Loli Pirate (L85 Dark Green edits, 40mm Nade)
/ Animations: Mr. Brightside
/ Sounds: Navaro, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (AG-36 UV Chop), D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"
#include "weapon_ins2m16a4" // Grenade Ammo

namespace INS2_L85A2
{

// Animations
enum INS2_L85A2_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE1,
	FIRE2,
	DRYFIRE,
	FIRESELECT,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE1,
	IRON_FIRE2,
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
string W_MODEL = "models/ins2/wpn/l85a2/w_l85a2.mdl";
string V_MODEL = "models/ins2/wpn/l85a2/v_l85a2.mdl";
string P_MODEL = "models/ins2/wpn/l85a2/p_l85a2.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 40;
string G_MODEL = "models/ins2/wpn/m16a4/m203.mdl";
// Sprites
string SPR_CAT = "ins2/arf/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/l85a2/shoot.ogg";
string EMPTY_S = "ins2/wpn/l85a2/empty.ogg";
string SHOOTGL = "ins2/wpn/ag36/shoot.ogg";
string EMPTYGL = "ins2/wpn/m203/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 30;
int MAX_CARRY2  	= 1000;
int MAX_CLIP2   	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int DEFAULT_GIVE2	= MAX_CLIP2 * 2;
int WEIGHT      	= 35;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 24;
uint DAMAGE_GL  	= 145;
uint SLOT       	= 5;
uint POSITION   	= 18;
float RPM_AIR   	= 652;
float RPM_WTR   	= 525;
string AMMO_TYPE 	= "ins2_5.56x45mm";
string AMMO_TYPE2	= "ins2_40x46mm";
string PROJ_NAME 	= "proj_ins2l85a2";

class weapon_ins2l85a2 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
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
		"ins2/wpn/l85a2/bltbk.ogg",
		"ins2/wpn/l85a2/bltrel.ogg",
		"ins2/wpn/l85a2/hit.ogg",
		"ins2/wpn/l85a2/magin.ogg",
		"ins2/wpn/l85a2/magout.ogg",
		"ins2/wpn/l85a2/magrel.ogg",
		"ins2/wpn/l85a2/rof.ogg",
		"ins2/wpn/m203/close.ogg",
		"ins2/wpn/m203/desel.ogg",
		"ins2/wpn/m203/drop.ogg",
		"ins2/wpn/m203/ins.ogg",
		"ins2/wpn/m203/open.ogg",
		"ins2/wpn/m203/sel.ogg",
		EMPTY_S,
		SHOOT_S,
		SHOOTGL,
		EMPTYGL
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_556x45 );

		g_Game.PrecacheOther( PROJ_NAME );
		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( GrenadeExplode );
		INS2BASE::PrecacheSound( GrenadeWaterExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_ins2_MGs.txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_556;
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
		return CommonPlayEmptySound( (WeaponGLMode == INS2BASE::GL_AIMED) ? EMPTYGL : EMPTY_S );
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		DisplayFiremodeSprite();
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (72.0/32.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_DRAW : DRAW, "m16", GetBodygroup(), (22.0/31.0) );
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
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 4.75 + g_Engine.v_up * -3.2 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 4.75 + g_Engine.v_up * -3.2 + m_pPlayer.pev.view_ofs * 0.25;
			else
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 2 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 2 + m_pPlayer.pev.view_ofs * 0.01;
			
			Vector vecVeloc = g_Engine.v_forward * 1450 + g_Engine.v_up * 28;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOTGL, Math.RandomFloat( 0.95, 1.0 ), 0.7, 0, 95 + Math.RandomLong( 0, 0x9 ) );
			INS2GLPROJECTILE::CIns2GL@ pGL = INS2GLPROJECTILE::ShootGrenade( m_pPlayer.pev, vecStart, vecVeloc, DAMAGE_GL, G_MODEL, false, PROJ_NAME );
			pGL.pev.body = 1;

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? GL_IRON_FIRE : GL_FIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.5;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0;
			PunchAngle( Vector( Math.RandomFloat( -2.55, -3.6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.15 : 1.45, Math.RandomFloat( -0.5, 0.5 ) ) );

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

			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

			ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 1.8f, 0.75f, 2.25f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

			m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

			if( WeaponADSMode != INS2BASE::IRON_IN )
			{
				if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
					KickBack( 1.0, 0.3, 0.225, 0.03, 3.5, 2.5, 5 );
				else if( m_pPlayer.pev.velocity.Length2D() > 0 )
					KickBack( 0.95, 0.3, 0.225, 0.03, 3.5, 2.5, 7 );
				else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
					KickBack( 0.30, 0.175, 0.125, 0.02, 2.25, 1.25, 10 );
				else
					KickBack( 0.8, 0.2, 0.15, 0.0225, 2.5, 1.5, 8 );
			}
			else
			{
				PunchAngle( Vector( Math.RandomFloat( -2.55, -2.25 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.5f : 0.7f, Math.RandomFloat( -0.5, 0.5 ) ) );
			}

			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE2 ), 0, GetBodygroup() );
			else
				self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE2 ), 0, GetBodygroup() );

			ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 10, 6, -9 ) : Vector( 10, 1, -5 ) );
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
				EffectsFOVON( 30 );
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
			GrenadeLauncherSwitch( GL_IRON_IN, GL_IRON_OUT, GetBodygroup(), (25.0/32.0), (28.0/32.0) );
		else
			GrenadeLauncherSwitch( GL_IN, GL_OUT, GetBodygroup(), (25.0/32.0), (28.0/32.0) );
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
				ReloadSecondary( MAX_CLIP2, GL_RELOAD, (116.0/30.0), GetBodygroup() );
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
			ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_SEMI, (23.0/30.0) );

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
				(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (136.0/30.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (115.0/30.0), GetBodygroup() );
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

		if( WeaponADSMode != INS2BASE::IRON_IN )
			self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IDLE : IDLE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_IRON_IDLE : IRON_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class L85A2_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_556, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556 );
	}
}

class L123A2_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2l85a2";
}

string GetGLName()
{
	return "ammo_ins2l85a2gl";
}

string GetName()
{
	return "weapon_ins2l85a2";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_L85A2::weapon_ins2l85a2", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_L85A2::L85A2_MAG", GetAmmoName() ); // Register the ammo entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_L85A2::L123A2_MAG", GetGLName() ); // Register the ammo entity

	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_ARGR, GetAmmoName(), GetGLName() ); // Register the weapon
}

}