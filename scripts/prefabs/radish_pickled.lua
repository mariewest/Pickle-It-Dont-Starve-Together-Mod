require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'radish_pickled',
	formatted_name = "Pickled Radish",
	
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
	    Asset("ATLAS", "images/inventoryimages/radish_pickled.xml"),	-- Radish Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/radish_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'radish',
	art_build = 'radish',
	art_anim = 'pickled',
	
	source = 'radish',
}

STRINGS.NAMES.RADISH_PICKLED = "Pickled Radish"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH_PICKLED = {	
	"Sweet, tangy, and pink",
	"This would make a great garnish"
}

return pickleit_CreatePickledPrefab(pickled_data)