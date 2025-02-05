/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	w_class = ITEM_SIZE_TINY
	thrown_force_divisor = 1
	origin_tech = "materials=1"
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 1
	edge = 1
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/loaded      //Descriptive string for currently loaded food object.
	var/scoop_food = 1
	structure_damage_factor = STRUCTURE_DAMAGE_WEAK

/obj/item/material/kitchen/utensil/New()
	..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.targeted_organ in list(BP_HEAD, BP_EYES))
			if((CLUMSY in user.mutations) && prob(15))
				M = user
			return eyestab(M,user)
		else
			return ..()

	if (reagents.total_volume > 0)
		if(M == user)
			if(!M.can_eat(loaded))
				return
			M.visible_message(SPAN_NOTICE("\The [user] eats some [loaded] from \the [src]."))
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		else
			user.visible_message(SPAN_WARNING("\The [user] begins to feed \the [M]!"))
			if(!(M.can_force_feed(user, loaded) && do_mob(user, M, 5 SECONDS)))
				return
			M.visible_message(SPAN_NOTICE("\The [user] feeds some [loaded] to \the [M] with \the [src]."))
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), 1)
		cut_overlays()
		return
	else
		to_chat(user, SPAN_WARNING("You don't have anything on \the [src]."))	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"

/obj/item/material/kitchen/utensil/fork/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	edge = 0
	sharp = 0
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/spoon/mre
	desc = "A wooden spoon, almost chalky."
	icon_state = "mre_spoon"
	applies_material_colour = FALSE
	default_material = MATERIAL_WOOD

/*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = "wood"
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_force_divisor = 1 // as above

/obj/item/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(15))
		to_chat(user, SPAN_WARNING("\The [src] accidentally slips out of your hand."))
		user.drop_from_inventory(src)
		user.take_organ_damage(2)
		user.Paralyse(2)
		return
	return ..()
