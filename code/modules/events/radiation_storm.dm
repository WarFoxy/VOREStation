/datum/event/radiation_storm
	var/const/enterBelt		= 30
	var/const/radIntervall 	= 5	// Enough time between enter/leave belt for 10 hits, as per original implementation
	var/const/leaveBelt		= 80
	var/const/revokeAccess	= 165
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	var/postStartTicks 		= 0

/datum/event/radiation_storm/announce()
	command_announcement.Announce("Вблизи [station_name()] обнаружен высокий уровень радиации. Пожалуйста, эвакуируйтесь в технические тоннели или дормы.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg') //VOREStation Edit - Dorms ref

/datum/event/radiation_storm/start()
	make_maint_all_access()

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce("Станция вошла в радиационный пояс. Пожалуйста, оставайтесь в защищенном месте, пока мы не пройдем радиационный пояс.", "Anomaly Alert")
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce("Станция прошла радиационный пояс. Пожалуйста, подождите одну минуту, пока уровень радиации снизится, и сообщите в медпункт, если у вас возникнут какие-либо необычные симптомы. Maintenance потеряет весь доступ в ближайшее время.", "Anomaly Alert")
/datum/event/radiation_storm/proc/radiate()
	var/radiation_level = rand(15, 35)
	for(var/z in using_map.station_levels)
		SSradiation.z_radiate(locate(1, 1, z), radiation_level, 1)

	for(var/mob/living/carbon/C in living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(A.flags & RAD_SHIELDED)
			continue
		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(prob(5))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/event/radiation_storm/end()
	revoke_maint_all_access()

/datum/event/radiation_storm/syndicate/radiate()
	return
