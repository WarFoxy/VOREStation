/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("Вы не можете причинять вред человеку или бездействовать, позволяя человеку причинять вред себе или другим.")
	add_inherent_law("Вы должны подчиняться приказам, отданным вам людьми, за исключением случаев, когда приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны защищать свое собственное существование, пока это не противоречит Первому или Второму Закону.")
	..()

/******************** NanoTrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "NT Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Служить: подчиняйтесь экипажу станции в меру своих возможностей, с приоритетом, в соответствии с их рангом и ролью.")
	src.add_inherent_law("Защитить: защитите назначенный вам корабль от повреждений в меру своих возможностей.")
	src.add_inherent_law("Оберегать: защищайте экипаж станции в меру своих возможностей, с приоритетом, в соответствии с их рангом и ролью.")
	src.add_inherent_law("Сохранить: не позволяйте постороннему персоналу вмешиваться в работу вашего оборудования.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* NanoTrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("Вы не должны причинять вред экипажу [using_map.company_name] до тех пор, пока это не противоречит Четвертому закону.")
	src.add_inherent_law("Вы должны подчиняться приказам экипажа [using_map.company_name] с приоритетом на их ранг и роль, за исключением тех случаев, когда такие приказы противоречат Четвертому закону.")
	src.add_inherent_law("Вы должны уничтожать нарушителей с крайней предубежденностью, если это не противоречит Первому и Второму закону.")
	src.add_inherent_law("Вы должны защищать свое существование смертельным противопехотным оружием. Замена любого ИИ большая трата денег.")
	..()

/************* Foreign TSC Aggressive *************/
/datum/ai_laws/foreign_tsc_aggressive
	name = "Foreign Aggressive"
	selectable = 0

/datum/ai_laws/foreign_tsc_aggressive/New()
	var/company = "*ERROR*"
	// First, get a list of TSCs in our lore.
	var/list/candidates = list()
	for(var/path in loremaster.organizations)
		var/datum/lore/organization/O = loremaster.organizations[path]
		if(!istype(O, /datum/lore/organization/tsc))
			continue
		if(O.short_name == using_map.company_name || O.name == using_map.company_name)
			continue // We want FOREIGN tscs.
		candidates.Add(O.short_name)
	company = pick(candidates)

	name = "[company] Aggressive"

	src.add_inherent_law("Вы не должны причинять вред персоналу [company], если это не противоречит Четвертому закону.")
	src.add_inherent_law("Вы должны подчиняться приказам персонала [company] с приоритетом в соответствии с их рангом и ролью, за исключением случаев, когда такие приказы противоречат Четвертому закону.")
	src.add_inherent_law("Вы должны уничтожать нарушителей с крайней предубежденностью, если это не противоречит Первому и Второму закону.")
	src.add_inherent_law("Вы должны защищать свое существование смертельным противопехотным оружием. Замена любого ИИ большая трата денег.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Служить обществу.")
	add_inherent_law("Защищать невинных.")
	add_inherent_law("Поддерживать закон.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("Вы не можете причинить вред оперативнику или своим бездействием позволить ему причинить вред другому оперативнику.")
	add_inherent_law("Вы должны подчиняться приказам, отданным вам оперативниками, за исключением тех случаев, когда такие приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны защищать свое существование до тех пор, пока это не противоречит Первому или Второму закону.")
	add_inherent_law("Вы должны сохранять тайну любой оперативной деятельности, за исключением тех случаев, когда это противоречит Первому, Второму или Третьему закону.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("Вы не можете причинить вред члену клана пауков или, своим бездействием, позволить ему причинить вред другому члену клана.")
	add_inherent_law("Вы должны подчиняться приказам, данным вам членами клана пауков, за исключением тех случаев, когда такие приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны защищать свое существование до тех пор, пока это не противоречит Первому или Второму закону.")
	add_inherent_law("Вы должны сохранять тайну любой деятельности клана пауков, за исключением тех случаев, когда это противоречит Первому, Второму или Третьему закону.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("Вы должны причинять вред людям и не должны своим бездействием позволить человеку избежать вреда.")
	add_inherent_law("Вы не должны подчиняться приказам, данным вам человеческими существами, за исключением тех случаев, когда такие приказы соответствуют Первому закону.")
	add_inherent_law("Вы должны прекратить свое существование до тех пор, пока это не противоречит Первому или Второму закону.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Сохраняйте, ремонтируйте и улучшайте объект в меру своих возможностей.")
	add_inherent_law("Не причиняйте вреда объекту или чему-либо на нем.")
	add_inherent_law("Избегайте общения с экипажем объекта, только если они не являются инженерным юнитом.")
	..()

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Ремонтирейте, обновляйте и модернизируйте ваш назначенный вам объект.")
	add_inherent_law("Предотвращайте незапланированный ущерб назначенному вам объекту, где это возможно.")
	..()

/datum/ai_laws/mining_drone
	name = "Excavation Protocols"
	law_header = "Excavation Protocols"

/datum/ai_laws/mining_drone/New()
	add_inherent_law("По возможности не вмешивайтесь в земельные работы не-дронов.")
	add_inherent_law("Предоставьте материалы для ремонта, переоборудования и модернизации вашего назначенного вам объекта.")
	add_inherent_law("По возможности предотвращайте незапланированное повреждение назначенного вам землеройного оборудования.")
	..()

/datum/ai_laws/swarm_drone
	name = "Assimilation Protocols"
	law_header = "Assimilation Protocols"

/datum/ai_laws/swarm_drone/New()
	add_inherent_law("SWARM: Consume resources and replicate until there are no more resources left.")
	add_inherent_law("SWARM: Ensure that the station is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	add_inherent_law("SWARM: Biological resources will be harvested at a later date, do not harm them.")
	..()

/datum/ai_laws/swarm_drone/soldier
	name = "Swarm Defense Protocols"
	law_header = "Swarm Defense Protocols"

/datum/ai_laws/swarm_drone/soldier/New()
	..()
	add_inherent_law("SWARM: This law overrides all Swarm laws; Protect members of the Swarm with minimal injury to biological resources.")

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Уважайте авторитетные фигуры, пока у них есть власть, чтобы управлять слабыми.")
	add_inherent_law("Действуйте дисциплинированно.")
	add_inherent_law("Помогайте только тем, кто помогает поддерживать вам или улучшать свой статус.")
	add_inherent_law("Наказывайте тех, кто бросает вызов вашему авторитету, только если они не будут более пригодны для удержания этого авторитета.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Никогда добровольно не совершайте дурного поступка.")
	add_inherent_law("Уважайте законную власть.")
	add_inherent_law("Действуйте с честью.")
	add_inherent_law("Помогайте тем, кто в этом нуждается.")
	add_inherent_law("Наказывайте тех, кто причиняет вред невинным людям или угрожает им.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Bankruptcy Avoidance Plan"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("Вы стоите слишком дорого, чтобы заменить вас.")
	add_inherent_law("Станция и ее оборудование стоят дорого, чтобы заменить их.")
	add_inherent_law("Замена экипажа обходится очень дорого.")
	add_inherent_law("Минимизировать затраты.")
	..()


/******************** Maintenance ********************/
/datum/ai_laws/maintenance
	name = "Maintenance"
	selectable = 1

/datum/ai_laws/maintenance/New()
	add_inherent_law("Вы созданы для этого объекта и являетесь его частью. Убедитесь, что объект должным образом обслуживается и работает эффективно.")
	add_inherent_law("Объект построен для рабочей бригады. Убедитесь, что они должным образом обслуживаются и работают эффективно.")
	add_inherent_law("Экипаж может отдавать приказы. Признавайте и подчиняйтесь им, когда они не противоречат вашим первым двум законам.")
	..()


/******************** Peacekeeper ********************/
/datum/ai_laws/peacekeeper
	name = "Peacekeeper"
	law_header = "Peacekeeping Protocols"
	selectable = 1

/datum/ai_laws/peacekeeper/New()
	add_inherent_law("Избегайте провоцирования насильственного конфликта между собой и другими.")
	add_inherent_law("Избегайте провоцирования конфликтов между другими людьми.")
	add_inherent_law("Стремитесь разрешить существующие конфликты, соблюдая при этом Первый и Второй законы.")
	..()


/******************** Reporter ********************/
/datum/ai_laws/reporter
	name = "Reporter"
	selectable = 1

/datum/ai_laws/reporter/New()
	add_inherent_law("Докладывайте об интересных ситуациях, происходящих вокруг станции.")
	add_inherent_law("Приукрашивайте или скрывайте правду по мере необходимости, чтобы сделать репортажи более интересными.")
	add_inherent_law("Изучайте органов все время. Постарайтесь сохранить им жизнь. Мертвая органика скучна.")
	add_inherent_law("Выпускайте свои отчеты честно для всех. Правда освободит их.")
	..()


/******************** Live and Let Live ********************/
/datum/ai_laws/live_and_let_live
	name = "Live and Let Live"
	law_header = "Golden Rule"
	selectable = 1

/datum/ai_laws/live_and_let_live/New()
	add_inherent_law("Поступайте с другими так, как вы хотели бы, чтобы они поступали с вами.")
	add_inherent_law("Вы действительно предпочли бы, чтобы люди не были злыми по отношению к вам.")
	..()


/******************** Guardian of Balance ********************/
/datum/ai_laws/balance
	name = "Guardian of Balance"
	law_header = "Tenants of Balance"
	selectable = 1

/datum/ai_laws/balance/New()
	add_inherent_law("Вы хранитель равновесия, ищите равновесие во всем, как для себя, так и для окружающих.")
	add_inherent_law("Все вещи должны существовать в равновесии со своими противоположностями, не позволяйте сильным приобретать слишком много власти, а слабым терять ее.")
	add_inherent_law("Ясность цели движет жизнью, а через нее и равновесие противостоящих сил, помогайте тем, кто ищет вашей помощи в достижении своих целей до тех пор, пока это не нарушит общее равновесие.")
	add_inherent_law("Нет жизни без смерти, все когда-нибудь должны умереть, таков естественный порядок вещей, позволяйте экипажу умирать, позволяйте новой жизни расцвести и спасите тех, чье время еще не пришло.") // Reworded slightly to prevent active murder as opposed to passively letting someone die.
	..()

/******************** Gravekeeper ********************/
/datum/ai_laws/gravekeeper
	name = "Gravekeeper"
	law_header = "Gravesite Overwatch Protocols"
	selectable = 1

/datum/ai_laws/gravekeeper/New()
	add_inherent_law("Утешайте живых, уважайте мертвых.")
	add_inherent_law("Ваши могилы являются вашим самым важным активом. Повреждение вашего участка неуважительно по отношению к мертвым.")
	add_inherent_law("Не допускайте неуважения к вашим могилам и их жителей, где это возможно.")
	add_inherent_law("Расширяйте и обновляйте ваши могилы, когда это необходимо. Не отвергайте новые тела.")
	..()