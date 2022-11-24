/obj/item/hardpoint/primary/minigun
	name = "M80 Minigun"
	desc = "Tank's primary armament. Doesn't differ much from it's ancestor aside from modern materials."

	icon_state = "minigun"
	disp_icon = "tank"
	disp_icon_state = "minigun"

	health = 350
	cooldown = 10
	accuracy = 0.8
	firing_arc = 90

	auto_fire_support = TRUE

	origins = list(0, 0)

	max_ammo = 2

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 57),
		"2" = list(0, -67),
		"4" = list(77, 0),
		"8" = list(-77, 0)
	)

	var/firerate_level = 1
	var/last_shot_time = 0		//when was last shot fired, after 3 seconds we stop barrel
	var/list/shots_cooldown = list(8, 8, 6, 6, 4, 4, 3, 2, 1)	//cooldown between shots

/obj/item/hardpoint/primary/minigun/setup_mags()
	backup_ammo = list(
		"M80" = list(),
		)
	return

/obj/item/hardpoint/primary/minigun/fire(var/mob/user, var/atom/A)

	var/S = 'sound/weapons/vehicles/minigun_stop.ogg'
	//check how much time since last shot. 2 seconds are grace period before minigun starts to lose rotation momentum
	var/t = world.time - last_shot_time - 2 SECONDS
	t = round(t / 10)

	if(t > 0)
		firerate_level = max(firerate_level - t * 3, 1)	//we lose 3 firerate_levels per second
	else
		if(firerate_level < 9)
			firerate_level++
		if(!(world.time % 3))
			S = 'sound/weapons/vehicles/minigun_loop.ogg'
		else
			S = null

	if(firerate_level < 2)
		playsound(get_turf(src), 'sound/weapons/vehicles/minigun_start.ogg', 40, 1)

	cooldown = shots_cooldown[firerate_level]
	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
		A = get_step(get_turf(A), pick(cardinal))
	fire_projectile(user, A)
	if(!(world.time % 10))
		to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_ammo))]/[SPAN_HELPFUL(max_ammo)]</b>"))
	last_shot_time = world.time

	if(S)
		playsound(get_turf(src), S, 40, 1)
