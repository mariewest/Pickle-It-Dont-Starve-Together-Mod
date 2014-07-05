require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'egg_pickled',
	formatted_name = "Pickled Egg",
	
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
	    Asset("ATLAS", "images/inventoryimages/egg_pickled.xml"),	-- Cucumber Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/egg_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'egg_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'bird_egg',
}

-- Let tallbird eggs get pickled, too
pickleit_AddRecipe("tallbirdegg", pickled_data.name)

STRINGS.NAMES.EGG_PICKLED = "Pickled Egg"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EGG_PICKLED = {	
	"Am I supposed to actually eat this?", 
	"Who decided this should be edible?",
}

return pickleit_CreatePickledPrefab(pickled_data)