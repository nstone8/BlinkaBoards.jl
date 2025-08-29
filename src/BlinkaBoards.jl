module BlinkaBoards

using PyCall

export BlinkaBoard, i2c, DigitalIOPin, setinput!, setoutput!, rawiopin, isinput, isoutput
export digitalread, digitalwrite!

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
    digitalio
    function BlinkaBoard()
        new(pyimport("board"),pyimport("digitalio"))        
    end
end

"""
```julia
i2c(blinka)
```
Get the i2c channel of a `BlinkaBoard`
"""
function i2c(b::BlinkaBoard)
    b.board.I2C()
end

"""
```
rawiopin(board,pin)
```
Get the python object representing the IO pin on a `BlinkaBoard`. This is currently specific
to the MCP2221, we should split this into another package if we start using a bunch of GPIO
boards
"""
rawiopin(b::BlinkaBoard,i::Int) = [b.board.G0,b.board.G1,b.board.G2,b.board.G3][i+1]

"""
```julia
DigitalIOPin(board,pin_num)
```
Build an object representing a Digital IO pin on a `BlinkaBoard`. The pin will be
configured as an output. This can be changed using `setinput!`.
"""
struct DigitalIOPin
    board
    pin
    output #is this an output pin? false corresponds to input
    function DigitalIOPin(b::BlinkaBoard,pin_num::Int)
        pin = b.digitalio.DigitalInOut(rawiopin(b,pin_num))
        pin.direction = b.digitalio.Direction.OUTPUT
        new(b,pin,true)
    end
end

"""
```julia
setinput!(pin)
```
Set a `DigitalIOPin` as an input
"""
function setinput!(pin::DigitalIOPin)
    pin.pin.direction = pin.board.digitialio.Direction.INPUT
    return nothing
end

"""
```julia
setoutput!(pin)
```
Set a `DigitalIOPin` as an output
"""
function setoutput!(pin::DigitalIOPin)
    pin.pin.direction = pin.board.digitialio.Direction.OUTPUT
    return nothing
end

"""
```julia
isoutput(pin)
```
Test if a `DigitalIOPin` is an output
"""
isoutput(pin::DigitalIOPin) = pin.output

"""
```julia
isinput(pin)
```
Test if a `DigitalIOPin` is an input
"""
isinput(pin::DigitalIOPin) = !pin.output

"""
```julia
digitalread(pin)
```
Read the value of a `DigitalIOPin`
"""
function digitalread(pin::DigitalIOPin)
    @assert isinput(pin)
    pin.pin.value
end

"""
```julia
digitalwrite!(pin,value)
```
Write a value to a `DigitalIOPin`
"""
function digitalwrite!(pin::DigitalIOPin,value::Bool)
    @assert isoutput(pin)
    pin.pin.value = value
    return nothing
end

end # module BlinkaBoards
