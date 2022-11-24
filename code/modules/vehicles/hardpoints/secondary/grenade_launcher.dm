/obj/item/hardpoint/secondary/grenade_launcher
	name = "M92T Grenade Launcher"
	desc = "Tank's secondary armament. Special version of M92 Grenade Launcher modified to be installed on top of tank't turret and support remote control. Retains it's ability to launch grenades over infantry. Has max range of 8 tiles."

	icon_state = "grenade_launcher"
	disp_icon = "tank"
	disp_icon_state = "grenade_launcher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	health = 500
	cooldown = 30
	accuracy = 0.4
	firing_arc = 90
	max_range = 8

	origins = list(0, 0)

	max_ammo = 4

	use_muzzle_flash = FALSE

	px_offsets = list(
		"1" = list(0, 17),
		"2" = list(0, 0),
		"4" = list(6, 0),
		"8" = list(-6, 17)
	)

/obj/item/hardpoint/secondary/grenade_launcher/setup_mags()
	backup_ammo = list(
		"M92T HE" = list(),
		)
	return

/obj/item/hardpoint/secondary/grenade_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/secondary/grenade_launcher/can_activate(var/mob/user, var/atom/A)
	if(!..())
		return FALSE

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	if(get_dist(origin_turf, A) < 2)
		to_chat(usr, SPAN_WARNING("The target is too close."))
		return FALSE

	return TRUE
