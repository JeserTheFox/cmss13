/obj/item/hardpoint/secondary/flamer
	name = "LZR-N Flamer Unit"
	desc = "Tank's secondary armament. Flamer unit TODO DESCRIPTION"

	icon_state = "lzrn_flamer"
	disp_icon = "tank"
	disp_icon_state = "lzrn_flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 300
	cooldown = 30
	accuracy = 0.68
	firing_arc = 120

	origins = list(0, -2)

	max_ammo = 2

	use_muzzle_flash = FALSE

	px_offsets = list(
		"1" = list(2, 14),
		"2" = list(-2, 3),
		"4" = list(3, 0),
		"8" = list(-3, 18)
	)

/obj/item/hardpoint/secondary/flamer/setup_mags()
	backup_ammo = list(
		"LZR-N Napalm" = list(),
		)
	return

/obj/item/hardpoint/secondary/flamer/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/range = get_dist(origin_turf, A) + 1

	var/obj/item/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, owner.seats[VEHICLE_GUNNER])
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, range < P.ammo.max_range ? range : P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, A))

	ammo.current_rounds--
