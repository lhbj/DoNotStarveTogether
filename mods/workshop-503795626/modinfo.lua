name = "Invincible Structures"
description = [[
	It's a server protection mod.
	With this mod, giants will not be able to destroy the structures any more.
	Still, the hammer can destroy them.
]]
author = "辣椒小皇纸"
version = "1.2"
forumthread = ""

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true
server_filter_tags = {"Invincible Structures"}

----------------------
-- General settings --
----------------------

configuration_options =
{
	{
		name = "Invincible_Wall",
		label = "Invincible Wall",
		hover = "Make the Fence Gate and Thulecite Wall invincible",
		options =	{
						{description = "Yes", data = true, hover = ""},
						{description = "No", data = false, hover = ""},
					},
		default = true,
	},
	{
		name = "More_Invincible_Wall",
		label = "More Invincible Wall",
		hover = "Make more wall invincible, such as Fence, Wall Hay, etc.",
		options =	{
						{description = "Yes", data = true, hover = ""},
						{description = "No", data = false, hover = ""},
					},
		default = false,
	},
}