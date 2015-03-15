GLOBAL.require("map/terrain")

-- Add beets to the world spawn in forests
GLOBAL.terrain.rooms.Clearing.contents.distributeprefabs.beet_planted = .045
GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.beet_planted = .02
GLOBAL.terrain.rooms.Forest.contents.distributeprefabs.beet_planted = .015
GLOBAL.terrain.rooms.BGCrappyForest.contents.distributeprefabs.beet_planted = .03
GLOBAL.terrain.rooms.CrappyForest.contents.distributeprefabs.beet_planted = .03
GLOBAL.terrain.filter.beet_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add onions to the world spawn in forests
GLOBAL.terrain.rooms.Clearing.contents.distributeprefabs.onion_planted = .01
GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.onion_planted = .035
GLOBAL.terrain.rooms.Forest.contents.distributeprefabs.onion_planted = .035
GLOBAL.terrain.rooms.BGCrappyForest.contents.distributeprefabs.onion_planted = .02
GLOBAL.terrain.rooms.CrappyForest.contents.distributeprefabs.onion_planted = .02
GLOBAL.terrain.rooms.SpiderForest.contents.distributeprefabs.onion_planted = .015
GLOBAL.terrain.filter.onion_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add radishes to world spawn in grass areas
GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.radish_planted = .025
GLOBAL.terrain.filter.radish_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add potatoes to world spawn in areas that can have ponds (but not marshes)
GLOBAL.terrain.rooms.BGCrappyForest.contents.distributeprefabs.potato_planted = .01
GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.potato_planted = .02
GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.potato_planted = .02
GLOBAL.terrain.rooms.BGNoise.contents.distributeprefabs.potato_planted = .01
GLOBAL.terrain.filter.potato_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Decrease the spawn rate of carrots in the world spawn to keep balance.
GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.carrot_planted = .035
