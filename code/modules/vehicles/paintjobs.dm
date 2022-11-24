/*
Base camo (Avilable for JOB_PLAYTIME_TIER_1 playtime):
1. Tree Frog
2. Desert Fox
3. -
4. -

Full camo (Available for JOB_PLAYTIME_TIER_2 playtime):
1. Jaeger
2. -
3. -
4. -

Custom paintjobs Tier 1 (Available for JOB_PLAYTIME_TIER_2 playtime)
1. Cat (Yellow eyes)
2. Cat (Green eyes)
3. Cat (Blue eyes)
4. Supernova (Some flames on turret)

Custom paintjobs Tier 2 (Available for JOB_PLAYTIME_TIER_3 playtime)
1. -
2. -
3. -

Free game (Every camo and custom paintjobs available regardless of current map upon reaching JOB_PLAYTIME_TIER_4)
*/


/*
Testing
maps = list(MAP_LV_624)

Green Biom
	maps = list(MAP_LV_624, MAP_WHISKEY_OUTPOST, MAP_CORSAT)
Sand Biom
	maps = list(MAP_BIG_RED, MAP_DESERT_DAM, MAP_CORSAT, MAP_KUTJEVO)
Snow Biom
	maps = list(MAP_ICE_COLONY, MAP_SOROKYNE_STRATA, MAP_CORSAT)
Snow Biom
	maps = list(MAP_PRISON_STATION, MAP_PRISON_STATION_V3, MAP_CORSAT)
*/



/datum/vehicle_paintjob
	var/name = "Name"				//name of the camo/paintjob it is known as
	var/desc = "Description"		//paintjob fluff description.
	var/list/vehicle = list()		//type of vehicle it's applied to
	var/list/maps = list()			//which maps this camo available on. Paintjobs don't have this restriction. 30+ hours can use any paintjob on any map.
	var/icon_tag = ""				//icon icon_tag
	var/play_time_req = 0			//required playtime as VC to unlock

//vehicle camo

/datum/vehicle_paintjob/camo
	name = "Factory Steel"
	desc = "Default USCM paint job, applied once vehicle is fabricated."

/datum/vehicle_paintjob/camo/grass
	name = "Tree Frog"
	desc = "Basic USCM single-tone woodland type vehicle camouflage pattern. Makes vehicle's silhouette less noticeable at distance, however won't help from wary spotter with binoculars."
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	maps = list(MAP_LV_624, MAP_WHISKEY_OUTPOST, MAP_CORSAT)
	icon_tag = "_grass"
	//play_time_req = JOB_PLAYTIME_TIER_1

/datum/vehicle_paintjob/camo/jungle
	name = "Jaeger"
	desc = "Advanced USCM multi-colored woodland type vehicle camouflage pattern. Significantly lowers vehicle visibility in dense vegetation areas."
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	maps = list(MAP_LV_624, MAP_WHISKEY_OUTPOST, MAP_CORSAT)
	icon_tag = "_jungle"
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/camo/desert
	name = "Desert Fox"
	desc = "Basic USCM single-tone desert type vehicle camouflage pattern. Developed for operations in desert bioms."
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_BIG_RED, MAP_DESERT_DAM, MAP_CORSAT, MAP_KUTJEVO)
	maps = list(MAP_LV_624)
	icon_tag = "_desert"
	//play_time_req = JOB_PLAYTIME_TIER_1

/datum/vehicle_paintjob/camo/rock
	name = "ROCKS WIP"
	desc = "WIP"
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_BIG_RED, MAP_DESERT_DAM, MAP_CORSAT, MAP_KUTJEVO)
	maps = list(MAP_LV_624, MAP_CORSAT)
	icon_tag = "_rock"
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/camo/ice
	name = "SNOW WIP"
	desc = "WIP"
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_ICE_COLONY, MAP_SOROKYNE_STRATA, MAP_CORSAT)
	icon_tag = ""
	//play_time_req = JOB_PLAYTIME_TIER_1

/datum/vehicle_paintjob/camo/ice_full
	name = "WINTER WIP"
	desc = "WIP"
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_ICE_COLONY, MAP_SOROKYNE_STRATA, MAP_CORSAT)
	icon_tag = ""
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/camo/black
	name = "BLACK WIP"
	desc = "WIP"
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_PRISON_STATION, MAP_PRISON_STATION_V3, MAP_CORSAT)
	icon_tag = ""
	//play_time_req = JOB_PLAYTIME_TIER_1

/datum/vehicle_paintjob/camo/black_full
	name = "DIGITAL WIP"
	desc = "WIP"
	vehicle = list(/obj/vehicle/multitile/tank, /obj/vehicle/multitile/apc)
	//maps = list(MAP_PRISON_STATION, MAP_PRISON_STATION_V3, MAP_CORSAT)
	icon_tag = ""
	//play_time_req = JOB_PLAYTIME_TIER_2

//custom paintjobs

/datum/vehicle_paintjob/custom/cat_yellow
	name = "Cat Eyes (Yellow)"
	desc = "Custom paint job in a form of two animal eyes. This version has yellow colored eyes. It is applied to tank turret's side panels near the main gun.\nFirst time painted by tank crewman Sergeant First Class Bridsky on his M22A3 Jackson medium tank. SFC Bridsky claimed that paint job represents cat eyes. Most of his fellow marines, however, called it \"Evil Eyes\" and believed that it brings bad luck."
	vehicle = list(/obj/vehicle/multitile/tank)
	icon_tag = "cat_yellow"
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/custom/cat_green
	name = "Cat Eyes (Green)"
	desc = "Custom paint job in a form of two animal eyes. This version has green colored eyes. It is applied to tank turret's side panels near the main gun.\nFirst time painted by tank crewman Sergeant First Class Bridsky on his M22A3 Jackson medium tank. SFC Bridsky claimed that paint job represents cat eyes. Most of his fellow marines, however, called it \"Evil Eyes\" and believed that it brings bad luck."
	vehicle = list(/obj/vehicle/multitile/tank)
	icon_tag = "cat_green"
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/custom/cat_blue
	name = "Cat Eyes (Blue)"
	desc = "Custom paint job in a form of two animal eyes. This version has blue colored eyes. It is applied to tank turret's side panels near the main gun.\nFirst time painted by tank crewman Sergeant First Class Bridsky on his M22A3 Jackson medium tank. SFC Bridsky claimed that paint job represents cat eyes. Most of his fellow marines, however, called it \"Evil Eyes\" and believed that it brings bad luck."
	vehicle = list(/obj/vehicle/multitile/tank)
	icon_tag = "cat_blue"
	//play_time_req = JOB_PLAYTIME_TIER_2

/datum/vehicle_paintjob/custom/supernova
	name = "Supernova"
	desc = "Custom paint job in a form of flames from explosion. It is applied to turrets front area around primary weapon mount spot.\nThis is undoubtedly one of the most generic possible custom paint jobs for a vehicle. Very bright colors also ruin any type of camouflage vehicle has."
	vehicle = list(/obj/vehicle/multitile/tank)
	icon_tag = "supernova"
	//play_time_req = JOB_PLAYTIME_TIER_2
