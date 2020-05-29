/datum/event/solar_storm
	startWhen				= 45
	announceWhen			= 1
	var/const/rad_interval 	= 5  	//Same interval period as radiation storms.
	var/base_solar_gen_rate


/datum/event/solar_storm/setup()
	endWhen = startWhen + rand(30,90) + rand(30,90) //2-6 minute duration

/datum/event/solar_storm/announce()
	command_announcement.Announce("Обнаружена солнечная буря, приближающаяся к [station_name()]. Пожалуйста, прервите все действия в EVA и вернитесь на станцию.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')
	adjust_solar_output(1.5)

/datum/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = GLOB.solar_gen_rate
	GLOB.solar_gen_rate = mult * base_solar_gen_rate


/datum/event/solar_storm/start()
	command_announcement.Announce("Солнечная буря достигла станции. Пожалуйста, снимите EVA и оставайтесь внутри станции, пока она не пройдет.", "Anomaly Alert")
	adjust_solar_output(5)


/datum/event/solar_storm/tick()
	if(activeFor % rad_interval == 0)
		radiate()

/datum/event/solar_storm/proc/radiate()
	// Note: Too complicated to be worth trying to use the radiation system for this.  Its only in space anyway, so we make an exception in this case.
	for(var/mob/living/L in living_mob_list)
		var/turf/T = get_turf(L)
		if(!T)
			continue

		if(!istype(T.loc,/area/space) && !istype(T,/turf/space))	//Make sure you're in a space area or on a space turf
			continue

		//Todo: Apply some burn damage from the heat of the sun. Until then, enjoy some moderate radiation.
		L.rad_act(rand(15, 30))

/datum/event/solar_storm/end()
	command_announcement.Announce("Солнечная буря прошла мимо станции. Работа в EVA вновь безопасна. Пожалуйста, сообщите в медпункт, если вы испытываете какие-либо необычные симптомы. ", "Anomaly Alert")
	adjust_solar_output()


//For a false alarm scenario.
/datum/event/solar_storm/syndicate/adjust_solar_output()
	return

/datum/event/solar_storm/syndicate/radiate()
	return
