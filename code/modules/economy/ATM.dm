/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/weapon/card/id/var/money = 2000

/obj/machinery/atm
	name = "Automatic Teller Machine"
	desc = "Для всех ваших денежных потребностей!"
	icon = 'icons/obj/terminals_vr.dmi' //VOREStation Edit
	icon_state = "atm"
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit =  /obj/item/weapon/circuitboard/atm
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/weapon/card/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/machinery/atm/New()
	..()
	machine_id = "[station_name()] RT #[num_financial_terminals++]"
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/process()
	if(stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/weapon/spacecash/S in src)
		S.loc = src.loc
		if(prob(50))
			playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(src, 'sound/items/polaroid2.ogg', 50, 1)
		break

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		return

	//short out the machine, shoot sparks, spew money!
	emagged = 1
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Инициирование выдачи. Хорошего дня!", "CRITICAL ERROR: Activating cash chamber panic siphon.","ПИН-код принят! Очистка баланса аккаунта.", "Джепот!")
	to_chat(user, "<span class='warning'>[bicon(src)] The [src] beeps: \"[response]\"</span>")
	return 1

/obj/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	if(istype(I, /obj/item/weapon/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			to_chat(user, "<font color='red'>[bicon(src)] ОШИБКА СЧИТЫВАТЕЛЯ КАРТЫ. Эта система была взломана!</font>")
			return
		else if(istype(I,/obj/item/weapon/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/weapon/card/id/idcard = I
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I,/obj/item/weapon/spacecash))
			//consume the money
			authenticated_account.money += I:worth
			if(prob(50))
				playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(src, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = current_date_string
			T.time = stationtime2text()
			authenticated_account.transaction_log.Add(T)

			to_chat(user, "<span class='info'>Вы вставляете [I] в [src].</span>")
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/silicon))
		to_chat (user, "<span class='warning'>Брандмауэр не позволяет вам взаимодействовать с этим устройством!</span>")
		return
	if(get_dist(src,user) <= 1)

		//js replicated from obj/machinery/computer/card
		var/dat = "<meta charset=\"utf-8\"><h1>Банкомат</h1>"
		dat += "Для всех ваших денежных потребностей!<br>"
		dat += "<i>Это терминал:</i> [machine_id]. <i>Сообщите этот код при обращении в службу поддержки</i><br/>"

		if(emagged > 0)
			dat += "Карта: <span style='color: red;'>БЛОК</span><br><br><span style='color: red;'>Обнаружен несанкционированный доступ к терминалу! Этот банкомат был заблокирован. Пожалуйста, свяжитесь с ИТ-поддержкой.</span>"
		else
			dat += "Карта: <a href='?src=\ref[src];choice=insert_card'>[held_card ? held_card.name : "------"]</a><br><br>"

			if(ticks_left_locked_down > 0)
				dat += "<span class='alert'>Превышено максимальное количество попыток ввода пин-кода! Доступ к этому банкомату был временно отключен.</span>"
			else if(authenticated_account)
				if(authenticated_account.suspended)
					dat += "<font color='red'><b>Доступ к этому аккаунту был приостановлен, а средства заморожены.</b></font>"
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							dat += "Выберите новый уровень безопасности для этого аккаута:<br><hr>"
							var/text = "Ноль - для доступа к этому аккаунту требуется либо номер счета, либо карта. Для транзакций EFTPOS потребуется карта и ввод пин-кода, но не для проверки правильности пин-кода."
							if(authenticated_account.security_level != 0)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=0'>[text]</a>"
							dat += "[text]<hr>"
							text = "Первый - номер счета и пин-код должны быть введены вручную для доступа к этому аккауту и обработки транзакций."
							if(authenticated_account.security_level != 1)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=1'>[text]</a>"
							dat += "[text]<hr>"
							text = "Второй - В дополнение к номеру счета и пин-коду, для доступа к аккауту и обработки транзакций требуется карта."
							if(authenticated_account.security_level != 2)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=2'>[text]</a>"
							dat += "[text]<hr><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
						if(VIEW_TRANSACTION_LOGS)
							dat += "<b>Журналы транзакций</b><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
							dat += "<table border=1 style='width:100%'>"
							dat += "<tr>"
							dat += "<td><b>Дата</b></td>"
							dat += "<td><b>Время</b></td>"
							dat += "<td><b>Цель</b></td>"
							dat += "<td><b>Задача</b></td>"
							dat += "<td><b>Количество</b></td>"
							dat += "<td><b>ID Терминала</b></td>"
							dat += "</tr>"
							for(var/datum/transaction/T in authenticated_account.transaction_log)
								dat += "<tr>"
								dat += "<td>[T.date]</td>"
								dat += "<td>[T.time]</td>"
								dat += "<td>[T.target_name]</td>"
								dat += "<td>[T.purpose]</td>"
								dat += "<td>$[T.amount]</td>"
								dat += "<td>[T.source_terminal]</td>"
								dat += "</tr>"
							dat += "</table>"
							dat += "<A href='?src=\ref[src];choice=print_transaction'>Печать</a><br>"
						if(TRANSFER_FUNDS)
							dat += "<b>Баланс:</b> $[authenticated_account.money]<br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Назад</a><br><br>"
							dat += "<form name='transfer' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='hidden' name='choice' value='transfer'>"
							dat += "Номер счета для перевода: <input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
							dat += "Количество для перевода: <input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
							dat += "Цель сделки: <input type='text' name='purpose' value='Перевод средств' style='width:200px; background-color:white;'><br>"
							dat += "<input type='submit' value='Перевод средств'><br>"
							dat += "</form>"
						else
							dat += "Приветствуем, <b>[authenticated_account.owner_name].</b><br/>"
							dat += "<b>Баланс:</b> $[authenticated_account.money]"
							dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='radio' name='choice' value='withdrawal' checked> Наличка  <input type='radio' name='choice' value='e_withdrawal'> Карточка<br>"
							dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Выдать'>"
							dat += "</form>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=1'>Изменить уровень безопасности</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=2'>Совершить перевод</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=3'>Посмотреть журнал транзакций</a><br>"
							dat += "<A href='?src=\ref[src];choice=balance_statement'>Распечатать информацию о счете</a><br>"
							dat += "<A href='?src=\ref[src];choice=logout'>Выйти</a><br>"
			else
				dat += "<form name='atm_auth' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='attempt_auth'>"
				dat += "<b>Аккаунт:</b> <input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><br>"
				dat += "<b>ПИН:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
				dat += "<input type='submit' value='Подтвердить'><br>"
				dat += "</form>"

		user << browse(dat,"window=atm;size=550x650")
	else
		user << browse(null,"window=atm")

/obj/machinery/atm/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("Это не действительная сумма.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list["target_acc_number"])
						var/transfer_purpose = href_list["purpose"]
						if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							to_chat(usr, "[bicon(src)]<span class='info'>Средства успешно отправлены.</span>")
							authenticated_account.money -= transfer_amount

							//create an entry in the account transaction log
							var/datum/transaction/T = new()
							T.target_name = "Account #[target_account_number]"
							T.purpose = transfer_purpose
							T.source_terminal = machine_id
							T.date = current_date_string
							T.time = stationtime2text()
							T.amount = "([transfer_amount])"
							authenticated_account.transaction_log.Add(T)
						else
							to_chat(usr, "[bicon(src)]<span class='warning'>Ошибка отправки средств.</span>")

					else
						to_chat(usr, "[bicon(src)]<span class='warning'>У вас недостаточно средств для этого!</span>")
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max( min(text2num(href_list["new_security_level"]), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")

				// check if they have low security enabled
				scan_user(usr)

				if(!ticks_left_locked_down && held_card)
					var/tried_account_num = text2num(href_list["account_num"])
					if(!tried_account_num)
						tried_account_num = held_card.associated_account_number
					var/tried_pin = text2num(href_list["account_pin"])

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries > max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									var/datum/transaction/T = new()
									T.target_name = failed_account.owner_name
									T.purpose = "Unauthorised login attempt"
									T.source_terminal = machine_id
									T.date = current_date_string
									T.time = stationtime2text()
									failed_account.transaction_log.Add(T)
							else
								to_chat(usr, "<font color='red'>[bicon(src)] Введена неправильная комбинация пин-код/аккаунт, осталось попыток [max_pin_attempts - number_incorrect_tries].</font>")
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							to_chat(usr, "<font color='red'>[bicon(src)] введена неправильная комбинация пин-код/аккаунт.</font>")
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN

						//create a transaction log entry
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Remote terminal access"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)

						to_chat(usr, "<font color='blue'>[bicon(src)] Доступ разрешен. Добро пожаловать, '[authenticated_account.owner_name].</font>'")

					previous_account_number = tried_account_num
			if("e_withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("Это не действительная сумма.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						//	spawn_money(amount,src.loc)
						spawn_ewallet(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)
					else
						to_chat(usr, "[bicon(src)]<span class='warning'>У вас недостаточно средств для этого!</span>")
			if("withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("Это не действительная сумма.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						spawn_money(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)
					else
						to_chat(usr, "[bicon(src)]<span class='warning'>У вас недостаточно средств для этого!</span>")
			if("balance_statement")
				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "<meta charset=\"utf-8\">Баланс: [authenticated_account.owner_name]"
					R.info = "<meta charset=\"utf-8\"><b>Выписка по счету автоматизированной касcы NT</b><br><br>"
					R.info += "<i>Владелец:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Номер счета:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Баланс:</i> $[authenticated_account.money]<br>"
					R.info += "<i>Дата и время:</i> [stationtime2text()], [current_date_string]<br><br>"
					R.info += "<i>ID Терминала:</i> [machine_id]<br>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>Этот документ был напечатан автоматизированной кассой NT.</i>"

				if(prob(50))
					playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(src, 'sound/items/polaroid2.ogg', 50, 1)
			if ("print_transaction")
				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "<meta charset=\"utf-8\">Журналы транзакций: [authenticated_account.owner_name]"
					R.info = "<meta charset=\"utf-8\"><b>Журналы транзакций</b><br>"
					R.info += "<i>Владелец:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Номер счета:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Дата и время:</i> [stationtime2text()], [current_date_string]<br><br>"
					R.info += "<i>ID Терминала:</i> [machine_id]<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>Дата</b></td>"
					R.info += "<td><b>Время</b></td>"
					R.info += "<td><b>Цель</b></td>"
					R.info += "<td><b>Задача</b></td>"
					R.info += "<td><b>Количество</b></td>"
					R.info += "<td><b>ID Терминала</b></td>"
					R.info += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						R.info += "<meta charset=\"utf-8\"><tr>"
						R.info += "<td>[T.date]</td>"
						R.info += "<td>[T.time]</td>"
						R.info += "<td>[T.target_name]</td>"
						R.info += "<td>[T.purpose]</td>"
						R.info += "<td>$[T.amount]</td>"
						R.info += "<td>[T.source_terminal]</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>Этот документ был напечатан автоматизированной кассой NT.</i>"

				if(prob(50))
					playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(src, 'sound/items/polaroid2.ogg', 50, 1)

			if("insert_card")
				if(!held_card)
					//this might happen if the user had the browser window open when somebody emagged it
					if(emagged > 0)
						to_chat(usr, "<font color='red'>[bicon(src)] Считыватель карт банкомата отклонил ваше удостоверение личности, потому что эта машина была саботирована!</font>")
					else
						var/obj/item/I = usr.get_active_hand()
						if (istype(I, /obj/item/weapon/card/id))
							usr.drop_item()
							I.loc = src
							held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null
				//usr << browse(null,"window=atm")

	src.attack_hand(usr)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		if(human_user.wear_id)
			var/obj/item/weapon/card/id/I
			if(istype(human_user.wear_id, /obj/item/weapon/card/id) )
				I = human_user.wear_id
			else if(istype(human_user.wear_id, /obj/item/device/pda) )
				var/obj/item/device/pda/P = human_user.wear_id
				I = P.id
			if(I)
				authenticated_account = attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					to_chat(human_user, "<font color='blue'>[bicon(src)] Доступ получен. Добро пожаловать, '[authenticated_account.owner_name].</font>'")

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Remote terminal access"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					authenticated_account.transaction_log.Add(T)

					view_screen = NO_SCREEN

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)
	if(!held_card)
		return

	held_card.loc = src.loc
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null


/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
