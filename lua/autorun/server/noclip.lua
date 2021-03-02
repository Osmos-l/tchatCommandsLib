local replace = string.Replace

local MESSAGE = "no clip turn {state}"

local isValid =  commandsLib.register( "noclip", {
    ["prefix"] = { "/", "!" },
    ["whitelist"] = {
        ["usergroup"]   = {
            ["superadmin"] = true,
        },
        ["steamid"]     = {},
        ["steamid64"]   = {},
        ["team"]        = {}
    },
    ["execute"] = function( requester, options )
        local requesterMoveType = requester:GetMoveType()
        
        local requesterDesiredMoveType = requesterMoveType == MOVETYPE_NOCLIP and
                                            MOVETYPE_NOCLIP or MOVETYPE_WALK

        if ( requesterMoveType ~= MOVETYPE_OBSERVER ) then
            requester:SetMoveType( requesterDesiredMoveType )
            
            local msg = MESSAGE
            msg = replace( msg, "{state}", requesterDesiredMoveType == MOVETYPE_NOCLIP 
                                            and "on" or "off" )
            requester:ChatPrint( msg )
        end

    end,
    ["showCommand"] = false
} )

if ( isValid ) then
    print( "Congratulations, you have created 'noclip' chat command!" )
else
    print( "Error, a command does already have this name !" )
end
