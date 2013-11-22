-- Our roasted radish asset files
local assets=
{
    Asset("ANIM", "anim/radish.zip"),								-- Radish animation (has "cooked" animation in it)
    Asset("ATLAS", "images/inventoryimages/radish_cooked.xml"),		-- Roasted radish atlas for TEX
    Asset("IMAGE", "images/inventoryimages/radish_cooked.tex"),		-- Roasted radish TEX for inventory
}

-- Base Cooked Radish (mostly copied from prefabs/veggies.lua)								
local function fn_cooked(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set our animation info: bank/build/animation
	inst.AnimState:SetBank("radish")
	inst.AnimState:SetBuild("radish")
	inst.AnimState:PlayAnimation("cooked")	-- Cooked is part of our base radish
	
	-- Make this perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_MED
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = "VEGGIE"
	
	-- Make it stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "radish_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/radish_cooked.xml"

	-- Cooked radish can burn
	MakeSmallBurnable(inst)
	
	-- ??
	MakeSmallPropagator(inst)
	
	-- Birds and bunnies eat it, so it's bait still.
	inst:AddComponent("bait")
	
	-- ??
	inst:AddComponent("tradable")

	return inst
end

STRINGS.NAMES.RADISH_COOKED = "Roasted Radish"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH_COOKED = {	
	"Delicious and healthy",
	"Sweeter and softer than a raw radish",
}

-- Return our prefabbed cooked radish
return Prefab( "common/inventory/radish_cooked", fn_cooked, assets)