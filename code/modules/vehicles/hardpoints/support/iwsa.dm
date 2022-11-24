/obj/item/hardpoint/support/weapons_boost
	name = "Armaments Systems Boost Module"
	desc = "Tank's support module. Armaments Systems Boost Module consists of two main components: integrated weapons sensor array which eases target tracking and improves the accuracy, and upgraded ammunition loading mechanism which increases fire rate of all installed armaments."

	icon_state = "weapons_boost"
	disp_icon = "tank"
	disp_icon_state = "weapons_boost"

	health = 250

	buff_multipliers = list(
		"cooldown" = 0.67,
		"accuracy" = 1.67
	)
