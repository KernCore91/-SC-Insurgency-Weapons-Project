// Insurgency's AN-94N
/* Model Credits
/ Model: Contract Wars, Norman The Loli Pirate (Heavy Edits, PK-AS Side Rail Mount)
/ Textures: Contract Wars, Norman The Loli Pirate (Edits, PK-AS Side Rail Mount edits)
/ Animations: D.N.I.O. 071
/ Sounds: New World Interactive, Infinity Ward (COD Modern Warfare 2019, ported by Viper)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"

namespace INS2_AN94
{

// Animations
enum INS2_AN94_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE_BURST_START1,
	FIRE_BURST_START2,
	FIRE_BURST_START3,
	FIRE_BURST_END1,
	FIRE_BURST_END2,
	FIRE_BURST_END3,
	FIRE1,
	FIRE2,
	FIRE3,
	DRYFIRE,
	FIRESELECT,
	RELOAD,
	RELOAD_EMPTY,
	IRON_IDLE,
	IRON_FIRE_BURST_START1,
	IRON_FIRE_BURST_START2,
	IRON_FIRE_BURST_START3,
	IRON_FIRE_BURST_END1,
	IRON_FIRE_BURST_END2,
	IRON_FIRE_BURST_END3,
	IRON_FIRE1,
	IRON_FIRE2,
	IRON_FIRE3,
	IRON_DRYFIRE,
	IRON_FIRESELECT,
	IRON_TO,
	IRON_FROM
};

// Models
string W_MODEL = "models/ins2/wpn/an94/w_an94.mdl";
string V_MODEL = "models/ins2/wpn/an94/v_an94.mdl";
string P_MODEL = "models/ins2/wpn/an94/p_an94.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 2;
// Sprites
string SPR_CAT = "ins2/arf/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/an94/shoot.ogg";
string EMPTY_S = "ins2/wpn/ak74/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 30;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 25;
uint SLOT       	= 5;
uint POSITION   	= 10;
float RPM_AIR   	= 600; //Rounds per minute in air
float RPM_WTR   	= 500; //Rounds per minute in water
float RPM_BURST_AIR	= 1600; //Burst fire rate in air
float RPM_BURST_WTR	= 1000; //Burst fire rate in water
uint AIM_FOV    	= 34; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_5.45x39mm";

class weapon_ins2an94 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iBurstCount = 0, m_iBurstLeft = 0;
	private float m_flNextBurstFireTime = 0;
	private int m_iShell;
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/an94/bltbk.ogg",
		"ins2/wpn/an94/bltrel.ogg",
		"ins2/wpn/an94/magin.ogg",
		"ins2/wpn/an94/magout.ogg",
		"ins2/wpn/an94/magrtl.ogg",
		"ins2/wpn/an94/rof.ogg",
		"ins2/wpn/ak74/magrel.ogg",
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_545x39 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		g_Game.PrecacheGeneric( "events/" + "muzzle_SAW.txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_556;
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "m16", GetBodygroup(), (60.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "m16", GetBodygroup(), (25.0/32.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_iBurstLeft = 0;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	private void FirstAttackCommon()
	{
		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 4.0f, 0.8f, 1.0f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE, true );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( m_iBurstLeft <= 1 && m_flNextBurstFireTime < WeaponTimeBase() )
			{
				if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
					KickBack( 1.30, 0.30, 0.35, 0.03, 4.75, 2.75, 5 );
				else if( m_pPlayer.pev.velocity.Length2D() > 0 )
					KickBack( 1.00, 0.30, 0.3, 0.03, 4.75, 2.6, 7 );
				else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
					KickBack( 0.50, 0.20, 0.15, 0.02, 3.5, 1.25, 10 );
				else
					KickBack( 0.70, 0.225, 0.175, 0.0225, 3.6, 1.65, 8 );
			}
		}
		else
		{
			if( m_iBurstLeft <= 1 && m_flNextBurstFireTime < WeaponTimeBase() )
			{
				PunchAngle( Vector( Math.RandomFloat( -2.325, -1.875 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.75f : 0.55f, Math.RandomFloat( -0.5, 0.5 ) ) );
			}
		}

		if( m_iBurstLeft == 1 && m_flNextBurstFireTime < WeaponTimeBase() )
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( Math.RandomLong( IRON_FIRE_BURST_END1, IRON_FIRE_BURST_END3 ), 0, GetBodygroup() );
			else
				self.SendWeaponAnim( Math.RandomLong( FIRE_BURST_END1, FIRE_BURST_END3 ), 0, GetBodygroup() );
		}
		else
		{
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ), 0, GetBodygroup() );
			else
				self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE3 ), 0, GetBodygroup() );
		}

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 20, 5.5, -8.5 ) : Vector( 20, 1.6, -4.5 ) );
	}

	void BurstCount()
	{
		//Fire at most 2 bullets.
		m_iBurstCount = Math.min( 2, self.m_iClip );
		m_iBurstLeft = m_iBurstCount - 1;
		m_flNextBurstFireTime = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_BURST_WTR ) : WeaponTimeBase() + GetFireRate( RPM_BURST_AIR );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( Math.RandomLong( IRON_FIRE_BURST_START1, IRON_FIRE_BURST_START3 ), 0, GetBodygroup() );
		else
			self.SendWeaponAnim( Math.RandomLong( FIRE_BURST_START1, FIRE_BURST_START3 ), 0, GetBodygroup() );
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

		if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_AUTO )
		{
			if( (m_pPlayer.m_afButtonPressed & IN_ATTACK == 1) && self.m_iClip != 1 )
			{
				BurstCount();

				//Prevent primary attack before burst finishes. Might need to be finetuned.
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( RPM_AIR ) + (1.5 * GetFireRate( RPM_BURST_AIR ));
			}
			else
			{
				if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( RPM_WTR );
				else
					self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( RPM_AIR );
			}
		}
		else if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_2XBURST )
		{
			if( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 )
				return;

			BurstCount();

			//Prevent primary attack before burst finishes. Might need to be finetuned.
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.175f;
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;
		FirstAttackCommon();
	}

	void ItemPostFrame()
	{
		if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_2XBURST || (WeaponSelectFireMode == INS2BASE::SELECTFIRE_AUTO && m_pPlayer.m_afButtonPressed & IN_ATTACK == 0) /*!SpecialFireRate*/ )
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

					FirstAttackCommon();
					--m_iBurstLeft;


					if( m_iBurstLeft > 0 )
						m_flNextBurstFireTime = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_BURST_WTR ) : WeaponTimeBase() + GetFireRate( RPM_BURST_AIR );
					else
						m_flNextBurstFireTime = 0;
				}

				//While firing a burst, don't allow reload or any other weapon actions. Might be best to let some things run though.
				return;
			}
		}

		BaseClass.ItemPostFrame();
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
		ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_AUTO, INS2BASE::SELECTFIRE_2XBURST, (30.0/32.0) );

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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (170.0/37.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (135.0/37.0), GetBodygroup() );
			canReload = false;
		}

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		if( self.m_flNextPrimaryAttack + 0.1 < g_Engine.time )
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

class AN94_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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

string GetAmmoName()
{
	return "ammo_ins2an94";
}

string GetName()
{
	return "weapon_ins2an94";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_AN94::weapon_ins2an94", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_AN94::AN94_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_556, "", GetAmmoName() ); // Register the weapon
}

}