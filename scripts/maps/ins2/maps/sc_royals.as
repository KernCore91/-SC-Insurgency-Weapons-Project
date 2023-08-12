// Replacement Script with Insurgency Weapons
// Put this in the map's .cfg file: map_script ins2/maps/sc_royals
// Author: KernCore, original replacement logic from Nero

//Insurgency weapons
#include "../weapons"

/*
ammo_357
ammo_556
ammo_9mmAR
ammo_9mmbox
ammo_ARgrenades
ammo_buckshot
ammo_crossbow
ammo_gaussclip
ammo_rpgclip
ammo_spore
weapon_crossbow *
weapon_crowbar *
weapon_eagle *
weapon_gauss
weapon_glock *
weapon_grapple 
weapon_handgrenade *
weapon_m16 *
weapon_m249 *
weapon_rpg *
weapon_satchel *
weapon_shotgun *
weapon_snark *
weapon_sporelauncher *
weapon_tripmine *
weapon_uziakimbo *
*/

namespace SC_ROYALS
{

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M1911::GetName(), INS2_M1911::GetAmmoName() },
	{ INS2_MAKAROV::GetName(), INS2_MAKAROV::GetAmmoName() },
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_M29::GetName(), INS2_M29::GetAmmoName() },
	{ INS2_PYTHON::GetName(), INS2_PYTHON::GetAmmoName() },
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<array<string>> g_UziAkimboCandidates = {
	{ INS2_MP40::GetName(), INS2_MP40::GetAmmoName() },
	{ INS2_MP18::GetName(), INS2_MP18::GetAmmoName() },
	{ INS2_STERLING::GetName(), INS2_STERLING::GetAmmoName() }
};
const int iUziAkimboChooser = Math.RandomLong( 0, g_UziAkimboCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_M590::GetName(), INS2_M590::GetAmmoName() },
	{ INS2_COACH::GetName(), INS2_COACH::GetAmmoName() },
	{ INS2_ITHACA::GetName(), INS2_ITHACA::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_M16Candidates = {
	{ INS2_AKM::GetName(), INS2_AKM::GetAmmoName(), INS2_AKM::GetGLName() },
	{ INS2_L85A2::GetName(), INS2_L85A2::GetAmmoName(), INS2_L85A2::GetGLName() }
};
const int iM16Chooser = Math.RandomLong( 0, g_M16Candidates.length() - 1 );

array<array<string>> g_CrossBowCandidates = {
	{ INS2_M1GARAND::GetName(), INS2_M1GARAND::GetAmmoName() },
	{ INS2_K98K::GetName(), INS2_K98K::GetAmmoName() },
	{ INS2_ENFIELD::GetName(), INS2_ENFIELD::GetAmmoName() }
};
const int iCrossChooser = Math.RandomLong( 0, g_CrossBowCandidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_RPG7::GetName(), INS2_RPG7::GetAmmoName() },
	{ INS2_PZSCHRECK::GetName(), INS2_PZSCHRECK::GetAmmoName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_GaussCandidates = {
	{ INS2_FNFAL::GetName(), INS2_FNFAL::GetAmmoName() },
	{ INS2_G3A3::GetName(), INS2_G3A3::GetAmmoName() },
	{ INS2_FG42::GetName(), INS2_FG42::GetAmmoName() }
};
const int iGaussChooser = Math.RandomLong( 0, g_GaussCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName(),
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_SatchelCandidates = {
	INS2_LAW::GetName()
};
const int iSatChooser = Math.RandomLong( 0, g_SatchelCandidates.length() - 1 );

array<string> g_SnarkCandidates = {
	INS2_AKS74U::GetName(),
	INS2_AK74::GetName(),
	INS2_M4A1::GetName(),
	INS2_GALIL::GetName(),
	INS2_STG44::GetName(),
};
const int iSnarkChooser = Math.RandomLong( 0, g_SnarkCandidates.length() - 1 );

array<array<string>> g_M249Candidates = {
	{ INS2_LEWIS::GetName(), INS2_LEWIS::GetAmmoName() },
	{ INS2_M60::GetName(), INS2_M60::GetAmmoName() },
	{ INS2_RPK::GetName(), INS2_RPK::GetAmmoName() }
};
const int iM249Chooser = Math.RandomLong( 0, g_M249Candidates.length() - 1 );

array<array<string>> g_SporeLauncherCandidates = {
	{ INS2_SKS::GetName(), INS2_SKS::GetAmmoName() },
	{ INS2_M1A1PARA::GetName(), INS2_M1A1PARA::GetAmmoName() },
	{ INS2_C96CARBINE::GetName(), INS2_C96CARBINE::GetAmmoName() }
};
const int iSporeChooser = Math.RandomLong( 0, g_SporeLauncherCandidates.length() - 1 );

array<array<string>> g_ShockRifleCandidates = {
	{ INS2_SVD::GetName(), INS2_SVD::GetAmmoName() },
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() },
	{ INS2_MOSIN::GetName(), INS2_MOSIN::GetAmmoName() }
};
const int iShockChooser = Math.RandomLong( 0, g_ShockRifleCandidates.length() - 1 );

array<string> g_MinigunCandidates = {
	INS2_MG42::GetName()
};
const int iMinigunChooser = Math.RandomLong( 0, g_MinigunCandidates.length() - 1 );

array<ItemMapping@> g_Ins2ItemMappings = {
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//glock
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmAR", g_9mmHandGunCandidates[i9mmChooser][1] ), ItemMapping( "ammo_9mmbox", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ), //The deagle doesn't have a ammo entity ¯\_(ツ)_/¯
		ItemMapping( "ammo_357", g_DeagleCandidates[iDeagChooser][1] ),
	//uziakimbo
	ItemMapping( "weapon_uziakimbo", g_UziAkimboCandidates[iUziAkimboChooser][0] ), ItemMapping( "weapon_uzi", g_UziAkimboCandidates[iUziAkimboChooser][0] ),
		ItemMapping( "ammo_uziclip", g_UziAkimboCandidates[iUziAkimboChooser][1] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//m16
	ItemMapping( "weapon_m16", g_M16Candidates[iM16Chooser][0] ),
		ItemMapping( "ammo_556clip", g_M16Candidates[iM16Chooser][1] ),
		ItemMapping( "ammo_ARgrenades", g_M16Candidates[iM16Chooser][2] ), ItemMapping( "ammo_mp5grenades", g_M16Candidates[iM16Chooser][2] ),
	//crossbow
	ItemMapping( "weapon_crossbow", g_CrossBowCandidates[iCrossChooser][0] ),
		ItemMapping( "ammo_crossbow", g_CrossBowCandidates[iCrossChooser][1] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//gauss
	ItemMapping( "weapon_gauss", g_GaussCandidates[iGaussChooser][0] ),
		ItemMapping( "ammo_gaussclip", g_GaussCandidates[iGaussChooser][1] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//satchel
	ItemMapping( "weapon_satchel", g_SatchelCandidates[iSatChooser] ),
	//tripmine
	ItemMapping( "weapon_tripmine", g_SatchelCandidates[iSatChooser] ),
	//snark
	ItemMapping( "weapon_snark", g_SnarkCandidates[iSnarkChooser] ),
	//m249
	ItemMapping( "weapon_m249", g_M249Candidates[iM249Chooser][0] ), ItemMapping( "weapon_saw", g_M249Candidates[iM249Chooser][0] ),
		ItemMapping( "ammo_556", g_M249Candidates[iM249Chooser][1] ),
	//sporelauncher
	ItemMapping( "weapon_sporelauncher", g_SporeLauncherCandidates[iSporeChooser][0] ),
		ItemMapping( "ammo_spore", g_SporeLauncherCandidates[iSporeChooser][1] ), ItemMapping( "ammo_sporeclip", g_SporeLauncherCandidates[iSporeChooser][1] ),
	//shockrifle
	ItemMapping( "weapon_shockrifle", g_ShockRifleCandidates[iShockChooser][0] ),
		ItemMapping( "monster_shockroach", g_ShockRifleCandidates[iShockChooser][1] ),
	//minigun
	ItemMapping( "weapon_minigun", g_MinigunCandidates[iMinigunChooser] )
};

//Using Materialize hook for that one guy that thought it would be a good idea to spawn entities using squadmaker
HookReturnCode PickupObjectMaterialize( CBaseEntity@ pEntity ) 
{
	Vector origin, angles;
	string targetname, target, netname;

	for( uint j = 0; j < g_Ins2ItemMappings.length(); ++j )
	{
		if( pEntity.pev.ClassNameIs( g_Ins2ItemMappings[j].get_From() ) )
		{
			origin = pEntity.pev.origin;
			angles = pEntity.pev.angles;
			targetname = pEntity.pev.targetname;
			target = pEntity.pev.target;
			netname = pEntity.pev.netname;

			g_EntityFuncs.Remove( pEntity );
			CBaseEntity@ pNewEnt = g_EntityFuncs.Create( g_Ins2ItemMappings[j].get_To(), origin, angles, true );

			if( targetname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "targetname", targetname );

			if( target != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "target", target );

			if( netname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "netname", netname );

			g_EntityFuncs.DispatchSpawn( pNewEnt.edict() );
		}
	}
	return HOOK_HANDLED;
}

}

void MapInit()
{
	INS2_KABAR::Register();
	INS2_KNUCKLES::Register();
	INS2_M1911::Register();
	INS2_MAKAROV::Register();
	INS2_C96::Register();
	INS2_M29::Register();
	INS2_PYTHON::Register();
	INS2_WEBLEY::Register();
	INS2_MP40::Register();
	INS2_MP18::Register();
	INS2_STERLING::Register();
	INS2_M590::Register();
	INS2_COACH::Register();
	INS2_ITHACA::Register();
	INS2_AKM::Register();
	INS2_L85A2::Register();
	INS2_M1GARAND::Register();
	INS2_K98K::Register();
	INS2_ENFIELD::Register();
	INS2_SVD::Register();
	INS2_G43::Register();
	INS2_MOSIN::Register();
	INS2_RPG7::Register();
	INS2_PZSCHRECK::Register();
	INS2_FNFAL::Register();
	INS2_G3A3::Register();
	INS2_FG42::Register();
	INS2_MK2GRENADE::Register();
	INS2_M24GRENADE::Register();
	INS2_LAW::DEFAULT_GIVE = INS2_LAW::MAX_CLIP;
	INS2_LAW::Register();
	INS2_AKS74U::Register();
	INS2_AK74::Register();
	INS2_M4A1::Register();
	INS2_GALIL::Register();
	INS2_STG44::Register();
	INS2_LEWIS::Register();
	INS2_M60::Register();
	INS2_RPK::Register();
	INS2_SKS::Register();
	INS2_M1A1PARA::Register();
	INS2_C96CARBINE::Register();

	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @SC_ROYALS::g_Ins2ItemMappings );
	g_ClassicMode.ForceItemRemap( true );
	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @SC_ROYALS::PickupObjectMaterialize );
}

void MapActivate()
{
	//KernCore: Create a few entities to help with ammo pickups

	array<Vector> Sc_Royals_Coords1 = {
		Vector( 680, -585, -140 ),
		Vector( 680, -560, -140 ),
		Vector( 680, -535, -140 )
	};

	array<Vector> Sc_Royals_Coords2 = {
		Vector( -240, -280, -140 ),
		Vector( -220, -280, -140 ),
		Vector( -200, -280, -140 )
	};

	array<Vector> Sc_Royals_Coords3 = {
		Vector( -270, -1040, -140 ),
		Vector( -270, -1020, -140 ),
		Vector( -270, -1000, -140 )
	};

	// this map has different origins for the spawn area
	if( string(g_Engine.mapname) == "sc_royals4" )
	{
		Sc_Royals_Coords1 = {
			Vector( 465, -1050, 724 ),    // 465, -1050, 724
            Vector( 465, -1025, 724 ),    // 465, -1025, 724
            Vector( 465, -1000, 724 )    // 465, -1000, 724
		};

		Sc_Royals_Coords2 = {
			Vector( -390, -744, 724 ),    // -390, -744, 724
            Vector( -410, -744, 724 ),    // -410, -744, 724
            Vector( -430, -744, 724 )    // -430, -744, 724
		};

		Sc_Royals_Coords3 = {
			Vector( -462, -1450, 724 ),    // -462, -1450, 724
            Vector( -462, -1470, 724 ),    // -462, -1470, 724
            Vector( -462, -1490, 724 )    // -462, -1490, 724
		};
	}
	
	for( uint i = 0; i < Sc_Royals_Coords1.length(); i++ )
	{
		g_EntityFuncs.Create( "ammo_9mmAR", Sc_Royals_Coords1[i], g_vecZero, false );
	}

	for( uint i = 0; i < Sc_Royals_Coords2.length(); i++ )
	{
		g_EntityFuncs.Create( "ammo_uziclip", Sc_Royals_Coords2[i], g_vecZero, false );
	}

	for( uint i = 0; i < Sc_Royals_Coords3.length(); i++ )
	{
		g_EntityFuncs.Create( "ammo_556clip", Sc_Royals_Coords3[i], g_vecZero, false );
	}

	//KernCore end
}

void MapStart()
{
	//KernCore: Removing that pesky ammo_spore entity
	CBaseEntity@ pEntity = null;
	Vector origin, angles;
	string targetname;

	for( int i = 0; ( @pEntity = @g_EntityFuncs.FindEntityByClassname( pEntity, "ammo_spore" ) ) != null; i++ )
	{
		origin = pEntity.pev.origin;
		targetname = pEntity.pev.targetname;
		angles = pEntity.pev.angles;

		g_EntityFuncs.Remove( pEntity );
		CBaseEntity@ pNewEnt1 = g_EntityFuncs.Create( SC_ROYALS::g_SporeLauncherCandidates[SC_ROYALS::iSporeChooser][1], origin, angles, true );
		if( targetname != "" )
			g_EntityFuncs.DispatchKeyValue( pNewEnt1.edict(), "targetname", targetname );

		g_EntityFuncs.DispatchSpawn( pNewEnt1.edict() );
	}
	//KernCore: End

	// Outerbeast
	CBaseEntity@ pChangeLevel;
	while( ( @pChangeLevel = g_EntityFuncs.FindEntityByClassname( pChangeLevel, "trigger_changelevel" ) ) !is null )
	{
		g_EntityFuncs.DispatchKeyValue( pChangeLevel.edict(), "keep_inventory", 1.0f );
	}
}