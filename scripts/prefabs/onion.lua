-- Our onion asset files
local assets=
{
    Asset("ANIM", "anim/onion.zip"),						-- Onion animation
    Asset("ATLAS", "images/inventoryimages/onion.xml"),		-- Onion Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/onion.tex"),		-- TEX for inventory
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

-- Make an injectible instance of our onion
local onion = MakeVegStats(1,	TUNING.CALORIES_SMALL,	0,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0)

-- Add it to the global VEGGIES table
VEGGIES['onion'] = onion

-- We added this to the VEGGIES table so that onions can be grown from "seeds" along with all the other veggies.


-- Base onion (mostly copied from prefabs/veggies.lua)								
local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set animation info
	inst.AnimState:SetBuild("onion")
	inst.AnimState:SetBank("onion")
	inst.AnimState:PlayAnimation("idle")
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0						-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL	-- Amount to fill belly
	inst.components.edible.sanityvalue = -TUNING.SANITY_TINY 	-- Amount to help Sanity
	inst.components.edible.foodtype = "VEGGIE"					-- The type of food
	
	-- Make our onion perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)		-- Time until perished
	inst.components.perishable:StartPerishing() 					-- start perishing right away
	inst.components.perishable.onperishreplacement = "spoiled_food"	-- Turn into spoiled food when perished
	
	-- Make our onion stackable
	inst:AddComponent("stackable")

	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "onion"								-- Use our onion.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/onion.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        
	
	-- Make it so onion can be used as bait in a trap
	inst:AddComponent("bait")
	
	-- Can be traded? Not sure what this is exactly...
	inst:AddComponent("tradable")
	
	-- Onions can be cooked
	inst:AddComponent("cookable")
	inst.components.cookable.product = "onion_cooked" -- This is what it becomes when cooked

	return inst
end

STRINGS.NAMES.ONION = "Onion"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION = {	
	"*Sob* Who's cutting onions?",
	"Ogres are like onions",
	"Onions always make me cry",
	"I can pickle that!",
}

-- List of prefabs [I'm unclear why these are needed here, but veggies.lua provides them this way]
local prefabs =
{
	"onion_cooked",
	"onion_seeds",
	"spoiled_food",
}    

-- Make it so this can go in the cook_pot
AddIngredientValues({"onion"}, {veggie=1}, true)

-- Return our prefabbed onion
return Prefab( "common/inventory/onion", fn, assets, prefabs)