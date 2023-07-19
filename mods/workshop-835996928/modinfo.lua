name 						= "Ultimate Tool"
description 					= "It's a Crazy tool! Originally from Filigrani"
author 						= "Nkiy"
version 					= "0.1.1"
forumthread 				= ""
api_version 				= 10
priority 					= 0.1235123
dont_starve_compatible 		= false
reign_of_giants_compatible 	= false
shipwrecked_compatible 		= false
dst_compatible 			= true

all_clients_require_mod = true
client_only_mod = false

icon_atlas 					= "modicon.xml"
icon 						= "modicon.tex"

configuration_options =  {
   {
      name = "Durability",
      options =
	 {
	    {description = "Very Short", data = 500, hover = "500 times"},
	    {description = "Short", data = 1000, hover = "1000 times"},
	    {description = "Normal", data = 2500, hover = "2500 times"},
	    {description = "Long", data = 5000, hover = "5000 times"},
	    {description = "Super Long", data = 20000, hover = "20000 times."},
	    {description = "Indestructible", data = -1, hover = "won't be destroyed."},
	 },
      default = 2500,
   },
   {
      name = "",
      options =
	 {
	    {description = "", data = 0},
	 },
      default = 0,
   },
   {
      name = "Enable Shovel",
      options =
	 {
	    {description = "Yes", data= true, hover = "Shovel Enabled"},
	    {description = "No", data = false, hover = "Shovel Disabled"},
	 },
      default = true,
   },
   {
      name = "Enable Axe",
      options =
	 {
	    {description = "Yes", data= true, hover = "Axe Enabled"},
	    {description = "No", data = false, hover = "Axe Disabled"},
	 },
      default = true,
   },
   {
      name = "Enable Pickaxe",
      options =
	 {
	    {description = "Yes", data= true, hover = "Pickaxe Enabled"},
	    {description = "No", data = false, hover = "Pickaxe Disabled"},
	 },
      default = true,
   },
   {
      name = "Enable Hammer",
      options =
	 {
	    {description = "Yes", data= true, hover = "Hammer Enabled"},
	    {description = "No", data = false, hover = "Hammer Disabled"},
	 },
      default = true,
   },
   {
      name = "",
      options =
	 {
	    {description = "", data = 0},
	 },
      default = 0,
   },
   {
      name = "Damage",
      options =
	 {
	    {description = "0", data= 0, hover = "harmless"},
	    {description = "17", data = 17, hover = "shovel"},
	    {description = "27.2", data = 27.2, hover = "pickaxe"},
	    {description = "34", data = 34, hover = "spear"},
	    {description = "42.5", data = 42.5, hover = "batbat"},
	    {description = "59.5", data = 59.5, hover = "hambat"},
	    {description = "68", data = 68, hover = "nightsword"},
	    {description = "100", data = 100, hover = "..."},
	    {description = "200", data = 200, hover = "???"},
	    {description = "500", data = 500, hover = "WTF?"},
	    {description = "1000", data = 1000, hover = "╮(╯▽╰)╭"},
	 },
      default = 34,
   },
   {
      name = "",
      options =
	 {
	    {description = "", data = 0},
	 },
      default = 0,
   },
   {
      name = "Craftable Rock",
      options =
	 {
	    {description = "Yes", data = true, hover = "Enable Rock Recipe"},
	    {description = "No", data = false, hover = "Do not Enable Rock Recipe"},
	 },
      default = true,
   },
   {
      name = "Rock Count",
      hover = "How many rocks could be crafted in one action.",
      options =
	 {
	    {description = "1", data = 1},
	    {description = "2", data = 2},
	    {description = "3", data = 3},
	    {description = "5", data = 5},
	    {description = "10", data = 10},
	    {description = "20", data = 20},
	    {description = "50", data = 50},
	 },
      default = 5,
   },
   {
      name = "",
      options =
	 {
	    {description = "", data = 0},
	 },
      default = 0,
   },
   {
      name = "Keep Temperature",
      label = "Keep 36°C",
      hover = "Help keep you warm.",
      options =
	 {
	    {description = "Yes", data = true},
	    {description = "No", data = false},
	 },
      default = true,
   },
   {
      name = "",
      options =
	 {
	    {description = "", data = 0},
	 },
      default = 0,
   },
   {
      name = "walkspeed",
      label = "Walk Speed Modifier",
      options =
	 {
	    {description = "1.25, As Cane", data = 1.25},
	    {description = "1.5", data = 1.5},
	    {description = "2", data = 2.0},
	 },
      default = 1.5
   },
}
