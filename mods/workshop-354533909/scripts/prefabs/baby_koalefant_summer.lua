local assets=
{
    Asset("ANIM", "anim/baby_koalefant_summer.zip"),
    Asset("ANIM", "anim/koalefant_basic.zip"),
    Asset("ANIM", "anim/koalefant_actions.zip"),
	Asset("SOUND", "sound/koalefant.fsb"),
}

local prefabs =
{
    "meat",
    "smallmeat",
}

local babyloot = {"smallmeat","smallmeat","smallmeat", "smallmeat"}
local toddlerloot = {"smallmeat","smallmeat","smallmeat","smallmeat", "smallmeat", "smallmeat"}
local teenloot = {"meat","meat","meat", "meat", "smallmeat", "smallmeat", "smallmeat", "smallmeat"}




local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("koalefant") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function FollowKoalefant(inst)
    local nearest = FindEntity(inst, 100, function(guy)
        return guy:HasTag("koalefant") and not guy:HasTag("baby") and guy.components.leader and guy.components.leader:CountFollowers() < 1
    end)
	if nearest and nearest.components.leader then
		nearest.components.leader:AddFollower(inst)
	end
end

local function Grow(inst)
            inst.components.growable:StartGrowing()
            inst.components.growable:SetStage(inst.components.growable:GetNextStage() )
    end


local function GetGrowTime()
    return GetRandomWithVariance(TUNING.BABYBEEFALO_GROW_TIME.base*5, TUNING.BABYBEEFALO_GROW_TIME.random)
end

local function SetBaby(inst)
	local scale = 0.5
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(babyloot)
end

local function SetToddler(inst)
	local scale = 0.7
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(toddlerloot)
end

local function SetTeen(inst)
	local scale = 0.9
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(teenloot)
end

local function SetFullyGrown(inst)
    local grown = SpawnPrefab("koalefant_summer")
    grown.Transform:SetPosition(inst.Transform:GetWorldPosition() )
    grown.Transform:SetRotation(inst.Transform:GetRotation() )
    inst:Remove()
end

local growth_stages =
{
    {name="baby", time = GetGrowTime, fn = SetBaby},
    {name="toddler", time = GetGrowTime, fn = SetToddler, growfn = Grow},
    {name="teen", time = GetGrowTime, fn = SetTeen, growfn = Grow},
    {name="grown", time = GetGrowTime, fn = SetFullyGrown, growfn = Grow},
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 100, .75)
	
	inst.DynamicShadow:SetSize( 2.5, 1.25 )
---	inst.Transform:SetFourFaced()
    inst.Transform:SetSixFaced()
	inst.Transform:SetScale(0.5, 0.5, 0.5)
    
	inst:AddTag("notraptrigger")
    inst:AddTag("baby")
	inst:AddTag("animal")
	inst:AddTag("koalefant")
    
    inst.AnimState:SetBank("koalefant")
    inst.AnimState:SetBuild("baby_koalefant_summer")
    inst.AnimState:PlayAnimation("idle_loop", true)
    
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()
	
    inst:AddComponent("eater")
   --- inst.components.eater:SetVegetarian()
    ---inst.components.eater.foodprefs = { "VEGGIE", "SEEDS", "GENERIC" }
	inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
     
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BABYBEEFALO_HEALTH)

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "koalefantherd"
    inst:AddComponent("follower")
    inst.components.follower.canaccepttarget = true

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(80, 110)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()
    
    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable.growonly = true
    inst.components.growable:SetStage(1)
    inst.components.growable:StartGrowing()

    inst:DoTaskInTime(1, FollowKoalefant)

	MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")
	
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 9
    
    MakeHauntablePanic(inst)
    
    inst:DoTaskInTime(1, FollowKoalefant)
	
    local brain = require "brains/baby_koalefantbrain"
    inst:SetBrain(brain)

    inst:SetStateGraph("SGkoalefant")

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab( "common/monsters/baby_koalefant_summer", fn, assets, prefabs) 
