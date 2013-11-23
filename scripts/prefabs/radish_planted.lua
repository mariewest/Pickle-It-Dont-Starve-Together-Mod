local assets=
{
	Asset("ANIM", "anim/radish.zip"),
}

local prefabs=
{
	"radish",
}

local function onpickedfn(inst)
	inst:Remove()
end


local function fn(Sim)
    --Radish you eat is defined in radish.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("radish")
    inst.AnimState:SetBuild("radish")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    

    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("radish", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

STRINGS.NAMES.RADISH_PLANTED = "Radish"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PLANTED = {	
	"It's a little wild radish",
}

return Prefab( "common/inventory/radish_planted", fn, assets) 
