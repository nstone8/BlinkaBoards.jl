module BlinkaBoards

using PyCall

export BlinkaBoard

"""
```julia
BlinkaBoard()
```
Initialize a GPIO board using Blinka. On linux systems the following
commands should be executed in the system shell before attempting to connect:
- `sudo rmmod hid_mcp2221`:
  Remove the built-in driver for the mcp2221 chip
- `export BLINKA_MCP2221=1`:
  Tell Blinka what is connected to the computer (the MCP2221 is our usb adapter)
"""
struct BlinkaBoard
    board
    function BlinkaBoard()
        new(pyimport("board"))
    end
end

"""
```julia
i2c(blinka)
```
Get the i2c channel of a `BlinkaBoard`
"""
function i2c(b::BlinkaBoard)
    b.board.i2c
end

end # module BlinkaBoards
