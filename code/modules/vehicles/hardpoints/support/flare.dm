/obj/item/hardpoint/support/flare_launcher
	name = "M-87F Flare Launcher"
	desc = "APC's support module. M-87F Flare Launcher allows APC crew to illuminate surrounding area with flares for advancing infantry. It is said that some talented technician from the 3rd brigade converted one of these to launch fireworks. For some reason, their work was taken away and blueprints classified."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "flare_launcher"
	disp_icon = "apc"
	disp_icon_state = "flare_launcher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	damage_multiplier = 0.1

	activatable = TRUE

	health = 500
	cooldown = 30
	accuracy = 0.7
	firing_arc = 120

	origins = list(0, -2)

	max_ammo = 5

	use_muzzle_flash = FALSE

/obj/item/hardpoint/support/flare_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/support/flare_launcher/setup_mags()
	backup_ammo = list(
		"M-87F Flare" = list(),
		)
	return
