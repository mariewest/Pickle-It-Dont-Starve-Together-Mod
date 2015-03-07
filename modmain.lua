-- Our list of prefab files that this mod includes
PrefabFiles = {
	"pickleit_veggies",
	"pickled_foods",
	"world_plants",

	"pickle_barrel",
	"mush_pickled",

	"pigs_foot",
	"pigs_foot_cooked",
}

local assets=
{
    Asset("ATLAS", "images/inventoryimages/pickle_barrel.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_barrel.tex"),
}

local require = GLOBAL.require
require "pickleit_strings"

AddMinimapAtlas("images/inventoryimages/pickle_barrel.xml")

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

-- Add the pickleit action (Controller support!)
pickleit_dopickle = function(act)
	if act.target.components.pickler ~= nil then
       if act.target.components.container ~= nil and act.target.components.container:IsOpen() and not act.target.components.container:IsOpenedBy(act.doer) then
           return false, "INUSE"
       elseif not act.target.components.pickler:CanPickle() then
           return false
       end
       act.target.components.pickler:StartPickling()
       return true
	end

	return false
end 
AddAction('PICKLEIT', GLOBAL.STRINGS.NAMES.PICKLE, pickleit_dopickle)
AddStategraphActionHandler('wilson', GLOBAL.ActionHandler(GLOBAL.ACTIONS.PICKLEIT, "dolongaction"))

local function picklit_pickle_button(inst, doer, actions, right)
	if right then
		if not inst.components.pickler:Pickling() then
			table.insert(actions, GLOBAL.ACTIONS.PICKLEIT)
		end	
	end
end
AddComponentAction('SCENE', 'pickler', picklit_pickle_button)
