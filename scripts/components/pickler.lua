require "tuning"

local function onpickleperson(self, pickleperson)
    self.inst.replica.pickler:SetPicklePerson(pickleperson)
end

local Pickler = Class(function(self, inst)
    self.inst = inst

    self.targettime = nil
    self.task = nil

	-- Pickling should take 1.5 days to complete
    self.pickle_time = TUNING.TOTAL_DAY_TIME * 1.5

    self.pickleperson = nil
end,
nil,
{
	pickleperson = onpickleperson
})

function Pickler:SetPicklePerson(pickleperson)
	self.pickleperson = pickleperson
end

function Pickler:CanPickle()
	local num = 0
	for k,v in pairs (self.inst.components.container.slots) do
		num = num + 1 
	end
	return num >= 1 and not self.inst.components.pickler:Pickling()
end

-- Pickle all the items
local function pickleallitems(inst)
	for k,v in pairs (inst.components.container.slots) do
	
		local result = nil
		
		if pickleit_Recipes[v.prefab] ~= nil then
			if v.prefab == "cucumber" then
				local rnd = math.random() * 100	
				-- 2% chance of spawning a golden pickle
				if rnd <= 2 then
					result = SpawnPrefab("cucumber_golden_pickled")
				else
					result = SpawnPrefab(pickleit_Recipes[v.prefab])
				end
			else
				result = SpawnPrefab(pickleit_Recipes[v.prefab])
			end
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
	inst.components.pickler:Pickle()
end

function Pickler:Pickle()
	self:StopPickling()

	pickleallitems(self.inst)

	if self.ondonepickling then
		self.ondonepickling(self.inst)
	end
end

function Pickler:StartPickling( time )
	self:StopPickling()
		
	if self.inst.components.container then
		if self.inst.components.container:IsOpen() then
			self.inst.components.container:Close()
		end
		self.inst.components.container.canbeopened = false
	end
	
	-- determine pickling completion time
	local pickle_time = time or self.pickle_time
	self.targettime = GetTime() + pickle_time
	self.task = self.inst:DoTaskInTime(pickle_time, dopickling, "pickle")
		
	-- if this function is called with time set, then its assumed that we are continuing pickling
	if not time and self.onstartpickling then
		self.onstartpickling(self.inst)
	elseif time and self.oncontinuepickling then
		self.oncontinuepickling(self.inst)
	end
end

function Pickler:StopPickling()
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	self.targettime = nil

	if self.inst.components.container then
		self.inst.components.container.canbeopened = true
	end
end

function Pickler:Pickling()
	return self.targettime ~= nil
end

function Pickler:TimeLeft()
	return self:Pickling() and (self.targettime - GetTime()) or 0
end

function Pickler:LongUpdate( dt )
	if(self:Pickling()) then
		self:StartPickling( self:TimeLeft() - dt )
	end
end

function Pickler:OnSave()
    if self:Pickling() then
		local data = {}
		local timeleft = self:TimeLeft()
		if timeleft > 0 then
			data.time = timeleft
		end
		return data
    end
end

function Pickler:OnLoad(data)
    if data then
		local time = data.time or 1
		self:StartPickling( time )
    end
end

-- Determine which pickled loot to drop when the pickle barrel is destroyed
function Pickler:CalculateLoot()
	local loot = {}
	
	if self:Pickling() then
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

-- Slow the perish rate of food in the pickle barrel when it starts pickling
function Pickler:SlowPerishing()
	if self:Pickling() then
		for k,v in pairs (self.inst.components.container.slots) do	
			-- Stop the item from perishing as long as it isn't already spoiled
			if v.components.perishable and not v.components.perishable:IsSpoiled() then
				-- Make the items 100% fresh (because StopPerishing() wasn't working...?)
				v.components.perishable:SetPercent(1)
			end	
		end
	end
end

function Pickler:GetDebugString()
	local str = ""
	if self:Pickling() then str = str.." pickling, time left="..self:TimeLeft()
	else str = str.." not pickling" end
	return str
end

return Pickler