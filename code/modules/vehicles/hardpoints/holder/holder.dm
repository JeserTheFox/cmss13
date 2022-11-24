/obj/item/hardpoint/holder
	name = "holder hardpoint"
	desc = "Holder for other hardpoints"

	// List of types of hardpoints that this hardpoint can hold
	var/list/accepted_hardpoints

	// List of held hardpoints
	var/list/hardpoints

	activatable = 0

/obj/item/hardpoint/holder/Destroy()
	QDEL_NULL_LIST(hardpoints)

	. = ..()

/obj/item/hardpoint/holder/update_icon()
	overlays.Cut()
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/I = H.get_hardpoint_image()
		overlays += I

/obj/item/hardpoint/holder/examine(var/mob/user)
	var/msg = "[icon2html(src, user)] That's \a [name].\n"
	msg += desc
	if(health <= 0)
		msg += "\n<b>It's busted!</b>"
	else if(isobserver(user) || (ishuman(user) && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI)))
		msg += "\nIt's at <b>[SPAN_HELPFUL(round(get_integrity_percent(), 1))]%</b> integrity!"
	for(var/obj/item/hardpoint/H in hardpoints)
		H.examine_hardpoint(user)

//made a separate examine proc for handling giving hardpoint info when examining vehicles/holders, cause I am tired of juggling with examine and it's constantly breaking - Jeser
/obj/item/hardpoint/holder/examine_hardpoint(mob/user)
	var/msg = "\nThere is \a [icon2html(src, user)] [name] installed."
	if(health <= 0)
		msg += " <b>It's busted!</b>"
	else if(isobserver(user) || (ishuman(user) && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI)))
		msg += " It's at <b>[SPAN_HELPFUL(round(get_integrity_percent(), 1))]%</b> integrity!"
	for(var/obj/item/hardpoint/H in hardpoints)
		msg += H.examine_hardpoint(user)
	return msg

/obj/item/hardpoint/holder/get_hardpoint_info()
	var/dat = ""
	for(var/obj/item/hardpoint/H in hardpoints)
		dat += H.get_hardpoint_info()
	dat += "<hr>"
	if(activatable)
		dat += "<b><A href='?src=\ref[owner];switch_hardpoint=\ref[src]'>\[[name]\]</A></b>"
	else
		dat += "<b>[name]</b>"
	if(health <= 0)
		dat += " | Integrity: <font color=\"red\"><b>\[DESTROYED\]</b></font><br>"
	else
		dat += " | Integrity: <b>[round(get_integrity_percent())]%</b><br>"
		//check if this hardpoint even uses ammo
		if(length(backup_ammo))
			if(ammo)
				dat += "Ammo: [ammo.current_rounds ? ammo.current_rounds : "<b><font color=\"red\">0</font></b>"]/[ammo.max_rounds] <b>[ammo.ammo_tag]</b> <b><A href='?src=\ref[owner];unload_hardpoint=\ref[src]'>\[Unload\]</A></b>"
			else
				dat += "Ammo: <b>No ammo selected</b>"
			dat += " | Total spare ammo: [get_total_mags() ? get_total_mags() : "<b><font color=\"red\">0</font></b>"]/[max_ammo]<br>"
			if(length(backup_ammo) > 1 || !ammo)
				for(var/tag in backup_ammo)
					if(length(backup_ammo[tag]))
						dat += "|<b><A href='?src=\ref[owner];switch_ammo_hardpoint=\ref[src];switch_ammo_tag=[tag]'>\[[tag]\]</A></b>: x[length(backup_ammo[tag])]|"
					else
						dat += "|<b>\[[tag]\]</b>: x[length(backup_ammo[tag])]"

	return dat

/obj/item/hardpoint/holder/take_damage(var/damage)
	..()

	for(var/obj/item/hardpoint/H in hardpoints)
		H.take_damage(damage)

/obj/item/hardpoint/holder/on_install(var/obj/vehicle/multitile/V)
	for(var/obj/item/hardpoint/HP in hardpoints)
		HP.owner = V
	return

/obj/item/hardpoint/holder/proc/can_install(var/obj/item/hardpoint/H)
	// Can only have 1 hardpoint of each slot type
	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/HP in hardpoints)
			if(HP.slot == H.slot)
				return FALSE
	// Must be accepted by the holder
	return LAZYISIN(accepted_hardpoints, H.type)

/obj/item/hardpoint/holder/proc/install(var/obj/item/hardpoint/H, var/mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("All the mounting points on \the [src] are broken!"))
		return

	user.visible_message(SPAN_NOTICE("[user] begins installing \the [H] on the [H.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin installing \the [H] on the [H.slot] hardpoint slot of \the [src]."))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user] stops installing \the [H] on \the [src]."), SPAN_WARNING("You stop installing \the [H] on \the [src]."))
		return

	user.temp_drop_inv_item(H, 0)
	add_hardpoint(H)

	update_icon()

/obj/item/hardpoint/holder/proc/uninstall(var/obj/item/hardpoint/H, var/mob/user)
	if(!LAZYISIN(hardpoints, H))
		return

	user.visible_message(SPAN_NOTICE("[user] begins removing \the [H] from the [H.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin removing \the [H] from the [H.slot] hardpoint slot of \the [src]."))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user] stops removing \the [H] from \the [src]."), SPAN_WARNING("You stop removing \the [H] from \the [src]."))
		return

	remove_hardpoint(H, get_turf(user))

	update_icon()

/obj/item/hardpoint/holder/attackby(var/obj/item/O, var/mob/user)
	if(HAS_TRAIT(O, TRAIT_TOOL_CROWBAR))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		var/chosen_hp = tgui_input_list(usr, "Select a hardpoint to remove", "Vehicle Hardpoint Removal", (hardpoints + "Cancel"))
		if(chosen_hp == "Cancel")
			return
		var/obj/item/hardpoint/old = chosen_hp

		uninstall(old, user)
		return

	if(istype(O, /obj/item/hardpoint))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		var/obj/item/hardpoint/H = O
		if(!(H.type in accepted_hardpoints))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		install(H, user)
		return

	..()

/obj/item/hardpoint/holder/proc/add_hardpoint(var/obj/item/hardpoint/H)
	H.owner = owner
	H.forceMove(src)
	LAZYADD(hardpoints, H)
	sort_hardpoints()

	H.rotate(turning_angle(H.dir, dir))

/obj/item/hardpoint/holder/proc/remove_hardpoint(var/obj/item/hardpoint/H, var/turf/uninstall_to)
	if(!hardpoints)
		return
	hardpoints -= H
	H.forceMove(uninstall_to ? uninstall_to : get_turf(src))

	H.reset_rotation()

	H.owner = null

	if(H.health <= 0)
		qdel(H)

//Returns all activatable hardpoints
/obj/item/hardpoint/holder/proc/get_activatable_hardpoints(var/seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(!H.is_activatable() || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

//This proc sorts list/hardpoints by specific order, which is:
/*
HOLDER(Turret)
PRIMARY
SECONDARY
SUPPORT
ARMOR
LOCOMOTION
*/
//it is done to guarantee a consistent listing of them for VCs in possible menus and windows
/obj/item/hardpoint/holder/proc/sort_hardpoints()
	var/list/sorted_hardpoints = list(
						HDPT_PRIMARY = null,
						HDPT_SECONDARY = null,
						HDPT_SUPPORT = null,
						)
	for(var/obj/item/hardpoint/HP in hardpoints)
		sorted_hardpoints[HP.slot] = HP
	hardpoints.Cut()
	for(var/slot in sorted_hardpoints)
		hardpoints += sorted_hardpoints[slot]


//Returns hardpoints that use ammunition
/obj/item/hardpoint/holder/proc/get_hardpoints_with_ammo(var/seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(!backup_ammo || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

/obj/item/hardpoint/holder/proc/find_hardpoint(var/name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.name == name)
			return H
	return null

// Modified to return a list of all images tied to the holder
/obj/item/hardpoint/holder/get_hardpoint_image()
	var/image/I = ..()
	var/list/images = list(I)
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/HI = H.get_hardpoint_image()
		if(LAZYLEN(px_offsets) && loc && HI)
			HI.pixel_x += px_offsets["[loc.dir]"][1]
			HI.pixel_y += px_offsets["[loc.dir]"][2]
		images += HI
	return images

/obj/item/hardpoint/holder/rotate(var/deg)
	for(var/obj/item/hardpoint/H in hardpoints)
		H.rotate(deg)

	..()
