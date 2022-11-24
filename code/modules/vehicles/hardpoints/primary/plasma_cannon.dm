/obj/effect/warning/plasma_cannon
	color = "#00CCFF"

// APC dual plasma cannon. Not a regular hardpoint weapon. Instead of normal shooting, it has a prep time and applies effect on whole area
/obj/item/hardpoint/primary/plasma_cannon
	name = "PARS-159 Boyars Plasma Cannon"
	desc = "APC's primary armament. A two-barrel cannon for the APC that shoots super hot plasma beam after small preparation cycle. A dedicated breach tool used to tear up holes in enemy fortifications for marines to charge in."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "plasma_cannon"
	disp_icon = "apc"
	disp_icon_state = "plasma_cannon"
	activation_sounds = list('sound/weapons/vehicles/plasma_cannon_prep.ogg')

	damage_multiplier = 0.2

	health = 500
	cooldown = 60 SECONDS
	accuracy = 0.98
	firing_arc = 60
	max_range = 6
	var/prep_time = 5 SECONDS

	//we use this to cancel firing plasma cannon if vehicle/hardpoint moves or turns during prep time
	var/turf/prep_vehicle_position
	var/prep_dir

	origins = list(0, 0)

	max_ammo = 3

	muzzle_flash_pos = list(
		"1" = list(10, -29),
		"2" = list(-10, 10),
		"4" = list(-14, 9),
		"8" = list(14, 9)
	)

/obj/item/hardpoint/primary/plasma_cannon/setup_mags()
	backup_ammo = list(
		"PARS-159" = list(),
		)
	return

/obj/item/hardpoint/primary/plasma_cannon/can_activate(var/mob/user, var/atom/A)
	if(!owner)
		return

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return

	if(health <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is broken!</b>"))
		return FALSE

	if(world.time < next_use)
		if(cooldown >= 20)	//filter out guns with high firerate to prevent message spam.
			to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((next_use - world.time) / 10)] seconds before [name] can be used again."))
		return FALSE

	if(ammo && ammo.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo!</b> Magazines: <b>[SPAN_HELPFUL(get_total_mags())]/[SPAN_HELPFUL(max_ammo)]</b>"))
		return FALSE

	if(!in_firing_arc(A))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return FALSE

	if(max_range && max_range < get_dist(get_turf(owner), A))
		to_chat(user, SPAN_WARNING("<b>The target is too far!</b>"))
		return FALSE

	return TRUE

/obj/item/hardpoint/primary/plasma_cannon/fire(var/mob/user, var/atom/A)
	if(!ammo)
		to_chat(user, SPAN_WARNING("WARNING. No ammunition is currently selected."))
		return

	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	fire_projectile(user, A)

//instead of actually firing a projectile, this proc gathers and marks tiles for AOE effect
/obj/item/hardpoint/primary/plasma_cannon/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/helper_turf = get_turf(src)
	prep_vehicle_position = helper_turf
	prep_dir = dir

	if(get_dist(prep_vehicle_position, A) < 2)
		to_chat(user, SPAN_WARNING("The target is too close."))
		return

	//we get lines of turfs for AOE
	var/list/list/tiles_lines[3]
	tiles_lines[1] = getline2(get_step(helper_turf, turn(dir, -90)), get_step(A, turn(dir, -90)))	//left tiles
	tiles_lines[2] = getline2(helper_turf, A)	//center tiles
	tiles_lines[3] = getline2(get_step(helper_turf, turn(dir, 90)), get_step(A, turn(dir, 90)))	//right tiles

	//remove first tiles which are under the vehicle
	for(var/list/L in tiles_lines)
		L.Cut(1,2)

	//a bit crude code that adds 2 more tiles past the one we clicked at, to ensure deep penetration of any potential defenses
	for(var/list/L in tiles_lines)
		if(!length(L))
			continue
		helper_turf = get_step(L[length(L)], dir)
		L += helper_turf
		helper_turf = get_step(helper_turf, dir)
		L += helper_turf

	helper_turf = null

	//this stores the index of a first obstruction, then either second tile after tile with obstruction or first impassible tile
	var/list/helper_list = list(0, 0, 0)
	var/helper_var = 0

	//impassible tile - tile that we can't go past (rocks, hulls, indestructible dense opaque objects (invincible podlocks) etc.)
	//penetrated tile - first obstacle tile + 2 more tiles right behind itthat will be hit, unless impassible
	//how this works: we go along the line until we find an obstruction: dense and opaque non-unacidable/non-hull object/turf,
	//tile's index with this turf is wrtten in helper list, this is the first tile of our "3-tiles deep defenses penetration"
	//then we continue going along the list. Hitting 3rd tile after finding obstruction OR finding impassible tile (hull turfs) stops us
	for(var/list/L in tiles_lines)
		var/list_index = 1
		//helper will store current tile's index
		helper_var = 1
		for(var/turf/T in L)
			if(helper_list[list_index] + 3 >= helper_var)
				L.Cut(helper_list[list_index] + 3)	//we cut off tiles past the third penetrated tile
				break
			if(T.density)
				helper_list[list_index] = helper_var
				if(istype(/turf/closed/wall, T))
					var/turf/closed/wall/W = T
					if(W.hull)
						L.Cut(helper_var)	//we cut off impassible
						break
				else
					L.Cut(helper_var)	//we cut off impassible
					break
			else
				var/break_it = FALSE
				for(var/obj/O in T.contents)
					if(O.density && O.opacity)
						helper_list[list_index] = helper_var
						if(unacidable)
							L.Cut(helper_var)	//we cut off impassible
							break_it = TRUE
							break
				if(break_it)
					break
			helper_var++
		list_index++

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)
	//all deployed marks are gathered in the list and will be worked with now
	var/list/marked = list()
	for(var/list/L in tiles_lines)
		for(var/turf/T in L)
			var/obj/effect/warning/plasma_cannon/W = new (T)
			marked += W


	helper_list.Cut()

	sleep(prep_time)

	if(prep_vehicle_position != get_turf(src) || prep_dir != dir)
		to_chat(user, SPAN_WARNING("<b>Cancelling firing procedure. \The [src] is recharging and will be ready to fire in 30 seconds.</b>"))
		next_use = world.time + 30 SECONDS
		return

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, tiles_lines[2][length(tiles_lines[2])]))

	tiles_lines.Cut()

	playsound(get_turf(src), 'sound/weapons/vehicles/plasma_cannon_fire.ogg', 60, 1)

	for(var/obj/effect/warning/plasma_cannon/W in marked)
		apply_plasma_on_mark(W, src, user)
		marked -= W

	ammo.current_rounds--
	to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo.current_rounds)]/[SPAN_HELPFUL(ammo.max_rounds)]</b> <b>[ammo.ammo_tag]</b> | Mags: <b>[SPAN_HELPFUL(get_total_mags())]/[SPAN_HELPFUL(max_ammo)]</b>"))

//this checks whether we should stop checking further turfs
/obj/item/hardpoint/primary/plasma_cannon/proc/stop_check(var/turf/T)
	if(T.density)
		if(istype(T, /turf/closed/wall))
			var/turf/closed/wall/W = T
			if(!W.hull)
				return FALSE
		return TRUE
	else
		for(var/obj/structure/window/W in T)
			if(W.unacidable)
				return TRUE
		return FALSE

/obj/item/hardpoint/primary/plasma_cannon/proc/apply_plasma_on_mark(var/obj/effect/warning/plasma_cannon/warn, var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	var/turf/T = get_turf(warn)
	qdel(warn)

	T.handle_plasma_cannon_hit(src, user)

	var/datum/reagent/napalm/blue/R = new()
	var/obj/flamer_fire/FF = new (T, PC, user, R, 0)
	//Burn bright, but fast
	FF.firelevel = 20//4
	return



//plasma hadnling procs
/atom/proc/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	return

/obj/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	if(unacidable)
		return
	qdel(src)

/mob/living/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	apply_damage(150, BURN)
	return

/obj/vehicle/multitile/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	take_damage_type(500, "abstract", user)
	return

/turf/open/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	for(var/atom/A in contents)
		A.handle_plasma_cannon_hit(PC, user)
	return

/turf/closed/wall/handle_plasma_cannon_hit(var/obj/item/hardpoint/primary/plasma_cannon/PC, var/mob/user)
	take_damage(damage_cap + 5)
	return
