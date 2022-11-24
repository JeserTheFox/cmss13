/obj/item/hardpoint/primary/autocannon
	name = "AC3-E Autocannon"
	desc = "Tank's primary armament. Light 20mm autocannon is perfect for fast scouting tank. Also used to train rookie gunners, due to available IFF-capatible rounds."

	icon_state = "autocannon"
	disp_icon = "tank"
	disp_icon_state = "autocannon"
	activation_sounds = list('sound/weapons/vehicles/autocannon_fire.ogg')

	health = 500
	cooldown = 7
	accuracy = 0.98
	firing_arc = 60

	origins = list(0, -3)

	max_ammo = 6

	px_offsets = list(
		"1" = list(0, 22),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

/obj/item/hardpoint/primary/autocannon/setup_mags()
	backup_ammo = list(
		"AC3-E" = list(),
		"AC3-E IFF" = list()
		)
	return
