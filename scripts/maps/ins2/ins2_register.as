// Insurgency Pack Register file (It registers everything in the pack so far)
// Author: KernCore

#include "weapons"
// Buymenu
#include "BuyMenu"

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "D.N.I.O. 071/Norman The Loli Pirate/R4to0/KernCore" );
	g_Module.ScriptInfo.SetContactInfo( "https://discord.gg/0wtJ6aAd7XOGI6vI" );

	//First slot 	(slot 0)    		- Melees & Utility
	INS2_KNUCKLES::POSITION     		= 9;
	INS2_KABAR::POSITION        		= 10;
	INS2_KUKRI::POSITION        		= 11;
	//INS2_GRAVKNIFE::POSITION  		= 12;
	//INS2_ETOOL::POSITION      		= 13;
	//Second slot 	(slot 1)    		- Pistols & Revolvers
	//INS2_MAKAROV::POSITION      		= 9;
	//INS2_M1911::POSITION        		= 10;
	INS2_M9BERETTA::POSITION    		= 11;
	INS2_USP::POSITION          		= 12;
	INS2_GLOCK17::POSITION      		= 13;
	INS2_C96::POSITION          		= 14;
	INS2_DEAGLE::POSITION       		= 15;
	INS2_WEBLEY::POSITION       		= 16;
	//INS2_PYTHON::POSITION       		= 17;
	//INS2_M29::POSITION          		= 18;
	//INS2_CZ75B::POSITION      		= 19;
	//Third slot 	(slot 2)    		- Submachine Guns
	INS2_UMP45::POSITION        		= 9;
	INS2_MP5K::POSITION         		= 10;
	INS2_MP18::POSITION         		= 11;
	INS2_MP40::POSITION         		= 12;
	INS2_STERLING::POSITION     		= 13;
	//INS2_PPSH41::POSITION       		= 14;
	INS2_M1928::POSITION        		= 15;
	INS2_MP7::POSITION          		= 16;
	//INS2_VECTOR::POSITION     		= 17;
	//INS2_UZI::POSITION        		= 18;
	//INS2_MP5SD::POSITION      		= 19;
	//Fourth slot 	(slot 3)    		- Carbines & Shotguns
	INS2_C96CARBINE::POSITION   		= 9;
	//INS2_MK18::POSITION         		= 10;
	INS2_AKS74U::POSITION       		= 11;
	INS2_M4A1::POSITION         		= 12;
	//INS2_M1A1PARA::POSITION     		= 13;
	INS2_SKS::POSITION          		= 14;
	INS2_ITHACA::POSITION       		= 15;
	INS2_M590::POSITION         		= 16;
	INS2_COACH::POSITION        		= 17;
	INS2_M1014::POSITION        		= 18;
	//INS2_SAIGA12::POSITION      		= 19;
	//INS2_G36C::POSITION         		= 20;*
	//Fifth slot 	(slot 4)    		- Explosives & Launchers
	INS2_M24GRENADE::POSITION   		= 9;
	INS2_MK2GRENADE::POSITION   		= 10;
	INS2_M79::POSITION          		= 11;
	INS2_PZFAUST::POSITION      		= 12;
	INS2_LAW::POSITION          		= 13;
	INS2_AT4::POSITION          		= 14;
	INS2_RPG7::POSITION         		= 15;
	INS2_PZSCHRECK::POSITION    		= 16;
	//INS2_M2FLAMETHROWER::POSITION		= 17;
	//INS2_ANM14INC::POSITION   		= 18;
	//INS2_BINOCULARS::POSITION 		= 19;
	//Sixth slot 	(slot 5)    		- Assault Rifles
	INS2_ASVAL::POSITION        		= 9;
	//INS2_STG44::POSITION        		= 10;
	//INS2_F2000::POSITION        		= 11;
	INS2_AK12::POSITION         		= 12;
	INS2_AK74::POSITION         		= 13;
	INS2_GALIL::POSITION        		= 14;
	INS2_M16A4::POSITION        		= 15;
	INS2_L85A2::POSITION        		= 16;
	INS2_AKM::POSITION          		= 17;
	//INS2_M16A1::POSITION      		= 18;
	//INS2_AUG::POSITION        		= 19;
	//Seventh slot 	(slot 6)    		- Rifles & Battle Rifles
	//INS2_K98K::POSITION         		= 9;
	INS2_M1GARAND::POSITION     		= 10;
	//INS2_SVT40::POSITION        		= 11;
	INS2_ENFIELD::POSITION      		= 12;
	INS2_FNFAL::POSITION        		= 13;
	INS2_G3A3::POSITION         		= 14;
	//INS2_SG751::POSITION        		= 15;
	INS2_M14EBR::POSITION       		= 16;
	//INS2_SCARH::POSITION        		= 17;
	//INS2_FG42::POSITION         		= 18;
	//INS2_BAR::POSITION          		= 19;
	//Eight slot 	(slot 7)    		- LMGs & Sniper Rifles
	//INS2_M40A1::POSITION        		= 9;
	//INS2_MOSIN::POSITION        		= 10;
	INS2_G43::POSITION          		= 11;
	//INS2_SVD::POSITION          		= 12;
	//INS2_LEWIS::POSITION        		= 13;
	INS2_RPK::POSITION          		= 14;
	INS2_M60::POSITION          		= 15;
	INS2_M249::POSITION         		= 16;
	INS2_MG42::POSITION         		= 17;
	//INS2_BREN::POSITION       		= 18;
	//INS2_M21::POSITION        		= 19;
	//INS2_SVT40::POSITION      		= 20;*
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
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Makarov PM", INS2_MAKAROV::GetName(), 80, "secondary", "pistol" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Makarov 9x18mm Ammo", INS2_MAKAROV::GetAmmoName(), 10, "ammo", "pistol" ) );
		//M1911
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt M1911A1", INS2_M1911::GetName(), 100, "secondary", "pistol" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1911A1 .45ACP Ammo", INS2_M1911::GetAmmoName(), 10, "ammo", "pistol" ) );
		//Beretta
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Beretta M92F", INS2_M9BERETTA::GetName(), 115, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Beretta 9x19mm Ammo", INS2_M9BERETTA::GetAmmoName(), 15, "ammo", "pistol" ) );
		//USP Match
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K USP Match", INS2_USP::GetName(), 130, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "USP .45ACP Ammo", INS2_USP::GetAmmoName(), 10, "ammo", "pistol" ) );
		//Glock 17
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Glock 17", INS2_GLOCK17::GetName(), 140, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Glock 17 9x19mm Ammo", INS2_GLOCK17::GetAmmoName(), 20, "ammo", "pistol" ) );
		//C96
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mauser C96", INS2_C96::GetName(), 175, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 7.63x25mm Ammo", INS2_C96::GetAmmoName(), 15, "ammo", "pistol" ) );
		//Desert Eagle
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "IMI Desert Eagle", INS2_DEAGLE::GetName(), 200, "secondary", "pistol" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Desert Eagle .50AE Ammo", INS2_DEAGLE::GetAmmoName(), 20, "ammo", "pistol" ) );

	//Revolvers
		//Webley
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Webley Mk.VI", INS2_WEBLEY::GetName(), 170, "secondary", "revolver" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Webley .455 Ammo", INS2_WEBLEY::GetAmmoName(), 10, "ammo", "revolver" ) );
		//Colt Python
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt Python", INS2_PYTHON::GetName(), 185, "secondary", "revolver" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Python .357 Magnum Ammo", INS2_PYTHON::GetAmmoName(), 15, "ammo", "revolver" ) );
		//Model M29
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "S&W Model 29", INS2_M29::GetName(), 200, "secondary", "revolver" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Model 29 .44 Magnum Ammo", INS2_M29::GetAmmoName(), 20, "ammo", "revolver" ) );

	//Assault Rifles & Battle Rifles
		//AS VAL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AS VAL", INS2_ASVAL::GetName(), 245, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AS VAL 9x39mm Ammo", INS2_ASVAL::GetAmmoName(), 20, "ammo", "assault" ) );
		//StG-44
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "StG-44", INS2_STG44::GetName(), 260, "primary", "assault" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "StG-44 7.92x33mm Ammo", INS2_STG44::GetAmmoName(), 30, "ammo", "assault" ) );
		//F2000
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN F2000", INS2_F2000::GetName(), 270, "primary", "assault" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "F2000 5.56x45mm Ammo", INS2_F2000::GetAmmoName(), 30, "ammo", "assault" ) );
		//AK-12
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AK-12", INS2_AK12::GetName(), 280, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AK-12 5.45x39mm Ammo", INS2_AK12::GetAmmoName(), 30, "ammo", "assault" ) );
		//AK-74
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74 + Foregrip", INS2_AK74::GetName(), 290, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74 5.45x39mm Ammo", INS2_AK74::GetAmmoName(), 30, "ammo", "assault" ) );
		//GALIL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "IMI GALIL ARM + Bipod", INS2_GALIL::GetName(), 300, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "GALIL 5.56x45mm Ammo", INS2_GALIL::GetAmmoName(), 35, "ammo", "assault" ) );
		//M16A4
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A4 + M203", INS2_M16A4::GetName(), 310, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M16A4 5.56x45mm Ammo", INS2_M16A4::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M203 40mm grenade Ammo", INS2_M16A4::GetGLName(), 30, "ammo", "launcher" ) );
		//L85A2
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "L85A2 + AG-36", INS2_L85A2::GetName(), 320, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "L85A2 5.56x45mm Ammo", INS2_L85A2::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AG-36 40mm grenade Ammo", INS2_L85A2::GetGLName(), 30, "ammo", "launcher" ) );
		//AKM
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKM + GP-25", INS2_AKM::GetName(), 330, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKM 7.62x39mm Ammo", INS2_AKM::GetAmmoName(), 30, "ammo", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "GP-25 40mm grenade Ammo", INS2_AKM::GetGLName(), 30, "ammo", "launcher" ) );
		//FN FAL
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN FAL", INS2_FNFAL::GetName(), 310, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN FAL 7.62x51mm Ammo", INS2_FNFAL::GetAmmoName(), 20, "ammo", "assault" ) );
		//G3A3
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K G3A3", INS2_G3A3::GetName(), 315, "primary", "assault" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "G3A3 7.62x51mm Ammo", INS2_G3A3::GetAmmoName(), 20, "ammo", "assault" ) );
		//FG-42
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FG-42 + Bipod", INS2_FG42::GetName(), 330, "primary", "assault" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FG-42 7.92x57mm Ammo", INS2_FG42::GetAmmoName(), 40, "ammo", "assault" ) );

	//Rifles & Sniper Rifles
		//Kar98K
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Karabiner 98K + Schiessbecher", INS2_K98K::GetName(), 220, "primary", "rifle" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Karabiner 98K 7.92x57mm Ammo", INS2_K98K::GetAmmoName(), 10, "ammo", "rifle" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Schiessbecher Ammo", INS2_K98K::GetGLName(), 30, "ammo", "launcher" ) );
		//Garand
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1 Garand + Bayonet", INS2_M1GARAND::GetName(), 235, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1 Garand 7.62x63mm Ammo", INS2_M1GARAND::GetAmmoName(), 15, "ammo", "rifle" ) );
		//Enfield
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lee-Enfield No.IV Mk.I", INS2_ENFIELD::GetName(), 250, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lee-Enfield .303 Ammo", INS2_ENFIELD::GetAmmoName(), 20, "ammo", "rifle" ) );
		//M14 EBR
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M14 EBR Red Dot Sight", INS2_M14EBR::GetName(), 320, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M14 EBR 7.62x51mm Ammo", INS2_M14EBR::GetAmmoName(), 30, "ammo", "rifle" ) );
		//M40A1
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M40A1 Unertl Scope", INS2_M40A1::GetName(), 305, "primary", "rifle" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M40A1 7.62x51mm Ammo", INS2_M40A1::GetAmmoName(), 15, "ammo", "rifle" ) );
		//Mosin Nagant
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mosin Nagant M91/30 PU Scope", INS2_MOSIN::GetName(), 320, "primary", "rifle" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mosin Nagant 7.62x54mm Ammo", INS2_MOSIN::GetAmmoName(), 15, "ammo", "rifle" ) );
		//G43
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Gewehr 43 ZF4 Scope", INS2_G43::GetName(), 335, "primary", "rifle" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Gewehr 43 7.92x57mm Ammo", INS2_G43::GetAmmoName(), 20, "ammo", "rifle" ) );
		//Dragunov
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SVD Dragunov PSO-1 Scope", INS2_SVD::GetName(), 345, "primary", "rifle" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SVD Dragunov 7.62x54mm Ammo", INS2_SVD::GetAmmoName(), 30, "ammo", "rifle" ) );

	//Shotguns
		//Ithaca M37
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Ithaca M37", INS2_ITHACA::GetName(), 260, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Ithaca M37 12 Gauge Ammo", INS2_ITHACA::GetAmmoName(), 40, "ammo", "shotgun" ) );
		//M590
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mossberg M590", INS2_M590::GetName(), 275, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M590 12 Gauge Ammo", INS2_M590::GetAmmoName(), 50, "ammo", "shotgun" ) );
		//Coach Gun
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Coach Gun", INS2_COACH::GetName(), 290, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Coach Gun Buckshot Ammo", INS2_COACH::GetAmmoName(), 20, "ammo", "shotgun" ) );
		//M1014
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Benelli M1014", INS2_M1014::GetName(), 325, "primary", "shotgun" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1014 12 Gauge Ammo", INS2_M1014::GetAmmoName(), 45, "ammo", "shotgun" ) );
		//Saiga 12
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Saiga 12K", INS2_SAIGA12::GetName(), 600, "primary", "shotgun" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Saiga 12K Gauge Ammo", INS2_SAIGA12::GetAmmoName(), 80, "ammo", "shotgun" ) );

	//Submachine Guns
		//UMP45
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K UMP-45", INS2_UMP45::GetName(), 155, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "UMP-45 .45ACP Ammo", INS2_UMP45::GetAmmoName(), 20, "ammo", "smg" ) );
		//MP5K
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K MP5K", INS2_MP5K::GetName(), 165, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP5K 9x19mm Ammo", INS2_MP5K::GetAmmoName(), 20, "ammo", "smg" ) );
		//MP-18
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Bergmann MP-18,I", INS2_MP18::GetName(), 170, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-18 9x19mm Ammo", INS2_MP18::GetAmmoName(), 25, "ammo", "smg" ) );
		//MP40
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-40", INS2_MP40::GetName(), 175, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP-40 9x19mm Ammo", INS2_MP40::GetAmmoName(), 25, "ammo", "smg" ) );
		//Sterling L2A3
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Sterling L2A3", INS2_STERLING::GetName(), 185, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Sterling 9x19mm Ammo", INS2_STERLING::GetAmmoName(), 30, "ammo", "smg" ) );
		//PPSh41
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PPSh-41", INS2_PPSH41::GetName(), 195, "primary", "smg" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "PPSh-41 7.62x25mm Ammo", INS2_PPSH41::GetAmmoName(), 50, "ammo", "smg" ) );
		//Thompson M1928
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Thompson M1928", INS2_M1928::GetName(), 200, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Thompson M1928 .45ACP Ammo", INS2_M1928::GetAmmoName(), 50, "ammo", "smg" ) );
		//MP7
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "H&K MP7", INS2_MP7::GetName(), 210, "primary", "smg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MP7 4.6x30mm Ammo", INS2_MP7::GetAmmoName(), 30, "ammo", "smg" ) );

	//Carbines
		//C96 M1932 Schnellfeuer
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 M1932 Schnellfeuer", INS2_C96CARBINE::GetName(), 215, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "C96 M1932 7.63x25mm Ammo", INS2_C96CARBINE::GetAmmoName(), 30, "ammo", "carbine" ) );
		//MK. 18
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk. 18", INS2_MK18::GetName(), 225, "primary", "carbine" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk.18 5.56x45mm Ammo", INS2_MK18::GetAmmoName(), 30, "ammo", "carbine" ) );
		//AKS-74U
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74U", INS2_AKS74U::GetName(), 235, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "AKS-74U 5.45x39mm Ammo", INS2_AKS74U::GetAmmoName(), 30, "ammo", "carbine" ) );
		//M4A1
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Colt M4A1", INS2_M4A1::GetName(), 245, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M4A1 5.56x45mm Ammo", INS2_M4A1::GetAmmoName(), 30, "ammo", "carbine" ) );
		//M1A1 Paratrooper
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1A1 Paratrooper", INS2_M1A1PARA::GetName(), 260, "primary", "carbine" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M1A1 Paratrooper 7.62x33mm Ammo", INS2_M1A1PARA::GetAmmoName(), 20, "ammo", "carbine" ) );
		//SKS
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SKS Simonov", INS2_SKS::GetName(), 275, "primary", "carbine" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "SKS 7.62x39mm Ammo", INS2_SKS::GetAmmoName(), 25, "ammo", "carbine" ) );

	//Launchers & Explosives
		//M79
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 Grenade Launcher", INS2_M79::GetName(), 375, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 40mm grenade Ammo", INS2_M79::GetAmmoName(), 30, "ammo", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M79 40mm buckshot Ammo", INS2_M79::GetGLName(), 25, "ammo", "launcher" ) );
		//Panzerfaust
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerfaust 60M", INS2_PZFAUST::GetName(), 425, "primary", "launcher" ) );
		//M72 LAW
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M72 LAW", INS2_LAW::GetName(), 450, "primary", "launcher" ) );
		//AT4
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M136 AT4", INS2_AT4::GetName(), 500, "primary", "launcher" ) );
		//RPG7
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPG-7", INS2_RPG7::GetName(), 700, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPG-7 Rocket Ammo", INS2_RPG7::GetAmmoName(), 100, "ammo", "launcher" ) );
		//Panzerschreck
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerschreck", INS2_PZSCHRECK::GetName(), 750, "primary", "launcher" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Panzerschreck Rocket Ammo", INS2_PZSCHRECK::GetAmmoName(), 125, "ammo", "launcher" ) );
		//M2 Flamethrower
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M2 Flamethrower", INS2_M2FLAMETHROWER::GetName(), 750, "primary", "launcher" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M2 Napalm Ammo", INS2_M2FLAMETHROWER::GetAmmoName(), 60, "ammo", "launcher" ) );

	//Light Machine Guns
		//Lewis
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lewis Model 1915 MK.I + Bipod", INS2_LEWIS::GetName(), 345, "primary", "lmg" ) );
	//g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Lewis .303 Ammo", INS2_LEWIS::GetAmmoName(), 55, "ammo", "lmg" ) );
		//RPK
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPK + Bipod", INS2_RPK::GetName(), 400, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "RPK 7.62x39mm Ammo", INS2_RPK::GetAmmoName(), 75, "ammo", "lmg" ) );
		//M60
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M60 + Bipod", INS2_M60::GetName(), 475, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M60 7.62x51mm Ammo", INS2_M60::GetAmmoName(), 100, "ammo", "lmg" ) );
		//M249
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "FN M249 + Bipod", INS2_M249::GetName(), 575, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "M249 5.56x45mm AP Ammo", INS2_M249::GetAmmoName(), 150, "ammo", "lmg" ) );
		//MG-42
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-42 + Bipod", INS2_MG42::GetName(), 900, "primary", "lmg" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "MG-42 7.92x57mm Ammo", INS2_MG42::GetAmmoName(), 200, "ammo", "lmg" ) );

	//Equipment
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Stielhandgranate M24", INS2_M24GRENADE::GetName(), 45, "equipment", "" ) );
	g_Ins2Menu.AddItem( BuyMenu::BuyableItem( "Mk. 2 \"Pineapple\" Grenade", INS2_MK2GRENADE::GetName(), 50, "equipment", "" ) );

	BuyMenu::MoneyInit();
}