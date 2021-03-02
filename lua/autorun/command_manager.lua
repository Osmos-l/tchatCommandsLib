local toLower = string.lower
local setChar = string.SetChar
local strExplode = string.Explode

local tableCopy = table.Copy
local tableRemove = table.remove
local tableCount = table.Count

local isString = isstring
local isTable = istable

local commands = commands or {}
commandsLib = commandsLib or {}

--
-- TODO: Comment method role 
--
function commandsLib.register( name, options )

    local command = chatCommand( name, options )
    if ( command ) then
        if ( not commands[name] ) then
            -- TODO: Optimize stockage
            commands[name] = command
            return true
        end
    end

    return false
end

--
-- TODO: Comment method role 
--
function commandsLib.delete( name )
    local exist = existCommandName( name )
    if ( exist ) then
        local command = getCommand( name )

        commands[ name ] = nil
        command:OnDelete()
    end
end

local function existCommandName( text )
    return commands[text] ~= nil
end
local function getCommand( commandName )
    return tableCopy( commands[ commandName ] )
end
local function comparePrefix( toCompare1, toCompare2 )
    local equal = false

    if ( isTable( toCompare2 ) ) then
        for k, v in ipairs( toCompare2 ) do
            if ( v == toCompare1 ) then
                equal = true
            end
        end
    else
        equal = toCompare1 == toCompare2
    end

    return equal
end
local function checkRestriction( ply, restriction )
    local restricted = true
    local probablyEmpty = true

    for type, values in pairs( restriction ) do
        if ( tableCount( values ) == 0 ) then
            continue
        end

        probablyEmpty = false

        for value, __ in pairs( values ) do
            local toCompare

            if ( type == "usergroup" ) then
                toCompare = ply:GetUserGroup()
            elseif ( type == "steamid" ) then
                toCompare = ply:SteamID()
            elseif ( type == "steamid64" ) then
                toCompare = ply:SteamID64()
            elseif ( type == "team" ) then
                toCompare = ply:Team()
            end

            if ( toCompare == value ) then
                restricted = false
                break
            end
        end
    end

    if ( probablyEmpty ) then
        return false
    end

    return restricted
end

local function executeCommand( text, ply )
    if ( text == nil or not isString( text ) ) then
        return
    end
    if ( ply == nil or not ply:IsPlayer() ) then
        return
    end

    local commandPrefix = text[1]

    text = setChar( text, 1, '' ) -- Remove prefix

    -- TODO: Add options separator configuration
    text = strExplode( ' ', text ) -- Explode to get command name and options

    local commandName = toLower( text[1] )

    if ( existCommandName( commandName ) ) then 
        local command = getCommand( commandName )

        local commmandOptions = false
        if ( #text > 1 ) then
            commandOptions = tableRemove( text, 1 )
        end

        if ( comparePrefix( commandPrefix, command:getPrefix() )
             and not checkRestriction( ply, command:getRestricted() ) ) then
            command:execute( ply, commandOptions )

            return not command:getShowMessage()
        end
    end

    return
end


if CLIENT then
    hook.Add( "OnPlayerChat", "OnPlayerChat:CommandsLib", function( requester, text )
        return executeCommand( text, requester )
    end)
else
    hook.Add( "PlayerSay", "OnPlayerChat:CommandsLib", function( requester, text )
        local response = executeCommand( text, requester )
        return response and "" or text
    end)
end