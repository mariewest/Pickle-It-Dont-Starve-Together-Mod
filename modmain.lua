-- Our list of prefab files that this mod includes
PrefabFiles = {
	"beet",
	"beet_cooked",
	"beet_pickled",
	"beet_planted",
	"beet_seeds",
	"cabbage",
	"cabbage_cooked",
	"cabbage_pickled",
	"cabbage_seeds",
	"carrot_pickled",
	"corn_pickled",
	"cucumber",
	"cucumber_cooked",
	"cucumber_pickled",
	"cucumber_seeds",
	"egg_pickled",
	"eggplant_pickled",
	"fish_pickled",
	"mush_pickled",
	"mushroom_pickled",
	"onion",
	"onion_cooked",
	"onion_pickled",
	"onion_planted",
	"onion_seeds",
	"pickle_barrel",
	"pumpkin_pickled",
	"radish",
	"radish_cooked",
	"radish_pickled",
	"radish_planted",
	"radish_seeds",
	"pigs_foot",
	"pigs_foot_cooked",
	"pigs_foot_pickled",
}

local assets=
{
    Asset("ATLAS", "images/inventoryimages/pickle_barrel.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_barrel.tex"),
}

AddMinimapAtlas("images/inventoryimages/pickle_barrel.xml")

-- Add a loot drop to pigmen
local function AddPigLoot(prefab)
	prefab.components.lootdropper:AddChanceLoot('pigs_foot',1)
	prefab.components.lootdropper:AddChanceLoot('pigs_foot',.5)
end

AddPrefabPostInit("pigman", AddPigLoot)
AddPrefabPostInit("pigguard", AddPigLoot)