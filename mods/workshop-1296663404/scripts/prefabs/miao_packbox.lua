
local assets =
{
	Asset("ANIM", "anim/miao_packbox.zip"),
	Asset("ANIM", "anim/miao_packbox_full.zip"),
	Asset("ATLAS", "images/inventoryimages/miao_packbox.xml"),
	Asset("IMAGE", "images/inventoryimages/miao_packbox.tex"),
	Asset("ATLAS", "images/inventoryimages/miao_packbox_full.xml"),
	Asset("IMAGE", "images/inventoryimages/miao_packbox_full.tex"),
}
local function ondeploy(inst, pt, deployer)
	if inst.components.miaopacker then
		inst.components.miaopacker:Unpack(pt)
		inst:Remove()
		if deployer and deployer.components.inventory then
			local miao_packbox =SpawnPrefab("miao_packbox")
			deployer.components.inventory:GiveItem(miao_packbox)
		end
	end
end	

local function get_name(inst)
	return #inst._name:value() > 0 and "Packaged "..inst._name:value() or STRINGS.MIAODABAO
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("miao_packbox")
    inst.AnimState:SetBuild("miao_packbox")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("miao_packbox")
	
    inst.entity:SetPristine()

	if not TheWorld.ismastersim  then
		return inst
    end
	
    inst:AddComponent("inspectable")
    inst:AddComponent("miao_packbox")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "miao_packbox"	
    inst.components.inventoryitem.atlasname = "images/inventoryimages/miao_packbox.xml"
	
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    return inst
end

local function fullfn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("miao_packbox_full")
    inst.AnimState:SetBuild("miao_packbox_full")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("miao_packbox_full")	
	inst:AddTag("nonpackable")
	inst._name = net_string(inst.GUID, "miaopackfull._name")
	inst.displaynamefn = get_name
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("inspectable")

	inst:AddComponent("miaopacker")	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/miao_packbox_full.xml"

	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
	MakeHauntableLaunchAndSmash(inst)
	
    return inst
end	
local function buildfullfn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("miao_packbox_full")
    inst.AnimState:SetBuild("miao_packbox_full")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("miao_packbox_full")
	inst:AddTag("nonpackable")
	inst._name = net_string(inst.GUID, "miaopackbuild._name")
	inst.displaynamefn = get_name
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("inspectable")

	inst:AddComponent("miaopacker")	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "miao_packbox_full"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/miao_packbox_full.xml"

	MakeHauntableLaunchAndSmash(inst)

	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    return inst
end	
	
return Prefab("miao_packbox", fn, assets),
	Prefab("miao_packbox_full", fullfn, assets),
	Prefab("miao_packbox_buildfull", buildfullfn, assets),
	MakePlacer("miao_packbox_full_placer", "miao_packbox_full", "miao_packbox_full", "place"),
	MakePlacer("miao_packbox_buildfull_placer", "miao_packbox_full", "miao_packbox_full", "place")
