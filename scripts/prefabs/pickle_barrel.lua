require "prefabutil"
require "recipe"
require "modutil"

local cooking = require("cooking")

local assets=
{
	Asset("ANIM", "anim/pickle_barrel.zip"),
    Asset("ATLAS", "images/inventoryimages/pickle_barrel.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_barrel.tex"),
	Asset("SOUNDPACKAGE", "sound/pickle_barrel.fev"),
	Asset("SOUND", "sound/pickle_barrel_bank.fsb"),
}

local prefabs = {}

--  Break the pickle barrel when it is hammered upon
local function onhammered(inst, worker)
	inst.components.pickler:CalculateLoot()
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end
	
-- 	Define the positions of the slots
local slotpos = {}
for y = 2, 1, -1 do
	for x = 0, 2 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end

local function itemtest(inst, item, slot)
	if item.components.edible ~= nil then
		if item.components.edible.foodtype == "VEGGIE" or item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "GENERIC" then
			return true
		end	
	end
	
	return false
end

local pickle_barrel = 
{
	widget = 
	{
		slotpos = slotpos,
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = Vector3(200,0,0),
		side_align_tip = 100,
		buttoninfo  =
		{
			text = "Pickle",
			position = Vector3(0, -80, 0),
			fn = function(inst)
				inst.components.pickler:StartPickling()
			end,
			
			validfn = function(inst)
				return inst.components.pickler:CanPickle()
			end,
		}

	},
	acceptsstacks = false,
	type = "cooker",
	itemtestfn = itemtest,
}

local widgetbuttoninfo = {
	text = "Pickle",
	position = Vector3(0, -80, 0),
	fn = function(inst)
		inst.components.pickler:StartPickling()
	end,
	
	validfn = function(inst)
		return inst.components.pickler:CanPickle()
	end,
}


-- Randomizes the inspection line upon inspection, based on whether or not the pickle barrel is pickling.
local function setdescription(isPickling)
	if isPickling == true then
		STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL = STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL_PICKLING 
	else
		STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL = STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL_GENERIC
	end
end

local function onopen(inst)
	inst.SoundEmitter:PlaySound("pickle_barrel/pickle_barrel/open", "open")
	
	inst.AnimState:PlayAnimation("open")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("pickle_barrel/pickle_barrel/close", "close")

	inst.AnimState:PlayAnimation("closed")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", false)
end

local function startpicklefn(inst)
	-- Change the pickle barrel descriptions to descriptions that indicate the barrel is currently pickling
	setdescription(true)
	
	-- Slow down the time it takes the food to perish
	inst.components.pickler:SlowPerishing()
	
	inst.SoundEmitter:PlaySound("pickle_barrel/pickle_barrel/pickling", "pickling")
	
	inst.AnimState:PlayAnimation("full")
end

local function donepicklefn(inst)
	-- Change the pickle barrel descriptions back to default
	setdescription(false)

	inst.SoundEmitter:KillSound("pickling")
	
	inst.AnimState:PlayAnimation("closed")
end

local function continuedonefn(inst)
	-- Change the pickle barrel descriptions back to default
	setdescription(false)
	
	inst.AnimState:PlayAnimation("closed")
end

local function continuepicklefn(inst)
	-- Change the pickle barrel descriptions to descriptions that indicate the barrel is currently pickling
	setdescription(true)
	
	-- Slow down the time it takes the food to perish
	inst.components.pickler:SlowPerishing()
	
	inst.AnimState:PlayAnimation("full")
end

local function getstatus(inst)
	-- if inst.components.stewer.cooking and inst.components.stewer:GetTimeToCook() > 15 then
		-- return "COOKING_LONG"
	-- elseif inst.components.stewer.cooking then
		-- return "COOKING_SHORT"
	-- elseif inst.components.stewer.done then
		-- return "DONE"
	-- else
		-- return "EMPTY"
	-- end
	
	return "EMPTY"	-- Temp!
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "pickle_barrel.tex" )
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("pickle_barrel")
    inst.AnimState:SetBuild("pickle_barrel")
    inst.AnimState:PlayAnimation("closed")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("pickler")
    inst.components.pickler.onstartpickling = startpicklefn
    inst.components.pickler.oncontinuepickling = continuepicklefn
	inst.components.pickler.oncontinuedone = continuedonefn
    inst.components.pickler.ondonepickling = donepicklefn
    
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("pickle_barrel", pickle_barrel)
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose


    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus


    -- inst:AddComponent("playerprox")
    -- inst.components.playerprox:SetDist(3,5)
    -- inst.components.playerprox:SetOnPlayerFar(onfar)
	

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)

	--MakeSnowCovered(inst, .01)    
	--inst:ListenForEvent("onbuilt", onbuilt)
    return inst
end

-- Set the pickle barrel description to default values (description changes when pickling)
--setdescription(false)

-- Add recipe for pickle barrel
local crafting_recipe = Recipe("pickle_barrel", {Ingredient("boards", 3), Ingredient("rope", 2)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, "pickle_barrel_placer")
crafting_recipe.atlas = "images/inventoryimages/pickle_barrel.xml"


return Prefab( "common/pickle_barrel", fn, assets, prefabs),
		MakePlacer( "common/pickle_barrel_placer", "pickle_barrel", "pickle_barrel", "closed" ) 
