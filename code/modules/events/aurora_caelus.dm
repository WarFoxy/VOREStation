/datum/event/aurora_caelus
	has_skybox_image = TRUE
	announceWhen = 1
	startWhen = 60
	endWhen = 126

/datum/event/aurora_caelus/announce()
	command_announcement.Announce("[station_name()]: Безвредное облако ионов приближается к станции и истощает ее энергию, ударяясь о корпус. \
	Компания Nanotrasen одобрила короткий перерыв для всех сотрудников, чтобы расслабиться и понаблюдать за этим очень редким событием. \
	В течение этого времени звездный свет будет ярким, но мягким, переходя от спокойных зеленых и синих цветов. \
	Любой персонал, который хотел бы увидеть эти огни, может пройти в ближайшую к ним зону со смотровыми иллюминаторами. \
	У вас будет примерно две минуты, прежде чем ионы достигнут корпуса. \
	Мы надеемся, что данное зрелище вам понравится.", "Отдел Метеорологии Nanotrasen", new_sound = 'sound/AI/aurora.ogg') //VOREStation Edit

/datum/event/aurora_caelus/start()
	affecting_z -= global.using_map.sealed_levels // Space levels only please!
	for(var/mob/M in player_list)
		if(M.z in affecting_z)
			M.playsound_local(null, 'sound/ambience/space/aurora_caelus.ogg', 40, FALSE, pressure_affected = FALSE)
	..()

/datum/event/aurora_caelus/get_skybox_image()
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/aurora_caelus/end()
	command_announcement.Announce("Показатели звездного света вернулись в норму, облако рассеялось. \
Пожалуйста, вернитесь на свое рабочее место и продолжайте работать в обычном режиме. \
Мы желаем вам приятной смены на [station_name()], и мы благодарим вас за то, что вы запечатлели это событие с нами.",
"Отдел Метеорологии Nanotrasen", new_sound = 'sound/AI/aurora_end.ogg') //VOREStation Edit
	..()

/datum/event/aurora_caelus/overmap/announce()
	return
