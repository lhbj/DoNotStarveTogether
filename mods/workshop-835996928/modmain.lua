PrefabFiles =
   {
      "ultimatetool",
   }
Assets = {
   Asset("IMAGE", "images/inventoryimages/ultimatetool.tex"),
   Asset("ATLAS", "images/inventoryimages/ultimatetool.xml")
}

local LANG = {}
local lang_str

LANG.ZH = {
   name = "多功能工具",
   desc = "砍伐,挖掘,采矿,攻击,锤子",
   characters_describe = "诶……这个工具好像很厉害的样子。",
}

LANG.EN = {
   name = "Ultimate Tool",
   desc = "Chop,Mine,Hammeret,Atack,Dig",
   characters_describe = "Wow..Maybe its a crazy tool."
}

local function AutoLang()
   if GLOBAL.LanguageTranslator.defaultlang~=nil then
      lang=string.upper(GLOBAL.LanguageTranslator.defaultlang)
      local tempstrings = L2S[lang]
      if tempstrings~=nil then
	 strings=tempstrings
	 TUNING.DYC_SUPERWALL_STRINGS=strings
	 TUNING.DYC_SUPERWALL_LANGUAGE=lang
	 SL(strings)
      end
   end
end
--
--local function SetLanguage(lang_code)
--  local lang = string.upper(lang_code)
--  local lang_strings = LANG[lang_code]
--  if lang_strings == nil then
--    lang_string = LANG.EN
--  end
--end

GLOBAL.STRINGS.NAMES.ULTIMATETOOL = "Ultimate Tool"
GLOBAL.STRINGS.RECIPE_DESC.ULTIMATETOOL = "Chop,Mine,Hammer,Atack,Dig"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ULTIMATETOOL = "This tool has ultimate power."

GLOBAL.TUNING.NKIY_ULTIMATETOOL_DURABILITY = GetModConfigData("Durability")
GLOBAL.TUNING.NKIY_ULTIMATETOOL_DAMAGE = GetModConfigData("Damage")
GLOBAL.TUNING.NKIY_ULTIMATETOOL_HAMMER = GetModConfigData("Enable Hammer")
GLOBAL.TUNING.NKIY_ULTIMATETOOL_AXE = GetModConfigData("Enable Axe")
GLOBAL.TUNING.NKIY_ULTIMATETOOL_PICKAXE = GetModConfigData("Enable Pickaxe")
GLOBAL.TUNING.NKIY_ULTIMATETOOL_SHOVEL = GetModConfigData("Enable Shovel")
GLOBAL.TUNING.NKIY_RECIPE_ROCK = GetModConfigData("Craftable Rock")
GLOBAL.TUNING.NKIY_ROCK_COUNT = GetModConfigData("Rock Count")

GLOBAL.TUNING.NKIY_KEEP_TEMP = GetModConfigData("Keep Temperature")
GLOBAL.TUNING.NKIY_WALK_SPEED = GetModConfigData("walkspeed")

-- print_r(GLOBAL)

AddRecipe( "ultimatetool",
	   {Ingredient("flint", 7), Ingredient("twigs", 5), Ingredient("rope", 4)} ,
	   GLOBAL.RECIPETABS.TOOLS,
	   GLOBAL.TECH.SCIENCE_ONE,
	   nil,
	   nil,
	   nil,
	   nil,
	   nil,
	   "images/inventoryimages/ultimatetool.xml",
	   "ultimatetool.tex")

if GLOBAL.TUNING.NKIY_RECIPE_ROCK then
   AddRecipe( "rocks",
	      {
		 Ingredient("flint", GLOBAL.TUNING.NKIY_ROCK_COUNT),
		 Ingredient("nitre", GLOBAL.TUNING.NKIY_ROCK_COUNT),
	      },
	      GLOBAL.RECIPETABS.REFINE,
	      GLOBAL.TECH.SCIENCE_ONE,nil,nil,nil,
	      GLOBAL.TUNING.NKIY_ROCK_COUNT*2
   )
end

function deploy_anywhere(inst)
      if not GLOBAL.TheWorld.ismastersim then
	 return inst
      end
      inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.ANYWHERE)
end
AddPrefabPostInit("butterfly", deploy_anywhere)

function get_seeds(prefab)
      if not GLOBAL.TheWorld.ismastersim then
	 return inst
      end
      prefab:AddComponent("edible")
end
-- AddPrefabPostInit("hybrid_banana", get_seeds)
