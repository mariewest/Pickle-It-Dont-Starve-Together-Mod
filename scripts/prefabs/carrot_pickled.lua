require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'carrot_pickled',
	formatted_name = "Pickled Carrot",
	
	healing = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SMALL,
	sanity = 0,
	perishtime = TUNING.PERISH_PRESERVED,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/carrot_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/carrot_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'carrot_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'carrot',
}

STRINGS.NAMES.CARROT_PICKLED = "Pickled Carrot"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CARROT_PICKLED = {	
	"Lasts longer than a normal carrot", 
	"Some prefer carrots, while others like cabbage.",
}

return pickleit_CreatePickledPrefab(pickled_data)