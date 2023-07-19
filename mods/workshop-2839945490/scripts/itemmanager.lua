local ItemManager = Class(function(self)
	self.preciousitems = {}
	self.canbreak_items = {}
    self.nodrop_items = {}
end)

function ItemManager:Init()
    self.preciousitems={
        "walrus_tusk",  -- 海象牙
        "walrushat",  -- 贝雷帽
        "cane",  -- 步行手杖
        "deerclops_eyeball",  -- 巨鹿眼球
        "eyebrellahat",  -- 眼球伞
        "orangestaff",  -- 懒人魔杖
        "yellowstaff",  -- 唤星法杖
        "opalstaff",  -- 唤月法杖
        "greenstaff",  -- 拆解魔杖
        "opalpreciousgem",  -- 彩虹宝石
        "orangeamulet",  -- 懒人护符
        "yellowamulet",  -- 魔光护符
        "greenamulet",  -- 建造护符
        "minotaurhorn",  -- 犀牛角
        "thurible",  -- 暗影香炉
        "armorskeleton",  -- 骨甲
        "skeletonhat",  -- 骨盔
        "shroom_skin",  -- 蘑菇皮
        "shieldofterror",  -- 恐怖盾牌
        "alterguardianhat",  -- 启迪之冠
        "alterguardianhatshard",  -- 启迪之冠碎片
        "panflute",  -- 排箫
        "fossil_piece",  -- 化石碎片
    }
    self.canbreak_items = {
        "skeleton",
        "skeleton_player",
        "myth_higanabana_tele"
    }
end

function ItemManager:PrefabInItems(classified, prefab)
    if self[classified] == nil or type(self[classified]) ~= "table" then
        print("Classified " .. classified .. " is not exist!")
        return
    end
    for k, v in pairs(self[classified]) do
        if v == prefab then
            return true
        end
    end
    return false
end

function ItemManager:AddItem(classified, prefab, save_after_update)
    if type(prefab) ~= "string" then
        print("Argument 'prefab' must be instance of string!")
        return
    elseif prefab == "" then
        print("prefab can not be empty!")
        return
    else
        -- 去除首位空格
        prefab = prefab:match("^[%s]*(.-)[%s]*$")
    end

    if self[classified] == nil or type(self[classified]) ~= "table" then
        print("Classified " .. classified .. " is not exist!")
        return
    end
    -- 如果已经存在就直接退出
    for i=1, #self[classified] do
        if self[classified][i] == string.lower(prefab) then
            return
        end
    end
    table.insert(self[classified], string.lower(prefab))
    if save_after_update then
        self:Save()
    end
end

function ItemManager:ListAllItemInPlayer(player)
    --[[
        列出玩家身上所有物品
        Args:
            player: 玩家对象
        Return: 玩家身上的物品和对应数量表
    ]]
    local inventory = player.components.inventory
    if not inventory then
        return {}
    end

    local allitems = {}

    --遍历身上
    for k = 1, inventory.maxslots do
        local v = inventory.itemslots[k]
        -- 初始化

        if v ~= nil then
            if v.components.stackable then
                allitems[v.prefab] = (allitems[v.prefab] or 0) + v.components.stackable.stacksize
            else
                allitems[v.prefab] = (allitems[v.prefab] or 0) + 1
            end                  
        end         

        --遍历身上打包袋
        if v ~= nil and v:HasTag("bundle") and v.components.unwrappable ~= nil and v.components.unwrappable.itemdata ~= nil then
            for key, value in pairs(v.components.unwrappable.itemdata) do
                if value then
                    if value.data and value.data.stackable  then
                        allitems[value.prefab] = (allitems[value.prefab] or 0) + value.data.stackable.stack
                    else
                        allitems[value.prefab] = (allitems[value.prefab] or 0) + 1
                    end
                end
            end
        end
    end

    --遍历背包
    for k, v in pairs(inventory.equipslots) do
        if v:HasTag("backpack") and v.components.container then
            for j = 1, v.components.container.numslots do
                local u=v.components.container.slots[j]
                if u~=nil then
                    if u.components.stackable then
                        allitems[u.prefab] = (allitems[u.prefab] or 0) + u.components.stackable.stacksize
                    else
                        allitems[u.prefab] = (allitems[u.prefab] or 0) + 1
                    end
                end

                --遍历背包内打包袋
                if u ~= nil and u:HasTag("bundle") then
                    for key, value in pairs(u.components.unwrappable.itemdata) do
                        if value then
                            if value.data and value.data.stackable  then
                                allitems[value.prefab] = (allitems[value.prefab] or 0) + value.data.stackable.stack
                            else
                                allitems[value.prefab] = (allitems[value.prefab] or 0) + 1
                            end
                        end
                    end
                end
            end
        else
            allitems[v.prefab] = (allitems[v.prefab] or 0) + 1
        end
    end

    return allitems
end

function ItemManager:CheckItmeInPlayer(player, prefab)
    local allitems = self:ListAllItemInPlayer(player)
    return allitems[prefab] or 0
end

function ItemManager:Save()
    local str = json.encode({preciousitems = self.preciousitems, canbreak_items = self.canbreak_items, nodrop_items = self.nodrop_items})
    TheSim:SetPersistentString("visitordrop", str, false)
end

function ItemManager:Load()
	TheSim:GetPersistentString("visitordrop", function(load_success, data)
		if load_success and data ~= nil then
			local status, recipe_visitordrop = pcall( function() return json.decode(data) end )
		    if status and recipe_visitordrop then
				self.preciousitems = recipe_visitordrop.preciousitems or {}
				self.canbreak_items = recipe_visitordrop.canbreak_items or {}
                self.nodrop_items = recipe_visitordrop.nodrop_items or {}
			else
				print("Faild to load the visitordrop data!", status, recipe_visitordrop)
			end
		end
	end)
    if #self.preciousitems == 0 and #self.canbreak_items == 0 then
        self:Init()
    end
end

function ItemManager:DebugPrint()
    print('preciousitems: '..table.concat(self.preciousitems, ', '))
    print('canbreak_items: '..table.concat(self.canbreak_items, ', '))
    print('nodrop_items: '..table.concat(self.nodrop_items, ', '))
end

return ItemManager
