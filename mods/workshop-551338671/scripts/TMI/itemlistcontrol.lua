local Listload = {
	["food"] = true,
	["resource"] = true,
	["weapon"] = true,
	["tool"] = true,
	["clothe"] = true,
	["gift"] = true,
	["living"] = false,
	["building"] = false,
}

local deleteprefabs = {
	["buildgridplacer"] = true,
	["cave"] = true,
	["forest"] = true,
	["frontend"] = true,
	["global"] = true,
	["gridplacer"] = true,
	["hud"] = true,
	["ice_splash"] = true,
	["impact"] = true,
	["lanternlight"] = true,
	["sporecloud_overlay"] = true,
	["thunder_close"] = true,
	["thunder_far"] = true,
	["waterballoon_splash"] = true,
	["world"] = true,
}

local function comp(a, b)
	return a < b
end

local function MergeItemList(...)
	local ret = {}
	for _, map in ipairs({...}) do
		for i = 1, #map do
			table.insert(ret, map[i])
		end
	end
	return ret
end

local ItemListControl = Class(function(self)
		self.beta = BRANCH ~= "release" and true or false
		self.list = {}
		self:Init()

	end)

function ItemListControl:Init()
	if self.beta then
		self.betalistpatch = require "TMI/list/itemlist_beta"
	end

	local n = 1
	self.list["all"] = {}
	for k,v in pairs(Listload) do
		local path = "TMI/list/itemlist_"..k
		self.list[k] = require(path)
		if self.betalistpatch and self.betalistpatch[k] and #self.betalistpatch[k] > 0 then
			self.list[k] = MergeItemList(self.list[k], self.betalistpatch[k])
			self:SortList(self.list[k])
		end
		if v then
			for i = 1, #self.list[k] do
				if not table.contains(self.list["all"], self.list[k][i]) then
					self.list["all"][n] = self.list[k][i]
					n = n + 1
				end
			end
		end
	end

	self:SortList(self.list["all"])

	self.list["others"] = {}

	for _, v in pairs(PREFAB_SKINS) do
		if type(v) == "table" then
			for _, vv in pairs(v) do
				deleteprefabs[vv] = true
			end
		end
	end

	for _, v in pairs(Prefabs) do
		if v.assets and self:CanAddOthers(v.name) then
			table.insert(self.list["others"], v.name)
		end
	end

	self:SortList(self.list["others"])
end

function ItemListControl:GetList()
	return self:GetListbyName(TOOMANYITEMS.DATA.listinuse)
end

function ItemListControl:GetListbyName(name)
	if name and type(name) == "string" then
		if name == "special" then
			return TOOMANYITEMS.DATA.specialitems
		else
			return self.list[name]
		end
	else
		TOOMANYITEMS.DATA.listinuse = "all"
	end
	return self.list["all"]
end

function ItemListControl:Search()
	local searchlist = {}
	local list = self:GetList()
	local item = TOOMANYITEMS.DATA.search

	for _,v in ipairs(list) do
		if string.find(v, item) then
			table.insert(searchlist, v)
		end
	end

	for k,v in pairs(STRINGS.NAMES) do
		local prefab = string.lower(k)
		if table.contains(list, prefab) and string.find(string.lower(v), item) and not table.contains(searchlist, prefab) then
			table.insert(searchlist, prefab)
		end
	end

	self:SortList(searchlist)
	return searchlist
end

function ItemListControl:SortList(list)
	table.sort(list, comp)
end

function ItemListControl:CanAddOthers(item)
	local can_add = not table.contains(self.list["others"], item)
	and not table.contains(self.list["all"], item)
	and not table.contains(self.list["living"], item)
	and not table.contains(self.list["building"], item)
	and not string.find(item, "MOD_")
	and not string.find(item, "_placer")
	and not string.find(item, "_builder")
	and not string.find(item, "_classified")
	and not string.find(item, "_network")
	and not string.find(item, "_lvl")
	and not string.find(item, "_fx")
	and not string.find(item, "blueprint")
	and not string.find(item, "buff")
	and not string.find(item, "map")
	and not string.find(item, "workshop")
	if not deleteprefabs[item] and can_add then
		return true
	end
	return false
end

return ItemListControl
