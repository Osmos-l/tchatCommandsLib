do
    chatCommand = {}
    chatCommand.__index = chatCommand

    -- Const
    local ERROR_UNVALID_NAME = "Command name is unvalid"
    local ERROR_UNVALID_OPTIONS = "Command options are unvalid"

    local COMMAND_TARGET_SINGLE = "local"
    local COMMAND_TARGET_ALL    = "all"

    local function isValidCommandName( toValid )

        if ( toValid == nil or not isstring( toValid) ) then
            return false
        end

        if ( toValid == '' ) then
            return false
        end

        return true
    end

    local function isValidCommandOptions( toValid )
        
        if ( toValid == nil or not istable( toValid ) ) then
            return false
        end
        
        -- Essential options
        if ( toValid['prefix'] == nil or not 
             isstring( toValid['prefix'] ) ) then
            return false
        end
        if ( toValid['execute'] == nil or not
             isfunction( toValid['execute'] ) ) then
            return false
        end
        if ( toValid['player'] == nil or not
             isstring( toValid['player'] ) ) then
            return false
        end
        if ( toValid['player'] ~= COMMAND_TARGET_SINGLE and
             toValid['player'] ~= COMMAND_TARGET_ALL ) then
            return false
        end
        if ( toValid['showCommand'] == nil or not 
             isbool( toValid['showCommand'] ) ) then
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

        local command = {
            name = name,
            options = options
        }

        setmetatable( command, chatCommand )

        return command
    end
    
    function chatCommand:preExecute()
        local preExecute = function()
            return nil
        end

        if ( self.options["preExecute"] and 
             isfunction( self.options["preExecute"] ) ) then
            preExecute = self.options["preExecute"]
        end

        return preExecute()
    end

    function chatCommand:execute()
        local preExecute = { self:preExecute() }

        local execute = self.options["execute"]
        execute( "STUB", preExecute )

        self:postExecute()
    end

    function chatCommand:postExecute()
    end
    -- Getters
    function chatCommand:getName()
        return self.name
    end
    function chatCommand:getOptions()
        return self.options
    end
    function chatCommand:getPrefix()
        return self:getOptions()['prefix']
    end

    setmetatable( chatCommand, {__call = chatCommand.new } )

end