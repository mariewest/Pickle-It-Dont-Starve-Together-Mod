require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'pumpkin_pickled',
	formatted_name = "Pickled Pumpkin",
	
	healing = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_MED,
	sanity = -TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_SUPERSLOW,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/pumpkin_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/pumpkin_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'pumpkin_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'pumpkin',
}

STRINGS.NAMES.PUMPKIN_PICKLED = "Pickled Pumpkin"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PUMPKIN_PICKLED = {	
	"Peter Piper pickled a peck of pickled pumpkins... err, peppers",
	"What's a pumpkin's favorite sport?\nSquash!",
}

return pickleit_CreatePickledPrefab(pickled_data)