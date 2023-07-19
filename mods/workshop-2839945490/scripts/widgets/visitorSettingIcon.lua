local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local visitorSettingIcon = Class(Widget, function(self, owner)
	Widget._ctor(self, "visitorSettingIcon")
	if owner.Network:IsServerAdmin() then
		self.root = self:AddChild(Widget("ROOT"))
		self.pageIcon = self.root:AddChild(ImageButton("images/vd_setting_icon.xml", "vd_setting_icon.tex", nil, nil, nil, nil, {1,1}, {0,0}))
		self.pageIcon:SetScale(0.6, 0.6, 0.6)
		self.pageIcon:SetHAnchor(1)  -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
		self.pageIcon:SetVAnchor(2)  -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
		self.pageIcon:SetPosition(26, TUNING.HAS_MEDAL_PAGE_ICON and 72 or 26, 0)
		self.pageIcon:SetTooltip("访客掉落工具箱")  --tips
		self.pageIcon:SetOnClick(function()
			if ThePlayer and ThePlayer.HUD then
				ThePlayer.HUD:ShowVDSettingsScreen()
			end
		end)
	end
end)

return visitorSettingIcon