-- Our radish asset files
local assets=
{
    Asset("ANIM", "anim/radish.zip"),							-- radish animation
    Asset("ATLAS", "images/inventoryimages/radish.xml"),		-- radish Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/radish.tex"),		-- TEX for inventory
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

-- Make an injectible instance of our radish
local radish = MakeVegStats(.5,	TUNING.CALORIES_TINY,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
								TUNING.CALORIES_SMALL,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0)

-- Add it to the global VEGGIES table
VEGGIES['radish'] = radish

-- We added this to the VEGGIES table so that radish can be grown from "seeds" along with all the other veggies.


-- Base radish (mostly copied from prefabs/veggies.lua)								
local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set animation info
	inst.AnimState:SetBuild("radish")
	inst.AnimState:SetBank("radish")
	inst.AnimState:PlayAnimation("idle")
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_TINY	-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_TINY	-- Amount to fill belly
	inst.components.edible.sanityvalue = 0						-- Amount to help Sanity
	inst.components.edible.foodtype = "VEGGIE"					-- The type of food
	
	-- Make our radish perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)		-- Time until perished
	inst.components.perishable:StartPerishing() 					-- Start perishing right away
	inst.components.perishable.onperishreplacement = "spoiled_food"	-- Turn into spoiled food when perished
	
	-- Make our radish stackable
	inst:AddComponent("stackable")

	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "radish"	-- Use our radish.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/radish.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        
	
	-- Make it so radishes can be used as bait in a trap
	inst:AddComponent("bait")
	
	-- Can be traded? Not sure what this is exactly...
	inst:AddComponent("tradable")
	
	-- Radishes can be cooked
	inst:AddComponent("cookable")
	inst.components.cookable.product = "radish_cooked" -- This is what it becomes when cooked

	return inst
end

STRINGS.NAMES.RADISH = "Radish"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH = {	
	"What is small, red, and whispers?\nA hoarse radish!",
	"This veggie is so rad(ish)",
}

-- List of prefabs [I'm unclear why these are needed here, but veggies.lua provides them this way]
local prefabs =
{
	"radish_cooked",
	"radish_seeds",
	"spoiled_food",
}    

-- Make it so this can go in the cook_pot
AddIngredientValues({"radish"}, {fruit=1}, true)

-- Return our prefabbed radish
return Prefab( "common/inventory/radish", fn, assets, prefabs)