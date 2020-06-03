/datum/preferences
	var/media_volume = 1
	var/media_player = 2	// 0 = VLC, 1 = WMP, 2 = HTML5, 3+ = unassigned

/datum/category_item/player_setup_item/player_global/media
	name = "Media"
	sort_order = 5

/datum/category_item/player_setup_item/player_global/media/load_preferences(var/savefile/S)
	S["media_volume"]	>> pref.media_volume
	S["media_player"]	>> pref.media_player

/datum/category_item/player_setup_item/player_global/media/save_preferences(var/savefile/S)
	S["media_volume"]	<< pref.media_volume
	S["media_player"]	<< pref.media_player

/datum/category_item/player_setup_item/player_global/media/sanitize_preferences()
	pref.media_volume = isnum(pref.media_volume) ? CLAMP(pref.media_volume, 0, 1) : initial(pref.media_volume)
	pref.media_player = sanitize_inlist(pref.media_player, list(0, 1, 2), initial(pref.media_player))

/datum/category_item/player_setup_item/player_global/media/content(var/mob/user)
	. += "<b>Громкость музыки в автомате:</b>"
	. += "<a href='?src=\ref[src];change_media_volume=1'><b>[round(pref.media_volume * 100)]%</b></a><br>"
	. += "<b>Тип плеера:</b> В зависимости от вашей операционной системы, один из них может работать лучше. "
	. += "Используйте HTML5, если он работает у вас. Если ни HTML5, ни WMP не работают, вам придется вернуться к использованию VLC, "
	. += "но для этого необходимо, чтобы на вашем компьютере был установлен сам VLC."
	. += "Попробуйте другие проигрыватели, если хотите, но вы, вероятно, перестанете слышать музыку.<br>"
	. += (pref.media_player == 2) ? "<span class='linkOn'><b>HTML5</b></span> " : "<a href='?src=\ref[src];set_media_player=2'>HTML5</a> "
	. += (pref.media_player == 1) ? "<span class='linkOn'><b>WMP</b></span> " : "<a href='?src=\ref[src];set_media_player=1'>WMP</a> "
	. += (pref.media_player == 0) ? "<span class='linkOn'><b>VLC</b></span> " : "<a href='?src=\ref[src];set_media_player=0'>VLC</a> "
	. += "<br>"

/datum/category_item/player_setup_item/player_global/media/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["change_media_volume"])
		if(CanUseTopic(user))
			var/value = input("Выберите громность музыкального автомата (0-100%)", "Громкость", round(pref.media_volume * 100))
			if(isnum(value))
				value = CLAMP(value, 0, 100)
				pref.media_volume = value/100.0
				if(user.client && user.client.media)
					user.client.media.update_volume(pref.media_volume)
			return TOPIC_REFRESH
	else if(href_list["set_media_player"])
		if(CanUseTopic(user))
			var/newval = sanitize_inlist(text2num(href_list["set_media_player"]), list(0, 1, 2), pref.media_player)
			if(newval != pref.media_player)
				pref.media_player = newval
				if(user.client && user.client.media)
					user.client.media.open()
					spawn(10)
						user.update_music()
			return TOPIC_REFRESH
	return ..()
