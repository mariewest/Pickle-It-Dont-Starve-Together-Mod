require "tuning"
require "cooking"

local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity)
	return {
		health = health,
		hunger = hunger,
		cooked_health = cooked_health,
		cooked_hunger = cooked_hunger,
		seed_weight = seedweight,
		perishtime = perish_time,
		cooked_perishtime = cooked_perish_time,
		sanity = sanity,
		cooked_sanity = cooked_sanity,
	}
end

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

PICKLEITVEGGIES =
{
	--sw, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time,cooked_sanity
	beet = MakeVegStats(.5,TUNING.CALORIES_SMALL,TUNING.HEALING_TINY,TUNING.PERISH_MED,0,TUNING.CALORIES_SMALL,TUNING.HEALING_MEDSMALL,TUNING.PERISH_FAST,0),
	cabbage = MakeVegStats(	2,TUNING.CALORIES_SMALL,TUNING.HEALING_TINY,TUNING.PERISH_MED,0,TUNING.CALORIES_SMALL,TUNING.HEALING_MEDSMALL,TUNING.PERISH_FAST,TUNING.SANITY_SUPERTINY),
	cucumber = MakeVegStats(2,TUNING.CALORIES_SMALL,0,TUNING.PERISH_MED,0,TUNING.CALORIES_SMALL,TUNING.HEALING_SMALL,TUNING.PERISH_FAST,0),
	onion = MakeVegStats(1,TUNING.CALORIES_SMALL,0,TUNING.PERISH_MED,0,TUNING.CALORIES_SMALL,TUNING.HEALING_SMALL,TUNING.PERISH_FAST,TUNING.SANITY_TINY),
	potato = MakeVegStats(2,TUNING.CALORIES_SMALL,-TUNING.HEALING_SMALL,TUNING.PERISH_SLOW,-TUNING.SANITY_SMALL,TUNING.CALORIES_MEDSMALL,TUNING.HEALING_SMALL,TUNING.PERISH_SUPERFAST, TUNING.SANITY_SUPERTINY),
	radish = MakeVegStats(.5,TUNING.CALORIES_TINY,TUNING.HEALING_TINY,TUNING.PERISH_MED,0,TUNING.CALORIES_TINY,TUNING.HEALING_MEDSMALL,TUNING.PERISH_FAST,TUNING.SANITY_SUPERTINY),
}

-- Make Pickle It veggies usable in the crock pot
local veggies = {"beet", "cabbage", "cucumber", "onion", "radish"}
AddIngredientValues(veggies, {veggie=1}, true)
-- Compatibility with "Waiter 101"
AddIngredientValues({"potato"}, {veggie=1, tuber=1}, true)

local assets_seeds =
{
    Asset("ANIM", "anim/seeds.zip"),
}

local function MakeVeggie(name, has_seeds)

	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
    	Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
	    Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
	}

	local assets_cooked =
	{
		Asset("ANIM", "anim/"..name..".zip"),
	    Asset("IMAGE", "images/inventoryimages/"..name.."_cooked.tex"),
	    Asset("ATLAS", "images/inventoryimages/"..name.."_cooked.xml"),
	}

	local assets_seeds =
	{
		Asset("ANIM", "anim/"..name..".zip"),
	    Asset("IMAGE", "images/inventoryimages/"..name.."_seeds.tex"),
	    Asset("ATLAS", "images/inventoryimages/"..name.."_seeds.xml"),
	}

	local prefabs =
	{
		name.."_cooked",
		"spoiled_food",
	}

	if has_seeds then
		table.insert(prefabs, name.."_seeds")
	end

	local function fn_seeds()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("seeds")
        inst.AnimState:SetBuild("seeds")
        inst.AnimState:SetRayTestOnBB(true)
		inst.AnimState:PlayAnimation("idle")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

		inst:AddComponent("edible")
		inst.components.edible.healthvalue 	= TUNING.HEALING_TINY/2
		inst.components.edible.hungervalue 	= TUNING.CALORIES_TINY
		inst.components.edible.foodtype 	= FOODTYPE.SEEDS

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name.."_seeds"
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name.."_seeds.xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("cookable")
		inst.components.cookable.product = "seeds_cooked"

		inst:AddComponent("bait")

		inst:AddComponent("plantable")
		inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
		inst.components.plantable.product = name

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

		inst:AddComponent("edible")
		inst.components.edible.healthvalue 	= PICKLEITVEGGIES[name].health
		inst.components.edible.hungervalue 	= PICKLEITVEGGIES[name].hunger
		inst.components.edible.sanityvalue 	= PICKLEITVEGGIES[name].sanity or 0
		inst.components.edible.foodtype 	= FOODTYPE.VEGGIE

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLEITVEGGIES[name].perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("bait")

		-- Potatoes are a little special
		if name == "potato" then
			-- Potatoes are their own seeds
			inst:AddComponent("plantable")
			inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
			inst.components.plantable.product = name
		end

		inst:AddComponent("cookable")
		inst.components.cookable.product = name.."_cooked"

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local function fn_cooked()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("cooked")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = PICKLEITVEGGIES[name].cooked_health
		inst.components.edible.hungervalue = PICKLEITVEGGIES[name].cooked_hunger
		inst.components.edible.sanityvalue = PICKLEITVEGGIES[name].cooked_sanity or 0
		inst.components.edible.foodtype = FOODTYPE.VEGGIE

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name.."_cooked"
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name.."_cooked.xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLEITVEGGIES[name].cooked_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("bait")

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local base = Prefab( "common/inventory/"..name, fn, assets, prefabs)
	local cooked = Prefab( "common/inventory/"..name.."_cooked", fn_cooked, assets_cooked)
	local seeds = has_seeds and Prefab( "common/inventory/"..name.."_seeds", fn_seeds, assets_seeds) or nil

	return base, cooked, seeds
end

local prefs = {}
for veggiename,veggiedata in pairs(PICKLEITVEGGIES) do
	local veg, cooked, seeds

	-- Potatoes don't have seeds; all other veggies do
	if veggiename == "potato" then
		veg, cooked, seeds = MakeVeggie(veggiename, false)
	else
		veg, cooked, seeds = MakeVeggie(veggiename, true)
	end

	table.insert(prefs, veg)
	table.insert(prefs, cooked)
	if seeds then
		table.insert(prefs, seeds)

		-- Add them to global
		VEGGIES[veggiename] = veggiedata
	end
end

return unpack(prefs)
