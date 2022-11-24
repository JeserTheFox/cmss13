/obj/item/ammo_magazine/hardpoint/ltb
	name = "LTB-95 Cannon Magazine"
	desc = "A primary armament cannon magazine"
	caliber = "95mm" //Making this unique on purpose
	icon_state = "ltb"
	ammo_tag = "LTB"
	default_ammo = /datum/ammo/rocket/ltb
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/ltb

/obj/item/ammo_magazine/hardpoint/ltb/update_icon()
	icon_state = initial(icon_state) + "_[current_rounds]"

/obj/item/ammo_magazine/hardpoint/ltb/empty
	current_rounds = 0

//HE shell, old LTB explosion radius, but very small damage
/obj/item/ammo_magazine/hardpoint/ltb/he
	name = "LTB-95 Cannon HE Magazine"
	desc = "An LTB-95 Cannon magazine with High-Explosive shells. Upon impact the shell explodes. Big area of effect, small damage."
	info = "Good for area suppressing, will stun small-medium size enemies for a brief time, shooting into tight area may amplify effect. Beware of friendly fire!"
	icon_state = "ltb_he"
	ammo_tag = "LTB HE"
	default_ammo = /datum/ammo/rocket/ltb/he

/obj/item/ammo_magazine/hardpoint/ltb/he/empty
	current_rounds = 0

//AP shell, massive damage on direct hit with tiny token explosion to look nice.
/obj/item/ammo_magazine/hardpoint/ltb/ap
	name = "LTB-95 Cannon AP Magazine"
	desc = "An LTB-95 Cannon magazine with Armor-Piercing shells. Smashing directly into target at high speed, it deals massive damage to a single target. Produces tiny explosion in the impact area."
	info = "Requires direct hits only, but deals significant damage. You do NOT want to hit an ally with this one."
	icon_state = "ltb_ap"
	ammo_tag = "LTB AP"
	default_ammo = /datum/ammo/rocket/ltb/ap

/obj/item/ammo_magazine/hardpoint/ltb/ap/empty
	current_rounds = 0

//HEAP shell, when it hits dense destructible obj/turf, shell "penetrates" it and explodes on the next tile after it
/obj/item/ammo_magazine/hardpoint/ltb/heap
	name = "LTB-95 Cannon HEAP Magazine"
	desc = "An LTB-95 Cannon magazine with High-Explosive Armor-Piercing shells. Reinforced tip allows shell to penetrate even thick armor or walls, after which densily packed explosives detonates. Very effective when fired at buildings and fortified positions."
	info = "Shell won't penetrate indestructible turfs and objects and will explode on their tile. Intended use - dealing damage to enemies behind defenses. Compact space will amplify explosion dealing more damage."
	icon_state = "ltb_heap"
	ammo_tag = "LTB HEAP"
	default_ammo = /datum/ammo/rocket/ltb/heap

/obj/item/ammo_magazine/hardpoint/ltb/heap/empty
	current_rounds = 0

//Shrapnel anti-infantry shell, massive damage on direct hit with tiny token explosion to look nice.
/obj/item/ammo_magazine/hardpoint/ltb/frg
	name = "LTB-95 Cannon FRG Magazine"
	desc = "An LTB-95 Cannon magazine with shrapnel-filled shells. Upon impact explosion sends fragmentation in a cone."
	info = "Direct hit will send only one piece of fragmentation into target, rest will go past it. While it most likely won't kill, it may deal noticeable damage to a group of enemy infantry not in cover, weakening or forcing to heal up and delaying them."
	icon_state = "ltb_frg"
	ammo_tag = "LTB FRG"
	default_ammo = /datum/ammo/rocket/ltb/frg

/obj/item/ammo_magazine/hardpoint/ltb/frg/empty
	current_rounds = 0
