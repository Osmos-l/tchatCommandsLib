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
        if ( toValid['prefix'] == nil or not 
             isString( toValid['prefix'] ) ) then
            return false
        end
        if ( toValid['execute'] == nil or not
             isFunction( toValid['execute'] ) ) then
            return false
        end
        if ( toValid['player'] == nil or not
             isString( toValid['player'] ) ) then
            return false
        end
        if ( toValid['player'] ~= COMMAND_TARGET_SINGLE and
             toValid['player'] ~= COMMAND_TARGET_ALL ) then
            return false
        end
        if ( toValid['showCommand'] == nil or not 
             isBool( toValid['showCommand'] ) ) then
            return false
        end

        return true
    end

    --[[
        Constructor of chatCommand class

        @param String name The command name
        @param Array options The different options of the command

        @return chatCommand
    ]]
    function chatCommand:new( name, options )
        if ( not isValidCommandName( name ) ) then 
            error( ERROR_UNVALID_NAME )
            return 
        end

        if ( not isValidCommandOptions( options ) ) then 
            error( ERROR_UNVALID_OPTIONS )
            return 
        end

        if ( not options['whitelist'] or not isTable( options['whitelist'] ) ) then
            options['whitelist'] = {
                ["usergroup"] = {},
                ["steamid"] = {},
                ["steamid64"] = {},
                ["team"] = {}
            }
        end

        local command = {
            name = name,
            options = options
        }

        setmetatable( command, chatCommand )

        return command
    end
    
    function chatCommand:preExecute( requester )
        local base = function()
            // LIKE if client and requester ~= LocalPlayer() then return end
        end

        local preExecute = function()
            base()

            if ( self.options["preExecute"] and 
                isFunction( self.options["preExecute"] ) ) then
                return self.options["preExecute"]( requester )
            else 
                return nil
            end
        end

        return preExecute()
    end

    function chatCommand:execute( requester, commandOptions )
        local preExecute = { self:preExecute( requester, commandOptions ) }

        local execute = self.options["execute"]
        execute( requester, commandOptions, preExecute )

        self:postExecute( requester, commandOptions )
    end

    function chatCommand:postExecute()
    end
    -- Getters
    function chatCommand:getName()
        return self.name
    end
    function chatCommand:getOptions()
        return tableCopy( self.options )
    end
    function chatCommand:getPrefix()
        return self:getOptions()['prefix']
    end
    function chatCommand:getRestricted()
        return tableCopy( self:getOptions()['whitelist'] )
    end

    setmetatable( chatCommand, {__call = chatCommand.new } )

end