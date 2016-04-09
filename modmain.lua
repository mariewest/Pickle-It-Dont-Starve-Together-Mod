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

-- Changing this to modimport() doesn't work as-is... I'm invading the global STRINGS space in strings, and adding c_ helper functions in helpers...
-- So for now these are staying part of the global space, and not being sandboxed into the mod space.
-- When I have more time I'll look into changing it because STRINGS could have conflicts as-is
local require = GLOBAL.require
require "pickleit_strings"
require "pickleit_helpers"

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


--- CRAFTING RECIPES

-- Moved here since it's deprecated to call Recipe from prefabs... So now the code gets messier.
local crafting_recipe_pickle_barrel = AddRecipe("pickle_barrel", {Ingredient("boards", 3), Ingredient("rope", 2)}, GLOBAL.RECIPETABS.FARM,  GLOBAL.TECH.SCIENCE_ONE, "pickle_barrel_placer", 2)
crafting_recipe_pickle_barrel.atlas = "images/inventoryimages/pickle_barrel.xml"

local cucumber_pickled = Ingredient( "cucumber_pickled", 1)
cucumber_pickled.atlas = "images/inventoryimages/cucumber_pickled.xml"

local crafting_recipe_pickle_sword = Recipe( "pickle_sword", { cucumber_pickled , Ingredient("twigs", 2), Ingredient("rope", 1)} , GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE)
crafting_recipe_pickle_sword.atlas = "images/inventoryimages/pickle_sword.xml"


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
local function ModDryingRack(inst)

	local oldonstartdrying = inst.components.dryer.onstartdrying
	local onstartdrying = function(inst, dryable, ...)
		if dryable == "pigs_foot" then
		    inst.AnimState:PlayAnimation("drying_pre")
			inst.AnimState:PushAnimation("drying_loop", true)
			inst.AnimState:OverrideSymbol("swap_dried", "pigs_foot", "pigs_foot_hanging")
			return
		end

		return oldonstartdrying(inst, dryable, ...)
	end

	local oldsetdone = inst.components.dryer.ondonedrying
	local setdone = function(inst, product, ...)
	    if product == "pigs_foot_dried" then
		    inst.AnimState:PlayAnimation("idle_full")
		    inst.AnimState:OverrideSymbol("swap_dried", "pigs_foot", "pigs_foot_dried_hanging")
		    return
	    end

	    return oldsetdone(inst, product, ...)
	end

    inst.components.dryer:SetStartDryingFn(onstartdrying)
	inst.components.dryer:SetDoneDryingFn(setdone)

	-- Klei apparently removed these functions :|
	--inst.components.dryer:SetContinueDryingFn(onstartdrying)
    --inst.components.dryer:SetContinueDoneFn(setdone)
end

AddPrefabPostInit("meatrack", ModDryingRack)

-- Override for potatoes on farm giving multiples
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
