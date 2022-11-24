/obj/item/hardpoint/secondary/m56t
	name = "M56T Cupola"
	desc = "Tank's secondary armament. Special version of M56 Smartgun modified to be installed on top of tank't turret and support remote control. Not all types of ammunition is IFF-compatible, always check the ammo to know for sure."

	icon_state = "m56t"
	disp_icon = "tank"
	disp_icon_state = "m56t"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 350
	cooldown = 3
	accuracy = 1
	firing_arc = 0

	auto_fire_support = TRUE

	origins = list(0, 0)

	max_ammo = 2

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-7, -15),
		"4" = list(6, -10),
		"8" = list(-5, 7)
	)

/obj/item/hardpoint/secondary/m56t/setup_mags()
	backup_ammo = list(
		"M56T IFF" = list(),
		"M56T AP" = list(),
		)
	return

/obj/item/hardpoint/secondary/m56t/fire(var/mob/user, var/atom/A, var/autofire = FALSE)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	fire_projectile(user, A)

	if(!autofire)
		to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_ammo))]/[SPAN_HELPFUL(max_ammo)]</b>"))


/*
	for(var/bullets_fired = 1, bullets_fired <= burst_amount, bullets_fired++)
		var/atom/T = A
		if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
			T = get_step(get_turf(A), pick(cardinal))
		if(LAZYLEN(activation_sounds))
			playsound(get_turf(src), pick(activation_sounds), 60, 1)
		fire_projectile(user, T)
		if(ammo.current_rounds <= 0)
			break
		if(bullets_fired < burst_amount)	//we need to sleep only if there are more bullets to shoot in the burst
			sleep(3)
	to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_ammo))]/[SPAN_HELPFUL(max_ammo)]</b>"))
*/
