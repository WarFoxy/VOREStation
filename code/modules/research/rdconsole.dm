/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second method is with Technology Disks and Design Disks. Each of these disks can hold a single technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This method is a lot more secure (since it
won't update every console in existence) but it's more of a hassle to do. Also, the disks can be stolen.
*/

/obj/machinery/computer/rdconsole
	name = "R&D control console"
	desc = "Science, in a computer! Experiment results not guaranteed."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/weapon/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/weapon/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/screen = 1.0	//Which screen is currently showing.
	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

	var/protofilter //String to filter protolathe designs by
	var/circuitfilter //String to filter circuit designs by

/obj/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if("metal")
			return_name = "Metal"
		if("glass")
			return_name = "Glass"
		if("gold")
			return_name = "Gold"
		if("silver")
			return_name = "Silver"
		if("phoron")
			return_name = "Solid Phoron"
		if("uranium")
			return_name = "Uranium"
		if("diamond")
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/ID)
	var/return_name = ID
	var/datum/reagent/temp_reagent
	for(var/R in (typesof(/datum/reagent) - /datum/reagent))
		temp_reagent = null
		temp_reagent = new R()
		if(temp_reagent.id == ID)
			return_name = temp_reagent.name
			qdel(temp_reagent)
			temp_reagent = null
			break
	return return_name

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(3, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/proc/griefProtection() //Have it automatically push research to the CentCom server so wild griffins can't fuck up R&D's work
	for(var/obj/machinery/r_n_d/server/centcom/C in machines)
		for(var/datum/tech/T in files.known_tech)
			C.files.AddTech2Known(T)
		for(var/datum/design/D in files.known_designs)
			C.files.AddDesign2Known(D)
		C.files.RefreshResearch()

/obj/machinery/computer/rdconsole/New()
	..()
	files = new /datum/research(src) //Setup the research data holder.
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in machines)
			S.update_connections()
			break

/obj/machinery/computer/rdconsole/Initialize()
	SyncRDevices()
	. = ..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	//Loading a disk into it.
	if(istype(D, /obj/item/weapon/disk))
		if(t_disk || d_disk)
			to_chat(user, "Диск уже загружен в машину.")
			return

		if(istype(D, /obj/item/weapon/disk/tech_disk))
			t_disk = D
		else if (istype(D, /obj/item/weapon/disk/design_disk))
			d_disk = D
		else
			to_chat(user, "<span class='notice'>Машина не может принимать диски в этом формате.</span>")
			return
		user.drop_item()
		D.loc = src
		to_chat(user, "<span class='notice'>Вы добавляете [D] в машину.</span>")
	else
		//The construction/deconstruction of the console code.
		..()

	src.updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>Вы отключаете протоколы безопасности.</span>")
		return 1

/obj/machinery/computer/rdconsole/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	usr.set_machine(src)
	if((screen < 1 || (screen == 1.6 && href_list["menu"] != "1.0")) && (!allowed(usr) && !emagged)) //Stops people from HREF exploiting out of the lock screen, but allow it if they have the access.
		to_chat(usr, "Не авторизованный доступ")
		return

	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		var/temp_screen = text2num(href_list["menu"])
		if(temp_screen <= 1.1 || (3 <= temp_screen && 4.9 >= temp_screen) || allowed(usr) || emagged) //Unless you are making something, you need access.
			screen = temp_screen
		else
			to_chat(usr, "Не авторизованный доступ.")

	else if(href_list["updt_tech"]) //Update the research holder with information from the technology disk.
		screen = 0.0
		spawn(5 SECONDS)
			screen = 1.2
			files.AddTech2Known(t_disk.stored)
			updateUsrDialog()
			griefProtection() //Update CentCom too

	else if(href_list["clear_tech"]) //Erase data on the technology disk.
		t_disk.stored = null

	else if(href_list["eject_tech"]) //Eject the technology disk.
		t_disk.loc = loc
		t_disk = null
		screen = 1.0

	else if(href_list["copy_tech"]) //Copys some technology data from the research holder to the disk.
		for(var/datum/tech/T in files.known_tech)
			if(href_list["copy_tech_ID"] == T.id)
				t_disk.stored = T
				break
		screen = 1.2

	else if(href_list["updt_design"]) //Updates the research holder with design data from the design disk.
		screen = 0.0
		spawn(5 SECONDS)
			screen = 1.4
			files.AddDesign2Known(d_disk.blueprint)
			updateUsrDialog()
			griefProtection() //Update CentCom too

	else if(href_list["clear_design"]) //Erases data on the design disk.
		d_disk.blueprint = null

	else if(href_list["eject_design"]) //Eject the design disk.
		d_disk.loc = loc
		d_disk = null
		screen = 1.0

	else if(href_list["copy_design"]) //Copy design data from the research holder to the design disk.
		for(var/datum/design/D in files.known_designs)
			if(href_list["copy_design_ID"] == D.id)
				d_disk.blueprint = D
				break
		screen = 1.4

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>Деструктивный анализатор в данный момент занят.</span>")

			else if(linked_destroy.loaded_item)
				linked_destroy.loaded_item.loc = linked_destroy.loc
				linked_destroy.loaded_item = null
				linked_destroy.icon_state = "d_analyzer"
				screen = 2.1

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>Деструктивный анализатор в данный момент занят.</span>")
			else
				if(alert("Продолжение уничтожит загруженный предмет. Продолжить?", "Destructive analyzer confirmation", "Да", "Нет") == "Нет" || !linked_destroy)
					return
				linked_destroy.busy = 1
				screen = 0.1
				updateUsrDialog()
				flick("d_analyzer_process", linked_destroy)
				spawn(2.4 SECONDS)
					if(linked_destroy)
						linked_destroy.busy = 0
						if(!linked_destroy.loaded_item)
							to_chat(usr, "<span class='notice'>Деструктивный анализатор пуст.</span>")
							screen = 1.0
							return

						for(var/T in linked_destroy.loaded_item.origin_tech)
							files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
						if(linked_lathe && linked_destroy.loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
							for(var/t in linked_destroy.loaded_item.matter)
								if(t in linked_lathe.materials)
									linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)

						linked_destroy.loaded_item = null
						for(var/obj/I in linked_destroy.contents)
							for(var/mob/M in I.contents)
								M.death()
							if(istype(I,/obj/item/stack/material))//Only deconsturcts one sheet at a time instead of the entire stack
								var/obj/item/stack/material/S = I
								if(S.get_amount() > 1)
									S.use(1)
									linked_destroy.loaded_item = S
								else
									qdel(S)
									linked_destroy.icon_state = "d_analyzer"
							else
								if(I != linked_destroy.circuit && !(I in linked_destroy.component_parts))
									qdel(I)
									linked_destroy.icon_state = "d_analyzer"

						use_power(linked_destroy.active_power_usage)
						screen = 1.0
						updateUsrDialog()

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr))
			screen = text2num(href_list["lock"])
		else
			to_chat(usr, "Не авторизованный доступ.")

	else if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		screen = 0.0
		if(!sync)
			to_chat(usr, "<span class='notice'>Сначала вы должны подключиться к сети.</span>")
		else
			griefProtection() //Putting this here because I dont trust the sync process
			spawn(3 SECONDS)
				if(src)
					for(var/obj/machinery/r_n_d/server/S in machines)
						var/server_processed = 0
						if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in files.known_tech)
								S.files.AddTech2Known(T)
							for(var/datum/design/D in files.known_designs)
								S.files.AddDesign2Known(D)
							S.files.RefreshResearch()
							server_processed = 1
						if((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in S.files.known_tech)
								files.AddTech2Known(T)
							for(var/datum/design/D in S.files.known_designs)
								files.AddDesign2Known(D)
							files.RefreshResearch()
							server_processed = 1
						if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
							S.produce_heat()
					screen = 1.6
					updateUsrDialog()

	else if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync

	else if(href_list["build"]) //Causes the Protolathe to build something.
		if(linked_lathe)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["build"])
					being_built = D
					break
			if(being_built)
				linked_lathe.addToQueue(being_built)

	else if(href_list["buildfive"]) //Causes the Protolathe to build 5 of something.
		if(linked_lathe)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["buildfive"])
					being_built = D
					break
			if(being_built)
				for(var/i = 1 to 5)
					linked_lathe.addToQueue(being_built)

		screen = 3.1

	else if(href_list["protofilter"])
		var/filterstring = input(usr, "Введите строку фильтра или оставьте пустым, чтобы не фильтровать:", "Design Filter", protofilter) as null|text
		if(!Adjacent(usr))
			return
		if(isnull(filterstring)) //Clicked Cancel
			return
		if(filterstring == "") //Cleared value
			protofilter = null
		protofilter = sanitize(filterstring, 25)

	else if(href_list["circuitfilter"])
		var/filterstring = input(usr, "Введите строку фильтра или оставьте пустым, чтобы не фильтровать:", "Design Filter", circuitfilter) as null|text
		if(!Adjacent(usr))
			return
		if(isnull(filterstring)) //Clicked Cancel
			return
		if(filterstring == "") //Cleared value
			circuitfilter = null
		circuitfilter = sanitize(filterstring, 25)

	else if(href_list["imprint"]) //Causes the Circuit Imprinter to build something.
		if(linked_imprinter)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["imprint"])
					being_built = D
					break
			if(being_built)
				linked_imprinter.addToQueue(being_built)
		screen = 4.1

	else if(href_list["disposeI"] && linked_imprinter)  //Causes the circuit imprinter to dispose of a single reagent (all of it)
		linked_imprinter.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallI"] && linked_imprinter) //Causes the circuit imprinter to dispose of all it's reagents.
		linked_imprinter.reagents.clear_reagents()

	else if(href_list["removeI"] && linked_lathe)
		linked_imprinter.removeFromQueue(text2num(href_list["removeI"]))

	else if(href_list["disposeP"] && linked_lathe)  //Causes the protolathe to dispose of a single reagent (all of it)
		linked_lathe.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallP"] && linked_lathe) //Causes the protolathe to dispose of all it's reagents.
		linked_lathe.reagents.clear_reagents()

	else if(href_list["removeP"] && linked_lathe)
		linked_lathe.removeFromQueue(text2num(href_list["removeP"]))

	else if(href_list["lathe_ejectsheet"] && linked_lathe) //Causes the protolathe to eject a sheet of material
		linked_lathe.eject(href_list["lathe_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["imprinter_ejectsheet"] && linked_imprinter) //Causes the protolathe to eject a sheet of material
		linked_imprinter.eject(href_list["imprinter_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["find_device"]) //The R&D console looks for devices nearby to link up with.
		screen = 0.0
		spawn(10)
			SyncRDevices()
			screen = 1.7
			updateUsrDialog()

	else if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		switch(href_list["disconnect"])
			if("destroy")
				linked_destroy.linked_console = null
				linked_destroy = null
			if("lathe")
				linked_lathe.linked_console = null
				linked_lathe = null
			if("imprinter")
				linked_imprinter.linked_console = null
				linked_imprinter = null

	else if(href_list["reset"]) //Reset the R&D console's database.
		griefProtection()
		var/choice = alert("Сброс базы данных консоли R&D", "Вы уверены, что хотите сбросить базу данных консоли R&D? Потерянные данные не могут быть восстановлены.", "Продолжить", "Отмена")
		if(choice == "Продолжить")
			screen = 0.0
			qdel(files)
			files = new /datum/research(src)
			spawn(20)
				screen = 1.6
				updateUsrDialog()

	else if (href_list["print"]) //Print research information
		screen = 0.5
		spawn(20)
			var/obj/item/weapon/paper/PR = new/obj/item/weapon/paper
			PR.name = "список исследованных технологий"
			PR.info = "<meta charset=\"utf-8\"><center><b>[station_name()] Научные лаборатории</b>"
			PR.info += "<h2>[ (text2num(href_list["print"]) == 2) ? "Подробный" : null] отчет о проделанной работе</h2>"
			PR.info += "<i>отчет составлен в [stationtime2text()] от времени станции</i></center><br>"
			if(text2num(href_list["print"]) == 2)
				PR.info += GetResearchListInfo()
			else
				PR.info += GetResearchLevelsInfo()
			PR.info_links = PR.info
			PR.icon_state = "paper_words"
			PR.loc = src.loc
			spawn(10)
				screen = ((text2num(href_list["print"]) == 2) ? 5.0 : 1.1)
				updateUsrDialog()

	updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/list/dat = list()
	dat += "<meta charset=\"utf-8\"><UL>"
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "[T.name]"
		dat += "<UL>"
		dat +=  "<LI>Уровень: [T.level]"
		dat +=  "<LI>Сводка: [T.desc]"
		dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/list/dat = list()
	dat += "<UL>"
	for(var/datum/design/D in files.known_designs)
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	user.set_machine(src)
	var/list/dat = list()
	files.RefreshResearch()
	switch(screen) //A quick check to make sure you get the right screen when a device is disconnected.
		if(2 to 2.9)
			if(linked_destroy == null)
				screen = 2.0
			else if(linked_destroy.loaded_item == null)
				screen = 2.1
			else
				screen = 2.2
		if(3 to 3.9)
			if(linked_lathe == null)
				screen = 3.0
		if(4 to 4.9)
			if(linked_imprinter == null)
				screen = 4.0

	switch(screen)

		//////////////////////R&D CONSOLE SCREENS//////////////////
		if(0.0)
			dat += "Обновление Базы Данных..."

		if(0.1)
			dat += "Обработка и обновление базы данных..."

		if(0.2)
			dat += "СИСТЕМА ЗАБЛОКИРОВАНА<BR><BR>"
			dat += "<A href='?src=\ref[src];lock=1.6'>Разблокировать</A>"

		if(0.3)
			dat += "Построение прототипа. Пожалуйста подождите..."

		if(0.4)
			dat += "Печать схемы. Пожалуйста подождите..."

		if(0.5)
			dat += "Печать исследовательской информации. Пожалуйста подождите..."

		if(1.0) //Main Menu
			dat += "Главное меню:<BR><BR>"
			dat += "Загруженный диск: "
			dat += (t_disk || d_disk) ? (t_disk ? "technology storage disk" : "design storage disk") : "нет"
			dat += "<HR><UL>"
			dat += "<LI><A href='?src=\ref[src];menu=1.1'>Текущие Уровни Исследований</A>"
			dat += "<LI><A href='?src=\ref[src];menu=5.0'>Просмотр Исследованных Технологий</A>"
			if(t_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.2'>Дисковые операции</A>"
			else if(d_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.4'>Дисковые операции</A>"
			else
				dat += "<LI><span class='linkOff'>Дисковые операции</span>"
			if(linked_destroy)
				dat += "<LI><A href='?src=\ref[src];menu=2.2'>Меню Деструктивного Анализатора</A>"
			if(linked_lathe)
				dat += "<LI><A href='?src=\ref[src];menu=3.1'>Меню конструкций Протолата</A>"
			if(linked_imprinter)
				dat += "<LI><A href='?src=\ref[src];menu=4.1'>Меню печати схем</A>"
			dat += "<LI><A href='?src=\ref[src];menu=1.6'>Настройки</A>"
			dat += "</UL>"

		if(1.1) //Research viewer
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];print=1'>Печать страницы</A><HR>"
			dat += "Текущие Уровни Исследований:<BR><BR>"
			dat += GetResearchLevelsInfo()
			dat += "</UL>"

		if(1.2) //Technology Disk Menu

			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "Содержимое Диска: (Диск с технологическими данными)<BR><BR>"
			if(t_disk.stored == null)
				dat += "На диске нет данных.<HR>"
				dat += "Операции: "
				dat += "<A href='?src=\ref[src];menu=1.3'>Загрузить технологию на диск</A> || "
			else
				dat += "Имя: [t_disk.stored.name]<BR>"
				dat += "Уровень: [t_disk.stored.level]<BR>"
				dat += "Пояснение: [t_disk.stored.desc]<HR>"
				dat += "Операции: "
				dat += "<A href='?src=\ref[src];updt_tech=1'>Загрузка в базу данных</A> || "
				dat += "<A href='?src=\ref[src];clear_tech=1'>Очистить диск</A> || "
			dat += "<A href='?src=\ref[src];eject_tech=1'>Извлечь диск</A>"

		if(1.3) //Technology Disk submenu
			dat += "<BR><A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=1.2'>Вернуться к дисковым операциям</A><HR>"
			dat += "Загрузить технологию на диск:<BR><BR>"
			dat += "<UL>"
			for(var/datum/tech/T in files.known_tech)
				dat += "<LI>[T.name] "
				dat += "\[<A href='?src=\ref[src];copy_tech=1;copy_tech_ID=[T.id]'>копирование на диск</A>\]"
			dat += "</UL>"

		if(1.4) //Design Disk menu.
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			if(d_disk.blueprint == null)
				dat += "На диске нет никаких данных.<HR>"
				dat += "Операции: "
				dat += "<A href='?src=\ref[src];menu=1.5'>Загрузить конструкцию на диск</A> || "
			else
				dat += "Название: [d_disk.blueprint.name]<BR>"
				switch(d_disk.blueprint.build_type)
					if(IMPRINTER) dat += "Тип станка: Аппарат печати схем<BR>"
					if(PROTOLATHE) dat += "Тип станка: Протолат<BR>"
				dat += "Требуемые материалы:<BR>"
				for(var/M in d_disk.blueprint.materials)
					if(copytext_char(M, 1, 2) == "$") dat += "* [copytext_char(M, 2)] x [d_disk.blueprint.materials[M]]<BR>"
					else dat += "* [M] x [d_disk.blueprint.materials[M]]<BR>"
				dat += "<HR>Операции: "
				dat += "<A href='?src=\ref[src];updt_design=1'>Загрузить в БД</A> || "
				dat += "<A href='?src=\ref[src];clear_design=1'>Очистить диск</A> || "
			dat += "<A href='?src=\ref[src];eject_design=1'>Извлечь диск</A>"

		if(1.5) //Technology disk submenu
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=1.4'>Вернуться к дисковым операциям</A><HR>"
			dat += "Загрузить конструкцию на диск:<BR><BR>"
			dat += "<UL>"
			for(var/datum/design/D in files.known_designs)
				if(D.build_path)
					dat += "<LI>[D.name] "
					dat += "<A href='?src=\ref[src];copy_design=1;copy_design_ID=[D.id]'>\[скопировать на диск\]</A>"
			dat += "</UL>"

		if(1.6) //R&D console settings
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "R&D Console Setting:<HR>"
			dat += "<UL>"
			if(sync)
				dat += "<LI><A href='?src=\ref[src];sync=1'>Синхронизировать БД с сетью</A><BR>"
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Отключиться от исследовательской сети</A><BR>"
			else
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Подключиться от исследовательской сети</A><BR>"
			dat += "<LI><A href='?src=\ref[src];menu=1.7'>Меню устройства связи</A><BR>"
			dat += "<LI><A href='?src=\ref[src];lock=0.2'>Блокировка консоли</A><BR>"
			dat += "<LI><A href='?src=\ref[src];reset=1'>Сброс БД R&D</A><BR>"
			dat += "<UL>"

		if(1.7) //R&D device linkage
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=1.6'>Настройки</A><HR>"
			dat += "R&D Меню привязки консольного устройства:<BR><BR>"
			dat += "<A href='?src=\ref[src];find_device=1'>Повторная синхронизация с соседними устройствами</A><HR>"
			dat += "Связанные устройства:"
			dat += "<UL>"
			if(linked_destroy)
				dat += "<LI>Деструктивный анализатор <A href='?src=\ref[src];disconnect=destroy'>(Отключен)</A>"
			else
				dat += "<LI>(Нет связанного Деструктивного анализатора)"
			if(linked_lathe)
				dat += "<LI>Протолат <A href='?src=\ref[src];disconnect=lathe'>(Отключен)</A>"
			else
				dat += "<LI>(Нет связанного Протолата)"
			if(linked_imprinter)
				dat += "<LI>Аппарат печати схем <A href='?src=\ref[src];disconnect=imprinter'>(Отключен)</A>"
			else
				dat += "<LI>(Нет связанного Аппарата печати схем)"
			dat += "</UL>"

		////////////////////DESTRUCTIVE ANALYZER SCREENS////////////////////////////
		if(2.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "ДЕСТРУКТИВНЫЙ АНАЛИЗАТОР НЕ СВЯЗАН С КОНСОЛЬЮ<BR><BR>"

		if(2.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "Предмет не загружен. Ожидайте...<BR><HR>"

		if(2.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "Меню деконструкции<HR>"
			dat += "Название: [linked_destroy.loaded_item.name]<BR>"
			dat += "Исходник:"
			dat += "<UL>"
			for(var/T in linked_destroy.loaded_item.origin_tech)
				dat += "<LI>[CallTechName(T)] [linked_destroy.loaded_item.origin_tech[T]]"
				for(var/datum/tech/F in files.known_tech)
					if(F.name == CallTechName(T))
						dat += " (Текущий: [F.level])"
						break
			dat += "</UL>"
			dat += "<HR><A href='?src=\ref[src];deconstruct=1'>Деконструировать</A> || "
			dat += "<A href='?src=\ref[src];eject_item=1'>Извлечь предмет</A> || "

		/////////////////////PROTOLATHE SCREENS/////////////////////////
		if(3.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "ПРОТОЛАТ НЕ СВЯЗАН С КОНСОЛЬЮ<BR><BR>"

		if(3.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=3.4'>Просмотр очереди</A> || "
			dat += "<A href='?src=\ref[src];menu=3.2'>Хранилище материалов</A> || "
			dat += "<A href='?src=\ref[src];menu=3.3'>Хранилище химикатов</A><HR>"
			dat += "Меню Протолата:<BR><BR>"
			dat += "<B>Кол-во материалов:</B> [linked_lathe.TotalMaterials()] cm<sup>3</sup> (MAX: [linked_lathe.max_material_storage])<BR>"
			dat += "<B>Кол-во химикатов:</B> [linked_lathe.reagents.total_volume] (MAX: [linked_lathe.reagents.maximum_volume])<HR>"
			dat += "<UL>"
			dat += "<B>Фильтр:</B> <A href='?src=\ref[src];protofilter=1'>[protofilter ? protofilter : "None Set"]</A>"
			for(var/datum/design/D in files.known_designs)
				if(!D.build_path || !(D.build_type & PROTOLATHE))
					continue
				if(protofilter && findtext(D.name, protofilter) == 0)
					continue
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]*linked_lathe.mat_efficiency] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*linked_lathe.mat_efficiency] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext_char(temp_dat, 3)]\]"
				if(linked_lathe.canBuild(D))
					dat += "<LI><B><A href='?src=\ref[src];build=[D.id]'>[D.name]</A></B>(<A href='?src=\ref[src];buildfive=[D.id]'>x5</A>)[temp_dat]"
				else
					dat += "<LI><B>[D.name]</B>[temp_dat]"
			dat += "</UL>"

		if(3.2) //Protolathe Material Storage Sub-menu
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Меню Протолата</A><HR>"
			dat += "Хранилище материалов<BR><HR>"
			dat += "<UL>"
			for(var/M in linked_lathe.materials)
				var/amount = linked_lathe.materials[M]
				var/hidden_mat = FALSE
				for(var/HM in linked_lathe.hidden_materials)
					if(M == HM && amount == 0)
						hidden_mat = TRUE
						break
				if(hidden_mat)
					continue
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Извлечь "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];lathe_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];lathe_ejectsheet=[M];amount=50'>макс</A> sheets"
				dat += ""
			dat += "</UL>"

		if(3.3) //Protolathe Chemical Storage Submenu
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Меню Протолата</A><HR>"
			dat += "Chemical Storage:<BR><HR>"
			for(var/datum/reagent/R in linked_lathe.reagents.reagent_list)
				dat += "Название: [R.name] | Кол-во: [R.volume] "
				dat += "<A href='?src=\ref[src];disposeP=[R.id]'>(Очистка)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallP=1'><U>Утилизировать все химикаты</U></A><BR>"

		if(3.4) // Protolathe queue
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Меню Протолата</A><HR>"
			dat += "Очередь Протолата:<BR><HR>"
			if(!linked_lathe.queue.len)
				dat += "Пусто"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_lathe.queue)
					if(tmp == 1)
						if(linked_lathe.busy)
							dat += "<B>1: [D.name]</B><BR>"
						else
							dat += "<B>1: [D.name]</B> (Необх. материалы) <A href='?src=\ref[src];removeP=[tmp]'>(Удалить)</A><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeP=[tmp]'>(Удалить)</A><BR>"
					++tmp

		///////////////////CIRCUIT IMPRINTER SCREENS////////////////////
		if(4.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A><HR>"
			dat += "АППАРАТ ПЕЧАТИ СХЕМ НЕ СВЯЗАН С КОНСОЛЬЮ<BR><BR>"

		if(4.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=4.4'>Просмотреть очередь</A> || "
			dat += "<A href='?src=\ref[src];menu=4.3'>Хранилище материалов</A> || "
			dat += "<A href='?src=\ref[src];menu=4.2'>Хранилище химикатов</A><HR>"
			dat += "Меню печати схем:<BR><BR>"
			dat += "Кол-во материалов: [linked_imprinter.TotalMaterials()] cm<sup>3</sup><BR>"
			dat += "Кол-во химикатов: [linked_imprinter.reagents.total_volume]<HR>"
			dat += "<UL>"
			dat += "<B>Фильтр:</B> <A href='?src=\ref[src];circuitfilter=1'>[circuitfilter ? circuitfilter : "Не установлен"]</A>"
			for(var/datum/design/D in files.known_designs)
				if(!D.build_path || !(D.build_type & IMPRINTER))
					continue
				if(circuitfilter && findtext(D.name, circuitfilter) == 0)
					continue
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]*linked_imprinter.mat_efficiency] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*linked_imprinter.mat_efficiency] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext_char(temp_dat,3)]\]"
				if(linked_imprinter.canBuild(D))
					dat += "<LI><B><A href='?src=\ref[src];imprint=[D.id]'>[D.name]</A></B>[temp_dat]"
				else
					dat += "<LI><B>[D.name]</B>[temp_dat]"
			dat += "</UL>"

		if(4.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Меню печати схем</A><HR>"
			dat += "Хранилище химикатов<BR><HR>"
			for(var/datum/reagent/R in linked_imprinter.reagents.reagent_list)
				dat += "Название: [R.name] | Кол-во: [R.volume] "
				dat += "<A href='?src=\ref[src];disposeI=[R.id]'>(Очистка)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallI=1'><U>Утилизировать все химикаты</U></A><BR>"

		if(4.3)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Меню печати плат</A><HR>"
			dat += "Хранилище материала<BR><HR>"
			dat += "<UL>"
			for(var/M in linked_imprinter.materials)
				var/amount = linked_imprinter.materials[M]
				var/hidden_mat = FALSE
				for(var/HM in linked_imprinter.hidden_materials)
					if(M == HM && amount == 0)
						hidden_mat = TRUE
						break
				if(hidden_mat)
					continue
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Извлечь: "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=50'>макс</A> sheets"
				dat += ""
			dat += "</UL>"

		if(4.4)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Меню печати плат</A><HR>"
			dat += "Queue<BR><HR>"
			if(linked_imprinter.queue.len == 0)
				dat += "Empty"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_imprinter.queue)
					if(tmp == 1)
						dat += "<B>1: [D.name]</B><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeI=[tmp]'>(Удалить)</A><BR>"
					++tmp

		///////////////////Research Information Browser////////////////////
		if(5.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Главное меню</A> || "
			dat += "<A href='?src=\ref[src];print=2'>Печать страницы</A><HR>"
			dat += "Перечень исследованных технологий и конструкций:"
			dat += GetResearchListInfo()

	dat = jointext(dat, null)
	var/datum/browser/popup = new(user, "rdconsole", "Research and Development Console", 850, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	id = 2
	req_access = list(access_robotics)

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1
