-- Tax and calculation utilities
local Utils = {}

function Utils.ApplyTax(amount)
    return math.floor(amount * 0.07)
end

return Utils
