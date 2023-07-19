--[[
    
***************************************************************
Created by: zyjwsg
Date: 2016.4.4
Description: 金箍棒

update 1: 解决客机各种异常
***************************************************************

]]

PrefabFiles = 
{
	"jgb",
}

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe

TUNING.JGB_DAMAGE = GetModConfigData("jgbdamage")
TUNING.JGB_ATTAK_RANGE = GetModConfigData("jgbattackrange")
TUNING.JGB_MOVE_SPEED_MUL = GetModConfigData("jgbmovespeedmul")
TUNING.JGB_LIGHT_RADIUS = GetModConfigData("jgblightradius")
TUNING.JGB_LIGHT_INTENSITY = GetModConfigData("jgblightintensity")
TUNING.JGB_CAN_USE_AS_HAMMER = GetModConfigData("jgbcanuseashammer")
TUNING.JGB_CAN_USE_AS_SHOVEL = GetModConfigData("jgbcanuseasshovel")
TUNING.JGB_FINITE_USES = GetModConfigData("jgbfiniteuses")

STRINGS.NAMES.JGB = "GOLDEN CUDGEL"
STRINGS.RECIPE_DESC.JGB = "JIN GU BANG!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.JGB = "A cool weapon!"

AddRecipe("jgb", {Ingredient("rocks", 20),Ingredient("goldnugget", 15)}, RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/jgb.xml", "jgb.tex" )