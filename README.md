# Neat[Tinkering]
Update to [Seth Bling's Mar I/O][1] lua code, forked from [mam91/Neat-Genetic-Mario][2].

## (Planned) additions & changes ##
* [x] [Fixed function which determines if Mario got hit].
* [x] [Added a variable for BizHawk path to make setup easier].
* * [x] [Added instructions to Readme][Readme#1].
* [x] [Include lists of good/neutral for both sprites and extended sprites].
* [x] [Include powerups to fitness calculation]. (as antagonist to the damage counter)
* [x] [Option to start with specific powerup].
* [x] [Give bonus for received 1-Ups].
* [ ] Move bonus multiplicators to config.
* [ ] Show fitness calculation in GUI.
* [ ] Make GUI drawing optional. (Network & data)
* [ ] Make the drawing of the circle optional & disable it in overworld. (just cosmetical changes)
* [ ] Let the **Restart** button appear again.
* [ ] Reorganize the control form.

## Readme from [original repository][2]
> Added coins/score/damage to fitness calculation.
>
> Added version with weighted distance: added circle around mario where enemies inside the circle are treated as most important and enemies 
> outside of the circle have their weights reduced depending on how far outside the circle.
>
> Added a start/stop button so that the algorithm doesn't auto-start on load and so that one can easily pause the algorithm.
>
> For some reason, the load feature did not work on my machine.  This is now fixed so that I can load a previously saved pool.
>
> Moved the neat graphics to the form window instead of as a gui overlay.  I liked the gui overlay but I prefer to to separate the game > window from the neat information.
>
> Did some miscellaneous house-keeping, like moving global config settings into their own file, etc.
=======
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

[1]:https://github.com/wts42/Neat-Genetic-Mario/wiki/MarI-O
[2]:https://github.com/mam91/Neat-Genetic-Mario
[Fixed function which determines if Mario got hit]:https://github.com/mam91/Neat-Genetic-Mario/commit/d5ec3aaded533f1c5061e144e6c3b250d6f63e28
[Added a variable for BizHawk path to make setup easier]:https://github.com/wts42/Neat-Genetic-Mario/commit/9c920eb34be55a69c751cf5e725516a1ab2c6205
[Readme#1]:https://github.com/wts42/Neat-Genetic-Mario/commit/7b87f31eda57beced08bd360c4ec620c17375e8c
[Include lists of good/neutral for both sprites and extended sprites]:https://github.com/wts42/Neat-Genetic-Mario/commit/95179cf7b655daca9586980c1248cd0027131330
[Include powerups to fitness calculation]:https://github.com/wts42/Neat-Genetic-Mario/pull/3
[Option to start with specific powerup]:https://github.com/wts42/Neat-Genetic-Mario/pull/3
[Give bonus for received 1-Ups]:https://github.com/wts42/Neat-Genetic-Mario/pull/3
[BizHawk]:https://github.com/TASVideos/BizHawk
[BizHawk prerequesites]:https://github.com/TASVideos/BizHawk-Prereqs/releases
[BizHawk binaries]:https://github.com/TASVideos/BizHawk/releases
[Super Mario World (USA)]:https://www.google.de/search?q=Super+Mario+World+(USA).sfc

[Tinkering]:http://togelius.blogspot.de/2016/04/the-differences-between-tinkering-and.html
=======
9. The NEAT control window will display and you can then click Start to begin training.
