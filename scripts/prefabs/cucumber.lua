-- Our cucumber asset files
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

-- Make an injectible instance of our cucumber
local cucumber = MakeVegStats(3,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0)

-- Add it to the global VEGGIES table
VEGGIES['cucumber'] = cucumber

-- We added this to the VEGGIES table so that cucumbers can be grown from "seeds" along with all the other veggies.


-- Base Cucumber (mostly copied from prefabs/veggies.lua)								
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
	
	-- Make our cucumber perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)		-- Time until perished
	inst.components.perishable:StartPerishing() 					-- start perishing right away
	inst.components.perishable.onperishreplacement = "spoiled_food"	-- Turn into spoiled food when perished
	
	-- Make our cucumber stackable
	inst:AddComponent("stackable")

	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cucumber"	-- Use our cucumber.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cucumber.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- Not sure what this one does yet...
	MakeSmallPropagator(inst)        
	
	-- Make it so cucumbers can be used as bait in a trap
	inst:AddComponent("bait")
	
	-- Can be traded? Not sure what this is exactly...
	inst:AddComponent("tradable")
	
	-- Cucumbers can be cooked (grilled actually)
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cucumber_cooked" -- This is what it becomes when cooked

	return inst
end

-- List of prefabs [I'm unclear why these are needed here, but veggies.lua provides them this way]
local prefabs =
{
	"cucumber_cooked",
	"cucumber_seeds",
	"spoiled_food",
}    

-- Make it so this can go in the cook_pot
AddIngredientValues({"cucumber"}, {fruit=1}, true)

-- Return our prefabbed cucumber
return Prefab( "common/inventory/cucumber", fn, assets, prefabs)