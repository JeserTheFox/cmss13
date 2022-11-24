/obj/item/ammo_magazine/hardpoint/minigun
	name = "M80 Minigun Magazine"
	desc = "An M80 Minigun magazine. What, did you expect some witty description?"
	caliber = "7.62x51mm"	//Correlates to miniguns
	icon_state = "minigun"
	ammo_tag = "M80"
	default_ammo = /datum/ammo/bullet/minigun/tank
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/minigun

/obj/item/ammo_magazine/hardpoint/minigun/empty
	current_rounds = 0

/obj/item/ammo_magazine/hardpoint/minigun/ap
	name = "M80 Minigun AP Magazine"
	desc = "An M80 Minigun magazine filled with Armor-Piercing ammunittion."
	icon_state = "minigun_ap"
	ammo_tag = "M80 AP"
	default_ammo = /datum/ammo/bullet/minigun/tank/ap

/obj/item/ammo_magazine/hardpoint/minigun/ap/empty
	current_rounds = 0
