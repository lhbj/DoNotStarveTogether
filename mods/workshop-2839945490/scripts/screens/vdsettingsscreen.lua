local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local PopupDialogScreen = require "screens/redux/popupdialog"
local InputDialogScreen = require "screens/inputdialog"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

-- 通过译名或预制物代码来获取实际的预制物代码
local function get_item_prefab(itemname)
    for key, value in pairs(STRINGS.NAMES) do
        if string.lower(key) == string.lower(itemname) or value == itemname then
            return string.lower(key)
        end
    end
    return ""
end

local VDSettingsScreen = Class(Screen, function(self, owner, attach)
    Screen._ctor(self, "VDSettingsScreens")

    self.owner = owner
    self.attach = attach

    self.isopen = false

    self._scrnw, self._scrnh = TheSim:GetScreenSize()--屏幕宽高

    self:SetScaleMode(SCALEMODE_PROPORTIONAL)--等比缩放模式
    self:SetMaxPropUpscale(MAX_HUD_SCALE)--设置界面最大比例上限
    self:SetPosition(0, 0, 0)--设置坐标
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetHAnchor(ANCHOR_MIDDLE)

    self.scalingroot = self:AddChild(Widget("vddeliveryscalingroot"))
    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
    --监听从暂停状态恢复到继续状态，更新尺寸
    self.inst:ListenForEvent(
        "continuefrompause",
        function()
            if self.isopen then
                self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
            end
        end,
        TheWorld
    )
    --监听界面尺寸变化，更新尺寸
    self.inst:ListenForEvent(
        "refreshhudsize",
        function(hud, scale)
            if self.isopen then
                self.scalingroot:SetScale(scale)
            end
        end,
        owner.HUD.inst
    )

    self.root = self.scalingroot:AddChild(TEMPLATES.ScreenRoot("root"))

    -- secretly this thing is a modal Screen, it just LOOKS like a widget
    --全屏全透明背景板，点了直接关闭界面
    self.black = self.root:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black:SetTint(0, 0, 0, 0)
    self.black.OnMouseButton = function()
        self:OnCancel()
    end
    --总界面
    self.destspanel = self.root:AddChild(TEMPLATES.CurlyWindow(200, 360))
    self.destspanel:SetPosition(0, 25)
    --标题
    self.current = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
    self.current:SetPosition(0, 200, 0)--坐标
    self.current:SetRegionSize(250, 50)--设置区域大小
    self.current:SetHAlign(ANCHOR_MIDDLE)
    self.current:SetString("访客掉落工具箱")
    self.current:SetColour(1, 1, 1, 1)--默认颜色

    self:LoadButton()

    self:Show()--显示
    self.isopen = true--开启

    SetAutopaused(true)
end)

--按钮信息
local button_data={
    {
        name="command_helptext",
        text="快捷指令",
    },
    {
        name="add_item",
        text="添加贵重物品",
        fn=function(self)
            self:ShowInputDialog("vd_add_item")
        end
    },
    {
        name="add_canbreak",
        text="添加可砸可作祟物品",
        fn=function(self)
            self:ShowInputDialog("vd_add_canbreak")
        end
    },
    {
        name="add_nodrop",
        text="添加不丢弃物品",
        fn=function(self)
            self:ShowInputDialog("vd_add_nodrop")
        end
    },
    {
        name="remove_sign",
        text="删除所有自动生成的木牌",
        fn=function(self)
            local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
            TheNet:SendRemoteExecute("vd_remove_sign()", x, z)
            self:OnCancel()
        end
    },
    {
        name="usermanager_helptext",
        text="用户管理",
    },
    {
        name="set_user_power",
        text="设置用户权限",
        fn=function(self)
            self:OnCancel()
            ThePlayer.HUD:ShowVDUserManagerScreen()
        end,
    },
    {--关闭按钮
        name="close_btn",
        text="关闭",
        fn=function(self)
            self:OnCancel()
        end,
        -- 偏移量，可以在前面的按钮后加一些空行
        offset=1
    },
}

-- 显示输入框
function VDSettingsScreen:ShowInputDialog(target_fn)
    local asking_dialog = InputDialogScreen("请填写预制物代码或其中文名称",
        {
            {
                text = "添加",
                cb = function()
                    -- 添加物品到item_manager里
                    local prefab = get_item_prefab(InputDialogScreen:GetText())
                    local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
                    TheNet:SendRemoteExecute(string.format("%s('%s')", target_fn, prefab), x, z)
                    TheFrontEnd:PopScreen()
                    self:OnCancel()
                    if prefab ~= "" and ThePlayer ~= nil and ThePlayer.components ~= nil
                    and ThePlayer.components.talker ~= nil then
                        ThePlayer.components.talker:Say("已添加物品："..(STRINGS.NAMES[string.upper(prefab)] or prefab))
                    end
                end
            },
            {
                text = "取消",
                cb = function()
                    TheFrontEnd:PopScreen()
                end
            },
        }, true)
    -- 自动聚焦
    -- asking_dialog.edit_text:SetEditing(true)
    TheFrontEnd:PushScreen(asking_dialog)
end

--加载设置按钮
function VDSettingsScreen:LoadButton()
	for i, v in ipairs(button_data) do
        if v.spinner_data then
            self[v.name] = self.destspanel:AddChild(
                TEMPLATES.LabelSpinner(
                v.text,
                v.spinner_data.spinnerdata,
                v.spinner_data.width_label,
                v.spinner_data.width_spinner,
                v.spinner_data.height,
                v.spinner_data.spacing,
                v.spinner_data.font,
                v.spinner_data.font_size,
                v.spinner_data.horiz_offset,
                v.spinner_data.onchanged_fn,
                v.spinner_data.colour,
                v.spinner_data.tooltip_text
                )
            )
            if v.spinner_data.selected_fn then
                v.spinner_data.selected_fn(self[v.name].spinner)
            end
        elseif v.fn ~= nil then
            self[v.name] = self.destspanel:AddChild(
                TEMPLATES.StandardButton(
                    --点击按钮执行的函数
                    function()
                        v.fn(self)
                    end,
                    v.text,--按钮文字
                    {200, 40}--按钮尺寸
                )
            )
        else
            self[v.name] = self.destspanel:AddChild(Text(BODYTEXTFONT, 20, v.text, UICOLOURS.SILVER))
        end
        self[v.name]:SetPosition(0, 200 - 40 * (i + (v.offset or 0)))
    end
end

--关闭
function VDSettingsScreen:OnCancel()
	if not self.isopen then
        return
    end
	--关闭界面
    self.owner.HUD:CloseVDSettingsScreen()
end

--其他控制
function VDSettingsScreen:OnControl(control, down)
    if VDSettingsScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down and control == CONTROL_CANCEL then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        SetAutopaused(false)
        return true
    end
	return false
end

--关闭
function VDSettingsScreen:Close()
	if self.isopen then
        self.black:Kill()
        self.isopen = false

        self.inst:DoTaskInTime(
            .2,
            function()
                TheFrontEnd:PopScreen(self)
            end
        )
    end
    SetAutopaused(false)
end

return VDSettingsScreen
