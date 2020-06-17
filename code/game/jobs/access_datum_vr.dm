//Moved from southern_cross_jobs.vr to fix a runtime
var/const/access_explorer = 43
/datum/access/explorer
	id = access_explorer
	desc = "Искатель"
	region = ACCESS_REGION_GENERAL

var/const/access_pilot = 67
/datum/access/pilot
	id = access_pilot
	desc = "Пилот"
	region = ACCESS_REGION_SUPPLY

/var/const/access_talon = 301
/datum/access/talon
	id = access_talon
	desc = "Talon"
	access_type = ACCESS_TYPE_PRIVATE
