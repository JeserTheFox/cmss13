/obj/item/hardpoint/secondary
	name = "secondary hardpoint"
	desc = "Something's secondary armament. Smaller support gun"

	slot = HDPT_SECONDARY

	damage_multiplier = 0.125

	activatable = TRUE

/obj/item/hardpoint/secondary/setup_mags()
	backup_ammo = list(
		"Generic Ammo" = list()
		)
	return
