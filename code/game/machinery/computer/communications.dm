//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// The communications computer
/obj/machinery/computer/communications
	name = "command and communications console"
	desc = "Used to command and control the station. Can relay long-range communications."
	icon_keyboard = "tech_key"
	icon_screen = "comm"
	light_color = "#0099ff"
	req_access = list(access_heads)
	circuit = /obj/item/weapon/circuitboard/communications
	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/message_cooldown = 0
	var/centcomm_message_cooldown = 0
	var/tmp_alertlevel = 0
	var/const/STATE_DEFAULT = 1
	var/const/STATE_CALLSHUTTLE = 2
	var/const/STATE_CANCELSHUTTLE = 3
	var/const/STATE_MESSAGELIST = 4
	var/const/STATE_VIEWMESSAGE = 5
	var/const/STATE_DELMESSAGE = 6
	var/const/STATE_STATUSDISPLAY = 7
	var/const/STATE_ALERT_LEVEL = 8
	var/const/STATE_CONFIRM_LEVEL = 9
	var/const/STATE_CREWTRANSFER = 10

	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2

	var/datum/lore/atc_controller/ATC
	var/datum/announcement/priority/crew_announcement = new

/obj/machinery/computer/communications/New()
	..()
	ATC = atc
	crew_announcement.newscast = 1

/obj/machinery/computer/communications/process()
	if(..())
		if(state != STATE_STATUSDISPLAY)
			src.updateDialog()


/obj/machinery/computer/communications/Topic(href, href_list)
	if(..())
		return 1
	if (using_map && !(src.z in using_map.contact_levels))
		to_chat(usr, "<font color='red'><b>Не удается установить соединение:</b></font> <font color='black'>Вы слишком далеко от станции!</font>")
		return
	usr.set_machine(src)

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/weapon/card/id/I = M.GetIdCard()
			if (I && istype(I))
				if(src.check_access(I))
					authenticated = 1
				if(access_captain in I.access)
					authenticated = 2
					crew_announcement.announcer = GetNameAndAssignmentFromId(I)
		if("logout")
			authenticated = 0
			crew_announcement.announcer = ""

		if("swipeidseclevel")
			if(src.authenticated) //Let heads change the alert level.
				var/old_level = security_level
				if(!tmp_alertlevel) tmp_alertlevel = SEC_LEVEL_GREEN
				if(tmp_alertlevel < SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN
				if(tmp_alertlevel > SEC_LEVEL_BLUE) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot engage delta with this
				set_security_level(tmp_alertlevel)
				if(security_level != old_level)
					//Only notify the admins if an actual change happened
					log_game("[key_name(usr)] изменил уровень безопасности на [get_security_level()].")
					message_admins("[key_name_admin(usr)] изменил уровень безопасности на [get_security_level()].")
					switch(security_level)
						if(SEC_LEVEL_GREEN)
							feedback_inc("alert_comms_green",1)
						if(SEC_LEVEL_YELLOW)
							feedback_inc("alert_comms_yellow",1)
						if(SEC_LEVEL_VIOLET)
							feedback_inc("alert_comms_violet",1)
						if(SEC_LEVEL_ORANGE)
							feedback_inc("alert_comms_orange",1)
						if(SEC_LEVEL_BLUE)
							feedback_inc("alert_comms_blue",1)
				tmp_alertlevel = 0
				state = STATE_DEFAULT

		if("announce")
			if(src.authenticated==2)
				if(message_cooldown)
					to_chat(usr, "Пожалуйста подождите минуту между объявлениями")
					return
				var/input = input(usr, "Пожалуйста, напишите сообщение, чтобы сообщить об этом персоналу.", "Priority Announcement") as null|message
				if(!input || !(usr in view(1,src)))
					return
				crew_announcement.Announce(input)
				message_cooldown = 1
				spawn(600)//One minute cooldown
					message_cooldown = 0

		if("callshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(src.authenticated)
				call_shuttle_proc(usr)
				if(emergency_shuttle.online())
					post_status("shuttle")
			src.state = STATE_DEFAULT
		if("cancelshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(src.authenticated)
				cancel_call_proc(usr)
			src.state = STATE_DEFAULT
		if("messagelist")
			src.currmsg = 0
			src.state = STATE_MESSAGELIST
		if("toggleatc")
			src.ATC.squelched = !src.ATC.squelched
		if("viewmessage")
			src.state = STATE_VIEWMESSAGE
			if (!src.currmsg)
				if(href_list["message-num"])
					src.currmsg = text2num(href_list["message-num"])
				else
					src.state = STATE_MESSAGELIST
		if("delmessage")
			src.state = (src.currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(src.authenticated)
				if(src.currmsg)
					var/title = src.messagetitle[src.currmsg]
					var/text  = src.messagetext[src.currmsg]
					src.messagetitle.Remove(title)
					src.messagetext.Remove(text)
					if(src.currmsg == src.aicurrmsg)
						src.aicurrmsg = 0
					src.currmsg = 0
				src.state = STATE_MESSAGELIST
			else
				src.state = STATE_VIEWMESSAGE
		if("status")
			src.state = STATE_STATUSDISPLAY

		// Status display stuff
		if("setstat")
			switch(href_list["statdisp"])
				if("message")
					post_status("message", stat_msg1, stat_msg2)
				if("alert")
					post_status("alert", href_list["alert"])
				else
					post_status(href_list["statdisp"])

		if("setmsg1")
			stat_msg1 = reject_bad_text(sanitize(input("Строка 1", "Введите Текст Сообщения", stat_msg1) as text|null, 40), 40)
			src.updateDialog()
		if("setmsg2")
			stat_msg2 = reject_bad_text(sanitize(input("Строка 2", "Введите Текст Сообщения", stat_msg2) as text|null, 40), 40)
			src.updateDialog()

		// OMG CENTCOMM LETTERHEAD
		if("MessageCentCom")
			if(src.authenticated==2)
				if(centcomm_message_cooldown)
					to_chat(usr, "<font color='red'>Переработка массивов. Подождите, пожалуйста.</font>")
					return
				var/input = sanitize(input("Пожалуйста, выберите сообщение для передачи в [using_map.boss_short] через квантовую запутанность. \
				Пожалуйста, имейте в виду, что этот процесс очень дорогой, и злоупотребление приведет к ... терминации.  \
				Передача не гарантирует ответа. \
				Существует 30-секундная задержка, прежде чем вы сможете отправить еще одно сообщение, пишите ясно, кратно м понятно.", "Central Command Quantum Messaging") as null|message)
				if(!input || !(usr in view(1,src)))
					return
				CentCom_announce(input, usr)
				to_chat(usr, "<font color='blue'>Сообщение передано.</font>")
				log_game("[key_name(usr)] has made an IA [using_map.boss_short] announcement: [input]")
				centcomm_message_cooldown = 1
				spawn(300)//10 minute cooldown
					centcomm_message_cooldown = 0


		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if((src.authenticated==2) && (src.emagged))
				if(centcomm_message_cooldown)
					to_chat(usr, "<font color='red'>Переработка массивов. Подождите, пожалуйста.</font>")
					return
				var/input = sanitize(input(usr, "Пожалуйста, выберите сообщение для передачи в \[АНОМАЛЬНЫЕ МАРШРУТНЫЕ КОРДИНАТЫ через квантовую запутанность\].  Пожалуйста, имейте в виду, что этот процесс очень дорогой, и злоупотребление приведет к ... терминации. Передача не гарантирует ответ. Перед отправкой другого сообщения существует 30-секундная задержка, пишите ясно, кратно м понятно.", "Чтобы прерваться, отправьте пустое сообщение.", ""))
				if(!input || !(usr in view(1,src)))
					return
				Syndicate_announce(input, usr)
				to_chat(usr, "<font color='blue'>Сообщение передано.</font>")
				log_game("[key_name(usr)] has made an illegal announcement: [input]")
				centcomm_message_cooldown = 1
				spawn(300)//10 minute cooldown
					centcomm_message_cooldown = 0

		if("RestoreBackup")
			to_chat(usr, "Резервное копирование данных восстановлено!")
			src.emagged = 0
			src.updateDialog()



		// AI interface
		if("ai-main")
			src.aicurrmsg = 0
			src.aistate = STATE_DEFAULT
		if("ai-callshuttle")
			src.aistate = STATE_CALLSHUTTLE
		if("ai-callshuttle2")
			call_shuttle_proc(usr)
			src.aistate = STATE_DEFAULT
		if("ai-messagelist")
			src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			src.aistate = STATE_VIEWMESSAGE
			if (!src.aicurrmsg)
				if(href_list["message-num"])
					src.aicurrmsg = text2num(href_list["message-num"])
				else
					src.aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			src.aistate = (src.aicurrmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(src.aicurrmsg)
				var/title = src.messagetitle[src.aicurrmsg]
				var/text  = src.messagetext[src.aicurrmsg]
				src.messagetitle.Remove(title)
				src.messagetext.Remove(text)
				if(src.currmsg == src.aicurrmsg)
					src.currmsg = 0
				src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-status")
			src.aistate = STATE_STATUSDISPLAY

		if("securitylevel")
			src.tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL

		if("changeseclevel")
			state = STATE_ALERT_LEVEL



	src.updateUsrDialog()

/obj/machinery/computer/communications/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		src.emagged = 1
		to_chat(user, "Вы шифруете схемы маршрутизации связи!")
		return 1

/obj/machinery/computer/communications/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/communications/attack_hand(var/mob/user as mob)
	if(..())
		return
	if (using_map && !(src.z in using_map.contact_levels))
		to_chat(user, "<font color='red'><b>Невозможно установить соединение:</b></font> <font color='black'>Вы слишком далеко от станции!</font>")
		return

	user.set_machine(src)
	var/dat = "<meta charset=\"utf-8\"><head><title>Консоль связи</title></head><body>"
	if (emergency_shuttle.has_eta())
		var/timeleft = emergency_shuttle.estimate_arrival_time()
		dat += "<B>Аварийный шаттл</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"

	if (istype(user, /mob/living/silicon))
		var/dat2 = src.interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat +=  dat2
			user << browse(dat, "window=communications;size=400x500")
			onclose(user, "communications")
		return

	switch(src.state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=logout'>Выйти</A> \]"
				if (src.authenticated==2)
					dat += "<BR>\[ <A HREF='?src=\ref[src];operation=announce'>Сделать объявление</A> \]"
					if(src.emagged == 0)
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=MessageCentCom'>Отправить экстренное сообщение [using_map.boss_short]</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=MessageSyndicate'>Отправить экстренное сообщение \[UNKNOWN\]</A> \]"
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=RestoreBackup'>Вос. резервные данные маршрутиз.</A> \]"

				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=changeseclevel'>Изменить уровень безопасности</A> \]"
				if(emergency_shuttle.location())
					if (emergency_shuttle.online())
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=cancelshuttle'>Отменить вызов шаттла</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=callshuttle'>Вызвать аварийный шаттл</A> \]"

				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=status'>Информация дисплеев</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=login'>Войти</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=messagelist'>Соощения</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=toggleatc'>[ATC.squelched ? "Вкл" : "Выкл"] ATC Relay</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Вы уверены, что хотите вызвать шаттл? \[ <A HREF='?src=\ref[src];operation=callshuttle2'>OK</A> | <A HREF='?src=\ref[src];operation=main'>Отмена</A> \]"
		if(STATE_CANCELSHUTTLE)
			dat += "Вы уверены, что хотите отменить вызов шаттла? \[ <A HREF='?src=\ref[src];operation=cancelshuttle2'>OK</A> | <A HREF='?src=\ref[src];operation=main'>Отмена</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.currmsg)
				dat += "<B>[src.messagetitle[src.currmsg]]</B><BR><BR>[src.messagetext[src.currmsg]]"
				if (src.authenticated)
					dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=delmessage'>Удалить \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_DELMESSAGE)
			if (src.currmsg)
				dat += "Вы уверены, что хотите удалить это сообщение? \[ <A HREF='?src=\ref[src];operation=delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=viewmessage'>Отмена</A> \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Информация дисплеев<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Очистить</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=time'>Время на станции</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Прибытие шаттла</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Сообщение</A> \]"
			dat += "<ul><li> Строка 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Строка 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>Нет</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Красная тревога</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Карантин</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Био. опасность</A> \]<BR><HR>"
		if(STATE_ALERT_LEVEL)
			dat += "Текущий уровень безопасности: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				dat += "<font color='red'><b>Механизм самоуничтожения активен. Найдите способ отключить механизм, чтобы понизить уровень тревоги или эвакуироваться.</b></font>"
			else
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Голубой</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_ORANGE]'>Оранжевый</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_VIOLET]'>Фиолетовый</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_YELLOW]'>Желтый</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Зеленый</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Текущий уровень безопасности: [get_security_level()]<BR>"
			dat += "Подтвердите изменение на: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='?src=\ref[src];operation=swipeidseclevel'>OK</A> чтобы подтвердить изменение.<BR>"

	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Закрыть</A> \]"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")




/obj/machinery/computer/communications/proc/interact_ai(var/mob/living/silicon/ai/user as mob)
	var/dat = ""
	switch(src.aistate)
		if(STATE_DEFAULT)
			if(emergency_shuttle.location() && !emergency_shuttle.online())
				dat += "<meta charset=\"utf-8\"><BR>\[ <A HREF='?src=\ref[src];operation=ai-callshuttle'>Вызов аварийного шаттла</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-messagelist'>Сообщения</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-status'>Информация дисплеев</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=toggleatc'>[ATC.squelched ? "Вкл" : "Выкл"] ATC Relay</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Вы уверены, что хотите вызвать шаттл? \[ <A HREF='?src=\ref[src];operation=ai-callshuttle2'>OK</A> | <A HREF='?src=\ref[src];operation=ai-main'>Отмена</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Сообщения:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=ai-viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.aicurrmsg)
				dat += "<B>[src.messagetitle[src.aicurrmsg]]</B><BR><BR>[src.messagetext[src.aicurrmsg]]"
				dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=ai-delmessage'>Удалить</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return null
		if(STATE_DELMESSAGE)
			if(src.aicurrmsg)
				dat += "Вы уверены, что хотите удалить это сообщение? \[ <A HREF='?src=\ref[src];operation=ai-delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=ai-viewmessage'>Отмена</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return

		if(STATE_STATUSDISPLAY)
			dat += "Информация дисплеев<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Очистить</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=time'>Время на станции</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Прибытие шаттла</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Сообщение</A> \]"
			dat += "<ul><li> Строка 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Строка 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>Нет</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Красная тревога</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Карантин</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Био. опасность</A> \]<BR><HR>"


	dat += "<BR>\[ [(src.aistate != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=ai-main'>Главное меню</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Закрыть</A> \]"
	return dat

/proc/enable_prison_shuttle(var/mob/user)
	for(var/obj/machinery/computer/prison_shuttle/PS in machines)
		PS.allowedtocall = !(PS.allowedtocall)

/proc/call_shuttle_proc(var/mob/user)
	if ((!( ticker ) || !emergency_shuttle.location()))
		return

	if(!universe.OnShuttleCall(usr))
		to_chat(user, "<span class='notice'>Не удается установить соединение с блюспейс.</span>")
		return

	if(deathsquad.deployed)
		to_chat(user, "[using_map.boss_short] не позволит вызвать шаттл. Считайте, что все контракты расторгнуты.")
		return

	if(emergency_shuttle.deny_shuttle)
		to_chat(user, "Аварийный трансфер не может быть отправлен в это время. Пожалуйста, попробуйте позже.")
		return

	if(world.time < 6000) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, "Аварийный челнок заправляется. Пожалуйста, подождите еще [round((6000-world.time)/600)] минут, прежде чем пытаться снова.")
		return

	if(emergency_shuttle.going_to_centcom())
		to_chat(user, "Аварийный шаттл не может быть вызван при возвращении на [using_map.boss_short].")
		return

	if(emergency_shuttle.online())
		to_chat(user, "Аварийный шаттл уже в пути.")
		return

	if(ticker.mode.name == "blob")
		to_chat(user, "Согласно директиве 7-10, [station_name()] помещается на карантин до дальнейшего уведомления.")
		return

	emergency_shuttle.call_evac()
	log_game("[key_name(user)] вызывает шаттл.")
	message_admins("[key_name_admin(user)] вызывает шаттл.", 1)
	admin_chat_message(message = "Начало аварийной эвакуации! Вызов совершает [key_name(user)]!", color = "#CC2222") //VOREStation Add


	return

/proc/init_shift_change(var/mob/user, var/force = 0)
	if ((!( ticker ) || !emergency_shuttle.location()))
		return

	if(emergency_shuttle.going_to_centcom())
		to_chat(user, "Шаттл не может быть вызван при возвращении на [using_map.boss_short].")
		return

	if(emergency_shuttle.online())
		to_chat(user, "Шаттл уже в пути.")
		return

	// if force is 0, some things may stop the shuttle call
	if(!force)
		if(emergency_shuttle.deny_shuttle)
			to_chat(user, "В настоящее время у [using_map.boss_short] нет шаттла, доступного в вашем секторе. Пожалуйста, повторите попытку позже.")
			return

		if(deathsquad.deployed == 1)
			to_chat(user, "[using_map.boss_short] не позволит вызвать шаттл. Считайте, что все контракты расторгнуты.")
			return

		if(world.time < 54000) // 30 minute grace period to let the game get going
			to_chat(user, "Аварийный челнок заправляется. Пожалуйста, подождите еще [round((54000-world.time)/60)] минут, прежде чем пытаться снова.")
			return

		if(ticker.mode.auto_recall_shuttle)
			//New version pretends to call the shuttle but cause the shuttle to return after a random duration.
			emergency_shuttle.auto_recall = 1

		if(ticker.mode.name == "blob" || ticker.mode.name == "epidemic")
			to_chat(user, "Согласно директиве 7-10, [station_name()] помещается на карантин до дальнейшего уведомления.")
			return

	emergency_shuttle.call_transfer()

	//delay events in case of an autotransfer
	if (isnull(user))
		SSevents.delay_events(EVENT_LEVEL_MODERATE, 9000) //15 minutes
		SSevents.delay_events(EVENT_LEVEL_MAJOR, 9000)

	log_game("[user? key_name(user) : "Autotransfer"] вызывает шаттл.")
	message_admins("[user? key_name_admin(user) : "Autotransfer"] вызывает шаттл.", 1)
	admin_chat_message(message = "Автовозвратный шаттл отправлен, смена скоро закончится.", color = "#2277BB") //VOREStation Add

	return

/proc/cancel_call_proc(var/mob/user)
	if (!( ticker ) || !emergency_shuttle.can_recall())
		return
	if((ticker.mode.name == "blob")||(ticker.mode.name == "Meteor"))
		return

	if(!emergency_shuttle.going_to_centcom()) //check that shuttle isn't already heading to CentCom
		emergency_shuttle.recall()
		log_game("[key_name(user)] has recalled the shuttle.")
		message_admins("[key_name_admin(user)] has recalled the shuttle.", 1)
	return


/proc/is_relay_online()
    for(var/obj/machinery/telecomms/relay/M in world)
        if(M.stat == 0)
            return 1
    return 0

/obj/machinery/computer/communications/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("СТАТУС: [src.fingerprintslast] уставливает статус сообщения с помощью [src]: [data1] [data2]")
			//message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)
