/obj/structure/weapons_loader
	name = "ammunition loader"
	desc = "A hefty piece of machinery that sorts, moves and loads various ammunition into the correct guns."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	var/obj/vehicle/multitile/vehicle = null

// Loading new magazines
/obj/structure/weapons_loader/attackby(var/obj/item/ammo_magazine/hardpoint/mag, var/mob/user)
	if(!istype(mag, /obj/item/ammo_magazine/hardpoint))
		return ..()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_CREWMAN))
		to_chat(user, SPAN_WARNING("You have no idea how to operate this thing!"))
		return

	// Check if any of the hardpoints accept the magazine
	var/obj/item/hardpoint/reloading_hardpoint = null
	for(var/obj/item/hardpoint/H in vehicle.get_hardpoints_with_ammo())
		if(QDELETED(H) || !H.backup_ammo)
			continue

		for(var/tag in H.backup_ammo)
			if(mag.ammo_tag == tag)
				reloading_hardpoint = H
				break
		if(reloading_hardpoint)
			break

	if(isnull(reloading_hardpoint))
		return ..()

	// Reload the hardpoint
	reloading_hardpoint.try_add_clip(mag, user)

// Hardpoint reloading
/obj/structure/weapons_loader/attack_hand(var/mob/living/carbon/human/user)

	if(!user || !istype(user))
		return

	vehicle.handle_hardpoint_unload(user)

// Landmark for spawning the reloader
/obj/effect/landmark/interior/spawn/weapons_loader
	name = "vehicle weapons reloader spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"
	color = "blue"

/obj/effect/landmark/interior/spawn/weapons_loader/on_load(var/datum/interior/I)
	var/obj/structure/weapons_loader/R = new(loc)

	R.icon = icon
	R.icon_state = icon_state
	R.layer = layer
	R.pixel_x = pixel_x
	R.pixel_y = pixel_y
	R.vehicle = I.exterior
	R.vehicle.Loader = R
	R.setDir(dir)
	R.update_icon()

	qdel(src)

obj/structure/weapons_loader/proc/unload_ammo()
	set name = "Unload Ammo"
	set category = "Object"
	set src in range(1)

	var/mob/living/carbon/human/H = usr
	if(!H || !istype(H))
		return

	//something went bad, try to reconnect to vehicle if user is currently buckled in and connected to vehicle
	if(!vehicle)
		if(isVehicle(H.interactee))
			vehicle = H.interactee
		if(!istype(vehicle))
			to_chat(H, SPAN_WARNING("Critical Error! Ahelp this! Code: T_VMIS"))
			return

	vehicle.handle_hardpoint_unload(H)
