-- Debugging & testing helper function

function c_pickleit_count_world_veg()
	local find_items = {
		"potato_planted", 
		"radish_planted", 
		"beet_planted", 
		"onion_planted",
		"carrot_planted",
	}
	local found_counts = {0,0,0,0,0}

	-- Find all of our planted world entities and count them
	local ents = TheSim:FindEntities(0, 0, 0, 9001)
	for i, v in ipairs(ents) do
		for j, w in ipairs(find_items) do
			if v.prefab == w then
				found_counts[j] = found_counts[j] + 1
			end
		end
	end

	-- Output the found counts
	for i, v in ipairs(found_counts) do
		print(find_items[i].." = "..v)
	end
end

function c_pickleit_spawn_foods()
	local our_foods = {
		"beet","beet_cooked","beet_pickled", 
		"cabbage","cabbage_cooked","cabbage_pickled",
		"onion","onion_cooked","onion_pickled",

		"radish","radish_cooked","radish_pickled",
		"cucumber","cucumber_cooked","cucumber_pickled","cucumber_golden_pickled",
		"potato", "potato_cooked",

		"pigs_foot","pigs_foot_cooked","pigs_foot_pickled","pigs_foot_dried",
		"berries_pickled",
		"carrot_pickled",
		"corn_pickled",
		"egg_pickled",
		"eggplant_pickled",

		"fish_pickled",
		"mushroom_pickled",
		"pumpkin_pickled",
		"mush_pickled",
		"beet_seeds","cabbage_seeds","cucumber_seeds","onion_seeds","radish_seeds",
	}

	local num_foods = table.getn(our_foods)
	print("FOOD COUNT: "..num_foods)

	local icebox = nil
	local icebox_old = nil
	local index = 1
	while index < num_foods do
		if icebox == nil or icebox.components.container:IsFull() then
			icebox_old = icebox
			icebox = DebugSpawn("icebox")
			if icebox_old ~= nil then
				local x,y,z = icebox_old.Transform:GetWorldPosition()
				icebox.Transform:SetPosition(x+1.5, y, z-1.5)
			end
		end

		local item = DebugSpawn(our_foods[index])
		item.components.stackable:SetStackSize(20)

		icebox.components.container:GiveItem(item)

		--print("Added "..our_foods[index].." to icebox")

		index = index + 1
	end

	local planted_veggies = { "beet_planted","onion_planted","potato_planted","radish_planted" }

	local cnt = 2
	for k,v in pairs(planted_veggies) do
		local plant = DebugSpawn(v)
		if icebox_old ~= nil then
			local x,y,z = icebox_old.Transform:GetWorldPosition()
			plant.Transform:SetPosition(x+3+cnt, y, z+cnt)
			cnt = cnt + 2
		end
	end


end