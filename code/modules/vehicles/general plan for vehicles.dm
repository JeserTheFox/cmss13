/*
Here are my notes/plans for overall vehicle direction in case I, well, will become unavailable for whatever reason.


//-----------------------------------------------------------------
Vehicle Updates Project

I. Movement and Trampling. FINISHED
1. Simplify movement momentum code. Needs less complexity and easier way to adjust speed.
	*DONE
2. Rework trampling to be an atom's proc instead of huge ass if else structure. Will allow unique behaviour for trampling objects without big calculations.
	*DONE
3. Rework effects on ramming xenos. APC deals less damage, balance damage from tank, remove defenders blocking vehicles, that's retarded and can't be balanced.
	*DONE

II. Interiors update
1. Rework entering/exiting
	*DONE
2. Add VC-only passenger slots, remove limitations for destroyed vehicles, allowing people get in and drag dead out.
	*DONE
3. Remap APC interiors to be bigger and other interior changes.
	*DONE
4. SL/TL/Queen tracker. (Custom tiles to store it's vehicle.)

III. Weaponry update
1. Rework current horrible system, projectile should start at the center of tank to make it easier to predict projectile pathing and aiming.
	*Mostly done, but big issue:	still need to fix diagonal shooting (shooting diagonally for some reason traps round below tank and hits the tank)
2. Multiple ammo types, 2 ammo types per module minimum.
	*System DONE, ammo itself left
3. "DEFCON 2" tier ammo types for all weaponry as a tier 3 techweb.
	*Obsolete, needs re-thinking

IV. Armor and weight
1. Making armors actually useful. Instead of being narrowly specialized and, therefore, useless, each armor should provide okay protection, but excel in one specific area.
Snowplow is to be repurposed as Snow/mineplow. In lowered state removes weeds, traps, deals increased damage to structures, safely disposes of mines, removes snow, but adds noticeable slowdown.
2. Weight system, each module has weight, tank's class determined by weight and affects stuff like trampling and speed. Build your own tank fitting your style and environment. "Firepower", "Speed", "Health", choose two, basically.

V. Camouflage and Custom Decals
1. Fixed sprites for vehicles.
	*DONE
2. Add camouflages and custom paintjobs, unlocking with playtime.
	*Some camos DONE, need someone to make spraygun's bloody TGUI template

VI. Finishing touches.
1. Get tank out of techweb pithole.
2. Final balance tweaks, based on feedback.


Smaller vehicle stuff:
1. Vehicle interior effects. Improve crush effect, add internal explosion, fire, shrapnel "events" based on damage received by a tank.
2. Vehicle related tips, both for VCs and for marines/ship staff (interior and exterior cams accessible from CIC, exterior view from interior, vehicle controls guide, putting pulled objects and creatures into vehicle on help inten without entering and so on)

*/
