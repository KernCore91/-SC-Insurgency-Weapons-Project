// Replacement Script with Insurgency Weapons
// Put this in each map .cfg that belongs to the Afrikakorps series: map_script ins2/maps/afrikakorps
// Author: KernCore (A different approach from what I usually do), logic from Nero

#include "../weapons"

namespace AFRIKAKORPS1
{

/*weapon_357
weapon_9mmAR
weapon_9mmhandgun
weapon_crowbar
weapon_handgrenade
weapon_rpg
weapon_sniperrifle
ammo_357
ammo_762
ammo_9mmbox
ammo_rpgclip*/

array<array<string>> g_RevolverCandidates = {
	{ INS2_M1GARAND::GetName(), INS2_M1GARAND::GetAmmoName() },
	{ INS2_M1A1PARA::GetName(), INS2_M1A1PARA::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_M1928::GetName(), INS2_M1928::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M1911::GetName(), INS2_M1911::GetAmmoName() },
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_PZSCHRECK::GetName(), INS2_PZFAUST::GetName() },
	{ INS2_PZFAUST::GetName(), INS2_PZFAUST::GetName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_ENFIELD::GetName(), INS2_ENFIELD::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<ItemMapping@> g_ItemMappings = {
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//9mmAR
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//9mmhandgun
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] )
};

}

namespace AFRIKAKORPS2
{

/*weapon_357
weapon_9mmAR
weapon_9mmhandgun
weapon_crowbar
weapon_handgrenade
weapon_rpg
weapon_sniperrifle
ammo_357
ammo_762
ammo_9mmbox*/

array<array<string>> g_RevolverCandidates = {
	{ INS2_STG44::GetName(), INS2_STG44::GetAmmoName() },
	{ INS2_FG42::GetName(), INS2_FG42::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_M1928::GetName(), INS2_M1928::GetAmmoName() },
	{ INS2_MP18::GetName(), INS2_MP18::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M1911::GetName(), INS2_M1911::GetAmmoName() },
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() },
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName(),
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_RpgCandidates = {
	INS2_PZSCHRECK::GetName(),
	INS2_PZFAUST::GetName()
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_ENFIELD::GetName(), INS2_ENFIELD::GetAmmoName() },
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<ItemMapping@> g_ItemMappings = {
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//9mmhandgun
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//9mmAR
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] )
};

}

namespace AFRIKAKORPS3
{

/*weapon_357
weapon_9mmAR
weapon_9mmhandgun
weapon_crowbar
weapon_handgrenade
weapon_rpg
weapon_satchel
weapon_sniperrifle
ammo_9mmbox
ammo_357
ammo_762
ammo_9mmbox
ammo_rpgclip*/

array<array<string>> g_RevolverCandidates = {
	{ INS2_MG42::GetName(), INS2_MG42::GetAmmoName() },
	{ INS2_LEWIS::GetName(), INS2_LEWIS::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_M1928::GetName(), INS2_M1928::GetAmmoName() },
	{ INS2_MP40::GetName(), INS2_MP40::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() },
	{ INS2_WEBLEY::GetName(), INS2_WEBLEY::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName(),
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_PZSCHRECK::GetName(), INS2_PZSCHRECK::GetAmmoName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<string> g_SatchelCandidates = {
	INS2_PZFAUST::GetName()
};
const int iSatChooser = Math.RandomLong( 0, g_SatchelCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<ItemMapping@> g_ItemMappings = {
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//9mmhandgun
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//9mmAR
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//satchel
	ItemMapping( "weapon_satchel", g_SatchelCandidates[iSatChooser] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] )
};

}

namespace AFRIKAKORPS_BONUS
{

/*weapon_357
weapon_9mmAR
weapon_9mmhandgun
weapon_crowbar
weapon_handgrenade
weapon_rpg
weapon_sniperrifle
ammo_762
ammo_357
ammo_9mmbox*/

array<array<string>> g_RevolverCandidates = {
	{ INS2_STG44::GetName(), INS2_STG44::GetAmmoName() },
	{ INS2_FG42::GetName(), INS2_FG42::GetAmmoName() },
	{ INS2_G43::GetName(), INS2_G43::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_MP18::GetName(), INS2_MP18::GetAmmoName() },
	{ INS2_MP40::GetName(), INS2_MP40::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_C96::GetName(), INS2_C96::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_M24GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_RpgCandidates = {
	INS2_PZFAUST::GetName()
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_K98K::GetName(), INS2_K98K::GetAmmoName(), INS2_K98K::GetGLName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<ItemMapping@> g_ItemMappings = {
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
		ItemMapping( "ammo_357", g_RevolverCandidates[iRevChooser][1] ),
	//9mmhandgun
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//9mmAR
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser] ),
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] ),
		ItemMapping( "ammo_ARgrenades", g_SniperCandidates[iSnipChooser][2] )
};

}

void ReplaceItems( array<ItemMapping@>@ g_ItemMappings, CBaseEntity@ pEntity )
{
	Vector origin, angles;
	string targetname, target, netname;

	for( uint j = 0; j < g_ItemMappings.length(); ++j )
	{
		if( pEntity.pev.ClassNameIs( g_ItemMappings[j].get_From() ) )
		{
			origin = pEntity.pev.origin;
			angles = pEntity.pev.angles;
			targetname = pEntity.pev.targetname;
			target = pEntity.pev.target;
			netname = pEntity.pev.netname;

			g_EntityFuncs.Remove( pEntity );
			CBaseEntity@ pNewEnt = g_EntityFuncs.Create( g_ItemMappings[j].get_To(), origin, angles, true );

			if( targetname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "targetname", targetname );

			if( target != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "target", target );

			if( netname != "" )
				g_EntityFuncs.DispatchKeyValue( pNewEnt.edict(), "netname", netname );

			g_EntityFuncs.DispatchSpawn( pNewEnt.edict() );
		}
	}
}

//Using Materialize hook for that one guy that thought it would be a good idea to spawn entities using squadmaker
HookReturnCode PickupObjectMaterialize( CBaseEntity@ pEntity ) 
{
	if( string(g_Engine.mapname) == "afrikakorps1" )
	{
		ReplaceItems( @AFRIKAKORPS1::g_ItemMappings, @pEntity );
	}
	else if( string(g_Engine.mapname) == "afrikakorps2" )
	{
		ReplaceItems( @AFRIKAKORPS2::g_ItemMappings, @pEntity );
	}
	else if( string(g_Engine.mapname) == "afrikakorps3" )
	{
		ReplaceItems( @AFRIKAKORPS3::g_ItemMappings, @pEntity );
	}
	else if( string(g_Engine.mapname) == "afrikakorps_bonus" )
	{
		ReplaceItems( @AFRIKAKORPS_BONUS::g_ItemMappings, @pEntity );
	}
	return HOOK_HANDLED;
}

void MapInit()
{
	//if else hell down below, I don't care for this particular use case
	if( string(g_Engine.mapname) == "afrikakorps1" )
	{
		// Weapons
		//357
		INS2_M1GARAND::Register();
		INS2_M1A1PARA::Register();
		//9mmAR
		INS2_M1928::Register();
		//9mmhandgun
		INS2_M1911::Register();
		INS2_WEBLEY::Register();
		//crowbar
		INS2_KABAR::Register();
		INS2_KNUCKLES::Register();
		//handgrenade
		INS2_MK2GRENADE::Register();
		//rpg
		INS2_PZFAUST::Register();
		INS2_PZSCHRECK::Register();
		//sniperrifle
		INS2_ENFIELD::Register();

		// Initialize classic mode (item mapping only)
		g_ClassicMode.SetItemMappings( @AFRIKAKORPS1::g_ItemMappings );
	}
	else if( string(g_Engine.mapname) == "afrikakorps2" )
	{
		// Weapons
		//357
		INS2_STG44::Register();
		INS2_FG42::Register();
		//9mmAR
		INS2_M1928::Register();
		INS2_MP18::Register();
		//9mmhandgun
		INS2_M1911::Register();
		INS2_WEBLEY::Register();
		INS2_C96::Register();
		//crowbar
		INS2_KABAR::Register();
		INS2_KNUCKLES::Register();
		//handgrenade
		INS2_MK2GRENADE::Register();
		INS2_M24GRENADE::Register();
		//rpg
		INS2_PZFAUST::Register();
		INS2_PZSCHRECK::Register();
		//sniperrifle
		INS2_ENFIELD::Register();
		INS2_G43::Register();

		array<Vector> Afrikakorps02_Coords = {
			Vector( -113, -2199, 18 ),
			Vector( -113, -2209, 18 ),
			Vector( -113, -2219, 18 )
		};
		for( uint i = 0; i < Afrikakorps02_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_9mmclip", Afrikakorps02_Coords[i], g_vecZero, false );
		}

		// Initialize classic mode (item mapping only)
		g_ClassicMode.SetItemMappings( @AFRIKAKORPS2::g_ItemMappings );
	}
	else if( string(g_Engine.mapname) == "afrikakorps3" )
	{
		// Weapons
		//357
		INS2_LEWIS::Register();
		INS2_MG42::Register();
		//9mmAR
		INS2_M1928::Register();
		INS2_MP40::Register();
		//9mmhandgun
		INS2_WEBLEY::Register();
		INS2_C96::Register();
		//crowbar
		INS2_KABAR::Register();
		INS2_KNUCKLES::Register();
		//handgrenade
		INS2_MK2GRENADE::Register();
		INS2_M24GRENADE::Register();
		//rpg
		INS2_PZFAUST::Register();
		//satchel
		INS2_PZSCHRECK::Register();
		//sniperrifle
		INS2_G43::Register();

		// Initialize classic mode (item mapping only)
		g_ClassicMode.SetItemMappings( @AFRIKAKORPS3::g_ItemMappings );
	}
	else if( string(g_Engine.mapname) == "afrikakorps_bonus" )
	{
		// Weapons
		//357
		INS2_STG44::Register();
		INS2_FG42::Register();
		INS2_G43::Register();
		//9mmAR
		INS2_MP18::Register();
		INS2_MP40::Register();
		//9mmhandgun
		INS2_C96::Register();
		//crowbar
		INS2_KABAR::Register();
		//handgrenade
		INS2_M24GRENADE::Register();
		//rpg
		INS2_PZFAUST::Register();
		//sniperrifle
		INS2_K98K::Register();

		array<Vector> Afrikakorps_Bonus_Coords = {
			Vector( 3094, -1105, 34 ),
			Vector( 3094, -1110, 34 ),
			Vector( 3094, -1115, 34 )
		};
		for( uint i = 0; i < Afrikakorps_Bonus_Coords.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_ARgrenades", Afrikakorps_Bonus_Coords[i], g_vecZero, false );
		}

		array<Vector> Afrikakorps_Bonus_Coords2 = {
			Vector( 3076, -1145, 34 ),
			Vector( 3076, -1155, 34 )
		};
		for( uint i = 0; i < Afrikakorps_Bonus_Coords2.length(); i++ )
		{
			g_EntityFuncs.Create( "ammo_9mmclip", Afrikakorps_Bonus_Coords2[i], g_vecZero, false );
		}

		// Initialize classic mode (item mapping only)
		g_ClassicMode.SetItemMappings( @AFRIKAKORPS_BONUS::g_ItemMappings );
	}

	g_ClassicMode.ForceItemRemap( true );

	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @PickupObjectMaterialize );
}