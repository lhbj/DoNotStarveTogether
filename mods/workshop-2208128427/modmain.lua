local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3

Assets = {
	Asset("ATLAS", "images/inventoryimages/loot_pump.xml"),
    Asset( "ATLAS", "minimap/loot_pump.xml" ),
}

PrefabFiles =
{
	"loot_pump",
}


                        

GLOBAL.STRINGS.NAMES.LOOT_PUMP = "Loot Pump"
GLOBAL.STRINGS.RECIPE_DESC.LOOT_PUMP = "Throw items in containers."

AddMinimapAtlas("minimap/loot_pump.xml")


AddRecipe("loot_pump",
{
GLOBAL.Ingredient("gears", 1),
GLOBAL.Ingredient("minifan", 1),
GLOBAL.Ingredient("transistor", 2)
},
GLOBAL.RECIPETABS.SCIENCE,
GLOBAL.TECH.SCIENCE_TWO,
"loot_pump_placer", -- placer
1.5, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/loot_pump.xml", -- atlas
"loot_pump.tex")


-- I know that using from global variables is a terrible habit, but I don't know how to make a post init "MakePlacer"
GLOBAL.global("LOOT_PUMP_SCALE")
GLOBAL.global("LOOT_PUMP_SPEED")
GLOBAL.global("LOOT_PUMP_SOUND")
GLOBAL.global("LOOT_PUMP_TWOZN")
GLOBAL.global("LOOT_PUMP_EQUIP")


GLOBAL.LOOT_PUMP_SCALE=GetModConfigData("LOOT_PUMP_SCALE")
GLOBAL.LOOT_PUMP_SPEED=GetModConfigData("LOOT_PUMP_SPEED")
GLOBAL.LOOT_PUMP_SOUND=GetModConfigData("LOOT_PUMP_SOUND")
GLOBAL.LOOT_PUMP_TWOZN=GetModConfigData("LOOT_PUMP_TWOZN")
GLOBAL.LOOT_PUMP_EQUIP=GetModConfigData("LOOT_PUMP_EQUIP")

local loot_through_walls=GetModConfigData("LOOT_PUMP_WALLS")

AddPrefabPostInit("loot_pump", function(inst)
    inst.loot_through_walls=loot_through_walls
end)


