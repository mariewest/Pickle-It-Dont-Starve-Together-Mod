-- Our mush_pickled asset files
local assets=
{
    Asset("ANIM", "anim/mush_pickled.zip"),
    Asset("ATLAS", "images/inventoryimages/mush_pickled.xml"),
    Asset("IMAGE", "images/inventoryimages/mush_pickled.tex"),
}

-- Modeled after spoiled food
local function fn(Sim)
	local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mush_pickled")
    inst.AnimState:SetBuild("mush_pickled")
    inst.AnimState:PlayAnimation("idle")
    
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst.entity:SetPristine()

    inst:AddTag("spoiled")
    
    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE * 2
    inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES * 2
    
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mush_pickled"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mush_pickled.xml"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.SPOILED_HEALTH*4
    inst.components.edible.hungervalue = TUNING.SPOILED_HUNGER*2
    inst.components.edible.sanityvalue = -TUNING.SANITY_MED
	inst.components.edible.foodtype = "GENERIC"

	return inst
end

-- Return our prefabbed mush_pickled
return Prefab( "common/inventory/mush_pickled", fn, assets)