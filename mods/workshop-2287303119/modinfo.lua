-- information about the mod
version = "0.58.7"
version_compatible = "0.58.6"
name = "Show Me (中文)"
author = "Star, +Serp, 由 傳說覺悟 汉化"
forumthread = ""
description = "从Show Me (Origin) v0.58模组汉化\n当前版本: "..version.." 更新:\n"..[[
1.修复显示生命小于0的生物崩溃问题
2.修复类Hamlet树根箱拿起物品显示颜色导致客机崩溃的问题

历史更新：
1.水中木、不妥协、神话、棱镜资源计时器，棱镜月藏宝匣兼容；
2.修复蚁狮计时、中庭计时等；新增猪人、兔人、蜘蛛等生物刷新时间；
3.农作物的状态显示可设置，关闭则不显示肥料、水分、家族等等；
4.兼容item info模组、捆绑包显示支持关闭；

食物信息显示、拿起物品箱子提示、作物成长显示、生物信息显示、记忆厨师食物、工具信息显示、捆绑包物品显示；

如果不显示血量，是因为与简易血条一起使用已隐藏，要显示请在模组设置>显示血量>是

Steam Show Me (中文)、WeGame 提示语句(新.中文)
]]
	--and "Рассказывает о предметах и существах после действия \"Осмотреть\"."
	--or "Shows various info about creatures and items on \"inspect\" action."

-- custom icon
icon_atlas = "preview.xml"
icon = "preview.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

all_clients_require_mod=true
client_only_mod=false
--server_only_mod=true

api_version = 10
priority = 0.00666155465 --Priority does not matter.
--russian_icon = true

server_filter_tags = {"show", "showme", "提示语句",}

local color_options = {
	{description = "默认", data = -1,},
	{description = "0%", data = 0,},
	{description = "10%", data = 0.1,},
	{description = "20%", data = 0.2,},
	{description = "30%", data = 0.3,},
	{description = "40%", data = 0.4,},
	{description = "50%", data = 0.5,},
	{description = "60%", data = 0.6,},
	{description = "70%", data = 0.7,},
	{description = "80%", data = 0.8,},
	{description = "90%", data = 0.9,},
	{description = "100%", data = 1,},
}

configuration_options =
{
	--[[{
		name = "message_style",
		label = "Style",
		options = 
		{
			{description = "Isolation ->", data = 1},
			{description = "isolation ->", data = 2},
			{description = "Isol ->", data = 3},
			{description = "isol ->", data = 4}, 
			{description = "<- Warm", data = 5}, 
			{description = "<- warm", data = 6}, 
		}, 
		default = 1,
	},--]]
	{
		name = "food_style",
		label = "食物属性样式",
		options = 
		{
			{description = "默认", data = 0, hover = "默认是 \"详细\""},
			{description = "详细", data = 1, hover = "饥饿: +12.5 / 精神: -10 / 生命: +3"},
			{description = "简洁", data = 2, hover = "+12.5 / -10 / +3"},
		}, 
		default = 0,
	},
	{
		name = "food_order",
		label = "食物属性格式",
		options = 
		{
			{description = "默认", data = 0, hover = "默认是 \"标准\""},
			{description = "标准", data = 1, hover = "饥饿 / 精神 / 生命"},
			{description = "自定", data = 2, hover = "生命 / 饥饿 / 精神"},
		}, 
		default = 0,
	},
	{
		name = "food_estimation",
		label = "预计腐烂",
		hover = "预测食物腐烂时间！",
		options = 
		{
			{description = "默认", data = -1, hover = "是"},
			{description = "否", data = 0, hover = "否"},
			{description = "是", data = 1, hover = "是"},
		}, 
		default = -1,
	},
	{
		name = "show_food_units",
		label = "显示食物单位",
		hover = "显示食物单位，比如肉类、蔬菜类、水果类！",
		options = 
		{
			{description = "默认", data = -1, hover = "是"},
			{description = "否", data = 0, hover = "否"},
			{description = "是", data = 1, hover = "是"},
			{description = "禁止", data = 2, hover = "服务端将不会发送属性信息给客户端"},
		}, 
		default = -1,
	},
	{
		name = "show_uses",
		label = "显示工具用途",
		hover = "",
		options = 
		{
			{description = "默认", data = -1, hover = "是"},
			{description = "否", data = 0, hover = "否"},
			{description = "是", data = 1, hover = "是"},
			{description = "禁止", data = 2, hover = "服务端将不会发送属性信息给客户端"},
		}, 
		default = -1,
	},
	{
		name = "lang",
		label = "语言",
		--hover = "",
		options = 
		{
			{description = "自动", data = "auto", hover = "检测语言包"},
			{description = "英语", data = "en", hover = "英语"},
			{description = "俄语", data = "ru", hover = "俄语"},
			{description = "简体中文", data = "chs", hover = "简体中文"},
			{description = "繁体中文", data = "cht", hover = "繁体中文"},
			{description = "葡萄牙语", data = "br", hover = "葡萄牙语"},
			{description = "波兰语", data = "pl", hover = "波兰语"},
			{description = "韩语", data = "kr", hover = "韩语"},
			{description = "西班牙语", data = "es", hover = "西班牙语"},
		}, 
		default = "Auto",
	},
	{
		name = "display_hp",
		label = "显示血量",
		--hover = "",
		options = 
		{
			{description = "自动", data = -1, hover = "取决于安装的模组"},
			{description = "否", data = 0, hover = "否，但用户可以覆盖此选项。"},
			{description = "是", data = 1, hover = "是的，但用户可以覆盖此选项。"},
			{description = "禁止", data = 2, hover = "服务端将不会发送属性信息给客户端"},
		}, 
		default = 1,
	},
	{
		name = "T_crop",
		label = "农作物状态显示",
		hover = "例如缺肥料、水分、家族、有杂草等，成长计时不受影响",
		options = {
            {description = "开", data = true},
			{description = "关", data = false},
		},
		default = true,
	},
	-- {
		-- name = "naughtiness",
		-- label = "顽皮值",
		-- hover = "",
		-- options = {
			-- {description = "禁用", data = 0},
			-- {description = "", data = 1},
			-- {description = "", data = 2},
		-- },
		-- default = 0,
	-- },
	{
		name = "show_buddle_item",
		label = "显示捆绑包物品",
		options =
		{
			{description = "是", data = 1},
			{description = "否", data = 0},
		}, 
		default = 1,
	},
	{
		name = "item_info_mod",
		label = "兼容item info模组",
		hover = "如果打开，Show me将不显示与item info相同的信息",
		options =
		{
			{description = "关", data = 0},
			{description = "开", data = 1},
		}, 
		default = 0,
	},
	{
		name = "",
		label = "箱子提示颜色",
		hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "chestR",
		label = "红色值",
		hover = "默认绿色，如果红绿蓝都设置为0%或100%，箱子就没有颜色",
		options = color_options,
		default = -1,
	},
	{
		name = "chestG",
		label = "绿色值",
		hover = "默认绿色，如果红绿蓝都设置为0%或100%，箱子就没有颜色",
		options = color_options,
		default = -1,
	},
	{
		name = "chestB",
		label = "蓝色值",
		hover = "默认绿色，如果红绿蓝都设置为0%或100%，箱子就没有颜色",
		options = color_options,
		default = -1,
	},
}




