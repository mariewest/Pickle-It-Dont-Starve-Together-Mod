local assets=
{
    Asset("ANIM", "anim/pigs_foot.zip"),						-- Animation Zip
    Asset("ATLAS", "images/inventoryimages/pigs_foot_dried.xml"),	-- Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/pigs_foot_dried.tex"),	-- TEX for inventory
}

local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst:AddTag("meat")
	
	-- Set animation info
	inst.AnimState:SetBuild("pigs_foot")
	inst.AnimState:SetBank("pigs_foot")
	inst.AnimState:PlayAnimation("dried")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetPristine()
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_SMALL	-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_MED	-- Amount to fill belly
	inst.components.edible.sanityvalue = 0						-- Amount to help Sanity
	inst.components.edible.ismeat = true    
	inst.components.edible.foodtype = "MEAT"					-- The type of food
	
	-- Make it perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	-- Make it stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "pigs_foot_dried"	-- Use our TEX sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pigs_foot_dried.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        
	
	inst:AddComponent("bait")
	
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
		
	return inst
end

-- Return our prefab
return Prefab( "common/inventory/pigs_foot_dried", fn, assets)