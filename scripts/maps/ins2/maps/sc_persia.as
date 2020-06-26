// Replacement Script with Insurgency Weapons
// Put this in the map's .cfg file: map_script ins2/maps/sc_persia
// Author: KernCore, original replacement logic from Nero

/*MAP ENTITIES

weapon_eagle
weapon_handgrenade
weapon_shotgun
weapon_sniperrifle
weapon_uzi
weapon_uziakimbo
ammo_357
ammo_762
ammo_9mmAR
ammo_9mmbox
ammo_buckshot

MAP CFG

ammo_357 4
ammo_9mmclip 11
weapon_357
weapon_crowbar
weapon_medkit
weapon_mp5*/

//Obligatory Survival stuff
#include "../../point_checkpoint"
//Insurgency weapons
#include "../weapons"

namespace SC_PERSIA
{

array<array<string>> g_RevolverCandidates = {
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() },
	{ INS2_DEAGLE::GetName(), INS2_DEAGLE::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() },
	{ INS2_USP::GetName(), INS2_USP::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_M590::GetName(), INS2_M590::GetAmmoName() },
	{ INS2_M1014::GetName(), INS2_M1014::GetAmmoName() },
	{ INS2_COACH::GetName(), INS2_COACH::GetAmmoName() },
	{ INS2_ITHACA::GetName(), INS2_ITHACA::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_MP40::GetName(), INS2_MP40::GetAmmoName() },
	{ INS2_MP5K::GetName(), INS2_MP5K::GetAmmoName() },
	{ INS2_MP7::GetName(), INS2_MP7::GetAmmoName() },
	{ INS2_AK12::GetName(), INS2_AK12::GetAmmoName() },
	{ INS2_ASVAL::GetName(), INS2_ASVAL::GetAmmoName() },
	{ INS2_AK74::GetName(), INS2_AK74::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_UziCandidates = {
	{ INS2_SKS::GetName(), INS2_SKS::GetAmmoName() },
	{ INS2_M4A1::GetName(), INS2_M4A1::GetAmmoName() },
	{ INS2_AKS74U::GetName(), INS2_AKS74U::GetAmmoName() },
	{ INS2_AKM::GetName(), INS2_AKM::GetAmmoName() },
	{ INS2_GALIL::GetName(), INS2_GALIL::GetAmmoName() }
};
const int iUziChooser = Math.RandomLong( 0, g_UziCandidates.length() - 1 );

array<string> g_UziAkimboCandidates = {
	INS2_FNFAL::GetName(),
	INS2_G3A3::GetName(),
	INS2_M14EBR::GetName()
};
const int iUziAkimboChooser = Math.RandomLong( 0, g_UziAkimboCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName(),
	INS2_KUKRI::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName(),
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_MinigunCandidates = {
	INS2_MG42::GetName(),
	INS2_M249::GetName(),
	INS2_M60::GetName()
};
const int iMinigunChooser = Math.RandomLong( 0, g_MinigunCandidates.length() - 1 );

array<ItemMapping@> g_Ins2ItemMappings = {
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//mp5
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmAR", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_mp5clip", g_9mmARCandidates[iARChooser][1] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ), //The deagle doesn't have a ammo entity ¯\_(ツ)_/¯
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//uzi
	ItemMapping( "weapon_uzi", g_UziCandidates[iUziChooser][0] ),
		ItemMapping( "ammo_uziclip", g_UziCandidates[iUziChooser][1] ), ItemMapping( "ammo_9mmbox", g_UziCandidates[iUziChooser][1] ),
	//uziakimbo
	ItemMapping( "weapon_uziakimbo", g_UziAkimboCandidates[iUziAkimboChooser] ),
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
	//Obligatory Survival stuff
	RegisterPointCheckPointEntity();
	// Map support is enabled here by default.
	// So you don't have to add "mp_survival_supported 1" to the map config
	g_SurvivalMode.EnableMapSupport();

	//Ins2 weapons
	INS2_KABAR::Register();
	INS2_KNUCKLES::Register();
	INS2_KUKRI::Register();
	INS2_MK2GRENADE::Register();
	INS2_M24GRENADE::Register();
	INS2_MP40::Register();
	INS2_MP5K::Register();
	INS2_MP7::Register();
	INS2_M1928::Register();
	INS2_ASVAL::Register();
	INS2_AK74::Register();
	INS2_SKS::Register();
	INS2_M4A1::Register();
	INS2_AK12::Register();
	INS2_AKS74U::Register();
	INS2_AKM::Register();
	INS2_GALIL::Register();
	INS2_FNFAL::Register();
	INS2_G3A3::Register();
	INS2_M14EBR::Register();
	INS2_WEBLEY::Register();
	INS2_DEAGLE::Register();
	INS2_C96::Register();
	INS2_USP::Register();
	INS2_M590::Register();
	INS2_M1014::Register();
	INS2_COACH::Register();
	INS2_ITHACA::Register();
	INS2_G43::Register();
	INS2_MG42::Register();
	INS2_M249::Register();
	INS2_M60::Register();

	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @SC_PERSIA::g_Ins2ItemMappings );
	g_ClassicMode.ForceItemRemap( true );
	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @SC_PERSIA::PickupObjectMaterialize );
}

void ActivateSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	g_SurvivalMode.Activate();
}