local toLower = string.lower
local setChar = string.SetChar
local strExplode = string.Explode

local tableCopy = table.Copy
local tableRemove = table.remove

local commands = commands or {}

local function registerCommand( name, options )

    local command = chatCommand( name, options )
    if ( command ) then
        if ( not commands[name] ) then
            commands[name] = command
            return true
        else
            // TODO: throw error
        end
    end

    return false
end

local function existCommandName( text )
    return commands[text] ~= nil
end
local function getCommand( commandName )
    return tableCopy( commands[ commandName ] )
end

local function executeCommand( text, ply )
    if ( text == nil or not isstring( text ) ) then
        return
    end
    if ( ply == nil or not ply:IsPlayer() ) then
        return
    end

    local prefix = text[1]
    text = setChar( text, 1, '' )
    
    text = strExplode( ' ', text )
    local commandName = toLower( text[1] )
    local commandOptions = tableRemove( text, 1 )

    if ( existCommandName( commandName ) ) then 
        local command = getCommand( commandName )

        // TODO: compare prefix
        if ( prefix == command:getPrefix() ) then
            print( "execute command" )
            command:execute( ply )
        else
            print( "not same prefix" )
        end
    else
        print( "invalid command name" )
    end

    return
end

hook.Add( "OnPlayerChat", "OnPlayerChat:CommandsLib", function( ply, text )
    return executeCommand( text, ply )
end)

local isValid = registerCommand( "test", {
    ["prefix"] = "!", // TODO: array
    ["restricted"] = {
        ["usergroup"] = {
        },
        ["steamid"] = {

        },
        ["steamid64"] = {

        },
        ["team"] = {

        }
    },
    ["preExecute"] = function()
        local a, b, c = 1, 2, 3

        return a, b, c
    end,
    ["execute"] = function( options, preExecute )
        print( options )
        PrintTable( preExecute )
        chat.AddText( Color( 255, 0, 0 ), "HELLO WORLD" )
    end,
    ["postExecute"] = function()

    end,
    ["player"] = "local", // or "all",
    ["showCommand"] = false
} )
if ( isValid ) then
    print( "Congratulations, you have created a new chat command!" )
else
    print( "Error, a command does already have this name !" )
end