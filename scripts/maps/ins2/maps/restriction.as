// Replacement Script with Insurgency Weapons (Made for Outerbeast's edits and fixes)
// Put this in each map .cfg that belongs to the Restriction series: map_script ins2/maps/restriction
// Author: KernCore, logic from Nero

// Survival script (v1.2) -R4to0
#include "../../point_checkpoint"

// Map script (1.2) -R4to0
#include "../../Restriction/controller"

// The Weapons
#include "../weapons"

/*
Map entities:

ammo_357
ammo_9mmAR
ammo_9mmclip
ammo_buckshot
ammo_556
ammo_ARgrenades
ammo_rpgclip
weapon_crowbar
weapon_9mmhandgun
weapon_357
weapon_eagle
weapon_9mmAR
weapon_shotgun
weapon_m16
weapon_rpg
weapon_handgrenade
weapon_m249
*/

namespace RESTRICTION
{

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_MAKAROV::GetName(), INS2_MAKAROV::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_SAIGA12::GetName(), INS2_SAIGA12::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_M16Candidates = {
	{ INS2_AKM::GetName(), INS2_AKM::GetAmmoName(), INS2_AKM::GetGLName() }
};
const int iM16Chooser = Math.RandomLong( 0, g_M16Candidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_RPG7::GetName(), INS2_RPG7::GetAmmoName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_M249Candidates = {
	{ INS2_RPK::GetName(), INS2_RPK::GetAmmoName() }
};
const int iM249Chooser = Math.RandomLong( 0, g_M249Candidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName(),
	INS2_KUKRI::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_AKS74U::GetName(), INS2_AKS74U::GetAmmoName() },
	{ INS2_AK74::GetName(), INS2_AK74::GetAmmoName() },
	{ INS2_PPSH41::GetName(), INS2_PPSH41::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_ASVAL::GetName(), INS2_ASVAL::GetAmmoName() },
	{ INS2_MOSIN::GetName(), INS2_MOSIN::GetAmmoName() },
	{ INS2_SVD::GetName(), INS2_SVD::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<array<string>> g_RevolverCandidates = {
	{ INS2_SKS::GetName(), INS2_SKS::GetAmmoName() },
	{ INS2_AK12::GetName(), INS2_AK12::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<ItemMapping@> g_Ins2ItemMappings = {
	//glock
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ), ItemMapping( "ammo_glockclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//m16
	ItemMapping( "weapon_m16", g_M16Candidates[iM16Chooser][0] ),
		ItemMapping( "ammo_556clip", g_M16Candidates[iM16Chooser][1] ), ItemMapping( "ammo_ARgrenades", g_M16Candidates[iM16Chooser][2] ), ItemMapping( "ammo_mp5grenades", g_M16Candidates[iM16Chooser][2] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//m249
	ItemMapping( "weapon_m249", g_M249Candidates[iM249Chooser][0] ), ItemMapping( "weapon_saw", g_M249Candidates[iM249Chooser][0] ),
		ItemMapping( "ammo_556", g_M249Candidates[iM249Chooser][1] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//mp5
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmAR", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_mp5clip", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ),
		ItemMapping( "ammo_sporeclip", g_DeagleCandidates[iDeagChooser][1] ), //The deagle needed a ammo entity, so I gave it one ¯\_(ツ)_/¯
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] )
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
	// Restriction 1.2 mapscript functions -R4to0
	RegisterPointCheckPointEntity();
	ControllerMapInit();

	// Weapons
	INS2_SKS::Register();
	INS2_AK12::Register();
	INS2_MAKAROV::Register();
	INS2_SAIGA12::POSITION = 19;
	INS2_SAIGA12::Register();
	INS2_AKM::Register();
	INS2_RPG7::Register();
	INS2_RPK::Register();
	INS2_MK2GRENADE::Register();
	INS2_KABAR::Register();
	INS2_KNUCKLES::Register();
	INS2_KUKRI::Register();
	INS2_AKS74U::Register();
	INS2_AK74::Register();
	INS2_PPSH41::Register();
	INS2_ASVAL::Register();
	INS2_MOSIN::Register();
	INS2_SVD::Register();

	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @RESTRICTION::g_Ins2ItemMappings );
	g_ClassicMode.ForceItemRemap( true );

	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @RESTRICTION::PickupObjectMaterialize );
}

void MapActivate()
{ 
	// Create a few entities that will get replaced by the Hook above. Solves the problem of the deagle replacement not having ammo
	if( string(g_Engine.mapname) == "restriction02" )
	{
		array<Vector> Restriction02_Coords = {
			Vector( -108, 794, -186 ),
			Vector( -10, 806, -186 ),
			Vector( -61, 822, -201 ),
			Vector( 10, 798, -186 )
		};
		for( uint i = 0; i < Restriction02_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_sporeclip", Restriction02_Coords[i], g_vecZero, false );
		}
	}
	else if( string(g_Engine.mapname) == "restriction04" )
	{
		array<Vector> Restriction04_Coords = {
			Vector( 1857, 227, 646 ),
			Vector( 2034, -265, 632 ),
			Vector( 1994, -288, 632 ),
			Vector( 1864, -853, 616 )
		};
		for( uint i = 0; i < Restriction04_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_sporeclip", Restriction04_Coords[i], g_vecZero, false );
		}
	}
	else if( string(g_Engine.mapname) == "restriction06" )
	{
		array<Vector> Restriction06_Coords = {
			Vector( 1653, -1540, -1345 ),
			Vector( 1495, -1543, -1345 ),
			Vector( 1475, -1536, -1345 ),
			Vector( 1221, -1514, -1360 )
		};
		for( uint i = 0; i < Restriction06_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_sporeclip", Restriction06_Coords[i], g_vecZero, false );
		}
	}
	else if( string(g_Engine.mapname) == "restriction08" )
	{
		array<Vector> Restriction08_Coords = {
			Vector( 1326, 188, 136 ),
			Vector( 1413, 188, 136 ),
			Vector( -3434, 1298, 108 ),
			Vector( -3434, 1255, 108 )
		};
		for( uint i = 0; i < Restriction08_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_sporeclip", Restriction08_Coords[i], g_vecZero, false );
		}
	}
	else if( string(g_Engine.mapname) == "restriction10" )
	{
		array<Vector> Restriction10_Coords = {
			Vector( 259, 895, 56 ),
			Vector( 258, 842, 56 ),
			Vector( 1208, 497, 597 ),
			Vector( 1342, 500, 582 )
		};
		for( uint i = 0; i < Restriction10_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_sporeclip", Restriction10_Coords[i], g_vecZero, false );
		}
	}
}