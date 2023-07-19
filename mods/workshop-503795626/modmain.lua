if not GLOBAL.TheNet:GetIsServer() then 
    return
end

local assert = GLOBAL.assert
local debug = GLOBAL.debug

local UpvalueHacker = {}

local function GetUpvalueHelper(fn, name)
    local i = 1
    while debug.getupvalue(fn, i) and debug.getupvalue(fn, i) ~= name do
        i = i + 1
    end
    local name, value = debug.getupvalue(fn, i)
    return value, i
end

UpvalueHacker.GetUpvalue = function(fn, ...)
    local prv, i, prv_var = nil, nil, "(the starting point)"
    for j,var in ipairs({...}) do
        assert(type(fn) == "function", "We were looking for "..var..", but the value before it, "
            ..prv_var..", wasn't a function (it was a "..type(fn)
            .."). Here's the full chain: "..table.concat({"(the starting point)", ...}, ", "))
        prv = fn
        prv_var = var
        fn, i = GetUpvalueHelper(fn, var)
    end
    return fn, i, prv
end

UpvalueHacker.SetUpvalue = function(start_fn, new_fn, ...)
    local _fn, _fn_i, scope_fn = UpvalueHacker.GetUpvalue(start_fn, ...)
    debug.setupvalue(scope_fn, _fn_i, new_fn)
end

--Makes Wall a Structure
local indestructable_wall_list = {
    "wall_ruins",
    "fence_gate",
}

local more_wall_list = {
    "fence",
    "wall_hay",
    "wall_wood",
    "wall_stone",
    "wall_moonrock",
}

if GetModConfigData("More_Invincible_Wall") then
    for k, v in pairs(more_wall_list) do
        table.insert(indestructable_wall_list, v)
    end
end

if GetModConfigData("Invincible_Wall") then
	for k, v in pairs(indestructable_wall_list) do  
	    AddPrefabPostInit(v, function(inst)
	        inst:RemoveComponent("combat")
	        inst:AddTag("structure")
	    end)
	end
end

--Make telebase a Structure
AddPrefabPostInit("telebase", function(inst)
    inst:AddTag("structure")
end)

--Overworld Boss
AddPrefabPostInitAny(function(inst)
    if inst.components.workable and inst:HasTag("structure") then
        function inst.components.workable:Destroy(destroyer)
            if destroyer.components.playercontroller == nil then 
            return
            end
            if self:CanBeWorked() then
                self:WorkedBy(destroyer, self.workleft)
            end
        end
        function inst.components.workable:WorkedBy(worker)
            if worker.components.playercontroller == nil then
            return
            end
        numworks = numworks or 1
        self.workleft = self.workleft - numworks
        self.lastworktime = GLOBAL.GetTime()

        worker:PushEvent("working", { target = self.inst })
        self.inst:PushEvent("worked", { worker = worker, workleft = self.workleft })

        if self.onwork ~= nil then
            self.onwork(self.inst, worker, self.workleft, numworks)
        end

        if self.workleft <= 0 then
            if self.onfinish ~= nil then
                self.onfinish(self.inst, worker)
        end
            self.inst:PushEvent("workfinished", { worker = worker })

            worker:PushEvent("finishedwork", { target = self.inst, action = self.action })
        end
        end
    end
end)

--Sinkhole
local COLLAPSIBLE_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = nil,
    MINE = true,
}

AddPrefabPostInit("world", function(inst)
UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.antlion_sinkhole.fn, COLLAPSIBLE_WORK_ACTIONS, "onstartcollapse", "donextcollapse", "COLLAPSIBLE_WORK_ACTIONS")
end)

--Cavein Boulder
AddPrefabPostInit("cavein_boulder", function(inst)
inst:RemoveTag("heavy")
    inst:DoTaskInTime(3, function(inst)
    inst:AddTag("heavy")
    end)
end)

--Meteor
local SMASHABLE_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = nil,
    MINE = true,
}

AddPrefabPostInit("world", function(inst)
UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.shadowmeteor.fn, SMASHABLE_WORK_ACTIONS, "SetSize", "dostrike", "onexplode", "SMASHABLE_WORK_ACTIONS")
end)