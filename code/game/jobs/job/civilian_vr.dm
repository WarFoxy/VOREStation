/datum/job/bartender
	pto_type = PTO_CIVILIAN

/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO
	pto_type = PTO_CIVILIAN

/datum/job/hydro
	spawn_positions = 2
	pto_type = PTO_CIVILIAN

/datum/job/qm
	pto_type = PTO_CARGO
	dept_time_required = 20

/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO

/datum/job/mining
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO

/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Дворник" = /datum/alt_title/custodian, "Сантехник" = /datum/alt_title/sanitation_tech, "Горничная" = /datum/alt_title/maid)
	pto_type = PTO_CIVILIAN

/datum/alt_title/sanitation_tech
	title = "Сантехник"

/datum/alt_title/maid
	title = "Горничная"

/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Журналист" = /datum/alt_title/journalist, "Писатель" = /datum/alt_title/writer, "Историк" = /datum/alt_title/historian)
	pto_type = PTO_CIVILIAN

/datum/alt_title/historian
	title = "Историк"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/job/lawyer
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN

/datum/job/chaplain
	pto_type = PTO_CIVILIAN

