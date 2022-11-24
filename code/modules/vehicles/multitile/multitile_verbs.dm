//------------------------------------------------------
//------------------------VERBS-------------------------
//This file contains all basic verbs that vehicles contain

//------------------------HARDPOINTS VERBS--------------

//Used to swap which module a position is using
//e.g. swapping primary gunner from the minigun to the smoke launcher
/obj/vehicle/multitile/proc/switch_hardpoint()
	set name = "Change Active Hardpoint"
	set category = "Vehicle.Hardpoints"
	set desc = "Allows you to select an available hardpoint from the list."

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return

	var/obj/item/hardpoint/HP = tgui_input_list(usr, "Select a hardpoint.", "Switch Hardpoint", usable_hps)
	if(!HP)
		return

	V.active_hp[seat] = HP
	var/msg = "You select \the [HP]."

	V.check_hardpoint_autofire(M, HP)

	if(HP.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)] [HP.ammo.ammo_tag]</b>\n"
		msg += HP.get_ammo_report()
	to_chat(M, SPAN_NOTICE(msg))

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/cycle_hardpoint()
	set name = "Cycle Active Hardpoint"
	set category = "Vehicle.Hardpoints"
	set desc = "Cycles through hardpoints in an available hardpoints list without need to confirm selection."

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return
	var/new_hp = usable_hps.Find(V.active_hp[seat])
	if(!new_hp)
		new_hp = 0

	new_hp = (new_hp % usable_hps.len) + 1
	var/obj/item/hardpoint/HP = usable_hps[new_hp]
	if(!HP)
		return

	V.active_hp[seat] = HP
	var/msg = "You select \the [HP]."

	V.check_hardpoint_autofire(M, HP)

	if(HP.ammo)
		msg += " Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)] [HP.ammo.ammo_tag]</b>\n"
		msg += HP.get_ammo_report()
	to_chat(M, SPAN_NOTICE(msg))

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/switch_ammo_type()
	set name = "Switch Ammo Type"
	set category = "Vehicle.Hardpoints"
	set desc = "Allows you to select an ammunition type in current active hardpoint."

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/obj/item/hardpoint/HP = V.active_hp[seat]

	if(!HP)
		to_chat(M, SPAN_WARNING("Please select an active hardpoint first."))
		return

	if(HP.health <= 0)
		to_chat(M, SPAN_WARNING("\The [HP] is too damaged to be operated."))
		return

	if(HP.max_ammo <= 0)
		return

	if(!length(HP.backup_ammo))
		to_chat(M, SPAN_WARNING("ERROR. MIXED AMMO WAS NOT PROPERlY INITIALIZED. TELL A DEV."))
		return

	var/list/ammo_choices = list()
	var/obj/item/ammo_magazine/hardpoint/mag = null
	for(var/type in HP.backup_ammo)
		if(!length(HP.backup_ammo[type]))
			continue
		mag = HP.backup_ammo[type][1]
		if(HP.ammo && mag.ammo_tag == HP.ammo.ammo_tag)
			ammo_choices["[type] ([length(HP.backup_ammo[type])] left) (CURRENT)"] = type
		else
			ammo_choices["[type] ([length(HP.backup_ammo[type])] left)"] = type

	if(!length(ammo_choices))
		to_chat(M, SPAN_WARNING("<b>WARNING.</b> NO AMMO IS LOADED."))
		return

	var/chosen_ammo = tgui_input_list(M, "Select an ammo type to switch to:", "Ammo selection", (ammo_choices + "Cancel"))

	if(!chosen_ammo || chosen_ammo == "Cancel")
		return

	if(HP.ammo && ammo_choices[chosen_ammo] == HP.ammo.ammo_tag)
		to_chat(M, SPAN_WARNING("<b>[ammo_choices[chosen_ammo]]</b> ammunition is already selected."))
		return

	to_chat(M, SPAN_WARNING("Switching ammunition to <b>[ammo_choices[chosen_ammo]]</b>..."))

	if(!HP.switch_ammo_type(M, ammo_choices[chosen_ammo]))
		to_chat(M, SPAN_WARNING("<b>[ammo_choices[chosen_ammo]]</b> ammunition is already selected or no <b>[ammo_choices[chosen_ammo]]</b> ammo left."))
		return

	//reusing var for output message
	chosen_ammo = "Switched ammunition to <b>[HP.ammo.ammo_tag]</b>.\n"
	chosen_ammo += "Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b>\n"
	chosen_ammo += HP.get_ammo_report()
	to_chat(M, SPAN_NOTICE(chosen_ammo))
	return

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/unload_active_hardpoint()
	set name = "Unload Active Hardpoint"
	set category = "Vehicle.Hardpoints"
	set desc = "Allows you unload currently loaded ammunition in active hardpoint."

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/obj/item/hardpoint/HP = V.active_hp[seat]

	if(!HP)
		to_chat(M, SPAN_WARNING("No modules are currently active."))
		return

	if(HP.health <= 0)
		to_chat(M, SPAN_WARNING("\The [HP] is too damaged to be operated."))
		return

	if(alert(M, "Confirm unloading current weapon?", "Confirmation", "Yes", "No") == "No")
		return

	V.handle_hardpoint_unload(M, HP)
	return

//------------------------GENERAL VERBS-----------------
// Used to lock/unlock the vehicle doors to anyone without proper access
/obj/vehicle/multitile/proc/toggle_door_lock()
	set name = "Toggle Door Locks"
	set category = "Vehicle.Misc"
	set desc = "Toggles door locks in the vehicle, restricting access to those with Crewman, MP or Command access and making xenos take additional time to force their way in."

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return
	if(seat != VEHICLE_DRIVER)
		return

	V.door_locked = !V.door_locked
	to_chat(M, SPAN_NOTICE("You [V.door_locked ? "lock" : "unlock"] the vehicle doors."))

//switches between SHIFT + Click and Middle Mouse Button Click to fire not selected currently weapon
/obj/vehicle/multitile/proc/toggle_shift_click()
	set name = "Toggle Middle/Shift Clicking"
	set desc = "Toggles between using Middle Mouse Button (MMB) + Click and Shift + Click to fire not currently selected weapon if possible."
	set category = "Vehicle.Misc"

	var/obj/vehicle/multitile/V = usr.interactee
	if(!istype(V))
		return
	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == usr)
			seat = vehicle_seat
			break
	if(seat == VEHICLE_GUNNER)
		V.vehicle_flags ^= VEHICLE_TOGGLE_SHIFT_CLICK_GUNNER
		to_chat(usr, SPAN_NOTICE("You will fire not selected weapon with [(V.vehicle_flags & VEHICLE_TOGGLE_SHIFT_CLICK_GUNNER) ? "Shift + Click" : "Middle Mouse Button click"] now, if possible."))
	return

//opens vehicle status window with HP and ammo of hardpoints
/obj/vehicle/multitile/proc/get_status_info()
	set name = "Get Status Info"
	set desc = "Displays all available information about your vehicle in a small window with limited control over hardpoints."
	set category = "Vehicle.Misc"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	var/dat = "[V]<br>"
	dat += "Current armor resistances:<br>"
	var/list/resist_name = list("Bio" = "acid", "Slash" = "slash", "Bullet" = "bullet", "Expl" = "explosive", "Blunt" = "blunt")

	for(var/i in resist_name)
		var/resist = 1 - LAZYACCESS(V.dmg_multipliers, LAZYACCESS(resist_name, i))
		if(resist > 0)
			dat += "[resist * 100]% [i]|"
		else
			dat += "<font color=\"red\">[resist * 100]% [i]</font>|"

	dat += "<br>"

	if(V.health <= 0)
		dat += "Hull integrity: <b><font color=\"red\">\[CRITICAL FAILURE\]</font></b>"
	else
		dat += "Hull integrity: <b>[round(100.0 * V.health / initial(V.health))]%</b>"

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
		dat += "Doors <b><A href='?src=\ref[V];toggle_doors=1'>\[locks\]</A></b>: [V.door_locked ? "<font color=\"green\">Enabled</font>" : "<font color=\"red\">Disabled</font>"].<br>"

	V.interior.update_passenger_count()
	dat += "Common passengers capacity: [V.interior.passengers_taken_slots]/[V.interior.passengers_slots].<br>"

	for(var/datum/role_reserved_slots/RRS in V.interior.role_reserved_slots)
		dat += "[RRS.category_name] passengers capacity: [RRS.taken]/[RRS.total].<br>"

	show_browser(user, dat, "Vehicle Status Info", "vehicle_info", "size=430x600")
	onclose(user, "vehicle_info")
	return

//opens vehicle controls guide, that contains description of all verbs and shortcuts in it
/obj/vehicle/multitile/proc/open_controls_guide()
	set name = "Vehicle Controls Guide"
	set desc = "MANDATORY FOR FIRST PLAY AS VEHICLE CREWMAN OR AFTER UPDATES."
	set category = "Vehicle.MUST READ FOR ROOKIES"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	var/dat = "<b><i>Common verbs:</i></b><br>1. <b>\"Change Active Hardpoint\"</b> - brings up a list of all not destroyed activatable hardpoints you have access to and allows you to switch your current active hardpoint to one from the list. To activate currently selected hardpoint, click on your target. <font color='#cd6500'><b>MAKE SURE NOT TO HIT MARINES.</b></font><br>\
	 2. <b>\"Switch Ammo Type\"</b> - allows switching between available ammo types for active hardpoint.<br> \
	 3. <b>\"Unload Active Hardpoint\"</b> - unloads current ammo from active hardpoint.<br> \
	 4. <b>\"Name Vehicle\"</b> - used to add a custom name to the vehicle. Single use. 26 characters maximum.<br> \
	 5. <b>\"Get Status Info\"</b> - brings up \"Vehicle Status Info\" window with all available information about your vehicle which also allows to perform specific actions with hardpoints.<br> \
	<font color='#cd6500'><b><i>Driver verbs:</i></b></font><br> 1. <b>\"Activate Horn\"</b> - activates vehicle horn. Keep in mind, that vehicle horn is very loud and can be heard from afar by both allies and foes.<br> \
	 2. <b>\"Toggle Door Locks\"</b> - toggles vehicle's access restrictions. Crewman, Brig and Command accesses bypass these restrictions.<br> \
	<font color=\"red\"><b><i>Gunner verbs:</i></b></font><br> 1. <b>\"Cycle Active Hardpoint\"</b> - works similarly to one above, except it automatically switches to next hardpoint in a list allowing you to switch faster.<br> \
	 2. <b>\"Toggle Middle/Shift Clicking\"</b> - toggles between using <i>Middle Mouse Button</i> click and <i>Shift + Click</i> to fire not currently selected weapon if possible.<br> \
	 3. <b>\"Toggle Turret Gyrostabilizer\"</b> - toggles Turret Gyrostabilizer allowing it to keep current direction ignoring hull turning. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br> \
	 <b><i>Common shortcuts:</i></b><br> 1. <b>\"ALT + Click\"</b> - brings up ammo switching menu for active hardpoint.<br> \
	 2. <b>\"CTRL + Middle Mouse Button Click (MMB)\"</b> - unloads current ammo in active hardpoint.<br> \
	<font color='#cd6500'><b><i>Driver shortcuts:</i></b></font><br> 1. <b>\"CTRL + Click\"</b> - activates vehicle horn.<br> \
	<font color=\"red\"><b><i>Gunner shortcuts:</i></b></font><br> 1. <b>\"CTRL + SHIFT + Click\"</b> - toggles Turret Gyrostabilizer. <i>(Exists only on vehicles with rotating turret, e.g. M34A2 Longstreet Light Tank)</i><br> \
	 2. <b>\"CTRL + Click\"</b> - activates not destroyed activatable support module.<br> \
	 3. <b>\"Middle Mouse Button Click (MMB)\"</b> - default shortcut to shoot currently not selected weapon if possible. Won't work if <i>SHIFT + Click</i> firing is toggled ON.<br> \
	 4. <b>\"SHIFT + Click\"</b> - examines target as usual, unless <i>\"Toggle Middle/Shift Clicking\"</i> verb was used to toggle <i>SHIFT + Click</i> firing ON. In this case, it will fire currently not selected weapon if possible.<br> \
	<font color='#003300'><b><i>Support Gunner verbs:</i></b></font><br> 1. <b>\"Reload Firing Port Weapon\"</b> - initiates automated reloading process for M56 FPW. Requires a confirmation.<br> \
	<b><i>Extra tips:</i></b><br> \
	 1. Always listen to more experienced Crewman. This way you have better chance of survival and learning something.<br> \
	 2. It is recommended for <b>Gunner</b> to hide their HUD by pressing F12 few times to have unobstructed view over visible area.<br> \
	 3. Since <b>Driver</b> is almost constantly busy driving tank, <b>Gunner</b> is, often, the one to represent tank in radio communication and, therefore, is tank commander. It is also advised for <b>Driver</b> to switch off unneeded radio channels to be able to see messages from <b>Gunner</b> better. \
	 4. <b>Driver</b> has access to some hardpoints too, for example, they have exclusive access to M34A2-A Turret Smoke Screen."

	show_browser(user, dat, "Vehicle Controls Guide", "vehicle_help", "size=1020x700")
	onclose(user, "vehicle_help")
	return

//toggles gyrostabilizer for vehicles that have turret, allowing it to keep direction regardless hull rotations
/obj/vehicle/multitile/proc/toggle_gyrostabilizer()
	set name = "Toggle Turret Gyrostabilizer"
	set desc = "Toggles Turret Gyrostabilizer allowing it independant movement regardless of hull direction."
	set category = "Vehicle.Misc"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/obj/item/hardpoint/holder/tank_turret/T = null
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		T = TT
		break
	if(!T)
		return
	T.toggle_gyro(usr)

//single use verb that allows VCs to add a nickname in "" at the end of their vehicle name
/obj/vehicle/multitile/proc/name_vehicle()
	set name = "Name Vehicle"
	set desc = "Allows you to add a custom name to your vehicle. Single use. 26 characters maximum."
	set category = "Vehicle.Misc"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(V.nickname)
		to_chat(user, SPAN_WARNING("Vehicle already has a \"[V.nickname]\" nickname."))
		return

	var/new_nickname = stripped_input(user, "Enter a unique IC name or a callsign to add to your vehicle's name. [MAX_NAME_LEN] characters maximum. \n\nIMPORTANT! This is an IC nickname/callsign for your vehicle and you will be punished for putting in meme names.\nSINGLE USE ONLY.", "Name your vehicle", null, MAX_NAME_LEN)
	if(!new_nickname)
		return
	if(length(new_nickname) > MAX_NAME_LEN)
		alert(user, "Name [new_nickname] is over [MAX_NAME_LEN] characters limit. Try again.", "Naming vehicle failed", "Ok")
		return
	if(alert(user, "Vehicle's name will be [initial(V.name) + "\"[new_nickname]\""]. Confirm?", "Confirmation", "Yes", "No") == "No")
		return

	//post-checks
	if(V.seats[seat] != user)	//check that we are still in seat
		to_chat(user, SPAN_WARNING("You need to be buckled to vehicle seat to do this."))
		return

	if(V.nickname)	//check again if second VC was faster.
		to_chat(user, SPAN_WARNING("The other crewman beat you to it!"))
		return

	V.nickname = new_nickname
	V.name = initial(V.name) + " \"[V.nickname]\""
	to_chat(user, SPAN_NOTICE("You've added \"[V.nickname]\" nickname to your vehicle."))

	message_staff(WRAP_STAFF_LOG(user, "added \"[V.nickname]\" nickname to their [initial(V.name)]. ([V.x],[V.y],[V.z])"), V.x, V.y, V.z)

	V.initialize_cameras(TRUE)

//Activates vehicle horn. Yes, it is annoying.
/obj/vehicle/multitile/proc/activate_horn()
	set name = "Activate Horn"
	set desc = "Activates vehicle signal. Beep-beep."
	set category = "Vehicle.Misc"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(world.time < V.next_honk)
		to_chat(user, SPAN_WARNING("You need to wait [(V.next_honk - world.time) / 10] seconds."))
		return

	V.next_honk = world.time + 10 SECONDS
	to_chat(user, SPAN_NOTICE("You activate vehicle's horn."))
	V.perform_honk()

/obj/vehicle/multitile/proc/perform_honk()
	if(honk_sound)
		playsound(loc, honk_sound, 75, TRUE, 15)	//heard within ~15 tiles

//Support gunner verbs

/obj/vehicle/multitile/proc/reload_firing_port_weapon()
	set name = "Reload Firing Port Weapon"
	set desc = "Initiates firing port weapon automated reload process."
	set category = "Vehicle.Misc"

	var/mob/user = usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(V.health < initial(V.health) * 0.5)
		to_chat(user, SPAN_WARNING("\The [V]'s hull is too damaged to operate!"))

	for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in V.hardpoints)
		if(FPW.allowed_seat == seat)
			if(alert(user, "Initiate M56 FPW reload process? It will take [FPW.reload_time / 10] seconds.", "Initiate reload", "Yes", "No") == "Yes")
				FPW.start_auto_reload(user)
			return

	to_chat(user, SPAN_WARNING("Warning. No FPW for [seat] found, tell a dev!"))
