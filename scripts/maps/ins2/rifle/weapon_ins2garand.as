// Insurgency's M1 Garand
/* Model Credits
/ Model: Short_Fuse (Garand), Millenia (Bayonet)
/ Textures: Millenia (Garand), Sproily (Bayonet), Norman The Loli Pirate (Edits)
/ Animations: New World Interactive
/ Sounds: New World Interactive, R4to0 (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Millenia (Bayonet UVs), D.N.I.O. 071 (World Model UVs, Compile), KernCore (World Model UVs), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_M1GARAND
{

// Animations
enum INS2_M1GARAND_Animations
{
	IDLE = 0,
	IDLE_EMPTY,
	DRAW_FIRST,
	DRAW,
	DRAW_EMPTY,
	HOLSTER,
	HOLSTER_EMPTY,
	FIRE1,
	FIRE2,
	FIRE_LAST,
	DRYFIRE,
	RELOAD,
	RELOAD_EMPTY,
	RELOAD_NULL,
	IRON_IDLE,
	IRON_IDLE_EMPTY,
	IRON_FIRE,
	IRON_FIRE_LAST,
	IRON_DRYFIRE,
	IRON_TO,
	IRON_TO_EMPTY,
	IRON_FROM,
	IRON_FROM_EMPTY,
	MELEE,
	MELEE_EMPTY
};

enum M1GARAND_Bodygroups
{
	ARMS = 0,
	M1GARAND_STUDIO0,
	M1GARAND_STUDIO1,
	M1GARAND_BAYONET_STUDIO,
	BULLETS_CLIP,
	BULLETS_GUN
};

// Models
string W_MODEL = "models/ins2/wpn/garand/w_garand.mdl";
string V_MODEL = "models/ins2/wpn/garand/v_garand.mdl";
string P_MODEL = "models/ins2/wpn/garand/p_garand.mdl";
string T_MODEL = "models/ins2/wpn/garand/clip.mdl"; //toss model
string A_MODEL = "models/ins2/ammo/mags.mdl";
int MAG_BDYGRP = 4;
// Sprites
string SPR_CAT = "ins2/rfl/"; //Weapon category used to get the sprite's location
// Sounds
string SHOOT_S = "ins2/wpn/garand/shoot.ogg";
string EMPTY_S = "ins2/wpn/garand/empty.ogg";
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= 8;
int DEFAULT_GIVE 	= MAX_CLIP * 4;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_NOAUTORELOAD | ITEM_FLAG_NOAUTOSWITCHEMPTY | ITEM_FLAG_SELECTONEMPTY;
uint DAMAGE     	= 55;
uint DAMAGE_MELEE 	= 20;
uint SLOT       	= 6;
uint POSITION   	= 5;
float RPM_AIR   	= 0.2f; //Rounds per minute in air
float RPM_WTR   	= 0.35f; //Rounds per minute in water
string AMMO_TYPE 	= "ins2_7.62x63mm";

class weapon_ins2garand : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::MeleeWeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell, m_iMagDrop;
	private bool m_WasDrawn;
	private int GetBodygroup()
	{
		if( self.m_iClip >= MAX_CLIP )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_GUN, 7 );
		else if( self.m_iClip <= 0 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_GUN, 0 );
		else
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_GUN, self.m_iClip - 1 );

		return m_iCurBodyConfig;
	}
	//Optimization: SetBodygroup only plays on Reload functions
	private int SetBodygroup()
	{
		//Clip Submodels
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= MAX_CLIP )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_CLIP, 7 );
		else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_CLIP, 0 );
		else
			m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_CLIP, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) >= MAX_CLIP || (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) >= MAX_CLIP )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_CLIP, 7 );
			else if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) < MAX_CLIP && (m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + self.m_iClip) < MAX_CLIP )
				m_iCurBodyConfig = g_ModelFuncs.SetBodygroup( g_ModelFuncs.ModelIndex( V_MODEL ), m_iCurBodyConfig, BULLETS_CLIP, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + (self.m_iClip - 1) );
		}

		//g_Game.AlertMessage( at_console, "Current Bodygroup Config: " + m_iCurBodyConfig + "\n" );

		return m_iCurBodyConfig;
	}
	private array<string> Sounds = {
		"ins2/wpn/garand/bltbk.ogg", //0
		"ins2/wpn/garand/bltrel.ogg", //1
		"ins2/wpn/garand/thumbe.ogg", //2
		"ins2/wpn/garand/thumbs.ogg", //3
		"ins2/wpn/garand/hit.ogg", //4
		"ins2/wpn/garand/magin.ogg", //5
		"ins2/wpn/garand/magout.ogg", //6
		"ins2/wpn/garand/magrel.ogg", //7
		"ins2/wpn/garand/ping1.ogg", //8
		"ins2/wpn/garand/ping2.ogg", //9
		"ins2/wpn/garand/ping3.ogg", //10
		"ins2/wpn/garand/ping4.ogg", //11
		"ins2/wpn/garand/ping5.ogg", //12
		SHOOT_S,
		EMPTY_S
	};
	private string PingSounds()
	{
		string Snd;
		switch( Math.RandomLong( 0, 4 ) )
		{
			case 0: Snd = Sounds[8];
				break;
			case 1: Snd = Sounds[9];
				break;
			case 2: Snd = Sounds[10];
				break;
			case 3: Snd = Sounds[11];
				break;
			case 4: Snd = Sounds[12];
				break;
		}
		return Snd;
	}

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
		m_iShell = g_Game.PrecacheModel( INS2BASE::BULLET_30_06 );
		m_iMagDrop = g_Game.PrecacheModel( T_MODEL );

		g_Game.PrecacheOther( GetAmmoName() );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployFirearmSounds );
		INS2BASE::PrecacheSound( BayoHitFlesh );
		INS2BASE::PrecacheSound( BayoHitWorld );
		
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

	bool CanDeploy()
	{
		return true;
	}

	bool Deploy()
	{
		PlayDeploySound( 3 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "sniper", GetBodygroup(), (60.0/35.0) );
		}
		else
			return Deploy( V_MODEL, P_MODEL, (self.m_iClip == 0) ? DRAW_EMPTY : DRAW, "sniper", GetBodygroup(), (35.0/35.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();
		m_pPlayer.m_szAnimExtension = "sniper";

		BaseClass.Holster( skipLocal );
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

		if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? WeaponTimeBase() + RPM_WTR : WeaponTimeBase() + RPM_AIR;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, VecModAcc( VECTOR_CONE_1DEGREES, 4.0f, 0.4f, 1.75f ), (m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD) ? 1024 : 16384, DAMAGE, true, DMG_SNIPER | DMG_NEVERGIB );

		if( self.m_iClip == 0 )
		{
			SetThink( ThinkFunction( EjectClipThink ) );
			self.pev.nextthink = g_Engine.time + 0.2;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_AUTO, PingSounds(), 1.0, ATTN_NORM, 0, PITCH_NORM );
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		PunchAngle( Vector( Math.RandomFloat( -3.6, -3.225 ), (Math.RandomLong( 0, 1 ) < 0.5) ? -0.5f : 0.8f, Math.RandomLong( -1, 1 ) ) );

		if( WeaponADSMode == INS2BASE::IRON_IN )
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FIRE : IRON_FIRE_LAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? Math.RandomLong( FIRE1, FIRE2 ) : FIRE_LAST, 0, GetBodygroup() );

		ShellEject( m_pPlayer, m_iShell, (WeaponADSMode != INS2BASE::IRON_IN) ? Vector( 23, 4.75, -5.15 ) : Vector( 23, 0.5, -1.25 ) );
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
				EffectsFOVON( 37 );
				m_pPlayer.m_szAnimExtension = "sniperscope";
				break;
			}
			case INS2BASE::IRON_IN:
			{
				self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_FROM : IRON_FROM_EMPTY, 0, GetBodygroup() );
				EffectsFOVOFF();
				m_pPlayer.m_szAnimExtension = "sniper";
				break;
			}
		}
	}

	void EjectClipThink()
	{
		ClipCasting( m_pPlayer.pev.origin, m_pPlayer.pev.view_ofs + (g_Engine.v_right*42) + (g_Engine.v_up*16) + (g_Engine.v_forward*8), m_iMagDrop, false, 0 );
	}

	void ItemPreFrame()
	{
		if( m_reloadTimer < g_Engine.time && canReload )
			self.Reload();

		BaseClass.ItemPreFrame();
	}

	void TertiaryAttack()
	{
		if( !Swing( 1, 46.25, (self.m_iClip == 0) ? MELEE_EMPTY : MELEE, GetBodygroup(), 0.63f, DAMAGE_MELEE ) )
		{
			SetThink( ThinkFunction( this.SwingAgain ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}
	}

	void SwingAgain()
	{
		Swing( 0, 46.25, (self.m_iClip == 0) ? MELEE_EMPTY : MELEE, GetBodygroup(), 0.63f, DAMAGE_MELEE );
	}

	void Secret()
	{
		g_WeaponFuncs.ClearMultiDamage();
		m_pPlayer.TraceAttack( m_pPlayer.pev, 1.0f, m_pPlayer.pev.origin, g_Utility.GetGlobalTrace(), DMG_CLUB );
		g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );
	}

	//private int m_iSwing = 0;

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		m_pPlayer.m_szAnimExtension = "sniper";
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
			if( self.m_iClip > 0 )
				Reload( MAX_CLIP, RELOAD, (164.0/35.0), SetBodygroup() );
			else
			{
				/*switch( ( m_iSwing++ ) % 2 )
				{
					case 0:
						Reload( MAX_CLIP, RELOAD_EMPTY, (116.0/35.0), SetBodygroup() );
						break;
					case 1:
						Reload( MAX_CLIP, RELOAD_NULL, (191.0/35.0), SetBodygroup() );
						SetThink( ThinkFunction( this.Secret ) );
						self.pev.nextthink = g_Engine.time + 2.28;
						break;
				}*/
				if( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 1, 100 ) <= 6 )
				{
					Reload( MAX_CLIP, RELOAD_NULL, (191.0/35.0), SetBodygroup() );
					SetThink( ThinkFunction( this.Secret ) );
					self.pev.nextthink = g_Engine.time + 2.28;
				}
				else
					Reload( MAX_CLIP, RELOAD_EMPTY, (116.0/35.0), SetBodygroup() );
			}
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
			self.SendWeaponAnim( (self.m_iClip > 0) ? IRON_IDLE : IRON_IDLE_EMPTY, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (self.m_iClip > 0) ? IDLE : IDLE_EMPTY, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class GARAND_CLIP : ScriptBasePlayerAmmoEntity, INS2BASE::AmmoBase
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
	return "ammo_ins2garand";
}

string GetName()
{
	return "weapon_ins2garand";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M1GARAND::weapon_ins2garand", GetName() ); // Register the weapon entity
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_M1GARAND::GARAND_CLIP", GetAmmoName() ); // Register the ammo entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, (INS2BASE::ShouldUseCustomAmmo) ? AMMO_TYPE : INS2BASE::DF_AMMO_357, "", GetAmmoName() ); // Register the weapon
}

}