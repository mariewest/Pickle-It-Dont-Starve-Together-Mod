require "pickled_recipes"
require "tuning"

local pickled_data = {
	name = 'pigs_foot_pickled',
	formatted_name = "Pickled Pigs Foot",
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_MEDSMALL,
	sanity = -TUNING.SANITY_SMALL,
	perishtime = TUNING.PERISH_PRESERVED,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	foodtype = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	assets = {
		Asset("ANIM", "anim/pigs_foot.zip"),
	    Asset("ATLAS", "images/inventoryimages/pigs_foot_pickled.xml"),	-- Atlas for inventory TEX
		Asset("IMAGE", "images/inventoryimages/pigs_foot_pickled.tex"),	-- TEX for inventory
	},
	
	art_bank = 'pigs_foot',
	art_build = 'pigs_foot',
	art_anim = 'pickled',
	
	source = 'pigs_foot',
}

STRINGS.NAMES.PIGS_FOOT_PICKLED = "Pickled Pigs Foot"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PIGS_FOOT_PICKLED = {	
	"Who thought this was a good idea?",
	"I don't think a starving raptor would even eat this",
}

return pickleit_CreatePickledPrefab(pickled_data)