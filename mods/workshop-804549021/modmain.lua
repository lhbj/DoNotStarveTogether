KnownModIndex = GLOBAL.KnownModIndex

PrefabFiles = 
{
	"range"
}

if GetModConfigData("Time") == "short" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 10
end

if GetModConfigData("Time") == "default" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 30
end

if GetModConfigData("Time") == "long" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 60
end

if GetModConfigData("Time") == "longer" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 240
end

if GetModConfigData("Time") == "longest" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 480
end

if GetModConfigData("Time") == "always" then
	GLOBAL.TUNING.RANGE_CHECK_TIME = 1
end

GLOBAL.TUNING.RANGE_INDICATOR = 1.55

if (KnownModIndex:IsModEnabled("workshop-482119182")) then
	RangeMod = GLOBAL.GetModConfigData("RangeMod", "workshop-482119182")
		if RangeMod == 0.5 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.1
		elseif RangeMod == 0.6 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.2
		elseif RangeMod == 0.7 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.3
		elseif RangeMod == 0.8 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.4
		elseif RangeMod == 0.9 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.50
		elseif RangeMod == 1.1 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.65
		elseif RangeMod == 1.2 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.70
		elseif RangeMod == 1.3 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.78
		elseif RangeMod == 1.4 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.84
		elseif RangeMod == 1.5 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.92
		elseif RangeMod == 1.6 then
			GLOBAL.TUNING.RANGE_INDICATOR = 1.98
		elseif RangeMod == 1.7 then
			GLOBAL.TUNING.RANGE_INDICATOR = 2.03
		elseif RangeMod == 1.8 then
			GLOBAL.TUNING.RANGE_INDICATOR = 2.09
		elseif RangeMod == 1.9 then
			GLOBAL.TUNING.RANGE_INDICATOR = 2.15
		elseif RangeMod == 2.0 then
			GLOBAL.TUNING.RANGE_INDICATOR = 2.2
		end	
end

local function IceFlingOnShow(inst)
	local pos = GLOBAL.Point(inst.Transform:GetWorldPosition())
	local range_indicators_client = TheSim:FindEntities(pos.x,pos.y,pos.z, 2, {"range_indicator_client"})
	if #range_indicators_client < 1 then
		local range = GLOBAL.SpawnPrefab("range_indicator_client")
		range.Transform:SetPosition(pos.x, pos.y, pos.z)
	end
end

function IceFlingOnRemove(inst)
	local pos = GLOBAL.Point(inst.Transform:GetWorldPosition())
	local range_indicators_client = GLOBAL.TheSim:FindEntities(pos.x,pos.y,pos.z, 2, {"range_indicator_client"})
	for i,v in ipairs(range_indicators_client) do
		if v:IsValid() then
			v:Remove()
		end
	end
end

if (KnownModIndex:IsModEnabled("workshop-412291722")) then
	print("Server Version Enabled")
	return
else
	print("Client Version Running")
	local controller = GLOBAL.require "components/playercontroller"
	local old_OnLeftClick = controller.OnLeftClick

		function controller:OnLeftClick(down,...)
			if (not down) and self:UsingMouse() and self:IsEnabled() and not GLOBAL.TheInput:GetHUDEntityUnderMouse() then
				local item = GLOBAL.TheInput:GetWorldEntityUnderMouse()
				if item and item:HasTag("hasemergencymode") and item.prefab == "firesuppressor" then
					IceFlingOnShow(item)
				end
			end
			return old_OnLeftClick(self,down,...)
		end

	function IceFlingPostInit(inst)
		inst:ListenForEvent("onremove", IceFlingOnRemove)
	end

	AddPrefabPostInit("firesuppressor", IceFlingPostInit)
end