-- Our list of prefab files that this mod includes
PrefabFiles = {
	"pickleit_veggies",
	"pickled_foods",
	"world_plants",

	"pickle_barrel",
	"mush_pickled",

	"pigs_foot",
	"pigs_foot_cooked",
	"pigs_foot_dried",
	"pickle_sword",
}

local assets=
{
    Asset("ATLAS", "images/inventoryimages/pickle_barrel.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_barrel.tex"),
}

local require = GLOBAL.require
require "pickleit_strings"

AddMinimapAtlas("images/inventoryimages/pickle_barrel.xml")


AddReplicableComponent('pickler')

-- Add the pickleit action (Controller support!)
pickleit_dopickle = function(act)
	if act.target.components.pickler ~= nil then
       if act.target.components.container ~= nil and act.target.components.container:IsOpen() and not act.target.components.container:IsOpenedBy(act.doer) then
           return false, "INUSE"
       elseif not act.target.components.pickler:CanPickle() then
           return false
       end

       act.target.components.pickler:SetPicklePerson(act.doer)
       act.target.components.pickler:StartPickling()

       return true
	end

	return false
end 
AddAction('PICKLEIT', GLOBAL.STRINGS.NAMES.PICKLE, pickleit_dopickle)
AddStategraphActionHandler('wilson_client', GLOBAL.ActionHandler(GLOBAL.ACTIONS.PICKLEIT, "dolongaction"))
AddStategraphActionHandler('wilson', GLOBAL.ActionHandler(GLOBAL.ACTIONS.PICKLEIT, "dolongaction"))

local function picklit_pickle_button(inst, doer, actions, right)
	if right then
		table.insert(actions, GLOBAL.ACTIONS.PICKLEIT)
	end
end
AddComponentAction('SCENE', 'pickler', picklit_pickle_button)

if not GLOBAL.TheNet:GetIsServer() then
    return
end

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


-- Meatrack overload for pigs_foot on meatrack
local meatrack = require('prefabs/meatrack')

local function ModDryingRack(inst)

	local oldonstartdrying = inst.onstartdrying
	local onstartdrying = function(inst, dryable, ...)
		if dryable == "pigs_foot" then
		    inst.AnimState:PlayAnimation("drying_pre")
			inst.AnimState:PushAnimation("drying_loop", true)
			inst.AnimState:OverrideSymbol("swap_dried", "pigs_foot", "pigs_foot_hanging")
			return
		end

		return oldonstartdrying(inst, dryable, ...)
	end

	local oldsetdone = inst.setdone
	local setdone = function(inst, product, ...)
	    if product == "pigs_foot_dried" then
		    inst.AnimState:PlayAnimation("idle_full")
		    inst.AnimState:OverrideSymbol("swap_dried", "pigs_foot", "pigs_foot_dried_hanging")
		    return
	    end

	    return oldsetdone(inst, product, ...)
	end

    inst.components.dryer:SetStartDryingFn(onstartdrying)
    inst.components.dryer:SetContinueDryingFn(onstartdrying)
    inst.components.dryer:SetContinueDoneFn(setdone)
end
 
AddPrefabPostInit("meatrack", ModDryingRack)