/obj/item/hardpoint/holder/tank_turret
	name = "M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt smoke screen deployment system."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = "tank"
	disp_icon_state = "tank_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -48
	pixel_y = -48

	density = TRUE	//come on, it's huge

	activatable = TRUE
	cooldown = 150
	accuracy = 0.8

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke
	max_ammo = 4
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 750
	damage_multiplier = 0.05

	accepted_hardpoints = list(
		// primaries
		/obj/item/hardpoint/primary/flamer,
		/obj/item/hardpoint/primary/ltb,
		/obj/item/hardpoint/primary/minigun,
		/obj/item/hardpoint/primary/autocannon,
		// secondaries
		/obj/item/hardpoint/secondary/flamer,
		/obj/item/hardpoint/secondary/tow,
		/obj/item/hardpoint/secondary/m56t,
		/obj/item/hardpoint/secondary/grenade_launcher
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, -10),
		"2" = list(0, 10),
		"4" = list(-10, 0),
		"8" = list(10, 0)
	)

	var/gyro = FALSE

	// How long the windup is before the turret rotates
	var/rotation_windup = 15
	// Used during the windup
	var/rotating = FALSE

/obj/item/hardpoint/holder/tank_turret/setup_mags()
	backup_ammo = list(
		"M34A2-A Smoke" = list(),
		)
	return

/obj/item/hardpoint/holder/tank_turret/update_icon()
	var/broken = (health <= 0)
	icon_state = "tank_turret_[broken]"

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	..()

/obj/item/hardpoint/holder/tank_turret/get_icon_image(var/x_offset, var/y_offset, var/new_dir)
	var/icon_state_suffix = "0"
	if(health <= 0)
		icon_state_suffix = "1"

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		I.overlays += damage_overlay

	return I

// no picking this big beast up
/obj/item/hardpoint/holder/tank_turret/attack_hand(var/mob/user)
	return

/obj/item/hardpoint/holder/tank_turret/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(PC.linked_powerloader)
			if(!PC.loaded)
				forceMove(PC.linked_powerloader)
				PC.loaded = src
				playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
				PC.update_icon()
				to_chat(user, SPAN_NOTICE("You grab [PC.loaded] with [PC]."))
				update_icon()

	..()

/obj/item/hardpoint/holder/tank_turret/get_hardpoint_info()
	var/dat = ""
	for(var/obj/item/hardpoint/H in hardpoints)
		dat += H.get_hardpoint_info()
	dat += "<hr>"
	if(activatable)
		dat += "<b><A href='?src=\ref[owner];switch_hardpoint=\ref[src]'>\[M34A2-A Turret Smoke Screen\]</A></b>"
	else
		dat += "<b>M34A2-A Turret Smoke Screen</b>"
	if(health <= 0)
		dat += " | Integrity: <font color=\"red\"><b>\[DESTROYED\]</b></font><br>"
	else
		dat += " | Integrity: <b>[round(get_integrity_percent())]%</b><br>"
		//check if this hardpoint even uses ammo
		if(length(backup_ammo))
			if(ammo)
				dat += "Uses left: [ammo.current_rounds ? ammo.current_rounds / 2 : "<b><font color=\"red\">0</font></b>"]/[ammo.max_rounds / 2] <b>[ammo.ammo_tag]</b> <b><A href='?src=\ref[owner];unload_hardpoint=\ref[src]'>\[Unload\]</A></b>"
			else
				dat += "Uses left: <b>No ammo selected</b>"
			dat += " | Total spare ammo: [get_total_mags() ? get_total_mags() : "<b><font color=\"red\">0</font></b>"]/[max_ammo]<br>"
			if(length(backup_ammo) > 1 || !ammo)
				for(var/tag in backup_ammo)
					if(length(backup_ammo[tag]))
						dat += "|<b><A href='?src=\ref[owner];switch_ammo_hardpoint=\ref[src];switch_ammo_tag=[tag]'>\[[tag]\]</A></b>: x[length(backup_ammo[tag])]|"
					else
						dat += "|<b>\[[tag]\]</b>: x[length(backup_ammo[tag])]"
	return dat

//gyro ON locks the turret in one direction, OFF will make turret turning when tank turns
/obj/item/hardpoint/holder/tank_turret/proc/toggle_gyro(var/mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s stabilization systems are busted!"))
		return

	gyro = !gyro
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s gyroscopic stabilizer [gyro ? "ON" :"OFF"]."))

/obj/item/hardpoint/holder/tank_turret/proc/user_rotation(var/mob/user, var/deg)
	// no rotating a broken turret
	if(health <= 0)
		return

	if(rotating)
		return

	rotating = TRUE
	to_chat(user, SPAN_NOTICE("You begin rotating the turret towards the [dir2text(turn(dir,deg))]."))

	if(!do_after(user, rotation_windup, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		rotating = FALSE
		return
	rotating = FALSE

	rotate(deg, TRUE)

/obj/item/hardpoint/holder/tank_turret/rotate(var/deg, var/override_gyro = FALSE)
	if(gyro && !override_gyro)
		return

	..(deg)

	var/obj/vehicle/multitile/tank/C = owner
	var/obj/item/hardpoint/support/advanced_optics/AOM
	for(var/obj/item/hardpoint/support/advanced_optics/A in C.hardpoints)
		AOM = A
	if(AOM && AOM.is_active)
		var/mob/user = C.seats[VEHICLE_GUNNER]
		if(user && user.client)
			user = C.seats[VEHICLE_GUNNER]
			user.client.change_view(AOM.view_buff)

			switch(dir)
				if(NORTH)
					user.client.pixel_x = 0
					user.client.pixel_y = AOM.view_tile_offset * 32
				if(SOUTH)
					user.client.pixel_x = 0
					user.client.pixel_y = -1 * AOM.view_tile_offset * 32
				if(EAST)
					user.client.pixel_x = AOM.view_tile_offset * 32
					user.client.pixel_y = 0
				if(WEST)
					user.client.pixel_x = -1 * AOM.view_tile_offset * 32
					user.client.pixel_y = 0

/obj/item/hardpoint/holder/tank_turret/fire(var/mob/user, var/atom/A)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown

	var/turf/L
	var/turf/R
	switch(owner.dir)
		if(NORTH)
			L = locate(owner.x - 2, owner.y + 4, owner.z)
			R = locate(owner.x + 2, owner.y + 4, owner.z)
		if(SOUTH)
			L = locate(owner.x + 2, owner.y - 4, owner.z)
			R = locate(owner.x - 2, owner.y - 4, owner.z)
		if(EAST)
			L = locate(owner.x + 4, owner.y + 2, owner.z)
			R = locate(owner.x + 4, owner.y - 2, owner.z)
		else
			L = locate(owner.x - 4, owner.y + 2, owner.z)
			R = locate(owner.x - 4, owner.y - 2, owner.z)

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)
	fire_projectile(user, L)

	sleep(10)

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)
	fire_projectile(user, R)

	to_chat(user, SPAN_WARNING("Smoke Screen uses left: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds / 2 : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds / 2 : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_ammo))]/[SPAN_HELPFUL(max_ammo)]</b>"))

/obj/item/hardpoint/holder/tank_turret/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	origin_turf = get_step(get_step(origin_turf, owner.dir), owner.dir)	//this should get us tile in front of tank to prevent grenade being stuck under us.

	var/obj/item/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, owner.seats[VEHICLE_GUNNER])
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, get_dist(origin_turf, A) + 1, P.ammo.shell_speed)
	ammo.current_rounds--
