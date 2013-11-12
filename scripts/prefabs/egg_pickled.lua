require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'egg_pickled',
	formatted_name = "Pickled Egg",
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_SLOW,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	food_type = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	description = {
		"Am I supposed to actually eat this?", 
		"Who decided this should be edible?",
	},
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/egg_pickled.xml"),	-- Cucumber Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/egg_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'egg_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'bird_egg',
}

return pickleit_CreatePickledPrefab(pickled_data)