local assets=
{
	Asset("ANIM", "anim/onion.zip"),
}

local prefabs=
{
	"onion",
}

local function onpickedfn(inst)
	inst:Remove()
end


local function fn(Sim)
    --Onion you eat is defined in onion.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("onion")
    inst.AnimState:SetBuild("onion")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    

    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("onion", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

STRINGS.NAMES.ONION_PLANTED = "Onion"

-- Randomizes the inspection line upon inspection.
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ONION_PLANTED = {	
	"Look, a wild onion!",
}

return Prefab( "common/inventory/onion_planted", fn, assets) 
