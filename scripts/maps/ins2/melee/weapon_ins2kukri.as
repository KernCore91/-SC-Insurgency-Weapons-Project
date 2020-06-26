// Insurgency's Khukuri
/* Model Credits
/ Model: RouVix
/ Textures: Millenia
/ Animations: New World Interactive
/ Sounds: New World Interactive, KernCore (Conversion to .ogg format)
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: D.N.I.O. 071 (Compile, World Model)
/ Script: KernCore
*/

#include "../base"

namespace INS2_KUKRI
{

// Animations
enum INS2_KUKRI_Animations
{
	IDLE = 0,
	DRAW,
	HOLSTER,
	HIT_1,
	HIT_2,
	HIT_3
};

// Models
string W_MODEL = "models/ins2/wpn/kukri/w_kukri.mdl";
string V_MODEL = "models/ins2/wpn/kukri/v_kukri.mdl";
string P_MODEL = "models/ins2/wpn/kukri/p_kukri.mdl";
// Sprites
string SPR_CAT = "ins2/mel/"; //Weapon category used to get the sprite's location
// Information
int MAX_CARRY   	= -1;
int MAX_CLIP    	= WEAPON_NOCLIP;
int DEFAULT_GIVE 	= 0;
int WEIGHT      	= 20;
int FLAGS       	= 0;
uint DAMAGE      	= 50;
uint SLOT       	= 0;
uint POSITION   	= 9;
string AMMO_TYPE 	= "";

class weapon_ins2kukri : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::MeleeWeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int GetBodygroup()
	{
		return 0;
	}

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

		INS2BASE::PrecacheSound( INS2BASE::DeployBayonetSounds );
		INS2BASE::PrecacheSound( KnifeHitFlesh );
		INS2BASE::PrecacheSound( BayoHitWorld );
		INS2BASE::PrecacheSound( SwingMelee );
		
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
		PlayDeploySound( 0 );
		return Deploy( V_MODEL, P_MODEL, DRAW, "crowbar", GetBodygroup(), (19.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		self.SendWeaponAnim( Math.RandomLong( HIT_1, HIT_3 ), 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (26.0/30.0);
		SetThink( ThinkFunction( this.DoHeavyAttack ) );
		self.pev.nextthink = g_Engine.time + (4.5/30.0);
	}

	void DoHeavyAttack()
	{
		Smack( 46.03834, (16.0/30.0), DAMAGE, (26.0/30.0), KnifeHitFlesh[Math.RandomLong( 0, KnifeHitFlesh.length() - 1)], BayoHitWorld[Math.RandomLong( 0, BayoHitWorld.length() - 1)], DMG_SLASH | DMG_CLUB );
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, SwingMelee[Math.RandomLong( 0, SwingMelee.length() - 1 )], 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0, 0xF ) );
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

string GetName()
{
	return "weapon_ins2kukri";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_KUKRI::weapon_ins2kukri", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, AMMO_TYPE ); // Register the weapon
}

}