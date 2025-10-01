local Util = require("common.util")
local Unit = require("units.unit")

local Tank = {}
setmetatable(Tank, { __index = Unit })
Tank.__index = Tank

function Tank:new(name, max_hp, damage, crit_chance, crit_mult, speed, armor)
    assert(armor >= 0, "Armor must be >= 0")

    local newTank = Unit:new(name, max_hp, damage, crit_chance, crit_mult, speed)
    setmetatable(newTank, Tank)

    newTank.type = "Tank"
    newTank.armor = armor

    return newTank
end

function Tank:take_damage(amount)
    assert(type(amount) == "number" and amount >= 0, "Damage must be positive number")
    assert(self:is_alive(), "Dead units cannot receive any damage")

    if self.armor >= amount then
        self.armor = self.armor - amount
    else
        local remaining_damage = amount - self.armor
        self.armor = 0
        self.hp = math.max(0, self.hp - remaining_damage)
    end
end

function Tank:__tostring()
    local temp = "Type = " .. self.type .. " Name = " .. self.name ..
        ' (HP: ' .. string.rep('#', self.hp) .. string.rep('-', self.max_hp - self.hp) .. ')' ..
        ' (ARMOR: ' .. string.rep('*', self.armor) .. ')'
    if not self:is_alive() then temp = temp .. " (DEAD!)" end
    return temp
end

return Tank
