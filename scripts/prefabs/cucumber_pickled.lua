require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'cucumber_pickled',
	formatted_name = "Pickle",
	
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
	    Asset("ATLAS", "images/inventoryimages/cucumber_pickled.xml"),	-- Cucumber Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/cucumber_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'cucumber_pickled',
	art_build = 'pickled_food',
	art_anim = 'idle',
	
	source = 'cucumber',
}

STRINGS.NAMES.CUCUMBER_PICKLED = "Pickle"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUCUMBER_PICKLED = {	
	"This is quite a pickle", 
	"Why do gherkins giggle? They're PICKLish!",
	"If only I had a hamburger to put this on",
}

return pickleit_CreatePickledPrefab(pickled_data)