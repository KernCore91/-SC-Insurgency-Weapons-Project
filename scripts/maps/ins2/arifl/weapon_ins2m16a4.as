// Insurgency's M16A4
/* Model Credits
/ Model: Twinke Masta (Edits by Sureshot), Hellspike (M203), New World Interactive (Quadrant Sight, Edits by Norman The Loli Pirate), Norman The Loli Pirate (40mm Nade)
/ Textures: Twinke Masta, flamshmizer (M203), New World Interactive (Quadrant Sight, Edits by Norman The Loli Pirate), Norman The Loli Pirate (40mm Nade)
/ Animations: New World Interactive
/ Sounds: New World Interactive, acro (M203 shoot sound), D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Twinke Masta (UVs), D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"

namespace INS2_M16A4
{

// Animations
enum INS2_M16A4_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE,
	DRYFIRE,
	FIRESELECT,
	RELOAD,
	RELOAD_EMPTY,
	IRON_TO,
	IRON_FROM,
	IRON_IDLE,
	IRON_FIRE,
	IRON_DRYFIRE,
	IRON_FIRESELECT,
	GL_IN,
	GL_OUT,
	GL_IDLE,
	GL_DRAW,
	GL_HOLSTER,
	GL_FIRE,
	GL_DRYFIRE,
	GL_RELOAD,
	GL_IRON_TO,
	GL_IRON_FROM,
	GL_IRON_IDLE,
	GL_IRON_FIRE,
	GL_IRON_DRYFIRE,
	GL_IRON_IN,
	GL_IRON_OUT
};

// Models
string W_MODEL = "models/ins2/wpn/m16a4/w_m16.mdl";
string V_MODEL = "models/ins2/wpn/m16a4/v_m16.mdl";
string P_MODEL = "models/ins2/wpn/m16a4/p_m16.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 12;
string G_MODEL = "models/ins2/wpn/m16a4/m203.mdl";
// Sprites
string SPR_CAT = "ins2/arf/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/m16a4/shoot.ogg";
string EMPTY_S = "ins2/wpn/m16a4/empty.ogg";
string SHOOTGL = "ins2/wpn/m203/shoot.ogg";
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
uint DAMAGE     	= 23;
uint DAMAGE_GL  	= 145;
uint SLOT       	= 5;
uint POSITION   	= 17;
float RPM_AIR   	= 950;
float RPM_WTR   	= 700;
string AMMO_TYPE 	= "ins2_5.56x45mm";
string AMMO_TYPE2	= "ins2_40x46mm";
string PROJ_NAME 	= "proj_ins2m16a4";

class weapon_ins2m16a4 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn;
	private int m_iBurstCount = 0, m_iBurstLeft = 0;
	private float m_flNextBurstFireTime = 0;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/m16a4/bltbk.ogg",
		"ins2/wpn/m16a4/bltrel.ogg",
		"ins2/wpn/m16a4/rof.ogg",
		"ins2/wpn/m16a4/hit.ogg",
		"ins2/wpn/m16a4/magin.ogg",
		"ins2/wpn/m16a4/magout.ogg",
		"ins2/wpn/m16a4/magrel.ogg",
		"ins2/wpn/m203/close.ogg",
		"ins2/wpn/m203/desel.ogg",
		"ins2/wpn/m203/drop.ogg",
		"ins2/wpn/m203/ins.ogg",
		"ins2/wpn/m203/open.ogg",
		"ins2/wpn/m203/sel.ogg",
		SHOOTGL,
		EMPTYGL,
		SHOOT_S,
		EMPTY_S
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		WeaponADSMode = INS2BASE::IRON_OUT;
		WeaponSelectFireMode = INS2BASE::SELECTFIRE_3XBURST;
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (72.0/35.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (WeaponGLMode == INS2BASE::GL_AIMED) ? GL_DRAW : DRAW, "m16", GetBodygroup(), (22.0/31.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_iBurstLeft = 0;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	private void FirstAttackCommon()
	{
		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 1.25f, 0.5f, 1.25f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( m_pPlayer.pev.velocity.Length2D() > 0 )
				KickBack( 1.0, 0.45, 0.28, 0.045, 3.75, 3.0, 7 );
			else if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
				KickBack( 1.2, 0.5, 0.23, 0.15, 5.5, 3.5, 6 );
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
				KickBack( 0.6, 0.3, 0.2, 0.0125, 3.25, 2.0, 7 );
			else
				KickBack( 0.65, 0.35, 0.25, 0.015, 3.5, 2.25, 7 );
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -1.875, -2.475 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.6f : 0.6f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( IRON_FIRE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( FIRE, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 17, 6.5, -5.5 ) : Vector( 17, 2.25, -5.5 ) );
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
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -3 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -3 + m_pPlayer.pev.view_ofs * 0.25;
			else
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 2 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 2 + m_pPlayer.pev.view_ofs * 0.01;
			
			Vector vecVeloc = g_Engine.v_forward * 1400 + g_Engine.v_up * 8;
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
			else if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_3XBURST )
			{
				//Fire at most 3 bullets.
				m_iBurstCount = Math.min( 3, self.m_iClip );
				m_iBurstLeft = m_iBurstCount - 1;

				m_flNextBurstFireTime = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
				//Prevent primary attack before burst finishes. Might need to be finetuned.
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.39;
			}

			FirstAttackCommon();
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
				EffectsFOVON( 40 );
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
			GrenadeLauncherSwitch( GL_IRON_IN, GL_IRON_OUT, GetBodygroup(), (25.0/31.50), (28.0/31.50) );
		else
			GrenadeLauncherSwitch( GL_IN, GL_OUT, GetBodygroup(), (25.0/31.50), (28.0/31.50) );
	}

	void ItemPostFrame()
	{
		if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_3XBURST )
		{
			if( m_iBurstLeft > 0 )
			{
				if( m_flNextBurstFireTime < WeaponTimeBase() )
				{
					if( self.m_iClip <= 0 )
					{
						m_iBurstLeft = 0;
						return;
					}
					else
						--m_iBurstLeft;

					FirstAttackCommon();

					if( m_iBurstLeft > 0 )
						m_flNextBurstFireTime = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
					else
						m_flNextBurstFireTime = 0;
				}

				//While firing a burst, don't allow reload or any other weapon actions. Might be best to let some things run though.
				return;
			}
		}

		BaseClass.ItemPostFrame();
	}

	void ItemPreFrame()
	{
		// TODO: Custom crosshair
		/*if( WeaponGLMode == INS2BASE::GL_NOTAIMED )
			self.LoadSprites( m_pPlayer, self.pev.classname );
		else if( WeaponGLMode == INS2BASE::GL_AIMED )
			self.LoadSprites( m_pPlayer, string(self.pev.classname) + "gl" );*/

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
				ReloadSecondary( MAX_CLIP2, GL_RELOAD, (116.0/32.0), GetBodygroup() );
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
			ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_3XBURST, INS2BASE::SELECTFIRE_SEMI, (23.0/30.0) );

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
				(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (136.0/35.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (115.0/35.0), GetBodygroup() );
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

class M16A4_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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

class M203_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2m16a4";
}

string GetGLName()
{
	return "ammo_ins2m16a4gl";
}

string GetName()
{
	return "weapon_ins2m16a4";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M16A4::weapon_ins2m16a4", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M16A4::M16A4_MAG", GetAmmoName() ); // Register the ammo entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M16A4::M203_MAG", GetGLName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_ARGR, GetAmmoName(), GetGLName() ); // Register the weapon
}

}//Namespace end