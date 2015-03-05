require "tuning"
require "pickled_recipes"

local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity, pickled_hunger, pickled_health, pickled_perishtime, pickled_sanity)
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
		pickled_hunger = pickled_hunger,
		pickled_health = pickled_health,
		pickled_perishtime = pickled_perishtime,
		pickled_sanity = pickled_sanity,
	}
end

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

PICKLEITVEGGIES = 
{
 	beet = MakeVegStats(.5,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
								TUNING.CALORIES_SMALL,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0,
								TUNING.CALORIES_SMALL, TUNING.HEALING_TINY, TUNING.PERISH_PRESERVED, TUNING.SANITY_TINY),
	cabbage = MakeVegStats(2,	TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0,
									TUNING.CALORIES_MEDSMALL, TUNING.HEALING_SMALL, TUNING.PERISH_PRESERVED, TUNING.SANITY_SUPERTINY),
	cucumber = MakeVegStats(2,	TUNING.CALORIES_SMALL,	0,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0,
									TUNING.CALORIES_SMALL, TUNING.HEALING_TINY, TUNING.PERISH_SUPERSLOW, TUNING.SANITY_TINY),
	onion = MakeVegStats(1,	TUNING.CALORIES_SMALL,	0,	TUNING.PERISH_MED, 0,		
									TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0,
									TUNING.CALORIES_SMALL, TUNING.HEALING_TINY, TUNING.PERISH_SUPERSLOW, TUNING.SANITY_TINY),
	radish = MakeVegStats(.5,	TUNING.CALORIES_TINY,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,		
								TUNING.CALORIES_SMALL,	TUNING.HEALING_MEDSMALL,	TUNING.PERISH_FAST, 0,
								TUNING.CALORIES_TINY, TUNING.HEALING_TINY, TUNING.PERISH_PRESERVED, TUNING.SANITY_SUPERTINY),
}

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

	local assets_pickled =
	{
		Asset("ANIM", "anim/pickled_food.zip"),
	    Asset("ATLAS", "images/inventoryimages/"..name.."_pickled.xml"),
	    Asset("IMAGE", "images/inventoryimages/"..name.."_cooked.tex"),
	}
		
	local prefabs =
	{
		name.."_cooked",
		name.."_pickled",
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

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

		inst:AddComponent("edible")
		inst.components.edible.foodtype = FOODTYPE.SEEDS

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")

		inst.AnimState:PlayAnimation("idle")
		inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
		inst.components.edible.hungervalue = TUNING.CALORIES_TINY

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
		inst.components.edible.healthvalue = PICKLEITVEGGIES[name].health
		inst.components.edible.hungervalue = PICKLEITVEGGIES[name].hunger
		inst.components.edible.sanityvalue = PICKLEITVEGGIES[name].sanity or 0		
		inst.components.edible.foodtype = FOODTYPE.VEGGIE

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLEITVEGGIES[name].perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name	-- Use our beet.tex sprite
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"	-- here's the atlas for our tex

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		---------------------        

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")

		------------------------------------------------  

		inst:AddComponent("cookable")
		inst.components.cookable.product = name.."_cooked"

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
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLEITVEGGIES[name].cooked_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = PICKLEITVEGGIES[name].cooked_health
		inst.components.edible.hungervalue = PICKLEITVEGGIES[name].cooked_hunger
		inst.components.edible.sanityvalue = PICKLEITVEGGIES[name].cooked_sanity or 0
		inst.components.edible.foodtype = FOODTYPE.VEGGIE

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		---------------------        

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local function fn_pickled(sim)
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation('pickled')
	
        if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(PICKLEITVEGGIES[name].pickled_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = PICKLEITVEGGIES[name].pickled_health
		inst.components.edible.hungervalue = PICKLEITVEGGIES[name].pickled_hunger
		inst.components.edible.sanityvalue = PICKLEITVEGGIES[name].pickled_sanity or 0		
		inst.components.edible.foodtype = PICKLEITVEGGIES[name].pickled_foodtype or FOODTYPE.VEGGIE

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = PICKLEITVEGGIES[name].pickled_stacksize or TUNING.STACK_SIZE_SMALLITEM
		
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

	local base = Prefab( "common/inventory/"..name, fn, assets, prefabs)
	local cooked = Prefab( "common/inventory/"..name.."_cooked", fn_cooked, assets_cooked)
	local pickled = Prefab( "common/inventory/"..name.."_pickled", fn_pickled, assets_pickled)
	local seeds = has_seeds and Prefab( "common/inventory/"..name.."_seeds", fn_seeds, assets_seeds) or nil

	return base, cooked, pickled, seeds
end

local prefs = {}
for veggiename,veggiedata in pairs(PICKLEITVEGGIES) do
	-- Add them to global
	VEGGIES[veggiename] = veggiedata

	local veg, cooked, pickled, seeds = MakeVeggie(veggiename, true)
	table.insert(prefs, veg)
	table.insert(prefs, cooked)
	table.insert(prefs, pickled)
	if seeds then
		table.insert(prefs, seeds)
	end
end

----
--	This is not where these strings should go, but they work... Need to figure out where to put these.
----

STRINGS.NAMES.BEET = "Beet"
STRINGS.NAMES.BEET_COOKED = "Roasted Beet"
STRINGS.NAMES.BEET_SEEDS = "Beet Seeds"
STRINGS.NAMES.BEET_PICKLED = "Pickled Beet"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET = {	
	"Fact: bears eat beets. Bears, beets, Battlestar Galactica",
	"Nobody likes beets. Maybe I should have grown candy instead.",
	"Let's have a garden party.\nLettuce turnip the beet.",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_COOKED = {	
	"Roasted beets have a sweet earthy flavor", 
	"Sweeter than unroasted beets", 
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PICKLED = {	
	"I hear people really like pickled beets.\nMaybe I should give them a try.", 
	"They actually look kinda tasty",
}


STRINGS.NAMES.CABBAGE = "Cabbage"
STRINGS.NAMES.CABBAGE_COOKED = "Roasted Cabbage"
STRINGS.NAMES.CABBAGE_SEEDS = "Cabbage Seeds"
STRINGS.NAMES.CABBAGE_PICKLED = "Sauerkraut"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE = {	
	"A guy named Cabbage invented the computer... \nno wait, that was Babbage", 
	"About as large and wise as a man's head",
	"I heard that kids hang out around cabbage patches",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE_COOKED = {	
	"Crunchy and tasty", 
	"So easy to make, just slice and cook", 
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CABBAGE_PICKLED = {	
	"My grandpa puts sauerkraut in his chocolate cakes", 
	"Try substituting sauerkraut for coconut when baking",
	"Also known as liberty cabbage",
}


STRINGS.NAMES.CUCUMBER = "Cucumber"
STRINGS.NAMES.CUCUMBER_COOKED = "Grilled Cucumber"
STRINGS.NAMES.CUCUMBER_SEEDS = "Cucumber Seeds"
STRINGS.NAMES.CUCUMBER_PICKLED = "Pickle"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUCUMBER = {	
	"Looks cumbersome... cucumbersome", 
	"I bet this would make a fine pickle", 
	"Cool as a cucumber",
	"I shall call him Larry",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUCUMBER_COOKED = {	
	"It'll never become a pickle now", 
	"Tastes like grilled water", 
	"Poor Larry",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUCUMBER_PICKLED = {	
	"This is quite a pickle", 
	"Why do gherkins giggle? They're PICKLish!",
	"If only I had a hamburger to put this on",
}


STRINGS.NAMES.ONION = "Onion"
STRINGS.NAMES.ONION_COOKED = "Onion Rings"
STRINGS.NAMES.ONION_SEEDS = "Onion Seeds"
STRINGS.NAMES.ONION_PICKLED = "Pickled Onion"


STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION = {	
	"*Sob* Who's cutting onions?",
	"Ogres are like onions",
	"Onions always make me cry",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION_COOKED = {	
	"If you like it, you should put an onion ring on it",
	"If you hear an onion ring, answer it",
	"I guess this makes me the Lord of the Onion Rings",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION_PICKLED = {	
	"What's round, white, and giggles?\nA tickled onion!",
	"Beautiful and zesty... yum!",
}


STRINGS.NAMES.RADISH = "Radish"
STRINGS.NAMES.RADISH_COOKED = "Roasted Radish"
STRINGS.NAMES.RADISH_SEEDS = "Radish Seeds"
STRINGS.NAMES.RADISH_PICKLED = "Pickled Radish"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH = {	
	"What is small, red, and whispers?\nA hoarse radish!",
	"This veggie is so rad(ish)",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH_COOKED = {	
	"Delicious and healthy",
	"Sweeter and softer than a raw radish",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RADISH_PICKLED = {	
	"Sweet, tangy, and pink",
	"This would make a great garnish"
}




return unpack(prefs)