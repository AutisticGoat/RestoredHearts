RestoredHearts = RegisterMod("Restored Hearts", 1)

local LOCAL_TSIL = require("lua.extraLibs.loi.TSIL")
LOCAL_TSIL.Init("lua.extraLibs.loi")

include("lua.helpers.Helpers")

--apis
include("lua.extraLibs.APIs.customhealthapi.core")
RestoredHearts.SaveManager = include("lua.core.save_manager")
RestoredHearts.SaveManager.Init(RestoredHearts)
RestoredHearts.SaveManager.InitCHAPI(CustomHealthAPI)
include("lua.core.saving_system")

include("lua.extraLibs.APIs.ImmortalAPI")
include("lua.extraLibs.APIs.SunAPI")
include("lua.extraLibs.APIs.IllusionAPI")

--core
include("lua.core.enums")
include("lua.core.globals")
include("lua.core.save_manager")
include("lua.core.customhealth")
include("lua.core.dss.deadseascrolls")

include("lua.core.achievements")

--entities
include("lua.entities.clots.ImmortalClot.main")
include("lua.entities.clots.SunClot.main")

-- pickups
include("lua.items.pickups.ImmortalHeart.main")
include("lua.items.pickups.SunHeart.main")
include("lua.items.pickups.IllusionHearts.main")

--mod compatibility
include("lua.mod_compat.main")