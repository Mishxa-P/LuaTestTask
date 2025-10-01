local Util = require("common.util")

local BattleManager = {}

BattleManager.__index = BattleManager

function BattleManager:new(units)
    local newManager = {
        units = units or {},
        log = {}
    }
    return setmetatable(newManager, BattleManager)
end

function BattleManager:start_session()
    local round_number = 1
    while self:get_alive_units_count() > 1 do
        self.log[#self.log + 1] = "|start of the " .. round_number .. " round|"
        self:_process_round()
        self.log[#self.log + 1] = "|end of the " .. round_number .. " round|\n"
        round_number = round_number + 1
    end

    for i, v in ipairs(self.units) do
        if v:is_alive() then self.log[#self.log + 1] = v.name .. " won!" end
    end
end

function BattleManager:get_alive_units_count()
    local count = 0
    for i, v in ipairs(self.units) do
        if v:is_alive() then count = count + 1 end
    end
    return count
end

function BattleManager:print_log()
    for i, v in ipairs(self.log) do
        print(v)
    end
end

function BattleManager:_process_round()
    Util.sort(self.units, function(a, b) return a.speed > b.speed end)
    for i = 1, #self.units do
        local unit = self.units[i]

        if not unit:is_alive() then goto continue end

        if unit.type == "Mage" then
            local mage = self.units[i]

            local targets = {}
            for j = 1, #self.units do
                local potential_target = self.units[j]
                if potential_target:is_alive() and potential_target ~= mage then
                    Util.insert(targets, potential_target)
                end
            end

            local info = unit:attack(targets)
            for i, v in ipairs(info) do
                local message = ""
                if v.missed == false then
                    if v.crit then
                        message = v.unit.name ..
                            " attacked " .. v.target.name .. " for " .. v.damage .. " damage (CRIT!)"
                    else
                        message = v.unit.name .. " attacked " .. v.target.name .. " for " .. v.damage .. " damage"
                    end
                else
                    message = v.unit.name ..
                        " missed " .. "while attacking " .. v.target.name .. " reason = " .. v.reason
                end
                self.log[#self.log + 1] = message
            end

            goto continue
        end

        local target = self.units[#self.units]
        for f = #self.units, 1, -1 do
            target = self.units[f]
            if target:is_alive() and target ~= unit then
                break
            end
        end

        if target ~= unit then
            local info = unit:attack(target)
            local message = ""
            if info.missed == false then
                if info.crit then
                    message = info.unit.name ..
                        " attacked " .. info.target.name .. " for " .. info.damage .. " damage (CRIT!)"
                else
                    message = info.unit.name .. " attacked " .. info.target.name .. " for " .. info.damage .. " damage"
                end
            else
                message = info.unit.name ..
                    " missed " .. "while attacking " .. info.target.name .. " reason = " .. info.reason
            end
            self.log[#self.log + 1] = message
        end

        ::continue::
    end

    Util.sort(self.units, function(a) return a:is_alive() end)
    for i = 1, #self.units do
        self.log[#self.log + 1] = self.units[i]:__tostring()
    end
end

return BattleManager
