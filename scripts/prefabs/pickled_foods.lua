require "tuning"
require "pickled_recipes"

local function MakePickledFoodStats(pickled_hunger, pickled_health, pickled_perishtime, pickled_sanity, pickled_foodtype, pickled_stacksize, source)
	return {
		pickled_hunger = pickled_hunger,
		pickled_health = pickled_health,
		pickled_perishtime = pickled_perishtime,
		pickled_sanity = pickled_sanity,
		pickled_foodtype = pickled_foodtype,
		pickled_stacksize = pickled_stacksize,
		source = source,
	}
end

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

PICKLED_FOODS = 
{
 	beet = MakePickledFoodStats(		TUNING.CALORIES_SMALL, 		TUNING.HEALING_TINY, 		TUNING.PERISH_PRESERVED, 	0, 							FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	cabbage = MakePickledFoodStats(		TUNING.CALORIES_MEDSMALL, 	TUNING.HEALING_SMALL, 		TUNING.PERISH_PRESERVED, 	TUNING.SANITY_SUPERTINY,	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	cucumber = MakePickledFoodStats(	TUNING.CALORIES_SMALL, 		TUNING.HEALING_TINY, 		TUNING.PERISH_SUPERSLOW, 	TUNING.SANITY_SMALL, 		FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	onion = MakePickledFoodStats(		TUNING.CALORIES_SMALL, 		TUNING.HEALING_TINY, 		TUNING.PERISH_PRESERVED, 	-TUNING.SANITY_SUPERTINY, 	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	radish = MakePickledFoodStats(		TUNING.CALORIES_TINY, 		TUNING.HEALING_TINY, 		TUNING.PERISH_PRESERVED, 	TUNING.SANITY_SUPERTINY,	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
		
	carrot = MakePickledFoodStats(		TUNING.CALORIES_SMALL, 		TUNING.HEALING_SMALL,	 	TUNING.PERISH_PRESERVED, 	0,							FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	corn = MakePickledFoodStats(		TUNING.CALORIES_MEDSMALL, 	TUNING.HEALING_TINY, 		TUNING.PERISH_PRESERVED, 	-TUNING.SANITY_SUPERTINY,	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	mushroom = MakePickledFoodStats(	TUNING.CALORIES_SMALL, 		TUNING.HEALING_SMALL, 		TUNING.PERISH_PRESERVED, 	-TUNING.SANITY_SUPERTINY,	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM, 	"red_cap"),
	pumpkin = MakePickledFoodStats(		TUNING.CALORIES_MED, 		TUNING.HEALING_SMALL, 		TUNING.PERISH_PRESERVED, 	TUNING.SANITY_SUPERTINY,	FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
	eggplant = MakePickledFoodStats(	TUNING.CALORIES_SMALL, 		TUNING.HEALING_SMALL, 		TUNING.PERISH_PRESERVED, 	0,							FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),

	egg = MakePickledFoodStats(			TUNING.CALORIES_SMALL, 		TUNING.HEALING_SMALL, 		TUNING.PERISH_SUPERSLOW, 	TUNING.SANITY_TINY,			FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM, 	"bird_egg"),
	fish = MakePickledFoodStats(		TUNING.CALORIES_MED, 		TUNING.HEALING_MEDLARGE, 	TUNING.PERISH_PRESERVED, 	-TUNING.SANITY_SMALL,		FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),

	pigs_foot = MakePickledFoodStats(	TUNING.CALORIES_LARGE, 		TUNING.HEALING_MEDLARGE, 	TUNING.PERISH_PRESERVED, 	-TUNING.SANITY_MED,			FOODTYPE.VEGGIE, 	TUNING.STACK_SIZE_SMALLITEM),
}

local function MakePickledFood(name)
	local assets =
	{
		Asset("ANIM", "anim/pickled_food.zip"),
		Asset("ATLAS", "images/inventoryimages/"..name.."_pickled.xml"),
		Asset("IMAGE", "images/inventoryimages/"..name.."_pickled.tex"),
	}
		
	local prefabs =
	{
		name.."_pickled",
	}

	local function fn(sim)
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		
		if name == "carrot" then
			inst.AnimState:SetBank("carrot_pickled")
			inst.AnimState:SetBuild("pickled_food")
			inst.AnimState:PlayAnimation('idle')
		else
			inst.AnimState:SetBank(name)
			inst.AnimState:SetBuild(name)
			inst.AnimState:PlayAnimation('pickled')
		end
	
        if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLED_FOODS[name].pickled_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = PICKLED_FOODS[name].pickled_health
		inst.components.edible.hungervalue = PICKLED_FOODS[name].pickled_hunger
		inst.components.edible.sanityvalue = PICKLED_FOODS[name].pickled_sanity 	 or 0		
		inst.components.edible.foodtype = 	 PICKLED_FOODS[name].pickled_foodtype or FOODTYPE.VEGGIE

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = PICKLED_FOODS[name].pickled_stacksize or TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name.."_pickled"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name.."_pickled.xml"
		
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		inst:AddComponent("bait")
		
		inst:AddComponent("tradable")

		MakeHauntableLaunchAndPerish(inst)
	
		return inst
	end

	local pickled = Prefab( "common/inventory/"..name.."_pickled", fn, assets)

	return pickled
end

local prefs = {}
for foodname,fooddata in pairs(PICKLED_FOODS) do
	local pickled = MakePickledFood(foodname)
	table.insert(prefs, pickled)

	-- Add the recipe
	pickleit_AddRecipe((fooddata.source or foodname), foodname.."_pickled")
end

-- Two random addition recipes to add
pickleit_AddRecipe("green_cap", "mushroom")
pickleit_AddRecipe("blue_cap", "mushroom")



return unpack(prefs)