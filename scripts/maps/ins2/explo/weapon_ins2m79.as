// Insurgency's M79 Grenade Launcher
/* Model Credits
/ Model: Firearms Source Team, Norman The Loli Pirate
/ Textures: Firearms Source Team, Norman The Loli Pirate
/ Animations: MyZombieKillerz, D.N.I.O. 071 (Heavy Edits)
/ Sounds: Firearms Source Team, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (Compile)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"
#include "../arifl/weapon_ins2m16a4" // Grenade Ammo

namespace INS2_M79
{

// Animations
enum INS2_M79_Animations
{
	IDLE = 0,
	IDLE_BUCK,
	DRAW_FIRST,
	DRAW,
	DRAW_BUCK,
	HOLSTER,
	HOLSTER_BUCK,
	FIRE,
	FIRE_BUCK,
	DRYFIRE,
	DRYFIRE_BUCK,
	RELOAD1,
	RELOAD2,
	RELOAD3,
	RELOAD1_BUCK,
	RELOAD2_BUCK,
	RELOAD3_BUCK,
	SWITCH_BUCK,
	SWITCH_BUCK_EMPTY,
	SWITCH_NADE,
	SWITCH_NADE_EMPTY,
	IRON_IDLE,
	IRON_IDLE_BUCK,
	IRON_FIRE,
	IRON_FIRE_BUCK,
	IRON_DRYFIRE,
	IRON_DRYFIRE_BUCK,
	IRON_TO,
	IRON_TO_BUCK,
	IRON_FROM,
	IRON_FROM_BUCK
};

enum INS2_M79_AmmoType
{
	HIGH_EXPLOSIVE = 0,
	BUCK_SHOT
};

// Models
string W_MODEL = "models/ins2/wpn/m79/w_m79.mdl";
string V_MODEL = "models/ins2/wpn/m79/v_m79.mdl";
string P_MODEL = "models/ins2/wpn/m79/p_m79.mdl";
string G_MODEL = "models/ins2/wpn/m16a4/m203.mdl";
string A_MODEL = "models/ins2/wpn/m79/buck.mdl"; // Buckshot ammo for the M79
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/m79/shoot.ogg";
string SHOOT_A = "ins2/wpn/m79/shoot1.ogg"; // Alternative
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 1;
int MAX_CARRY2  	= 1000;
int MAX_CLIP2   	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 8;
int DEFAULT_GIVE2	= MAX_CLIP2 * 8;
int WEIGHT      	= 50;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 175;
uint DAMAGE_BS  	= 10;
uint SLOT       	= 4;
uint POSITION   	= 7;
string AMMO_TYPE 	= "ins2_40x46mm";
string AMMO_TYPE2 	= "ins2_40x46mmBS";
uint PELLETCOUNT 	= 27; //Yup
Vector VECTOR_CONE( 0.07846, 0.07846, 0.0 ); //9 DEGREES
string PROJ_NAME 	= "proj_ins2m79";

class weapon_ins2m79 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn;
	private int m_iAmmoMode;
	private bool m_bIsSwitching;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/uni/bretract.ogg",
		"ins2/wpn/m79/close.ogg",
		"ins2/wpn/m79/open.ogg",
		"ins2/wpn/m79/ins.ogg",
		"ins2/wpn/m79/rem.ogg",
		"ins2/wpn/m79/safe.ogg",
		"ins2/wpn/m203/drop.ogg",
		SHOOT_A,
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
		m_iAmmoMode = HIGH_EXPLOSIVE;
		self.m_iClip2 = 0;
		m_bIsSwitching = false;
		m_WasDrawn = false;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
		self.m_iDefaultSecAmmo = DEFAULT_GIVE2;
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( G_MODEL );
		g_Game.PrecacheModel( A_MODEL );

		g_Game.PrecacheOther( PROJ_NAME );
		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( GrenadeExplode );
		INS2BASE::PrecacheSound( GrenadeWaterExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		g_Game.PrecacheGeneric( "sprites/" + "ins2/gl_crosshair.spr" );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_ARGR;
		info.iAmmo1Drop	= MAX_CLIP;
		info.iMaxAmmo2 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY2 : INS2BASE::DF_MAX_CARRY_SPOR;
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
		return CommonPlayEmptySound();
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );

		//Workaround for a ammo bug
		if( m_iAmmoMode == BUCK_SHOT )
		{
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip );
			self.m_iClip = 0;
		}

		//Workaround for another ammo bug
		if( m_iAmmoMode == HIGH_EXPLOSIVE && self.m_iClip2 > 0 )
		{
			m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
			self.m_iClip2 = 0;

			self.m_iClip = 1;
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - self.m_iClip );
		}

		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (43.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (m_iAmmoMode == HIGH_EXPLOSIVE) ? DRAW : DRAW_BUCK, "m16", GetBodygroup(), (31.0/31.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( m_iAmmoMode == HIGH_EXPLOSIVE )
		{
			if( self.m_iClip <= 0 )
			{
				self.PlayEmptySound();
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
				self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
				return;
			}

			Vector ang_Aim = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
			Math.MakeVectors( ang_Aim );
			--self.m_iClip;
	
			Vector vecStart;
			if( WeaponADSMode != INS2BASE::IRON_IN )
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 12 + g_Engine.v_right * 4.85f + g_Engine.v_up * -3.5 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 12 + g_Engine.v_right * 4.85f + g_Engine.v_up * -3 + m_pPlayer.pev.view_ofs * 0.25;
			else
				vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 12 + g_Engine.v_up * 2 : 
					m_pPlayer.GetGunPosition() + g_Engine.v_forward * 12 + g_Engine.v_up * 2 + m_pPlayer.pev.view_ofs * 0.01;
	
			Vector vecVeloc = g_Engine.v_forward * 1600 + g_Engine.v_up * 32;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOT_S, Math.RandomFloat( 0.95, 1.0 ), 0.7, 0, 95 + Math.RandomLong( 0, 0x9 ) );
			INS2GLPROJECTILE::CIns2GL@ pGL = INS2GLPROJECTILE::ShootGrenade( m_pPlayer.pev, vecStart, vecVeloc, DAMAGE, G_MODEL, false, PROJ_NAME );
			pGL.pev.body = 1;
	
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.5;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0;
	
			PunchAngle( Vector( Math.RandomFloat( -5.5, -5 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.15 : 1.45, Math.RandomFloat( -0.5, 0.5 ) ) );
	
			//Manually set M203 Shoot animation on the player
			m_pPlayer.m_Activity = ACT_RELOAD;
			m_pPlayer.pev.frame = 0;
			m_pPlayer.pev.sequence = 148;
			m_pPlayer.ResetSequenceInfo();

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRE : FIRE, 0, GetBodygroup() );
		}
		else if( m_iAmmoMode == BUCK_SHOT )
		{
			if( self.m_iClip2 <= 0 )
			{
				self.PlayEmptySound();
				self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE_BUCK : DRYFIRE_BUCK, 0, GetBodygroup() );
				self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
				return;
			}

			ShootWeapon( SHOOT_A, PELLETCOUNT, VECTOR_CONE, (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 384 : 2560, DAMAGE_BS, true, DMG_LAUNCH );

			m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
			m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

			PunchAngle( Vector( Math.RandomFloat( -7, -6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.0 : 1.25, Math.RandomFloat( -0.5, 0.5 ) ) );

			--self.m_iClip2;
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.5;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0;

			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRE_BUCK : FIRE_BUCK, 0, GetBodygroup() );
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
				self.SendWeaponAnim( (m_iAmmoMode == HIGH_EXPLOSIVE) ? IRON_TO : IRON_TO_BUCK, 0, GetBodygroup() );
				EffectsFOVON( 45 );
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (m_iAmmoMode == HIGH_EXPLOSIVE) ? IRON_FROM : IRON_FROM_BUCK, 0, GetBodygroup() );
				EffectsFOVOFF();
				break;
			}
		}
	}

	void TertiaryAttack()
	{
		if( m_iAmmoMode == HIGH_EXPLOSIVE && m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) <= 0 )
			return;
		else if( m_iAmmoMode == BUCK_SHOT && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		m_bIsSwitching = true;

		self.Reload();
		self.m_flTimeWeaponIdle = self.m_flNextTertiaryAttack = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + 1;
	}

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		BaseClass.ItemPreFrame();
	}

	void Reload()
	{
		if( !m_bIsSwitching )
		{
			if( m_iAmmoMode == HIGH_EXPLOSIVE )
			{
				if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
					return;
			}
			else
			{
				if( self.m_iClip2 == MAX_CLIP2 || m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) <= 0 )
					return;
			}
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			self.SendWeaponAnim( (m_iAmmoMode == HIGH_EXPLOSIVE) ? IRON_FROM : IRON_FROM_BUCK, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			if( m_bIsSwitching )
			{
				switch( m_iAmmoMode )
				{
					case HIGH_EXPLOSIVE:
						self.SendWeaponAnim( (self.m_iClip > 0 || self.m_iClip2 > 0) ? SWITCH_BUCK : SWITCH_BUCK_EMPTY, 0, GetBodygroup() );
						m_iAmmoMode = BUCK_SHOT;
						m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip );
						self.m_iClip = 0;
						break;

					case BUCK_SHOT:
						self.SendWeaponAnim( (self.m_iClip > 0 || self.m_iClip2 > 0) ? SWITCH_NADE : SWITCH_NADE_EMPTY, 0, GetBodygroup() );
						m_iAmmoMode = HIGH_EXPLOSIVE;
						m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) + self.m_iClip2 );
						self.m_iClip2 = 0;
						break;
				}

				self.m_flTimeWeaponIdle = self.m_flNextTertiaryAttack = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (138.0/31.0);
				m_pPlayer.m_flNextAttack = (138.0/31.0);
				SetThink( ThinkFunction( this.SwitchThink ) );
				self.pev.nextthink = g_Engine.time + (136.0/31.0);

				m_bIsSwitching = false;
			}
			else
			{
				if( m_iAmmoMode == HIGH_EXPLOSIVE )
					Reload( MAX_CLIP, Math.RandomLong( RELOAD1, RELOAD3 ), (138.0/35.0), GetBodygroup() );
				else
					ReloadSecondary( MAX_CLIP2, Math.RandomLong( RELOAD1_BUCK, RELOAD3_BUCK ), (138.0/35.0), GetBodygroup() );
			}

			canReload = false;
		}

		BaseClass.Reload();
	}

	void SwitchThink()
	{
		SetThink( null ); 
		if( m_iAmmoMode == BUCK_SHOT )
		{
			self.m_iClip2 += 1; 
			m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iSecondaryAmmoType ) - 1 );
		}
		else
		{
			self.m_iClip += 1; 
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
		}
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (m_iAmmoMode == HIGH_EXPLOSIVE) ? IRON_IDLE : IRON_IDLE_BUCK, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (m_iAmmoMode == HIGH_EXPLOSIVE) ? IDLE : IDLE_BUCK, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class M79_GL : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_ARGR, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_ARGR );
	}
}

class M79_BUCK : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, A_MODEL );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( A_MODEL );
		CommonPrecache();
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP2, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY2 : INS2BASE::DF_MAX_CARRY_SPOR, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_SPOR );
	}
}

string GetAmmoName()
{
	return "ammo_ins2m79";
}

string GetGLName()
{
	return "ammo_ins2m79gl";
}

string GetName()
{
	return "weapon_ins2m79";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M79::weapon_ins2m79", GetName() ); // Register the weapon entity

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M79::M79_GL", GetAmmoName() ); // Register the ammo entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M79::M79_BUCK", GetGLName() ); // Register the buckshot ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_ARGR, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE2 : INS2BASE::DF_AMMO_SPOR, GetAmmoName(), GetGLName() ); // Register the weapon
}

}