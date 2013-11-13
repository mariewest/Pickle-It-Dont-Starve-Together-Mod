-- Our cabbage asset files
local assets=
{
    Asset("ANIM", "anim/cucumber.zip"),						-- Cucumber animation
    Asset("ATLAS", "images/inventoryimages/cucumber.xml"),	-- Cucumber Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/cucumber.tex"),	-- TEX for inventory
}

-- This is copied from prefabs/veggies.lua so we can neatly inject our veggie into the global VEGGIES table
local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity)
	return {
		health = health,
		hunger = hunger,
		cooked_health = cooked_health,
		cooked_hunger = cooked_hunger,
		seed_weight = seedweight,
		perishtime = perish_time,
		cooked_perishtime = cooked_perish_time,
		sanity = sanity,
		cooked_sanity = cooked_sanity
		
	}
end

-- Make an injectible instance of our cabbage
local cabbage = MakeVegStats(3,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0)

-- Add it to the global VEGGIES table
VEGGIES['cabbage'] = cabbage

-- We added this to the VEGGIES table so that cucumbers can be grown from "seeds" along with all the other veggies.


-- Base Cabbage (mostly copied from prefabs/veggies.lua)								
local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set animation info
	inst.AnimState:SetBuild("cucumber")
	inst.AnimState:SetBank("cucumber")
	inst.AnimState:PlayAnimation("idle")
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_TINY	-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL	-- Amount to fill belly
	inst.components.edible.sanityvalue = 0						-- Amount to help Sanity
	inst.components.edible.foodtype = "VEGGIE"					-- The type of food
	
	-- Make our cabbage perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)		-- Time until perished
	inst.components.perishable:StartPerishing() 					-- Start perishing right away
	inst.components.perishable.onperishreplacement = "spoiled_food"	-- Turn into spoiled food when perished
	
	-- Make our cabbage stackable
	inst:AddComponent("stackable")

	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cucumber"	-- Use our cucumber.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cucumber.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        
	
	-- Make it so cabbages can be used as bait in a trap
	inst:AddComponent("bait")
	
	-- Can be traded? Not sure what this is exactly...
	inst:AddComponent("tradable")
	
	-- Cabbages can be cooked (roasted actually)
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cabbage_cooked" -- This is what it becomes when cooked

	return inst
end

STRINGS.NAMES.CABBAGE = "Cabbage"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE = {	
	"A guy named Cabbage invented the computer... no wait, that was Babbage", 
	"About as large and wise as a man's head",
	"I heard that kids hang out around cabbage patches",
}

-- List of prefabs [I'm unclear why these are needed here, but veggies.lua provides them this way]
local prefabs =
{
	"cabbage_cooked",
	"cabbage_seeds",
	"spoiled_food",
}    

-- Make it so this can go in the cook_pot
AddIngredientValues({"cabbage"}, {fruit=1}, true)

-- Return our prefabbed cabbage
return Prefab( "common/inventory/cabbage", fn, assets, prefabs)