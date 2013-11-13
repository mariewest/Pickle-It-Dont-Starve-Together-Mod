require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'cabbage_pickled',
	formatted_name = "Sauerkraut",
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_SLOW,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	food_type = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/cabbage_pickled.xml"),	-- Cucumber Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/cabbage_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'cabbage_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'cabbage',
}

STRINGS.NAMES.CABBAGE_PICKLED = "Sauerkraut"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE_PICKLED = {	
	"My grandpa puts sauerkraut in his chocolate cakes", 
	"Try substituting sauerkraut for coconut when baking",
	"Also known as liberty cabbage",
}

return pickleit_CreatePickledPrefab(pickled_data)