-- Global table for recipes
pickleit_Recipes = {}

-- Add a pickled food recipe (called by CreatePickledPrefab, but can be called by anything)
function pickleit_AddRecipe(source, result)
	if source ~= nil and result ~= nil then
		pickleit_Recipes[source] = result
		return true
	end
	
	return false
end

--[[ This is what the pickled data should look like
local pickled_data = {
	name = 'item_name',
	formatted_name = 'Item Name',
	
	healing = TUNING.HEALING_TINY,
	hunger = TUNING.CALORIES_SMALL,
	sanity = TUNING.SANITY_TINY,
	perishtime = TUNING.PERISH_SLOW,
	stack_size = TUNING.STACK_SIZE_SMALLITEM,
	food_type = "GENERIC",
	
	burnable = true,
	baitable = true,
	
	description = {
		"Looks tasty", 
		"Can't wait to eat it!",
	},
	
	assets = {
		Asset("ANIM", "anim/my_pickled_food.zip"),
	},
	
	art_bank = 'my_art_bank',
	art_build = 'my_art_build',
	art_anim = 'my_animation',
	
	source = 'my_source_food',
}
--]]


-- Global function to easily create a new prefab for pickled foods
function pickleit_CreatePickledPrefab(pickled_data)
	pickleit_data[pickled_data.name] = pickled_data
	
	local function fn(sim)
		-- Create entity
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		-- Set art assets
		inst.AnimState:SetBank(pickled_data.art_bank)
		inst.AnimState:SetBuild(pickled_data.art_build)
		inst.AnimState:PlayAnimation(pickled_data.art_anim)
		
		-- Make it edible
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = pickled_data.healing
		inst.components.edible.hungervalue = pickled_data.hunger
		inst.components.edible.sanityvalue = pickled_data.sanity or 0		
		inst.components.edible.foodtype = pickled_data.foodtype or "GENERIC"
		
		-- Make it perisable
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(pickled_data.perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
		
		-- Make it inspectable
		inst:AddComponent("inspectable")
		inst.components.inspectable:SetDescription(pickled_data.description[math.random(#pickled_data.description)])

		-- It can go in the inventory
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = pickled_data.name
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..pickled_data.name..".xml"
		
		-- It stacks
		inst:AddComponent("stackable")
		if pickled_data.stack_size == nil then
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		else
			inst.components.stackable.maxsize = pickled_data.stack_size
		end
		
		
		-- If it burns, let it burn
		if pickled_data.burnable then
			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
		end

		-- If it's baitable, let it bait
		if pickled_data.baitable then
			inst:AddComponent("bait")
		end
		
		-- It's tradable
		inst:AddComponent("tradable")
	
		return inst
	end

	-- Add the recipe
	pickleit_AddRecipe(pickled_data.source, pickled_data.name)
	
	-- Return the prefab
	return Prefab( "common/inventory/"..pickled_data.name, fn, pickled_data.assets)

end