/datum/unarmed_attack/bite/sharp/numbing //Is using this against someone you are truly trying to fight a bad idea? Yes. Yes it is.
	attack_verb = list("bit")
	attack_noun = list("fangs")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/sharp/numbing/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	attack_damage = CLAMP(attack_damage, 1, 5)
	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.name]!</span>")
		return 0 //No venom for you.
	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>Клыки [user] царапают щеку [target]!</span>")
					to_chat(target, "<font color='red'><b>Ваше лицо слегка покалывает!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage) //Have to add this here, otherwise the swtich fails.
				if(3 to 4)
					user.visible_message("<span class='danger'>Клыки [user] вонзаются в шею [target] под странным, неуклюжим углом!</span>")
					to_chat(target, "<font color='red'><b>Ваша шея словно в огне, именно это вы чувствуете прежде чем онеметь!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user] погружает [pick(attack_noun)] <b><i>глубоко</i></b> в шею [target], заставляя вену выпячиваться наружу при накачке в нее какого-то химического вещества!</span>")
					to_chat(target, "<font color='red'><b>У вас такое чувство, что шея вот-вот лопнет! Через несколько мгновений вы просто не можете больше чувствовать свою шею, онемение начинает распространяться по всему телу!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user]'s fangs scrape across [target]'s [affecting.name]!</span>")
					to_chat(target, "<font color='red'><b>Ты чувствуешь покалывание на [affecting.name]!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(3 to 4)
					user.visible_message("<span class='danger'>[user]'s fangs pierce [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
					to_chat(target, "<font color='red'><b>Your [affecting.name] feels like it's on fire before going numb!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user]'s fangs sink deep into [target]'s [affecting.name], one of their veins bulging outwards from the sudden fluid pumped into it!</span>")
					to_chat(target, "<font color='red'><b>Your [affecting.name] feels like it's going to burst! Moments later, you simply can't feel your [affecting.name] any longer, the numbness slowly spreading throughout your body!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)

/datum/unarmed_attack/claws/shadekin
	var/energy_gain = 3

/datum/unarmed_attack/claws/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)

/datum/unarmed_attack/bite/sharp/shadekin
	var/energy_gain = 3

/datum/unarmed_attack/bite/sharp/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)