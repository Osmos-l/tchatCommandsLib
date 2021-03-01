local toLower = string.lower
local setChar = string.SetChar
local strExplode = string.Explode

local tableCopy = table.Copy
local tableRemove = table.remove

local isString = isstring
local isTable = istable

local commands = commands or {}

commandsLib = commandsLib or {}

function commandsLib.register( name, options )

    local command = chatCommand( name, options )
    if ( command ) then
        if ( not commands[name] ) then
            commands[name] = command
            return true
        end
    end

    // TODO: Delete command

    return false
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
        print( "is table" )
        PrintTable( toCompare2 )
        for k, v in ipairs( toCompare2 ) do
            print( v, toCompare1 )
            if ( v == toCompare1 ) then
                equal = true
            end
        end
    else
        print( "is not table" )
        equal = toCompare1 == toCompare2
    end
    print( "prefix = ", equal )
    return equal
end
local function checkRestriction( ply, restriction )
    local restricted = true

    for _, type in pairs( restriction ) do
        for v, __ in pairs( restriction ) do
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

            if ( toCompare == v ) then
                print( "unvalid restriction" )
                restricted = false
                break
            end
        end
    end

    return restricted
end

local function executeCommand( text, ply )
    if ( text == nil or not isString( text ) ) then
        print( "invalid text" )
        return
    end
    if ( ply == nil or not ply:IsPlayer() ) then
        print( "invalid speaker" )
        return
    end

    local commandPrefix = text[1]

    text = setChar( text, 1, '' ) // Command with options
    text = strExplode( ' ', text )

    local commandName = toLower( text[1] )

    local commmandOptions = false
    if ( #text > 1 ) then
        commandOptions = tableRemove( text, 1 )
    end

    if ( existCommandName( commandName ) ) then 
        local command = getCommand( commandName )

        if ( comparePrefix( commandPrefix, command:getPrefix() )
             and checkRestriction( ply, command:getRestricted() ) ) then
            command:execute( ply, commandOptions )
        else 
            print( "unvalid prefix or restriction" )
        end
    else
        print( "unvalid command name")
    end

    return
end

// TODO: distinction for sv and cl hook
hook.Add( "OnPlayerChat", "OnPlayerChat:CommandsLib", function( ply, text )
    print( "someone speak" )
    return executeCommand( text, ply )
end)

