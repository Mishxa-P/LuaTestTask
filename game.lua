local Unit = require("units.unit")
local Mage = require("units.mage")
local Tank = require("units.tank")
local BattleManager = require("managers.battle_manager")

local cat = Unit:new("Cat", 60, 3, 0.09, 100.0, 100)
local zbra = Tank:new("Zbra", 45, 2, 0.15, 5.0, 80, 90)
local gandalf = Mage:new("Gandalf", 40, 18, 0.0, 1.0, 60)

local battle_manager = BattleManager:new({ cat, zbra, gandalf})
battle_manager:start_session()
battle_manager:print_log()
