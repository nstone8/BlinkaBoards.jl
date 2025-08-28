using Conda
Conda.pip_interop(true)
Conda.pip("install",["Adafruit-Blinka",
                     "hidapi"])
