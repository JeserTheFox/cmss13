/obj/item/hardpoint/primary/flamer
	name = "DRG-N Offensive Flamer Unit"
	desc = "Tank's primary armament. \"DRG-N Offensive Flamer\" Unit is just a fancy name for a \"big-ass flamerthrower\". Rumors say, it's origin can be traced back to some ancient Chinese \"Dragon Tank\" project."

	icon_state = "drgn_flamer"
	disp_icon = "tank"
	disp_icon_state = "drgn_flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 400
	cooldown = 20
	accuracy = 0.75
	firing_arc = 90

	origins = list(0, 0)

	max_range = 7

	max_ammo = 2

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 1),
		"8" = list(-32, 1)
	)

	use_muzzle_flash = FALSE

/obj/item/hardpoint/primary/flamer/setup_mags()
	backup_ammo = list(
		"DRG-N X" = list(),
		"DRG-N GEL" = list(),
		)
	return

/obj/item/hardpoint/primary/flamer/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	var/list/turf/turfs = getline2(origin_turf, A)
	var/distance = 0
	var/turf/prev_T

	for(var/turf/T in turfs)
		if(T == loc)
			prev_T = T
			continue
		if(!ammo.current_rounds) 	break
		if(distance >= max_range) 	break
		if(prev_T && LinkBlocked(prev_T, T))
			break
		ammo.current_rounds--
		flame_turf(T)
		distance++
		prev_T = T
		sleep(1)

/obj/item/hardpoint/secondary/flamer/proc/flame_turf(turf/T)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		new/obj/flamer_fire(T, create_cause_data(initial(name), user))
		new/obj/flamer_fire(T, create_cause_data(initial(name), user), var/datum/reagent/R)
