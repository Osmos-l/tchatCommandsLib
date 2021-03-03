local isTable = istable
local isString = isstring
local tableCount = table.Count

local utils = {}

local function compare( toCompare1, toCompare2 )
    return toCompare1 == toCompare2
end

--
-- TODO: Comment method role
--
function utils.ComparePrefixes( prefix, prefixes )
    if ( not isString( prefix ) ) then return end
    local isEqual = false

    if ( not isTable( prefixes ) ) then
        return compare( prefix, prefixes )
    end

    for _, v in ipairs( prefixes ) do
        if ( compare( prefix, v ) ) then
            isEqual = true
            break
        end
    end

    return isEqual
end

local RESTRICTED_FUNCTIONS = {
    ["usergroup"] = function( target, toCompare )
        return compare( target:GetUserGroup(), toCompare )
    end,
    ["steamid"] = function( target, toCompare )
        return compare( target:SteamID(), toCompare )
    end,
    ["steamid64"] = function( target, toCompare )
        return compare( target:SteamID64(), toCompare )
    end,
    ["team"] = function( target, toCompare )
        return compare( target:Team(), toCompare )
    end
}

--
-- TODO: Comment method role
--
function utils.isPlayerRestricted( ply, restrictions )
    local isRestricted = true
    local emptyRestrictions = true

    for type, values in pairs( restrictions ) do
        if ( tableCount( values ) == 0 ) then
            continue
        end

        emptyRestrictions = false

        for value, __ in pairs( values ) do
            if ( RESTRICTED_FUNCTIONS[ type ]( ply, value ) ) then
                isRestricted = false
                break
            end
        end

    end

    if ( emptyRestrictions ) then
        return false
    end

    return isRestricted

end


return utils