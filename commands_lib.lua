-- /**
--  * Return if player is considered as a admin
--  *
--  * @param Player ply
--  * @return Boolean
--  */
-- local function isAdmin( ply )
--     return adminGroups[ ply:GetUserGroup() ]
-- end

-- local function isValidCommand( text )
--     return chatCommands[ command ] == nil
-- end

-- local function getCommand( text )
--     return table.Copy( chatCommands[ text ] )
-- end

-- /**
--  * Execute the command given in parameter
--  *
--  * @param String command
--  * @return null
--  */
-- local function executeCommand( text )
--     if ( !text ) or ( !isstring( text ) ) then return false end

--     text = strToLower( text )

--     if ( isValidCommand( text ) ) then
--         local command =  getCommand( text )

--         toExecute = function()
--             if ( command["admin"] and not isAdmin( ply ) ) then
--                 return
--             end
--             if ( command["callback"] ) then
--                 command["callback"]()
--             end

--             return not command["show_command"]
--         end
        
--         return toExecute()
--     end

--     return false
-- end

-- hook.Add( "OnPlayerChat", "OnPlayerChat::CommandsLib", function( ply, text )
--     if ply != LocalPlayer() then return nil end

--     return executeCommand( text )

-- end)