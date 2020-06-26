//assault rifles
#include "arifl/weapon_ins2akm"
#include "arifl/weapon_ins2m16a4"
#include "arifl/weapon_ins2galil"
#include "arifl/weapon_ins2asval"
#include "arifl/weapon_ins2l85a2"
#include "arifl/weapon_ins2ak74"
#include "arifl/weapon_ins2ak12"
//battle rifles
#include "brifl/weapon_ins2fnfal"
#include "brifl/weapon_ins2g3a3"
#include "brifl/weapon_ins2m14ebr"
//rifles
#include "rifle/weapon_ins2garand"
#include "rifle/weapon_ins2enfield"
//handguns
#include "handg/weapon_ins2usp"
#include "handg/weapon_ins2beretta"
#include "handg/weapon_ins2c96"
#include "handg/weapon_ins2deagle"
#include "handg/weapon_ins2glock17"
#include "handg/weapon_ins2webley"
//lmgs
#include "lmg/weapon_ins2rpk"
#include "lmg/weapon_ins2m249"
#include "lmg/weapon_ins2mg42"
#include "lmg/weapon_ins2m60"
//explosives/launchers
#include "explo/weapon_ins2mk2"
#include "explo/weapon_ins2rpg7"
#include "explo/weapon_ins2law"
#include "explo/weapon_ins2stick"
#include "explo/weapon_ins2pzfaust"
#include "explo/weapon_ins2m79"
#include "explo/weapon_ins2pzschreck"
#include "explo/weapon_ins2at4"
//shotguns
#include "shotg/weapon_ins2m590"
#include "shotg/weapon_ins2m1014"
#include "shotg/weapon_ins2coach"
#include "shotg/weapon_ins2ithaca"
//smgs
#include "smg/weapon_ins2mp5k"
#include "smg/weapon_ins2ump45"
#include "smg/weapon_ins2mp40"
#include "smg/weapon_ins2l2a3"
#include "smg/weapon_ins2m1928"
#include "smg/weapon_ins2mp7"
#include "smg/weapon_ins2mp18"
//carbines
#include "carbn/weapon_ins2sks"
#include "carbn/weapon_ins2m4a1"
#include "carbn/weapon_ins2aks74u"
#include "carbn/weapon_ins2c96carb"
//melees
#include "melee/weapon_ins2kabar"
#include "melee/weapon_ins2knuckles"
#include "melee/weapon_ins2kukri"
//sniper rifles
#include "srifl/weapon_ins2g43"

void RegisterAll()
{
	//assault rifles
	INS2_AKM::Register();
	INS2_M16A4::Register();
	INS2_GALIL::Register();
	INS2_ASVAL::Register();
	INS2_L85A2::Register();
	INS2_AK74::Register();
	INS2_AK12::Register();
	//battle rifles
	INS2_FNFAL::Register();
	INS2_G3A3::Register();
	INS2_M14EBR::Register();
	//rifles
	INS2_M1GARAND::Register();
	INS2_ENFIELD::Register();
	//handguns
	INS2_USP::Register();
	INS2_M9BERETTA::Register();
	INS2_C96::Register();
	INS2_DEAGLE::Register();
	INS2_GLOCK17::Register();
	INS2_WEBLEY::Register();
	//lmgs
	INS2_RPK::Register();
	INS2_M249::Register();
	INS2_MG42::Register();
	INS2_M60::Register();
	//explosives/launchers
	INS2_MK2GRENADE::Register();
	INS2_RPG7::Register();
	INS2_LAW::Register();
	INS2_M24GRENADE::Register();
	INS2_PZFAUST::Register();
	INS2_M79::Register();
	INS2_PZSCHRECK::Register();
	INS2_AT4::Register();
	//shotguns
	INS2_M590::Register();
	INS2_M1014::Register();
	INS2_COACH::Register();
	INS2_ITHACA::Register();
	//smgs
	INS2_MP5K::Register();
	INS2_UMP45::Register();
	INS2_MP40::Register();
	INS2_STERLING::Register();
	INS2_MP7::Register();
	INS2_M1928::Register();
	INS2_MP18::Register();
	//carbines
	INS2_C96CARBINE::Register();
	INS2_SKS::Register();
	INS2_M4A1::Register();
	INS2_AKS74U::Register();
	//melees
	INS2_KABAR::Register();
	INS2_KNUCKLES::Register();
	INS2_KUKRI::Register();
	//sniper rifles
	INS2_G43::Register();
}