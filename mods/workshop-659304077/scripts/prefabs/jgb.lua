local assets =
{
    Asset("ANIM", "anim/jgb.zip"),
    Asset("ANIM", "anim/swap_jgb.zip"),

    Asset("ATLAS", "images/inventoryimages/jgb.xml"),
}


local function jgblightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(TUNING.JGB_LIGHT_INTENSITY)
    inst.Light:SetRadius(TUNING.JGB_LIGHT_RADIUS)
    inst.Light:Enable(true)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(200/255, 100/255, 170/255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end


local function lighton(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("jgblight")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
end


local function lightoff(inst)
    if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
end

local function onjgbremove(inst)
    SpawnPrefab("moonrocknugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_jgb", "swap_jgb")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    lighton(inst, owner)
end


local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    lightoff(inst, owner)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.Light:SetIntensity(TUNING.JGB_LIGHT_INTENSITY)
    inst.Light:SetRadius(TUNING.JGB_LIGHT_RADIUS)
    inst.Light:Enable(true)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(200/255, 100/255, 170/255)

    inst.AnimState:SetBank("jgb")
    inst.AnimState:SetBuild("jgb")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE, 2) --可挖矿
    inst.components.tool:SetAction(ACTIONS.CHOP, 4) --可砍树

    if TUNING.JGB_CAN_USE_AS_SHOVEL then
        inst.components.tool:SetAction(ACTIONS.DIG)  --可挖..
    end
    --inst.components.tool:SetAction(ACTIONS.NET)  --可捕虫
    if TUNING.JGB_CAN_USE_AS_HAMMER then
        inst.components.tool:SetAction(ACTIONS.HAMMER) --可重击
    end
    --inst:AddInherentAction(ACTIONS.TERRAFORM)    --可铲草

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.JGB_DAMAGE)
    inst.components.weapon:SetRange(TUNING.JGB_ATTAK_RANGE, TUNING.JGB_ATTAK_RANGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/jgb.xml"


    if TUNING.JGB_FINITE_USES > 0 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.JGB_FINITE_USES)
        inst.components.finiteuses:SetUses(TUNING.JGB_FINITE_USES)
        inst.components.finiteuses:SetOnFinished(onjgbremove)
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)
    end
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.JGB_MOVE_SPEED_MUL

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/jgb", fn, assets),
       Prefab("jgblight", jgblightfn)