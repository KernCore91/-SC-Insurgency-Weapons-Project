// Replacement Script with Insurgency Weapons
// Put this in the map's .cfg file: map_script ins2/maps/sc_egypt2
// Author: KernCore, original replacement logic from Nero

/*
ammo_357
ammo_556
ammo_762
ammo_9mmbox
ammo_buckshot
ammo_crossbow
ammo_gaussclip
ammo_rpgclip
ammo_uziclip
weapon_357
weapon_9mmhandgun
weapon_9mmAR
weapon_eagle
weapon_crossbow
weapon_egon
weapon_gauss
weapon_handgrenade
weapon_m249
weapon_rpg
weapon_shotgun
weapon_sniperrifle
weapon_uziakimbo
*/

//Insurgency weapons
#include "../weapons"

namespace SC_EGYPT2
{

array<array<string>> g_RevolverCandidates = {
	{ INS2_ENFIELD::GetName(), INS2_ENFIELD::GetAmmoName() },
	{ INS2_M1GARAND::GetName(), INS2_M1GARAND::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M9BERETTA::GetName(), INS2_M9BERETTA::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_MP18::GetName(), INS2_MP18::GetAmmoName() },
	{ INS2_MP40::GetName(), INS2_MP40::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_FNFAL::GetName(), INS2_FNFAL::GetAmmoName() },
	{ INS2_G3A3::GetName(), INS2_G3A3::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<array<string>> g_CrossbowCandidates = {
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() },
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() }
};
const int iCrossChooser = Math.RandomLong( 0, g_CrossbowCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName(),
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<array<string>> g_M249Candidates = {
	{ INS2_RPK::GetName(), INS2_RPK::GetAmmoName() },
	{ INS2_M60::GetName(), INS2_M60::GetAmmoName() }
};
const int iM249Chooser = Math.RandomLong( 0, g_M249Candidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_PZSCHRECK::GetName(), INS2_PZSCHRECK::GetAmmoName() },
	{ INS2_RPG7::GetName(), INS2_RPG7::GetAmmoName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_M590::GetName(), INS2_M590::GetAmmoName() },
	{ INS2_COACH::GetName(), INS2_COACH::GetAmmoName() },
	{ INS2_ITHACA::GetName(), INS2_ITHACA::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<array<string>> g_UziCandidates = {
	{ INS2_SKS::GetName(), INS2_SKS::GetAmmoName() },
	{ INS2_AKS74U::GetName(), INS2_AKS74U::GetAmmoName() },
	{ INS2_C96CARBINE::GetName(), INS2_C96CARBINE::GetAmmoName() }
};
const int iUziChooser = Math.RandomLong( 0, g_UziCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName(),
	INS2_KUKRI::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_EgonCandidates = {
	INS2_PZFAUST::GetName(),
	INS2_LAW::GetName()
};
const int iEgonChooser = Math.RandomLong( 0, g_EgonCandidates.length() - 1 );

array<array<string>> g_GaussCandidates = {
	{ INS2_AKM::GetName(), INS2_AKM::GetAmmoName() }
};
const int iGaussChooser = Math.RandomLong( 0, g_GaussCandidates.length() - 1 );

array<ItemMapping@> g_Ins2ItemMappings = {
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//egon
	ItemMapping( "weapon_egon", g_EgonCandidates[iEgonChooser] ),
	//glock
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ), ItemMapping( "ammo_glockclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//mp5
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmAR", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_mp5clip", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ),
	//crossbow
	ItemMapping( "weapon_crossbow", g_CrossbowCandidates[iCrossChooser][0] ),
		ItemMapping( "ammo_crossbow", g_CrossbowCandidates[iCrossChooser][1] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//m249
	ItemMapping( "weapon_m249", g_M249Candidates[iM249Chooser][0] ), ItemMapping( "weapon_saw", g_M249Candidates[iM249Chooser][0] ),
		ItemMapping( "ammo_556", g_M249Candidates[iM249Chooser][1] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] ),
	//gauss
	ItemMapping( "weapon_gauss", g_GaussCandidates[iGaussChooser][0] ),
		ItemMapping( "ammo_gaussclip", g_GaussCandidates[iGaussChooser][1] ),
	//uzi & uziakimbo
	ItemMapping( "weapon_uzi", g_UziCandidates[iUziChooser][0] ), ItemMapping( "weapon_uziakimbo", g_UziCandidates[iUziChooser][0] ),
		ItemMapping( "ammo_uziclip", g_UziCandidates[iUziChooser][1] )
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
	// Weapons
	INS2_ENFIELD::Register();
	INS2_M1GARAND::Register();
	INS2_M9BERETTA::Register();
	INS2_MP18::Register();
	INS2_MP40::Register();
	INS2_FNFAL::Register();
	INS2_G3A3::Register();
	INS2_WEBLEY::Register();
	INS2_C96::Register();
	INS2_MK2GRENADE::Register();
	INS2_M24GRENADE::Register();
	INS2_RPK::Register();
	INS2_M60::Register();
	INS2_PZSCHRECK::Register();
	INS2_RPG7::Register();
	INS2_M590::Register();
	INS2_COACH::Register();
	INS2_ITHACA::Register();
	INS2_G43::Register();
	INS2_SKS::Register();
	INS2_AKS74U::Register();
	INS2_C96CARBINE::Register();
	INS2_KABAR::Register();
	INS2_KNUCKLES::Register();
	INS2_KUKRI::Register();
	INS2_PZFAUST::Register();
	INS2_LAW::Register();
	INS2_AKM::Register();

	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @SC_EGYPT2::g_Ins2ItemMappings );
	g_ClassicMode.ForceItemRemap( true );

	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @SC_EGYPT2::PickupObjectMaterialize );
}