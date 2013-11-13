require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'fish_pickled',
	formatted_name = "Pickled Herring",
	
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
	    Asset("ATLAS", "images/inventoryimages/fish_pickled.xml"),	-- Cucumber Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/fish_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'fish_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'fish',
}

STRINGS.NAMES.FISH_PICKLED = "Pickled Herring"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FISH_PICKLED = {	
	"Whoa, this is pungent!", 
	"Catch a pickled herring, put it in your pocket",
	"At least it's not lutefisk",
}

return pickleit_CreatePickledPrefab(pickled_data)