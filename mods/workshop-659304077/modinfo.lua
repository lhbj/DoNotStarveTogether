-- This information tells other players more about the mod
name = "金箍棒(Golden Cudgel)"
description = "大圣爷捅破天的棍子！(The weapon of Chinese Monkey King.)"
author = "zyjwsg"
version = "1.3.2"

forumthread = ""

dst_compatible = true
client_only_mod = false
all_clients_require_mod = true 

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"


configuration_options =
{
    {
		name = "jgbdamage",
		label = "Attaking Damage:",
		options =
		{
			{description = "50", data = 50},
			{description = "70(Default)", data = 70},
			{description = "100", data = 100},
			{description = "200", data = 200},
			{description = "1000", data = 1000},
		},
		default = 70,
	},

	{
		name = "jgbattackrange",
		label = "Attaking Range:",
		options =
		{
			{description = "1.7", data = 1.7},
			{description = "2(Default)", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
		},
		default = 2,
	},
	
	{
		name = "jgbmovespeedmul",
		label = "Move Speed Multiple:",
		options =
		{
			{description = "1", data = 1},
			{description = "1.2(Default)", data = 1.2},
			{description = "1.5", data = 1.5},
			{description = "2", data = 2},
		},
		default = 1.2,
	},
	
	{
		name = "jgblightradius",
		label = "Light Radius:",
		options =
		{
			{description = "0.6(Default)", data = 0.6},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 0.6,
	},

	{
		name = "jgblightintensity",
		label = "Light Intensity:",
		options =
		{
			{description = "0.3(Default)", data = 0.3},
			{description = "0.5", data = 0.6},
			{description = "0.8", data = 0.8},
		},
		default = 0.3,
	},

	{
		name = "jgbcanuseashammer",
		label = "Can Use As Hammer:",
		options =
		{
			{description = "true(Default)", data = true},
			{description = "false", data = false},
		},
		default = true,
	},

	{
		name = "jgbcanuseasshovel",
		label = "Can Use As Shovel:",
		options =
		{
			{description = "true", data = true},
			{description = "false(Default)", data = false},
		},
		default = false,
	},

	{
		name = "jgbfiniteuses",
		label = "Finite Uses:",
		options =
		{
			{description = "500", data = 500},
			{description = "600(Default)", data = 600},
			{description = "700", data = 700},
			{description = "800", data = 800},
			{description = "infinite", data = 0},
		},
		default = 600,
	},
}