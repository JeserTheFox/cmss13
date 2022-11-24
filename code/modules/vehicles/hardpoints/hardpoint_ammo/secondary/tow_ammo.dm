/obj/item/ammo_magazine/hardpoint/tow
	name = "TOW Launcher HE Magazine"
	desc = "TOW launcher magazine filled with HE rockets."
	icon_state = "tow_he"
	caliber = "rocket"
	ammo_tag = "TOW HE"
	max_rounds = 2
	default_ammo = /datum/ammo/rocket/tow
	gun_type = /obj/item/hardpoint/secondary/tow
	var/guided = FALSE

/obj/item/ammo_magazine/hardpoint/tow/empty
	current_rounds = 0

/obj/item/ammo_magazine/hardpoint/tow/ap
	name = "TOW Launcher AP Magazine"
	desc = "TOW launcher magazine filled with AP rockets."
	icon_state = "tow_ap"
	ammo_tag = "TOW AP Guided"
	default_ammo = /datum/ammo/rocket/ap/tow
	guided = TRUE

/obj/item/ammo_magazine/hardpoint/tow/ap/empty
	current_rounds = 0
