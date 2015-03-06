

PICKLEIT_WORLD_PLANTS = 
{ 
    beet = "beet",
    onion = "onion",
    radish = "radish",
}

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

        inst:AddComponent("inspectable")
        
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(name, 10)
    	inst.components.pickable.onpickedfn = onpickedfn
        
        inst.components.pickable.quickpick = true

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