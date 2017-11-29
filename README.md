# NeatResearch

Update to Seth Bling's Mar I/O lua code.  

Added coins/score/damage to fitness calculation.

Added version with weighted distance: added circle around mario where enemies inside the circle are treated as most important and enemies outside of the circle have their weights reduced depending on how far outside the circle.

Added a start/stop button so that the algorithm doesn't auto-start on load and so that one can easily pause the algorithm.

For some reason, the load feature did not work on my machine.  This is now fixed so that I can load a previously saved pool.

Moved the neat graphics to the form window instead of as a gui overlay.  I liked the gui overlay but I prefer to to separate the game window from the neat information.

Did some miscellaneous house-keeping, like moving global config settings into their own file, etc.
