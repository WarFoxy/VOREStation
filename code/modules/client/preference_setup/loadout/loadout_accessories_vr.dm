// Collars

/datum/gear/choker //A colorable choker
	display_name = "choker (colorable, tagless)"
	path = /obj/item/clothing/accessory/choker
	slot = slot_tie
	sort_category = "Аксессуары"

/datum/gear/choker/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/collar
	display_name = "collar, silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = slot_tie
	sort_category = "Аксессуары"

/datum/gear/collar/New()
	..()
	gear_tweaks = list(gear_tweak_collar_tag)

/datum/gear/collar/golden
	display_name = "collar, golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/gear/collar/bell
	display_name = "collar, bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/gear/collar/shock
	display_name = "collar, shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/gear/collar/spike
	display_name = "collar, spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/gear/collar/pink
	display_name = "collar, pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/gear/collar/holo
	display_name = "collar, holo"
	path = /obj/item/clothing/accessory/collar/holo

//TFF 17/6/19 - public loadout addition: Indigestible Holocollar
/datum/gear/collar/holo/indigestible
	display_name = "collar, holo (indigestible)"
	path = /obj/item/clothing/accessory/collar/holo/indigestible

/datum/gear/accessory/holster
	display_name = "holster selection (Security, CD, HoP, Exploration)"
	allowed_roles = list("Директор колонии", "Глава персонала", "Офицер безопасности", "Надзиратель", "Глава безопасности","Детектив","Искатель","Следопыт")

/datum/gear/accessory/brown_vest
	display_name = "webbing, brown (Eng, Sec, Med, Exploration, Miner)"
	allowed_roles = list("Инженер","Атмосферный техник","Главный инженер","Офицер безопасности","Детектив","Глава безопасности","Надзиратель","Парамедик","Главврач","Медик","Химик","Военврач","Искатель","Следопыт","Шахтер")

/datum/gear/accessory/black_vest
	display_name = "webbing, black (Eng, Sec, Med, Exploration, Miner)"
	allowed_roles = list("Инженер","Атмосферный техник","Главный инженер","Офицер безопасности","Детектив","Глава безопасности","Надзиратель","Парамедик","Главврач","Медик","Химик","Военврач","Искатель","Следопыт","Шахтер")

/datum/gear/accessory/white_vest
	display_name = "webbing, white (Medical)"
	allowed_roles = list("Парамедик","Главврач","Медик","Химик","Военврач")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, brown (Eng, Sec, Med, Exploration, Miner)"
	allowed_roles = list("Инженер","Атмосферный техник","Главный инженер","Офицер безопасности","Детектив","Глава безопасности","Надзиратель","Парамедик","Главврач","Медик","Химик","Военврач","Искатель","Следопыт","Шахтер")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, black (Eng, Sec, Med, Exploration, Miner)"
	allowed_roles = list("Инженер","Атмосферный техник","Главный инженер","Офицер безопасности","Детектив","Глава безопасности","Надзиратель","Парамедик","Главврач","Медик","Химик","Военврач","Искатель","Следопыт","Шахтер")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, white (Medical)"
	allowed_roles = list("Парамедик","Главврач","Медик","Химик","Военврач")

/datum/gear/accessory/webbing
	cost = 1

/datum/gear/accessory/stethoscope
	allowed_roles = list("Главврач","Медик","Химик","Психиатр","Парамедик", "Военврач")

/datum/gear/accessory/khcrystal
	display_name = "KH Life Crystal"
	path = /obj/item/weapon/storage/box/khcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/tronket
	display_name = "metal necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/tronket

/datum/gear/accessory/pilotpin
	display_name = "pilot qualification pin"
	description = "An iron pin denoting the qualification to fly SCG spacecraft."
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	allowed_roles = list("Следопыт", "Пилот", "Военврач")

/datum/gear/accessory/flops
	display_name = "drop straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)
