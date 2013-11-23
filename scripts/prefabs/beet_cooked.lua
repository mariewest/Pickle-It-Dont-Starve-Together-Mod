-- Our roasted beet asset files
local assets=
{
    Asset("ANIM", "anim/beet.zip"),									-- Beet animation (has "cooked" animation in it)
    Asset("ATLAS", "images/inventoryimages/beet_cooked.xml"),		-- Roasted beet atlas for TEX
    Asset("IMAGE", "images/inventoryimages/beet_cooked.tex"),		-- Roasted beet TEX for inventory
}

-- Base Cooked Beet (mostly copied from prefabs/veggies.lua)								
local function fn_cooked(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set our animation info: bank/build/animation
	inst.AnimState:SetBank("beet")
	inst.AnimState:SetBuild("beet")
	inst.AnimState:PlayAnimation("cooked")	-- Cooked is part of our base beet
	
	-- Make this perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_SMALL
	inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = "VEGGIE"
	
	-- Make it stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	-- Make it inspectable
	inst:AddComponent("inspectable")
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "beet_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/beet_cooked.xml"

	-- Cooked beet can burn
	MakeSmallBurnable(inst)
	
	-- ??
	MakeSmallPropagator(inst)
	
	-- Birds and bunnies eat it, so it's bait still.
	inst:AddComponent("bait")
	
	-- ??
	inst:AddComponent("tradable")

	return inst
end

STRINGS.NAMES.BEET_COOKED = "Roasted Beet"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_COOKED = {	
	"Roasted beets have a sweet earthy flavor", 
	"Sweeter than unroasted beets", 
}

-- Return our prefabbed cooked beet
return Prefab( "common/inventory/beet_cooked", fn_cooked, assets)