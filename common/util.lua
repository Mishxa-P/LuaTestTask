local Util = {}

function Util.insert(list, value, pos)
    if pos ~= nil and (pos <= 0 or pos > #list + 1) then error("Index out of bounds") end
    if pos == nil then
        list[#list + 1] = value
    else
        for i = #list, pos, -1 do
            list[i + 1] = list[i]
        end
        list[pos] = value
    end
end

function Util.remove(list, pos)
    if pos ~= nil and (pos <= 0 or pos > #list + 1) then error("Index out of bounds") end
    local value = list[pos]

    for i = pos, #list - 1 do
        list[i] = list[i + 1]
    end
    list[#list] = nil
    return value
end

function Util.sort(list, comparator)
    if comparator ~= nil and type(comparator) ~= "function" then error("Wrong comparator") end

    local comparator_func = comparator or function(a, b) return a < b end

    for i = 1, #list do
        local swapped = false
        for j = 1, #list - i do
            if comparator_func(list[j + 1], list[j]) then
                list[j + 1], list[j] = list[j], list[j + 1]
                swapped = true
            end
        end
        if not swapped then break end
    end
end

function Util.print(list)
    local message = ""
    for i, v in ipairs(list) do
        message = message .. " " .. v:__tostring()
    end
    print(message)
end

return Util
