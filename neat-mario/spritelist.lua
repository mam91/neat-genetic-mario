-- Idea from: https://github.com/kevino5233/MarIO_Enhanced/
-- Spritelist from: https://www.smwcentral.net/?p=viewthread&t=7562
-- Extended spritelist: https://web.archive.org/web/20170709102356/www.smwiki.net/wiki/RAM_Address/$7E:170B
--

local _M = {}

_M.Sprites = {}

-- Make sure this list is sorted before initialization.
_M.NeutralSprites = {
				0x0E,		-- Keyhole.
				0x2C,		-- Yoshi egg Red/Blue/Yellow/Blue (X&3).
				0x2D,		-- Baby green Yoshi.
				0x2F,		-- Portable spring board.
				0x35,		-- Green Yoshi.
				0x3E,		-- POW, blue/silver (X&1).
				0x41,		-- Dolphin, horizontal.
				0x42,		-- Dolphin2, horizontal.
				0x43,		-- Dolphin, vertical.
				0x49,		-- Growing/shrinking pipe end.
				0x4A,		-- Goal Point Question Sphere.
				0x52,		-- Moving ledge hole in ghost house.
				0x53,		-- ???
				0x54,		-- Climbing net door, use with object 0x4A-E.
				0x55,		-- Checkerboard platform, horizontal.
				0x56,		-- Flying rock platform, horizontal.
				0x57,		-- Checkerboard platform, vertical.
				0x58,		-- Flying rock platform, vertical.
				0x59,		-- Turn block bridge, horizontal and vertical.
				0x5A,		-- Turn block bridge, horizontal.
				0x5B,		-- Brown platform floating in water.
				0x5C,		-- Checkerboard platform that falls.
				0x5D,		-- Orange platform floating in water.
				0x5E,		-- Orange platform, goes on forever.
				0x5F,		-- Brown platform on a chain.
				0x60,		-- Flat green switch palace switch.
				0x61,		-- Floating skulls.
				0x62,		-- Brown platform, line-guided.
				0x63,		-- Checker/brown platform, line-guided (X&1).
				0x64,		-- Rope mechanism, line-guided (X&1).
				0x6A,		-- Coin game cloud.
				0x6B,		-- Spring board, left wall.
				0x6C,		-- Spring board, right wall.
				0x6D,		-- Invisible solid block.
				0x79,		-- Growing Vine.
				0x7C,		-- ???
				0x80,		-- Key.
				0x81,		-- Changing item from a translucent block.
				0x87,		-- Lakitu's cloud, no time limit. (!)
				0x8A,		-- Bird from Yoshi's house, max of 4.
				0x8B,		-- Puff of smoke from Yoshi's house.
				0xA3,		-- Grey platform on chain, clockwise/counter (X&1).
				0xBA,		-- Timed lift, 4 sec/1 sec (X&1).
				0xC0,		-- Grey platform on lava, sinks.
				0xC4,		-- Grey platform that falls.
				0xC8,		-- Light switch block for dark room.
				0xC9,		-- ???
				0xDA,		-- Green Koopa shell.
				0xDB,		-- Red Koopa shell.
				0xDC,		-- Blue Koopa shell.
				0xDD,		-- Yellow Koopa shell.
				0xDF,		-- Green shell, won't use Special World color.
				0xE0		-- 3 platforms on chains, clockwise/counter (X&1).
			}

-- Make sure this list is sorted before initialization.
_M.GoodSprites = {
				0x21,		-- Moving coin.
				0x45,		-- Directional coins, no time limit.
				0x74,		-- Mushroom.
				0x75,		-- Flower.
				0x76,		-- Star.
				0x77,		-- Feather.
				0x78,		-- 1-UP.
				0x7B,		-- Standard Goal Point.
							-- "Secret" Goal Point.
				0x83,		-- Left flying question block, coin/flower/feather/1-UP (X&3).
				0x84,		-- Flying question block, coin/flower/feather/1-UP (X&3).
				0xC1,		-- Flying grey turnblocks, first up/down (X&1).
				0xC7		-- Invisible mushroom.
			}

-- Currently not used.
_M.BadSprites = {
				0x00,		-- Green Koopa, no shell.
				0x01,		-- Red Koopa, no shell.
				0x02,		-- Blue Koopa, no shell.
				0x03,		-- Yellow Koopa, no shell.
				0x04,		-- Green Koopa.
				0x05,		-- Red Koopa.
				0x06,		-- Blue Koopa.
				0x07,		-- Yellow Koopa.
				0x08,		-- Green Koopa, flying left.
				0x09,		-- Green bouncing Koopa (Y&1).
				0x0A,		-- Red vertical flying Koopa.
				0x0B,		-- Red horizontal flying Koopa.
				0x0C,		-- Yellow Koopa with wings.
				0x0F,		-- Goomba.
				0x10,		-- Bouncing Goomba with wings.
				0x1A,		-- Classic Pirhana Plant (use ExGFX).
				0x1C,		-- Bullet Bill.
				0x4F,		-- Jumping Pirhana Plant.
				0x50,		-- Jumping Pirhana Plant, spit fire.
				0x7E,		-- Flying Red coin, worth 5 coins.
				0x7F,		-- Flying Yellow 1-UP.
				0xB1,		-- Creating/Eating block (X&1).
				0xB9,		-- Info Box, message 1/2 (X&1).
				0xBD,		-- Sliding Koopa without a shell.
				0x0D,		-- Bob-omb.
				0x11,		-- Buzzy Beetle.
				0x13,		-- Spiny.
				0x14,		-- Spiny falling.
				0x15,		-- Fish, horizontal.
				0x16,		-- Fish, vertical.
				0x18,		-- Surface jumping fish.
				0x1B,		-- Bouncing football in place.
				0x1D,		-- Hopping flame.
				0x1E,		-- Lakitu Normal/Fish (X&1).
				0x1F,		-- Magikoopa.
				0x20,		-- Magikoopa's magic, stationary.
				0x22,		-- Green vertical net Koopa, below/above (X&1).
				0x23,		-- Red fast vertical net Koopa, below/above (X&1).
				0x24,		-- Green horizontal net Koopa, below/above (X&1).
				0x25,		-- Red fast horizontal net Koopa, below/above (X&1).
				0x26,		-- Thwomp.
				0x27,		-- Thwimp.
				0x28,		-- Big Boo.
				0x29,		-- Koopa Kid (place at X=12, Y=0 to 6).
				0x2A,		-- Upside down Piranha Plant.
				0x2B,		-- Sumo Brother's fire lightning.
				0x2E,		-- Spike Top.
				0x30,		-- Dry Bones, throws bones.
				0x31,		-- Bony Beetle.
				0x32,		-- Dry Bones, stay on ledge.
				0x33,		-- Fireball, vertical. Requires buoyancy!
				0x34,		-- Boss fireball, stationary.
				0x37,		-- Boo.
				0x38,		-- Eerie.
				0x39,		-- Eerie, wave motion.
				0x3A,		-- Urchin, fixed vertical/horizontal (X&1).
				0x3B,		-- Urchin, wall detect v/h (X&1).
				0x3C,		-- Urchin, wall follow clockwise/counter (X&1).
				0x3D,		-- Rip Van Fish.
				0x3F,		-- Para-Goomba.
				0x40,		-- Para-Bomb.
				0x44,		-- Torpedo Ted.
				0x47,		-- Swimming/Jumping fish, doesn't need water. (!)
				0x48,		-- Diggin' Chuck's rock.
				0x46,		-- Diggin' Chuck.
				0x4B,		-- Pipe dwelling Lakitu.
				0x4C,		-- Exploding Block, fish/goomba/Koopa/Koopa with shell (X&3).
				0x4D,		-- Ground dwelling Monty Mole, follow/hop (X&1).
				0x4E,		-- Ledge dwelling Monty Mole, follow/hop (X&1).
				0x51,		-- Ninji.
				0x65,		-- Chainsaw, line-guided, right/left (X&1).
				0x66,		-- Upside down chainsaw, line-guided, null/left (X&1).
				0x67,		-- Grinder, line-guided, right/left (X&1).
				0x68,		-- Fuzz Ball, line-guided, right/left (X&1).
				0x6E,		-- Dino Rhino.
				0x6F,		-- Dino Torch.
				0x70,		-- Pokey.
				0x71,		-- Super Koopa, red cape, swoop.
				0x72,		-- Super Koopa, yellow cape, swoop.
				0x73,		-- Super Koopa, feather/yellow cape (X&1).
				0x7A,		-- Firework, makes Mario temporarily invisible.
				0x86,		-- Wiggler.
				0x8D,		-- Ghost house exit sign and door.
				0x8E,		-- Invisible "Warp Hole" blocks. (!)
				0x8F,		-- Scale platforms, long/short between (X&1).
				0x90,		-- Large green gas bubble.
				0x91,		-- Chargin' Chuck.
				0x92,		-- Splitin' Chuck.
				0x93,		-- Bouncin' Chuck.
				0x94,		-- Whistlin' Chuck, fish/Koopa (X&1).
				0x95,		-- Clapin' Chuck.
				0x97,		-- Puntin' Chuck.
				0x98,		-- Pitchin' Chuck.
				0x99,		-- Volcano Lotus.
				0x9A,		-- Sumo Brother.
				0x9B,		-- Hammer Brother (requires sprite 9C).
				0x9C,		-- Flying blocks for Hammer Brother.
				0x9D,		-- Bubble with Goomba/bomb/fish/mushroom (X&3).
				0x9E,		-- Ball and Chain, clockwise/counter (X&1).
				0x9F,		-- Banzai Bill.
				0xA2,		-- MechaKoopa.
				0xA4,		-- Floating Spike ball, slow/fast (X&1).
				0xA5,		-- Fuzzball/Sparky, ground-guided, left/right (X&1).
				0xA6,		-- HotHead, ground-guided, left/right (X&1).
				0xA8,		-- Blargg.
				0xAA,		-- Fishbone.
				0xAB,		-- Rex.
				0xAC,		-- Wooden Spike, moving down and up.
				0xAD,		-- Wooden Spike, moving up/down first (X&1).
				0xAE,		-- Fishin' Boo.
				0xAF,		-- Boo Block.
				0xB0,		-- Reflecting stream of Boo Buddies.
				0xB2,		-- Falling Spike.
				0xB3,		-- Bowser statue fireball.
				0xB4,		-- Grinder, non-line-guided.
				0xB6,		-- Reflecting fireball.
				0xB7,		-- Carrot Top lift, upper right.
				0xB8,		-- Carrot Top lift, upper left.
				0xBB,		-- Grey moving castle block, horizontal.
				0xBC,		-- Bowser statue, normal/fire/leap (X&3).
				0xBE,		-- Swooper Bat, hang/fly/fly/fly (X&3).
				0xBF,		-- Mega Mole. 
				0xC2,		-- Blurp fish.
				0xC3,		-- A Porcu-Puffer fish. 
				0xC5,		-- Big Boo Boss.
				0xC6,		-- Dark room with spot light.
				0xDE,		-- Group of 5 eeries, wave motion.
				0xE2,		-- Boo Buddies, counter-clockwise.
				0xE3		-- Boo Buddies, clockwise.
			}

function _M.InitSpriteList()
    local k = 1
    local j = 1
    for i=1, 256 do
        local isGood = (k <= #_M.GoodSprites) and (_M.GoodSprites[k] == i - 1)
        local isNeutral = (j <= #_M.NeutralSprites) and (_M.NeutralSprites[j] == i - 1)
        if isGood then
            k = k + 1
            _M.Sprites[#_M.Sprites + 1] = 1
        elseif isNeutral then
            j = j + 1
            _M.Sprites[#_M.Sprites + 1] = 0
        else
            _M.Sprites[#_M.Sprites + 1] = -1
        end
    end
end

_M.extSprites = {}

-- Make sure this list is sorted before initialization.
_M.ExtNeutralSprites = {
    0x01,		-- Puff of smoke with various objects.
	0x03,		-- Flame left by hopping flame.
	0x05,		-- Player fireball.
    0x0A,		-- Coin from coin cloud game.
    0x0F,		-- Trail of smoke (yellow Yoshi stomping the ground).
    0x10,		-- Spinjump stars.
    0x11,		-- Yoshi fireballs.
    0x12		-- Water bubble.
}

-- Currently not used.
_M.ExtBadSprites = {
    0x02,		-- Reznor fireball.
    0x04,		-- Hammer.
    0x06,		-- Bone from Dry Bones.
    0x07,		-- Lava splash.
    0x08,		-- Torpedo Ted shooter's arm.
    0x09,		-- Unknown flickering object
    0x0B,		-- Piranha Plant fireball.
    0x0C,		-- Lava Lotus's fiery objects.
    0x0D,		-- Baseball.
    0x0E		-- Wiggler's flower.
}

function _M.InitExtSpriteList()
    local j = 1
    for i=1, 21 do
        local isExtNeutral = (j <= #_M.ExtNeutralSprites) and (_M.ExtNeutralSprites[j] == i - 1)
        if isExtNeutral then
            j = j + 1
            _M.extSprites[#_M.extSprites + 1] = 0
        else
            _M.extSprites[#_M.extSprites + 1] = -1
        end
    end
end

return _M