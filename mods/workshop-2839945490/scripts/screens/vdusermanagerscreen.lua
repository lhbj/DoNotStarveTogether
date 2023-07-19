require "util"
local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local PlayerBadge = require "widgets/playerbadge"
local ScrollableList = require "widgets/scrollablelist"
local UserCommandPickerScreen = require "screens/redux/usercommandpickerscreen"

local TEMPLATES = require("widgets/redux/templates")

local list_spacing = 82.5

local REFRESH_INTERVAL = .5

-- 发送远端的访客掉落指令
local function SendVDFnCommand(userid, command)
    local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
    local base_cmdstr = [[
        local player = UserToPlayer('%s')
        if player ~= nil and player.components ~= nil and
        player.components.leaveanddrop ~= nil then
            %s
        end
    ]]
    command = string.format(base_cmdstr, userid, command)
    TheNet:SendRemoteExecute(command, x, z)
end

local VDUserManagerScreen = Class(Screen, function(self, owner)
    Screen._ctor(self, "VDUserManagerScreen")
    self.owner = owner
    self.time_to_refresh = REFRESH_INTERVAL
    self.usercommandpickerscreen = nil
    self.show_player_badge = not TheFrontEnd:GetIsOfflineMode() and TheNet:IsOnlineMode()
end)

function VDUserManagerScreen:OnBecomeActive()
    VDUserManagerScreen._base.OnBecomeActive(self)
    self:DoInit()
    self.time_to_refresh = REFRESH_INTERVAL
    self.scroll_list:SetFocus()

    SetAutopaused(true)
end

function VDUserManagerScreen:OnBecomeInactive()
    SetAutopaused(false)
    VDUserManagerScreen._base.OnBecomeInactive(self)
end

function VDUserManagerScreen:OnDestroy()
    --Overridden so we do part of Widget:Kill() but keeps the screen around hidden
    self:ClearFocus()
    self:StopFollowMouse()
    self:Hide()

    if self.onclosefn ~= nil then
        self.onclosefn()
    end
end

function VDUserManagerScreen:OnControl(control, down)
    if not self:IsVisible() then
        return false
    elseif VDUserManagerScreen._base.OnControl(self, control, down) then
        return true
    elseif not down and control == CONTROL_CANCEL then  -- 按下ESC
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        self:Close()
        return true
    end
    return false
end

function VDUserManagerScreen:OnRawKey(key, down)
    if not self:IsVisible() then
        return false
    elseif VDUserManagerScreen._base.OnRawKey(self, key, down) then
        return true
    end
    return not down
end

function VDUserManagerScreen:Close()
    TheFrontEnd:PopScreen(self)
end

function VDUserManagerScreen:OnUpdate(dt)
    if TheFrontEnd:GetFadeLevel() > 0 then
        self:Close()
    elseif self.time_to_refresh > dt then
        self.time_to_refresh = self.time_to_refresh - dt
    else  -- 用户加入或离开时自动刷新
        self.time_to_refresh = REFRESH_INTERVAL

        local ClientObjs = TheNet:GetClientTable() or {}

        --rebuild if player count changed
        local needs_rebuild = #ClientObjs ~= self.numPlayers

        --rebuild if players changed even though count didn't change
        if not needs_rebuild and self.scroll_list ~= nil then
            for i, client in ipairs(ClientObjs) do
                local listitem = self.scroll_list.items[i]
                if listitem == nil or
                    client.userid ~= listitem.userid or
                    (client.performance ~= nil) ~= (listitem.performance ~= nil) then
                    needs_rebuild = true
                    break
                end
            end
        end

        if needs_rebuild then
            -- We've either added or removed a player
            -- Kill everything and re-init
            self:DoInit(ClientObjs)
        else
            self.serverage = TheWorld.state.cycles + 1
            self.serveragetext:SetString(STRINGS.UI.PLAYERSTATUSSCREEN.AGE_PREFIX..self.serverage)
            if self.scroll_list ~= nil then
                for _,playerListing in ipairs(self.player_widgets) do
                    for _,client in ipairs(ClientObjs) do
                        if playerListing.userid == client.userid and playerListing.ishost == (client.performance ~= nil) then
                            -- 显示名字
                            playerListing.name:SetTruncatedString(self:GetDisplayName(client), playerListing.name._align.maxwidth, playerListing.name._align.maxchars, true)
                            local w, h = playerListing.name:GetRegionSize()
                            playerListing.name:SetPosition(playerListing.name._align.x + w * .5, 0, 0)
                            -- 显示管理员角标
                            playerListing.characterBadge:Set(client.prefab or "", client.colour or DEFAULT_PLAYER_COLOUR, playerListing.ishost, client.userflags or 0, client.base_skin)
                        end
                    end
                end
            end
        end
    end
end

--For ease of overriding in mods
function VDUserManagerScreen:GetDisplayName(clientrecord)
    return clientrecord.name or ""
end

function VDUserManagerScreen:DoInit(ClientObjs)
    if not self.black then
        --darken everything behind the dialog
        --bleed outside the screen a bit, otherwise it may not cover
        --the edge of the screen perfectly when scaled to some sizes
        local bleeding = 4
        self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
        self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
        self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
        self.black.image:SetVAnchor(ANCHOR_MIDDLE)
        self.black.image:SetHAnchor(ANCHOR_MIDDLE)
        self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.black.image:SetTint(0,0,0,0) -- invisible, but clickable!

	    self.black:SetHelpTextMessage("")
	    self.black:SetOnClick(function() TheFrontEnd:PopScreen(self) end)
		self.black:MoveToBack()
    end

    if not self.root then
        self.root = self:AddChild(Widget("ROOT"))
        self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
        self.root:SetHAnchor(ANCHOR_MIDDLE)
        self.root:SetVAnchor(ANCHOR_MIDDLE)
    end

    if not self.bg then
        self.bg = self.root:AddChild(Image( "images/scoreboard.xml", "scoreboard_frame.tex" ))
        self.bg:SetScale(.96,.9)
    end

    if not self.screentitle then
        self.screentitle = self.root:AddChild(Text(UIFONT,45))
        self.screentitle:SetColour(1,1,1,1)
        self.screentitle:SetPosition(0,215)
    end
    self.screentitle:SetString("用户权限管理面板")

    if not self.serveragetext then
        self.serveragetext = self.root:AddChild(Text(UIFONT,30))
        self.serveragetext:SetColour(1,1,1,1)
        self.serveragetext:SetPosition(0,175)
    end
    self.serverage = TheWorld.state.cycles + 1
    self.serveragetext:SetString(STRINGS.UI.PLAYERSTATUSSCREEN.AGE_PREFIX..self.serverage)

    if ClientObjs == nil then
        ClientObjs = TheNet:GetClientTable() or {}
    end
    self.numPlayers = #ClientObjs

    if not self.players_number then
        self.players_number = self.root:AddChild(Text(UIFONT, 25))
        self.players_number:SetPosition(318,160)
        self.players_number:SetSize(20)
        self.players_number:SetRegionSize(100,30)
        self.players_number:SetHAlign(ANCHOR_RIGHT)
        self.players_number:SetColour(1,1,1,1)
    end
    self.players_number:SetString(tostring(not TheNet:GetServerIsClientHosted() and self.numPlayers - 1 or self.numPlayers).."/"..(TheNet:GetServerMaxPlayers() or "?"))

    if not self.divider then
        self.divider = self.root:AddChild(Image("images/scoreboard.xml", "white_line.tex"))
        self.divider:SetPosition(0,155)
    end

    if not self.helptext then
        self.helptext = self.root:AddChild(Text(UIFONT,25))
        self.helptext:SetPosition(20,-250,0)
        self.helptext:SetColour(1,1,1,1)
        self.bg:SetScale(.95,.95)
        self.bg:SetPosition(0,-10)
    end

    local function doButtonFocusHookups(playerListing)
        local buttons = {}

        local focusforwardset = false
        for i,button in ipairs(buttons) do
            if not focusforwardset then
                focusforwardset = true
                playerListing.focus_forward = button
            end
            if buttons[i-1] then
                button:SetFocusChangeDir(MOVE_LEFT, buttons[i-1])
            end
            if buttons[i+1] then
                button:SetFocusChangeDir(MOVE_RIGHT, buttons[i+1])
            end
        end
    end

    local function listingConstructor(i, parent)
        local playerListing =  parent:AddChild(Widget("playerListing"))

        playerListing.highlight = playerListing:AddChild(Image("images/scoreboard.xml", "row_goldoutline.tex"))
        playerListing.highlight:SetPosition(22, 5)
        playerListing.highlight:Hide()

        if self.show_player_badge then
            playerListing.profileFlair = playerListing:AddChild(TEMPLATES.RankBadge())
            playerListing.profileFlair:SetPosition(-388,-14,0)
            playerListing.profileFlair:SetScale(.6)
        end

        playerListing.characterBadge = nil
        playerListing.characterBadge = playerListing:AddChild(PlayerBadge("", DEFAULT_PLAYER_COLOUR, false, 0))
        playerListing.characterBadge:SetScale(.8)
        playerListing.characterBadge:SetPosition(-328,5,0)
        playerListing.characterBadge:Hide()

        playerListing.number = playerListing:AddChild(Text(UIFONT, 35))
        playerListing.number:SetPosition(-422,0,0)
        playerListing.number:SetHAlign(ANCHOR_MIDDLE)
        playerListing.number:SetColour(1,1,1,1)
        playerListing.number:Hide()

        playerListing.adminBadge = playerListing:AddChild(ImageButton("images/avatars.xml", "avatar_admin.tex", "avatar_admin.tex", "avatar_admin.tex", nil, nil, {1,1}, {0,0}))
        playerListing.adminBadge:Disable()
        playerListing.adminBadge:SetPosition(-355,-13,0)
        playerListing.adminBadge.image:SetScale(.3)
        playerListing.adminBadge.scale_on_focus = false
        playerListing.adminBadge:SetHoverText(STRINGS.UI.PLAYERSTATUSSCREEN.ADMIN, { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 30, colour = {1,1,1,1}})
        playerListing.adminBadge:Hide()

        playerListing.name = playerListing:AddChild(Text(UIFONT, 35, ""))
        playerListing.name._align = {
            maxwidth = 215,
            maxchars = 36,
            x = -286,
        }

        playerListing.role = playerListing:AddChild(Text(UIFONT, 35, ""))
        playerListing.role:SetPosition(-20,0,0)
        playerListing.role:SetHAlign(ANCHOR_MIDDLE)

        playerListing.viewprofile = playerListing:AddChild(ImageButton("images/scoreboard.xml", "addfriend.tex", "addfriend.tex", "addfriend.tex", "addfriend.tex", nil, {1,1}, {0,0}))
        playerListing.viewprofile:SetPosition(120,3,0)
        playerListing.viewprofile:SetNormalScale(0.39)
        playerListing.viewprofile:SetFocusScale(0.39*1.1)
        playerListing.viewprofile:SetFocusSound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
        playerListing.viewprofile:SetHoverText(STRINGS.UI.PLAYERSTATUSSCREEN.VIEWPROFILE, { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 30, colour = {1,1,1,1}})

        playerListing.resetbtn = playerListing:AddChild(ImageButton("images/screen_btn_reset.xml", "screen_btn_reset.tex", "screen_btn_reset.tex", "screen_btn_reset.tex", "screen_btn_reset.tex", nil, {1,1}, {0,0}))
        playerListing.resetbtn:SetPosition(170,3,0)
        playerListing.resetbtn:SetNormalScale(0.39)
        playerListing.resetbtn:SetFocusScale(0.39*1.1)
        playerListing.resetbtn:SetFocusSound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
        playerListing.resetbtn:SetHoverText("重置为默认", { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 30, colour = {1,1,1,1}})

        playerListing.upgradebtn = playerListing:AddChild(ImageButton("images/screen_btn_upgrade.xml", "screen_btn_upgrade.tex", "screen_btn_upgrade.tex", "screen_btn_upgrade.tex", "screen_btn_upgrade.tex", nil, {1,1}, {0,0}))
        playerListing.upgradebtn:SetPosition(220,3,0)
        playerListing.upgradebtn:SetNormalScale(0.39)
        playerListing.upgradebtn:SetFocusScale(0.39*1.1)
        playerListing.upgradebtn:SetFocusSound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
        playerListing.upgradebtn:SetHoverText("提升为成员", { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 30, colour = {1,1,1,1}})

        playerListing.banbtn = playerListing:AddChild(ImageButton("images/screen_btn_ban.xml", "screen_btn_ban.tex", "screen_btn_ban.tex", "screen_btn_ban.tex", "screen_btn_ban.tex", nil, {1,1}, {0,0}))
        playerListing.banbtn:SetPosition(270,3,0)
        playerListing.banbtn:SetNormalScale(0.39)
        playerListing.banbtn:SetFocusScale(0.39*1.1)
        playerListing.banbtn:SetFocusSound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
        playerListing.banbtn:SetHoverText("降级为访客", { font = NEWFONT_OUTLINE, offset_x = 0, offset_y = 30, colour = {1,1,1,1}})

        playerListing.OnGainFocus = function()
            playerListing.highlight:Show()
        end
        playerListing.OnLoseFocus = function()
            playerListing.highlight:Hide()
        end

        return playerListing
    end

    local function UpdatePlayerListing(playerListing, client, i)
        if client == nil or GetTableSize(client) == 0 then
            playerListing:Hide()
            return
        end

        playerListing:Show()

        playerListing.displayName = self:GetDisplayName(client)

        playerListing.userid = client.userid

        if self.show_player_badge then
            if client.netid ~= nil then
                local _, _, _, profileflair, rank = GetSkinsDataFromClientTableData(client)
                playerListing.profileFlair:SetRank(profileflair, rank)
                playerListing.profileFlair:Show()
            else
                playerListing.profileFlair:Hide()
            end
        end

        playerListing.characterBadge:Set(client.prefab or "", client.colour or DEFAULT_PLAYER_COLOUR, client.performance ~= nil, client.userflags or 0, client.base_skin)
        playerListing.characterBadge:Show()

        if client.admin then
            playerListing.adminBadge:Show()
        else
            playerListing.adminBadge:Hide()
        end

        local visible_index = i
        if not TheNet:GetServerIsClientHosted() then
            playerListing.number:SetString(i-1)
            visible_index = i-1
            if i > 1 then
                playerListing.number:Show()
            else
                playerListing.number:Hide()
            end
        else
            playerListing.number:SetString(i)
        end

        playerListing.role:Hide()

        playerListing.name:SetTruncatedString(playerListing.displayName, playerListing.name._align.maxwidth, playerListing.name._align.maxchars, true)
        local w, h = playerListing.name:GetRegionSize()
        playerListing.name:SetPosition(playerListing.name._align.x + w * .5, 0, 0)
        playerListing.name:SetColour(unpack(client.colour or DEFAULT_PLAYER_COLOUR))

        local button_start = 50
        local button_x = button_start
        local button_x_offset = 42

        -- 查看玩家
        playerListing.viewprofile:SetOnClick(
            function()
                TheFrontEnd:PopScreen()
                self.owner.HUD:TogglePlayerAvatarPopup(playerListing.displayName, client, true, true)
            end)
        -- 重置为默认
        playerListing.resetbtn:SetOnClick(
            function()
                SendVDFnCommand(client.userid, "player.components.leaveanddrop:Reset()")
                self.helptext:SetString("成功将"..client.name.."重置为默认访客掉落状态")
            end)
        -- 提升为成员
        playerListing.upgradebtn:SetOnClick(
            function()
                SendVDFnCommand(client.userid, "player.components.leaveanddrop:TiSheng()")
                self.helptext:SetString("成功将"..client.name.."升级为成员")
            end)
        -- 降级为访客
        playerListing.banbtn:SetOnClick(
            function()
                SendVDFnCommand(client.userid, "player.components.leaveanddrop:Ban()")
                self.helptext:SetString("成功将"..client.name.."降级为访客")
            end)

        local this_user_is_dedicated_server = client.performance ~= nil and not TheNet:GetServerIsClientHosted()

        if not this_user_is_dedicated_server then
            playerListing.viewprofile:Show()
            playerListing.viewprofile:SetPosition(button_x,3,0)
            button_x = button_x + button_x_offset * 2
        else
            playerListing.viewprofile:Hide()
        end
        if not this_user_is_dedicated_server and not client.admin then
            playerListing.resetbtn:Show()
            playerListing.resetbtn:SetPosition(button_x,3,0)
            button_x = button_x + button_x_offset
            playerListing.upgradebtn:Show()
            playerListing.upgradebtn:SetPosition(button_x,3,0)
            button_x = button_x + button_x_offset
            playerListing.banbtn:Show()
            playerListing.banbtn:SetPosition(button_x,3,0)
            button_x = button_x + button_x_offset
        else
            playerListing.resetbtn:Hide()
            playerListing.upgradebtn:Hide()
            playerListing.banbtn:Hide()
        end

        doButtonFocusHookups(playerListing)
    end

    if not self.scroll_list then
        self.list_root = self.root:AddChild(Widget("list_root"))
        self.list_root:SetPosition(210, -35)

        self.row_root = self.root:AddChild(Widget("row_root"))
        self.row_root:SetPosition(210, -35)

        self.player_widgets = {}
        for i=1,6 do
            table.insert(self.player_widgets, listingConstructor(i, self.row_root))
            UpdatePlayerListing(self.player_widgets[i], ClientObjs[i] or {}, i)
        end

        self.scroll_list = self.list_root:AddChild(ScrollableList(ClientObjs, 380, 370, 60, 5, UpdatePlayerListing, self.player_widgets, nil, nil, nil, -15))
        self.scroll_list:LayOutStaticWidgets(-15)
        self.scroll_list:SetPosition(0,-10)

        self.focus_forward = self.scroll_list
        self.default_focus = self.scroll_list
    else
        self.scroll_list:SetList(ClientObjs)
    end

    if not self.bgs then
        self.bgs = {}
    end
    if #self.bgs > #ClientObjs then
        for i = #ClientObjs + 1, #self.bgs do
            table.remove(self.bgs):Kill()
        end
    else
        local maxbgs = math.min(self.scroll_list.widgets_per_view, #ClientObjs)
        if #self.bgs < maxbgs then
            for i = #self.bgs + 1, maxbgs do
                local bg = self.scroll_list:AddChild(Image("images/scoreboard.xml", "row.tex"))
                bg:SetTint(1, 1, 1, (i % 2) == 0 and .85 or .5)
                bg:SetPosition(-170, 165 - 65 * (i - 1))
                bg:MoveToBack()
                table.insert(self.bgs, bg)
            end
        end
    end
end

return VDUserManagerScreen
