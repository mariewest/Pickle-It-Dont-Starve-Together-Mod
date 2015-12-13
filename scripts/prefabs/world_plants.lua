PICKLEIT_WORLD_PLANTS =
{
    beet = "beet",
    onion = "onion",
	potato = "potato",
    radish = "radish",
}

local function dig_up_potato(inst, chopper)
	-- Figure out how many potatoes to spawn (random 1-4 potatoes)
	local rnd = math.random() * 100
	local qty

	if rnd <= 10 then
		qty = 4		-- 10% chance of 4 potatoes
	elseif rnd <= 50 then
		qty = 3		-- 40% chance of 3 potatoes
	elseif rnd <= 90 then
		qty = 2		-- 40% chance of 2 potatoes
	else
		qty = 1		-- 10% chance of 1 potato
	end

	-- Spawn the potatoes
	for i=1,qty do
		inst.components.lootdropper:SpawnLootPrefab("potato")
	end
    inst:Remove()    
end


local function MakeWorldPlant(name)
    local assets=
    {
    	Asset("ANIM", "anim/"..name..".zip"),
    }

    local prefabs=
    {
    	name,
    }

    local function onpickedfn(inst)
    	inst:Remove()
    end

    local function fn(Sim)
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
    	inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("planted")
        inst.AnimState:SetRayTestOnBB(true);

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

        inst:AddComponent("inspectable")

		if name == "potato" then
			-- Potatoes are not pickable; you use a shovel to get them
			inst:AddComponent("lootdropper")
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_potato)
			inst.components.workable:SetWorkLeft(1)
		else
			-- All other veggies are pickable
			inst:AddComponent("pickable")
			inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
			inst.components.pickable:SetUp(name, 10)
			inst.components.pickable.onpickedfn = onpickedfn
			inst.components.pickable.quickpick = true
		end

    	MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        return inst
    end

    return Prefab( "common/inventory/"..name.."_planted", fn, assets)
end

local prefs = {}
for plant_name, name in pairs(PICKLEIT_WORLD_PLANTS) do
    local world_plant = MakeWorldPlant(plant_name, true)
    table.insert(prefs, world_plant)
end

return unpack(prefs)
