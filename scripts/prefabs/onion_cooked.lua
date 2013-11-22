-- Our onion rings asset files
local assets=
{
    Asset("ANIM", "anim/onion.zip"),								-- Onion animation (has "cooked" animation in it)
    Asset("ATLAS", "images/inventoryimages/onion_cooked.xml"),		-- Onion rings atlas for TEX
    Asset("IMAGE", "images/inventoryimages/onion_cooked.tex"),		-- Onion rings TEX for inventory
}

-- Base Cooked Onion (mostly copied from prefabs/veggies.lua)								
local function fn_cooked(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set our animation info: bank/build/animation
	inst.AnimState:SetBank("onion")
	inst.AnimState:SetBuild("onion")
	inst.AnimState:PlayAnimation("cooked")	-- Cooked is part of our base onion
	
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
    inst.components.inventoryitem.imagename = "onion_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/onion_cooked.xml"

	-- Cooked onion can burn
	MakeSmallBurnable(inst)
	
	-- ??
	MakeSmallPropagator(inst)
	
	-- Birds and bunnies eat it, so it's bait still.
	inst:AddComponent("bait")
	
	-- ??
	inst:AddComponent("tradable")

	return inst
end

STRINGS.NAMES.ONION_COOKED = "Onion Rings"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION_COOKED = {	
	"If you like it, you should put an onion ring on it",
	"If you hear an onion ring, answer it",
	"I guess this makes me the Lord of the Onion Rings",
}

-- Return our prefabbed cooked onion
return Prefab( "common/inventory/onion_cooked", fn_cooked, assets)