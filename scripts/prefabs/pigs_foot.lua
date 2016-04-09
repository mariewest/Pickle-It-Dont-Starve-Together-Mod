require "cooking"

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
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst:AddTag("meat")

	-- Set animation info
	inst.AnimState:SetBuild("pigs_foot")
	inst.AnimState:SetBank("pigs_foot")
	inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetPristine()

	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0						-- Amount to heal
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL	-- Amount to fill belly
	inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL	-- Amount to help Sanity
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = "MEAT"					-- The type of food

	-- Make it perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	-- Make it stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	-- Make it inspectable
	inst:AddComponent("inspectable")

	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "pigs_foot"	-- Use our TEX sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pigs_foot.xml"	-- here's the atlas for our tex

	-- It can burn!
	MakeSmallBurnable(inst)

	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)

	inst:AddComponent("bait")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT

	-- This is cookable
	inst:AddComponent("cookable")
	inst.components.cookable.product = "pigs_foot_cooked" -- This is what it becomes when cooked

	-- Can be dried
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("pigs_foot_dried")
    --inst.components.dryable:SetProduct("smallmeat_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

	return inst
end

-- Make it so this can go in the cook_pot and drying rack
AddIngredientValues({"pigs_foot"}, {meat=.5}, true, true)

-- Return our prefab
return Prefab( "common/inventory/pigs_foot", fn, assets)
