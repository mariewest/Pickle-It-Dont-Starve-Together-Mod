-- Our grilled cucumber asset files
local assets=
{
    Asset("ANIM", "anim/cucumber.zip"),								-- Cucumber animation (has "cooked" animation in it)
    Asset("ATLAS", "images/inventoryimages/cucumber_cooked.xml"),	-- Grilled Cucumber atlas for TEX
    Asset("IMAGE", "images/inventoryimages/cucumber_cooked.tex"),	-- Grilled Cucumber TEX for inventory
}

-- Base Cooked Cucumber (mostly copied from prefabs/veggies.lua)								
local function fn_cooked(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set our animation info: bank/build/animation
	inst.AnimState:SetBank("cucumber")
	inst.AnimState:SetBuild("cucumber")
	inst.AnimState:PlayAnimation("cooked")	-- Cooked is part of our base cucumber
	
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
    inst.components.inventoryitem.imagename = "cucumber_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cucumber_cooked.xml"

	-- Cooked cucumber can burn
	MakeSmallBurnable(inst)
	
	-- ??
	MakeSmallPropagator(inst)
	
	-- Birds and bunnies eat it, so it's bait still.
	inst:AddComponent("bait")
	
	-- ??
	inst:AddComponent("tradable")

	return inst
end

STRINGS.NAMES.CUCUMBER_COOKED = "Grilled Cucumber"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUCUMBER_COOKED = {	
	"It'll never become a pickle now", 
	"Tastes like grilled water", 
	"Poor Larry",
}

-- Return our prefabbed cooked cucumber
return Prefab( "common/inventory/cucumber_cooked", fn_cooked, assets)