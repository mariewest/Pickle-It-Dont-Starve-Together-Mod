require "prefabutil"

local cooking = require("cooking")

local assets=
{
	Asset("ANIM", "anim/pickle_barrel.zip"),
}

local prefabs = {}
-- for k,v in pairs(cooking.recipes.pickle_barrel) do
	-- table.insert(prefabs, v.name)
-- end
					
	
-- 	Define the positions of the slots
local slotpos = {}
for y = 2, 1, -1 do
	for x = 0, 2 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end


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

local function itemtest(inst, item, slot)
	if cooking.IsCookingIngredient(item.prefab) then
		return true
	end
end

local function onopen(inst)
	-- inst.AnimState:PlayAnimation("cooking_pre_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
	-- if not inst.components.stewer.cooking then
		-- inst.AnimState:PlayAnimation("idle_empty")
		-- inst.SoundEmitter:KillSound("snd")
	-- end
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
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
	minimap:SetIcon( "pickle_barrel.png" )
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("pickle_barrel")
    inst.AnimState:SetBuild("pickle_barrel")
    inst.AnimState:PlayAnimation("idle")    -- idle_empty

	
    inst:AddComponent("pickler")
    -- inst.components.stewer.onstartcooking = startcookfn
    -- inst.components.stewer.oncontinuecooking = continuecookfn
    -- inst.components.stewer.oncontinuedone = continuedonefn
    -- inst.components.stewer.ondonecooking = donecookfn
    -- inst.components.stewer.onharvest = harvestfn
    
    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(6)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = false

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose


    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus


    -- inst:AddComponent("playerprox")
    -- inst.components.playerprox:SetDist(3,5)
    -- inst.components.playerprox:SetOnPlayerFar(onfar)


    -- inst:AddComponent("lootdropper")
    -- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    -- inst.components.workable:SetWorkLeft(4)
	-- inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)

	--MakeSnowCovered(inst, .01)    
	--inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end

return Prefab( "common/pickle_barrel", fn, assets, prefabs),
		MakePlacer( "common/pickle_barrel_placer", "pickle_barrel", "pickle_barrel", "idle" ) 
