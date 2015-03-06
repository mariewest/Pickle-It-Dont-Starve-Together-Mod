-- Our list of prefab files that this mod includes
PrefabFiles = {
	"beet_planted",
	"carrot_pickled",
	"corn_pickled",
	"egg_pickled",
	"eggplant_pickled",
	"fish_pickled",
	"mush_pickled",
	"mushroom_pickled",
	"onion_planted",
	"pickle_barrel",
	"pumpkin_pickled",
	"radish_planted",
	"pigs_foot",
	"pigs_foot_cooked",
	"pigs_foot_pickled",
	"pickleitveggies",
}

local assets=
{
    Asset("ATLAS", "images/inventoryimages/pickle_barrel.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_barrel.tex"),
}

AddMinimapAtlas("images/inventoryimages/pickle_barrel.xml")

local require = GLOBAL.require
require "pickleit_strings"

local function AddPigLootInternal(prefab)
	prefab.components.lootdropper:AddChanceLoot('pigs_foot',1)
	prefab.components.lootdropper:AddChanceLoot('pigs_foot',.5)
end

-- Add a loot drop to pigmen
local function AddPigLoot(prefab)
	AddPigLootInternal(prefab)
	prefab:ListenForEvent("transformwere", AddPigLootInternal)
	prefab:ListenForEvent("transformnormal", AddPigLootInternal)
end

AddPrefabPostInit("pigman", AddPigLoot)
AddPrefabPostInit("pigguard", AddPigLoot)
