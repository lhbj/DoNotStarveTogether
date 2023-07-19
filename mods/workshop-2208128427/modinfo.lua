name = "Loot Pump"
description = [[
Catches items from the ground and throw them in containers. (Autoloot)

Recipe: 1 Gears, 1 Whirly Fan and 2 Electrical Doodads.

The Loot Pump always priorise to launch the items on containers that already has that item inside.

There are two placement rings, the inner ring defines the looting region and the outer ring defines the container region.
NOTE: If the option "Two Zones" is activated, containers in the inner ring will not be considered by the Loot Pump.

If any empty container is found in the range, the Loot Pump will throw the loots in a random container in the range, which causes the item falls on ground. This can be intentionally used to make transport lines from multiple Loot Pumps.

The range, looting speed and the sound effects can be configured.

#Changelog:

v1.10:
-- Added an option to itens being looted go through walls.


v1.09:
-- Included some extra verifications.

v1.08:
-- Removed Pumpkin Lantern removed from the "look for items" list.
-- Targets with the tag "birds", "trap", "canbetrapped" and "smallcreature" will not be looted anymore.
-- Now the Loot Pump double-check the item "existence". This should reduce the incompatibility with mod that combine stacks.

v1.07:
-- Removed Life Giving Amulet from the "look for items" list. (Thanks for the suggestion @greeking13)
-- Added the option "Loot Equipment" (default: "Yes") on the mod configuration menu.
-- -- If this option is set to "No" the Loot Pump will not loot equipable items.

v1.06:
-- Removed Celestial Orb from the "look for items" list.

v1.05:
-- Removed Tooth Trap, Bee Mine and Bramble Trap from the "look for items" list.

v1.04:
-- Removed Thermal Stone, Glommer's Flower, Trap, Bird Trap, Tallbird Egg and Red Lantern from the "look for items" list.

v1.03:
-- Improved the container priority for the looting:
-- -- Now the priority is: Has a similar item > Will reduce the perish rate > Not full > Random;
-- Removed Woby, Chester and Hutch from the "look for containers" list;
-- Removed Lantern, Eyebone and Star-Sky from the "look for items" list.

]]
author = "Gleenus, Catherine and Jess"
version = "1.10"
forumthread = ""
api_version = 10
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

----------------------------
-- Configuration settings --
----------------------------

configuration_options = 
{
	{
		name = "LOOT_PUMP_SCALE",
		label = "Range Scale",
		hover = "Scale the looting and throwing range.",
		options =	
		{
			{description = " 33%", data = 0.33},
			{description = " 50%", data = 0.50},
			{description = " 66%", data = 0.66},
			{description = "100%", data = 1.00},
            {description = "150%", data = 1.50},
			{description = "200%", data = 2.00},			
		},
		default = 1,
	},

	{
		name = "LOOT_PUMP_SPEED",
		label = "Speed Scale",
		hover = "Scale the speed that items move while being looted.",
		options =	
		{
			{description = " 33%", data = 0.33},
			{description = " 50%", data = 0.50},
			{description = "100%", data = 1.00},
            {description = "200%", data = 2.00},
			{description = "300%", data = 3.00},			
		},
		default = 1,
	},
	
	{
		name = "LOOT_PUMP_SOUND",
		label = "Play Sound",
		hover = "Play item launch sound and container animation?",
		options =	
		{
			{description = " No", data = false},
			{description = "Yes", data = true},
		},
		default = true	,
	},
	
	{
		name = "LOOT_PUMP_TWOZN",
		label = "Two Zones",
		hover = "One zone for looting and other for containers.",
		options =	
		{
			{description = " No", data = false},
			{description = "Yes", data = true},
		},
		default = false	,
	},
	{
		name = "LOOT_PUMP_EQUIP",
		label = "Loot Equipments",
		hover = "Loot equipable items on ground?",
		options =	
		{
			{description = " No", data = false},
			{description = "Yes", data = true},
		},
		default = true,
	},
	{
		name = "LOOT_PUMP_WALLS",
		label = "Loot through walls?",
		hover = "Itens being looted can pass through walls?",
		options =	
		{
			{description = " No", data = false},
			{description = "Yes", data = true},
		},
		default = true,
	},
}
