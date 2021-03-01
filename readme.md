# commandsLib

commandsLib is a gLua library for tchat commands in Garry's mod.



## Usage

```lua
local isValid =  commandsLib.register( "hello", {
    ["prefix"] = { "/", "!" },
    ["execute"] = function( requester, options)
       chat.AddText( Color( 255, 0, 0), "HELLO WORLD" )
    end,
    ["player"] = "local",
    ["showCommand"] = false
} )
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
