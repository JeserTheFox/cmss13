/obj/item/hardpoint/secondary/tow
	name = "M71 TOW Launcher"
	desc = "Tank's secondary armament. Auxiliary rocket launcher installed on top of the turret. Doesn't differ much from it's ancestor aside from modern materials."

	icon_state = "tow"
	disp_icon = "tank"
	disp_icon_state = "tow"

	health = 500
	cooldown = 150
	accuracy = 0.8
	firing_arc = 60
	max_range = 25

	activation_time = 20 // for unguided, guided is +1 second

	origins = list(0, -2)

	max_ammo = 2

	px_offsets = list(
		"1" = list(1, 10),
		"2" = list(-1, 5),
		"4" = list(0, 0),
		"8" = list(0, 18)
	)

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-8, -16),
		"4" = list(5, -8),
		"8" = list(-5, 10)
	)

/obj/item/hardpoint/secondary/tow/setup_mags()
	backup_ammo = list(
		"TOW AP Guided" = list(),
		"TOW HE" = list(),
		)
	return

/obj/item/hardpoint/secondary/tow/fire(var/mob/user, var/atom/A)
	if(!ammo)
		to_chat(user, SPAN_WARNING("WARNING. No ammunition is currently selected."))
		return

	if(ammo.current_rounds <= 0)
		return

	if(check_shot_is_blocked(get_turf(A)))
		to_chat(user, SPAN_WARNING("Target capture failed. No clear line of fire."))
		return

	var/obj/item/ammo_magazine/hardpoint/tow/mag = ammo
	if(mag.guided)

		if(isliving(A))
			var/mob/living/L = A
			if(L.stat == DEAD)
				to_chat(user, SPAN_WARNING("Target capture failed. Target shows no signs of life."))
				return
			if(L.client)
				playsound_client(L.client, 'sound/weapons/vehicles/tow_target_lock.ogg', L, 40)

		else if(isVehicle(A))
			if(istype(A, /obj/vehicle/multitile))
				var/obj/vehicle/multitile/V = A
				//only serious military vehicles can detect target lock, but need to find some better way to check than this
				if(V.req_one_access.Find(ACCESS_MARINE_CREWMAN))
					for(var/seat in V.seats)
						if(!V.seats[seat])
							continue
						var/mob/M = V.seats[seat]
						to_chat(M, SPAN_DANGER("VEHICLE BEING TARGET LOCKED."))
						if(M.client)
							playsound_client(M.client, 'sound/weapons/vehicles/tow_target_lock.ogg', M, 40)
		else
			to_chat(user, SPAN_WARNING("Target capture failed. Only vehicles and big enough creatures are recognized as legitimate targets."))
			return
		var/atom/movable/AM = A

		var/atom/movable/overlay/target_lock = new()
		target_lock.icon = 'icons/effects/Targeted.dmi'
		target_lock.icon_state = "tow_locked"
		target_lock.layer = ABOVE_XENO_LAYER
		target_lock.vis_flags = VIS_INHERIT_ID
		target_lock.pixel_x = 5
		AM.vis_contents += target_lock

		var/warning_dir = get_cardinal_dir(A, get_turf(owner))
		target_lock.dir = warning_dir

		flick("tow_locking", target_lock)

		playsound(user, 'sound/weapons/vehicles/tow_target_lock.ogg', 40, 1)
		to_chat(user, SPAN_INFO("Acquiring target. Use [SPAN_HELPFUL("Middle Mouse Button (MMB)")] to cancel."))
		if(!do_after(user, activation_time + 1 SECONDS, INTERRUPT_ALL|INTERRUPT_MMB_CLICK, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_WARNING("You cancel firing [ammo.ammo_tag] rocket at \the [AM]. You can designate new target in [SPAN_HELPFUL("5 seconds")]."))
			AM.vis_contents -= target_lock
			next_use = world.time + 5 SECONDS
			return
		AM.vis_contents -= target_lock
	else

		new /obj/effect/overlay/temp/tow(get_turf(A))
		playsound(user, 'sound/weapons/vehicles/tow_target_lock.ogg', 40, 1)
		to_chat(user, SPAN_INFO("Acquiring target. Use [SPAN_HELPFUL("Middle Mouse Button (MMB)")] to cancel."))
		if(!do_after(user, activation_time, INTERRUPT_ALL|INTERRUPT_MMB_CLICK, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_WARNING("You cancel firing [ammo.ammo_tag] rocket at \the [A]. Targeting system will be ready for use in [SPAN_HELPFUL("5 seconds")]."))
			next_use = world.time + 5 SECONDS
			return

	if(!in_firing_arc(A) || !ammo || check_shot_is_blocked(get_turf(A)))
		to_chat(user, SPAN_WARNING("Target was lost or ammo is missing. Targeting system will be ready for use in [SPAN_HELPFUL("5 seconds")]."))
		next_use = world.time + 5 SECONDS
		return

	to_chat(user, SPAN_INFO("Target acquired. Firing [ammo.ammo_tag] rocket."))

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]
	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	fire_projectile(user, A)

	to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo.current_rounds)]/[SPAN_HELPFUL(ammo.max_rounds)]</b> <b>[ammo.ammo_tag]</b> | Mags: <b>[SPAN_HELPFUL(get_total_mags())]/[SPAN_HELPFUL(max_ammo)]</b>"))


/obj/item/hardpoint/secondary/tow/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	if(origins[1] || origins[2])
		origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/item/projectile/P = generate_bullet(user, origin_turf)
	if(P.ammo.flags_ammo_behavior & AMMO_HOMING && ismob(A))
		P.homing_target = A
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, owner.seats[VEHICLE_GUNNER])
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, max_range ? max_range : P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, A))

	ammo.current_rounds--

/obj/item/hardpoint/secondary/tow/proc/check_shot_is_blocked(var/turf/T)
	var/list/turf/path = getline2(get_turf(owner), T, include_from_atom = FALSE)
	T = path[1]
	path -= T	//remove outer vehicle tile
	T = path[length(path)]
	path -= T	//if target on last tile, we fire at it regardless

	if(!length(path) || length(path) + 1 > max_range)
		return TRUE

	var/blocked = FALSE
	for(T in path)
		if(T.density || T.opacity)
			blocked = TRUE
			break

		for(var/obj/O in T)
			if(O.density || O.opacity)
				blocked = TRUE
				break

	return blocked
