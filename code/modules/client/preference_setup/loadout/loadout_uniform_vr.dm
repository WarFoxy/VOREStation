/datum/gear/uniform/suit/permit
	display_name = "nudity permit"
	path = /obj/item/clothing/under/permit

//Polaris overrides
/datum/gear/uniform/solgov/pt/sifguard
	display_name = "pt uniform, planetside sec"
	path = /obj/item/clothing/under/solgov/pt/sifguard

//KHI Uniforms
/datum/gear/uniform/job_khi/cmd
	display_name = "khi uniform, cmd"
	path = /obj/item/clothing/under/rank/khi/cmd
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_khi/sec
	display_name = "khi uniform, sec"
	path = /obj/item/clothing/under/rank/khi/sec
	allowed_roles = list("Глава безопасности", "Надзиратель", "Детектив", "Офицер безопасности")

/datum/gear/uniform/job_khi/med
	display_name = "khi uniform, med"
	path = /obj/item/clothing/under/rank/khi/med
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Военврач")

/datum/gear/uniform/job_khi/eng
	display_name = "khi uniform, eng"
	path = /obj/item/clothing/under/rank/khi/eng
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер")

/datum/gear/uniform/job_khi/sci
	display_name = "khi uniform, sci"
	path = /obj/item/clothing/under/rank/khi/sci
	allowed_roles = list("Директор исследований", "Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель")

//Federation jackets
/datum/gear/suit/job_fed/sec
	display_name = "fed uniform, sec"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	allowed_roles = list("Глава безопасности", "Надзиратель", "Детектив", "Офицер безопасности")

/datum/gear/suit/job_fed/medsci
	display_name = "fed uniform, med/sci"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedblue
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог","Следопыт","Искатель","Военврач")

/datum/gear/suit/job_fed/eng
	display_name = "fed uniform, eng"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedeng
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер")

// Trekie things
//TOS
/datum/gear/uniform/job_trek/cmd/tos
	display_name = "TOS uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_trek/medsci/tos
	display_name = "TOS uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель", "Военврач")

/datum/gear/uniform/job_trek/eng/tos
	display_name = "TOS uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер","Надзиратель","Детектив","Офицер безопасности","Head of Security")

//TNG
/datum/gear/uniform/job_trek/cmd/tng
	display_name = "TNG uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/next
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_trek/medsci/tng
	display_name = "TNG uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/next
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель", "Военврач")

/datum/gear/uniform/job_trek/eng/tng
	display_name = "TNG uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/next
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер","Надзиратель","Детектив","Офицер безопасности","Глава безопасности")

//VOY
/datum/gear/uniform/job_trek/cmd/voy
	display_name = "VOY uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/voy
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_trek/medsci/voy
	display_name = "VOY uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/voy
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель", "Военврач")

/datum/gear/uniform/job_trek/eng/voy
	display_name = "VOY uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/voy
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер","Надзиратель","Детектив","Офицер безопасности","Глава безопасности")

//DS9

/datum/gear/suit/job_trek/ds9_coat
	display_name = "DS9 Overcoat (use uniform)"
	path = /obj/item/clothing/suit/storage/trek/ds9
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований",
						"Главврач","Медик","Химик","Парамедик","Geneticist",
						"Ученый","Роботехник","Ксенобиолог","Атмосферный техник",
						"Инженер","Надзиратель","Детектив","Офицер безопасности", "Следопыт", "Искатель", "Военврач")


/datum/gear/uniform/job_trek/cmd/ds9
	display_name = "DS9 uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ds9
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_trek/medsci/ds9
	display_name = "DS9 uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ds9
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель", "Военврач")

/datum/gear/uniform/job_trek/eng/ds9
	display_name = "DS9 uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ds9
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер","Надзиратель","Детектив","Офицер безопасности","Глава безопасности")


//ENT
/datum/gear/uniform/job_trek/cmd/ent
	display_name = "ENT uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ent
	allowed_roles = list("Глава безопасности","Директор колонии","Глава персонала","Главный инженер","Директор исследований","Главврач")

/datum/gear/uniform/job_trek/medsci/ent
	display_name = "ENT uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ent
	allowed_roles = list("Главврач","Медик","Химик","Парамедик","Geneticist","Директор исследований","Ученый", "Роботехник", "Ксенобиолог", "Следопыт", "Искатель", "Военврач")

/datum/gear/uniform/job_trek/eng/ent
	display_name = "ENT uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ent
	allowed_roles = list("Главный инженер","Атмосферный техник","Инженер","Надзиратель","Детектив","Офицер безопасности","Глава безопасности")
/*
Swimsuits
*/

/datum/gear/uniform/swimsuits
	display_name = "swimsuits selection"
	path = /obj/item/weapon/storage/box/fluff/swimsuit

/datum/gear/uniform/swimsuits/New()
	..()
	var/list/swimsuits = list()
	for(var/swimsuit in typesof(/obj/item/weapon/storage/box/fluff/swimsuit))
		var/obj/item/weapon/storage/box/fluff/swimsuit/swimsuit_type = swimsuit
		swimsuits[initial(swimsuit_type.name)] = swimsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(swimsuits))

/datum/gear/uniform/suit/gnshorts
	display_name = "GN shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

//Latex maid dress
/datum/gear/uniform/latexmaid
	display_name = "latex maid dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/gear/uniform/siren
	display_name = "jumpsuit, Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/gear/uniform/suit/v_nanovest
	display_name = "Varmacorp nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

/*
Qipao
*/
/datum/gear/uniform/qipao
	display_name = "qipao, black"
	path = /obj/item/clothing/under/dress/qipao

/datum/gear/uniform/qipao_red
	display_name = "qipao, red"
	path = /obj/item/clothing/under/dress/qipao/red

/datum/gear/uniform/qipao_white
	display_name = "qipao, white"
	path = /obj/item/clothing/under/dress/qipao/white
