//MP treads clamp for tank
/obj/item/vehicle_clamp
	name = "Vehicle Clamp"
	desc = "Good old vehicle clamp, except this one was reinforced and can be applied to military vehicles. Use screwdriver to uninstall it."

	icon = 'icons/obj/vehicles/vehicle_items.dmi'
	icon_state = "vehicle_clamp"
/*
/obj/item/tool/spray_gun
	name = "Spray Gun"
	desc = "Industrial spray gun that is used to apply various paint jobs on military vehicles. Can only be used by Vehicle Crewmen."
	icon = 'icons/obj/vehicles/vehicle_items.dmi'
	icon_state = "spray_gun"

	var/paint_left = CAN_APPLY_CAMO|CAN_APPLY_PAINTJOB
	var/selected_paintjob = /datum/vehicle_paintjob/camo

/obj/item/tool/spray_gun/update_icon()
	if(paint_left)
		icon_state = "spray_gun_0"
	else
		icon_state = "spray_gun_1"

/obj/item/tool/spray_gun/Initialize()
	..()
	update_icon()

/obj/item/tool/spray_gun/examine(mob/user)
	..()
	if(paint_left & (CAN_APPLY_CAMO|CAN_APPLY_PAINTJOB))
		to_chat(user, SPAN_NOTICE("It is full."))
	else if(paint_left & CAN_APPLY_CAMO)
		to_chat(user, SPAN_NOTICE("It still has enough paint left to apply camouflage paintjob."))
	else if(paint_left & CAN_APPLY_PAINTJOB)
		to_chat(user, SPAN_NOTICE("It still has enough paint left to apply custom paintjob."))
	else
		to_chat(user, SPAN_NOTICE("It is empty."))

/obj/item/tool/spray_gun/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.job != JOB_CREWMAN)
		to_chat(user, SPAN_WARNING("Only Vehicle Crewmen can use \the [name]!"))
		return

	if(!paint_left)
		to_chat(user, SPAN_WARNING("\The [name] is out of paint!"))
		return

	interact(H)
	..()

/obj/item/tool/spray_gun/interact(mob/user)
	tgui_interact(user)

/obj/item/tool/spray_gun/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SprayGun", "Spray Gun")
		ui.open()
		ui.set_autoupdate()


var/dat = "[V]<br>"
	dat += "Current armor resistances:<br>"
	var/list/resist_name = list("Bio" = "acid", "Slash" = "slash", "Bullet" = "bullet", "Expl" = "explosive", "Blunt" = "blunt")

	for(var/i in resist_name)
		var/resist = 1 - LAZYACCESS(V.dmg_multipliers, LAZYACCESS(resist_name, i))
		if(resist > 0)
			dat += SPAN_HELPFUL("[resist * 100]% [i] ")
		else
			dat += "<font color=\"red\">[resist * 100]% [i] </font>"

	dat += "<br>"

	if(V.health <= 0)
		dat += "Hull integrity: <font color=\"red\">\[CRITICAL FAILURE\]</font>"
	else
		dat += "Hull integrity: [round(100.0 * V.health / initial(V.health))]%"

	var/list/hps = V.hardpoints.Copy()

	for(var/obj/item/hardpoint/holder/H in hps)
		dat += H.get_hardpoint_info()
		LAZYREMOVE(hps, H)
	for(var/obj/item/hardpoint/H in hps)
		dat += H.get_hardpoint_info()

	dat += "<hr>"

	if(V.health <= 0)
		dat += "Doors locks: <font color=\"red\">BROKEN</font>.<br>"
	else
		dat += "Doors locks: [V.door_locked ? "<font color=\"green\">Enabled</font>" : "<font color=\"red\">Disabled</font>"].<br>"

	V.interior.update_passenger_count()
	dat += "Common passengers capacity: [V.interior.passengers_taken_slots]/[V.interior.passengers_slots].<br>"

	for(var/datum/role_reserved_slots/RRS in V.interior.role_reserved_slots)
		dat += "[RRS.category_name] passengers capacity: [RRS.taken]/[RRS.total].<br>"

	show_browser(user, dat, "Vehicle Status Info", "vehicle_info")
	onclose(user, "vehicle_info")


/obj/item/tool/spray_gun/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	switch(action)
		if("select_paintjob")
			selected_paintjob = GLOB.vehicle_paintjobs["paintjobs_datum"][params["type"]]


/obj/item/tool/spray_gun/ui_data(mob/user)
	. = list()
	.["current_paintjob"] = selected_paintjob

/obj/item/tool/spray_gun/ui_static_data(mob/user)
	. = list()

	.["current_map"] = SSmapping.configs[GROUND_MAP].map_name
	.["glob_paintjobs"] = GLOB.vehicle_paintjobs
	.["playtime"] = get_job_playtime(user.client, JOB_CREWMAN)
*/
