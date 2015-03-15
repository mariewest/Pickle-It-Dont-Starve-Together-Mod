-- Our list of prefab files that this mod includes
PrefabFiles = {
	"pickleit_veggies",
	"pickled_foods",
	"world_plants",

	"pickle_barrel",
	"mush_pickled",

	"pigs_foot",
	"pigs_foot_cooked",
	
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

-- Override for potatos on farm giving multiples
local Crop = require('components/crop')
local oldCropHarvest = Crop.Harvest
Crop.Harvest = function(self, harvester, ...)
    if self.product_prefab == "potato" then
	    if self.matured then
			local product = GLOBAL.SpawnPrefab(self.product_prefab)
	        if harvester then
	        	local rnd = math.random() * 100
	        	local count = 0
	        	if rnd <= 20 then count = 1 elseif rnd <= 60 then count = 2 else count = 3 end
	        	product.components.stackable:SetStackSize(count)
	            harvester.components.inventory:GiveItem(product)
	        else
	            product.Transform:SetPosition(self.grower.Transform:GetWorldPosition())
	            Launch(product, self.grower, TUNING.LAUNCH_SPEED_SMALL)
	        end 
	        GLOBAL.ProfileStatsAdd("grown_"..product.prefab) 
	        
	        self.matured = false
	        self.growthpercent = 0
	        self.product_prefab = nil
	        self.grower.components.grower:RemoveCrop(self.inst)
	        self.grower = nil
	        
	        return true
	    end
	    return
	end

	return oldCropHarvest(self, harvester, ...)
end