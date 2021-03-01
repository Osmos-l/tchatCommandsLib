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
        requester.isInvincible = requester.isInvincible or false

        if ( requester.isInvincible ) then
            requester:GodDisable()
        else
            requester:GodEnable()
        end
        
        requester:ChatPrint( "Invincible turn " .. 
                                ( requester.isInvincible and "off" or "on" ) )

        requester.isInvincible = not requester.isInvincible
    end,
    ["showCommand"] = false
} )

if ( isValid ) then
    print( "Congratulations, you have created a new chat command!" )
else
    print( "Error, a command does already have this name !" )
end