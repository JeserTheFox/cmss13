
//Adapted autofire from M2C

/obj/vehicle/multitile/proc/check_hardpoint_autofire(var/mob/user, var/obj/item/hardpoint/HP)
	if(user.client)
		if(HP.auto_fire_support)
			to_world("signals registered")
			RegisterSignal(user.client, COMSIG_CLIENT_LMB_DOWN, .proc/auto_fire_start)
			RegisterSignal(user.client, COMSIG_CLIENT_LMB_UP, .proc/auto_fire_stop)
			RegisterSignal(user.client, COMSIG_CLIENT_LMB_DRAG, .proc/auto_fire_new_target)
		else
			to_world("signals unregistered")
			UnregisterSignal(user.client, list(
				COMSIG_CLIENT_LMB_DOWN,
				COMSIG_CLIENT_LMB_UP,
				COMSIG_CLIENT_LMB_DRAG,
			))

/obj/vehicle/multitile/proc/auto_fire_start(client/source, atom/A, params)
	SIGNAL_HANDLER
	if(params["shift"] || params["ctrl"] || params["alt"])
		return
	if(istype(A, /obj/screen))
		return

	var/obj/item/hardpoint/HP = active_hp[get_mob_seat(source.mob)]
	if(!HP || !HP.auto_fire_support)
		return

	HP.autofire_target = A

	INVOKE_ASYNC(src, .proc/auto_fire_repeat, source.mob, HP)

/obj/vehicle/multitile/proc/auto_fire_repeat(var/mob/user, var/obj/item/hardpoint/HP)
	if(!HP || !HP.autofire_target)
		return

	if(HP.can_activate(user, HP.autofire_target))
		HP.fire(user, HP.autofire_target, TRUE)

	addtimer(CALLBACK(src, .proc/auto_fire_repeat, user, HP), HP.cooldown * misc_multipliers["cooldown"])

/obj/vehicle/multitile/proc/auto_fire_stop(client/source, atom/A, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/HP = active_hp[get_mob_seat(source.mob)]
	if(HP)
		HP.autofire_target = null

/obj/vehicle/multitile/proc/auto_fire_new_target(client/source, atom/start, atom/hovered, atom/A, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/HP = active_hp[get_mob_seat(source.mob)]
	if(istype(hovered, /obj/screen))
		return

	if(HP)
		HP.autofire_target = hovered
