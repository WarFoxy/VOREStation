
/proc/communications_blackout(var/silent = 1)

	if(!silent)
		command_announcement.Announce("Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с вашим-БЗЗЗ", new_sound = 'sound/misc/interference.ogg')
	else // AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
		for(var/mob/living/silicon/ai/A in player_list)
			to_chat(A, "<br>")
			to_chat(A, "<span class='warning'><b>Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с вашим-БЗЗЗ</b></span>")
			to_chat(A, "<br>")
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
