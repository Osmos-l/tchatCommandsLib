# :fire: commandsLib :fire:

commandsLib is a gLua library for commands chat in Garry's mod that make your life easier.

## Installation

- Download and import into garrysmod/addons/commandslib or garrysmod/lua/autorun
- Use it :grin:

## Usage

```lua
local isValid =  commandsLib.register( "hello", {
    ["prefix"] = { "/", "!" },
    ["execute"] = function( requester, options )
       chat.AddText( Color( 255, 0, 0), "Hi " .. requester:Name() )
    end,
    ["player"] = "local",
    ["showCommand"] = false
} )
```

More exemples:

- [Client](https://github.com/Osmos-l/tchatCommandsLib/blob/main/lua/autorun/client/exemple.lua)
- [Server](https://github.com/Osmos-l/tchatCommandsLib/blob/main/lua/autorun/server/exemple.lua)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
