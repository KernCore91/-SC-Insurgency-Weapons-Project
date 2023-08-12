// Insurgency's RGO Grenade
/* Model Credits
/ Model: SAM61
/ Textures: Norman The Loli Pirate
/ Animations: New World Interactive, D.N.I.O. 071 (Heavy Edits)
/ Sounds: New World Interactive
/ Sprites: D.N.I.O. 071 (Model Render), R4to0 (Vector), KernCore (.spr Compile)
/ Misc: Norman The Loli Pirate (World Model), D.N.I.O. 071 (Compile)
/ Script: KernCore
*/

#include "../base"
#include "../proj/proj_ins2grenade"

namespace INS2_RGOGRENADE
{

// Animations
enum INS2_RGO_Animations
{
	IDLE = 0,
	DRAW,
	HOLSTER,
	HIGH_PINPULL,
	HIGH_THROW,
	HIGH_PINPULL_BAKE,
	HIGH_THROW_BAKE,
	LOW_PINPULL,
	LOW_THROW
};

// Models
string W_MODEL = "models/ins2/wpn/rgo/w_rgo.mdl";
string V_MODEL = "models/ins2/wpn/rgo/v_rgo.mdl";
string P_MODEL = "models/ins2/wpn/rgo/p_rgo.mdl";
// Sprites
string SPR_CAT = "ins2/exp/"; //Weapon category used to get the sprite's location
// Information
int MAX_CARRY   	= 1000;
int MAX_CLIP    	= WEAPON_NOCLIP;
int DEFAULT_GIVE 	= 1;
int WEIGHT      	= 20;
int FLAGS       	= ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;
uint DAMAGE     	= 150;
uint SLOT       	= 4;
uint POSITION   	= 6;
string AMMO_TYPE 	= GetName();
float TIMER     	= 3.8;
float IMPACT_TIMER 	= 1.5;
string PROJ_NAME 	= "proj_ins2rgo";

class weapon_ins2rgo : ScriptBasePlayerWeaponEntity, INS2BASE::WeaponBase, INS2BASE::ExplosiveBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int throwtype;
	private bool m_bInAttack, m_bThrown;
	private float m_fAttackStart = 0, m_fExplode = 0, m_flStartThrow = 0, m_flStartImpactTimer = 0;
	private int GetBodygroup()
	{
		return 0;
	}
	private int GetThrowAnimation()
	{
		if( throwtype == 0 )
			return HIGH_THROW_BAKE;
		else if( throwtype == 1 )
			return HIGH_THROW;
		else
			return LOW_THROW;
	}
	private array<string> Sounds = {
		"ins2/wpn/gren/pin.ogg",
		"ins2/wpn/gren/spoon2.ogg",
		"ins2/wpn/gren/throw.ogg"
	};

	void Spawn()
	{
		Precache();
		//self.KeyValue( "m_flCustomRespawnTime", 0.1 ); //fgsfds
		self.pev.dmg = DAMAGE;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );

		g_Game.PrecacheOther( PROJ_NAME );

		INS2BASE::PrecacheSound( Sounds );
		INS2BASE::PrecacheSound( INS2BASE::DeployGrenadeSounds );
		INS2BASE::PrecacheSound( GrenadeExplode );
		INS2BASE::PrecacheSound( GrenadeWaterExplode );

		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + "ammo_rgo.spr" );
		g_Game.PrecacheGeneric( "sprites/" + SPR_CAT + self.pev.classname + ".txt" );
		CommonPrecache();
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1	= (INS2BASE::ShouldUseCustomAmmo) ? MAX_CARRY : INS2BASE::DF_MAX_CARRY_RKT2;
		info.iAmmo1Drop	= DEFAULT_GIVE;
		info.iMaxAmmo2	= -1;
		info.iAmmo2Drop	= -1;
		info.iMaxClip	= MAX_CLIP;
		info.iSlot  	= SLOT;
		info.iPosition	= POSITION;
		info.iId     	= g_ItemRegistry.GetIdForName( self.pev.classname );
		info.iFlags 	= FLAGS;
		info.iWeight	= WEIGHT;

		return true;
	}

	void Materialize()
	{
		BaseClass.Materialize();
	}

	// Better ammo extraction --- Anggara_nothing
	bool CanHaveDuplicates()
	{
		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		//SetThink( null );
		return CommonAddToPlayer( pPlayer );
	}

	private int m_iAmmoSave;
	bool Deploy()
	{
		PlayDeploySound( 1 );
		m_iAmmoSave = 0; // Zero out the ammo save
		m_flStartImpactTimer = 0;

		return Deploy( V_MODEL, P_MODEL, DRAW, "gren", GetBodygroup(), (19.0/30.0) );
	}

	bool CanHolster()
	{
		if( m_fAttackStart != 0 )
			return false;

		return true;
	}

	bool CanDeploy()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType) == 0 )
			return false;

		return true;
	}

	private CBasePlayerItem@ DropItem()
	{
		m_iAmmoSave = m_pPlayer.AmmoInventory( self.m_iPrimaryAmmoType ); //Save the player's ammo pool in case it has any in DropItem

		if( m_fExplode > 0 ) //just in case
			m_fExplode = 0;

		return self;
	}

	void Holster( int skipLocal = 0 )
	{
		m_bThrown = false;
		m_bInAttack = false;
		m_fAttackStart = 0;
		m_flStartImpactTimer = 0;
		m_flStartThrow = 0;

		if( m_fExplode > 0 ) //player dies with the grenade cooked, ignores DropItem()
			m_fExplode = 0;

		CommonHolster();

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 ) //Save the player's ammo pool in case it has any in Holster
		{
			m_iAmmoSave = m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType );
		}

		if( m_iAmmoSave <= 0 )
		{
			SetThink( ThinkFunction( DestroyThink ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( m_fAttackStart > 0 )
			return;

		self.m_flNextPrimaryAttack = self.m_flNextTertiaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (50.0/33.0);
		throwtype = 0;
		self.SendWeaponAnim( HIGH_PINPULL_BAKE, 0, GetBodygroup() );

		m_bInAttack = true;
		m_fAttackStart = g_Engine.time + (50.0/33.0);
		m_flStartImpactTimer = g_Engine.time + (23.0/33.0);
		m_fExplode = g_Engine.time + TIMER;
		m_flStartThrow = g_Engine.time;

		self.m_flTimeWeaponIdle = g_Engine.time + (50.0/33.0) + (22.0/30.0);
	}

	void SecondaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( m_fAttackStart > 0 )
			return;

		self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (40.0/33.0);
		throwtype = 1;
		self.SendWeaponAnim( HIGH_PINPULL, 0, GetBodygroup() );

		m_bInAttack = true;
		m_fAttackStart = g_Engine.time + (40.0/33.0);
		m_fExplode = 0;

		self.m_flTimeWeaponIdle = g_Engine.time + (40.0/33.0) + (22.0/30.0);
	}

	void TertiaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		if( m_fAttackStart > 0 )
			return;

		self.m_flNextTertiaryAttack = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + (40.0/33.0);
		throwtype = 2;
		self.SendWeaponAnim( LOW_PINPULL, 0, GetBodygroup() );

		m_bInAttack = true;
		m_fAttackStart = g_Engine.time + (40.0/33.0);
		m_fExplode = 0;

		self.m_flTimeWeaponIdle = g_Engine.time + (40.0/33.0) + (25.0/30.0);
	}

	void LaunchThink()
	{
		Vector angThrow = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;

		if ( angThrow.x < 0 )
			angThrow.x = -10 + angThrow.x * ( (90 - 10) / 90.0 );
		else
			angThrow.x = -10 + angThrow.x * ( (90 + 10) / 90.0 );

		float flVel = (90.0f - angThrow.x) * 6;

		if ( flVel > 750.0f )
			flVel = 750.0f;

		Math.MakeVectors( angThrow );
		float time = 0, time2 = 0;

		time = m_flStartThrow - g_Engine.time + TIMER;
		time2 = m_flStartImpactTimer - g_Engine.time + IMPACT_TIMER; // This particular calculation is to account for the animation delay once the spoon leaves the grenade

		//g_Game.AlertMessage( at_console, "Impact Time: " + abs(time2) + "\n" );

		if( time < 0 )
			time = 0;

		if( time2 <= 0 )
		{
			//g_Game.AlertMessage( at_console, "Impact Time: " + abs(time2) + "\n" );
			time2 = 0;
		}

		Vector vecSrc = (throwtype != 2) ? m_pPlayer.pev.origin + m_pPlayer.pev.view_ofs + g_Engine.v_forward * 16 : m_pPlayer.pev.origin + (m_pPlayer.pev.view_ofs * 0.65) + g_Engine.v_forward * 16;
		Vector vecThrow = (throwtype != 2) ? g_Engine.v_forward * flVel + m_pPlayer.pev.velocity : (g_Engine.v_forward * flVel) * 0.70 + m_pPlayer.pev.velocity * 0.5;
		INS2GRENADEPROJECTILE::TossTimedImpactGrenade( m_pPlayer.pev, vecSrc, vecThrow, (throwtype == 0) ? time : TIMER, (throwtype == 0) ? time2 : IMPACT_TIMER, DAMAGE, W_MODEL, PROJ_NAME );

		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
		m_fAttackStart = 0;
		m_flStartImpactTimer = 0;
	}

	void ItemPreFrame()
	{
		if( m_fAttackStart == 0 && m_bThrown == true && m_bInAttack == false && self.m_flTimeWeaponIdle - 0.1 < g_Engine.time )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			{
				self.Holster();
			}
			else
			{
				self.Deploy();
				m_bThrown = false;
				m_bInAttack = false;
				m_fAttackStart = 0;
				m_flStartThrow = 0;
			}
		}

		if( m_fExplode > 0 && g_Engine.time > m_fExplode )
		{
			m_fExplode = 0;
			Explode();
		}

		//g_Game.AlertMessage( at_console, "Impact Time: " + abs(m_flStartImpactTimer - g_Engine.time + IMPACT_TIMER) + "\n" );

		if( !m_bInAttack || CheckButton() || g_Engine.time < m_fAttackStart )
			return;

		if( throwtype == 2 )
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (25.0/32.0);
		else
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + (22.0/32.0);

		

		self.SendWeaponAnim( GetThrowAnimation(), 0, GetBodygroup() );
		m_bThrown = true;
		m_bInAttack = false;
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		m_fExplode = 0;

		SetThink( ThinkFunction( this.LaunchThink ) );
		self.pev.nextthink = g_Engine.time + 0.19;

		BaseClass.ItemPreFrame();
	}

	void Explode()
	{
		//if( (m_pPlayer.pev.button & IN_ATTACK) == 0 )
		//	return;

		SelfExplode( m_pPlayer );
		SetThink( null );

		m_bThrown = false;
		m_bInAttack = false;
		m_fAttackStart = 0;
		m_flStartImpactTimer = 0;
		m_flStartThrow = 0;
		m_fExplode = 0;

		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			self.Holster();
		else
			self.Deploy();
	}

	void WeaponIdle()
	{
		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( IDLE, 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 10, 15 );
	}
}

string GetName()
{
	return "weapon_ins2rgo";
}

void Register()
{
	INS2GRENADEPROJECTILE::Register( PROJ_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "INS2_RGOGRENADE::weapon_ins2rgo", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), SPR_CAT, AMMO_TYPE, "", AMMO_TYPE ); // Register the weapon
}

}