if ( DarkRP ) then
    local random = math.random
    local replace = string.Replace

    local MESSAGE_COLOR = Color( 255, 255, 255 )
    local MESSAGE = "{nick} has rolled a {roll}"
    local MESSAGE_RANGE = 250

    local isValid =  commandsLib.register( "roll", {
        ["prefix"] = { "/", "!" },
        ["execute"] = function( requester, options )
            local roll = random( 1, 100 )

            local msg = MESSAGE
            msg = replace( msg, "{nick}", requester:Nick() )
            msg = replace( msg, "{roll}", roll )
            
            if GAMEMODE.Config.alltalk then
                for _, target in ipairs( player.GetAll() ) do
                    DarkRP.talkToPerson( target, MESSAGE_COLOR, msg )
                end
            else
                DarkRP.talkToRange( requester, msg, "", MESSAGE_RANGE )
            end

        end,
        ["showCommand"] = false
    } )

    if ( isValid ) then
        print( "Congratulations, you have created 'roll' chat command!" )
    else
        print( "Error, a command does already have this name !" )
    end
else
    error( "You must have DarkRP gamemode" )
end