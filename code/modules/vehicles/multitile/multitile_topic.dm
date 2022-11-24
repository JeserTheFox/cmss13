/obj/vehicle/multitile/Topic(href, href_list)
	if(href_list["switch_ammo_hardpoint"] && href_list["switch_ammo_tag"])
		var/mob/living/carbon/human/M = usr

		var/seat = get_mob_seat(M)
		if(!seat)
			return

		var/ammo_tag = href_list["switch_ammo_tag"]
		var/obj/item/hardpoint/HP = null
		for(var/obj/item/hardpoint/H in hardpoints)
			if(href_list["switch_ammo_hardpoint"] == "\ref[H]")
				HP = H
				break
			if(istype(H, /obj/item/hardpoint/holder))
				var/obj/item/hardpoint/holder/Holder = H
				for(H in Holder.hardpoints)
					if(href_list["switch_ammo_hardpoint"] == "\ref[H]")
						HP = H
						break

			if(HP)
				break

		if(!HP || HP.allowed_seat != seat)
			return

		if(HP.health <= 0)
			to_chat(M, SPAN_WARNING("\The [HP] is too damaged to be operated."))
			return

		if(!length(HP.backup_ammo))
			to_chat(M, SPAN_WARNING("ERROR. MIXED AMMO WAS NOT PROPERlY INITIALIZED. TELL A DEV."))
			return

		if(HP.ammo && ammo_tag == HP.ammo.ammo_tag)
			to_chat(M, SPAN_WARNING("<b>[ammo_tag]</b> ammunition is already selected."))
			return

		to_chat(M, SPAN_WARNING("Switching ammunition to <b>[ammo_tag]</b>..."))

		if(!HP.switch_ammo_type(M, ammo_tag))
			to_chat(M, SPAN_WARNING("<b>[ammo_tag]</b> ammunition is already selected or no <b>[ammo_tag]</b> ammo left."))
			return

		//reusing var for output message
		ammo_tag = "Switched ammunition to <b>[HP.ammo.ammo_tag]</b>.\n"
		ammo_tag += "Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b>\n"
		ammo_tag += HP.get_ammo_report()
		to_chat(M, SPAN_WARNING(ammo_tag))
		get_status_info()
		if(M.interactee != src)
			M.set_interaction(src)
		return

	else if(href_list["switch_hardpoint"])
		var/mob/living/carbon/human/M = usr

		var/seat = get_mob_seat(M)
		if(!seat)
			return

		var/obj/item/hardpoint/HP = null
		for(var/obj/item/hardpoint/H in hardpoints)
			if(href_list["switch_hardpoint"] == "\ref[H]")
				HP = H
				break
			if(istype(H, /obj/item/hardpoint/holder))
				var/obj/item/hardpoint/holder/Holder = H
				for(H in Holder.hardpoints)
					if(href_list["switch_hardpoint"] == "\ref[H]")
						HP = H
						break

			if(HP)
				break

		if(!HP || HP.allowed_seat != seat)
			return

		if(HP == active_hp[seat])
			to_chat(M, SPAN_WARNING("\The [HP] is already selected."))
			return

		if(HP.health <= 0)
			to_chat(M, SPAN_WARNING("\The [HP] is too damaged to be operated."))
			return

		active_hp[seat] = HP
		var/msg = "You select \the [HP]."
		if(HP.ammo)
			msg += " Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)] [HP.ammo.ammo_tag]</b>\n"
			msg += HP.get_ammo_report()
		to_chat(M, SPAN_NOTICE(msg))
		get_status_info()
		if(M.interactee != src)
			M.set_interaction(src)
		return

	else if(href_list["unload_hardpoint"])
		var/mob/living/carbon/human/M = usr

		var/seat = get_mob_seat(M)
		if(!seat)
			return

		var/obj/item/hardpoint/HP = null
		for(var/obj/item/hardpoint/H in hardpoints)
			if(href_list["unload_hardpoint"] == "\ref[H]")
				HP = H
				break
			if(istype(H, /obj/item/hardpoint/holder))
				var/obj/item/hardpoint/holder/Holder = H
				for(H in Holder.hardpoints)
					if(href_list["unload_hardpoint"] == "\ref[H]")
						HP = H
						break

			if(HP)
				break

		if(!HP || HP.allowed_seat != seat)
			return

		if(HP.health <= 0)
			to_chat(M, SPAN_WARNING("\The [HP] is too damaged to be operated."))
			return

		handle_hardpoint_unload(M, HP)
		get_status_info()
		if(M.interactee != src)
			M.set_interaction(src)
		return

	else if(href_list["toggle_doors"])
		var/mob/living/carbon/human/M = usr

		var/seat = get_mob_seat(M)
		if(!seat || seat != VEHICLE_DRIVER)
			return

		door_locked = !door_locked
		to_chat(M, SPAN_NOTICE("You [door_locked ? "lock" : "unlock"] the vehicle doors."))
		get_status_info()
		if(M.interactee != src)
			M.set_interaction(src)
		return
