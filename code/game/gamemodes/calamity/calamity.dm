#define ANTAG_TYPE_RATIO 8

/datum/game_mode/calamity
	name = "Calamity"
	round_description = "Это должен быть четверг. Вы никогда не могли привыкнуть к четвергам..."
	extended_round_description = "Весь ад вот-вот вырвется на свободу. Буквально любой антагонист может появиться в этом раунде. Крепитесь."
	config_tag = "calamity"
	required_players = 1
	votable = 0
	event_delay_mod_moderate = 0.5
	event_delay_mod_major = 0.75

/datum/game_mode/calamity/create_antagonists()

	shuffle(all_antag_types) // This is probably the only instance in the game where the order will be important.
	var/i = 1
	var/grab_antags = round(num_players()/ANTAG_TYPE_RATIO)+1
	for(var/antag_id in all_antag_types)
		if(i > grab_antags)
			break
		antag_tags |= antag_id
		i++
	..()

/datum/game_mode/calamity/check_victory()
	to_world("<font size = 3><b>Этот ужасный, ужасный день наконец закончился!</b></font>")

#undef ANTAG_TYPE_RATIO