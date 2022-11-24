/obj/item/hardpoint/primary/ltb
	name = "LTB-95 Cannon"
	desc = "Tank's primary armament. Developed specifically for USCM this 95mm cannon provides enough fire power to deal with most common armored targets. It's low weight allows technicians to quickly install and uninstall the cannon even in the field, while it's light shells make it possible for the 4-shell magazines to be man portable, if need be."

	icon_state = "ltb_cannon"
	disp_icon = "tank"
	disp_icon_state = "ltb_cannon"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 500
	cooldown = 5
	accuracy = 0.97
	firing_arc = 60

	origins = list(0, 0)

	max_ammo = 4

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 59),
		"2" = list(0, -74),
		"4" = list(89, -4),
		"8" = list(-89, -4)
	)

/obj/item/hardpoint/primary/ltb/setup_mags()
	backup_ammo = list(
		"LTB" = list(),
		"LTB HE" = list(),
		"LTB AP" = list(),
		"LTB HEAP" = list(),
		"LTB FRG" = list()
		)
	return
