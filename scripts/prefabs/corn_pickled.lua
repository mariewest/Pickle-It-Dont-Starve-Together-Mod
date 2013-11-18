require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'corn_pickled',
	formatted_name = "Pickled Corn",
	
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
	    Asset("ATLAS", "images/inventoryimages/corn_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/corn_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'corn_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'corn',
}

STRINGS.NAMES.CORN_PICKLED = "Pickled Corn"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CORN_PICKLED = {	
	"Lasts longer than regular corn",
	"What did the corn say when he got complimented?\nAww, shucks!",
}

return pickleit_CreatePickledPrefab(pickled_data)