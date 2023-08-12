// Insurgency's H&K VP-70M
/* Model Credits
/ Model: fallschirmjager, the_tub
/ Textures: the_tub
/ Animations: D.N.I.O. 071
/ Sounds: Magmacow, Navaro, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render, Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs)
/ Script: KernCore
*/

#include "../base"

namespace INS2_VP70
{

// Animations
enum INS2_VP70_Animations
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
	IRON_FROM
};

// Models
string W_MODEL = "models/ins2/wpn/vp70/w_vp70.mdl";
string V_MODEL = "models/ins2/wpn/vp70/v_vp70.mdl";
string P_MODEL = "models/ins2/wpn/vp70/p_vp70.mdl";
string A_MODEL = "models/ins2/ammo/mags2.mdl";
int MAG_BDYGRP = 3;
// Sprites
string SPR_CAT = "ins2/hdg/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/vp70/shoot.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 18;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 17;
uint SLOT       	= 1;
uint POSITION   	= 11;
float RPM_AIR   	= 1400; //Rounds per minute in air
float RPM_WTR   	= 1150; //Rounds per minute in water
uint AIM_FOV    	= 49; // Below 50 hides crosshair
string AMMO_TYPE 	= "ins2_9x19mm";

class weapon_ins2vp70 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
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
		"ins2/wpn/vp70/magin.ogg",
		"ins2/wpn/vp70/magout.ogg",
		"ins2/wpn/vp70/sldbk.ogg",
		"ins2/wpn/vp70/sldrel.ogg",
		"ins2/wpn/vp70/rof.ogg",
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
		WeaponSelectFireMode = INS2BASE::SELECTFIRE_3XBURST;
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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_9x19 );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployPistolSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_9MM;
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
		return CommonPlayEmptySound();
	}

	bool Deploy()
	{
		PlayDeploySound( 2 );
		DisplayFiremodeSprite();
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "onehanded", GetBodygroup(), (70.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "onehanded", GetBodygroup(), (30.0/36.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_iBurstLeft = 0;
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	private void FirstAttackCommon()
	{
		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 2.0f, 0.7f, 1.5f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 8192, DAMAGE );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( WeaponADSMode != INS2BASE::IRON_IN )
		{
			if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
				KickBack( 0.95, 0.5, 0.25, 0.03, 3.5, 2.5, 5 );
			else if( m_pPlayer.pev.velocity.Length2D() > 0 )
				KickBack( 0.75, 0.35, 0.225, 0.03, 3.5, 2.5, 7 );
			else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
				KickBack( 0.55, 0.2, 0.15, 0.02, 2.25, 1.25, 10 );
			else
				KickBack( 0.6, 0.3, 0.2, 0.0225, 2.5, 1.5, 8 );
		}
		else
		{
			PunchAngle( Vector( Math.RandomFloat( -1.875, -2.475 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.75f : 0.6f, Math.RandomFloat( -0.5, 0.5 ) ) );
		}

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( Math.RandomLong( IRON_FIRE1, IRON_FIRE3 ), 0, GetBodygroup() );
		else
			self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE3 ), 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 22, 7, -7.5 ) : Vector( 22, 1.1, -2 ) );
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1f;

		if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_SEMI && m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 )
		{
			if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.2f;
			else
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.125f;

			return;
		}
		else if( WeaponSelectFireMode == INS2BASE::SELECTFIRE_3XBURST )
		{
			//Fire at most 3 bullets.
			m_iBurstCount = Math.min( 3, self.m_iClip );
			m_iBurstLeft = m_iBurstCount - 1;

			m_flNextBurstFireTime = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + GetFireRate( RPM_WTR ) : WeaponTimeBase() + GetFireRate( RPM_AIR );
			//Prevent primary attack before burst finishes. Might need to be finetuned.
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.425;
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;
		FirstAttackCommon();
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
		ChangeFireMode( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRESELECT : FIRESELECT, GetBodygroup(), INS2BASE::SELECTFIRE_SEMI, INS2BASE::SELECTFIRE_3XBURST, (40.0/35.0) );

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
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (140.0/31.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (92.0/31.0), GetBodygroup() );
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

class VP70_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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

string GetAmmoName()
{
	return "ammo_ins2vp70";
}

string GetName()
{
	return "weapon_ins2vp70";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_VP70::weapon_ins2vp70", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_VP70::VP70_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_9MM, "", GetAmmoName() ); // Register the weapon
}

}