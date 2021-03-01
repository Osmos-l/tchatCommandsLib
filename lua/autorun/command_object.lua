local isString = isstring
local isFunction = isfunction
local isTable = istable
local isBool = isbool
local tableCopy = table.Copy

do

    chatCommand = {}
    chatCommand.__index = chatCommand

    -- Const
    local ERROR_UNVALID_NAME = "Command name is unvalid"
    local ERROR_UNVALID_OPTIONS = "Command options are unvalid"

    local COMMAND_TARGET_SINGLE = "local"
    local COMMAND_TARGET_ALL    = "all"

    local OPTION_WHITELIST = "whitelist"
    local OPTION_WHITELIST_USERGROUP = "usergroup"
    local OPTION_WHITELIST_STEAMID   = "steamid"
    local OPTION_WHITELIST_STEAMID64 = "steamid64"
    local OPTION_WHITELIST_TEAM  = "team"

    local OPTION_PREFIX    = "prefix"
    local OPTION_EXECUTE   = "execute"
    local OPTION_PLAYER    = "player"
    local OPTION_SHOWCOMMAND = "showCommand"
    local OPTION_PREEXECUTE = "preExecute"
    local OPTION_POSTEXECUTE = "postExecute"

    local function isValidCommandName( toValid )

        if ( toValid == nil or not isString( toValid) ) then
            return false
        end

        if ( toValid == '' ) then
            return false
        end

        return true
    end

    local function isValidCommandOptions( toValid )
        
        if ( toValid == nil or not isTable( toValid ) ) then
            return false
        end
        
        -- Essential options
        if ( toValid[ OPTION_PREFIX ] == nil or not 
             isTable( toValid[ OPTION_PREFIX ] ) ) then
            return false
        end
        if ( toValid[ OPTION_EXECUTE ] == nil or not
             isFunction( toValid[ OPTION_EXECUTE ] ) ) then
            return false
        end

        if ( CLIENT ) then
            if ( toValid[ OPTION_PLAYER ] == nil or not
                isString( toValid[ OPTION_PLAYER ] ) ) then
                return false
            end
            if ( toValid[ OPTION_PLAYER ] ~= COMMAND_TARGET_SINGLE and
                toValid[ OPTION_PLAYER ] ~= COMMAND_TARGET_ALL ) then
                return false
            end
        end
        
        if ( toValid[ OPTION_SHOWCOMMAND ] == nil or not 
             isBool( toValid[ OPTION_SHOWCOMMAND ] ) ) then
            return false
        end

        return true
    end

    -- Constructor of chatCommand class
    --
    --  @param String name The command name
    --  @param Array options The different options of the command
    --
    --  @return chatCommand
    function chatCommand:new( name, options )
        if ( not isValidCommandName( name ) ) then 
            error( ERROR_UNVALID_NAME )
            return 
        end

        if ( not isValidCommandOptions( options ) ) then 
            error( ERROR_UNVALID_OPTIONS )
            return 
        end

        if ( not options[ OPTION_WHITELIST ] or not isTable( options[ OPTION_WHITELIST ] ) ) then
            options[ OPTION_WHITELIST ] = {
                [ OPTION_WHITELIST_USERGROUP ] = {},
                [ OPTION_WHITELIST_STEAMID ]   = {},
                [ OPTION_WHITELIST_STEAMID64 ] = {},
                [ OPTION_WHITELIST_TEAM ] = {}
            }
        end

        local command = {
            name = name,
            options = options
        }

        setmetatable( command, chatCommand )

        return command
    end
    
    -- Pre execute command function
    --
    -- @param Player The requester of the command
    --
    -- @return ? Variables returned by the configurated function
    function chatCommand:preExecute( requester )
        local base = function()
        end

        local preExecute = function()
            base()

            if ( self.options[ OPTION_PREEXECUTE ] and 
                isFunction( self.options[ OPTION_PREEXECUTE ] ) ) then
                return self.options[ OPTION_PREEXECUTE ]( requester )
            else 
                return nil
            end
        end

        return preExecute()
    end

    -- Execute command function
    --
    -- @param Player The requester of the command
    -- @param Array Words wrote right after the command name
    function chatCommand:execute( requester, commandOptions )
        local preExecute = { self:preExecute( requester, commandOptions ) }

        local execute = self.options[ OPTION_EXECUTE ]
        local base = function()
            if ( CLIENT 
                and self:getScope() == COMMAND_TARGET_SINGLE
                and requester ~= LocalPlayer() ) then
                return
            end

            execute( requester, commandOptions, preExecute )

        end

        base()

        self:postExecute( requester, commandOptions )
    end

    -- Post Execute command function
    --
    -- @param Player The requester of the command
    -- @param Array Words wrote right after the command name
    function chatCommand:postExecute( requester, commandOptions )
        local base = function()
        end

        local postExecute = function()
            base()

            if ( self.options[ OPTION_POSTEXECUTE ] and 
                isFunction( self.options[ OPTION_POSTEXECUTE ] ) ) then
                return self.options[ OPTION_POSTEXECUTE ]( requester, commandOptions )
            else 
                return nil
            end
        end

        postExecute()
    end

    -- Getters
    function chatCommand:getName()
        return self.name
    end
    function chatCommand:getOptions()
        return tableCopy( self.options )
    end
    function chatCommand:getPrefix()
        return self:getOptions()[ OPTION_PREFIX ]
    end
    function chatCommand:getRestricted()
        return tableCopy( self:getOptions()[ OPTION_WHITELIST ] )
    end
    function chatCommand:getShowMessage()
        return self:getOptions()[ OPTION_SHOWCOMMAND ]
    end

    if CLIENT then
        function chatCommand:getScope()
            return self:getOptions()[ OPTION_PLAYER ]
        end
    end

    setmetatable( chatCommand, {__call = chatCommand.new } )

end