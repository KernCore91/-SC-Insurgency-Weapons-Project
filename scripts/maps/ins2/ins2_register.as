// Insurgency Pack Register file (It registers everything in the pack so far)
// Author: KernCore

#include "weapons"
// Buymenu
#include "BuyMenu"

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "D.N.I.O. 071/Norman The Loli Pirate/R4to0/D.G.F./KernCore" );
	g_Module.ScriptInfo.SetContactInfo( "https://discord.gg/0wtJ6aAd7XOGI6vI" );

	/**
	* This section below is reserved for when you register the addon as a plugin
	* Changing weapons positions in the hud so they don't interfere with
	* Map script weapons (which should be using positions 4 to 8).
	*/

	//First slot 	(slot 0)    		- Melees & Utility
	INS2_KNUCKLES::POSITION     		= 9;
	INS2_KABAR::POSITION        		= 10;
	INS2_KUKRI::POSITION        		= 11;
	/*
	Gravity knife            12
	Hatchet                  13
	British Entrenching Tool 14
	*/
	//Second slot 	(slot 1)    		- Pistols & Revolvers
	INS2_MAKAROV::POSITION      		= 9;
	INS2_M1911::POSITION        		= 10;
	INS2_M9BERETTA::POSITION    		= 11;
	INS2_USP::POSITION          		= 12;
	INS2_GLOCK17::POSITION      		= 13;
	INS2_C96::POSITION          		= 14;
	INS2_DEAGLE::POSITION       		= 15;
	INS2_VP70::POSITION         		= 16;
	INS2_WEBLEY::POSITION       		= 17;
	INS2_PYTHON::POSITION       		= 18;
	INS2_M29::POSITION          		= 19;
	/*
	Stechkin APS             20
	Luger P08                21
	Mateba Model 6 Unica     22
	Akimbo P320              23
	Skorpion vz.61           24
	*/
	//Third slot 	(slot 2)    		- Submachine Guns
	INS2_UMP45::POSITION        		= 9;
	INS2_GREASEGUN::POSITION    		= 10;
	INS2_MP5K::POSITION         		= 11;
	INS2_MP18::POSITION         		= 12;
	INS2_MP40::POSITION         		= 13;
	INS2_MP5SD::POSITION        		= 14;
	INS2_STERLING::POSITION     		= 15;
	INS2_M1928::POSITION        		= 16;
	INS2_PPSH41::POSITION       		= 17;
	INS2_MP7::POSITION          		= 18;
	/*
	Mac10                    18
	Uzi                      19
	FMG-9                    20
	PP-Bizon                 21
	Kriss Vector             22
	Sten Mk. IIS             23
	*/
	//Fourth slot 	(slot 3)    		- Carbines & Shotguns
	INS2_C96CARBINE::POSITION   		= 9;
	INS2_MK18::POSITION         		= 10;
	INS2_AKS74U::POSITION       		= 11;
	INS2_M4A1::POSITION         		= 12;
	INS2_G36C::POSITION         		= 13;
	INS2_M1A1PARA::POSITION     		= 14;
	INS2_SKS::POSITION          		= 15;
	INS2_ITHACA::POSITION       		= 16;
	INS2_M590::POSITION         		= 17;
	INS2_COACH::POSITION        		= 18;
	INS2_M1014::POSITION        		= 19;
	INS2_SAIGA12::POSITION      		= 20;
	/*
	Winchester M1897         21
	Winchester M1887         22
	MTs-255 Revolver Shotgun 23
	AA-12                    24
	*/
	//Fifth slot 	(slot 4)    		- Explosives & Launchers
	INS2_M24GRENADE::POSITION   		= 9;
	INS2_MK2GRENADE::POSITION   		= 10;
	INS2_RGOGRENADE::POSITION   		= 11;
	INS2_M79::POSITION          		= 12;
	INS2_PZFAUST::POSITION      		= 13;
	INS2_LAW::POSITION          		= 14;
	INS2_AT4::POSITION          		= 15;
	INS2_RPG7::POSITION         		= 16;
	INS2_PZSCHRECK::POSITION    		= 17;
	/*
	C4 Explosive Device      17
	China Lake               18
	No. 69 Grenade           19
	TNT Charge               21
	PIAT                     22
	M1A1 Bazooka             23
	9K32M Strela-2           24
	*/
	//Sixth slot 	(slot 5)    		- Assault Rifles
	INS2_ASVAL::POSITION        		= 9;
	INS2_STG44::POSITION        		= 10;
	INS2_F2000::POSITION        		= 11;
	INS2_AK12::POSITION         		= 12;
	INS2_AK74::POSITION         		= 13;
	INS2_GALIL::POSITION        		= 14;
	INS2_AN94::POSITION         		= 15;
	INS2_M16A1::POSITION        		= 16;
	INS2_GROZA::POSITION        		= 17;
	INS2_M16A4::POSITION        		= 18;
	INS2_L85A2::POSITION        		= 19;
	INS2_AKM::POSITION          		= 20;
	/*
	Steyr AUG A1             18
	FAMAS F1                 19
	OTs-14 Groza 4           21
	Vz. 58                   22
	H&K G11                  24
	*/
	//Seventh slot 	(slot 6)    		- Rifles & Battle Rifles
	INS2_K98K::POSITION         		= 9;
	INS2_M1GARAND::POSITION     		= 10;
	INS2_ENFIELD::POSITION      		= 11;
	INS2_SVT40::POSITION        		= 12;
	INS2_FNFAL::POSITION        		= 13;
	INS2_G3A3::POSITION         		= 14;
	INS2_M14EBR::POSITION       		= 15;
	INS2_SCARH::POSITION        		= 16;
	INS2_FG42::POSITION         		= 17;
	/*
	M1918 BAR                16
	SIG SG-751               18
	SVU-AS                   19
	Gewehr 98                21
	*/
	//Eight slot 	(slot 7)    		- LMGs & Sniper Rifles
	INS2_M40A1::POSITION        		= 9;
	INS2_MOSIN::POSITION        		= 10;
	INS2_G43::POSITION          		= 11;
	INS2_XM21::POSITION         		= 12;
	INS2_SVD::POSITION          		= 13;
	INS2_LEWIS::POSITION        		= 14;
	INS2_MG34::POSITION         		= 15;
	INS2_RPK::POSITION          		= 16;
	INS2_M60::POSITION          		= 17;
	INS2_M249::POSITION         		= 18;
	INS2_PKM::POSITION          		= 19;
	INS2_MG42::POSITION         		= 20;
	/*
	WA2000                   18
	AWSM                     20
	VSSK                     21
	Bren MK. 2               22
	*/
	//Ninth slot 	(slot 8)    		- Special Purpose Weapons
	INS2_M2FLAMETHROWER::POSITION   	= 9;
	/*
	Barrett M82A1            10
	*/
	BuyMenu::RegisterBuyMenuCCVars();
}

void MapInit()
{
	g_Ins2Menu.RemoveItems();
	// Weapons
	RegisterAll();

	//Melees
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Brass Knuckles", INS2_KNUCKLES::GetName(), 40, "secondary", "melee" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "KA-BAR", INS2_KABAR::GetName(), 70, "secondary", "melee" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Kukri", INS2_KUKRI::GetName(), 90, "secondary", "melee" ) );

	//Pistols
		//Makarov
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Makarov PM 9x18mm", INS2_MAKAROV::GetName(), 100, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Makarov 9x18mm Ammo", INS2_MAKAROV::GetAmmoName(), 5, "ammo", "pistol" ) );
		//M1911
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt M1911 .45ACP", INS2_M1911::GetName(), 110, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1911 .45ACP Ammo", INS2_M1911::GetAmmoName(), 10, "ammo", "pistol" ) );
		//Beretta
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Beretta M92F 9x19mm", INS2_M9BERETTA::GetName(), 130, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Beretta 9x19mm Ammo", INS2_M9BERETTA::GetAmmoName(), 15, "ammo", "pistol" ) );
		//USP Match
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K USP Match .45ACP", INS2_USP::GetName(), 145, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "USP .45ACP Ammo", INS2_USP::GetAmmoName(), 10, "ammo", "pistol" ) );
		//Glock 17
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Glock 17 9x19mm", INS2_GLOCK17::GetName(), 155, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Glock 17 9x19mm Ammo", INS2_GLOCK17::GetAmmoName(), 20, "ammo", "pistol" ) );
		//C96
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mauser C96 7.63x25mm", INS2_C96::GetName(), 175, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 7.63x25mm Ammo", INS2_C96::GetAmmoName(), 15, "ammo", "pistol" ) );
		//Desert Eagle
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "IMI Desert Eagle .50AE", INS2_DEAGLE::GetName(), 200, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Desert Eagle .50AE Ammo", INS2_DEAGLE::GetAmmoName(), 25, "ammo", "pistol" ) );
		//H&K VP-70
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K VP-70M 9x19mm", INS2_VP70::GetName(), 170, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "VP-70M 9x19mm Ammo", INS2_VP70::GetAmmoName(), 20, "ammo", "pistol" ) );

	//Revolvers
		//Webley
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Webley Mk.VI .455 WMk.II", INS2_WEBLEY::GetName(), 160, "secondary", "revolver" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Webley .455 WMk.II Ammo", INS2_WEBLEY::GetAmmoName(), 10, "ammo", "revolver" ) );
		//Colt Python
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt Python .357 Magnum", INS2_PYTHON::GetName(), 180, "secondary", "revolver" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Python .357 Magnum Ammo", INS2_PYTHON::GetAmmoName(), 15, "ammo", "revolver" ) );
		//Model M29
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "S&W Model 29 .44 Magnum", INS2_M29::GetName(), 190, "secondary", "revolver" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Model 29 .44 Magnum Ammo", INS2_M29::GetAmmoName(), 20, "ammo", "revolver" ) );

	//Submachine Guns
		//UMP45
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K UMP-45 .45ACP", INS2_UMP45::GetName(), 165, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "UMP-45 .45ACP Ammo", INS2_UMP45::GetAmmoName(), 20, "ammo", "smg" ) );
		//M3 Greasegun
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M3 Greasegun .45ACP", INS2_GREASEGUN::GetName(), 170, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M3 Greasegun .45ACP Ammo", INS2_GREASEGUN::GetAmmoName(), 25, "ammo", "smg" ) );
		//MP5K
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K MP5K 9x19mm", INS2_MP5K::GetName(), 175, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP5K 9x19mm Ammo", INS2_MP5K::GetAmmoName(), 20, "ammo", "smg" ) );
		//MP-18
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Bergmann MP-18,I 9x19mm", INS2_MP18::GetName(), 180, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-18 9x19mm Ammo", INS2_MP18::GetAmmoName(), 25, "ammo", "smg" ) );
		//MP40
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-40 9x19mm", INS2_MP40::GetName(), 185, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-40 9x19mm Ammo", INS2_MP40::GetAmmoName(), 25, "ammo", "smg" ) );
		//MP5SD
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K MP5SD 9x19mm", INS2_MP5SD::GetName(), 190, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP5SD 9x19mm Ammo", INS2_MP5SD::GetAmmoName(), 20, "ammo", "smg" ) );
		//Sterling L2A3
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Sterling L2A3 9x19mm", INS2_STERLING::GetName(), 195, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Sterling 9x19mm Ammo", INS2_STERLING::GetAmmoName(), 30, "ammo", "smg" ) );
		//Thompson M1928
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Thompson M1928 .45ACP", INS2_M1928::GetName(), 225, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Thompson M1928 .45ACP Ammo", INS2_M1928::GetAmmoName(), 50, "ammo", "smg" ) );
		//PPSh41
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PPSh-41 7.62x25mm", INS2_PPSH41::GetName(), 235, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PPSh-41 7.62x25mm Ammo", INS2_PPSH41::GetAmmoName(), 50, "ammo", "smg" ) );
		//MP7
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K MP7 4.6x30mm", INS2_MP7::GetName(), 315, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP7 4.6x30mm Ammo", INS2_MP7::GetAmmoName(), 45, "ammo", "smg" ) );

	//Carbines
		//C96 M1932 Schnellfeuer
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 M1932 Schnellfeuer 7.63x25mm", INS2_C96CARBINE::GetName(), 185, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 M1932 7.63x25mm Ammo", INS2_C96CARBINE::GetAmmoName(), 30, "ammo", "carbine" ) );
		//MK. 18
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk. 18 MOD 1 5.56x45mm + EOTech Sight", INS2_MK18::GetName(), 220, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk. 18 5.56x45mm Ammo", INS2_MK18::GetAmmoName(), 30, "ammo", "carbine" ) );
		//AKS-74U
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74U 5.45x39mm", INS2_AKS74U::GetName(), 235, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74U 5.45x39mm Ammo", INS2_AKS74U::GetAmmoName(), 30, "ammo", "carbine" ) );
		//M4A1
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt M4A1 5.56x45mm + Foregrip", INS2_M4A1::GetName(), 245, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M4A1 5.56x45mm Ammo", INS2_M4A1::GetAmmoName(), 30, "ammo", "carbine" ) );
		//G36C
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K G36C 5.56x45mm", INS2_G36C::GetName(), 250, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "G36C 5.56x45mm Ammo", INS2_G36C::GetAmmoName(), 30, "ammo", "carbine" ) );
		//M1A1 Paratrooper
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1A1 Paratrooper 7.62x33mm + Bayonet", INS2_M1A1PARA::GetName(), 260, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1A1 Paratrooper 7.62x33mm Ammo", INS2_M1A1PARA::GetAmmoName(), 20, "ammo", "carbine" ) );
		//SKS
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SKS Simonov 7.62x39mm", INS2_SKS::GetName(), 270, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SKS 7.62x39mm Ammo", INS2_SKS::GetAmmoName(), 25, "ammo", "carbine" ) );

	//Shotguns
		//Ithaca M37
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Ithaca M37 12 Gauge + Bayonet", INS2_ITHACA::GetName(), 275, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Ithaca M37 12 Gauge Ammo", INS2_ITHACA::GetAmmoName(), 40, "ammo", "shotgun" ) );
		//M590
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mossberg M590 12 Gauge", INS2_M590::GetName(), 285, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M590 12 Gauge Ammo", INS2_M590::GetAmmoName(), 50, "ammo", "shotgun" ) );
		//Coach Gun
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Coach Gun Buck & Ball", INS2_COACH::GetName(), 295, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Coach Gun Buck & Ball Ammo", INS2_COACH::GetAmmoName(), 20, "ammo", "shotgun" ) );
		//M1014
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Benelli M1014 12 Gauge", INS2_M1014::GetName(), 330, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1014 12 Gauge Ammo", INS2_M1014::GetAmmoName(), 45, "ammo", "shotgun" ) );
		//Saiga 12
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Saiga 12K 12 Gauge", INS2_SAIGA12::GetName(), 725, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Saiga 12K 12 Gauge Ammo", INS2_SAIGA12::GetAmmoName(), 80, "ammo", "shotgun" ) );

	//Assault Rifles & Battle Rifles
		//AS VAL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AS VAL 9x39mm", INS2_ASVAL::GetName(), 230, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AS VAL 9x39mm Ammo", INS2_ASVAL::GetAmmoName(), 20, "ammo", "assault" ) );
		//GALIL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "IMI GALIL ARM 5.56x45mm + Bipod", INS2_GALIL::GetName(), 260, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "GALIL 5.56x45mm Ammo", INS2_GALIL::GetAmmoName(), 35, "ammo", "assault" ) );
		//F2000
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN F2000 5.56x45mm", INS2_F2000::GetName(), 265, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "F2000 5.56x45mm Ammo", INS2_F2000::GetAmmoName(), 30, "ammo", "assault" ) );
		//AK-12
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AK-12 5.45x39mm", INS2_AK12::GetName(), 275, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AK-12 5.45x39mm Ammo", INS2_AK12::GetAmmoName(), 30, "ammo", "assault" ) );
		//AK-74
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74 + Foregrip 5.45x39mm", INS2_AK74::GetName(), 285, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74 5.45x39mm Ammo", INS2_AK74::GetAmmoName(), 30, "ammo", "assault" ) );
		//StG-44
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "StG-44 7.92x33mm", INS2_STG44::GetName(), 290, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "StG-44 7.92x33mm Ammo", INS2_STG44::GetAmmoName(), 30, "ammo", "assault" ) );
		//AN-94
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AN-94N + PK-AS 5.45x39mm", INS2_AN94::GetName(), 300, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AN-94N 5.45x39mm Ammo", INS2_AN94::GetAmmoName(), 30, "ammo", "assault" ) );
		//M16A1
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A1 5.56x45mm + M203 40mm M406", INS2_M16A1::GetName(), 310, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A1 5.56x45mm Ammo", INS2_M16A1::GetAmmoName(), 20, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M203 40mm M406 grenade Ammo", INS2_M16A1::GetGLName(), 30, "ammo", "launcher" ) );
		//OTs-14 Groza 4 9/40
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "OTs-14 Groza 4 9x39mm + GP-30 40mm VOG-25", INS2_GROZA::GetName(), 320, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "OTs-14 9x39mm Ammo", INS2_GROZA::GetAmmoName(), 20, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "GP-30 40mm VOG-25 grenade Ammo", INS2_GROZA::GetGLName(), 30, "ammo", "launcher" ) );
		//M16A4
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A4 5.56x45mm + M203 40mm M406", INS2_M16A4::GetName(), 325, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A4 5.56x45mm Ammo", INS2_M16A4::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M203 40mm M406 grenade Ammo", INS2_M16A4::GetGLName(), 30, "ammo", "launcher" ) );
		//L85A2
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "L85A2 5.56x45mm + AG-36 40mm M406", INS2_L85A2::GetName(), 335, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "L85A2 5.56x45mm Ammo", INS2_L85A2::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AG-36 40mm M406 grenade Ammo", INS2_L85A2::GetGLName(), 30, "ammo", "launcher" ) );
		//AKM
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKM 7.62x39mm + GP-25 40mm VOG-25P", INS2_AKM::GetName(), 350, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKM 7.62x39mm Ammo", INS2_AKM::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "GP-25 40mm VOG-25P grenade Ammo", INS2_AKM::GetGLName(), 30, "ammo", "launcher" ) );

	//Rifles & Sniper Rifles
		//Kar98K
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Karabiner 98K 7.92x57mm + Schiessbecher 30x250mm", INS2_K98K::GetName(), 240, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Karabiner 98K 7.92x57mm Ammo", INS2_K98K::GetAmmoName(), 10, "ammo", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Schiessbecher 30x250mm Ammo", INS2_K98K::GetGLName(), 30, "ammo", "launcher" ) );
		//Garand
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1 Garand 7.62x63mm + Bayonet", INS2_M1GARAND::GetName(), 255, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1 Garand 7.62x63mm Ammo", INS2_M1GARAND::GetAmmoName(), 15, "ammo", "rifle" ) );
		//Enfield
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lee-Enfield No.IV Mk.I .303", INS2_ENFIELD::GetName(), 270, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lee-Enfield .303 Ammo", INS2_ENFIELD::GetAmmoName(), 20, "ammo", "rifle" ) );
		//SVT-40
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SVT-40 7.62x54mmR", INS2_SVT40::GetName(), 290, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SVT-40 7.62x54mmR Ammo", INS2_SVT40::GetAmmoName(), 30, "ammo", "rifle" ) );
		//FN FAL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN FAL 7.62x51mm", INS2_FNFAL::GetName(), 330, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN FAL 7.62x51mm Ammo", INS2_FNFAL::GetAmmoName(), 20, "ammo", "rifle" ) );
		//G3A3
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K G3A3 7.62x51mm", INS2_G3A3::GetName(), 335, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "G3A3 7.62x51mm Ammo", INS2_G3A3::GetAmmoName(), 20, "ammo", "rifle" ) );
		//M14 EBR
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M14 EBR 7.62x51mm + Red Dot Sight", INS2_M14EBR::GetName(), 345, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M14 EBR 7.62x51mm Ammo", INS2_M14EBR::GetAmmoName(), 20, "ammo", "rifle" ) );
		//SCARH
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN SCAR-H 7.62x51mm", INS2_SCARH::GetName(), 350, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SCAR-H 7.62x51mm Ammo", INS2_SCARH::GetAmmoName(), 20, "ammo", "rifle" ) );
		//FG-42
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FG-42 7.92x57mm + Bipod", INS2_FG42::GetName(), 360, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FG-42 7.92x57mm Ammo", INS2_FG42::GetAmmoName(), 35, "ammo", "rifle" ) );
		//M40A1
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M40A1 7.62x51mm + Leupold Scope", INS2_M40A1::GetName(), 305, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M40A1 7.62x51mm Ammo", INS2_M40A1::GetAmmoName(), 10, "ammo", "rifle" ) );
		//Mosin Nagant
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mosin Nagant M91/30 7.62x54mmR + PU Scope", INS2_MOSIN::GetName(), 320, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mosin Nagant 7.62x54mmR Ammo", INS2_MOSIN::GetAmmoName(), 15, "ammo", "rifle" ) );
		//G43
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Gewehr 43 7.92x57mm + ZF4 Scope", INS2_G43::GetName(), 340, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Gewehr 43 7.92x57mm Ammo", INS2_G43::GetAmmoName(), 20, "ammo", "rifle" ) );
		//XM21
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "XM21 7.62x51mm + Redfield ART 1 Scope", INS2_XM21::GetName(), 350, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "XM21 7.62x51mm Ammo", INS2_XM21::GetAmmoName(), 20, "ammo", "rifle" ) );
		//Dragunov
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SVD Dragunov 7.62x54mmR + PSO-1 Scope", INS2_SVD::GetName(), 360, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Dragunov 7.62x54mmR Ammo", INS2_SVD::GetAmmoName(), 30, "ammo", "rifle" ) );

	//Light Machine Guns
		//Lewis
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lewis Model 1915 MK.I .303 + Bipod", INS2_LEWIS::GetName(), 400, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lewis .303 Ammo", INS2_LEWIS::GetAmmoName(), 55, "ammo", "lmg" ) );
		//MG-34
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-34 7.92x57mm + Bipod", INS2_MG34::GetName(), 445, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-34 7.92x57mm Ammo", INS2_MG34::GetAmmoName(), 40, "ammo", "lmg" ) );
		//RPK
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPK 7.62x39mm + Bipod", INS2_RPK::GetName(), 485, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPK 7.62x39mm Ammo", INS2_RPK::GetAmmoName(), 75, "ammo", "lmg" ) );
		//M60
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M60 7.62x51mm + Bipod", INS2_M60::GetName(), 540, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M60 7.62x51mm Ammo", INS2_M60::GetAmmoName(), 100, "ammo", "lmg" ) );
		//M249
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN M249 5.56x45mm AP + Bipod", INS2_M249::GetName(), 700, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M249 5.56x45mm AP Ammo", INS2_M249::GetAmmoName(), 130, "ammo", "lmg" ) );
		//PKM
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PKM 7.62x54mmR + Bipod", INS2_PKM::GetName(), 950, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PKM 7.62x54mmR Ammo", INS2_PKM::GetAmmoName(), 200, "ammo", "lmg" ) );
		//MG-42
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-42 7.92x57mm + Bipod", INS2_MG42::GetName(), 1000, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-42 7.92x57mm Ammo", INS2_MG42::GetAmmoName(), 200, "ammo", "lmg" ) );

	//Launchers & Explosives
		//M79
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 Grenade Launcher", INS2_M79::GetName(), 450, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 40mm Grenade M406 Ammo", INS2_M79::GetAmmoName(), 30, "ammo", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 40mm Buckshot M576 Ammo", INS2_M79::GetGLName(), 35, "ammo", "launcher" ) );
		//RPG7
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPG-7", INS2_RPG7::GetName(), 600, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPG-7 40mm Rocket Ammo", INS2_RPG7::GetAmmoName(), 100, "ammo", "launcher" ) );
		//Panzerschreck
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerschreck", INS2_PZSCHRECK::GetName(), 700, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerschreck 88mm Rocket Ammo", INS2_PZSCHRECK::GetAmmoName(), 125, "ammo", "launcher" ) );
		//M2 Flamethrower
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M2 Flamethrower", INS2_M2FLAMETHROWER::GetName(), 800, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M2 Napalm Ammo", INS2_M2FLAMETHROWER::GetAmmoName(), 60, "ammo", "launcher" ) );

	//Time-Fuse Grenades
		//Stielhandgranate M24
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Stielhandgranate M24", INS2_M24GRENADE::GetName(), 45, "equipment", "timed" ) );
		//Mk. 2 Grenade
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk. 2 \"Pineapple\" Grenade", INS2_MK2GRENADE::GetName(), 50, "equipment", "timed" ) );

	//Impact-Fuse Grenades
		//RGO Grenade
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RGO Grenade", INS2_RGOGRENADE::GetName(), 65, "equipment", "impact" ) );
		//NO. 69
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "NO. 69 Grenade", INS2_NO69GRENADE::GetName(), 75, "equipment", "impact" ) );

	//Disposable Launchers
		//Panzerfaust
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerfaust 60M", INS2_PZFAUST::GetName(), 400, "equipment", "disposable" ) );
		//M72 LAW
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M72 LAW", INS2_LAW::GetName(), 425, "equipment", "disposable" ) );
		//AT4
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M136 AT4", INS2_AT4::GetName(), 450, "equipment", "disposable" ) );

	//High Explosives
		//TNT
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "TNT (10 Seconds Fuse)", INS2_TNT::GetName(), 400, "equipment", "explosive" ) );
		//Remote Controlled C4
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Remote Controlled C4", INS2_C4::GetName(), 500, "equipment", "explosive" ) );


	BuyMenu::MoneyInit();
}