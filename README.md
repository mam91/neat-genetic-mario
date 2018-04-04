# NeatResearch

Update to Seth Bling's Mar I/O lua code.  

Added coins/score/damage to fitness calculation.

Added version with weighted distance: added circle around mario where enemies inside the circle are treated as most important and enemies outside of the circle have their weights reduced depending on how far outside the circle.

Added a start/stop button so that the algorithm doesn't auto-start on load and so that one can easily pause the algorithm.

For some reason, the load feature did not work on my machine.  This is now fixed so that I can load a previously saved pool.

Moved the neat graphics to the form window instead of as a gui overlay.  I liked the gui overlay but I prefer to to separate the game window from the neat information.

Did some miscellaneous house-keeping, like moving global config settings into their own file, etc.

## Instructions
1. Install [BizHawk](https://github.com/TASVideos/BizHawk) prerequesites & emulator:
   1. [BizHawk prerequesites (currently 2.1)](https://github.com/TASVideos/BizHawk-Prereqs/releases)
   2. [BizHawk (currently 2.2.2)](https://github.com/TASVideos/BizHawk/releases)
2. Get the rom of [Super Mario World (USA)](https://www.google.de/search?q=Super+Mario+World+(USA).sfc). (Other Super Mario World roms might work too but are not tested)

CRC | MD5 | SHA1
------------- | ------------- | -------------
B19ED489 | CDD3C8C37322978CA8669B34BC89C804 | 6B47BB75D16514B6A476AA0C73A683A2A4C18765
3. Clone the repository or download the zip file and place the neat-mario folder in your \BizHawk-2.2\Lua\SNES\ folder. (like: BizHawk-2.2\Lua\SNES\neat-mario)
4. Open config.lua and change variable _M.BizhawkDir to point on your BizHawk directory.
5. Open BizHawk (EmuHawk.exe)
6. Click File > Open ROM (Ctrl + O) and find Super Mario World (USA).sfc file. 
7. Once loaded, click Tools > Lua Console
8. In the new window, click Script > Open Script (Ctrl + O) and select mario-neat.lua in your \BizHawk-2.2\Lua\SNES\neat-mario folder.
9. The NEAT control window will display and you can then click Start to begin training.
