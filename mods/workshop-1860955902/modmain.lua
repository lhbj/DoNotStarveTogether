AddPlayerPostInit(function(inst) 
    inst:AddTag("compassbearer")
	inst:AddTag("maprevealer")
    inst:AddComponent("maprevealer")	 
	if inst.components.maprevealable ~= nil then
       inst.components.maprevealable:AddRevealSource(inst, "compassbearer")
    end
end)   