# Insurgency Weapons Project
> Custom weapons project for Sven Co-op

This project is brought to you by the following super dedicated team members: Norman The Loli Pirate, D.N.I.O. 071, R4to0, D.G.F. and me (KernCore). This project started in mid November of 2017 and the first part of it was released on the Sven Co-op Forums (2020/01/19), with more content to come in the future.

## The Weapons

* AK-12 (weapon_ins2ak12)
* AK-74M (weapon_ins2ak74)
* AKM + GP-25 (weapon_ins2akm)
* AKS-74u (weapon_ins2aks74u)
* AS VAL (weapon_ins2asval)
* Benelli M1014 (weapon_ins2m1014)
* Beretta (weapon_ins2beretta)
* Brass knuckles (weapon_ins2knuckles)
* C96 Carbine (weapon_ins2c96carb)
* C96 Pistol (weapon_ins2c96)
* Coach gun (IZH-43) (weapon_ins2coach)
* Desert Eagle (weapon_ins2deagle)
* FN FAL (weapon_ins2fnfal)
* FN M249 (weapon_ins2m249)
* Galil (weapon_ins2galil)
* Gewehr 43 (weapon_ins2g43)
* Glock 17 (weapon_ins2glock17)
* H&K G3A3 (weapon_ins2g3a3)
* H&K MP5k (weapon_ins2mp5k)
* H&K MP7 (weapon_ins2mp7)
* H&K UMP-45 (weapon_ins2ump45)
* H&K USP (weapon_ins2usp)
* Ithaca 37 (weapon_ins2ithaca)
* KA-BAR (weapon_ins2kabar)
* Kukri (weapon_ins2kukri)
* L85A2 + L123A2 (weapon_ins2l85a2)
* Lee-Enfield No.IV Mk.I (weapon_ins2enfield)
* M1 Garand (weapon_ins2garand)
* M136 AT4 (weapon_ins2at4)
* M14 EBR (weapon_ins2m14ebr)
* M16A4 + M203 (weapon_ins2m16a4)
* M24 Stielhandgranate (weapon_ins2stick)
* M4A1 (weapon_ins2m4a1)
* M60 (weapon_ins2m60)
* M72 LAW (weapon_ins2law)
* M79 (weapon_ins2m79)
* MG-42 (weapon_ins2mg42)
* MK2 Grenade (weapon_ins2mk2)
* Mossberg 590 (weapon_ins2m590)
* MP-18 (weapon_ins2mp18)
* MP-40 (weapon_ins2mp40)
* Panzerfaust (weapon_ins2pzfaust)
* Panzerschreck (weapon_ins2pzschreck)
* RPG-7 (weapon_ins2rpg7)
* RPK (weapon_ins2rpk)
* SKS-D (weapon_ins2sks)
* Sterling L2A3 (weapon_ins2l2a3)
* Thompson M1928 (weapon_ins2m1928)
* Webley (weapon_ins2webley)

## Gameplay Video

Video:
[![](https://i.ytimg.com/vi/-zNmB1rg458/maxresdefault.jpg)](https://www.youtube.com/watch?v=-zNmB1rg458)
###### by SV BOY.

## Screenshots
[![](https://i.imgur.com/XRJbALTm.png)](https://i.imgur.com/XRJbALT.png)
[![](https://i.imgur.com/fogrWZEm.png)](https://i.imgur.com/fogrWZE.png)
[![](https://i.imgur.com/Rwn01Vfm.png)](https://i.imgur.com/Rwn01Vf.png)
[![](https://i.imgur.com/84E0GqLm.png)](https://i.imgur.com/84E0GqL.png)
[![](https://i.imgur.com/yszXhUnm.png)](https://i.imgur.com/yszXhUn.png)
[![](https://i.imgur.com/gYkANMzm.png)](https://i.imgur.com/gYkANMz.png)

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

## Additional Content

This pack includes a heavily modified Buymenu made specifically for it.
Here are the following commands that can be used in the Buymenu:

```
// Opening the Buy menu in the chat:
buy
/buy
!buy
.buy
\buy
#buy

// Opening the Buy menu in the console:
.buy

// Buying a specific weapon/ammo (without the weapon_ins2 prefix) without the menu:
<menu opening command here> <entity identifier here> <weapon name here> ie:
!buy w l2a3 (will directly buy a Sterling for you) or 
/buy a l2a3 (will directly buy ammo for the Sterling for you)

// Buying ammo for the current equipped weapon:
<menu opening command here> ammo ie:
!buy ammo or
/buy ammo
```

Server commands (in case you registered the weapons as a plugin):
```
as_command ins2.bm_maxmoney <value>
as_command ins2.bm_moneyperscore <value>
as_command ins2.bm_startmoney <value>
```

It also includes specific replacement map scripts, which when added to the maps supported, will allow you to replace the default weapons and ammo that are spawned by the map with the Insurgency Weapons included in this release.
The maps that currently support this optional feature are: auspices, sc_toysoldiers, sc_egypt2, sc_persia and suspension.

If you want to know how to add these scripts, take a look at their scripts in the folder: **scripts/maps/ins2/maps** and add their specific map_script command in there.

## Notes

This pack will not include a *.res* file or a *.fgd* file until we are fully finished with it.

This pack also includes a test map called: *sc_insurgency*. Use it to try the new weapons out.

Some weapons include a mode to change the firerate on them, you'll notice a sprite appear on your screen telling you the weapon's fire mode (Semi auto, Burst Fire, Full Auto), use ***E + R*** (or whatever key your *+use* and *+reload* is bound to) to change them;

Some other weapons also include Tertiary Attack functions (Like deploying the bipod, or changing to the GL mode).
To use these modes simply press the Mouse3 button (or whatever key you bound *+alt1*).

Many models feature textures above 512x512 resolution, including the weapon sprites, so gl_max_size 1024 is required to see the weapon textures without loss of quality.

Usage of this pack without more than 2 GB RAM, outside of servers, is likely to crash you.

## Credits

You are authorized to use any assets in this pack as you see fit, as long as you credit us and whoever contributed to the making of this pack.
There's a very long list of people/teams in the file: *ins2_credits.txt*, this file specifies the authors of every single asset that is being used in the making of this project.

### You are authorized to use any assets in this pack as you see fit, as long as:
* The content you're making doesn't break any of the EULAs listed below:
	* [Insurgency/Day of Infamy EULA](https://store.steampowered.com/eula/447820_eula_0) 
	* [Insurgency: Sandstorm's EULA](https://store.steampowered.com/eula/581320_eula_0)
* You credit anyone who contributed assets for this pack;
* You do not earn money from any of New World Interactive assets, Focus Home Interactive or this mod's assets.

### You are not permitted to:

* Re-pack it without the project author's consent;
* Use any assets included in this project without crediting who made them;
* Earn money from this pack or any other assets used;
* Upload it somewhere else without credits.

## Updates

### Update 1.2:
* Added the AS VAL
* Added the M14 EBR
* Added the MP7
* Added the Galil
* Added the MG-42
* Added the Thompson M1928
* Added the AK-12
* Added map scripts for the following maps: sc_persia, suspension
* Added support for WEAPON_NOCLIP
* Changed the 4.6x30mm bullet model
* Changed the 7.92x57mm bullet model
* Fixed minor reload issue with staged reload weapons
* Increased damage output on several weapons
* Updated G43 models
* Updated FN FAL viewmodel
* Updated all weapon scripts to offer better support for default ammo
* Updated Credits file
* Viewmodels recompiled to preserve arm bones
* Very minor update for the test map: fixed position of some items

### Update 1.1:
* Fixed guide rod on the Beretta M9
* Fixed a sound not being precached in the M79
* Added the Sterling L2A3

## Download Links

Total Size Compressed: 67.66 MB

(.7z) [Dropbox](https://www.dropbox.com/s/pffedw6m3yt7099/Insurgency%20First%20Release1_2.7z?dl=0)

(.7z) [HLDM-BR.NET](https://cdn.hldm-br.net/files/sc/ins2/Insurgency%20First%20Release1_2.7z)

(.7z) [Mega](https://mega.nz/#!W81lQaoR!E_BtJoJWXm9sfwL4O1uQja6impghi7DP-n5JOy-vEsE)

(.7z) [Boderman.net](http://www.boderman.net/svencoop/Insurgency_First_Release1_2.7z)