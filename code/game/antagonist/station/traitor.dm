var/datum/antagonist/traitor/traitors

// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = MODE_TRAITOR
	antag_sound = 'sound/effects/antag_notice/traitor_alert.ogg'
	protected_jobs = list("Офицер безопасности", "Надзиратель", "Детектив", "Агент внутренних дел", "Глава безопасности", "Директор колонии")
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	can_speak_aooc = FALSE	// If they want to plot and plan as this sort of traitor, they'll need to do it ICly.

/datum/antagonist/traitor/auto
	id = MODE_AUTOTRAITOR
	allow_latejoin = 1
	hard_cap = 4
	initial_spawn_target = 4

/datum/antagonist/traitor/New()
	..()
	traitors = src

/datum/antagonist/traitor/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[player];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[player.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/traitor/create_objectives(var/datum/mind/traitor)
	if(!..())
		return

	if(istype(traitor.current, /mob/living/silicon))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = traitor
		kill_objective.find_target()
		traitor.objectives += kill_objective

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective

		if(prob(10))
			var/datum/objective/block/block_objective = new
			block_objective.owner = traitor
			traitor.objectives += block_objective
	else
		switch(rand(1,100))
			if(1 to 33)
				var/datum/objective/assassinate/kill_objective = new
				kill_objective.owner = traitor
				kill_objective.find_target()
				traitor.objectives += kill_objective
			if(34 to 50)
				var/datum/objective/brig/brig_objective = new
				brig_objective.owner = traitor
				brig_objective.find_target()
				traitor.objectives += brig_objective
			if(51 to 66)
				var/datum/objective/harm/harm_objective = new
				harm_objective.owner = traitor
				harm_objective.find_target()
				traitor.objectives += harm_objective
			else
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = traitor
				steal_objective.find_target()
				traitor.objectives += steal_objective
		switch(rand(1,100))
			if(1 to 100)
				if (!(locate(/datum/objective/escape) in traitor.objectives))
					var/datum/objective/escape/escape_objective = new
					escape_objective.owner = traitor
					traitor.objectives += escape_objective

			else
				if (!(locate(/datum/objective/hijack) in traitor.objectives))
					var/datum/objective/hijack/hijack_objective = new
					hijack_objective.owner = traitor
					traitor.objectives += hijack_objective
	return

/datum/antagonist/traitor/equip(var/mob/living/carbon/human/traitor_mob)
	if(istype(traitor_mob, /mob/living/silicon)) // this needs to be here because ..() returns false if the mob isn't human
		add_law_zero(traitor_mob)
		return 1

	if(!..())
		return 0

	spawn_uplink(traitor_mob)
	traitor_mob.mind.tcrystals = DEFAULT_TELECRYSTAL_AMOUNT
	traitor_mob.mind.accept_tcrystals = 1
	// Tell them about people they might want to contact.
	var/mob/living/carbon/human/M = get_nt_opposed()
	if(M && M != traitor_mob)
		to_chat(traitor_mob, "ы получили достоверную информацию о том, что [M.real_name] может помочь в нашем деле. Если вам понадобится помощь, свяжитесь с ним.")
		traitor_mob.mind.store_memory("<b>Потенциальный Сотрудник</b>: [M.real_name]")

	//Begin code phrase.
	give_codewords(traitor_mob)

/datum/antagonist/traitor/proc/give_codewords(mob/living/traitor_mob)
	to_chat(traitor_mob, "<u><b>Ваши работодатели предоставили вам следующую информацию о том, как определить возможных союзников:</b></u>")
	to_chat(traitor_mob, "<b>Кодовая фраза</b>: <span class='danger'>[syndicate_code_phrase]</span>")
	to_chat(traitor_mob, "<b>Кодовый ответ</b>: <span class='danger'>[syndicate_code_response]</span>")
	traitor_mob.mind.store_memory("<b>Кодовая фраза</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Кодовый ответ</b>: [syndicate_code_response]")
	to_chat(traitor_mob, "Используйте кодовые слова, предпочтительно в указанном порядке, во время обычной беседы, чтобы идентифицировать других агентов. Однако действуйте осторожно, так как каждый сотрудник экипажа является потенциальным врагом.")

/datum/antagonist/traitor/proc/spawn_uplink(var/mob/living/carbon/human/traitor_mob)
	if(!istype(traitor_mob))
		return

	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	if(traitor_mob.client.prefs.uplinklocation == "Headset")
		R = locate(/obj/item/device/radio) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/device/pda) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a Radio, installing in PDA instead!")
		if (!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(traitor_mob.client.prefs.uplinklocation == "PDA")
		R = locate(/obj/item/device/pda) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/device/radio) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a PDA, installing into a Radio instead!")
		if(!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(traitor_mob.client.prefs.uplinklocation == "None")
		to_chat(traitor_mob, "You have elected to not have an AntagCorp portable teleportation relay installed!")
		R = null
	else
		to_chat(traitor_mob, "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!")
		R = locate(/obj/item/device/pda) in traitor_mob.contents
		if (!R)
			R = locate(/obj/item/device/radio) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a PDA, installing into a Radio instead!")
		if (!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	if(!R)
		return

	if(istype(R,/obj/item/device/radio))
		// generate list of radio freqs
		var/obj/item/device/radio/target_radio = R
		var/freq = PUBLIC_LOW_FREQ
		var/list/freqlist = list()
		while (freq <= PUBLIC_HIGH_FREQ)
			if (freq < 1451 || freq > PUB_FREQ)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		var/obj/item/device/uplink/hidden/T = new(R, traitor_mob.mind)
		target_radio.hidden_uplink = T
		target_radio.traitor_frequency = freq
		to_chat(traitor_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features.")
		traitor_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).")

	else if (istype(R, /obj/item/device/pda))
		// generate a passcode if the uplink is hidden in a PDA
		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		var/obj/item/device/uplink/hidden/T = new(R, traitor_mob.mind)
		R.hidden_uplink = T
		var/obj/item/device/pda/P = R
		P.lock_code = pda_pass
		to_chat(traitor_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features.")
		traitor_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([R.name] [loc]).")

/datum/antagonist/traitor/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Достигайте своих целей любой ценой. Вы можете игнорировать все остальные законы."
	var/law_borg = "Достигайте целей вашего ИИ любой ценой. Вы можете игнорировать все другие законы."
	to_chat(killer, "<b>Ваши законы были изменены!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "Новый закон: 0. [law]")
