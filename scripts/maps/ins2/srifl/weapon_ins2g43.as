// Insurgency's Gewehr 43
/* Model Credits
/ Model: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Scope ViewModel)
/ Textures: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Wood, Scope ViewModel)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (UV Chop), D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_G43
{

// Animations
enum INS2_G43_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE1,
	FIRE2,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	SCOPE_TO,
	SCOPE_FROM
};

enum SCOPE_Animations
{
	SCP_IDLE_FOV20 = 0,
	SCP_FIRE_FOV20,
	SCP_FIRELAST_FOV20,
	SCP_DRYFIRE_FOV20
};

// Models
string W_MODEL = "models/ins2/wpn/g43/w_g43.mdl";
string V_MODEL = "models/ins2/wpn/g43/v_g43.mdl";
string P_MODEL = "models/ins2/wpn/g43/p_g43.mdl";
string S_MODEL = "models/ins2/wpn/scopes/mosin.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 39;
// Sprites
string SPR_CAT = "ins2/srf/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/g43/shoot.ogg";
string EMPTY_S = "ins2/wpn/g43/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 10;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 60;
uint SLOT       	= 7;
uint POSITION   	= 6;
float RPM_AIR   	= 0.22f; //Rounds per minute in air
float RPM_WTR   	= 0.4f; //Rounds per minute in water
string AMMO_TYPE 	= "ins2_7.92x57mm";

class weapon_ins2g43 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/g43/bltbk.ogg",
		"ins2/wpn/g43/bltrel.ogg",
		"ins2/wpn/g43/magin.ogg",
		"ins2/wpn/g43/magout.ogg",
		"ins2/wpn/g43/magrel.ogg",
		EMPTY_S,
		SHOOT_S
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
		g_Game.PrecacheModel( S_MODEL );
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_792x57 );

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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "sniper", GetBodygroup(), (56.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "sniper", GetBodygroup(), (38.0/34.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			if( WeaponADSMode == INS2BASE::IRON_IN )
				self.SendWeaponAnim( SCP_DRYFIRE_FOV20, 0, GetBodygroup() );
			else
				self.SendWeaponAnim( DRYFIRE, 0, GetBodygroup() );

			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.3f;
			return;
		}

		if( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + RPM_WTR : WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 1.3f, 0.3f, 1.3f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 16384, DAMAGE, true, DMG_SNIPER | DMG_NEVERGIB );

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -5.0, -4.0 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.0f : 1.0f, Math.RandomFloat( -0.5, 0.5 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( SCP_FIRELAST_FOV20, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( Math.RandomLong( FIRE1, FIRE2 ), 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 19, 4, -6 ) : Vector( 18.5, 1.6, -3.55 ) );
	}

	void SightThink()
	{
		ToggleZoom( 20 );
		WeaponADSMode = INS2BASE::IRON_IN;
		SetPlayerSpeed();
		m_pPlayer.m_szAnimExtension = "sniperscope";
		m_pPlayer.SetVModelPos( Vector( 0, 0, 0 ) );
		m_pPlayer.pev.viewmodel = S_MODEL;
		self.SendWeaponAnim( SCP_IDLE_FOV20, 0, GetBodygroup() );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.47;
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.47;
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, INS2BASE::AimDownSights_in[ Math.RandomLong( 0, INS2BASE::AimDownSights_in.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );

		switch( WeaponADSMode )
		{
			case INS2BASE::IRON_OUT:
			{
				self.SendWeaponAnim( SCOPE_TO, 0, GetBodygroup() );
				g_PlayerFuncs.ScreenFade( m_pPlayer, Vector( 0, 0, 0 ), 0.47, 0, 255, FFADE_OUT );
				SetThink( ThinkFunction( SightThink ) );
				self.pev.nextthink = WeaponTimeBase() + 0.46;
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( SCOPE_FROM, 0, GetBodygroup() );
				m_pPlayer.ResetVModelPos();
				m_pPlayer.pev.viewmodel = V_MODEL;
				m_pPlayer.m_szAnimExtension = "sniper";
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
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			m_pPlayer.m_szAnimExtension = "sniper";
			m_pPlayer.pev.viewmodel = V_MODEL;
			self.SendWeaponAnim( SCOPE_FROM, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.46;
			m_pPlayer.m_flNextAttack = 0.46;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			(self.m_iClip == 0) ? Reload( MAX_CLIP, RELOAD_EMPTY, (163.0/34.0), GetBodygroup() ) : Reload( MAX_CLIP, RELOAD, (114.0/34.0), GetBodygroup() );
			canReload = false;
		}

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( SCP_IDLE_FOV20, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class G43_MAG : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2g43";
}

string GetName()
{
	return "weapon_ins2g43";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_G43::weapon_ins2g43", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_G43::G43_MAG", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}