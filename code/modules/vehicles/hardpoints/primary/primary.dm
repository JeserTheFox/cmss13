/obj/item/hardpoint/primary
	name = "primary hardpoint"
	desc = "Something's primary armament. Main big gun"

	slot = HDPT_PRIMARY

	damage_multiplier = 0.15

	activatable = TRUE

/obj/item/hardpoint/primary/setup_mags()
	backup_ammo = list(
		"Generic Ammo" = list()
		)
	return
