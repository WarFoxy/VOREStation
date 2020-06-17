/*
VOX HEIST ROUNDTYPE
*/

var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/heist
	name = "Heist"
	config_tag = "heist"
	required_players = 12
	required_players_secret = 12
	required_enemies = 3
	round_description = "Неопознанная сигнатура из блюспейса приближается к станции!"
	extended_round_description = "Контроль компании над большим количеством форона в системе обозначил станцию как очень важную цель для многих конкурирующих организаций и частных лиц. Будучи колонией со значительным населением и значительным богатством, она часто становится мишенью различных попыток грабежа, мошенничества и других злонамеренных действий."
	end_on_antag_death = 0
	antag_tags = list(MODE_RAIDER)