local replace = string.Replace

local MESSAGE = "Invincible turn {state}"

local isValid =  commandsLib.register( "invincible", {
    ["prefix"] = { "/", "!" },
    ["whitelist"] = { -- Optional
        ["usergroup"]   = {
            ["superadmin"] = true
        },
        ["steamid"]     = {},
        ["steamid64"]   = {},
        ["team"]        = {}
    },
    ["execute"] = function( requester, options )
        local isInvincible = requester:HasGodMode()
    
        if ( isInvincible ) then
            requester:GodDisable()
        else
            requester:GodEnable()
        end
        
        local msg = MESSAGE
        msg = replace( msg, "{state}", isInvincible and "off" or "on" )

        requester:ChatPrint( msg )

    end,
    ["showCommand"] = false
} )

if ( isValid ) then
    print( "Congratulations, you have created a new chat command!" )
else
    print( "Error, a command does already have this name !" )
end