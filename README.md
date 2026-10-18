# NS2 SUD Combat Adjustments (SCA)

Balance changes for the [NS2 Combat](https://steamcommunity.com/sharedfiles/filedetails/?id=2330337167) mod, made for the NS2 Sudamerica community.

Combat, rebalanced to play closer to the semi-competitive game NS2 Sudamerica runs on its public server. That server runs Blast to the Past on top of nu vanilla, so several changes here come from there. This list is only what SCA changes on top of Combat.

**Steam Workshop:** [3572663596](https://steamcommunity.com/sharedfiles/filedetails/?id=3572663596)

## Running it on a server

SCA runs on the server, together with the NS2 Combat mod. Add both to the server's mod list; players download them automatically when they join.

Each ARC writes one line to the server console with the route it takes, for example:

```
[SCA] ARC route: Marine Start > Central > Cart Tunnel > Alien Start (from Cart Tunnel, one of 2 approaches; the only route that way)
```

## Changes

### Aliens

**Traits**
- **No more stacking one hive type.** You can't take a second Crag, Shift or Shade trait until you have one of each, and no third until you have two of each. Stacking Carapace, Regeneration and Vampirism made aliens far too hard to kill. Locked traits show in red in the evolve menu, and hovering one tells you what to take first.
- **Carapace** now emphasizes biomass synergy. As in vanilla, it gives a base amount of armor plus more for every biomass level, and your biomass here is 1 at the start, 5 with Tier 2 and 9 with Tier 3. Skulk +6 / +10 / +14 armor, Onos +70 / +150 / +230. Combat gave the biomass 12 amount from the first point (Skulk +17, Onos +290).
- **Tier health:** each Tier upgrade (Tier 2 and Tier 3 abilities) gives the health of 4 biomass levels: Skulk +12, Gorge +8, Lerk +8, Fade +20, Onos +200 per Tier. In Combat, Tier 3 was worth 5 levels.
- **Focus:** 2 points -> 1, and its bonus is vanilla's +33% (Combat had +34%).
- **Aura** only shows an enemy's health while that enemy is parasited *(originally from CompMod)*.

**Skulk**
- **Leap energy:** 45 -> 55 *(CompMod value)*
- **Vampirism:** each bite gives you 11.3% of your max health as shield, down from 14% *(CompMod value)*
- **Xenocide** removed

**Lerk**
- **Health:** 180 -> 170 *(CompMod value)*
- **Spike damage:** 5 -> 5.5

**Fade**
- **Advanced Swipe:** new Fade-only upgrade: 1 point, needs Tier 3. Swipe damage +8%, from 75 to 81

**Onos**
- **Charge** comes with the Onos, as in vanilla. It used to need Tier 2, which now gives Bone Shield
- **Bone Shield:** 1000 -> 600 hitpoints
- **Stomp** no longer knocks Marines down, it webs them for 5 seconds instead. Damage 40 -> 50 *(CBM's Stomp)*, energy 30 -> 45

### Marines

**Weapons**
- **The Machine Gun is a sidegrade to the Shotgun:** 2 points with no Shotgun needed (was Shotgun + 1 point), and you keep it when you die. You pick one: owning either locks the other
- **Flamethrower and Grenade Launcher** unlock from the Shotgun or the Machine Gun
- **Weapon upgrades:** Shotgun 7.84% -> 10% per level, Flamethrower and Grenade Launcher 7% -> 10%, the same as every other weapon
- **Shotgun falloff** starts at 7.5m (was 5m) and ends at 17.5m (was 15m)
- **Grenade Launcher damage:** 70 -> 74.4 *(vanilla value)*

Why the Machine Gun changed: when Combat was made, it did 12 damage per bullet to lifeforms and was priced as an upgrade over the Shotgun. Vanilla has since nerfed it to 10.5, so it is priced as the Shotgun's equal here.

**Support**
- **Improved Resupply** also gives you Medtech #2: your Medpacks heal 40 at once and 10 over time (was 25 and 25)
- **Welding** gives twice the XP, on teammates and on structures
- **ARC:** health 1000 -> 1500, armor 200 -> 500
- **ARC routes:** each ARC heads for the hive from a different side in turn, by a random route through the map's rooms, so Aliens can't just wait in one corridor. It still deploys on the hive as before
- **ARC spawns:** no longer skipped. Combat sometimes lost an ARC when its spawn spot had no path to the hive, and the next one came a full interval late

### Experience
- **Assists:** anyone who dealt more than 10% of an enemy's health and armor since it was last at full health now shares the kill XP, even if far away or already dead. Before, only the killer and teammates close to the kill shared it
- **Catch-up:** every 5 minutes, anyone below 61% of the average XP is raised to it, as Combat intended. Combat's own check almost never fired

### Spawn protection
- Stays at Combat's 3 seconds for the first 10 minutes of a 25 minute round
- 10 to 15 minutes: 2.4 seconds (-20%)
- 15 to 20 minutes: 1.8 seconds (-40%)
- From 20 minutes on, overtime included: 1.2 seconds (-60%)
- A shorter or longer round moves the steps with it: they come at 40%, 60% and 80% of the round
- Everyone gets a warning 30 seconds before each drop

The longer a round goes, the easier it gets to finish it.

## Working on the mod

The project follows the NS2 Launch Pad layout:

```
mod.settings      Workshop name, description, tags and publish id
preview.jpg       Workshop cover image (512x512)
source/           the mod's files: lua/ and ui/
output/           what Launch Pad publishes; not kept in git
```

There is no compile step. To build `output/` before publishing:

```bash
rm -rf output && mkdir -p output && cp -r source/. output/
```

Each change is its own folder under `source/lua/SCA/`, listed in `source/lua/SCA/FileHooks.lua`. Removing a name from that list switches the change off. "Weapon Tree" and the server side of "Hive Traits" need "Upgrade Rules".

## Credits

**Author:** Bleu

**Developed for:** the NS2 Sudamerica community. Join us at [discord.gg/NS2-Sudamerica](https://discord.gg/NS2-Sudamerica).

Several changes here are ported or adapted from Blast to the Past, ENSL CompMod and the Community Balance Mod.
