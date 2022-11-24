/obj/item/ammo_magazine/hardpoint/m56t
	name = "M56T Cupola IFF Magazine"
	desc = "An M56T Cupola magazine filled with IFF-compatible ammunition."
	caliber = "10x28mm" //Correlates with smartguns
	icon_state = "m56t"
	ammo_tag = "M56T IFF"
	default_ammo = /datum/ammo/bullet/smartgun/m56t_cupola
	max_rounds = 500
	gun_type = /obj/item/hardpoint/secondary/m56t

/obj/item/ammo_magazine/hardpoint/m56t/empty
	current_rounds = 0

/obj/item/ammo_magazine/hardpoint/m56t/ap
	name = "M56T Cupola AP Magazine"
	desc = "An M56T Cupola magazine filled Armor-Piercing ammunition. Not IFF-compatible! Watch friendly fire!"
	icon_state = "m56t_ap"
	ammo_tag = "M56T AP"
	default_ammo = /datum/ammo/bullet/smartgun/m56t_cupola/armor_piercing

/obj/item/ammo_magazine/hardpoint/m56t/ap/empty
	current_rounds = 0




/obj/item/ammo_magazine/hardpoint/m56t/re700
	name = "RE-RE700 Frontal Cannon Magazine"
	desc = "A big box of bullets that looks suspiciously similar to the box you would use to refill a M56 Cupola. The Bleihagel logo sticker has peeled slightly and it looks like there's another logo underneath..."
	icon_state = "re700"
	ammo_tag = "RE700 IFF"
	gun_type = /obj/item/hardpoint/secondary/re700

/obj/item/ammo_magazine/hardpoint/m56t/re700/empty
	current_rounds = 0
