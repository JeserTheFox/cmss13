//----------THIS IS VEHICLE ASRS STUFF------------------
//REQUISITIONS ASRS, UPON WHICH THIS ONE IS BASED IS IN supplyshuttle.dm

//---------------VEHICLE ORDERS-------------
/datum/vehicle_order
	var/name = "vehicle order"
	var/desc = "vehicle description"

	//vehicle type that spawns
	var/obj/vehicle/ordered_vehicle
	//whether this vehicle is unlocked for taking
	var/unlocked = TRUE
	//whether this vehicle was already retrieved
	var/taken = FALSE

/datum/vehicle_order/proc/on_created(var/obj/vehicle/multitile/V)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_VEHICLE_ORDERED, V)

	if(VehicleElevatorConsole)
		var/obj/structure/machinery/computer/supplycomp/vehicle/console = VehicleElevatorConsole
		console.vehicle_tokens--
	else
		to_world("#ERROR# Vehicles ASRS console not found")
	taken = TRUE
	return

/datum/vehicle_order/tank
	name = "M34A2 Longstreet Light Tank"
	desc = "A giant piece of armor with a big gun, you know what to do. Entrance in the back."
	ordered_vehicle = /obj/vehicle/multitile/tank/decrepit
	unlocked = FALSE

/datum/vehicle_order/apc
	name = "M577 Armored Personnel Carrier"
	desc = "An M577 Armored Personnel Carrier. An armored transport with four big wheels. Entrances on the sides and back."
	ordered_vehicle = /obj/vehicle/multitile/apc/decrepit

/datum/vehicle_order/apc/med
	name = "M577-MED Armored Personnel Carrier"
	desc = "A medical modification of the M577 Armored Personnel Carrier. An armored transport with four big wheels. Has compact surgery theater set up inside and stores a significant amount of medical supplies. Entrances on the sides."
	ordered_vehicle = /obj/vehicle/multitile/apc/medical/decrepit

/datum/vehicle_order/apc/cmd
	name = "M577-CMD Armored Personnel Carrier"
	desc = "A modification of the M577 Armored Personnel Carrier designed to act as a field commander vehicle. An armored transport with four big wheels. Has inbuilt techpod vendor at the back of it, sensor tower and a field command station installed inside. Entrances on the sides."
	ordered_vehicle = /obj/vehicle/multitile/apc/command/decrepit

//-------------VEHICLE ASRS CONSOLE--------------
/obj/structure/machinery/computer/supplycomp/vehicle
	name = "Vehicles ASRS console"
	desc = "A console for an Automated Storage and Retrieval System. This one is tied to a deep storage unit for vehicles."
	req_access = list()
	var/list/allowed_roles = list(JOB_CREWMAN, JOB_PMC_CREWMAN, JOB_UPP_CREWMAN)

	//we spend these on vehicles retrieval
	var/vehicle_tokens = 1
	//we can send vehicle down and get a point
	var/allow_refund = TRUE

	//all vehicles that are stored in vehicle ASRS
	var/list/vehicles_orders
	//vehicles that were on elevator when it was sent down and need to be refunded
	var/list/vehicles_to_refund
	//what vehicles can be refunded
	var/list/vehicles_allowed_to_refund
	//currently selected vehicle order
	var/datum/vehicle_order/current_order

	temp = null

/obj/structure/machinery/computer/supplycomp/vehicle/Initialize()
	. = ..()

	//need to change this once someone merges my APC update MR so I can finally un**** these stupid vehicle spawning subtypes
	vehicles_allowed_to_refund = list(
		/obj/vehicle/multitile/tank,
		/obj/vehicle/multitile/tank/decrepit,
		/obj/vehicle/multitile/apc,
		/obj/vehicle/multitile/apc/decrepit,
		/obj/vehicle/multitile/apc/medical,
		/obj/vehicle/multitile/apc/medical/decrepit,
		/obj/vehicle/multitile/apc/command,
		/obj/vehicle/multitile/apc/command/decrepit
	)

/obj/structure/machinery/computer/supplycomp/vehicle/proc/set_global_vehicle_asrs_console()
	VehicleElevatorConsole = src

/obj/structure/machinery/computer/supplycomp/vehicle/proc/setup_vehicle_orders()

	vehicles_orders = list(
		new/datum/vehicle_order/apc(),
		new/datum/vehicle_order/apc/med(),
		new/datum/vehicle_order/apc/cmd()
	)

	var/datum/vehicle_order/VO = new/datum/vehicle_order/tank()

	if(SSticker.mode && SSticker.mode.name == "extended")
		VO.unlocked = TRUE

	vehicles_orders += VO

//proc that returns data for elevator status and controls for interface
/obj/structure/machinery/computer/supplycomp/vehicle/proc/get_platform_text()
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.vehicle_shuttle
	var/dat = "\nPlatform position: "
	if (shuttle.has_arrive_time())
		dat += "Moving<BR>"
	else if(shuttle.at_station())
		if(shuttle.docking_controller)
			switch(shuttle.docking_controller.get_docking_status())
				if("docked")
					dat += "Raised<BR>"
				if("undocked")
					dat += "Lowered<BR>"
				if("docking")
					dat += "Raising<BR>"
				if("undocking")
					dat += "Lowering<BR>"
		else
			dat += "Raised<BR>"

		if(shuttle.can_launch())
			dat += "<A href='?src=\ref[src];send=1'>Lower platform</A>"
		else
			dat += "*ASRS is busy*"
	else
		dat += "Lowered<BR>"
		if (shuttle.can_launch())
			dat += "<A href='?src=\ref[src];send=1'>Raise platform</A>"
		else
			dat += "*ASRS is busy*"
	dat += "<hr>"
	dat += "<BR>"
	return dat

/obj/structure/machinery/computer/supplycomp/vehicle/attack_hand(var/mob/living/carbon/human/H as mob)
	if(inoperable())
		return

	//replaced Z-level restriction with role restriction.
	if(LAZYLEN(allowed_roles) && !allowed_roles.Find(H.job))
		to_chat(H, SPAN_WARNING("This console isn't for you."))
		return

	if(!allowed(H))
		to_chat(H, SPAN_DANGER("Access Denied."))
		return

	if(!VehicleElevatorConsole)
		set_global_vehicle_asrs_console()

	if(!vehicles_orders || !length(vehicles_orders))
		setup_vehicle_orders()

	H.set_interaction(src)
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.vehicle_shuttle

	var/dat
	if(!shuttle)
		dat += "\nWARNING! PLATFORM IS NOT RESPONSIVE"
	else
		if(temp)
			dat = temp
		else
			dat += get_platform_text()

			if(vehicle_tokens < 1)
				dat += "<font color=\"red\">No vehicles are available for retrieval.</font><br><br>"
			else
				dat += "[vehicle_tokens > 1 ? "<font color=\"green\"><b>[vehicle_tokens]</b></font> vehicles" : "<font color=\"green\"><b>[vehicle_tokens]</b></font> vehicle"] can be retrieved.<br><br>"

				for(var/d in vehicles_orders)
					var/datum/vehicle_order/VO = d

					if(VO.unlocked)
						if(VO.taken)
							dat += "[VO.name]: <font color=\"green\"><b>RETRIEVED</b></font>.<br>"
						else
							dat += "[VO.name]: <a href='?src=\ref[src];select_vehicle=\ref[VO]'>Select for retrieval</a><br>"
					else
						dat += "[VO.name]: <font color=\"red\"><b>UNAVAILABLE</b></font>.<br>"

				dat += {"<HR><A href='?src=\ref[H];mach_close=computer'>Close</A><br>"}

	show_browser(H, dat, "Vehicles Automated Storage and Retrieval System", "computer", "size=575x450")
	return

/obj/structure/machinery/computer/supplycomp/vehicle/Topic(href, href_list)
	if(LAZYLEN(allowed_roles) && !allowed_roles.Find(usr.job))		//replaced Z-level restriction with role restriction.
		to_chat(usr, SPAN_WARNING("This console isn't for you."))
		return

	if(!allowed(usr))
		to_chat(usr, SPAN_DANGER("Access Denied."))
		return

	if(!supply_controller)
		world.log << "## ERROR: Eek. The supply_controller controller datum is missing somehow."
		return

	var/datum/shuttle/ferry/supply/shuttle = supply_controller.vehicle_shuttle
	if (!shuttle)
		world.log << "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return

	if(..())
		return

	if(ismaintdrone(usr))
		return

	if(isturf(loc) && ( in_range(src, usr) || ishighersilicon(usr) ) )
		usr.set_interaction(src)

	//Calling the shuttle
	if(href_list["send"])
		if(shuttle.at_station())
			vehicles_to_refund = list()
			if(forbidden_atoms_check(shuttle.get_location_area()))
				temp = "<font color=\"red\"><b>For safety reasons, the Vehicle Automated Storage and Retrieval System cannot store live organisms, classified nuclear weaponry or homing beacons.</b></font>\
				<BR>If this error message appears during an attempt to store a USCM vehicle that is part of the [MAIN_SHIP_NAME] vehicle park, \
				that means that current Vehicle ASRS settings were overriden to only allow vehicle storage after operation is officially logged as finished in main ship log.<BR><BR>\
				<A href='?src=\ref[src];mainmenu=1'>OK</A>"
			else
				temp = "Lowering platform.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
				if(length(vehicles_to_refund))
					refund_vehicles()
				shuttle.launch(src)
		else
			if(current_order && current_order.unlocked && !current_order.taken)
				var/obj/vehicle/multitile/ordered_vehicle = new current_order.ordered_vehicle(GLOB.vehicle_elevator)
				current_order.on_created(ordered_vehicle)

			shuttle.launch(src)
			temp = "Raising platform.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			current_order = null

	else if (href_list["select_vehicle"])

		current_order = locate(href_list["select_vehicle"])
		if(!current_order || !current_order.unlocked)
			temp = null
			return

		temp = get_platform_text()

		temp += "<b>Selected vehicle:</b> [current_order.name]<BR>"
		temp += "<b>Vehicle description:</b> [current_order.desc]<BR>"
		temp += "<HR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A><BR><BR>"

	else if (href_list["mainmenu"])
		current_order = null
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/supplycomp/vehicle/proc/refund_vehicles()
	if(!length(vehicles_to_refund))
		return
	for(var/obj/vehicle/multitile/V in vehicles_to_refund)
		for(var/datum/vehicle_order/VO in vehicles_orders)
			if(istype(V, VO.ordered_vehicle))
				VO.taken = FALSE
				VO.unlocked = TRUE
				vehicle_tokens++
				SEND_GLOBAL_SIGNAL(COMSIG_GLOB_VEHICLE_REFUNDED, V)
				message_staff("\The [V] was refunded at Vehicle ASRS.")
				qdel(V)
				break

//vehicle ASRS has it's own version of this proc
/obj/structure/machinery/computer/supplycomp/vehicle/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/item/stack/sheet/mineral/phoron))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

	if(istype(A,/obj/vehicle))
		if(allow_refund && length(vehicles_allowed_to_refund) && vehicles_allowed_to_refund.Find(A.type))
			var/obj/vehicle/multitile/V = A
			if(V.interior && length(V.interior.get_passengers()) > 0)	//we have someone inside
				return 1
			if(!vehicles_to_refund.Find(V))
				vehicles_to_refund += V
		else
			return 1
