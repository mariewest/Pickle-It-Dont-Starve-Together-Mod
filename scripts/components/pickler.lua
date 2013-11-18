require "tuning"

local Pickler = Class(function(self, inst)
    self.inst = inst
    self.pickling = false
    
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

-- Pickle all the items
local function pickleallitems(inst)
	for k,v in pairs (inst.components.container.slots) do
	
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
end

local function dopickling(inst)
	pickleallitems(inst)
	
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
			
			self.inst.components.container:Close()
			self.inst.components.container.canbeopened = false
			
			if self.onstartpickling then
				self.onstartpickling(self.inst)
			end
			
			-- Pickling should take 3 days to complete
			local pickle_time = TUNING.TOTAL_DAY_TIME * 3
			self.targettime = GetTime() + pickle_time
			self.task = self.inst:DoTaskInTime(pickle_time, dopickling, "pickle")

		end
		
	end
end

function Pickler:OnSave()
    
    if self.pickling then
		local data = {}
		data.pickling = true
		local time = GetTime()
		if self.targettime and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
    end
end

function Pickler:OnLoad(data)

    if data.pickling then
		self.product = data.product
		if self.oncontinuepickling then
			local time = data.time or 1
			self.oncontinuepickling(self.inst)
			self.pickling = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dopickling, "pickle")
			
			if self.inst.components.container then		
				self.inst.components.container.canbeopened = false
			end
			
		end
    end
end

-- Determine which pickled loot to drop
function Pickler:CalculateLoot()
	local loot = {}
	
	if self.pickling then
		for k,v in pairs (self.inst.components.container.slots) do			
			
			local rnd = math.random() * 100	
			
			if rnd >= 50 then
				-- 50% chance of dropping pickled mush
				table.insert(loot, "mush_pickled")
				
			elseif rnd >= 5 then
				-- 45% chance of dropping original item
				table.insert(loot, v.prefab)
				
			else
				-- 5% chance of dropping pickled item
				local result = "mush_pickled"
			
				if pickleit_Recipes[v.prefab] ~= nil then
					result = pickleit_Recipes[v.prefab]
				end
				
				table.insert(loot, result)
			end

		end
	else
		self.inst.components.container:DropEverything()
	end
	
	self.inst.components.lootdropper:SetLoot(loot)
end

return Pickler