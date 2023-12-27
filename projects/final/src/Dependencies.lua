--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com
]]


--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--
-- our own code
--

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- StateMachine: game states
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/StatisticState'
require 'src/states/game/PlayState'
require 'src/states/game/EndState'

-- StateMachine: entity states
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerRightState'
require 'src/states/entity/PlayerLeftState'
require 'src/states/entity/PlayerDieState'
require 'src/states/entity/PlayerWinState'

require 'src/states/entity/cake/CakeEmergingState'
require 'src/states/entity/cake/CakeChasingState'
require 'src/states/entity/cake/CakeDyingState'

-- general
require 'src/Animation'
require 'src/Entity'
-- require 'src/GameObject'
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/Bullet'
require 'src/Cake'

-- Sound: initiation
gSounds = {
    ['cakeEmerging'] = love.audio.newSource('sounds/cakeEmerging.wav', 'static'),
    ['cakeExplosion'] = love.audio.newSource('sounds/cakeExplosion.wav', 'static'),
    ['cakeHit'] = love.audio.newSource('sounds/cakeHit.wav', 'static'),
    ['highScore'] = love.audio.newSource('sounds/highScore.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['playerDies'] = love.audio.newSource('sounds/playerDies.wav', 'static'),
    ['playerJump'] = love.audio.newSource('sounds/playerJump.wav', 'static'),
    ['playerLand'] = love.audio.newSource('sounds/playerLand.wav', 'static'),
    ['reachGoal'] = love.audio.newSource('sounds/reachGoal.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['shoot'] = love.audio.newSource('sounds/shoot.wav', 'static'),
}

-- Graphic: initiation of textures
gTextures = {
--     ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
--     ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
--     ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
--     ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
--     ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['startScreen'] = love.graphics.newImage('graphics/startScreen.jpg'),
    ['level1Background'] = love.graphics.newImage('graphics/level1Background.jpg'),
    ['level1Backgrounddata'] = love.image.newImageData('graphics/level1Background.jpg'),
    ['level2Background'] = love.graphics.newImage('graphics/level2Background.jpg'),
    ['level2Backgrounddata'] = love.image.newImageData('graphics/level2Background.jpg'),
    ['level3Background'] = love.graphics.newImage('graphics/level3Background.jpg'),
    ['level3Backgrounddata'] = love.image.newImageData('graphics/level3Background.jpg'),
    ['purple-cube'] = love.graphics.newImage('graphics/purple_cube.png'),
    ['cake'] = love.graphics.newImage('graphics/cake.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png'),
--     ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
--     ['key-lock'] = love.graphics.newImage('graphics/keys_and_locks.png'),
--     ['poles'] = love.graphics.newImage('graphics/flags.png'),
--     ['flags'] = love.graphics.newImage('graphics/flags.png')
}

gFrames = {
--     ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
--     
--     ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
--     
--     ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
--     ['jump-blocks'] = GenerateQuads(gTextures['jump-blocks'], 16, 16),
--     ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
--     ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128)
    ['purple-cube'] = GenerateQuads(gTextures['purple-cube'], CUBE_SIZE, CUBE_SIZE),
    ['cake'] = GenerateQuads(gTextures['cake'], CAKE_WIDTH, CAKE_HEIGHT)
--     ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
--     ['key-lock'] = GenerateQuads(gTextures['key-lock'], 16, 16),
--     ['poles'] = GenerateQuads(gTextures['flags'], 16, 48),
--     ['flags'] = GenerateQuads(gTextures['flags'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['extralarge'] = love.graphics.newFont('fonts/font.ttf', 64)
--    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}
