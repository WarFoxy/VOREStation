/datum/event/morph_spawn
	startWhen = 1
	announceWhen = 20
	endWhen = 30
	var/announceProb = 50

/datum/event/morph_spawn/start()

	var/obj/effect/landmark/spawnspot = null
	var/list/possibleSpawnspots = list()
	for(var/obj/effect/landmark/newSpawnspot in landmarks_list)
		if(newSpawnspot.name == "morphspawn")
			possibleSpawnspots += newSpawnspot
	if(possibleSpawnspots.len)
		spawnspot = pick(possibleSpawnspots)
	else
		kill()		// To prevent fake announcements
		return

	if(!spawnspot)
		kill()		// To prevent fake announcements
		return

	var/datum/ghost_query/Q = new /datum/ghost_query/morph()
	var/list/winner = Q.query()

	if(winner.len)
		var/mob/living/simple_mob/vore/hostile/morph/newMorph = new /mob/living/simple_mob/vore/hostile/morph(get_turf(spawnspot))
		var/mob/observer/dead/D = winner[1]
		if(D.mind)
			D.mind.transfer_to(newMorph)
		to_chat(D, "<span class='notice'>Вы <b>Морф</b>, и каким то образом вы попали на станцию. \
		Вы остерегаетесь окружающей среды, но ваш первобытный голод все еще требует от вас найти добычу. Используйте убедительную маскировку, \
		используя свою аморфную форму, чтобы пройти через вентиляционные отверстия, чтобы найти и поглотить слабую жертву.</span>")
		to_chat(D, "<span class='notice'>Вы можете использовать shift+ЛКМ на объектах, чтобы замаскироваться под них, но ваши атаки почти бесполезны, когда вы замаскированы. \
		Вы можете не маскироваться, щелкнув shift+ЛКМ по себе, но маскировка при переключении или включении имеет короткое время перезарядки. Вы можете залезать в вентиляцию, \
		используя alt+ЛКМ по вентиляции.</span>")
		newMorph.ckey = D.ckey
		newMorph.visible_message("<span class='warning'>A morph appears to crawl out of somewhere.</span>")
	else
		kill()		// To prevent fake announcements
		return


/datum/event/morph_spawn/announce()
	if(prob(announceProb))
		command_announcement.Announce("Неизвестная форма жизни была обнаружена на [station_name()]. Всему персоналу следует действовать с особой осторожностью.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')