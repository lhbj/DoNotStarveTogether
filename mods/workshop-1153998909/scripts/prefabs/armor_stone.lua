local modname = KnownModIndex:GetModActualName("More Armor")
local ARMOR_STONE_BLOCK_VALUE = GetModConfigData("ARMOR_STONE_BLOCK_VALUE", modname)
local ARMOR_STONE_DURABILITY_MULTIPLICATOR = GetModConfigData("ARMOR_STONE_DURABILITY_MULTIPLICATOR", modname)

local assets=
{
    Asset("ANIM", "anim/armor_stone.zip"),
    Asset("ATLAS", "images/inventoryimages/armor_stone.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_stone.tex"),
}

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner)
owner.AnimState:OverrideSymbol("swap_body", "armor_stone", "armor_my_folder")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_stone")
    inst.AnimState:SetBuild("armor_stone")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("wood")

    -- provide compatibility with an armor repair kit mod -> https://steamcommunity.com/sharedfiles/filedetails/?id=1155672829
    inst:AddTag("armorrepairable")
    --
    
    inst.foleysound = "dontstarve/movement/foley/logarmour"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/logarmour"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_stone.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORWOOD * ARMOR_STONE_DURABILITY_MULTIPLICATOR, ARMOR_STONE_BLOCK_VALUE)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab( "common/inventory/armor_stone", fn, assets)
