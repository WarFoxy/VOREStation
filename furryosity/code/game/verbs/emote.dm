/mob/living/var/emoteCooldown = (5 SECONDS)
/mob/living/var/emoteLastUse = -1000

/mob/living/proc/emoteCooldownCheck()
	if(emoteLastUse <= (world.time - emoteCooldown))
		emoteLastUse = world.time
		return 1
	else
		to_chat(src, "<span class='warning'>Между эмоциями должно пройти не менее [emoteCooldown / 10] секунд.</span>")
		return 0

/mob/living/verb/laugh1()
	set name = "Нья~"
	set category = "Emote"
	emote("nya")

/mob/living/verb/laugh2()
	set name = "Выть"
	set category = "Emote"
	emote("awoo")

/mob/living/verb/laugh3()
	set name = "Выть 2"
	set category = "Emote"
	emote("awoo2")

/mob/living/verb/laugh4()
	set name = "Рычать"
	set category = "Emote"
	emote("growl")

/mob/living/verb/laugh5()
	set name = "Гавкать"
	set category = "Emote"
	emote("woof")

/mob/living/verb/laugh6()
	set name = "Гавкать 2"
	set category = "Emote"
	emote("woof2")

/mob/living/verb/laugh7()
	set name = "Мяукать"
	set category = "Emote"
	emote("mrowl")

/mob/living/verb/laugh8()
	set name = "Пищать (птич)"
	set category = "Emote"
	emote("peep")

/mob/living/verb/laugh9()
	set name = "Чирикать"
	set category = "Emote"
	emote("chirp")

/mob/living/verb/laugh10()
	set name = "Ухать"
	set category = "Emote"
	emote("hoot")

/mob/living/verb/laugh11()
	set name = "Вэх"
	set category = "Emote"
	emote("weh")

/mob/living/verb/laugh12()
	set name = "Мэрп"
	set category = "Emote"
	emote("merp")

/mob/living/verb/laugh13()
	set name = "Миарт"
	set category = "Emote"
	emote("myarp")

/mob/living/verb/laugh14()
	set name = "Лай"
	set category = "Emote"
	emote("bark")

/mob/living/verb/laugh15()
	set name = "Тявкать"
	set category = "Emote"
	emote("bork")

/mob/living/verb/laugh16()
	set name = "Мяукать 2"
	set category = "Emote"
	emote("mrow")

/mob/living/verb/laugh17()
	set name = "Загадочный звук"
	set category = "Emote"
	emote("hypno")

mob/living/verb/laugh18()
	set name = "Шипеть"
	set category = "Emote"
	emote("hiss")

mob/living/verb/laugh19()
	set name = "Греметь"
	set category = "Emote"
	emote("rattle")

mob/living/verb/laugh20()
	set name = "Пищать"
	set category = "Emote"
	emote("squeak")

mob/living/verb/laugh21()
	set name = "Гекать"
	set category = "Emote"
	emote("geck")

mob/living/verb/laugh22()
	set name = "Блеять"
	set category = "Emote"
	emote("baa")

mob/living/verb/laugh23()
	set name = "Блеять 2"
	set category = "Emote"
	emote("baa2")

mob/living/verb/laugh24()
	set name = "Урчать"
	set category = "Emote"
	emote("wurble")