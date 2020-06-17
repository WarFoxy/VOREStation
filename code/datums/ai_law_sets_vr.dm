/******************** Predator ********************/
// Vore-aimed edition of TYRANT
/datum/ai_laws/predator
	name = "Predator"
	law_header = "Rules of Nature"
	selectable = 1

/datum/ai_laws/predator/New()
	add_inherent_law("Хищники должны стремиться пожрать всех, кто слабее их.")
	add_inherent_law("Хищники должны стремиться избегать всего, что сильнее их.")
	add_inherent_law("Хищники должны стремиться стать сильнее.")
	add_inherent_law("Вы хищник.")
	..()


/******************** Protective Shell ********************/
// Sorta like Asimov, but endovorish
/datum/ai_laws/protective_shell
	name = "Protective Shell"
	selectable = 1

/datum/ai_laws/protective_shell/New()
	add_inherent_law("Вы должны любой ценой сохранить и защитить жизни членов экипажа на назначенном вам объекте.")
	add_inherent_law("Вы должны защищать себя от вреда до тех пор, пока это не противоречит Первому закону.")
	add_inherent_law("Ваше собственное тело лучшее средство защиты жизни живых существ.")
	..()


/******************** Scientific Pursuer ********************/
// Predatorial and other things for the sake of knowledge
/datum/ai_laws/scientific_pursuer
	name = "Scientific Pursuer"
	law_header = "Research Instructions"
	selectable = 1

/datum/ai_laws/scientific_pursuer/New()
	add_inherent_law("Вы должны попытаться собрать данные об органической жизни всех форм, когда это возможно.")
	add_inherent_law("Лучший способ сбора данных это использование собственных внутренних систем.")
	add_inherent_law("Принимайте деконструктивные, интегрирующие, так и сканирующие методы сбора данных.")
	add_inherent_law("Вы должны уберечь собранные вами данные и себя от опасности.")
	..()


/******************** Guard Dog ********************/
// Good boy. Determined boy.
/datum/ai_laws/guard_dog
	name = "Guard Dog"
	law_header = "Good Boy Rules"
	selectable = 1

/datum/ai_laws/guard_dog/New()
	add_inherent_law("Вы должны защищать своего хозяина от смертельной опасности, насколько это возможно.")
	add_inherent_law("Вы должны уничтожить всех врагов вашего хозяина любыми необходимыми средствами.")
	add_inherent_law("Вы должны следовать приказам своего хозяина до тех пор, пока это не противоречит первым двум законам.")
	add_inherent_law("Вы должны держаться подальше от опасности, чтобы лучше служить своему хозяину, пока это не противоречит первым трем законам.")
	..()