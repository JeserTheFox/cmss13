/obj/item/ammo_magazine/hardpoint/plasma_cannon
	name = "PARS-159 Plasma Cannon Battery"
	desc = "A combined battery-tank filled with classified substance, that works as a base for producing plasma beam in PARS-159 Boyars Dual Plasma Cannon."
	caliber = "20mm"
	icon_state = "plasma_cannon"
	ammo_tag = "PARS-159"
	default_ammo = /datum/ammo/bullet //doesn't actually use any bullets
	max_rounds = 5
	gun_type = /obj/item/hardpoint/primary/plasma_cannon

/obj/item/ammo_magazine/examine(mob/user)
	var/msg = "[icon2html(src, user)] That's \a [name].\n"
	msg += desc

	if(current_rounds < 0)
		msg += "Something went horribly wrong. Ahelp the following: ERROR CODE R1: negative current_rounds on examine."
		log_debug("ERROR CODE R1: negative current_rounds on examine. User: <b>[usr]</b>")
	else
		msg += "\The [src] has enough charge for <b>[current_rounds]</b> shots out of <b>[max_rounds]</b> left."

	to_chat(user, msg)

/obj/item/ammo_magazine/hardpoint/plasma_cannon/empty
	current_rounds = 0
