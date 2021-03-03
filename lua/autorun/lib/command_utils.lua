local isTable = istable
local isString = isstring
local utils = {}

local function compareStrings( toCompare1, toCompare2 )
    return toCompare1 == toCompare2
end

function utils.ComparePrefixes( prefix, prefixes )
    if ( not isString( prefix ) ) then return end
    local isEqual = false

    if ( not isTable( prefixes ) ) then
        return compareStrings( prefix, prefixes )
    end

    for _, v in ipairs( prefixes ) do
        if ( compareStrings( prefix, v ) ) then
            isEqual = true
            break
        end
    end

    return isEqual
end


return utils