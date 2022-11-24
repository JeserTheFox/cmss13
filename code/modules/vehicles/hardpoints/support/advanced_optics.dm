/obj/item/hardpoint/support/advanced_optics
	name = "Advanced Optics Module"
	desc = "Tank's support module. Advanced Optics Module is a pre-made and tuned package consisting of high-quality optical lens and a bunch of electronics, that provides high-definition zoom. Installed AOM significantly increases effective engagement range of a tank. Works only for gunner, can be toggled ON and OFF. View amplification works in the current direction of turret despite module being mounted in support slot on a hull, which often leads to a confusion among rookies."

	icon_state = "adv_optics"
	disp_icon = "tank"
	disp_icon_state = "adv_optics"

	health = 250

	activatable = TRUE

	var/is_active = 0
	var/view_buff = 10 //This way you can VV for more or less fun
	var/view_tile_offset = 7

/obj/item/hardpoint/support/advanced_optics/activate(var/mob/user, var/atom/A)
	if(!user.client)
		return

	if(is_active)
		user.client.change_view(8)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		is_active = FALSE
		return

	var/atom/holder = owner
	for(var/obj/item/hardpoint/holder/tank_turret/T in owner.hardpoints)
		holder = T
		break

	user.client.change_view(view_buff)
	is_active = TRUE

	switch(holder.dir)
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

/obj/item/hardpoint/support/advanced_optics/deactivate()
	if(!is_active)
		return

	var/obj/vehicle/multitile/C = owner
	for(var/seat in C.seats)
		if(!ismob(C.seats[seat]))
			continue
		var/mob/user = C.seats[seat]
		if(!user.client) continue
		user.client.change_view(8)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	is_active = FALSE

/obj/item/hardpoint/support/advanced_optics/can_activate()
	if(health <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] is broken!"))
		return FALSE
	return TRUE
