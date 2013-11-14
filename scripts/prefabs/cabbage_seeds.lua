--[[
		There was a catch with getting our seeds to grow and have our cabbage show on the farm when matured
		We needed to define a second folder "cabbage01" within our cabbage.scml file (see file for clarity) 
		This required manual editing after using spriter (there is probably a way to do this within spriter though)
		
		The added layer/folder name.."01" is hard coded into the plant_normal.lua prefab, so we accomodated this in our anim
]]--

-- Our Cabbage Seeds asset (no animation, since we're using the base seed animation, like all seeds)
local assets={
    Asset("ATLAS", "images/inventoryimages/cabbage_seeds.xml"),
    Asset("IMAGE", "images/inventoryimages/cabbage_seeds.tex"),
}

-- Cabbage Seeds (mostly copied from prefabs/veggies.lua)								
local function fn_seeds()
	-- New Entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	
	-- Set Animation info
	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("seeds")
	inst.AnimState:SetRayTestOnBB(true) -- ?? What's this do?
	
	-- Make it edible
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "SEEDS" -- Food type is seeds

	-- It's stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM -- And it's small, (bigger stacks)

	-- ?? Tradable...
	inst:AddComponent("tradable")
	
	-- Inspectable
	inst:AddComponent("inspectable")
	
	-- It's an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cabbage_seeds"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cabbage_seeds.xml"
	
	-- By default use the idle animation
	inst.AnimState:PlayAnimation("idle")
	
	-- Tweak it's values for health and hunger
	inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
	inst.components.edible.hungervalue = TUNING.CALORIES_TINY

	-- It's perishable
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)	-- but it takes a long time to perish
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"		-- Turns into spoiled food when it perishes
	
	-- Seeds can be cooked
	inst:AddComponent("cookable")
	inst.components.cookable.product = "seeds_cooked"	-- Turns into cooked seeds when cooked (like all seeds)
	
	-- Seeds make great bait
	inst:AddComponent("bait")
	
	-- Make it so our cabbage seeds can be planted in farms (and anywhere else seeds can grow in the future probably)
	inst:AddComponent("plantable")
	inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME	-- Set the grow time
	inst.components.plantable.product = "cabbage"				-- Cabbage seeds grow into a cabbage (shocking!)
	
	return inst
end

STRINGS.NAMES.CABBAGE_SEEDS = "Cabbage Seeds"

-- Return our prefabbed cabbage seeds
return Prefab( "common/inventory/cabbage_seeds", fn_seeds, assets)