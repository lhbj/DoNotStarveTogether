name = "访客掉落（优化版）"
description = [[
生存15天内默认为访客，离线物品全部掉落，地点可选[猪王]或者[月台]。
管理员聊天输入 add玩家编号 进行授权，del玩家编号 收回权限。
管理员聊天输入 find/查找 物品代码/物品名称 即可以搜查该物品在每位玩家身上的数量（输入内容前后可任意搭配，中间有空格）。
世界天数20天以上，部分访客玩家（默认为生存天数小于10）将被限制点燃物品（树除外），砸物品（巨型作物除外），摘人工种植花，作祟物品（复活物品除外）和砍世界树。
访客关闭箱子后会检查身上是否有齿轮、绿宝石、排箫等物品。
绑定过牛铃的牛受到攻击后会显示攻击者。现在可以配置是否显示头衔。
可设置能否烧草、树苗。
可设置冬天开局是否送暖石、小火堆材料、冬帽。
掉落地点设置在原地时，玩家离开游戏会在原地设置一个木牌，方便管理员查找掉落物。
]]

author = "WIGFRID & DHC_King"
version = "4.3.0"
forumthread = ""

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false
all_clients_require_mod= true
api_version = 6

api_version_dst = 10  

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local choice_visitortime={}
for i=1,14 do
	choice_visitortime[i]={description=i*5,data=i*5}
end

local choice_lighttime={}
for i=1,15 do
	choice_lighttime[i]={description=i*2,data=i*2}
end

configuration_options =
{
    {
		name = "droppos",
		label = "访客物品掉落地点",
		options =
		{
			{description = "原地", data = "none"},
			{description = "猪王", data = "pigking"},
			{description = "月台", data = "moonbase"},
			{description = "出生点", data = "portal"},
		},
		default = "moonbase",
	},
    {
		name = "visitortime",
		label = "访客几天之后可以升级为成员",
		options =
		choice_visitortime
		,
		default = 15,
	},
    {
		name = "lighttime",
		label = "访客几天后可以进行危险操作",
		options =
		choice_lighttime
		,
		default = 10,
	},
	{
		name = "showtitle",
		label = "是否显示头衔",
		options =	
		{
			{description = "显示", data = "yes"},
			{description = "不显示", data = "no"},
		},
		default = "yes",
	},
	{
		name = "can_light_sapling",
		label = "访客是否可以烧树苗",
		options = {
			{description = "是", data = true},
			{description = "否", data = false}
		},
		default = false
	},
	{
		name = "can_light_grass",
		label = "访客是否可以烧种下的草",
		options = {
			{description = "是", data = true},
			{description = "否", data = false}
		},
		default = false
	},
	{
		name = "onstart_resource",
		label = "访客冬天开局送温暖",
		options = {
			{description = "是", data = true},
			{description = "否", data = false}
		},
		default = true
	},
	{
		name = "show_bundle_owner",
		label = "显示包裹所有者",
		options = {
			{description = "是", data = true, hover = "捆绑包裹和礼物会显示是谁打包的"},
			{description = "否", data = false}
		},
		default = true
	},
	{
		name = "hit_beefalo",
		label = "攻击皮弗娄牛",
		hover = "设置谁可以攻击皮弗娄牛\n被禁止的人攻击玩家的牛会受到反伤",
		options = {
			{description = "所有人都可以", data = "all"},
			{description = "仅成员可以", data = "member", hover="包括管理员"},
			{description = "所有人都不可以", data = "none", hover="管理员除外"},
		},
		default = "none"
	},
	{
		name = "show_ui",
		label = "快捷指令按钮",
		hover = "只有管理员会显示",
		options = {
			{description = "显示", data = true},
			{description = "隐藏", data = false}
		},
		default = true
	},
	{
		name = "danger_announce",
		label = "行为宣告",
		hover = "访客的危险行为宣告和携带、捡起贵重物品宣告",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = true
	}
}
