//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC"
	if(config.wikiurl)
		if(alert("Это действите откроет Вики сервера в вашем браузере. Вы уверены, что хотите продолжить?",,"Да","Нет")=="Нет")
			return
		src << link(config.wikiurl)
	else
		to_chat(src, "<span class='warning'>URL Вики не задан в конфигурации сервера.</span>")
		return
/*
/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		to_chat(src, "<span class='warning'>The forum URL is not set in the server configuration.</span>")
		return
*/

/client/verb/discordurl()
	set name = "discordurl"
	set desc = "Посетить сервер Discord."
	set hidden = 1
	if( config.discordurl )
		if(alert("Данное действие откроет приглашение на сервер Discord XenosStation в вашем браузере. Вы уверены, что хотите продолжить?",,"Да","Нет")=="Нет")
			return
		src << link(config.discordurl)
	else
		to_chat(src, "<span class='warning'>Сервер Discord не задан в конфигурации.</span>")
		return

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Показать правила сервера."
	set hidden = 1
	show_browser(src, file(RULES_FILE), "window=rules;size=1270x720")
#undef RULES_FILE

/*/client/verb/map()
	set name = "Map"
	set desc = "See the map."
	set hidden = 1

	if(config.mapurl)
		if(alert("This will open the map in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.mapurl)
	else
		to_chat(src, "<span class='danger'>The map URL is not set in the server configuration.</span>")
	return
	*/

/**/

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub"
	set hidden = 1

	if(config.githuburl)
		if(alert("Это действие откроет GitHub в вашем браузере. Вы уверены?",,"Да","Нет")=="Нет")
			return
		src << link(config.githuburl)
	else
		to_chat(src, "<span class='danger'>URL-адрес GitHub не задан в конфигурации сервера.</span>")
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Админ:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Режим Хоткей: (когда хоткей включен)
\tTAB = включение режима хоткей (при запуске на англ раскладке. иначе не будет работать)
\ta = влево
\ts = назад
\td = вправо
\tw = вперед
\tq = бросить
\te = снарядить
\tr = кинуть
\tt = сказать
\t5 = эмоция
\tx = сменить руку
\tz = активировать удерживаемый объект (или Y)
\tj = переключить режим прицеливания
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = режим помощи
\t2 = режим разоружения
\t3 = режим захвата
\t4 = режим вреда
\tCtrl+ЛКМ = тащить
\tShift+ЛКМ = изучить
</font>"}

	/*var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}
*/

	var/robot_hotkey_mode = {"<font color='purple'>
Режим Хоткей: (когда хоткей включен)
\tTAB = включение режима хоткей (при запуске на англ раскладке. иначе не будет работать)
\ta = влево
\ts = назад
\td = вправо
\tw = вперед
\tq = убрать активный модуль
\tt = сказать
\tx = сменить активный модуль
\tz = активировать удерживаемый объект (или Y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = включить модуль 1
\t2 = включить модуль 2
\t3 = включить модуль 3
\t4 = переключение режима
\t5 = эмоции
\tCtrl+ЛКМ = тащить
\tShift+ЛКМ = изучить
</font>"}

/*	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}
*/

	if(isrobot(src.mob))
		to_chat(src,robot_hotkey_mode)
	//	to_chat(src,robot_other)
	else
		to_chat(src,hotkey_mode)
	//	to_chat(src,other)
	if(holder)
		to_chat(src,admin)

// Set the DreamSeeker input macro to the type appropriate for its mob
/client/proc/set_hotkeys_macro(macro_name = "macro", hotkey_macro_name = "hotkeymode", hotkeys_enabled = null)
	// If hotkeys mode was not specified, fall back to choice of default in client preferences.
	if(isnull(hotkeys_enabled))
		hotkeys_enabled = is_preference_enabled(/datum/client_preference/hotkeys_default)

	if(hotkeys_enabled)
		winset(src, null, "mainwindow.macro=[hotkey_macro_name] hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=[macro_name] hotkey_toggle.is-checked=false input.focus=true")
