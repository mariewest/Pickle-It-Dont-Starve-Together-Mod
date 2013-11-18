require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'eggplant_pickled',
	formatted_name = "Pickled Eggplant",
	
	healing = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_MEDSMALL,
	sanity = -TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_PRESERVED,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/eggplant_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/eggplant_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'eggplant_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'eggplant',
}

STRINGS.NAMES.EGGPLANT_PICKLED = "Pickled Eggplant"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EGGPLANT_PICKLED = {	
	"Lasts longer than a regular eggplant",
	"You don't steal a bitter eggplant",
}

return pickleit_CreatePickledPrefab(pickled_data)