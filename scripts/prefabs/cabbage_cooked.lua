-- Our grilled cabbage asset files
local assets=
{
    Asset("ANIM", "anim/cabbage.zip"),								-- Cabbage animation (has "cooked" animation in it)
    Asset("ATLAS", "images/inventoryimages/cabbage_cooked.xml"),	-- Grilled cabbage atlas for TEX
    Asset("IMAGE", "images/inventoryimages/cabbage_cooked.tex"),	-- Grilled cabbage TEX for inventory
}

-- Base Cooked Cabbage (mostly copied from prefabs/veggies.lua)								
local function fn_cooked(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set our animation info: bank/build/animation
	inst.AnimState:SetBank("cabbage")
	inst.AnimState:SetBuild("cabbage")
	inst.AnimState:PlayAnimation("cooked")	-- Cooked is part of our base cabbage
	
	-- Make this perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_SMALL
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
    inst.components.inventoryitem.imagename = "cabbage_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cabbage_cooked.xml"

	-- Cooked cabbage can burn
	MakeSmallBurnable(inst)
	
	-- ??
	MakeSmallPropagator(inst)
	
	-- Birds and bunnies eat it, so it's bait still.
	inst:AddComponent("bait")
	
	-- ??
	inst:AddComponent("tradable")

	return inst
end

STRINGS.NAMES.CABBAGE_COOKED = "Roasted Cabbage"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE_COOKED = {	
	"Crunchy and tasty", 
	"So easy to make, just slice and cook", 
}

-- Return our prefabbed cooked cabbage
return Prefab( "common/inventory/cabbage_cooked", fn_cooked, assets)