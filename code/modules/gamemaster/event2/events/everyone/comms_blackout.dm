/datum/event2/meta/comms_blackout
	name = "communications blackout"
	departments = list(DEPARTMENT_EVERYONE) // It's not an engineering event because engineering can't do anything to help . . . for now.
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/comms_blackout

/datum/event2/meta/comms_blackout/get_weight()
	return 50 + metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5



/datum/event2/event/comms_blackout/announce()
	var/alert = pick("Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с ваши*%fj00)`5vc-BZZT", \
					"Обнаружены ионосферные аномалии. Временный сбой связи неизбе*3mga;b4;'1v¬-BZZZT", \
					"Обнаружены ионосферные аномалии. Временный сбо#MCi46:5.;@63-BZZZZT", \
					"Обнаружены ионосферные аномалии. В'fZ\\kg5_0-BZZZZZT", \
					"Обнаружены ио:%£ MCayj^j<.3-BZZZZZZT", \
					"#4nd%;f4y6,>£%-BZZZZZZZT")
	if(prob(33))
		command_announcement.Announce(alert, new_sound = 'sound/misc/interference.ogg')
	// AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
	for(var/mob/living/silicon/ai/A in player_list)
		to_chat(A, "<br>")
		to_chat(A, "<span class='warning'><b>[alert]</b></span>")
		to_chat(A, "<br>")

/datum/event2/event/comms_blackout/start()
	if(prob(50))
		// One in two chance for the radios to turn i%t# t&_)#%, which can be more alarming than radio silence.
		log_debug("Doing partial outage of telecomms.")
		for(var/obj/machinery/telecomms/processor/P in telecomms_list)
			P.emp_act(1)
	else
		// Otherwise just shut everything down, madagascar style.
		log_debug("Doing complete outage of telecomms.")
		for(var/obj/machinery/telecomms/T in telecomms_list)
			T.emp_act(1)

	// Communicators go down no matter what.
	for(var/obj/machinery/exonet_node/N in machines)
		N.emp_act(1)
