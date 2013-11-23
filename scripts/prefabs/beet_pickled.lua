require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'beet_pickled',
	formatted_name = "Pickled Beet",
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = -TUNING.SANITY_SMALL,
	perishtime = TUNING.PERISH_PRESERVED,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/beet_pickled.xml"),	-- Beet Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/beet_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'beet',
	art_build = 'beet',
	art_anim = 'pickled',
	
	source = 'beet',
}

STRINGS.NAMES.BEET_PICKLED = "Pickled Beet"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PICKLED = {	
	"I hear people really like pickled beets.\nMaybe I should give them a try.", 
	"They actually look kinda tasty",
}

return pickleit_CreatePickledPrefab(pickled_data)