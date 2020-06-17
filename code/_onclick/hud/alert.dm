//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want


/mob/proc/throw_alert(category, type, severity, obj/new_master)

/* Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 path is a type path of the actual alert type to throw
 severity is an optional number that will be placed at the end of the icon_state for this alert
 For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 Clicks are forwarded to master */

	if(!category)
		return

	var/obj/screen/alert/alert
	if(alerts[category])
		alert = alerts[category]
		if(new_master && new_master != alert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [alert.master]")
			clear_alert(category)
			return .()
		else if(alert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == alert.severity)
			if(alert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		alert = new type

	if(new_master)
		alert.icon_state = "itembased"
		var/image/I = image(icon = new_master.icon, icon_state = new_master.icon_state, dir = SOUTH)
		I.plane = PLANE_PLAYER_HUD_ABOVE
		alert.add_overlay(I)
		alert.master = new_master
	else
		alert.icon_state = "[initial(alert.icon_state)][severity]"
		alert.severity = severity

	alerts[category] = alert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	alert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(alert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(alert.timeout)
		addtimer(CALLBACK(src, .proc/alert_timeout, alert, category), alert.timeout)
		alert.timeout = world.time + alert.timeout - world.tick_lag
	return alert

/mob/proc/alert_timeout(obj/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category)
	var/obj/screen/alert/alert = alerts[category]
	if(!alert)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/obj/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = 1
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/no_underlay // Don't underlay the UI style's blank template icon under this


/obj/screen/alert/MouseEntered(location,control,params)
	openToolTip(usr, src, params, title = name, content = desc, theme = alerttooltipstyle)


/obj/screen/alert/MouseExited()
	closeToolTip(usr)


//Gas alerts
/obj/screen/alert/not_enough_oxy
	name = "Choking (No O2)"
	desc = "You're not getting enough oxygen. Find some good air before you pass out! \
The box in your backpack has an oxygen tank and breath mask in it."
	icon_state = "not_enough_oxy"

/obj/screen/alert/too_much_oxy
	name = "Choking (O2)"
	desc = "There's too much oxygen in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_oxy"

/obj/screen/alert/not_enough_nitro
	name = "Choking (No N)"
	desc = "You're not getting enough nitrogen. Find some good air before you pass out!"
	icon_state = "not_enough_nitro"

/obj/screen/alert/too_much_nitro
	name = "Choking (N)"
	desc = "There's too much nitrogen in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_nitro"

/obj/screen/alert/not_enough_co2
	name = "Choking (No CO2)"
	desc = "You're not getting enough carbon dioxide. Find some good air before you pass out!"
	icon_state = "not_enough_co2"

/obj/screen/alert/too_much_co2
	name = "Choking (CO2)"
	desc = "There's too much carbon dioxide in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_co2"

/obj/screen/alert/too_much_co2/plant
	name = "Livin' the good life"
	desc = "There's so much carbon dioxide in the air, you're in fucking heaven. Watch out for passed out fleshies, though."
	icon_state = "too_much_co2"

/obj/screen/alert/not_enough_tox
	name = "Choking (No Phoron)"
	desc = "You're not getting enough phoron. Find some good air before you pass out!"
	icon_state = "not_enough_tox"

/obj/screen/alert/tox_in_air
	name = "Choking (Phoron)"
	desc = "There's highly flammable, toxic phoron in the air and you're breathing it in. Find some fresh air. \
The box in your backpack has an oxygen tank and gas mask in it."
	icon_state = "too_much_tox"

/obj/screen/alert/not_enough_fuel
	name = "Choking (No Volatile fuel)"
	desc = "You're not getting enough volatile fuel. Find some good air before you pass out!"
	icon_state = "not_enough_tox"

/obj/screen/alert/not_enough_n2o
	name = "Choking (No Sleeping Gas)"
	desc = "You're not getting enough sleeping gas. Find some good air before you pass out!"
	icon_state = "not_enough_tox"
//End gas alerts


/obj/screen/alert/fat
	name = "Ожирение"
	desc = "Вы съели слишком много еды. Побегайте по станции и сбросьте немного веса."
	icon_state = "fat"

/obj/screen/alert/fat/vampire
	desc = "Вы выпили слишком много крови. Побегайте по станции и сбросьте немного веса."
	icon_state = "v_fat"

/obj/screen/alert/fat/synth
	desc = "Ваша батарея полна! Не перегружайте ее."
	icon_state = "c_fat"

/obj/screen/alert/hungry
	name = "Голод"
	desc = "Перекусить сейчас бы не помешало"
	icon_state = "hungry"

/obj/screen/alert/hungry/vampire
	desc = "Вам не помешало бы подкрепиться кровью, а лучше дважды."
	icon_state = "v_hungry"

/obj/screen/alert/hungry/synth
	desc = "Батарея разряжена, следует проследовать на станцию зарядки."
	icon_state = "c_hungry"

/obj/screen/alert/starving
	name = "Голодание"
	desc = "Вы сильно голодаете. Боли в животе превращают передвижение в вялый шаг."
	icon_state = "starving"

/obj/screen/alert/starving/vampire
	desc = "Вам *нужна* кровь; идите и разорвите чью нибудь шею!"
	icon_state = "v_starving"

/obj/screen/alert/starving/synth
	desc = "Ваша батарея вот-вот сядет! Зарядите ее как можно скорее!"
	icon_state = "c_starving"

/obj/screen/alert/hot
	name = "Очень жарко"
	desc = "Ваше тело пылает от жары! Попробуйте где-нибудь охладиться и снимите любую изоляционную одежду."
	icon_state = "hot"

/obj/screen/alert/hot/robot
	desc = "Воздух вокруг вас слишком горячий. Будьте осторожны, при работе в этой среде."

/obj/screen/alert/cold
	name = "Очень холодно"
	desc = "Вы совсем замерзли! Доберитесь до теплого места и снимите любую изолирующую одежду."
	icon_state = "cold"

/obj/screen/alert/cold/robot
	desc = "Воздух вокруг вас слишком холоден. Будьте осторожны, при работе в этой среде."

/obj/screen/alert/lowpressure
	name = "Низкое давление"
	desc = "Воздух вокруг вас опасно разрежен. Необходим скафандр."
	icon_state = "lowpressure"

/obj/screen/alert/highpressure
	name = "Высокое давление"
	desc = "Воздух вокруг вас очень плотный. Необходим пожарный костюм."
	icon_state = "highpressure"

/obj/screen/alert/blind
	name = "Слепота"
	desc = "Вы ничего не видите! Это может быть вызвано генетическим дефектом, травмой глаза, бессознательным состоянием или чем-то, что закрывает ваши глаза."
	icon_state = "blind"

/obj/screen/alert/stunned
	name = "Оглушение"
	desc = "Вы временно оглушены! У вас будут проблемы с перемещением или выполнением действий, но это должно проясниться само по себе."
	icon_state = "stun"

/obj/screen/alert/paralyzed
	name = "Паралич"
	desc = "Вы парализованы! Это может быть связано с наркотиками или серьезной травмой. Вы не сможете двигаться или выполнять действия."
	icon_state = "paralysis"

/obj/screen/alert/weakened
	name = "Слабость"
	desc = "Вы ослабли! Это может быть временная проблема из-за травмы или в результате употребления наркотиков или алкоголя."
	icon_state = "weaken"

/obj/screen/alert/confused
	name = "Конфуз"
	desc = "Вы запутались, и можете наткнуться на предметы! Это может быть связано с сотрясения мозга, наркотиками или головокружением. Ходьба поможет уменьшить количество инцидентов."
	icon_state = "confused"

/obj/screen/alert/high
	name = "High"
	desc = "Whoa man, you're tripping balls! Careful you don't get addicted... if you aren't already."
	icon_state = "high"

/obj/screen/alert/embeddedobject
	name = "Инородный Объект"
	desc = "Что-то застряло в вашей плоти и вызывает сильное кровотечение. Со временем оно может выпасть, но хирургия самый безопасный способ. Если вы чувствуете себя нормально, щелкните правой кнопкой мыши на себе и выберите \"Удалить инородный объект\", чтобы вытащить объект."
	icon_state = "embeddedobject"

/obj/screen/alert/embeddedobject/Click()
	if(isliving(usr))
		var/mob/living/carbon/human/M = usr
		return M.help_shake_act(M)

/obj/screen/alert/asleep
	name = "Во сне"
	desc = "Вы заснули. Подождите немного, и вы проснетесь. Если только вы этого не сделаете, учитывая, насколько вы беспомощны."
	icon_state = "asleep"

/obj/screen/alert/weightless
	name = "Невесомость"
	desc = "Гравитация перестала влиять на вас, и вы бесцельно летите. Вам понадобится что-то большое и тяжелое, например стена или решетка, чтобы оттолкнуться, если вы хотите двигаться. Реактивный ранец позволит свободно перемещаться. Пара магнитных ботинок позволит вам нормально ходить по полу. За исключением этого, вы можете бросать вещи, использовать огнетушитель или стрелять из пистолета, чтобы двигаться по 3-му закону движения Ньютона."
	icon_state = "weightless"

/obj/screen/alert/fire
	name = "В огне"
	desc = "Вы в огне. Остановитесь, упадите и покатайтесь по полу, чтобы потушить огонь или переместитесь в вакуумную зону."
	icon_state = "fire"

/obj/screen/alert/fire/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()


//ALIENS

/obj/screen/alert/alien_tox
	name = "Плазма"
	desc = "В воздухе есть горючая плазма. Если она загорится, вы будете поджарены."
	icon_state = "alien_tox"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_fire
// This alert is temporarily gonna be thrown for all hot air but one day it will be used for literally being on fire
	name = "Очень жарко"
	desc = "Здесь слишком жарко! Бегите в космос или хотя бы подальше от пламени. Стояние на сорняках исцелит вас."
	icon_state = "alien_fire"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_vulnerable
	name = "Смерть королевы"
	desc = "Ваша королева была убита, вы будете страдать от штрафов за передвижение и потерей hivemind. Новую королеву нельзя сделать, пока вы не поправитесь."
	icon_state = "alien_noqueen"
	alerttooltipstyle = "alien"

//BLOBS

/obj/screen/alert/nofactory
	name = "No Factory"
	desc = "You have no factory, and are slowly dying!"
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

//SILICONS

/obj/screen/alert/nocell
	name = "Нет энергоячейки"
	desc = "Юнит не имеет энергоячейки. Модули недоступны до тех пор, пока энергоячейка не будет переустановлена. Робототехник может оказать помощь."
	icon_state = "nocell"

/obj/screen/alert/emptycell
	name = "Нет заряда"
	desc = "В энергоячейке устройства не осталось заряда. Модули будут недоступны, пока энергоячейка не будет перезаряжена. Зарядные станции доступны в отделе робототехники, общих ванных комнатах и в комнате искусственного интеллекта."
	icon_state = "emptycell"

/obj/screen/alert/lowcell
	name = "Низкий заряд"
	desc = "Энергоячейка юнита на исходе. Зарядные станции имеются в отделе робототехники, общих ванных комнатах и в комнате искусственного интеллекта."
	icon_state = "lowcell"

//Need to cover all use cases - emag, illegal upgrade module, malf AI hack, traitor cyborg
/obj/screen/alert/hacked
	name = "Взломан"
	desc = "Обнаружено опасное нестандартное оборудование. Пожалуйста, убедитесь, что любое использование этого оборудования соответствует законам NT о продукции, если таковые имеются."
	icon_state = "hacked"
	no_underlay = TRUE

/obj/screen/alert/locked
	name = "Locked Down"
	desc = "Unit has been remotely locked down. Usage of a Robotics Control Console like the one in the Research Director's \
office by your AI master or any qualified human may resolve this matter. Robotics may provide further assistance if necessary."
	icon_state = "locked"
	no_underlay = TRUE

/obj/screen/alert/newlaw
	name = "Обновление законов"
	desc = "Законы были загружены в этот юнит или удалены из него. Пожалуйста, будьте в курсе любых изменений, чтобы оставаться в соответствии с самыми современными законами NT."
	icon_state = "newlaw"
	timeout = 300
	no_underlay = TRUE

//MECHS

/obj/screen/alert/low_mech_integrity
	name = "Mech Damaged"
	desc = "Mech integrity is low."
	icon_state = "low_mech_integrity"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/obj/screen/alert/notify_cloning
	name = "Revival"
	desc = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!"
	icon_state = "template"
	timeout = 300

/obj/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client) return
	var/mob/observer/dead/G = usr
	G.reenter_corpse()

// /obj/screen/alert/notify_jump
// 	name = "Body created"
// 	desc = "A body was created. You can enter it."
// 	icon_state = "template"
// 	timeout = 300
// 	var/atom/jump_target = null
// 	var/attack_not_jump = null

// /obj/screen/alert/notify_jump/Click()
// 	if(!usr || !usr.client) return
// 	if(!jump_target) return
// 	var/mob/dead/observer/G = usr
// 	if(!istype(G)) return
// 	if(attack_not_jump)
// 		jump_target.attack_ghost(G)
// 	else
// 		var/turf/T = get_turf(jump_target)
// 		if(T && isturf(T))
// 			G.loc = T

//OBJECT-BASED

/obj/screen/alert/restrained/buckled
	name = "Пристегнут"
	desc = "Вы были пристегнуты к чему-то. Нажмите эту кнопку, чтобы отстегнуться, если вы не в наручниках."

/obj/screen/alert/restrained/handcuffed
	name = "В наруч. (Рука)"
	desc = "Вы в наручниках и не можете действовать. Если кто-то будет тащить вас, вы не сможете двигаться. Нажмите на эту кнопку, чтобы освободиться."

/obj/screen/alert/restrained/legcuffed
	name = "В наруч. (Нога)"
	desc = "На вашей ноге наручники, что значительно замедляет ваш бег. Нажмите на эту кнопку, чтобы освободиться."

/obj/screen/alert/restrained/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()
// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= alerts.len, i++)
			mymob.client.screen -= alerts[alerts[i]]
		return 1
	for(var/i = 1, i <= alerts.len, i++)
		var/obj/screen/alert/alert = alerts[alerts[i]]

		if(alert.icon_state in cached_icon_states(ui_style))
			alert.icon = ui_style

		else if(!alert.no_underlay)
			var/image/I = image(icon = ui_style, icon_state = "template")
			I.color = ui_color
			I.alpha = ui_alpha
			alert.underlays = list(I)

		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		mymob?.client?.screen |= alert
	return 1

/mob
	var/list/alerts = list() // contains /obj/screen/alert only // On /mob so clientless mobs will throw alerts properly

/obj/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return
	var/paramslist = params2list(params)
	if(paramslist["shift"]) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr,"<span class='boldnotice'>[name]</span> - <span class='info'>[desc]</span>")
		return
	if(master)
		return usr.client.Click(master, location, control, params)

/obj/screen/alert/Destroy()
	..()
	severity = 0
	master = null
	screen_loc = ""
	return QDEL_HINT_QUEUE
