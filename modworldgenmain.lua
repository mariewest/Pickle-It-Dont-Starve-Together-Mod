GLOBAL.require("map/terrain")

-- Add beets to the world spawn in forests
GLOBAL.terrain.rooms.Clearing.contents.distributeprefabs.beet_planted = .4
GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.beet_planted = .2
GLOBAL.terrain.rooms.Forest.contents.distributeprefabs.beet_planted = .2
GLOBAL.terrain.rooms.BGCrappyForest.contents.distributeprefabs.beet_planted = .3
GLOBAL.terrain.rooms.CrappyForest.contents.distributeprefabs.beet_planted = .3
GLOBAL.terrain.filter.beet_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add onions to the world spawn in forests
GLOBAL.terrain.rooms.Clearing.contents.distributeprefabs.onion_planted = .1
GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.onion_planted = .3
GLOBAL.terrain.rooms.Forest.contents.distributeprefabs.onion_planted = .3
GLOBAL.terrain.rooms.BGCrappyForest.contents.distributeprefabs.onion_planted = .2
GLOBAL.terrain.rooms.CrappyForest.contents.distributeprefabs.onion_planted = .2
GLOBAL.terrain.rooms.SpiderForest.contents.distributeprefabs.onion_planted = .1
GLOBAL.terrain.filter.onion_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Add radishes to world spawn in grass areas
GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.radish_planted = .02
GLOBAL.terrain.filter.radish_planted = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROCKY, GLOBAL.GROUND.MARSH}

-- Decrease the spawn rate of carrots in the world spawn to keep balance.
GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.carrot_planted = .04
