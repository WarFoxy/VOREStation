var/global/list/uplink_locations = list("ПДА", "Наушник", "Ничего")

/datum/category_item/player_setup_item/antagonism/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/basic/load_character(var/savefile/S)
	S["uplinklocation"] >> pref.uplinklocation
	S["exploit_record"] >> pref.exploit_record
	S["antag_faction"]	>> pref.antag_faction
	S["antag_vis"]		>> pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/save_character(var/savefile/S)
	S["uplinklocation"] << pref.uplinklocation
	S["exploit_record"] << pref.exploit_record
	S["antag_faction"]	<< pref.antag_faction
	S["antag_vis"]		<< pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))
	if(!pref.antag_faction) pref.antag_faction = "Нет"
	if(!pref.antag_vis) pref.antag_vis = "Скрыта"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/antagonism/basic/copy_to_mob(var/mob/living/carbon/human/character)
	character.exploit_record = pref.exploit_record
	character.antag_faction = pref.antag_faction
	character.antag_vis = pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	. += "Фракция: <a href='?src=\ref[src];antagfaction=1'>[pref.antag_faction]</a><br/>"
	. += "Видимость: <a href='?src=\ref[src];antagvis=1'>[pref.antag_vis]</a><br/>"
	. +="<b>Тип связи : <a href='?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a></b>"
	. +="<br>"
	. +="<b>Полезная информация:</b><br>"
	if(jobban_isbanned(user, "Записи"))
		. += "<b>Вам запрещено использовать записи персонажей.</b><br>"
	else
		. +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_in_list(pref.uplinklocation, uplink_locations)
		return TOPIC_REFRESH

	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Установите полезную информацию о вас здесь.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Записи") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	if(href_list["antagfaction"])
		var/choice = input(user, "Пожалуйста, выберите фракцию антагониста для работы.", "Character Preference", pref.antag_faction) as null|anything in antag_faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Пожалуйста, введите название своей фракции.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.antag_faction = raw_choice
		else
			pref.antag_faction = choice
		return TOPIC_REFRESH

	if(href_list["antagvis"])
		var/choice = input(user, "Пожалуйста, выберите уровень видимости антагониста.", "Character Preference", pref.antag_vis) as null|anything in antag_visiblity_choices
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		else
			pref.antag_vis = choice
		return TOPIC_REFRESH

	return ..()
