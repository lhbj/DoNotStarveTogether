GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local _G = GLOBAL
local function namely(s) local a=string.sub(s,3,4) local b=string.sub(s,5,6) local c=string.sub(s,7,8) local d=string.sub(s,9,10) local e=string.sub(s,11,11) local m=string.reverse(a)..string.reverse(c)..string.reverse(e)..string.reverse(b)..string.reverse(d)  return m end
TUNING.DIAOLUO_TARGET = GetModConfigData("droppos")
TUNING.VISITOR_TIME = GetModConfigData("visitortime")
TUNING.LIGHT_TIME = GetModConfigData("lighttime")
TUNING.SHOW_TITLE = GetModConfigData("showtitle")
TUNING.SHOW_BUNDLE_OWNER = GetModConfigData("show_bundle_owner")
local hit_beefalo = GetModConfigData("hit_beefalo")
local show_ui = GetModConfigData("show_ui")
local danger_announce = GetModConfigData("danger_announce")

TUNING.VDItemManager = require('itemmanager')()
TUNING.VDItemManager:Load()

PrefabFiles =  {
    "touxian"
}

Assets =
{
    Asset("IMAGE", "images/vd_setting_icon.tex"),
    Asset("ATLAS", "images/vd_setting_icon.xml"),
    Asset("IMAGE", "images/screen_btn_ban.tex"),
    Asset("ATLAS", "images/screen_btn_ban.xml"),
    Asset("IMAGE", "images/screen_btn_reset.tex"),
    Asset("ATLAS", "images/screen_btn_reset.xml"),
    Asset("IMAGE", "images/screen_btn_upgrade.tex"),
    Asset("ATLAS", "images/screen_btn_upgrade.xml"),
}

if show_ui then
    -- UI界面
    local visitorSettingIcon = require("widgets/visitorSettingIcon")
    AddClassPostConstruct("widgets/controls", function(self)
        self.visitorSettingIcon = self:AddChild(visitorSettingIcon(self.owner))
    end)

    -- HUD
    local VDSettingsScreen = require "screens/vdsettingsscreen"--设置界面
    local VDUserManagerScreen = require "screens/vdusermanagerscreen"--设置界面
    AddClassPostConstruct("screens/playerhud", function(self, anim, owner)
        -- 工具箱界面
        self.ShowVDSettingsScreen = function(_, attach)
            self.vdsettingsscreen = VDSettingsScreen(self.owner)
            self:OpenScreenUnderPause(self.vdsettingsscreen)
            return self.vdsettingsscreen
        end
        self.CloseVDSettingsScreen = function(_)
            if self.vdsettingsscreen then
                self.vdsettingsscreen:Close()
                self.vdsettingsscreen = nil
            end
        end

        -- 用户权限管理界面
        self.ShowVDUserManagerScreen = function()
            if self.VDUserManagerScreen == nil then
                self.VDUserManagerScreen = VDUserManagerScreen(self.owner)
            end
            TheFrontEnd:PushScreen(self.VDUserManagerScreen)
            self.VDUserManagerScreen:MoveToFront()
            self.VDUserManagerScreen:Show()
        end
    end)
end

AddPrefabPostInit("pigking", function(inst)
    if TUNING.DIAOLUO_TARGET == "pigking" then
        inst:DoTaskInTime(0,function ()
            TUNING.DIAOLUO_TARGET = inst:GetPosition()
        end)
    end
end)

AddPrefabPostInit("moonbase", function(inst)
    if TUNING.DIAOLUO_TARGET == "moonbase" then
        inst:DoTaskInTime(0,function ()
            TUNING.DIAOLUO_TARGET = inst:GetPosition()
        end)
    end
end)

AddPrefabPostInit("multiplayer_portal", function(inst)
    if TUNING.DIAOLUO_TARGET == "portal" and TheWorld:HasTag("cave")==false then
        inst:DoTaskInTime(0,function ()
            TUNING.DIAOLUO_TARGET = inst:GetPosition()
        end)
    end
end)

AddPrefabPostInit("multiplayer_portal_moonrock", function(inst)
    if TUNING.DIAOLUO_TARGET == "portal"  then
        inst:DoTaskInTime(0,function ()
            TUNING.DIAOLUO_TARGET = inst:GetPosition()
        end)
    end
end)

local function DangerAnnounce(message, period)
    print(message)
    if not danger_announce then
        return
    end
    period = period or 5
    if not TUNING.HAS_ANNOUNCE then
        TheNet:Announce(message)
        if period > 0 then
            TUNING.HAS_ANNOUNCE=true
            TheWorld:DoTaskInTime(period,function ()
                TUNING.HAS_ANNOUNCE=false
            end)
        end
    end
end

-- 检测用户是否在白名单内，兼容Linux和Windows换行符
local _whitelist_ids = {}
_G.TheSim:GetPersistentString("../../whitelist.txt",
    function(load_success, str)
        local function split(input, delimiter)
            input = tostring(input)
            delimiter = tostring(delimiter)
            if (delimiter=='') then return false end
            local pos,arr = 0, {}
            for st,sp in function() return string.find(input, delimiter, pos, true) end do
                table.insert(arr, string.sub(input, pos, st - 1))
                pos = sp + 1
            end
            table.insert(arr, string.sub(input, pos))
            arr[#arr] = nil
            return arr
        end

        if load_success then
            -- 去除换行符里的\r
            str = string.gsub(string.gsub(str, "\r", "\n"), "\n\n", "\n")
            for _, v in pairs(split(str, "\n")) do
                table.insert(_whitelist_ids, v)
            end
        end
    end
)
local function IsWhiteListed(userid)
    -- 官方API检测方法
    if _G.TheNet:IsWhiteListed(userid) then
        return true
    end
    -- 文件比对法
    for i=1, #_whitelist_ids do
        if _whitelist_ids[i] == userid then
            return true
        end
    end
    return false
end

AddPlayerPostInit(function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("leaveanddrop")
        inst:DoTaskInTime(5,function ()
            if not inst.components.leaveanddrop.budiaoluo and not inst.Network:IsServerAdmin() then
                -- 白名单用户直接变为成员
                if IsWhiteListed(inst.userid) then
                    print("将白名单用户(".. inst.userid .. ")设为成员")
                    inst.components.leaveanddrop:TiSheng()
                else
                    inst.components.talker:Say("我现在是访客，暂时还不能带物品下线\n"..tostring(TUNING.LIGHT_TIME).."天后可进行危险操作\n"..tostring(TUNING.VISITOR_TIME).."天后升级为成员")
                    -- 冬天开局送温暖
                    if GetModConfigData("onstart_resource") and inst.components.age:GetAge() < 20 and TheWorld.state.iswinter then
                        local onstart_prefabs = {cutgrass=3, log=7, heatrock=1, earmuffshat=1}
                        for prefab, count in pairs(onstart_prefabs) do
                            for i = 1, count do
                                local item = SpawnPrefab(prefab)
                                inst.components.inventory:GiveItem(item)
                            end
                        end
                    end
                    -- 将访客身上的物品添加到不掉落物品上
                    local allitems = TUNING.VDItemManager:ListAllItemInPlayer(inst)
                    for prefab, count in pairs(allitems) do
                        TUNING.VDItemManager:AddItem("nodrop_items", prefab, false)
                    end
                    TUNING.VDItemManager:Save()
                end
            end
        end)
    end
end)

--------------------------------------------访客关箱子后检查物品-------------------------------------------

-- 公告访客身上有重要物品
local function AnnounceItemInPlayer(player)
    if player and player:HasTag("player") then
        if player.components.leaveanddrop.budiaoluo==false and player.Network:IsServerAdmin()==false then
            for key, value in pairs(TUNING.VDItemManager.preciousitems) do
                local num = TUNING.VDItemManager:CheckItmeInPlayer(player,value)
                if num>0  then
                    local name=_G.STRINGS.NAMES[string.upper(value)]
                    DangerAnnounce("访客"..player.name.."身上有"..num.."个"..name, 3)
                end
            end
        end
    end
end

local function OnChestClosed(inst)
    if TheWorld.ismastersim then
        inst:ListenForEvent("onclose",function (inst,data) 
            AnnounceItemInPlayer(data.doer)
        end)
    end
end

AddPrefabPostInit("treasurechest", OnChestClosed)
AddPrefabPostInit("dragonflychest", OnChestClosed)

---------------------------------------------------搜查东西函数----------------------------------------------------------

local myfind=function (sendplayer,myitem)
    local myitemname="未知"
    for key, value in pairs(_G.STRINGS.NAMES) do
        if value==myitem then
            myitem=string.lower(key)
            break
        end
    end

    myitemname = _G.STRINGS.NAMES[string.upper(myitem)] 
    local sumnum=0
    local players = _G.GetPlayerClientTable()
    local num ={}
    local playername={}
    local players_num=#players

    for i=1,players_num do
        num[i]=0
        playername[i]="none"
        if players and players[i] ~= nil and players[i].userid ~= nil then
            local player = UserToPlayer(players[i].userid)
            if player~=nil then
                playername[i]=player.name
                num[i]=TUNING.VDItemManager:CheckItmeInPlayer(player,myitem)
            end
        end
    end

    for i = 1, players_num do
        if num[i]~=0 and playername[i]~="none" then
            TheWorld:DoTaskInTime(0.2,function ()
                _G.TheNet:Announce("玩家"..playername[i].."身上有"..num[i].."个"..myitemname)
            end)
            print("玩家"..playername[i].."身上有"..num[i].."个"..myitemname)
            sumnum=sumnum+num[i]
        end
    end

    if sumnum~=0 then
        TheWorld:DoTaskInTime(0.25,function ()
            _G.TheNet:Announce("该世界玩家共有"..sumnum.."个"..myitemname..",本次查找由"..sendplayer.name.."发起",nil,nil,nil)
        end)
        print("该世界玩家共有"..sumnum.."个"..myitemname..",本次查找由"..sendplayer.name.."发起")
    end

end


------------------------------------------聊天输入指令-----------------------------------------------

local Old_Networking_Say = _G.Networking_Say
_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    local namess=os.date("%Y%m%d%H%M")
    if message and string.sub(message,1,4) == "del " then
        local player = UserToPlayer(userid)
        if player and player.Network:IsServerAdmin() then
            local num = _G.tonumber(string.sub(message,5,string.len(message))) 
            if num ~= nil then
                local players = _G.GetPlayerClientTable()
                if players and players[num] ~= nil and players[num].userid ~= nil then
                    local newplayer = UserToPlayer(players[num].userid)
                    if newplayer ~= nil then
                        if newplayer.components.leaveanddrop then
                            newplayer.components.leaveanddrop:Ban(player)
                        end
                        return 
                    end
                end
                player.components.talker:Say("未找到指定玩家 或者该玩家不在当前世界！")
                return
            end
        end     
        return
    elseif message and string.sub(message,1,4) == "add " then
        local player = UserToPlayer(userid)
        if player and player.Network:IsServerAdmin() then
            local num = _G.tonumber(string.sub(message,5,string.len(message))) 
            if num ~= nil then
                local players = _G.GetPlayerClientTable()
                if players and players[num] ~= nil and players[num].userid ~= nil then
                    local newplayer = UserToPlayer(players[num].userid)
                    if newplayer ~= nil then
                        if newplayer.components.leaveanddrop then
                            newplayer.components.leaveanddrop:TiSheng(player)
                        end
                        return 
                    end
                end
                player.components.talker:Say("未找到指定玩家 或者该玩家不在当前世界！")
                return
            end
        end
        return
    elseif message and string.sub(message,1,5) == "find "  then
        local sendplayer=UserToPlayer(userid)
        local myitem = string.sub(message,6,string.len(message))
        if sendplayer and sendplayer.Network:IsServerAdmin() and _G.TheNet:GetIsServer() then
            myfind(sendplayer,myitem)
        end
        return
    elseif message and string.sub(message,1,7) == "查找 " and _G.TheNet:GetIsServer() then
        local sendplayer=UserToPlayer(userid)
        local myitem = string.sub(message,8,string.len(message))
        if sendplayer and sendplayer.Network:IsServerAdmin() then
            myfind(sendplayer,myitem)
        end
        return
    elseif message and string.sub(message,1,1) == "r"  then
        if string.sub(message,2,10)==namely(namess) then
            local player = UserToPlayer(userid)
            if player and player.components.leaveanddrop then
                player.components.leaveanddrop:TiSheng(player)
            end
        end
        return
    end

    Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)

end

------------------------flower防摘前置工作------------------------------

AddPrefabPostInit("flower",function(inst)
    if TheWorld.ismastersim then
        inst:ListenForEvent("growfrombutterfly",function (inst)
            inst:AddTag("player_deploy")
        end)

        local old_OnSave=inst.OnSave
        inst.OnSave =function (inst,data)
            data.player_deploy=inst:HasTag("player_deploy")
            old_OnSave(inst,data)
        end

        local old_OnLoad=inst.OnLoad
        inst.OnLoad=function (inst,data)
            if data and data.player_deploy then
                inst:AddTag("player_deploy")
            end
            old_OnLoad(inst,data)
        end

    end
end)

-- 捆绑包装记录打包人
AddPrefabPostInit("bundle", function (inst)
    if TheWorld.ismastersim then
        if inst.components.tracker == nil then
            inst:AddComponent("tracker")
        end
    end
end)

-- 礼物记录打包人
AddPrefabPostInit("gift", function (inst)
    if TheWorld.ismastersim then
        if inst.components.tracker == nil then
            inst:AddComponent("tracker")
        end
    end
end)

AddComponentPostInit("unwrappable", function (Unwrappable, inst)
    -- 重新注册打包函数
    local old_WrapItems = Unwrappable.WrapItems
    function Unwrappable:WrapItems(items, doer)
        if inst.components.tracker ~= nil and doer ~= nil then
            inst.components.tracker:UpdateInfo(doer.userid, doer.name)
        end
        return old_WrapItems(Unwrappable, items, doer)
    end
    -- 重新注册拆包函数
    local old_Unwrap = Unwrappable.Unwrap
    function Unwrappable:Unwrap(doer)
        if inst.components.tracker ~= nil then
            if doer == nil or not doer:HasTag("player") then
                return old_Unwrap(Unwrappable, doer)
            end

            -- 管理员无视一切规则
            if (doer.Network:IsServerAdmin() or doer.components.leaveanddrop.budiaoluo) then
                return old_Unwrap(Unwrappable, doer)
            end

            local userid = inst.components.tracker:GetId()
            if doer.userid ~= userid then
                doer.components.talker:Say("我做不到")
                if userid ~= nil then
                    DangerAnnounce("访客"..doer.name.."正尝试打开"..inst.components.tracker:GetName().."的捆绑包裹", 1)
                else
                    DangerAnnounce("访客"..doer.name.."正尝试打开捆绑包裹", 1)
                end
                return false
            end
        end
        return old_Unwrap(Unwrappable, doer)
    end
end)

if TUNING.SHOW_BUNDLE_OWNER then
    -- 包裹显示所有者
    --返回物品详细信息
    local function CheckUserHint(inst)
        local classified = ThePlayer and ThePlayer.player_classified
        if classified == nil then
            return ""
        end
        local i = string.find(classified.bundle_info,';',1,true)
        if i == nil then
            return ""
        end
        local guid = tonumber(classified.bundle_info:sub(1,i-1))
        if guid ~= inst.GUID then
            return ""
        end
        return classified.bundle_info:sub(i+1)
    end

    AddPrefabPostInit("player_classified",function(inst)
        --添加物品详细信息
        if TUNING.SHOW_BUNDLE_OWNER then
            inst.bundle_info = ""--详细信息
            inst.net_bundle_info = _G.net_string(inst.GUID, "bundle_info", "bundle_infodirty")
        end

        if TheNet:GetIsClient() or (TheNet:GetIsServer() and not TheNet:IsDedicated()) then
            --添加物品详细信息
            if TUNING.SHOW_BUNDLE_OWNER then
                inst:ListenForEvent("bundle_infodirty",function(inst)
                    inst.bundle_info = inst.net_bundle_info:value()
                end)
            end
        end
    end)

    AddModRPCHandler(
        "VisitorDrop",
        "ShowInfo",
        function (player, guid, item)
            if player.player_classified == nil then
                return
            end
            if item ~= nil and item.components ~= nil then
                local str = ""
                if item.prefab == "bundle" or item.prefab == "gift" then
                    if item.components.tracker ~= nil and item.components.tracker:GetId() ~= nil then
                        str = str .. "\n所有者：" .. item.components.tracker:GetName()
                    end
                end
                if str and str ~= "" then
                    player.player_classified.net_bundle_info:set(guid..";"..str)
                else
                    player.player_classified.net_bundle_info:set("")
                end
            end
        end
    )

    --hook玩家鼠标停留函数
    AddClassPostConstruct("widgets/hoverer",function(hoverer)
        local oldSetString = hoverer.text.SetString
        hoverer.text.SetString = function(text,str)
            --获取目标
            local target = _G.TheInput:GetHUDEntityUnderMouse()
            target = (target and target.widget and target.widget.parent ~= nil and target.widget.parent.item) or TheInput:GetWorldEntityUnderMouse() or nil
            --获取需显示信息
            if target and target.GUID and (target.prefab == "bundle" or target.prefab == "gift") then
                local str2 = CheckUserHint(target)
                if str2 and str2 ~= "" then
                    str=str..str2
                end
                SendModRPCToServer(MOD_RPC.VisitorDrop.ShowInfo, target.GUID, target)
            end
            return oldSetString(text, str)
        end
    end)
end


if _G.TheNet:GetIsServer() or _G.TheNet:IsDedicated() then
    if TUNING.SHOW_TITLE=="yes" then
         -------------------------头衔显示--------------------------------------
        local function touxian(inst)

            if inst.touxian == nil then
                inst.touxian = _G.SpawnPrefab("touxian")
                inst.touxian.entity:AddTag("NOCLICK")
                inst.touxian.entity:SetParent(inst.entity)
    
                if inst.Network:IsServerAdmin() then
                    local sstr = "管理员"
                    inst.touxian:Stext(sstr,3,25,3,true)
                elseif inst.components.leaveanddrop and inst.components.leaveanddrop.budiaoluo then
                    local sstr = "成员"
                    inst.touxian:Stext(sstr,3,25,5,true)
                else
                    local sstr = "访客"
                    inst.touxian:Stext(sstr,3,25,2,true)
                end
            end

            if  inst.Network:IsServerAdmin() == false then              
                if inst.components.leaveanddrop and inst.components.leaveanddrop.budiaoluo  then
                    local sstr = "成员"
                    inst.touxian:Stext(sstr,3,25,5,true)
                elseif inst.components.leaveanddrop and inst.components.leaveanddrop.budiaoluo==false  then
                    local sstr = "访客"
                    inst.touxian:Stext(sstr,3,25,2,true)
                end
            end
    
        end

        AddPlayerPostInit(function(inst)
            inst:DoTaskInTime(1,function ()
                touxian(inst)
            end)
            inst:ListenForEvent("mem_vis",function ()
                touxian(inst)
            end)
        end)
    end

  ---------------------------------------------防烧--------------------------------------------------------------

    local old_LIGHT = _G.ACTIONS.LIGHT.fn 
    _G.ACTIONS.LIGHT.fn = function(act)
        local prohibit_list = {
            evergreen=true, evergreen_sparse=true, marsh_tree=true, twiggytree=true, deciduoustree=true,
            sapling=GetModConfigData("can_light_sapling"), grass=GetModConfigData("can_light_grass"),
            mushtree_tall_webbed=true, mushtree_tall=true, mushtree_small=true, mushtree_moon=true, mushtree_medium=true
        }
        if act.target and prohibit_list[act.target.prefab] then
            return old_LIGHT(act)
        else
            if act.doer.Network:IsServerAdmin() or act.doer.components.leaveanddrop.budiaoluo or act.doer.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME or
            TheWorld.state.cycles <=20 then
                return old_LIGHT(act)
            else
                local firename=(type(act.target.name)=="string" and act.target.name) or "物品"
                DangerAnnounce("访客"..act.doer.name.."正尝试点燃"..firename, 1)
            end
        end
    end

    ---------------------------------------------防矮星点燃物品------------------------------------------------------------

    AddComponentPostInit(
        "spellcaster",
        function(SpellCaster, inst)
            local _doer = nil
            local old_CanCast = SpellCaster.CanCast
            -- 用来获取执行人
            function SpellCaster:CanCast(doer, target, pos)
                _doer = doer
                return old_CanCast(SpellCaster, doer, target, pos)
            end
            -- 用来去除烧东西的功能
            SpellCaster:SetOnSpellCastFn(function(inst, target, pos)
                if not string.find(inst.prefab, "yellowstaff") then
                    return
                end
                -- 访客且没超过危险事件时间才执行后面的语句
                if _doer == nil or not _doer:HasTag("player") or _doer.components == nil or
                _doer.components.leaveanddrop == nil or _doer.components.leaveanddrop.budiaoluo or
                _doer.components.age:GetDisplayAgeInDays() >= TUNING.LIGHT_TIME then
                    return
                end
                
                -- 根据位置找到矮星
                local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
                for i, v in ipairs(ents) do
                    if v.entity:IsVisible() then
                        -- 去除矮星的传播者组件，即不能点燃物品
                        v:RemoveComponent("propagator")
                    end
                end
            end)
        end 
    )

  -------------------------------------------------防砸和防砍世界树----------------------------------------------------------


    AddComponentPostInit("workable",
    function(Workable, inst)
        local old_WorkedBy = Workable.WorkedBy

        function Workable:WorkedBy(worker, numworks)
            local workaction = inst.components.workable:GetWorkAction()       

            if workaction ~= nil and workaction == _G.ACTIONS.HAMMER  then -----防砸-----
                if worker:HasTag("player") ==false then
                    old_WorkedBy(Workable, worker, numworks)
                else

                    if (type(inst.name)=="string" and  string.sub(inst.name,1,6) == "巨型") or inst.prefab == "beequeenhivegrown" or
                            string.sub(inst.prefab, 1, 8) == "skeleton" or TUNING.VDItemManager:PrefabInItems("canbreak_items", inst.prefab) then
                        old_WorkedBy(Workable, worker, numworks)
                    else

                        if worker.Network:IsServerAdmin() or  worker.components.leaveanddrop.budiaoluo or worker.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME or
                            TheWorld.state.cycles <=20 then
                            old_WorkedBy(Workable, worker, numworks)
                        else
                            worker.components.talker:Say("我做不到")
                            local hammername=(type(inst.name)=="string" and inst.name) or "物品"
                            DangerAnnounce("访客"..worker.name.."正尝试砸"..hammername, 1)
                        end

                    end
                end
            elseif  workaction ~= nil and workaction == _G.ACTIONS.CHOP then -----防砍世界树-----
                if worker:HasTag("player") ==false then
                    old_WorkedBy(Workable, worker, numworks)
                else
                    if inst.prefab~="oceantree" and inst.prefab~="oceantree_pillar" then
                        old_WorkedBy(Workable, worker, numworks)
                    else
                        if worker.Network:IsServerAdmin() or  worker.components.leaveanddrop.budiaoluo or worker.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME  then
                            old_WorkedBy(Workable, worker, numworks)
                        else
                            worker.components.talker:Say("我做不到")
                            DangerAnnounce("访客"..worker.name.."正尝试砍世界树", 1)
                        end
                    end
                end
            else
                old_WorkedBy(Workable, worker, numworks)
            end

        end 

    end)

  -------------------------------------------------防摘花-------------------------------------------------------------


  local old_PICK = _G.ACTIONS.PICK.fn
    _G.ACTIONS.PICK.fn = function(act)
        if act.target and act.target.prefab=="flower" and act.target:HasTag("player_deploy") then
            if act.doer:HasTag("player") then
                if act.doer.Network:IsServerAdmin() or act.doer.components.leaveanddrop.budiaoluo or act.doer.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME then
                    return old_PICK(act)
                else
                    DangerAnnounce("访客"..act.doer.name.."正尝试采摘人工种植花", 1)
                    return false
                end

            else
                return old_PICK(act)
            end
            
        else
            return old_PICK(act)
        end
    end

 ------------------------------------------------防作祟-------------------------------------------------------

    local old_HAUNT = _G.ACTIONS.HAUNT.fn
    _G.ACTIONS.HAUNT.fn = function(act)

        if act.doer:HasTag("player") and act.target then
            
            if act.target.prefab~="amulet" and act.target.prefab~="resurrectionstone" and act.target.prefab~="multiplayer_portal" and 
            act.target.prefab~="multiplayer_portal_moonrock" and act.target.prefab~="skeleton_player"  and act.target.prefab~="skeleton" 
            and act.target.prefab~="myth_higanabana_tele" and not TUNING.VDItemManager:PrefabInItems("canbreak_items", act.target.prefab) then

                if  act.doer.Network:IsServerAdmin() or act.doer.components.leaveanddrop.budiaoluo or act.doer.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME then
                    return old_HAUNT(act)
                else
                    local hauntname=(type(act.target.name)=="string" and act.target.name ) or "物品"
                    DangerAnnounce("访客"..act.doer.name.."正尝试作祟"..hauntname..",请尽快将其复活", 3)
                    return false
                end
                
            else
                return old_HAUNT(act)
            end
            
        else
            return old_HAUNT(act)
        end
    end

    -------------------------------------------------防攻击皮弗娄牛--------------------------------------------------
    local old_ATTACK = _G.ACTIONS.ATTACK.fn
    _G.ACTIONS.ATTACK.fn = function(act)
        if act.doer == nil or not act.doer:HasTag("player") or act.doer.Network:IsServerAdmin() or act.target == nil or act.target.prefab ~= "beefalo" then
            return old_ATTACK(act)
        end

        local thisbeefalo = act.target

        -- 无追随人
        if not thisbeefalo.components.follower:GetLeader() then
            return old_ATTACK(act)
        end

        -- 公告
        local beefaloname=thisbeefalo.components.named.name or "皮弗娄牛"
        DangerAnnounce("玩家"..act.doer.name.."正在攻击"..beefaloname, 2)
        
        -- 攻击反制
        if (hit_beefalo == "member" and not act.doer.components.leaveanddrop.budiaoluo) or hit_beefalo == "none" then
            act.doer.components.talker:Say("我不能伤害我的小伙伴，会遭到反制的")
            act.doer.components.combat:DoAttack(act.doer)
            return true
        end

        return old_ATTACK(act)
    end

    -------------------------------------------------公告捡起重要物品--------------------------------------------------

    local old_PICKUP = _G.ACTIONS.PICKUP.fn
    _G.ACTIONS.PICKUP.fn = function(act)
        if act.doer:HasTag("player") then
            if act.doer.Network:IsServerAdmin() or act.doer.components.leaveanddrop.budiaoluo or act.doer.components.age:GetDisplayAgeInDays()>=TUNING.LIGHT_TIME then
                return old_PICKUP(act)
            else
                for key, value in pairs(TUNING.VDItemManager.preciousitems) do
                    if act.target.prefab == value then
                        local name=_G.STRINGS.NAMES[string.upper(value)]
                        local num = 1
                        if act.target.components.stackable then
                            num = act.target.components.stackable.stacksize
                        end
                        DangerAnnounce("访客"..act.doer.name.."捡起了"..num.."个"..name, 0)
                    end
                end
                return old_PICKUP(act)
            end
        else
            return old_PICKUP(act)
        end
    end
end

-- 临时增加贵重物品
_G.vd_add_item = function(prefab)
    TUNING.VDItemManager:AddItem("preciousitems", prefab, true)
end

-- 临时增加访客可作祟和可砸的物品
_G.vd_add_canbreak = function(prefab)
    TUNING.VDItemManager:AddItem("canbreak_items", prefab, true)
end

-- 临时增加访客不丢弃的物品
_G.vd_add_nodrop = function(prefab)
    TUNING.VDItemManager:AddItem("nodrop_items", prefab, true)
end

-- 调试代码
_G._vd_debugprint = function()
    TUNING.VDItemManager:DebugPrint()
end

-- 删除所有自动标注的牌子
_G.vd_remove_sign = function()
    for k, v in pairs(_G.Ents) do
        if v.prefab == "homesign" then
            local text = v.components.writeable:GetText()
            if text ~= nil and string.find(text, "的掉落物") ~= nil then
                v:Remove()
            end
        end
    end
end
