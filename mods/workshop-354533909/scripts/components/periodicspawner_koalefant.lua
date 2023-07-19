
local function DoSpawn(inst)
    local spawner = inst.components.periodicspawner_koalefant
    if spawner then
		spawner.target_time = nil    
		spawner:TrySpawn()
        spawner:Start()
    end
end

local PeriodicSpawner_Koalefant = Class(function(self, inst)
    self.inst = inst
    self.basetime = 40
    self.randtime = 60
end)

function PeriodicSpawner_Koalefant:SetRandomTimes(basetime, variance, no_reset)
    self.basetime = basetime
    self.randtime = variance
	
    if self.task and not no_reset then
        self:Stop()
        self:Start()
    end
end

function PeriodicSpawner_Koalefant:TrySpawn()
	local prefab = nil
	if TheWorld.state.iswinter then
		prefab = "baby_koalefant_winter"
	else 
		prefab = "baby_koalefant_summer"
	end

    if not self.inst:IsValid() or not prefab then
        return
    end
	
	local canspawn = true
	
	local pos = Vector3(self.inst.Transform:GetWorldPosition())
    local koalefants = TheSim:FindEntities(pos.x,pos.y,pos.z, 80, {"koalefant"})
	if #koalefants > 12 then
		canspawn = false
	end
	   
    if canspawn then
        local inst = SpawnPrefab(prefab)
        inst.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    end
	
    return canspawn
end

function PeriodicSpawner_Koalefant:Start()
    local t = self.basetime + math.random()*self.randtime
    self.target_time = GetTime() + t
    self.task = self.inst:DoTaskInTime(t, DoSpawn)
end

function PeriodicSpawner_Koalefant:Stop()
    self.target_time = nil
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

function PeriodicSpawner_Koalefant:LongUpdate(dt)
	if self.target_time then
		if self.task then
			self.task:Cancel()
			self.task = nil
		end
		local time_to_wait = self.target_time - GetTime() - dt
		
		if time_to_wait <= 0 then
			DoSpawn(self.inst)		
		else
			self.target_time = GetTime() + time_to_wait
			self.task = self.inst:DoTaskInTime(time_to_wait, DoSpawn)
		end
	end
end

return PeriodicSpawner_Koalefant