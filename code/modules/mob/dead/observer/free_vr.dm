var/global/list/prevent_respawns = list()

/hook/death/proc/quit_notify(mob/dead)
	if(ishuman(dead))
		to_chat(dead,"<span class='notice'>Вы мертвы! Если вы не намерены продолжать играть в этом раунде в качестве этого персонажа, пожалуйста, используйте кнопку <b>Покинуть Раунд</b> в панели ООС, чтобы освободить слот вашей профессии.</span>")

	return TRUE

/mob/observer/dead/verb/cleanup()
	set name = "Покинуть раунд"
	set category = "OOC"
	set desc = "Free your job slot, remove yourself from the manifest, and prevent respawning as this character for this round."

	var/confirm = alert("Это освободит ваше рабочее место, удалит вас из манифеста и позволит вам возродиться этим персонажем. Вы можете присоединиться другим персонажем, если хотите. \
	Сделать это сейчас?","Покинуть раунд","Выйти","Отмена")
	if(confirm != "Выйти")
		return

	//Why are you clicking this button?
	if(!mind || !mind.assigned_role)
		to_chat(src,"<span class='warning'>Либо вы еще не начали играть в этом раунде, либо уже использовали эту кнопку.</span>")
		return

	//Add them to the nope list
	//prevent_respawns += mind.name //Replaced by PR 4785

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		if(O.target == src.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current,"<span class='warning'>Вы чувствуете, что ваша цель больше не находится в пределах вашей досягаемости ...</span>")
			qdel(O)

	//Resleeving cleanup
	if(src.mind.name in SStranscore.backed_up)
		var/datum/transhuman/mind_record/MR = SStranscore.backed_up[src.mind.name]
		SStranscore.stop_backup(MR)
	if(src.mind.name in SStranscore.body_scans) //This uses mind names to avoid people cryo'ing a printed body to delete body scans.
		var/datum/transhuman/body_record/BR = SStranscore.body_scans[src.mind.name]
		SStranscore.remove_body(BR)

	//Job slot cleanup
	var/job = src.mind.assigned_role
	job_master.FreeRole(job)

	//Their objectives cleanup
	if(src.mind.objectives.len)
		qdel(src.mind.objectives)
		src.mind.special_role = null

	//Cut the PDA manifest (ugh)
	if(PDA_Manifest.len)
		PDA_Manifest.Cut()
	for(var/datum/data/record/R in data_core.medical)
		if((R.fields["name"] == src.real_name))
			qdel(R)
	for(var/datum/data/record/T in data_core.security)
		if((T.fields["name"] == src.real_name))
			qdel(T)
	for(var/datum/data/record/G in data_core.general)
		if((G.fields["name"] == src.real_name))
			qdel(G)

	//This removes them from being 'active' list on join screen
	src.mind.assigned_role = null

	//Feedback
	to_chat(src,"<span class='notice'>Ваша работа была освобождена, и вы можете вернуться в качестве другого персонажа или уйти. Спасибо за использование этой кнопки, она помогает серверу!</span>")
