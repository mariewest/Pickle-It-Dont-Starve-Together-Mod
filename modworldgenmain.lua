GLOBAL.require("map/terrain")

-- Add beets to the world spawn in forests
AddRoomPreInit("Clearing", function(room) room.contents.distributeprefabs.beet_planted = 0.045 end)
AddRoomPreInit("BGForest", function(room) room.contents.distributeprefabs.beet_planted = 0.02 end)
AddRoomPreInit("Forest", function(room) room.contents.distributeprefabs.beet_planted = 0.015 end)
AddRoomPreInit("CrappyForest", function(room) room.contents.distributeprefabs.beet_planted = 0.03 end)
AddRoomPreInit("BGCrappyForest", function(room) room.contents.distributeprefabs.beet_planted = 0.03 end)
GLOBAL.terrain.filter.beet_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add onions to the world spawn in forests
AddRoomPreInit("Clearing", function(room) room.contents.distributeprefabs.onion_planted = 0.01 end)
AddRoomPreInit("BGForest", function(room) room.contents.distributeprefabs.onion_planted = 0.035 end)
AddRoomPreInit("Forest", function(room) room.contents.distributeprefabs.onion_planted = 0.035 end)
AddRoomPreInit("BGCrappyForest", function(room) room.contents.distributeprefabs.onion_planted = 0.02 end)
AddRoomPreInit("CrappyForest", function(room) room.contents.distributeprefabs.onion_planted = 0.02 end)
AddRoomPreInit("SpiderForest", function(room) room.contents.distributeprefabs.onion_planted = 0.015 end)
GLOBAL.terrain.filter.onion_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add radishes to world spawn in grass areas
AddRoomPreInit("BGGrass", function(room) room.contents.distributeprefabs.radish_planted = 0.025 end)
GLOBAL.terrain.filter.radish_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add potatoes to world spawn in areas that can have ponds (but not marshes)
AddRoomPreInit("BGCrappyForest", function(room) room.contents.distributeprefabs.potato_planted = 0.01 end)
AddRoomPreInit("BGForest", function(room) room.contents.distributeprefabs.potato_planted = 0.02 end)
AddRoomPreInit("BGGrass", function(room) room.contents.distributeprefabs.potato_planted = 0.02 end)
AddRoomPreInit("BGNoise", function(room) room.contents.distributeprefabs.potato_planted = 0.01 end)
GLOBAL.terrain.filter.potato_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Decrease the spawn rate of carrots in the world spawn to keep balance.
AddRoomPreInit("BGGrass", function(room) room.contents.distributeprefabs.carrot_planted = 0.035 end)
