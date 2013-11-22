-- Our beet asset files
local assets=
{
    Asset("ANIM", "anim/beet.zip"),							-- beet animation
    Asset("ATLAS", "images/inventoryimages/beet.xml"),		-- beet Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/beet.tex"),		-- TEX for inventory
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

-- Make an injectible instance of our beet
local beet = MakeVegStats(2,	TUNING.CALORIES_MEDSMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_MED, 0,		
								TUNING.CALORIES_SMALL,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0)

-- Add it to the global VEGGIES table
VEGGIES['beet'] = beet

-- We added this to the VEGGIES table so that beet can be grown from "seeds" along with all the other veggies.


-- Base beet (mostly copied from prefabs/veggies.lua)								
local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set animation info
	inst.AnimState:SetBuild("beet")
	inst.AnimState:SetBank("beet")
	inst.AnimState:PlayAnimation("idle")
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_TINY	-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL	-- Amount to fill belly
	inst.components.edible.sanityvalue = 0						-- Amount to help Sanity
	inst.components.edible.foodtype = "VEGGIE"					-- The type of food
	
	-- Make our beet perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)		-- Time until perished
	inst.components.perishable:StartPerishing() 					-- Start perishing right away
	inst.components.perishable.onperishreplacement = "spoiled_food"	-- Turn into spoiled food when perished
	
	-- Make our beet stackable
	inst:AddComponent("stackable")

	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "beet"	-- Use our beet.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/beet.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        
	
	-- Make it so beets can be used as bait in a trap
	inst:AddComponent("bait")
	
	-- Can be traded? Not sure what this is exactly...
	inst:AddComponent("tradable")
	
	-- Beets can be cooked
	inst:AddComponent("cookable")
	inst.components.cookable.product = "beet_cooked" -- This is what it becomes when cooked

	return inst
end

STRINGS.NAMES.BEET = "Beet"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET = {	
	"Fact: bears eat beets. Bears, beets, Battlestar Galactica",
	"Nobody likes beets. Maybe I should have grown candy instead.",
	"Let's have a garden party.\nLettuce turnip the beet.",
}

-- List of prefabs [I'm unclear why these are needed here, but veggies.lua provides them this way]
local prefabs =
{
	"beet_cooked",
	"beet_seeds",
	"spoiled_food",
}    

-- Make it so this can go in the cook_pot
AddIngredientValues({"beet"}, {fruit=1}, true)

-- Return our prefabbed beet
return Prefab( "common/inventory/beet", fn, assets, prefabs)