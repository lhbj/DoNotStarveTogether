require 'prefabutil'

local assets=
   {
      Asset("ANIM", "anim/swap_ultimatetool.zip"),

      Asset("ATLAS", "images/inventoryimages/ultimatetool.xml"),
      Asset("IMAGE", "images/inventoryimages/ultimatetool.tex"),
   }

local prefabs =
   {
   }

local durability = TUNING.NKIY_ULTIMATETOOL_DURABILITY
local damage = TUNING.NKIY_ULTIMATETOOL_DAMAGE
local hammer_enabled = TUNING.NKIY_ULTIMATETOOL_HAMMER
local shovel_enabled = TUNING.NKIY_ULTIMATETOOL_SHOVEL
local pickaxe_enabled = TUNING.NKIY_ULTIMATETOOL_PICKAXE
local axe_enabled = TUNING.NKIY_ULTIMATETOOL_AXE
local keep_temperature = TUNING.NKIY_KEEP_TEMP
local walkspeed = TUNING.NKIY_WALK_SPEED

local function keep_temp(player, inst)
   if not keep_temperature then
      return
   end

   if player.components.temperature.current < 10 or player.components.temperature.current > 50 then
      player.components.temperature:SetTemperature(36)
      inst.components.finiteuses:Use()
   end
   if inst.components.equippable:IsEquipped() then
      player:DoTaskInTime(1, keep_temp, inst)
   end
end

local function OnEquip(inst, owner)
   owner.AnimState:OverrideSymbol("swap_object", "swap_ultimatetool", "wand")
   owner.AnimState:Show("ARM_carry")
   owner.AnimState:Hide("ARM_normal")
   if keep_temperature then
      owner:DoTaskInTime(1, keep_temp, inst)
   end
end

local function OnUnequip(inst, owner)
   owner.AnimState:Hide("ARM_carry")
   owner.AnimState:Show("ARM_normal")
end

local function fn(Sim)


   local inst = CreateEntity()

   inst.entity:AddTransform()
   inst.entity:AddAnimState()
   inst.entity:AddNetwork()

   MakeInventoryPhysics(inst)

   inst.AnimState:SetBank("swap_ultimatetool")
   inst.AnimState:SetBuild("swap_ultimatetool")
   inst.AnimState:PlayAnimation("idle")

   inst:AddTag("sharp")
   inst:AddTag("mower")

   -----------
   if not TheWorld.ismastersim then
      return inst
   end
   inst.entity:SetPristine()
   -----------


   inst:AddComponent("weapon")
   inst.components.weapon:SetDamage(damage)

   -------

   inst:AddComponent("tool")
   inst:AddComponent("finiteuses")

   if pickaxe_enabled then
      inst.components.tool:SetAction(ACTIONS.MINE)
   end
   if axe_enabled then
      inst.components.tool:SetAction(ACTIONS.CHOP)
   end
   if hammer_enabled then
      inst.components.tool:SetAction(ACTIONS.HAMMER)
   end
   if shovel_enabled then
      inst.components.tool:SetAction(ACTIONS.DIG)
   end

   inst.components.finiteuses:SetConsumption(ACTIONS.PICK, 1)
   inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
   inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
   inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
   inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)

   inst.components.finiteuses:SetMaxUses(durability)
   inst.components.finiteuses:SetUses(durability)
   if(durability > 0)
   then
      inst.components.finiteuses:SetOnFinished(inst.Remove)
   end

   inst:AddComponent("inspectable")


   inst:AddComponent("inventoryitem")
   inst.components.inventoryitem.imagename = "ultimatetool"
   inst.components.inventoryitem.atlasname = "images/inventoryimages/ultimatetool.xml"

   inst:AddComponent("equippable")
   inst.components.equippable:SetOnEquip( OnEquip )
   inst.components.equippable:SetOnUnequip( OnUnequip )
   inst.components.equippable.walkspeedmult = walkspeed

   return inst
end

----------------------------------------------------------------
return  Prefab("common/inventory/ultimatetool", fn, assets, prefabs)
