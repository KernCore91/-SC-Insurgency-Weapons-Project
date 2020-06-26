// Insurgency's Raketenpanzerbüchse 54
/* Model Credits
/ Model: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Textures: Seth Soldier (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2rocket"

namespace INS2_PZSCHRECK
{

// Animations
enum INS2_PZSCHRECK_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
	FIDGET,
	FIDGET_EMPTY,
	DRAW_FIRST,
	DRAW,
	DRAW_EMPTY,
	HOLSTER,
	HOLSTER_EMPTY,
	FIRE,
	DRYFIRE,
	RELOAD,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIDGET,
	IRON_FIDGET_EMPTY,
	IRON_FIRE,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY
};

// Models
string W_MODEL = "models/ins2/wpn/schrck/w_schrck.mdl";
string V_MODEL = "models/ins2/wpn/schrck/v_schrck.mdl";
string P_MODEL = "models/ins2/wpn/schrck/p_schrck.mdl";
string A_MODEL = "models/ins2/wpn/schrck/rkt.mdl";
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/schrck/shoot.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 50;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 285;
float SPEED     	= 1550;
uint SLOT       	= 4;
uint POSITION   	= 15;
string AMMO_TYPE 	= "ins2_88mm_rocket";
string PROJ_NAME 	= "proj_ins2pzschreck";

class weapon_ins2pzschreck : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/schrck/load1.ogg",
		"ins2/wpn/schrck/load2.ogg",
		"ins2/wpn/schrck/wire.ogg",
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

		g_Game.PrecacheOther( PROJ_NAME );
		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( ChargeExplode );
		INS2BASE::PrecacheSound( ChargeWaterExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_RKT;
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
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "rpg", GetBodygroup(), (103.0/30.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "rpg", GetBodygroup(), (42.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void ShootThink()
	{
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOT_S, Math.RandomFloat( 0.95, 1.0 ), 0.5, 0, 95 + Math.RandomLong( 0, 0x9 ) );
		--self.m_iClip;

		Vector ang_Aim = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
		Math.MakeVectors( ang_Aim );
		ang_Aim.x = -(ang_Aim.x);

		Vector vecStart = (WeaponADSMode == INS2BASE::IRON_IN) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 18 + g_Engine.v_up * 1.1 :
			m_pPlayer.GetGunPosition() + g_Engine.v_forward * 18 + g_Engine.v_right * 2 + g_Engine.v_up * -1;

		Vector vecVeloc = g_Engine.v_forward * SPEED + g_Engine.v_up * 8;
		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		INS2ROCKETPROJECTILE::CIns2Rocket@ pRocket = INS2ROCKETPROJECTILE::ShootRocket( m_pPlayer.pev, vecStart, vecVeloc, A_MODEL, DAMAGE, PROJ_NAME );
		Math.MakeVectors( m_pPlayer.pev.v_angle );
		pRocket.pev.angles = ang_Aim;

		PunchAngle( Vector( Math.RandomFloat( -2.55, -3.6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.15 : 1.45, Math.RandomFloat( -0.5, 0.5 ) ) );
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (33.0/30.0);
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		SetThink( ThinkFunction( ShootThink ) );
		self.pev.nextthink = g_Engine.time + 0.4;

		self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_FIRE : FIRE, 0, GetBodygroup() );
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
				EffectsFOVON( 45 );
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
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			Reload( MAX_CLIP, RELOAD, (209.0/33.0), GetBodygroup() );
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

		int iAnim = Math.RandomLong( 0, 1 );

		if( WeaponADSMode == INS2BASE::IRON_IN )
		{
			switch( iAnim )
			{
				case 0: self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() ); break;
				case 1: self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FIDGET : IRON_FIDGET_EMPTY, 0, GetBodygroup() ); break;
			}
		}
		else
		{
			switch( iAnim )
			{
				case 0: self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() ); break;
				case 1: self.SendWeaponAnim( (self.m_iClip > 0) ? FIDGET : FIDGET_EMPTY, 0, GetBodygroup() ); break;
			}
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class PZSCHRECK_ROCKET : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
		return CommonAddAmmo( pOther, MAX_CLIP, (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_RKT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_RKT );
	}
}

string GetAmmoName()
{
	return "ammo_ins2pzschreck";
}

string GetName()
{
	return "weapon_ins2pzschreck";
}

void Register()
{
	INS2ROCKETPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PZSCHRECK::weapon_ins2pzschreck", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PZSCHRECK::PZSCHRECK_ROCKET", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_RKT, "", GetAmmoName() ); // Register the weapon
}

}