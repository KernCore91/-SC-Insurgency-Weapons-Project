// Replacement Script with Insurgency Weapons
// Replace the original map script with this one in each map .cfg that belongs to the UTBM series: map_script ins2/maps/of_utbm
// Author: KernCore, logic from Nero

#include "../../point_checkpoint"
#include "../../opfor/nvision"
#include "../../opfor/weapon_knife"

//Ins2 weapons
#include "../weapons"

/*
ammo_357
ammo_556
ammo_556clip
ammo_762
ammo_9mmAR
ammo_9mmbox
ammo_9mmclip
ammo_ARgrenades
ammo_buckshot
ammo_gaussclip
ammo_rpgclip
ammo_spore
weapon_357
weapon_9mmAR
weapon_9mmhandgun
weapon_displacer
weapon_eagle
weapon_gauss
weapon_glock
weapon_grapple
weapon_handgrenade
weapon_knife
weapon_m16
weapon_m249
weapon_medkit
weapon_minigun
weapon_mp5
weapon_pipewrench
weapon_rpg
weapon_satchel
weapon_saw
weapon_shockrifle
weapon_shotgun
weapon_snark
weapon_sniperrifle
weapon_sporelauncher
weapon_tripmine
weapon_uziakimbo
*/

namespace UNDERTHEBLACKMOON
{

array<string> g_CrowbarCandidates = {
	INS2_KABAR::GetName(),
	INS2_KNUCKLES::GetName()
};
const int iCrowbChooser = Math.RandomLong( 0, g_CrowbarCandidates.length() - 1 );

array<array<string>> g_9mmHandGunCandidates = {
	{ INS2_M9BERETTA::GetName(), INS2_M9BERETTA::GetAmmoName() },
	{ INS2_GLOCK17::GetName(), INS2_GLOCK17::GetAmmoName() }
};
const int i9mmChooser = Math.RandomLong( 0, g_9mmHandGunCandidates.length() - 1 );

array<array<string>> g_RevolverCandidates = {
	{ INS2_PYTHON::GetName(), INS2_PYTHON::GetAmmoName() },
	{ INS2_M29::GetName(), INS2_M29::GetAmmoName() }
};
const int iRevChooser = Math.RandomLong( 0, g_RevolverCandidates.length() - 1 );

array<array<string>> g_DeagleCandidates = {
	{ INS2_DEAGLE::GetName(), INS2_DEAGLE::GetAmmoName() },
	{ INS2_USP::GetName(), INS2_USP::GetAmmoName() }
};
const int iDeagChooser = Math.RandomLong( 0, g_DeagleCandidates.length() - 1 );

array<string> g_UziAkimboCandidates = {
	INS2_MP7::GetName()
};
const int iUziAkimboChooser = Math.RandomLong( 0, g_UziAkimboCandidates.length() - 1 );

array<array<string>> g_9mmARCandidates = {
	{ INS2_UMP45::GetName(), INS2_UMP45::GetAmmoName() },
	{ INS2_MP5K::GetName(), INS2_MP5K::GetAmmoName() }
};
const int iARChooser = Math.RandomLong( 0, g_9mmARCandidates.length() - 1 );

array<array<string>> g_ShotgunCandidates = {
	{ INS2_M590::GetName(), INS2_M590::GetAmmoName() },
	{ INS2_M1014::GetName(), INS2_M1014::GetAmmoName() }
};
const int iShotChooser = Math.RandomLong( 0, g_ShotgunCandidates.length() - 1 );

array<array<string>> g_M16Candidates = {
	{ INS2_M16A4::GetName(), INS2_M16A4::GetAmmoName(), INS2_M16A4::GetGLName() },
	{ INS2_L85A2::GetName(), INS2_L85A2::GetAmmoName(), INS2_L85A2::GetGLName() }
};
const int iM16Chooser = Math.RandomLong( 0, g_M16Candidates.length() - 1 );

array<array<string>> g_RpgCandidates = {
	{ INS2_AT4::GetName(), INS2_AT4::GetName() }
};
const int iRpgChooser = Math.RandomLong( 0, g_RpgCandidates.length() - 1 );

array<string> g_GrenadeCandidates = {
	INS2_MK2GRENADE::GetName()
};
const int iGrenChooser = Math.RandomLong( 0, g_GrenadeCandidates.length() - 1 );

array<string> g_SatchelCandidates = {
	INS2_LAW::GetName()
};
const int iSatchChooser = Math.RandomLong( 0, g_SatchelCandidates.length() - 1 );

array<array<string>> g_SniperCandidates = {
	{ INS2_M40A1::GetName(), INS2_M40A1::GetAmmoName() }
};
const int iSnipChooser = Math.RandomLong( 0, g_SniperCandidates.length() - 1 );

array<array<string>> g_M249Candidates = {
	{ INS2_M60::GetName(), INS2_M60::GetAmmoName() }
};
const int iM249Chooser = Math.RandomLong( 0, g_M249Candidates.length() - 1 );

array<array<string>> g_SporeLauncherCandidates = {
	{ INS2_M79::GetName(), INS2_M79::GetAmmoName() }
};
const int iSporeChooser = Math.RandomLong( 0, g_SporeLauncherCandidates.length() - 1 );

array<array<string>> g_ShockRifleCandidates = {
	{ INS2_M4A1::GetName(), INS2_M4A1::GetAmmoName() },
	{ INS2_MK18::GetName(), INS2_MK18::GetAmmoName() },
	{ INS2_F2000::GetName(), INS2_F2000::GetAmmoName() }
};
const int iShockChooser = Math.RandomLong( 0, g_ShockRifleCandidates.length() - 1 );

array<string> g_MinigunCandidates = {
	INS2_M249::GetName()
};
const int iMinigunChooser = Math.RandomLong( 0, g_MinigunCandidates.length() - 1 );

array<ItemMapping@> g_Ins2ItemMappings = {
	//knife
	ItemMapping( "weapon_knife", g_CrowbarCandidates[iCrowbChooser] ),
	//crowbar
	ItemMapping( "weapon_crowbar", g_CrowbarCandidates[iCrowbChooser] ),
	//pipewrench
	ItemMapping( "weapon_pipewrench", INS2_KUKRI::GetName() ),
	//glock
	ItemMapping( "weapon_9mmhandgun", g_9mmHandGunCandidates[i9mmChooser][0] ), ItemMapping( "weapon_glock", g_9mmHandGunCandidates[i9mmChooser][0] ),
		ItemMapping( "ammo_9mmclip", g_9mmHandGunCandidates[i9mmChooser][1] ), ItemMapping( "ammo_glockclip", g_9mmHandGunCandidates[i9mmChooser][1] ),
	//357
	ItemMapping( "weapon_357", g_RevolverCandidates[iRevChooser][0] ), ItemMapping( "weapon_python", g_RevolverCandidates[iRevChooser][0] ),
	//eagle
	ItemMapping( "weapon_eagle", g_DeagleCandidates[iDeagChooser][0] ), //The deagle doesn't have a ammo entity ¯\_(ツ)_/¯
		ItemMapping( "ammo_357", g_DeagleCandidates[iDeagChooser][1] ),
	//uziakimbo
	ItemMapping( "weapon_uziakimbo", g_UziAkimboCandidates[iUziAkimboChooser] ),
	//mp5
	ItemMapping( "weapon_9mmAR", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_9mmar", g_9mmARCandidates[iARChooser][0] ), ItemMapping( "weapon_mp5", g_9mmARCandidates[iARChooser][0] ),
		ItemMapping( "ammo_9mmAR", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_mp5clip", g_9mmARCandidates[iARChooser][1] ), ItemMapping( "ammo_9mmbox", g_9mmARCandidates[iARChooser][1] ),
	//shotgun
	ItemMapping( "weapon_shotgun", g_ShotgunCandidates[iShotChooser][0] ),
		ItemMapping( "ammo_buckshot", g_ShotgunCandidates[iShotChooser][1] ),
	//m16
	ItemMapping( "weapon_m16", g_M16Candidates[iM16Chooser][0] ),
		ItemMapping( "ammo_556clip", g_M16Candidates[iM16Chooser][1] ),
		ItemMapping( "ammo_ARgrenades", g_M16Candidates[iM16Chooser][2] ), ItemMapping( "ammo_mp5grenades", g_M16Candidates[iM16Chooser][2] ),
	//rpg
	ItemMapping( "weapon_rpg", g_RpgCandidates[iRpgChooser][0] ),
		ItemMapping( "ammo_rpgclip", g_RpgCandidates[iRpgChooser][1] ),
	//gauss
	//handgrenade
	ItemMapping( "weapon_handgrenade", g_GrenadeCandidates[iGrenChooser] ),
	//satchel
	ItemMapping( "weapon_satchel", g_SatchelCandidates[iSatchChooser] ),
	//tripmine
	ItemMapping( "weapon_tripmine", g_SatchelCandidates[iSatchChooser] ),
	//snark
	//sniperrifle
	ItemMapping( "weapon_sniperrifle", g_SniperCandidates[iSnipChooser][0] ),
		ItemMapping( "ammo_762", g_SniperCandidates[iSnipChooser][1] ),
	//m249
	ItemMapping( "weapon_m249", g_M249Candidates[iM249Chooser][0] ), ItemMapping( "weapon_saw", g_M249Candidates[iM249Chooser][0] ),
		ItemMapping( "ammo_556", g_M249Candidates[iM249Chooser][1] ),
	//sporelauncher
	ItemMapping( "weapon_sporelauncher", g_SporeLauncherCandidates[iSporeChooser][0] ),
		ItemMapping( "ammo_spore", g_SporeLauncherCandidates[iSporeChooser][1] ), ItemMapping( "ammo_sporeclip", g_SporeLauncherCandidates[iSporeChooser][1] ),
	//displacer
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
	// Enable SC CheckPoint Support for Survival Mode
	RegisterPointCheckPointEntity();
	// Register original Opposing Force knife weapon
	RegisterKnife();
	// Enable Nightvision Support
	NightVision::Enable();
	// Global CVars
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 0 );

	if( g_Engine.mapname == "of_utbm_7" || g_Engine.mapname == "of_utbm_8" || g_Engine.mapname == "of_utbm_9" )
		Precache();

	INS2_KABAR::POSITION = 22;
	INS2_KABAR::Register();
	INS2_KNUCKLES::POSITION = 21;
	INS2_KNUCKLES::Register();
	INS2_KUKRI::POSITION = 23;
	INS2_KUKRI::Register();
	INS2_M9BERETTA::Register();
	INS2_GLOCK17::Register();
	INS2_PYTHON::Register();
	INS2_M29::Register();
	INS2_DEAGLE::Register();
	INS2_USP::Register();
	INS2_MP7::Register();
	INS2_UMP45::Register();
	INS2_MP5K::Register();
	INS2_M590::Register();
	INS2_M1014::Register();
	INS2_M16A4::Register();
	INS2_L85A2::Register();
	INS2_AT4::Register();
	INS2_MK2GRENADE::Register();
	INS2_LAW::Register();
	INS2_M40A1::Register();
	INS2_M60::Register();
	INS2_M249::Register();
	INS2_M79::Register();
	INS2_M4A1::Register();
	INS2_MK18::Register();
	INS2_F2000::Register();
	

	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @UNDERTHEBLACKMOON::g_Ins2ItemMappings );
	g_ClassicMode.ForceItemRemap( true );

	g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, @UNDERTHEBLACKMOON::PickupObjectMaterialize );
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
		CBaseEntity@ pNewEnt1 = g_EntityFuncs.Create( UNDERTHEBLACKMOON::g_SporeLauncherCandidates[UNDERTHEBLACKMOON::iSporeChooser][1], origin, angles, true );
		if( targetname != "" )
			g_EntityFuncs.DispatchKeyValue( pNewEnt1.edict(), "targetname", targetname );

		g_EntityFuncs.DispatchSpawn( pNewEnt1.edict() );
	}
	//KernCore: End

	g_EngineFuncs.ServerPrint( "Opposing Force: Under the Black Moon Version 1.6 - Download this campaign at scmapdb.com\n" );
	
	if( g_Engine.mapname == "of_utbm_7" || g_Engine.mapname == "of_utbm_8" || g_Engine.mapname == "of_utbm_9" )
		InitXenReturn();
}

void Precache()
{
	g_Game.PrecacheModel( "sprites/exit1.spr" );
	g_Game.PrecacheGeneric( "sprites/exit1.spr" );
	g_SoundSystem.PrecacheSound( "weapons/displacer_self.wav" );
}

void InitXenReturn()
{
	CBaseEntity@ pXenReturnDest;

	dictionary xenfx =
	{
		{ "targetname", "xen_return_spawnfx" },
		{ "m_iszScriptFunctionName", "XenReturnFx" },
		{ "m_iMode", "1" }
	};
	g_EntityFuncs.CreateEntity( "trigger_script", xenfx, true );

	while( ( @pXenReturnDest = g_EntityFuncs.FindEntityByTargetname( pXenReturnDest, "xen_return_dest*") ) !is null )
	{
		if( pXenReturnDest.GetClassname() != "info_teleport_destination" )
			continue;

		if( pXenReturnDest.pev.SpawnFlagBitSet( 32 ) )
			continue;

		pXenReturnDest.pev.spawnflags |= 32;
		pXenReturnDest.pev.target = "xen_return_spawnfx";
	}
}

void XenReturnFx(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if( pActivator is null )
		return;

	CSprite@ pSprite = g_EntityFuncs.CreateSprite( "sprites/exit1.spr", pActivator.GetOrigin(), true, 0.0f );
	pSprite.SetScale( 1 );
	pSprite.SetTransparency( kRenderTransAdd, 0, 0, 0, 200, kRenderFxNoDissipation );
	pSprite.AnimateAndDie( 18 );

	g_SoundSystem.EmitSound( pActivator.edict(), CHAN_ITEM, "weapons/displacer_self.wav", 1.0f, ATTN_NORM );
}