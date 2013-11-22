local assets=
{
    Asset("ANIM", "anim/pigs_foot.zip"),						-- Animation Zip
    Asset("ATLAS", "images/inventoryimages/pigs_foot.xml"),	-- Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/pigs_foot.tex"),	-- TEX for inventory
}

local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set animation info
	inst.AnimState:SetBuild("pigs_foot")
	inst.AnimState:SetBank("pigs_foot")
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
    inst.components.inventoryitem.imagename = "cabbage"	-- Use our cabbage.tex sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cabbage.xml"	-- here's the atlas for our tex
	
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