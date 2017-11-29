# NeatResearch

Update to Seth Bling's Mar I/O lua code.  

Added coins/score/damage to fitness calculation.

Added version with weighted distance: added circle around mario where enemies inside the circle are treated as most important and enemies outside of the circle have their weights reduced depending on how far outside the circle.

Added a start/stop button so that the algorithm doesn't auto-start on load and so that one can easily pause the algorithm.

For some reason, the load feature did not work on my machine.  This is now fixed so that I can load a previously saved pool.

Moved the neat graphics to the form window instead of as a gui overlay.  I liked the gui overlay but I prefer to to separate the game window from the neat information.

Did some miscellaneous house-keeping, like moving global config settings into their own file, etc.

Instructions

You will need the bizhawk emulator located here: http://tasvideos.org/BizHawk.html

And you will need the super mario world .rom file.  (Easy to find online)

Place the neat-mario folder in your \BizHawk-2.2\Lua\SNES\ folder, like BizHawk-2.2\Lua\SNES\neat-mario.
  
Open bizhawk, click open rom, find super mario world .rom file.  Once loaded, click Tools > Lua Console. In the new window, click script > open script.  Select mario-net.lua in your \BizHawk-2.2\Lua\SNES\neat-mario folder.  The neat control window will display and you can then click Start to begin training.
