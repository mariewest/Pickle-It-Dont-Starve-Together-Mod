require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'onion_pickled',
	formatted_name = "Pickled Onion",
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = -TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_PRESERVED,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/onion_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/onion_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'onion',
	art_build = 'onion',
	art_anim = 'pickled',
	
	source = 'onion',
}

STRINGS.NAMES.ONION_PICKLED = "Pickled Onion"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION_PICKLED = {	
	"What's round, white, and giggles?\nA tickled onion!",
	"Beautiful and zesty... yum!",
}

return pickleit_CreatePickledPrefab(pickled_data)