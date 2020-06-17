/datum/gear/eyes/medical
	allowed_roles = list("Медик","Главврач","Химик","Парамедик","Geneticist", "Психиатр", "Военврач")

/datum/gear/eyes/meson
	display_name = "Optical Meson Scanners (Engineering, Science)"
	allowed_roles = list("Инженер","Главный инженер","Атмосферный техник", "Ученый", "Директор исследований", "Искатель", "Следопыт")

/datum/gear/eyes/arglasses
	display_name = "AR glasses"
	path = /obj/item/clothing/glasses/omnihud

/datum/gear/eyes/arglassespres
	display_name = "AR glasses, prescription"
	path = /obj/item/clothing/glasses/omnihud/prescription

/datum/gear/eyes/arglasses/sec
	display_name = "AR-S glasses (Sec)"
	path = /obj/item/clothing/glasses/omnihud/sec
	allowed_roles = list("Офицер безопасности","Глава безопасности","Надзиратель","Детектив")

/datum/gear/eyes/arglasses/eng
	display_name = "AR-E glasses (Eng)"
	path = /obj/item/clothing/glasses/omnihud/eng
	allowed_roles = list("Инженер","Главный инженер","Атмосферный техник")

/datum/gear/eyes/arglasses/med
	display_name = "AR-M glasses (Medical)"
	path = /obj/item/clothing/glasses/omnihud/med
	allowed_roles = list("Медик","Главврач","Химик","Парамедик","Geneticist", "Психиатр", "Военврач")

/datum/gear/eyes/arglasses/all
	display_name = "AR-B glasses (CD, HoP)"
	path = /obj/item/clothing/glasses/omnihud/all
	cost = 2
	allowed_roles = list("Директор колонии","Глава персонала")

/datum/gear/eyes/spiffygogs
	display_name = "slick orange goggles"
	path = /obj/item/clothing/glasses/fluff/spiffygogs

/datum/gear/eyes/science_proper
	display_name = "science goggles (no overlay)"
	path = /obj/item/clothing/glasses/fluff/science_proper

/datum/gear/eyes/security/secpatch
	display_name = "Security HUDpatch"
	path = /obj/item/clothing/glasses/hud/security/eyepatch

/datum/gear/eyes/medical/medpatch
	display_name = "Health HUDpatch"
	path = /obj/item/clothing/glasses/hud/health/eyepatch