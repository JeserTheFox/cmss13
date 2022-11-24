//*******************************************************************************
//TANK Modules and Ammo
//*******************************************************************************/

//**************************LTB***************************************/
/datum/supply_packs/ammo_ltb_cannon
	name = "LTB cannon magazines (x3)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/ltb,
					/obj/item/ammo_magazine/hardpoint/ltb,
					/obj/item/ammo_magazine/hardpoint/ltb)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB cannon ammo crate"
	group = "Vehicle Modules and Ammo"



/datum/supply_packs/ammo_ltb_he
	name = "LTB cannon HE magazine (x1)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/ltb/he)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB cannon HE ammo crate"
	group = "Vehicle Modules and Ammo"

/datum/supply_packs/ammo_ltb_ap
	name = "LTB cannon AP magazine (x1)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/ltb/ap)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB cannon AP ammo crate"
	group = "Vehicle Modules and Ammo"

/datum/supply_packs/ammo_ltb_heap
	name = "LTB cannon HEAP magazine (x1)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/ltb/heap)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB cannon HEAP ammo crate"
	group = "Vehicle Modules and Ammo"

/datum/supply_packs/ammo_ltb_frg
	name = "LTB cannon FRG magazine (x1)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/ltb/frg)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB cannon FRG ammo crate"
	group = "Vehicle Modules and Ammo"


//**************************MINIGUN***************************************/

/datum/supply_packs/ammo_minigun
	name = "M80 minigun magazines (x3)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/minigun,
					/obj/item/ammo_magazine/hardpoint/minigun,
					/obj/item/ammo_magazine/hardpoint/minigun)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M80 minigun ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************ACE AUTOCANNON***************************************/

/datum/supply_packs/ammo_autocannon
	name = "AC3-E autocannon magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/autocannon,
					/obj/item/ammo_magazine/hardpoint/autocannon)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "AC3-E autocannon ammo crate"
	group = "Vehicle Modules and Ammo"

/datum/supply_packs/ammo_autocannon_iff
	name = "AC3-E autocannon IFF magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/autocannon/iff,
					/obj/item/ammo_magazine/hardpoint/autocannon/iff)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "AC3-E autocannon IFF ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************DRAGON FLAMER***************************************/

/datum/supply_packs/ammo_drgn_flamer
	name = "DRG-N offensive flamer unit fuel tanks (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/dragon_flamer,
					/obj/item/ammo_magazine/hardpoint/dragon_flamer)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "DRG-N Flamer fuel tanks crate"
	group = "Vehicle Modules and Ammo"

//**************************GRENADE LAUNCHER***************************************/

/datum/supply_packs/ammo_glauncher
	name = "M92T grenade launcher magazines (x4)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/tank_glauncher,
					/obj/item/ammo_magazine/hardpoint/tank_glauncher,
					/obj/item/ammo_magazine/hardpoint/tank_glauncher,
					/obj/item/ammo_magazine/hardpoint/tank_glauncher)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M92T grenade launcher ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************TURRET SMOKE SCREEN***************************************/

/datum/supply_packs/ammo_slauncher
	name = "Tank turret smoke screen magazines (x4)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/turret_smoke,
					/obj/item/ammo_magazine/hardpoint/turret_smoke,
					/obj/item/ammo_magazine/hardpoint/turret_smoke,
					/obj/item/ammo_magazine/hardpoint/turret_smoke)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "tank turret smoke screen ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************TOW LAUNCHER***************************************/

/datum/supply_packs/ammo_tow
	name = "M71 TOW launcher HE magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/tow,
					/obj/item/ammo_magazine/hardpoint/tow)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M71 TOW launcher HE ammo crate"
	group = "Vehicle Modules and Ammo"

/datum/supply_packs/ammo_tow_ap
	name = "M71 TOW launcher AP magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/tow/ap,
					/obj/item/ammo_magazine/hardpoint/tow/ap)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M71 TOW launcher AP ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************M56T CUPOLA***************************************/

/datum/supply_packs/ammo_m56t
	name = "M56T Cupola magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/m56t,
					/obj/item/ammo_magazine/hardpoint/m56t)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M56T Cupola ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************LZR-N FLAMER***************************************/

/datum/supply_packs/ammo_lzrn_flamer
	name = "LZR-N flamer unit fuel tanks (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/lzrn_flamer,
					/obj/item/ammo_magazine/hardpoint/lzrn_flamer)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "LZR-N flamer fuel tanks crate"
	group = "Vehicle Modules and Ammo"

//*******************************************************************************
//APC Modules and Ammo
//*******************************************************************************/

//**************************PLASMA CANNON***************************************/

/datum/supply_packs/plasma_cannon
	name = "PARS-159 Boyars Plasma Cannon magazines (x5)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/plasma_cannon,
					/obj/item/ammo_magazine/hardpoint/plasma_cannon,
					/obj/item/ammo_magazine/hardpoint/plasma_cannon)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "PARS-159 plasma cannon ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************RE700 FRONTAL CANNON***************************************/

/datum/supply_packs/ammo_frontalcannon
	name = "Bleihagel RE-RE700 frontal cannon magazines (x2)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/m56t/re700,
					/obj/item/ammo_magazine/hardpoint/m56t/re700)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "RE-RE700 frontal cannon ammo crate"
	group = "Vehicle Modules and Ammo"

//**************************FLARE LAUNCHER***************************************/

/datum/supply_packs/ammo_flarelauncher
	name = "M-87F flare launcher magazines (x5)"
	contains = list(
					/obj/item/ammo_magazine/hardpoint/flare_launcher,
					/obj/item/ammo_magazine/hardpoint/flare_launcher,
					/obj/item/ammo_magazine/hardpoint/flare_launcher,
					/obj/item/ammo_magazine/hardpoint/flare_launcher,
					/obj/item/ammo_magazine/hardpoint/flare_launcher)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M-87F flare launcher ammo crate"
	group = "Vehicle Modules and Ammo"
