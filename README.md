# Insurgency Weapons Project
![](https://i.imgur.com/u0h7FjO.png)
> Custom weapons project for Sven Co-op

This project is brought to you by the following super dedicated team members: Norman The Loli Pirate, D.N.I.O. 071, R4to0, D.G.F. and me (KernCore). This project started in mid November of 2017 and the first part of it was released on the Sven Co-op Forums (2020/01/19), with more content to come in the future.

## The Weapons

* AK-12 (weapon_ins2ak12)
* AK-74M (weapon_ins2ak74)
* AKM + GP-25 (weapon_ins2akm)
* AKS-74u (weapon_ins2aks74u)
* AS VAL (weapon_ins2asval)
* Benelli M1014 (weapon_ins2m1014)
* Beretta M9 (weapon_ins2beretta)
* Brass knuckles (weapon_ins2knuckles)
* C96 Carbine (weapon_ins2c96carb)
* C96 Pistol (weapon_ins2c96)
* Coach gun (IZH-43) (weapon_ins2coach)
* Colt M1911 (weapon_ins2m1911)
* Colt Python (weapon_ins2python)
* Desert Eagle (weapon_ins2deagle)
* Dragunov SVD (weapon_ins2dragunov)
* FG-42 (weapon_ins2fg42)
* FN F2000 (weapon_ins2f2000)
* FN FAL (weapon_ins2fnfal)
* FN M249 (weapon_ins2m249)
* Galil ARM (weapon_ins2galil)
* Gewehr 43 (weapon_ins2g43)
* Glock 17 (weapon_ins2glock17)
* H&K G3A3 (weapon_ins2g3a3)
* H&K MP5k (weapon_ins2mp5k)
* H&K MP7 (weapon_ins2mp7)
* H&K UMP-45 (weapon_ins2ump45)
* H&K USP (weapon_ins2usp)
* Ithaca M37 (weapon_ins2ithaca)
* KA-BAR (weapon_ins2kabar)
* Kukri (weapon_ins2kukri)
* L85A2 + L123A2 (weapon_ins2l85a2)
* Lee-Enfield No.IV Mk.I (weapon_ins2enfield)
* Lewis Model 1915 MK.I (weapon_ins2lewis)
* M1 Garand (weapon_ins2garand)
* M136 AT4 (weapon_ins2at4)
* M14 EBR (weapon_ins2m14ebr)
* M16A4 + M203 (weapon_ins2m16a4)
* M24 Stielhandgranate (weapon_ins2stick)
* M4A1 (weapon_ins2m4a1)
* M60 (weapon_ins2m60)
* M72 LAW (weapon_ins2law)
* M79 (weapon_ins2m79)
* Makarov PM (weapon_ins2makarov)
* MG-42 (weapon_ins2mg42)
* MK. 18 MOD 1 (weapon_ins2mk18)
* MK2 Grenade (weapon_ins2mk2)
* Mosin Nagant M91/30 (weapon_ins2mosin)
* Mossberg 590 (weapon_ins2m590)
* MP-18 (weapon_ins2mp18)
* MP-40 (weapon_ins2mp40)
* Panzerfaust (weapon_ins2pzfaust)
* Panzerschreck (weapon_ins2pzschreck)
* PPSh-41 (weapon_ins2ppsh41)
* RPG-7 (weapon_ins2rpg7)
* RPK (weapon_ins2rpk)
* Saiga 12k (weapon_ins2saiga12)
* SKS-D (weapon_ins2sks)
* Smith & Wesson Model 29 (weapon_ins2m29)
* Sterling L2A3 (weapon_ins2l2a3)
* StG-44 (weapon_ins2stg44)
* Thompson M1928 (weapon_ins2m1928)
* Webley Mk.VI (weapon_ins2webley)

## Gameplay Video

Video:
[![](http://i3.ytimg.com/vi/LyThjfNqwWs/maxresdefault.jpg)](https://www.youtube.com/watch?v=LyThjfNqwWs)
*by SV BOY.*

Video:
[![](http://i3.ytimg.com/vi/tMmC0-DIgCQ/maxresdefault.jpg)](https://www.youtube.com/watch?v=tMmC0-DIgCQ)
*by AlphaLeader772.*

## Screenshots
[![](https://i.imgur.com/XRJbALTm.png)](https://i.imgur.com/XRJbALT.png)
[![](https://i.imgur.com/fogrWZEm.png)](https://i.imgur.com/fogrWZE.png)
[![](https://i.imgur.com/Rwn01Vfm.png)](https://i.imgur.com/Rwn01Vf.png)
[![](https://i.imgur.com/84E0GqLm.png)](https://i.imgur.com/84E0GqL.png)
[![](https://i.imgur.com/yszXhUnm.png)](https://i.imgur.com/yszXhUn.png)
[![](https://i.imgur.com/gYkANMzm.png)](https://i.imgur.com/gYkANMz.png)

## Installation Guide

1. Registering the weapons as plugins (Good for server operators, and most people):
	1. Download the pack from one of the download links below
	2. Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	3. Open up *`default_plugins.txt`* located in **`Steam\steamapps\common\Sven Co-op\svencoop\`**
	4. Add these lines to the file:
	```
	"plugin"
	{
		"name"          "Insurgency Mod"
		"script"        "../maps/ins2/ins2_register"
		"concommandns"     "ins2"
	}
	```
	5. Load any map of your preference;
	6. Type in chat *\buy* or type in console give *name of the weapon* and enjoy.

2. Registering the weapons as map_scripts (Good for map makers):
	1. Download the pack from one of the download links below
	2. Extract it's contents inside **`Steam\steamapps\common\Sven Co-op\svencoop_addon\`**
	3. Open up any map *.cfg* (i.e: **svencoop1.cfg**) and add this line to it:
	```
	map_script ins2/ins2_register
	```
	4. Load up the map you chose;
	5. Type in chat *\buy* or type in console give *name of the weapon* and enjoy.

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

### Update 1.4:
* Added the Lewis Model 1915 MK.I
* Added the MK. 18 Mod 1
* Applied minor tweaks to the AK-74 and AKS-74u viewmodel reload animations
* Applied minor tweaks to the Galil viewmodel reload_empty and draw_first animations
* Changed main 1024x1024 sprite to support the updated MK. 18 model
* Fixed issue that prevented disposable launchers from being dropped once the player respawned
* Tweaked AKM viewmodel's animations slightly
* Tweaked SKS viewmodel's animations slightly
* Fix player's speed not being affected when using bipods
* Model `mags.mdl` has been modified to support low poly versions of the Lewis and MK. 18

### Update 1.3:
* Added the FN F2000
* Added the Makarov PM
* Added the Saiga 12k
* Added the FG-42
* Added the Mosin Nagant
* Added the PPSh-41
* Added the STG-44
* Added the Colt Python
* Added the Dragunov SVD
* Added the Colt M1911
* Added the Smith & Wesson Model 29
* Added a map script for the following series: Restriction
* Added Python's and Saiga's ammo model as a "mags.mdl" bodygroup (Changing already existing models require server restart if it's on)
* Added SPEED variable for GLs in ARs
* Changed the 9x18mm bullet model
* Changed the 7.62x54mm bullet model
* Changed the 7.62x25mm Tokarev bullet model
* Changed the 7.92x33mm Kurz bullet model
* Disposable Launchers start with more ammo now
* Fixed AK-12 viewmodel's receiver texture and UV map, updated world models
* Fixed two instances where you could cook the grenades and give them to other players to explode them
* Fixed an instance where you could hold an already cooked grenade indefinitely
* Changed Makarov folder from makarov to pm
* Changed Saiga folder from saiga12 to saiga
* Modified sounds from the already existing folders of the F2000, Mosin Nagant and M1911
* Removed hit.ogg and magrel.ogg sounds from the M1911
* Tweaked Kukri viewmodel's animations slightly

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

Total Size Compressed: 82.02 MB

(.7z) [Dropbox](https://www.dropbox.com/s/ucyz0ntw3w8yaw3/Insurgency%20First%20Release1_4.7z?dl=0)  
(.7z) [HLDM-BR.NET](https://cdn.hldm-br.net/files/sc/ins2/Insurgency%20First%20Release1_4.7z)  
(.7z) [Mega](https://mega.nz/file/qld2hJ4T#DmksAjNCVbsUt59oGy-5QOgIlsCYwBNGgQsjDraNcCA)  
(.7z) [Boderman.net](http://boderman.net/svencoop/Insurgency_First_Release1_4.7z)  
(.7z) [GitHub](https://github.com/KernCore91/-SC-Insurgency-Weapons-Project/releases/download/v1.4/Insurgency.First.Release1_4.7z)
