require "tuning"

local Pickler = Class(function(self, inst)
    self.inst = inst
    self.pickling = false
    self.done = false
end)

function Pickler:CanPickle()
	local num = 0
	for k,v in pairs (self.inst.components.container.slots) do
		num = num + 1 
	end
	return num >= 1
end

local function dopickling(inst)
	inst.components.pickler.task = nil
	
	if inst.components.pickler.ondonepickling then
		inst.components.pickler.ondonepickling(inst)
	end
	
	inst.components.pickler.pickling = false
	
	inst.components.container.canbeopened = true
end

function Pickler:StartPickling()
	if not self.pickling then
		if self.inst.components.container then
		
			self.pickling = true
			
			if self.onstartpickling then
				self.onstartpickling(self.inst)
			end
		
			-- Pickle all the items
			for k,v in pairs (self.inst.components.container.slots) do
			
				local result = nil
				
				if pickleit_Recipes[v.prefab] ~= nil then
					result = SpawnPrefab(pickleit_Recipes[v.prefab])
				else
					result = SpawnPrefab("mush_pickled")
				end
				
				if result then
					local owner = v.components.inventoryitem and v.components.inventoryitem.owner or nil
					local holder = owner and (owner.components.inventory or owner.components.container) 
					local slot = holder and holder:GetItemSlot(v)
					v:Remove()
					holder:GiveItem(result, slot)
				end
			end
			
			-- Pickling should take 5 days to complete
			local pickle_time = TUNING.TOTAL_DAY_TIME * 0.03	-- TEMP! Temporarily reduced the time for testing purposes!
			self.targettime = GetTime() + pickle_time
			self.task = self.inst:DoTaskInTime(pickle_time, dopickling, "pickle")	-- TEMP! 3rd parameter??

			self.inst.components.container:Close()
			self.inst.components.container.canbeopened = false

		end
		
	end
end

return Pickler