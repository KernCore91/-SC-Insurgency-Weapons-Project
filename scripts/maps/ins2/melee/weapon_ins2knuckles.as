// Insurgency's Brass Knuckles
/* Model Credits
/ Model: Hav0k101
/ Textures: elcobra
/ Animations: New World Interactive
/ Sounds: New World Interactive, KernCore (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (Compile), Norman The Loli Pirate (World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_KNUCKLES
{

// Animations
enum INS2_KNUCKLES_Animations
{
	IDLE = 0,
	FIDGET,
	DRAW_FIRST,
	DRAW,
	DRAW_ALT,
	HOLSTER,
	SWING_1,
	SWING_2,
	SWING_3,
	CRACK
};

// Models
string W_MODEL = "models/ins2/wpn/knuk/w_knuk.mdl";
string V_MODEL = "models/ins2/wpn/knuk/v_knuk.mdl";
string P_MODEL = "models/ins2/wpn/knuk/p_knuk.mdl";
// Sprites
string SPR_CAT = "ins2/mel/"; //Weapon category used to get the sprite's location
// Information
int MAX_CARRY   	= -1;
int MAX_CLIP    	= WEAPON_NOCLIP;
int DEFAULT_GIVE 	= 0;
int WEIGHT      	= 20;
int FLAGS       	= 0;
uint DAMAGE     	= 12;
uint SLOT       	= 0;
uint POSITION   	= 5;
string AMMO_TYPE 	= "";

class weapon_ins2knuckles : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::MeleeWeaponBase
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
		"ins2/wpn/knuk/draw1.ogg",
		"ins2/wpn/knuk/draw2.ogg",
		"ins2/wpn/knuk/ready1.ogg",
		"ins2/wpn/knuk/ready2.ogg",
		"ins2/wpn/knuk/slide.ogg"
	};
	private array<string> flsh_Sounds = {
		"ins2/wpn/knuk/hitb1.ogg",
		"ins2/wpn/knuk/hitb2.ogg",
		"ins2/wpn/knuk/hitb3.ogg",
		"ins2/wpn/knuk/hitb4.ogg"
	};
	private array<string> wrld_Sounds = {
		"ins2/wpn/knuk/hit1.ogg",
		"ins2/wpn/knuk/hit2.ogg",
		"ins2/wpn/knuk/hit3.ogg",
		"ins2/wpn/knuk/hit4.ogg"
	};
	private array<string> swng_Sounds = {
		"ins2/wpn/knuk/swg1.ogg",
		"ins2/wpn/knuk/swg2.ogg",
		"ins2/wpn/knuk/swg3.ogg",
		"ins2/wpn/knuk/swg4.ogg"
	};

	void Spawn()
	{
		Precache();
		self.m_iClip = -1;
		self.m_flCustomDmg 	= self.pev.dmg;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );

		INS2BASE::PrecacheSound( INS2BASE::DeployRandomSounds );
		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( flsh_Sounds );
		INS2BASE::PrecacheSound( wrld_Sounds );
		INS2BASE::PrecacheSound( swng_Sounds );
		
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= MAX_CARRY;
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

	bool Deploy()
	{
		PlayDeploySound( 4 );
		if( m_WasDrawn == false )
		{
			m_WasDrawn = true;
			if( Math.RandomLong( 0, 1 ) < 0.5 )
				return Deploy( V_MODEL, P_MODEL, DRAW_FIRST, "crowbar", GetBodygroup(), (118.0/32.0) );
			else
				return Deploy( V_MODEL, P_MODEL, DRAW_ALT, "crowbar", GetBodygroup(), (49.0/32.0) );
		}
		else
		{
			return Deploy( V_MODEL, P_MODEL, DRAW, "crowbar", GetBodygroup(), (28.0/32.0) );
		}
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		self.SendWeaponAnim( Math.RandomLong( SWING_1, SWING_3 ), 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (38.0/35.0);
		SetThink( ThinkFunction( this.DoHeavyAttack ) );
		self.pev.nextthink = g_Engine.time + 0.14;
	}

	void SecondaryAttack()
	{
		if( self.m_flNextSecondaryAttack < g_Engine.time )
		{
			//g_Game.AlertMessage( at_console, "Executed\n" );
			self.SendWeaponAnim( CRACK, 0, GetBodygroup() );
			self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = g_Engine.time + (82.0/30.0);
		}
	}

	void DoHeavyAttack()
	{
		Smack( 38.0, (18.0/35.0), DAMAGE, (38.0/35.0), flsh_Sounds[Math.RandomLong( 0, flsh_Sounds.length() - 1)], wrld_Sounds[Math.RandomLong( 0, wrld_Sounds.length() - 1)], DMG_SLASH | DMG_CLUB );
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, swng_Sounds[Math.RandomLong( 0, swng_Sounds.length() - 1 )], 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0, 0xF ) );
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( Math.RandomLong( IDLE, FIDGET ), 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_ins2knuckles";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_KNUCKLES::weapon_ins2knuckles", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, AMMO_TYPE ); // Register the weapon
}

}