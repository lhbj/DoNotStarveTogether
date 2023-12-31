local function SendCommand(fnstr)
	local x, _, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
	local is_valid_time_to_use_remote = TheNet:GetIsClient() and TheNet:GetIsServerAdmin()
	if is_valid_time_to_use_remote then
		TheNet:SendRemoteExecute(fnstr, x, z)
	else
		ExecuteConsoleCommand(fnstr)
	end
end

local function GetCharacter()
	return "UserToPlayer('"..TOOMANYITEMS.CHARACTER_USERID.."')"
end

local function GetDomesticateStr(tendencytype, saddle)
	local str1 = "local player = %s local x,y,z = player.Transform:GetWorldPosition() local beef = c_spawn('beefalo') beef.components.domesticatable:DeltaDomestication(1) beef.components.domesticatable:DeltaObedience(1) beef.components.domesticatable:DeltaTendency("
	local str2 = ", 1) beef:SetTendency() beef.components.domesticatable:BecomeDomesticated() beef.components.hunger:SetPercent(0.5) beef.components.rideable:SetSaddle(nil, SpawnPrefab('"
	local str3 = "')) beef.Transform:SetPosition(x,y,z)"
	return str1..tendencytype..str2..saddle..str3
end

local function gotoswitch(point1, point2)
	point1 = point1 or ""
	point2 = point2 or ""
	return 'local player = %s if player ~= nil then local function tmi_goto(prefab) if player.Physics ~= nil then player.Physics:Teleport(prefab.Transform:GetWorldPosition()) else player.Transform:SetPosition(prefab.Transform:GetWorldPosition()) end end local target = c_findnext("'..point1..'") if target == nil then target = c_findnext("'..point2..'") end tmi_goto(target) end'
end

local world_id = TheWorld.meta.session_identifier or "world"
local savepath = TOOMANYITEMS.TELEPORT_DATA_FILE .. "toomanyitems_teleport_save_"..world_id

local function LoadTeleportData(slot_num)
	if slot_num and type(slot_num) == "number" then
		local x = TOOMANYITEMS.TELEPORT_DATA[slot_num] and TOOMANYITEMS.TELEPORT_DATA[slot_num]["x"]
		local z = TOOMANYITEMS.TELEPORT_DATA[slot_num] and TOOMANYITEMS.TELEPORT_DATA[slot_num]["z"]
		if x and z and type(x) == "number" and type(z) == "number" then
			SendCommand(string.format('local player = %s if player ~= nil then if player.Physics ~= nil then player.Physics:Teleport('..x..', '..'0, '..z..') else player.Transform:SetPosition('..x..', '..'0, '..z..') end end', GetCharacter()))
		end
	end
end

local function SaveTeleportData(slot_num)
	local x, _, z = ThePlayer.Transform:GetWorldPosition()

	if x and z and slot_num and type(x) == "number" and type(z) == "number" and type(slot_num) == "number" then
		TOOMANYITEMS.TELEPORT_DATA[slot_num] = {}
		TOOMANYITEMS.TELEPORT_DATA[slot_num]["x"] = x
		TOOMANYITEMS.TELEPORT_DATA[slot_num]["z"] = z

		if TOOMANYITEMS.DATA_SAVE == 1 then
			TOOMANYITEMS.SaveData(savepath, TOOMANYITEMS.TELEPORT_DATA)
		end
	end
end

local function GetTeleportList(Teleportfn)
	local telelist = {}
	for i = 1, 6 do
		telelist[i] = {
			beta = false,
			pos = "all",
			name = '[ '..i..' ]',
			tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TELEPORT_SLOT.." "..i,
			fn = {
				TeleportNum = i,
				TeleportFn = Teleportfn,
			},
		}
	end
	return telelist
end

return {
	{
		tittle = STRINGS.UI.SERVERLISTINGSCREEN.SEASONFILTER,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.UI.SERVERLISTINGSCREEN.SEASONS.SPRING,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SEASON_SPRINGTIP,
				fn = 'TheWorld:PushEvent("ms_setseason", "spring")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.UI.SERVERLISTINGSCREEN.SEASONS.SUMMER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SEASON_SUMMERTIP,
				fn = 'TheWorld:PushEvent("ms_setseason", "summer")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.UI.SERVERLISTINGSCREEN.SEASONS.AUTUMN,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SEASON_AUTUMNTIP,
				fn = 'TheWorld:PushEvent("ms_setseason", "autumn")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.UI.SERVERLISTINGSCREEN.SEASONS.WINTER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SEASON_WINTERTIP,
				fn = 'TheWorld:PushEvent("ms_setseason", "winter")',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_NEXT,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_NEXTTIP,
				fn = 'TheWorld:PushEvent("ms_nextphase")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_ODAY,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_ODAYTIP,
				fn = 'c_skip(1)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_FDAYS,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_FDAYSTIP,
				fn = 'c_skip(5)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_TDAYS,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_TDAYSTIP,
				fn = 'c_skip(10)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_20DAYS,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TIME_20DAYSTIP,
				fn = 'c_skip(20)',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_SLOW,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_SLOWTIP,
				fn = 'local player = %s if player ~= nil and player.components.locomotor then player.components.locomotor:SetExternalSpeedMultiplier(player, "c_speedmult", 0.6) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_NORMAL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_NORMALTIP,
				fn = 'local player = %s if player ~= nil and player.components.locomotor then player.components.locomotor:SetExternalSpeedMultiplier(player, "c_speedmult", 1) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_FAST,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_FASTTIP,
				fn = 'local player = %s if player ~= nil and player.components.locomotor then player.components.locomotor:SetExternalSpeedMultiplier(player, "c_speedmult", 2) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_SFAST,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_SFASTTIP,
				fn = 'local player = %s if player ~= nil and player.components.locomotor then player.components.locomotor:SetExternalSpeedMultiplier(player, "c_speedmult", 3) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_FLY,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SPEED_FLYTIP,
				fn = 'local player = %s if player ~= nil and player.components.locomotor then player.components.locomotor:SetExternalSpeedMultiplier(player, "c_speedmult", 4) end',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.UI.CUSTOMIZATIONSCREEN.LIGHTNING,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_LIGHTNINGTIP,
				fn = 'TheWorld:PushEvent("ms_sendlightningstrike", Vector3(%s.Transform:GetWorldPosition()))',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_WATER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_WATERTIP,
				fn = 'TheWorld:PushEvent("ms_forceprecipitation", true)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_NOWATER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_WEATHER_NOWATERTIP,
				fn = 'TheWorld:PushEvent("ms_forceprecipitation", false)',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_KILL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_KILLTIP,
				fn = '%s:PushEvent("death")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTERREBIRTH,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_REBIRTHTIP,
				fn = '%s:PushEvent("respawnfromghost")',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_DESPAWN,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_DESPAWNTIP,
				fn = 'c_despawn(%s)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_GATHER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_GATHERTIP,
				fn = 'local x,y,z = %s.Transform:GetWorldPosition() for k,v in pairs(AllPlayers) do v.Transform:SetPosition(x,y,z) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_UNLOCKTECH,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_CHARACTER_UNLOCKTECHTIP,
				fn = '%s.components.builder:UnlockRecipesForTech({SCIENCE = 10, MAGIC = 10, ANCIENT = 10, SHADOW = 10, CARTOGRAPHY = 10})',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_DELETE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_DELETETIP,
				fn = 'local player = %s local function InInv(b) local inv = b.components.inventoryitem return inv and inv.owner and true or false end local function CanDelete(inst) if inst and inst ~= TheWorld and not InInv(inst) and inst.Transform then if inst:HasTag("player") then if inst.userid == nil or inst.userid == "" then return true end else return true end end return false end if player and player.Transform then if player.components.burnable then player.components.burnable:Extinguish(true) end local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 3) for _, obj in pairs(ents) do if CanDelete(obj) then if obj.components then if obj.components.burnable then obj.components.burnable:Extinguish(true) end if obj.components.firefx then if obj.components.firefx.extinguishsoundtest then obj.components.firefx.extinguishsoundtest = function() return true end end obj.components.firefx:Extinguish() end end obj:Remove() end end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_FERTILIZER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_FERTILIZERTIP,
				fn = "local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) local poop = nil for k,obj in pairs(ents) do if not obj:HasTag('player') and obj ~= TheWorld and obj.AnimState and obj.Transform then if not (poop and poop.components and poop.components.fertilizer) then poop = c_spawn('poop') end if obj and obj.components.crop and not obj.components.crop:IsReadyForHarvest() and not obj:HasTag('withered') then obj.components.crop:Fertilize(poop) elseif obj.components.grower and obj.components.grower:IsEmpty() then obj.components.grower:Fertilize(poop) elseif obj.components.pickable and obj.components.pickable:CanBeFertilized() then obj.components.pickable:Fertilize(poop) end end end if poop ~= nil then poop:Remove() end",
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_GROWTH,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_GROWTHTIP,
				fn = 'local player = %s local function trygrowth(inst) if inst:IsInLimbo() or (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then return end if inst.components.pickable ~= nil then if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then return end inst.components.pickable:FinishGrowing() end if inst.components.crop ~= nil then inst.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME * 3, true) end if inst.components.growable ~= nil and inst:HasTag("tree") and not inst:HasTag("stump") then inst.components.growable:DoGrowth() end if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then inst.components.harvestable:Grow() end end local x, y, z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x, y, z, 30, nil, { "pickable", "stump", "withered", "INLIMBO" }) if #ents > 0 then trygrowth(table.remove(ents, math.random(#ents))) if #ents > 0 then local timevar = 1 - 1 / (#ents + 1) for i, v in ipairs(ents) do v:DoTaskInTime(timevar * math.random(), trygrowth) end end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_HARVEST,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_HARVESTTIP,
				fn = 'local player = %s if not player or player:HasTag("playerghost") then return end local function tryharvest(inst) local objc = inst.components if objc.crop ~= nil then objc.crop:Harvest(player) elseif objc.harvestable ~= nil then objc.harvestable:Harvest(player) elseif objc.stewer ~= nil then objc.stewer:Harvest(player) elseif objc.dryer ~= nil then objc.dryer:Harvest(player) elseif objc.occupiable ~= nil and objc.occupiable:IsOccupied() then local item = objc.occupiable:Harvest(player) if item ~= nil then player.components.inventory:GiveItem(item) end elseif objc.pickable ~= nil and objc.pickable:CanBePicked() then objc.pickable:Pick(player) end end local function harvesting() local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) for k, obj in pairs(ents) do if not obj:HasTag("player") and not obj:HasTag("flower") and not obj:HasTag("trap") and not obj:HasTag("mine") and not obj:HasTag("cage") and obj ~= TheWorld and obj.AnimState and obj.components and obj.prefab and not string.find(obj.prefab, "mandrake") then tryharvest(obj) end end end harvesting()',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_PICK,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_PICKTIP,
				fn = 'local player = %s if not player or player:HasTag("playerghost") then return end local inv = player.components.inventory local x, y, z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x, y, z, 30, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire" }) local baits = { ["powcake"] = true, ["pigskin"] = true, ["winter_food4"] = true, } local function Wall(item) local xx, yy ,zz = item.Transform:GetWorldPosition() local nents = TheSim:FindEntities(xx, yy, zz, 3) local targets = 0 for _, vv in ipairs(nents) do if vv:HasTag("wall") and vv.components.health then targets = targets + 1 end end return targets end for _, v in ipairs(ents) do local c = v.components if c.inventoryitem ~= nil and c.inventoryitem.canbepickedup and c.inventoryitem.cangoincontainer and not c.inventoryitem:IsHeld() and not v:HasTag("flower") and not v:HasTag("trap") and not v:HasTag("mine") and not v:HasTag("cage") and not string.find(v.prefab, "mooneye") and inv and inv:CanAcceptCount(v, 1) > 0 then if c.trap ~= nil and c.trap:IsSprung() then c.trap:Harvest(player) else if baits[v.prefab] then if Wall(v) < 7 then inv:GiveItem(v) end else if c.bait then if not c.bait.trap then inv:GiveItem(v) end else inv:GiveItem(v) end end end end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_FROZEN,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_ENTITY_FROZENTIP,
				fn = "local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 15) for k,obj in pairs(ents) do if not obj:HasTag('player') and obj ~= TheWorld and obj.AnimState and obj.Transform and obj.components and obj.components.freezable ~= nil then obj.components.freezable:AddColdness(1, 60) obj.components.freezable:SpawnShatterFX() end end",
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_ORNERY,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_ORNERYTIP,
				fn = GetDomesticateStr("TENDENCY.ORNERY", "saddle_war"),
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_RIDER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_RIDERTIP,
				fn = GetDomesticateStr("TENDENCY.RIDER", "saddle_race"),
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_PUDGY,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_PUDGYTIP,
				fn = GetDomesticateStr("TENDENCY.PUDGY", "saddle_race"),
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_DEFAULT,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_BEEFALO_DEFAULTTIP,
				fn = GetDomesticateStr("TENDENCY.DEFAULT", "saddle_war"),
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_ADD,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_ADDTIP,
				fn = 'local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 5) for k,obj in pairs(ents) do if not obj:HasTag("player") and obj ~= TheWorld and obj.AnimState and obj.Transform and obj.components and obj.components.follower ~= nil and not player:HasTag("playerghost") then if obj.components.combat and obj.components.combat:TargetIs(player) then obj.components.combat:SetTarget(nil) end if player.components.leader ~= nil then player:PushEvent("makefriend") player.components.leader:AddFollower(obj) obj.components.follower:AddLoyaltyTime(6000) obj.components.follower.maxfollowtime = 6000 end end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_EXPEL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_EXPELTIP,
				fn = 'local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 8) for k,obj in pairs(ents) do if obj.components and obj.components.follower ~= nil and player.components.leader ~= nil and player.components.leader:IsFollower(obj) then player.components.leader:RemoveFollower(obj) obj.components.follower.targettime = 0 end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_HEALTH,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_HEALTHTIP,
				fn = 'local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) for k,obj in pairs(ents) do if obj.components and obj.components.follower ~= nil and player.components.leader ~= nil and player.components.leader:IsFollower(obj) and obj.components.health then obj.components.health:SetPercent(1) end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_HUNGER,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_HUNGERTIP,
				fn = 'local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) for k,obj in pairs(ents) do if obj.components and obj.components.follower ~= nil and player.components.leader ~= nil and player.components.leader:IsFollower(obj) and obj.components.hunger then obj.components.hunger:SetPercent(1) end end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_LOYAL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_FOLLOWER_LOYALTIP,
				fn = 'local player = %s local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) for k,obj in pairs(ents) do if obj.components and obj.components.follower ~= nil and player.components.leader ~= nil and player.components.leader:IsFollower(obj) and not player:HasTag("playerghost") then obj.components.follower.targettime = obj.components.follower.maxfollowtime + GetTime() if obj.components.domesticatable then obj.components.domesticatable:DeltaObedience(1) end end end',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_RESET,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_RESETTIP,
				fn = 'c_reset(true)',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_REGENERATE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_REGENERATETIP,
				fn = 'c_regenerateworld()',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_ROLLBACK,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_ROLLBACKTIP,
				fn = 'c_rollback()',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_SAVE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_SAVETIP,
				fn = 'c_save()',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_SHUTDOWN,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_SHUTDOWNTIP,
				fn = 'if TheNet:GetIsServer() and TheNet:GetServerIsDedicated() then c_shutdown(true) end',
			},
		},
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TELEPORT_SAVE_TEXT,
		list = GetTeleportList(SaveTeleportData)
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_TELEPORT_LOAD_TEXT,
		list = GetTeleportList(LoadTeleportData)
	},
	{
		tittle = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TEXT,
		list = {
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_SHOW,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_SHOWTIP,
				fn = 'local p=%s local m=p and p.userid and p.player_classified and p.player_classified.MapExplorer local function ThMap() if m then m:LearnRecordedMap(TheWorld.TMI_map) end end if TheWorld.TMI_map then ThMap() else local function InInv(b) local inv=b.components.inventoryitem return inv and inv.owner and true or false end for _,v in pairs(Ents) do if m and v.MiniMapEntity and v.Transform and v.AnimState and v.prefab and not InInv(v) then m:RevealArea(v.Transform:GetWorldPosition()) end end local function RdMap() if m then TheWorld.TMI_map = m:RecordMap() end end p:DoTaskInTime(5,RdMap) end',
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_HIDE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_HIDETIP,
				fn = function() ExecuteConsoleCommand('TheWorld.minimap.MiniMap:ClearRevealedAreas()') end,
			},
			{
				beta = false,
				pos = "all",
				name = STRINGS.NAMES.MULTIPLAYER_PORTAL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.MULTIPLAYER_PORTAL,
				fn = gotoswitch("multiplayer_portal"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.CAVE_ENTRANCE_OPEN,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.CAVE_ENTRANCE_OPEN,
				fn = gotoswitch("cave_entrance_open", "cave_entrance"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.PIGKING,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.PIGKING,
				fn = gotoswitch("pigking"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.WALRUS_CAMP,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.WALRUS_CAMP,
				fn = gotoswitch("walrus_camp"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.MOONBASE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.MOONBASE,
				fn = gotoswitch("moonbase"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.STAGEHAND,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.STAGEHAND,
				fn = gotoswitch("stagehand"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.SCULPTURE_ROOKBODY,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.SCULPTURE_ROOKBODY,
				fn = gotoswitch("sculpture_rookbody"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.LAVA_POND,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.LAVA_POND,
				fn = gotoswitch("lava_pond"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.BEEQUEENHIVE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.BEEQUEENHIVE,
				fn = gotoswitch("beequeenhive"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.CRITTERLAB,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.CRITTERLAB,
				fn = gotoswitch("critterlab"),
			},
			{
				beta = false,
				pos = "forest",
				name = STRINGS.NAMES.KLAUS_SACK,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.KLAUS_SACK,
				fn = gotoswitch("klaus_sack"),
			},
			{
				beta = false,
				pos = "cave",
				name = STRINGS.NAMES.CAVE_EXIT,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.CAVE_EXIT,
				fn = gotoswitch("cave_exit"),
			},
			{
				beta = false,
				pos = "cave",
				name = STRINGS.NAMES.ANCIENT_ALTAR,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.ANCIENT_ALTAR,
				fn = gotoswitch("ancient_altar", "ancient_altar_broken"),
			},
			{
				beta = false,
				pos = "cave",
				name = STRINGS.NAMES.TOADSTOOL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.TOADSTOOL,
				fn = gotoswitch("toadstool_cap"),
			},
			{
				beta = false,
				pos = "cave",
				name = STRINGS.NAMES.RABBITHOUSE,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.RABBITHOUSE,
				fn = gotoswitch("rabbithouse"),
			},
			{
				beta = false,
				pos = "cave",
				name = STRINGS.NAMES.MONKEYBARREL,
				tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_TELEPORTTIP..STRINGS.NAMES.MONKEYBARREL,
				fn = gotoswitch("monkeybarrel"),
			},
		},
	},

}
