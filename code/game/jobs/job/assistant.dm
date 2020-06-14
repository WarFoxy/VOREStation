//////////////////////////////////
//			Assistant
//////////////////////////////////
/datum/job/assistant
	title = "Ассистент"
	flag = ASSISTANT
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "всеми на станции"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "Ассистент делает все, что от него требуется. Хотя он и является частью экипажа, у него нет реальной власти."
/*	alt_titles = list("Technical Assistant" = /datum/alt_title/tech_assist,
						"Medical Intern"= /datum/alt_title/med_intern, "Research Assistant" = /datum/alt_title/research_assist,
						"Visitor" = /datum/alt_title/visitor)
	)	*/	//VOREStation Removal: no alt-titles for visitors

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

// Assistant Alt Titles
/datum/alt_title/tech_assist
	title = "Технический Ассистент"
	title_blurb = "Технический Ассистент пытается выполнять все, что нужно инженерному отделу. Он не является настоящим инженером и часто проходит подготовку, \
					для того, чтобы стать Инженером. Технический Ассистент не имеет никаких реальных полномочий."

/datum/alt_title/med_intern
	title = "Медицинский Интерн"
	title_blurb = "Медицинский Интерн пытается выполнять все, что нужно медицинскому отделу. Их часто просят обратить внимание на консоль датчиков \
					костюмов. У медицинского Интерна нет реальной власти."

/datum/alt_title/research_assist
	title = "Научный Ассистент"
	title_blurb = "Научный Ассистент пытается помочь всем, кто работает в научном отделе. Ожидается, что они будут следовать указаниям научных сотрудников, поскольку это часто является вопросом безопасности. Научный Ассистент не имеет никакого реального авторитета."

/datum/alt_title/visitor
	title = "Посетитель"
	title_blurb = "Посетитель - это любой человек, который прибыл на станцию, но не имеет определенной работы. Многие свободные от дежурства члены экипажа, желающие воспользоваться услугами станции, прибывают в качестве посетителей. Должным образом зарегистрированные посетители считаются частью экипажа, но они не имеют никаких реальных полномочий."
	title_outfit = /decl/hierarchy/outfit/job/assistant/visitor

/datum/alt_title/resident		// Just in case it makes a comeback
	title = "Резидент"
	title_blurb = "Резидент - это человек, который живет на станции, часто в другой части станциb. Они считаются частью экипажа для большинства, но не имеют никакого реального авторитета."
	title_outfit = /decl/hierarchy/outfit/job/assistant/resident
