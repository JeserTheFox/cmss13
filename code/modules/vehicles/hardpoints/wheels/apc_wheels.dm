/obj/item/hardpoint/locomotion/apc_wheels
	name = "APC Wheels"
	desc = "APC's locomotion module. Each of the wheels can steer independently for increased maneuverability. The tires are armoured against small-arms fire and shrapnel."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	damage_multiplier = 0.15

	icon_state = "wheels"
	disp_icon = "apc"
	disp_icon_state = "wheels"

	health = 500

	move_delay = VEHICLE_SPEED_SUPERFAST
	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.5
