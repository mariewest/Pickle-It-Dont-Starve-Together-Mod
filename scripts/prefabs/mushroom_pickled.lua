require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'mushroom_pickled',
	formatted_name = "Pickled Mushroom",
	
	healing = TUNING.HEALING_SMALL,
	hunger = TUNING.CALORIES_SMALL,
	sanity = -TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_SUPERSLOW,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/mushroom_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/mushroom_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'mushroom_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'red_cap',
}

-- All mushrooms (red, green, and blue) can produce pickled mushrooms
pickleit_AddRecipe("green_cap", pickled_data.name)
pickleit_AddRecipe("blue_cap", pickled_data.name)

STRINGS.NAMES.MUSHROOM_PICKLED = "Pickled Mushroom"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSHROOM_PICKLED = {	
	"Why did the fungi leave the party?\nThere wasn't mushroom.", 
	"Why do people like Mr. Mushroom?\nBecause he's a fungi!",
}

return pickleit_CreatePickledPrefab(pickled_data)