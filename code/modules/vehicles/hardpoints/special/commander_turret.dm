#define LASER_CAS	"CAS marking"
#define LASER_RANGE	"range finder"

//doesn't have sprites, because not needed.
// - Can rotate
// - Provides zoom
// - Click activates/deactivates laser
// - Ctrl + Click switches laser modes
// - MMB Click toggles NVGs
// - Alt + Click activates order buffs
/obj/item/hardpoint/special/commander_turret
	name = "Commander Turret"
	desc = "Small rotating turret full of advanced optics, allowing high-quality zoom, with integrated night vision, laser designator and broadcaster controls."

	allowed_seat = VEHICLE_SUPPORT_COMMANDER

	activatable = TRUE
	firing_arc = 100

	//order coodown
	cooldown = 30 SECONDS
	next_use = 0

	//laser coodown
	var/laser_cooldown = 5 SECONDS
	var/laser_next_use = 0

	var/obj/effect/overlay/temp/laser_coordinate/coord
	var/obj/effect/overlay/temp/laser_target/laser
	var/laser_mode = LASER_RANGE
	var/tracking_id
	var/lastx = 0
	var/lasty = 0

	var/nightvision = FALSE

	var/view_buff = 10
	var/view_tile_offset = 7

/obj/item/hardpoint/special/commander_turret/Initialize()
	. = ..()
	tracking_id = ++cas_tracking_id_increment

/obj/item/hardpoint/special/commander_turret/Destroy()
	QDEL_NULL(laser)
	QDEL_NULL(coord)
	. = ..()

/obj/item/hardpoint/special/commander_turret/get_hardpoint_info()
	var/dat = "<hr>"
	dat += "[name]<br>"
	if(CAS_mode == LASER_RANGE)
		dat += "Laser mode: <font color=\"green\">[LASER_RANGE]</font>"
	else
		dat += "Laser mode: <font color=\"red\">[LASER_CAS] (ID: [tracking_id])</font>"

	return dat

//----------------ROTATION PART-----------------

/obj/item/hardpoint/special/commander_turret/proc/user_rotation(var/mob/living/carbon/human/user, var/deg)
	if(!owner || owner.health <= initial(owner.health) * 0.5)
		return

	if(rotating)
		return

	rotating = TRUE

	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		rotating = FALSE
		return
	rotating = FALSE

	rotate(deg, TRUE)

/obj/item/hardpoint/special/commander_turret/rotate(var/deg, var/override_gyro = FALSE)
	if(!override_gyro)
		return

	var/obj/vehicle/multitile/apc/command/C = owner
	var/mob/user = C.seats[VEHICLE_SUPPORT_COMMANDER]
	if(!user || !user.client)
		return
	user = C.seats[VEHICLE_SUPPORT_COMMANDER]
	user.client.change_view(view_buff, src)

	switch(dir)
		if(NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = view_tile_offset * 32
		if(SOUTH)
			user.client.pixel_x = 0
		user.client.pixel_y = -1 * view_tile_offset * 32
		if(EAST)
			user.client.pixel_x = view_tile_offset * 32
		user.client.pixel_y = 0
		if(WEST)
			user.client.pixel_x = -1 * view_tile_offset * 32
			user.client.pixel_y = 0

//----------------ORDER BUFF PART-----------------

/obj/item/hardpoint/special/commander_turret/can_activate(var/mob/living/carbon/human/user, var/atom/A)
	if(!owner)
		return FALSE

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return FALSE

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return FALSE

	if(owner.health < initial(owner.health) * 0.5)
		to_chat(user, SPAN_WARNING("<b>\The [owner]'s hull is too damaged!</b>"))
		return FALSE

	if(world.time < next_use)
		to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((next_use - world.time) / 10)] seconds before you can give out a new order."))
		return FALSE

	return TRUE

/obj/item/hardpoint/special/firing_port_weapon/fire(var/mob/living/carbon/human/user, var/atom/A)


	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

//----------------NIGHTVISION PART-----------------

/obj/item/hardpoint/special/commander_turret/proc/toggle_nightvision(var/mob/living/carbon/human/user)

	if(user != C.seats[VEHICLE_SUPPORT_COMMANDER])
		return

	if(nightvision)
		remove_nvg(user)
	else
		enable_nvg(user)

	to_chat(user, SPAN_NOTICE("You toggle [src]'s nightvision mode [nightvision ? "off" : "on"]."))

/obj/item/hardpoint/special/commander_turret/proc/enable_nvg(var/mob/living/carbon/human/user)

	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, .proc/update_sight)

	user.add_client_color_matrix("nvg", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string("#7aff7a")))
	user.overlay_fullscreen("nvg", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("nvg_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	playsound(user, 'sound/handling/toggle_nv1.ogg', 25)
	nightvision = TRUE
	user.update_sight()

	START_PROCESSING(SSobj, src)

/obj/item/hardpoint/special/commander_turret/proc/remove_nvg()
	SIGNAL_HANDLER

	var/mob/user = C.seats[VEHICLE_SUPPORT_COMMANDER]
	if(!user || !user.client)
		return

	if(nightvision)
		user.remove_client_color_matrix("nvg", 1 SECONDS)
		user.clear_fullscreen("nvg", 0.5 SECONDS)
		user.clear_fullscreen("nvg_blur", 0.5 SECONDS)
		playsound(user, 'sound/handling/toggle_nv2.ogg', 25)
		nightvision = FALSE

		UnregisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT)

		user.update_sight()

		STOP_PROCESSING(SSobj, src)

/obj/item/hardpoint/special/commander_turret/proc/update_sight(var/mob/living/carbon/human/user)
	SIGNAL_HANDLER

	if(lighting_alpha < 255)
		M.see_in_dark = 12
	M.lighting_alpha = lighting_alpha
	M.sync_lighting_plane_alpha()

//----------------LASER PART-----------------

/obj/item/hardpoint/special/commander_turret/proc/toggle_las_mode(var/mob/living/carbon/human/user)

	if(laser || coord)
		return

	if(laser_mode == LASER_RANGE)
		laser_mode = LASER_CAS
	else
		laser_mode = LASER_RANGE

	to_chat(user, SPAN_NOTICE("You switch [src] to [laser_mode] mode."))
	playsound(user, 'sound/machines/click.ogg', 15, 1)

/obj/item/hardpoint/special/commander_turret/proc/stop_targeting(var/mob/living/carbon/human/user)
	if(coord)
		QDEL_NULL(coord)

	else if(laser)
		QDEL_NULL(laser)

	to_chat(user, SPAN_WARNING("You stop lasing."))

/obj/item/hardpoint/special/commander_turret/proc/can_activate_laser(var/mob/living/carbon/human/user, var/atom/A)

	if(!owner || A.z == 0)
		return FALSE

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return FALSE

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return FALSE

	if(owner.health < initial(owner.health) * 0.5)
		to_chat(user, SPAN_WARNING("<b>\The [owner]'s hull is too damaged!</b>"))
		return FALSE

	if(laser || coord)
		to_chat(user, SPAN_WARNING("You're already targeting something."))
		return

	if(world.time < laser_next_use)
		to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((laser_next_use - world.time) / 10)] seconds before you can lase again."))
		return FALSE

	if(!in_firing_arc(A))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return FALSE

	return TRUE

/obj/item/hardpoint/special/commander_turret/proc/lase_target(atom/A, var/mob/living/carbon/human/user)
	set waitfor = 0

	var/acquisition_time = 5 SECONDS
	if(user.skills)
		acquisition_time = max(15, acquisition_time - 25*user.skills.get_skill_level(SKILL_JTAC))

	var/las_name
	las_name = "APC CMD-[tracking_id]"

	var/turf/TU = get_turf(A)
	var/area/targ_area = get_area(A)
	if(!istype(TU))
		return
	var/is_outside = FALSE
	switch(targ_area.ceiling)
		if(CEILING_NONE)
			is_outside = TRUE
		if(CEILING_GLASS)
			is_outside = TRUE

	if(protected_by_pylon(TURF_PROTECTION_CAS, TU))
		is_outside = FALSE

	if(!is_outside && laser_mode == LASER_CAS)	//rangefinding works regardless of ceiling
		to_chat(user, SPAN_WARNING("INVALID TARGET: target must be visible from high altitude."))
		return
	playsound(owner, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, SPAN_NOTICE("INITIATING LASER TARGETING. Stand still."))
	if(!do_after(user, acquisition_time, INTERRUPT_ALL, BUSY_ICON_GENERIC) || world.time < laser_cooldown || laser)
		return
	if(laser_mode)
		var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, las_name, user)
		coord = LT
		lastx = obfuscate_x(coord.x)
		lasty = obfuscate_y(coord.y)

		tgui_interact(user)
		show_coords(user)

		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(coord)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				QDEL_NULL(coord)
				break
	else
		to_chat(user, SPAN_NOTICE("TARGET ACQUIRED. LASER TARGETING IS ONLINE."))
		var/obj/effect/overlay/temp/laser_target/LT = new (TU, las_name, user, tracking_id)
		laser = LT

		var/turf/userloc = get_turf(user)
		msg_admin_niche("Laser target [las_name] has been designated by [key_name(user, 1)] at ([TU.x], [TU.y], [TU.z]). (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[userloc.x];Y=[userloc.y];Z=[userloc.z]'>JMP SRC</a>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[TU.x];Y=[TU.y];Z=[TU.z]'>JMP LOC</a>)")
		log_game("Laser target [las_name] has been designated by [key_name(user, 1)] at ([TU.x], [TU.y], [TU.z]).")

		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(laser)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				QDEL_NULL(laser)
				break

/obj/item/hardpoint/special/commander_turret/proc/show_coords(var/mob/living/carbon/human/user)
	if(lastx || lasty)
		to_chat(user, SPAN_NOTICE(FONT_SIZE_LARGE("SAVED COORDINATES OF TARGET. LONGITUDE [last_x]. LATITUDE [last_y].")))

/obj/item/hardpoint/special/commander_turret/proc/tgui_interact(var/mob/living/carbon/human/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Binoculars", "[src.name]")
		ui.open()

/obj/item/hardpoint/special/commander_turret/proc/ui_state(var/mob/living/carbon/human/user)
	return GLOB.inventory_state

/obj/item/hardpoint/special/commander_turret/proc/ui_data(var/mob/living/carbon/human/user)
	var/list/data = list()

	data["xcoord"] = lastx
	data["ycoord"] = lasty

	return data


#undef LASER_CAS
#undef LASER_RANGE
