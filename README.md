# Insurgency Weapons Project
> Custom weapons project for Sven Co-op
This project is brought to you by the following super dedicated team members: Norman The Loli Pirate, D.N.I.O. 071, R4to0, D.G.F. and me (KernCore). This project started in mid November of 2017 and the first part of it is being released today (2020/01/19), with more content to come in the future.

## The Weapons

* AK-74M (weapon_ins2ak74)
* AKM + GP-25 (weapon_ins2akm)
* AKS-74u (weapon_ins2aks74u)
* Benelli M1014 (weapon_ins2m1014)
* Beretta (weapon_ins2beretta)
* Brass knuckles (weapon_ins2knuckles)
* C96 Pistol (weapon_ins2c96)
* C96 Carbine (weapon_ins2c96carb)
* Coach gun (IZH-43) (weapon_ins2coach)
* Desert Eagle (weapon_ins2deagle)
* FN FAL (weapon_ins2fnfal)
* FN M249 (weapon_ins2m249)
* Gewehr 43 (weapon_ins2g43)
* Glock 17 (weapon_ins2glock17)
* H&K G3A3 (weapon_ins2g3a3)
* Ithaca 37 (weapon_ins2ithaca)
* KA-BAR (weapon_ins2kabar)
* Kukri (weapon_ins2kukri)
* L85A2 + L123A2 (weapon_ins2l85a2)
* Lee-Enfield No.IV Mk.I (weapon_ins2enfield)
* M1 Garand (weapon_ins2garand)
* M136 AT4 (weapon_ins2at4)
* M16A4 + M203 (weapon_ins2m16a4)
* M24 Stielhandgranate (weapon_ins2stick)
* M4A1 (weapon_ins2m4a1)
* Mossberg 590 (weapon_ins2m590)
* M60 (weapon_ins2m60)
* M72 LAW (weapon_ins2law)
* M79 (weapon_ins2m79)
* MK2 Grenade (weapon_ins2mk2)
* MP-18 (weapon_ins2mp18)
* MP-40 (weapon_ins2mp40)
* MP5k (weapon_ins2mp5k)
* Panzerfaust (weapon_ins2pzfaust)
* Panzerschreck (weapon_ins2pzschreck)
* RPG-7 (weapon_ins2rpg7)
* RPK (weapon_ins2rpk)
* SKS-D (weapon_ins2sks)
* UMP-45 (weapon_ins2ump45)
* USP (weapon_ins2usp)
* Webley (weapon_ins2webley)
* Sterling L2A3 (weapon_ins2l2a3)
* AS VAL (weapon_ins2asval)
* M14 EBR (weapon_ins2m14ebr)
* H&K MP7 (weapon_ins2mp7)
* Galil (weapon_ins2galil)
* MG-42 (weapon_ins2mg42)
* Thompson M1928 (weapon_ins2m1928)
* AK-12 (weapon_ins2ak12)

## Installation Guide

* Registering the weapons as plugins (Good for server operators, and most people):
	* Download the pack from one of the download links below
	* Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	* Open up *`default_plugins.txt`* located in **`Steam\steamapps\common\Sven Co-op\svencoop\`**
	* Add these lines to the file:
	```
	"plugin"
	{
		"name"          "Insurgency Mod"
		"script"        "../maps/ins2/ins2_register"
		"concommandns"     "ins2"
	}
	```
	* Load any map of your preference;
	* Type in chat *\buy* or type in console give *name of the weapon* and enjoy.

* Registering the weapons as map_scripts (Good for map makers):
	* Download the pack from one of the download links below
	* Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	* Open up any map *.cfg* (i.e: **svencoop1.cfg**) and add this line to it:
	```
	map_script ins2/ins2_register
	```
	* Load up the map you chose;
	* Type in chat *\buy* or type in console give *name of the weapon* and enjoy.