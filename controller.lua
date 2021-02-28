local toLower = string.lower
local setChar = string.SetChar
local strExplode = string.Explode

local tableCopy = table.Copy
local tableRemove = table.remove

local isString = isstring
local isTable = istable

local commands = commands or {}

local function registerCommand( name, options )

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
                restricted = false
                break
            end
        end
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

    text = setChar( text, 1, '' ) // Command with options
    text = strExplode( ' ', text )

    local commandName = toLower( text[1] )
    local commandOptions = tableRemove( text, 1 )

    if ( existCommandName( commandName ) ) then 
        local command = getCommand( commandName )

        if ( comparePrefix( commandPrefix, command:getPrefix()
             and checkRestriction( ply, command:getRestricted() ) ) ) then
            command:execute( ply, commandOptions )
        end
    end

    return
end

hook.Add( "OnPlayerChat", "OnPlayerChat:CommandsLib", function( ply, text )
    return executeCommand( text, ply )
end)

local isValid = registerCommand( "test", {
    ["prefix"] = { "/", "!" }, // TODO: ""
    ["whitelist"] = {
        ["usergroup"]   = {},
        ["steamid"]     = {},
        ["steamid64"]   = {},
        ["team"]        = {}
    },
    ["preExecute"] = function( requester, options )
        local a, b, c = 1, 2, 3

        return a, b, c, requester:Name()
    end,
    ["execute"] = function( requester, options, preExecute )
        print( options )
        PrintTable( preExecute )
        chat.AddText( Color( 255, 0, 0 ), "HELLO WORLD" )
    end,
    ["postExecute"] = function( requester, options )

    end,
    ["player"] = "local", // or "all",
    ["showCommand"] = false
} )
if ( isValid ) then
    print( "Congratulations, you have created a new chat command!" )
else
    print( "Error, a command does already have this name !" )
end