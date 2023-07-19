GLOBAL.SetupGemCoreEnv()

AddNaughtinessFor("baby_koalefant_summer", 30)
AddNaughtinessFor("baby_koalefant_winter", 30)

PrefabFiles = {
	"baby_koalefant_summer",
	"baby_koalefant_winter"
}

local STRINGS = GLOBAL.STRINGS

STRINGS.NAMES.BABY_KOALEFANT_SUMMER 									= "Baby Koalefant"
STRINGS.NAMES.BABY_KOALEFANT_SUMMER 									= "Baby Koalefant"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BABY_KOALEFANT_SUMMER				= "Aww. So adorable!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "My new little friend!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "He's young, but it doesn't matter. Death will find him anyway."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "Baby nose meat!"
STRINGS.CHARACTERS.WX78.DESCRIBE.BABY_KOALEFANT_SUMMER 					= "MEDIUM MAMMAL LOCATED."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BABY_KOALEFANT_SUMMER 			= "A young Koalefanta Proboscidea."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "It is so cute that I want to eat it."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "It's a bit surprising that they were able to reproduce."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BABY_KOALEFANT_SUMMER 			= "I must wait until the meat's ripe."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "We should become good friends."

--DST characters
STRINGS.CHARACTERS.WORTOX.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "One kill and you'll face Krampus' will."
STRINGS.CHARACTERS.WINONA.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "You'll taste good once you've matured."
STRINGS.CHARACTERS.WARLY.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "A little longer and it'll make a great dish."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.BABY_KOALEFANT_SUMMER 				= "Bruamp! Bruamp!"

--Insert Warbucks strings??

STRINGS.NAMES.BABY_KOALEFANT_WINTER 									= "Baby Koalefant"
STRINGS.NAMES.BABY_KOALEFANT_WINTER 									= "Baby Koalefant"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BABY_KOALEFANT_WINTER				= "Aww. So adorable!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BABY_KOALEFANT_WINTER 				= "My new little friend!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BABY_KOALEFANT_WINTER 				= "He's young, but it doesn't matter. Death will find him anyway."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BABY_KOALEFANT_WINTER 				= "Baby nose meat!"
STRINGS.CHARACTERS.WX78.DESCRIBE.BABY_KOALEFANT_WINTER 					= "MEDIUM MAMMAL LOCATED."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BABY_KOALEFANT_WINTER 			= "A young Koalefanta Proboscidea."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BABY_KOALEFANT_WINTER 				= "It is so cute that I want to eat it."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BABY_KOALEFANT_WINTER 				= "It's a bit surprising that they were able to reproduce."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BABY_KOALEFANT_WINTER 			= "I must wait until the meat's ripe."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BABY_KOALEFANT_WINTER 				= "We should become good friends."

--DST characters
STRINGS.CHARACTERS.WORTOX.DESCRIBE.BABY_KOALEFANT_WINTER 				= "One kill and you'll face Krampus' will."
STRINGS.CHARACTERS.WINONA.DESCRIBE.BABY_KOALEFANT_WINTER 				= "You'll taste good once you've matured."
STRINGS.CHARACTERS.WARLY.DESCRIBE.BABY_KOALEFANT_WINTER 				= "A little longer and it'll make a great dish."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.BABY_KOALEFANT_WINTER 				= "Bruamp! Bruamp!"


if GLOBAL.STRINGS.CHARACTERS.WALANI then
GLOBAL.STRINGS.CHARACTERS.WALANI.DESCRIBE.BABY_KOALEFANT_SUMMER			= "Stay young, my little friend."
end
if GLOBAL.STRINGS.CHARACTERS.WILBUR then
GLOBAL.STRINGS.CHARACTERS.WILBUR.DESCRIBE.BABY_KOALEFANT_SUMMER 		= "Ooh? Ooae!"
end
if GLOBAL.STRINGS.CHARACTERS.WOODLEGS then
GLOBAL.STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.BABY_KOALEFANT_SUMMER		= "Yer trunk be too small fer warmth!"
end
if GLOBAL.STRINGS.CHARACTERS.WAGSTAFF then
GLOBAL.STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.BABY_KOALEFANT_SUMMER		= "The track maker appears to create offspring."
end
if GLOBAL.STRINGS.CHARACTERS.WHEELER then
GLOBAL.STRINGS.CHARACTERS.WHEELER.DESCRIBE.BABY_KOALEFANT_SUMMER		= "That's a small mystery beast!"
end
if GLOBAL.STRINGS.CHARACTERS.WILBA then
GLOBAL.STRINGS.CHARACTERS.WILBA.DESCRIBE.BABY_KOALEFANT_SUMMER			= "'Tisn't fat enough to eat yet!"
end

if GLOBAL.STRINGS.CHARACTERS.WALANI then
GLOBAL.STRINGS.CHARACTERS.WALANI.DESCRIBE.BABY_KOALEFANT_WINTER 		= "Stay young, my little friend."
end
if GLOBAL.STRINGS.CHARACTERS.WILBUR then
GLOBAL.STRINGS.CHARACTERS.WILBUR.DESCRIBE.BABY_KOALEFANT_WINTER 		= "Ooh? Ooae!"
end
if GLOBAL.STRINGS.CHARACTERS.WOODLEGS then
GLOBAL.STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.BABY_KOALEFANT_WINTER 		= "Yer trunk be too small fer warmth!"
end
if GLOBAL.STRINGS.CHARACTERS.WAGSTAFF then
GLOBAL.STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.BABY_KOALEFANT_WINTER		= "The track maker appears to create offspring."
end
if GLOBAL.STRINGS.CHARACTERS.WHEELER then
GLOBAL.STRINGS.CHARACTERS.WHEELER.DESCRIBE.BABY_KOALEFANT_WINTER		= "That's a small mystery beast!"
end
if GLOBAL.STRINGS.CHARACTERS.WILBA then
GLOBAL.STRINGS.CHARACTERS.WILBA.DESCRIBE.BABY_KOALEFANT_WINTER			= "'Tisn't fat enough to eat yet!"
end


function OnAttackedMod(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
        return dude:HasTag("koalefant") and dude:HasTag("baby") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

function KoalefantSummerPostInit(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("periodicspawner_koalefant")
        inst.components.periodicspawner_koalefant:SetRandomTimes(TUNING.TOTAL_DAY_TIME*4, 0)
		inst.components.periodicspawner_koalefant:Start()
		inst:AddComponent("leader")
		inst:ListenForEvent("attacked", function(inst, data) OnAttackedMod(inst, data) end)
	end
end

AddPrefabPostInit("koalefant_summer", KoalefantSummerPostInit)

function KoalefantWinterPostInit(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("periodicspawner_koalefant")
        inst.components.periodicspawner_koalefant:SetRandomTimes(TUNING.TOTAL_DAY_TIME*4, 0)
		inst.components.periodicspawner_koalefant:Start()
		inst:AddComponent("leader")
		inst:ListenForEvent("attacked", function(inst, data) OnAttackedMod(inst, data) end)
	end
end

AddPrefabPostInit("koalefant_winter", KoalefantWinterPostInit)