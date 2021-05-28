// Insurgency's M2A1-2 Flamethrower
/* Model Credits
/ Model: Norman The Loli Pirate, New World Interactive
/ Textures: Norman The Loli Pirate, New World Interactive
/ Animations: New World Interactive, D.N.I.O. 071
/ Sounds: New World Interactive, nettimato, D.I.C.E. (Battlefield 5), Tripwire Interactive (Killing Floor 1), Norman The Loli Pirate (Edits), D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: Half-Life Base Defence (Flames), New World Interactive (Fire Balls), D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model, World Model UVs), KernCore (World Model UVs), D.N.I.O. 071 (World Model UVs, Compile)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2flame"

namespace INS2_M2FLAMETHROWER
{

// Animations
enum INS2_M2FLAMETHROWER_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE_START,
	FIRE_LOOP,
	FIRE_END,
	DRYFIRE
};

// Models
string W_MODEL = "models/ins2/wpn/ftm2/w_m2.mdl";
string V_MODEL = "models/ins2/wpn/ftm2/v_m2.mdl";
string P_MODEL = "models/ins2/wpn/ftm2/p_m2.mdl";
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 20;
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Sounds
string FLAME_START	= "ins2/wpn/ftm2/start.ogg";
string FLAME_LOOP 	= "ins2/wpn/ftm2/loop.ogg";
string FLAME_END  	= "ins2/wpn/ftm2/end.ogg";
string FLAME_EMPTY	= "ins2/wpn/ftm2/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= WEAPON_NOCLIP;
int DEFAULT_GIVE 	= 200;
int AMMO_PICKUP 	= 50;
int WEIGHT      	= 50;
int FLAGS       	= ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 10;
uint SLOT       	= 8;
uint POSITION   	= 4;
float AMMO_DECAY 	= 0.09; //timer
string AMMO_TYPE 	= "ins2_napalm";

class weapon_ins2m2 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn;
	private float m_flNextSoundTime = 0, m_flAmmoDecayTime = 0;
	private int m_iLoopCount = 0;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/ftm2/cap1.ogg",
		"ins2/wpn/ftm2/cap2.ogg",
		"ins2/wpn/ftm2/cap3.ogg",
		"ins2/wpn/ftm2/capon.ogg",
		"ins2/wpn/ftm2/trgon.ogg",
		"ins2/wpn/ftm2/trgoff.ogg",
		FLAME_START,
		FLAME_LOOP,
		FLAME_END,
		FLAME_EMPTY
	};

	void Spawn()
	{
		Precache();
		m_WasDrawn = false;
		CommonSpawn( W_MODEL, (INS2BASE::ShouldUseCustomAmmo) ? DEFAULT_GIVE : 100 );
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
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + "ammo_m2ft.spr" );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_URAN;
		info.iAmmo1Drop	= AMMO_PICKUP;
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
		return CommonPlayEmptySound( FLAME_EMPTY );
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "egon", GetBodygroup(), (120.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "egon", GetBodygroup(), (26.0/35.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		if( m_iLoopCount != 0 )
			StopSounds();

		m_iLoopCount = 0;

		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void StopSounds()
	{
		g_SoundSystem.StopSound( m_pPlayer.edict(), CHAN_STATIC, FLAME_START );
		g_SoundSystem.StopSound( m_pPlayer.edict(), CHAN_STREAM, FLAME_LOOP );
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_AUTO, FLAME_END, 1.0, ATTN_NORM, 0, PITCH_NORM );
	}

	void FireFlames()
	{
		SetThink( null );

		if( m_iLoopCount == 1 )
		{
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_STATIC, FLAME_START, 1.0, ATTN_NORM, 0, PITCH_NORM );
		}

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		if( m_flAmmoDecayTime <= g_Engine.time )
		{
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
			m_flAmmoDecayTime = g_Engine.time + AMMO_DECAY;
		}

		Vector vecAng = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
		Math.MakeVectors( vecAng );

		Vector vecSrc = m_pPlayer.GetGunPosition() + g_Engine.v_forward * 18.5f + g_Engine.v_up * -4.5f + g_Engine.v_right * 2;
		Vector vecDir = Vector( m_pPlayer.pev.velocity.x * 0.35f, m_pPlayer.pev.velocity.y * 0.35f, 0 ) + g_Engine.v_forward * 500;
		INS2FLAMEPROJECTILE::CreateFlames( m_pPlayer.pev, vecSrc, vecDir, DAMAGE );
	}

	void PrimaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
		{
			self.PlayEmptySound();
			self.SendWeaponAnim( DRYFIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.6f;
			return;
		}

		if( m_iLoopCount == 0 )
		{
			self.SendWeaponAnim( FIRE_START, 0, GetBodygroup() );

			self.m_flNextPrimaryAttack = g_Engine.time + (1.0/32.0);
			self.m_flTimeWeaponIdle = g_Engine.time + (18.0/32.0);

			m_flNextSoundTime = g_Engine.time + (13.0/32.0) + 0.71f;

			SetThink( ThinkFunction( this.FireFlames ) );
			self.pev.nextthink = g_Engine.time + (13.0/32.0);

			m_iLoopCount++;
		}
		else if( m_iLoopCount == 1 && self.m_flTimeWeaponIdle < g_Engine.time )
		{
			m_iLoopCount++;

			self.SendWeaponAnim( FIRE_LOOP, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = g_Engine.time + 0.055f;
			self.m_flTimeWeaponIdle = g_Engine.time + (300.0/30.0);

			FireFlames();
		}
		else if( m_iLoopCount == 2 )
		{
			self.m_flNextPrimaryAttack = g_Engine.time + 0.055f;

			FireFlames();
		}

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1f;
	}

	void TertiaryAttack()
	{
		self.m_flNextTertiaryAttack = WeaponTimeBase() + 0.1f;
	}

	void FinishFire()
	{
		self.SendWeaponAnim( FIRE_END, 0, GetBodygroup() );

		self.m_flNextPrimaryAttack = g_Engine.time + (20.0/35.0);
		self.m_flTimeWeaponIdle = g_Engine.time + (37.0/35.0);

		m_iLoopCount = 0;
		m_flNextSoundTime = 0;
		StopSounds();
	}

	void ItemPreFrame()
	{
		if( m_pPlayer.pev.button & IN_ATTACK == 0 )
		{
			// Player finished firing before the loop sequence
			// Wait for the animation to end before properly ending loop sequence
			if( m_iLoopCount == 1 && self.m_flTimeWeaponIdle < g_Engine.time )
			{
				FinishFire();
			}
			else if( m_iLoopCount == 2 ) // Player finished firing after the loop sequence
			{
				FinishFire();
			}
		}
		else if( m_pPlayer.pev.button & IN_ATTACK != 0 && m_iLoopCount != 0 )
		{
			if( m_flNextSoundTime < g_Engine.time )
			{
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_STREAM, FLAME_LOOP, 1.0, ATTN_NORM, 0, PITCH_NORM );
				m_flNextSoundTime = g_Engine.time + 4.9f;
				m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
			}

			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
			{
				FinishFire();
			}
		}

		BaseClass.ItemPreFrame();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( IDLE, 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class NAPALM_CAN : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, AMMO_PICKUP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_URAN, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_URAN );
	}
}

string GetAmmoName()
{
	return "ammo_ins2m2";
}

string GetName()
{
	return "weapon_ins2m2";
}

void Register()
{
	INS2FLAMEPROJECTILE::Register();
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M2FLAMETHROWER::weapon_ins2m2", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M2FLAMETHROWER::NAPALM_CAN", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_URAN, "", GetAmmoName() ); // Register the weapon
}

}