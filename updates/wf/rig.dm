/obj/item/weapon/rig/lc

	name = "EOD inquisitor voidsuit"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Covered in religious symbols."
	icon = 'updates/wf/icons/obj/rig_modules.dmi'
	icon_state = "lc_rig"
	mob_icon  = 'updates/wf/icons/mob/rig_back.dmi'
	icon_override = 'updates/wf/icons/mob/rig_back.dmi'
	cell_type = /obj/item/weapon/cell/infinite
	armor = list(melee = 90, bullet = 90, laser = 90,energy = 90, bomb = 90, bio = 100, rad = 100)
	slowdown = 0
	emp_protection = 100
	offline_slowdown = 0
	offline_vision_restriction = 0
	siemens_coefficient= 0.75
	rigsuit_max_pressure = 40 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	rigsuit_min_pressure = 0

	helm_type = /obj/item/clothing/head/helmet/space/rig/lc
	chest_type = /obj/item/clothing/suit/space/rig/lc
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/lc
	boot_type = /obj/item/clothing/shoes/magboots/rig/lc

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/weapon/rcd,
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/gun
		)

	req_access = list()
	req_one_access = list()
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/rig/lc
	icon = 'updates/wf/icons/obj/spacesuits.dmi'
	icon_override = 'updates/wf/icons/mob/spacesuit.dmi'

/obj/item/clothing/gloves/gauntlets/rig/lc
	icon = 'updates/wf/icons/obj/gloves.dmi'
	icon_override = 'updates/wf/icons/mob/hands.dmi'
	name = "insulated gauntlets"
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/rig/lc
	icon = 'updates/wf/icons/obj/hats.dmi'
	icon_override = 'updates/wf/icons/mob/head.dmi'
	camera_networks = list(NETWORK_COMMAND)

/obj/item/weapon/rig/lc/equipped

	req_access = list(access_captain)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp,
		/obj/item/rig_module/mounted/mop,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/fabricator,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/vision/multi
		)

/obj/item/clothing/shoes/magboots/rig/lc
	icon = 'updates/wf/icons/obj/shoes.dmi'
	icon_override = 'updates/wf/icons/mob/feet.dmi'
	name = "advanced boots"
/obj/item/clothing/shoes/magboots/rig/lc/set_slowdown()
	if(magpulse)
		slowdown = shoes ? max(SHOES_SLOWDOWN, shoes.slowdown) : SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	else if(shoes)
		slowdown = shoes.slowdown
	else
		slowdown = SHOES_SLOWDOWN