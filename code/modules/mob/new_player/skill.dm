var/global/const
	SKILL_NONE = 0
	SKILL_BASIC = 1
	SKILL_ADEPT = 2
	SKILL_EXPERT = 3
	SKILL_PROF = 4

/datum/skill/var
	ID = "none" // ID of the skill, used in code
	name = "None" // name of the skill
	desc = "Placeholder skill" // detailed description of the skill
	field = "Misc" // the field under which the skill will be listed
	secondary = 0 // secondary skills only have two levels and cost significantly less

var/global/list/SKILLS = null
var/list/SKILL_ENGINEER = list("field" = "Engineering", "EVA" = SKILL_BASIC, "construction" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "engines" = SKILL_ADEPT)
var/list/SKILL_ORGAN_ROBOTICIST = list("field" = "Science", "devices" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "computer" = SKILL_ADEPT, "anatomy" = SKILL_BASIC)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", "combat" = SKILL_BASIC, "weapons" = SKILL_ADEPT, "law" = SKILL_ADEPT, "forensics" = SKILL_BASIC)
var/list/SKILL_CHEMIST = list("field" = "Science", "chemistry" = SKILL_ADEPT, "science" = SKILL_ADEPT, "medical" = SKILL_BASIC, "devices" = SKILL_BASIC)
var/global/list/SKILL_PRE = list("Engineer" = SKILL_ENGINEER, "Roboticist" = SKILL_ORGAN_ROBOTICIST, "Security Officer" = SKILL_SECURITY_OFFICER, "Химик" = SKILL_CHEMIST)

/datum/skill/management
	ID = "management"
	name = "Командование"
	desc = "Ваша способность управлять и управлять другими членами экипажа."

/datum/skill/combat
	ID = "combat"
	name = "Ближ. бой"
	desc = "Этот навык описывает вашу подготовку в рукопашном бою или использовании оружия ближнего боя. Хотя опыт в этой области редок в эпоху огнестрельного оружия, эксперты по-прежнему существуют среди спортсменов."
	field = "Security"

/datum/skill/weapons
	ID = "weapons"
	name = "Даль. бой"
	desc = "Этот навык описывает ваш опыт и знания оружия. Низкий уровень этого навыка подразумевает знание простого оружия, например, тазеров и флешек. Высокий уровень в этом навыке подразумевает знание сложного оружия, такого как гранаты, щиты, боеприпасы или бомбы. Низкий уровень этого навыка типичен для офицеров безопасности, высокий уровень этого навыка типичен для специальных агентов и солдат."
	field = "Security"

/datum/skill/EVA
	ID = "EVA"
	name = "Extra-vehicular activity"
	desc = "Этот навык описывает ваши навыки и знания скафандров и работы в вакууме."
	field = "Engineering"
	secondary = 1

/datum/skill/forensics
	ID = "forensics"
	name = "Криминалистика"
	desc = "Описывает ваши навыки в проведении судебных экспертиз и выявлении жизненно важных доказательств. Не распространяется на аналитические способности, и, как таковой, не является единственным показателем ваших навыков исследования. Обратите внимание, что для выполнения вскрытия также требуется навык хирургии."
	field = "Security"

/datum/skill/construction
	ID = "construction"
	name = "Строительство"
	desc = "Ваша способность строить различные здания, такие как стены, полы, столы и так далее. Обратите внимание, что для создания таких устройств, как APC, требуется навык электроники. Низкий уровень этого навыка характерен для уборщиков, высокий уровень этого навыка характерен для инженеров."
	field = "Engineering"

/datum/skill/management
	ID = "management"
	name = "Командование"
	desc = "Your ability to manage and commandeer other crew members."

/datum/skill/knowledge/law
	ID = "law"
	name = "Корпоративный закон"
	desc = "Your knowledge of corporate law and procedures. This includes Corporate Regulations, as well as general station rulings and procedures. A low level in this skill is typical for security officers, a high level in this skill is typical for Colony Directors."
	field = "Security"
	secondary = 1

/datum/skill/devices
	ID = "devices"
	name = "Сложные устройства"
	desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies(bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."
	field = "Science"

/datum/skill/electrical
	ID = "electrical"
	name = "Электротехника"
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
	field = "Engineering"

/datum/skill/atmos
	ID = "atmos"
	name = "Атмосфера"
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."
	field = "Engineering"

/datum/skill/engines
	ID = "engines"
	name = "Двигатели"
	desc = "Describes your knowledge of the various engine types common on space stations, such as the singularity or anti-matter engine."
	field = "Engineering"
	secondary = 1

/datum/skill/computer
	ID = "computer"
	name = "Компьютеры"
	desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."
	field = "Science"

/datum/skill/pilot
	ID = "pilot"
	name = "Польз. тяж. техникой"
	desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."
	field = "Engineering"

/datum/skill/medical
	ID = "medical"
	name = "Медицина"
	desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyzer. At a high level, this skill grants exact knowledge of all the medicine available on the station, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."
	field = "Medical"

/datum/skill/anatomy
	ID = "anatomy"
	name = "Анатомия"
	desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery.This skill may also help in examining alien biology."
	field = "Medical"

/datum/skill/virology
	ID = "virology"
	name = "Вирусология"
	desc = "This skill implies an understanding of microorganisms and their effects on humans."
	field = "Medical"

/datum/skill/genetics
	ID = "genetics"
	name = "Генетика"
	desc = "Implies an understanding of how DNA works and the structure of the human DNA."
	field = "Science"

/datum/skill/chemistry
	ID = "chemistry"
	name = "Химия"
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."
	field = "Science"

/datum/skill/botany
	ID = "botany"
	name = "Ботаника"
	desc = "Describes how good a character is at growing and maintaining plants."

/datum/skill/cooking
	ID = "cooking"
	name = "Готовка"
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."

/datum/skill/science
	ID = "science"
	name = "Наука"
	desc = "Your experience and knowledge with scientific methods and processes."
	field = "Science"

/datum/attribute/var
	ID = "none"
	name = "None"
	desc = "This is a placeholder"


/proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skill)-/datum/skill))
			var/datum/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S


/mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		setup_skills()

	if(!M.skills || M.skills.len == 0)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<meta charset=\"utf-8\"><body>"
	HTML += "<b>Настройте свои навыки в пределах разумного</b><br>"
	HTML += "Текущий уровень навыков: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Неопытный\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Любитель\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Обученный\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Профи\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

/mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Показать мои навыки"

	show_skill_window(src, src)
