require "tuning"

local assets=
{
    Asset("ANIM", "anim/pickle_sword.zip"),
    Asset("ANIM", "anim/swap_pickle_sword.zip"),
 
    Asset("ATLAS", "images/inventoryimages/pickle_sword.xml"),
    Asset("IMAGE", "images/inventoryimages/pickle_sword.tex"),
}

local prefabs = {}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_pickle_sword", "swap_pickle_sword")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    --local sound = inst.entity:AddSoundEmitter()
	
    MakeInventoryPhysics(inst)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()
     
    inst.AnimState:SetBank("pickle_sword")
    inst.AnimState:SetBuild("pickle_sword")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE * 1.25)
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_SMALL
	
	inst:AddTag("show_spoilage")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "mush_pickled"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES * 1.5)
	inst.components.finiteuses:SetUses(TUNING.SPEAR_USES * 1.5)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("inspectable")
     
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "pickle_sword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pickle_sword.xml"
	
	MakeHauntableLaunchAndPerish(inst)
     
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
 
    return inst
end

-- Add recipe for pickle sword
--local cucumber_pickled = Ingredient( "cucumber_pickled", 1)  
--cucumber_pickled.atlas = "images/inventoryimages/cucumber_pickled.xml"
--local crafting_recipe = Recipe( "pickle_sword", { cucumber_pickled , Ingredient("twigs", 2), Ingredient("rope", 1)} , RECIPETABS.WAR, TECH.SCIENCE_ONE)  
-- Removing sort key because recipe constructor auto-increments; using mod priority instead to ensure unique priority order
-- http://forums.kleientertainment.com/topic/51231-general-mod-recipe-prioritysortkey-issue
--crafting_recipe.sortkey = 3266002	--404983266002
--crafting_recipe.atlas = "images/inventoryimages/pickle_sword.xml"            

return  Prefab("common/inventory/pickle_sword", fn, assets, prefabs)