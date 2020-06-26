// Insurgency's Panzerfaust 60M
/* Model Credits
/ Model: Knoffhoff (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Textures: Knoffhoff (Forgotten Hope 2), Norman The Loli Pirate (Edits)
/ Animations: New World Interactive
/ Sounds: New World Interactive, D.N.I.O. 071 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: KernCore (UV Chop), D.N.I.O. 071 (World Model UVs, Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2gl"

namespace INS2_PZFAUST
{

// Animations
enum INS2_PZFAUST_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
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
	IRON_FIRE,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY
};

// Models
string W_MODEL = "models/ins2/wpn/faust/w_faust.mdl";
string V_MODEL = "models/ins2/wpn/faust/v_faust.mdl";
string P_MODEL = "models/ins2/wpn/faust/p_faust.mdl";
string R_MODEL = "models/ins2/wpn/faust/rocket.mdl"; //rocket model
string T_MODEL = "models/ins2/wpn/faust/toss.mdl"; //toss model
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/faust/shoot.ogg";
string EMPTY_S = "ins2/wpn/rckt_empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 1;
int DEFAULT_GIVE 	= MAX_CLIP * 2;
int WEIGHT      	= 50;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE | ITEM_FLAG_ESSENTIAL;
uint DAMAGE     	= 200;
float SPEED     	= 1700;
uint SLOT       	= 4;
uint POSITION   	= 9;
string AMMO_TYPE 	= GetName();
string PROJ_NAME 	= "proj_ins2pzfaust";

class weapon_ins2pzfaust : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
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
		"ins2/wpn/faust/pin.ogg",
		"ins2/wpn/faust/sight.ogg",
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
		g_Game.PrecacheModel( R_MODEL );
		m_iMagDrop = g_Game.PrecacheModel( T_MODEL );

		g_Game.PrecacheOther( PROJ_NAME );

		INS2BASE::PrecacheSound( RocketWaterExplode );
		INS2BASE::PrecacheSound( RocketExplode );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		g_Game.PrecacheGeneric( "sprites/" + "ins2/gl_crosshair.spr" );
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + "ammo_pzfaust.spr" );

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
		return CommonPlayEmptySound( EMPTY_S );
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
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "rpg", GetBodygroup(), (104.0/31.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip > 0) ? DRAW : DRAW_EMPTY, "rpg", GetBodygroup(), (29.0/30.0) );
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

		Vector ang_Aim = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;
		Math.MakeVectors( ang_Aim );

		Vector vecStart;
		if( WeaponADSMode != INS2BASE::IRON_IN )
			vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -3 : 
				m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_right * 5 + g_Engine.v_up * -2 + m_pPlayer.pev.view_ofs * 0.25;
		else
			vecStart = (m_pPlayer.pev.button & IN_DUCK == 0) ? m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 2 : 
				m_pPlayer.GetGunPosition() + g_Engine.v_forward * 16 + g_Engine.v_up * 1.15 + m_pPlayer.pev.view_ofs * 0.01;

		Vector vecVeloc = g_Engine.v_forward * SPEED + g_Engine.v_up * 8;

		INS2GLPROJECTILE::CIns2GL@ pGL = INS2GLPROJECTILE::ShootGrenade( m_pPlayer.pev, vecStart, vecVeloc, DAMAGE, R_MODEL, true, PROJ_NAME );
		pGL.pev.sequence = 0;
		pGL.pev.framerate = 0.065;
		PunchAngle( Vector( Math.RandomFloat( -3.0, -3.6 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -1.5 : 1.5, Math.RandomFloat( -0.5, 0.5 ) ) );

		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, SHOOT_S, Math.RandomFloat( 0.95, 1.0 ), 0.5, 0, 95 + Math.RandomLong( 0, 0x9 ) );
		--self.m_iClip;
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

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
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_TO : IRON_TO_EMPTY, 0, GetBodygroup() );
				EffectsFOVON( 35 );
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
			Reload( MAX_CLIP, RELOAD, (130.0/35.0), GetBodygroup() );
			SetThink( ThinkFunction( EjectClipThink ) );
			self.pev.nextthink = g_Engine.time + 0.571;
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
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_ins2pzfaust";
}

void Register()
{
	INS2GLPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_PZFAUST::weapon_ins2pzfaust", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, AMMO_TYPE, "", AMMO_TYPE ); // Register the weapon
}

}