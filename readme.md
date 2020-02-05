# Easy UI

## Example
Creates button on map ready
```lua
local exampleButton = EUI.CreateButton({
    text = 'CLICK ME',
    size = 'large',
    y = -0.1,
    origin = 'right',
    stickTo = 'right',
    onClick = function(self)
        self.text = 'CLICKED'
        print('exampleButton CLICKED')
    end
})

EUI.Ready(function ()
    EUI.GameFrame:AppendChild(exampleButton)
end)
```

## Development
```sh
# Build static
lua builder/builder.lua
```
