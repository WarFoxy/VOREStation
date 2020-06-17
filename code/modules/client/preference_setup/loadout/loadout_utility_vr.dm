/datum/gear/utility/saddlebag
	display_name = "saddle bag, horse"
	path = /obj/item/weapon/storage/backpack/saddlebag
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common
	display_name = "saddle bag, common"
	path = /obj/item/weapon/storage/backpack/saddlebag_common
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/robust
	display_name = "saddle bag, robust"
	path = /obj/item/weapon/storage/backpack/saddlebag_common/robust
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/vest
	display_name = "taur duty vest (backpack)"
	path = /obj/item/weapon/storage/backpack/saddlebag_common/vest
	slot = slot_back
	cost = 1

/datum/gear/utility/dufflebag
	display_name = "dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag
	slot = slot_back
	cost = 2

/datum/gear/utility/dufflebag/black
	display_name = "black dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
	display_name = "medical dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/med
	allowed_roles = list("Медик","Главврач","Химик","Парамедик","Geneticist","Психиатр","Военврач")

/datum/gear/utility/dufflebag/med/emt
	display_name = "EMT dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
	display_name = "security Dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/sec
	allowed_roles = list("Глава безопасности","Надзиратель","Детектив","Офицер безопасности")

/datum/gear/utility/dufflebag/eng
	display_name = "engineering dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/eng
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер")

/datum/gear/utility/dufflebag/sci
	display_name = "science dufflebag"
	path = /obj/item/weapon/storage/backpack/dufflebag/sci
	allowed_roles = list("Директор исследований","Ученый","Роботехник","Ксенобиолог","Искатель","Следопыт")
