local isValid =  commandsLib.register( "random", {
    ["prefix"] = { "/", "!" },
    ["whitelist"] = { -- Optional
        ["usergroup"]   = {},
        ["steamid"]     = {},
        ["steamid64"]   = {},
        ["team"]        = {}
    },
    ["preExecute"] = function( requester, options ) -- Optional
        local randomNumber
        if ( options and options[1] and options[2] ) then
            randomNumber = math.Rand( tonumber( options[1] ), 
                                        tonumber( options[2] ) )
        else
            randomNumber = math.Rand( 0, 100 )
        end

        return randomNumber
    end,
    ["execute"] = function( requester, options, preExecute )
        local randomNumber = preExecute[1]

        chat.AddText( Color( 255, 0, 0 ), requester:Name(), 
                      Color( 255, 255, 255 ), " random number is ",
                      Color( 0, 0, 0 ), randomNumber )
    end,
    ["postExecute"] = function( requester, options ) -- Optional
        ServerLog( requester:Name()  .. " used 'random' chat command" )
    end,
    ["player"] = "local", -- Only for client commands
    ["showCommand"] = false
} )

if ( isValid ) then
    print( "Congratulations, you have created a new chat command!" )
else
    print( "Error, a command does already have this name !" )
end

-- Exemple
--
-- input => !random 50 100
-- output => x random number is y
-- 