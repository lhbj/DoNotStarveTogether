PrefabFiles = {
    "armor_stone",
	"armor_bone"
}

Assets =
{
	Asset("ATLAS", "images/inventoryimages/armor_stone.xml"),
	Asset("ATLAS", "images/inventoryimages/armor_bone.xml"),
}

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH

STRINGS.NAMES.ARMOR_STONE = "Stone Suit"
STRINGS.RECIPE_DESC.ARMOR_STONE = "Add some rocky reinforcement."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_STONE = "The rocks made it more sturdy!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ARMOR_STONE = "Aww, it's not as flamable now!"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ARMOR_STONE = "Wolfgang make armor mighty with rocks!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.ARMOR_STONE = "To prolong the inevitable even more."
STRINGS.CHARACTERS.WX78.DESCRIBE.ARMOR_STONE = "FURTHER UPGRADED ARMOR"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ARMOR_STONE = "The crude log platemail has been reinforced with rocks."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ARMOR_STONE = "It used to fit me well, until I added the rocks."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ARMOR_STONE = "This seems excessive."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ARMOR_STONE = "A borrowed tree vest, reinforced by the earth."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ARMOR_STONE = "It sure can take a beating!"
STRINGS.CHARACTERS.WINONA.DESCRIBE.ARMOR_STONE = "Go ahead and punch me! You'll break your fists!"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.ARMOR_STONE = "You knock on wood, you knock on stone! Hyuyu!"
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.ARMOR_STONE = "Strong Friend Shirt"
STRINGS.CHARACTERS.WARLY.DESCRIBE.ARMOR_STONE = "It's a little less flammable like this."

STRINGS.NAMES.ARMOR_BONE = "Bone Suit"
STRINGS.RECIPE_DESC.ARMOR_BONE = "Superior skeletal sturdiness."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_BONE = "I threw the suit a bone! It must have liked it!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ARMOR_BONE = "It's even less flamable now! Ugh!"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ARMOR_BONE = "Rocks and bones make armor very mighty!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.ARMOR_BONE = "Death now protects me, how ironic."
STRINGS.CHARACTERS.WX78.DESCRIBE.ARMOR_BONE = "ARMOR HAS REACHED MAXIMUM UPGRADE CAPACITY"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ARMOR_BONE = "This crude log and stone platemail has been further upgraded with bones."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ARMOR_BONE = "I would've prefered reinforcing it with more wood."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ARMOR_BONE = "This is hardly my style."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ARMOR_BONE = "The armor of savages!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ARMOR_BONE = "We're as tough as our cave friends now!"
STRINGS.CHARACTERS.WINONA.DESCRIBE.ARMOR_BONE = "Give me all you got, I can take it!"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.ARMOR_BONE = "Mortals have reinforced this armor! But I'd rather souls more."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.ARMOR_BONE = "Sharp Friend Shirt"
STRINGS.CHARACTERS.WARLY.DESCRIBE.ARMOR_BONE = "What a waste of good stock..."

local ARMOR_STONE_INGREDIENT_ROCKS = GetModConfigData("ARMOR_STONE_INGREDIENT_ROCKS")
local ARMOR_STONE_INGREDIENT_ROPE = GetModConfigData("ARMOR_STONE_INGREDIENT_ROPE")

local ARMOR_BONE_INGREDIENT_BONES = GetModConfigData("ARMOR_BONE_INGREDIENT_BONES")
local ARMOR_BONE_INGREDIENT_ROPE = GetModConfigData("ARMOR_BONE_INGREDIENT_ROPE")

local armor_stone = GLOBAL.Ingredient("armor_stone", 1)
armor_stone.atlas = "images/inventoryimages/armor_stone.xml"

AddRecipe(
	"armor_stone", {
		Ingredient("armorwood", 1),
		Ingredient("rope", ARMOR_STONE_INGREDIENT_ROPE),
		Ingredient("rocks", ARMOR_STONE_INGREDIENT_ROCKS)
	},
	RECIPETABS.WAR,
	{
		SCIENCE = 2
	},
	nil,
	nil,
	nil,
	nil,
	nil,
	"images/inventoryimages/armor_stone.xml"
)

AddRecipe(
	"armor_bone", {
		armor_stone,
		Ingredient("rope", ARMOR_BONE_INGREDIENT_ROPE),
		Ingredient("boneshard", ARMOR_BONE_INGREDIENT_BONES)
	},
	RECIPETABS.WAR,
	{
		SCIENCE = 2
	},
	nil,
	nil,
	nil,
	nil,
	nil,
	"images/inventoryimages/armor_bone.xml"
)