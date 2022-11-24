/obj/item/ammo_magazine/hardpoint/autocannon
	name = "AC3-E Autocannon Magazine"
	desc = "An AC3-E Autocannon magazine filled with 20mm rounds packing small amount of explosives which isn't enough to deal serious damage, but excels in suppressing light targets in 3x3 area."
	caliber = "20mm"
	icon_state = "ace"
	ammo_tag = "AC3-E"
	default_ammo = /datum/ammo/bullet/autocannon
	max_rounds = 50
	gun_type = /obj/item/hardpoint/primary/autocannon

/obj/item/ammo_magazine/hardpoint/autocannon/empty
	current_rounds = 0

/obj/item/ammo_magazine/hardpoint/autocannon/iff
	name = "AC3-E Autocannon IFF Magazine"
	desc = "An AC3-E Autocannon magazine filled with 20mm IFF-compatible rounds. Upgrade came at a cost of a reduced explosive package, resulting in supression radius reducing to minimum."
	icon_state = "ace_iff"
	ammo_tag = "AC3-E IFF"
	default_ammo = /datum/ammo/bullet/autocannon/iff

/obj/item/ammo_magazine/hardpoint/autocannon/iff/empty
	current_rounds = 0
