// Insurgency's M136 AT4
/* Model Credits
/ Model: New World Interactive, Norman The Loli Pirate (Edits, Rocket projectile)
/ Textures: New World Interactive, Norman The Loli Pirate (Edits, Rocket projectile)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (UV Chop), D.N.I.O. 071 (Compile, World Model UVs), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2rocket"

namespace INS2_AT4
{

// Animations
enum INS2_AT4_Animations
{
	IDLE = 0,
	DRAW_FIRST,
	DRAW,
	HOLSTER,
	FIRE,
	DRYFIRE,
	RELOAD,
	TOSS,
	IRON_IDLE,
	IRON_FIRE,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_FROM
};

// Models
string W_MODEL = "models/ins2/wpn/at4/w_at4.mdl";
string V_MODEL = "models/ins2/wpn/at4/v_at4.mdl";
string P_MODEL = "models/ins2/wpn/at4/p_at4.mdl";
string R_MODEL = "models/ins2/wpn/at4/rkt.mdl"; //rocket model
string T_MODEL = "models/ins2/wpn/at4/toss.mdl"; //toss model
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/at4/shoot.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 2;
int WEIGHT      	= 50;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE | ITEM_FLAG_ESSENTIAL;
uint DAMAGE     	= 230;
float SPEED     	= 2000;
uint SLOT       	= 4;
uint POSITION   	= 11;
string AMMO_TYPE 	= GetName();
string PROJ_NAME 	= "proj_ins2at4";

class weapon_ins2at4 : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_WasDrawn;
	private int m_iMagDrop;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"ins2/wpn/law/low.ogg",
		"ins2/wpn/at4/latch.ogg",
		"ins2/wpn/law/latch.ogg",
		"ins2/wpn/law/safe.ogg",
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
		g_Game.PrecacheModel( R_MODEL );
		m_iMagDrop = g_Game.PrecacheModel( T_MODEL );

		g_Game.PrecacheOther( PROJ_NAME );

		INS2BASE::PrecacheSound( RocketWaterExplode );
		INS2BASE::PrecacheSound( RocketExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_RKT2;
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

	// Better ammo extraction --- Anggara_nothing
	bool CanHaveDuplicates()
	{
		return true;
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "rpg", GetBodygroup(), (105.0/31.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, DRAW, "rpg", GetBodygroup(), (29.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 && self.m_iClip == 0 && !m_fDropped )
		{
			EjectClipThink();
			SetThink( ThinkFunction( DestroyThink ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}

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
			m_pPlayer.GetGunPosition() + g_Engine.v_forward * 18 + g_Engine.v_right * 3 + g_Engine.v_up * -0.85;

		Vector vecVeloc = g_Engine.v_forward * SPEED + g_Engine.v_up * 8;
		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		INS2ROCKETPROJECTILE::CIns2Rocket@ pRocket = INS2ROCKETPROJECTILE::ShootRocket( m_pPlayer.pev, vecStart, vecVeloc, R_MODEL, DAMAGE, PROJ_NAME );
		Math.MakeVectors( m_pPlayer.pev.v_angle );
		pRocket.pev.angles = ang_Aim;

		PunchAngle( Vector( Math.RandomFloat( -3.0, -3.6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.5 : 1.5, Math.RandomFloat( -0.5, 0.5 ) ) );
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.SendWeaponAnim( (WeaponADSMode == INS2BASE::IRON_IN) ? IRON_DRYFIRE : DRYFIRE, 0, GetBodygroup() );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.7f;
			return;
		}

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (30.0/30.0);
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		SetThink( ThinkFunction( ShootThink ) );
		self.pev.nextthink = g_Engine.time + 0.25;

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( IRON_FIRE, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( FIRE, 0, GetBodygroup() );
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
				EffectsFOVON( 35 );
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

	/*void InactiveItemPreFrame()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 && self.m_iClip == 0 )
		{
			
		}

		BaseClass.InactiveItemPreFrame();
	}*/

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
			self.SendWeaponAnim( IRON_FROM, 0, GetBodygroup() );
			m_reloadTimer = g_Engine.time + 0.16;
			m_pPlayer.m_flNextAttack = 0.16;
			canReload = true;
			EffectsFOVOFF();
		}

		if( m_reloadTimer < g_Engine.time )
		{
			Reload( MAX_CLIP, RELOAD, (146.0/30.0), GetBodygroup() );
			SetThink( ThinkFunction( EjectClipThink ) );
			self.pev.nextthink = g_Engine.time + (40.0/30.0);
			canReload = false;
		}

		BaseClass.Reload();
	}

	void EjectClipThink()
	{
		ClipCasting( m_pPlayer.pev.origin, m_pPlayer.pev.view_ofs + (g_Engine.v_right*42) + (g_Engine.v_up*16) + (g_Engine.v_forward*8), m_iMagDrop, false, 0 );
	}

	void WeaponIdle()
	{
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

string GetName()
{
	return "weapon_ins2at4";
}

void Register()
{
	INS2ROCKETPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_AT4::weapon_ins2at4", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, AMMO_TYPE, "", AMMO_TYPE ); // Register the weapon
}

}