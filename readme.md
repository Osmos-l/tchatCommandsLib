# commandsLib

commandsLib is a gLua library for commands chat in Garry's mod.
I'm actually work in, only client side commands work.
You can contribute for sure :)


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

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
