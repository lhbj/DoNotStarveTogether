name = "Ice Fling Range Check [DST CLIENT]"
description = ""
author = "_Q_ & Aire Ayquaza"
version = "1.2.4"

api_version = 6
api_version_dst = 10
priority = - 4.0001

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
dst_compatible = true
all_clients_require_mod = false
client_only_mod = true

server_filter_tags = {}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

configuration_options =
{
    {
        name = "Time",
        options =
        {
            {description = "Short", data = "short"},
			{description = "Default", data = "default"},
			{description = "Long", data = "long"},
			{description = "Longer", data = "longer"},
			{description = "Longest", data = "longest"},
			{description = "Always", data = "always"},
        },
        default = "default",
    }
}