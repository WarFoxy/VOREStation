/mob/living/var/emoteCooldown = (5 SECONDS)
/mob/living/var/emoteLastUse = -1000

var/list/sounded_species = null

/mob/living/proc/emoteCooldownCheck()
	if(emoteLastUse <= (world.time - emoteCooldown))
		emoteLastUse = world.time
		return 1
	else
		to_chat(src, "<span class='warning'>����� �������� ������ ������ �� ����� [emoteCooldown / 10] ������.</span>")
		return 0

/mob/living/verb/laugh1()
	set name = "���~"
	set category = "Emote"
	sounded_species = null
	emote("nya")

/mob/living/verb/laugh2()
	set name = "����"
	set category = "Emote"
	emote("awoo")

/mob/living/verb/laugh3()
	set name = "���� 2"
	set category = "Emote"
	emote("awoo2")

/mob/living/verb/laugh4()
	set name = "������"
	set category = "Emote"
	emote("growl")

/mob/living/verb/laugh5()
	set name = "�������"
	set category = "Emote"
	emote("woof")

/mob/living/verb/laugh6()
	set name = "������� 2"
	set category = "Emote"
	emote("woof2")

/mob/living/verb/laugh7()
	set name = "�������"
	set category = "Emote"
	emote("mrowl")

/mob/living/verb/laugh8()
	set name = "������ (����)"
	set category = "Emote"
	emote("peep")

/mob/living/verb/laugh9()
	set name = "��������"
	set category = "Emote"
	emote("chirp")

/mob/living/verb/laugh10()
	set name = "�����"
	set category = "Emote"
	emote("hoot")

/mob/living/verb/laugh11()
	set name = "���"
	set category = "Emote"
	emote("weh")

/mob/living/verb/laugh12()
	set name = "����"
	set category = "Emote"
	emote("merp")

/mob/living/verb/laugh13()
	set name = "�����"
	set category = "Emote"
	emote("myarp")

/mob/living/verb/laugh14()
	set name = "���"
	set category = "Emote"
	emote("bark")

/mob/living/verb/laugh15()
	set name = "�������"
	set category = "Emote"
	emote("bork")

/mob/living/verb/laugh16()
	set name = "������� 2"
	set category = "Emote"
	emote("mrow")

/mob/living/verb/laugh17()
	set name = "���������� ����"
	set category = "Emote"
	emote("hypno")

mob/living/verb/laugh18()
	set name = "������"
	set category = "Emote"
	sounded_species = list(SPECIES_UNATHI)
	emote("hiss")

mob/living/verb/laugh19()
	set name = "�������"
	set category = "Emote"
	emote("rattle")

mob/living/verb/laugh20()
	set name = "������"
	set category = "Emote"
	emote("squeak")

mob/living/verb/laugh21()
	set name = "������"
	set category = "Emote"
	emote("geck")

mob/living/verb/laugh22()
	set name = "������"
	set category = "Emote"
	emote("baa")

mob/living/verb/laugh23()
	set name = "������ 2"
	set category = "Emote"
	emote("baa2")

mob/living/verb/laugh24()
	set name = "������"
	set category = "Emote"
	emote("wurble")