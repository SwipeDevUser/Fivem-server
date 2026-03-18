-- Item Drop System
local Drops = {}

Drops.ActiveDrops = {}

-- Create a dropped item
function Drops.CreateDrop(item)
    local dropId = math.random(1000000, 9999999)
    
    Drops.ActiveDrops[dropId] = {
        item = item,
        createdAt = os.time()
    }
    
    return dropId
end

-- Get a dropped item
function Drops.GetDrop(dropId)
    return Drops.ActiveDrops[dropId]
end

-- Remove a dropped item
function Drops.RemoveDrop(dropId)
    Drops.ActiveDrops[dropId] = nil
end

-- Get all drops
function Drops.GetAllDrops()
    return Drops.ActiveDrops
end

return Drops
