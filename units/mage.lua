local Util = require("common.util")
local Unit = require("units.unit")

local Mage = {}
setmetatable(Mage, { __index = Unit })
Mage.__index = Mage

function Mage:new(name, max_hp, damage, crit_chance, crit_mult, speed)
    local newMage = Unit:new(name, max_hp, damage, crit_chance, crit_mult, speed)
    setmetatable(newMage, Mage)

    newMage.type = "Mage"
    return newMage
end

function Mage:attack(targets)
    local info = {}
    for i, v in ipairs(targets) do
        Util.insert(info, Unit.attack(self, v))
    end
    return info
end

return Mage
