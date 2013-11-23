local assets=
{
	Asset("ANIM", "anim/beet.zip"),
}

local prefabs=
{
	"beet",
}

local function onpickedfn(inst)
	inst:Remove()
end


local function fn(Sim)
    --Beet you eat is defined in beet.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("beet")
    inst.AnimState:SetBuild("beet")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    

    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("beet", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

STRINGS.NAMES.BEET_PLANTED = "Beet"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PLANTED = {	
	"Looks like a beet",
}

return Prefab( "common/inventory/beet_planted", fn, assets) 
