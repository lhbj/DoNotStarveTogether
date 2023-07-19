GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {
	"miao_packbox", 
	"miao_packbox_fx", 
}

Assets = {	

}

STRINGS.NAMES.MIAO_PACKBOX = "Super PackBox"
STRINGS.RECIPE_DESC.MIAO_PACKBOX = "Pack!Pack!Pack!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAO_PACKBOX = "Can it pack the whole world?"

STRINGS.MIAODABAO = "Packaged objects"
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MIAOPACK={WUFA = "I can't pack it!", USEING = "It's busy"}
TUNING.ZHIZUOSHULIANG = GetModConfigData("CAOSHULIANG") or  6
AddRecipe("miao_packbox",{Ingredient("waxpaper",TUNING.ZHIZUOSHULIANG),Ingredient("rope", 3),Ingredient("purplegem", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, nil,
"images/inventoryimages/miao_packbox.xml", 
"miao_packbox.tex")
-----pack
local MIAOPACK = GLOBAL.Action({priority = 99})
MIAOPACK.id = "MIAOPACK"
MIAOPACK.str = "Pack"
MIAOPACK.fn = function(act)
	local target = act.target	
	local invobject = act.invobject
	local doer = act.doer
	if  target ~= nil then
		local targetpos = target:GetPosition()
		local package = GLOBAL.SpawnPrefab("miao_packbox_full")
    	if package and package.components.miaopacker then
			if 	not package.components.miaopacker:CanPack(target) then
				package:Remove()
				return false, "WUFA"
			end
			if target.components.teleporter ~= nil and target.components.teleporter:IsBusy() then
				package:Remove()
				return false, "USEING"			
			end
			package.components.miaopacker:Pack(target)
			package.Transform:SetPosition( targetpos:Get() )
			if invobject ~= nil then
				invobject:Remove()
			end
			if doer and doer.SoundEmitter then
				doer.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
			end
			return true
		end		
	end  			
end
AddAction(MIAOPACK) 
AddComponentAction("USEITEM", "miao_packbox" , function(inst, doer, target, actions) 
	if inst:HasTag("miao_packbox") and	not target:HasTag("player")then
		table.insert(actions, GLOBAL.ACTIONS.MIAOPACK)
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MIAOPACK, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MIAOPACK, "dolongaction"))
