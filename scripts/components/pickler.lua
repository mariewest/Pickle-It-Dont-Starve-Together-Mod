local Pickler = Class(function(self, inst)
    self.inst = inst
    self.pickling = false
    self.done = false
    
    -- self.product = nil
    -- self.product_spoilage = nil
    -- self.recipes = nil
    -- self.default_recipe = nil
end)

function Pickler:CanPickle()
	local num = 0
	for k,v in pairs (self.inst.components.container.slots) do
		num = num + 1 
	end
	return num >= 1
end

function Pickler:StartPickling()
	if not self.done and not self.cooking then
		if self.inst.components.container then
		
			-- Turn carrots into instant eggplants in lieu of pickled items and recipes :) 
			for k,v in pairs (self.inst.components.container.slots) do
				if v.prefab == "carrot" then
					local pickled = SpawnPrefab("eggplant")
					if pickled then
						local owner = v.components.inventoryitem and v.components.inventoryitem.owner or nil
						local holder = owner and ( owner.components.inventory or owner.components.container) 
						local slot = holder and holder:GetItemSlot(v)	
						v:Remove()
						holder:GiveItem(pickled, slot)
					end
				end
				
			end
			

		end
		
	end
end

return Pickler