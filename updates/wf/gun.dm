/obj/item/weapon/gun/energy/dusk
	name = "laser gun from Dusk 3"
	icon = 'updates/wf/icons/obj/dusk.dmi'
	icon_state = "dusk"
	item_state = "dusk"
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Dusk for a small fortune. It's certainly aged well."
	force = 10
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	fire_delay = 6
	charge_cost = 100	//to compensate a bit for self-recharging
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/captain
	battery_lock = 1

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 100),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam),
		list(mode_name="DESTROY", burst=1, projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 200),
		list(mode_name="DESTROY burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/pulse),
		)