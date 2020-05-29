/datum/event/communications_blackout/announce()
	var/alert = pick(	"Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с ваш*%fj00)`5vc-BZZT", \
						"Обнаружены ионосферные аномалии. Временный сбой связи неизб*3mga;b4;'1v¬-BZZZT", \
						"Обнаружены ионосферные аномалии. Временный сбой#MCi46:5.;@63-BZZZZT", \
						"Обнаружены ионосферные аном'fZ\\kg5_0-BZZZZZT", \
						"Обнаружены ионосфер:%Ј MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>Ј%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>[alert]</b></span>")
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg', volume=25))


/datum/event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
	for(var/obj/machinery/exonet_node/N in machines)
		N.emp_act(1)
