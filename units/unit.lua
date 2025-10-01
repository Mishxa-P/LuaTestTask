local Unit = {}

Unit.__index = Unit

function Unit:new(name, max_hp, damage, crit_chance, crit_mult, speed)
    assert(type(name) == "string" and #name > 0 and #name < 25, "Name length must be > 0 and < 25")
    assert(max_hp > 0, "Max hp must be > 0")
    assert(damage >= 0, "Damage must be >= 0")
    assert(crit_chance >= 0 and crit_chance <= 1, "Crit chance must be >=0 and <= 1")
    assert(crit_mult >= 1, "Crit multiplier must be >= 1")

    local newUnit = {
        type = "Unit",
        name = name,
        hp = max_hp,
        max_hp = max_hp,
        damage = damage,
        crit_chance = crit_chance,
        crit_mult = crit_mult,
        speed = speed
    }
    return setmetatable(newUnit, Unit)
end

function Unit:attack(target)
    assert(target ~= nil, "Target cannot be nil")
    assert(self:is_alive(), "Dead unit cannot attack")

    if debug then
        assert(type(target.take_damage) == "function", "Target must implement take_damage")
    end
    if not target:is_alive() then
        return { missed = true, reason = "target_is_dead", unit = self, target = target }
    end

    local rnd = math.random()
    local damage = self.damage
    local crit = false
    if self.crit_chance >= rnd then
        crit = true
        damage = damage * self.crit_mult
    end

    target:take_damage(damage)

    return {
        missed = false,
        unit = self,
        target = target,
        crit = crit,
        damage = damage,
        is_target_dead = target:is_alive()
    }
end

function Unit:take_damage(amount)
    assert(type(amount) == "number" and amount >= 0, "Damage must be positive number")
    assert(self:is_alive(), "Dead units cannot receive any damage")

    self.hp = math.max(0, self.hp - amount)
end

function Unit:is_alive()
    return self.hp > 0
end

function Unit:__tostring()
    local temp = "Type = " .. self.type .. " Name = " .. self.name ..
        ' (' .. string.rep('#', self.hp) .. string.rep('-', self.max_hp - self.hp) .. ')'
    if not self:is_alive() then temp = temp .. " (DEAD!)" end
    return temp
end

return Unit
