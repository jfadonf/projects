--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

--[[
    Load the libraries:
        class
        event
        push
        timer

    Load game sprites classes:
        constants
        classes of game
        statemachine
        util

    Load map classes:
        Doorway
        dungeon
        room

    Load states:
        entity states
        player states
        game states

    Load Textures

    Load Frames

    Load Fonts
        
    Load Sounds
]]
require 'src/Dependencies'

--[[
    function: love.load 
        randomseed
        set title
        graphics: set filter
        push: setup screen
        set font
        instanciate gStateMachine
        gStateMachine: change to start
        make sound
        initiate keyboard
]]
function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Legend of Zelda')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

-- function: record the key which was pressed in the table love.keyboard.keysPressed
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- function: check whether the key in the table love.keyboard.keysPressed was pressed
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    function: love.update
        timer
        gstatemachine update
        keyboard: empty keyspressed table
]]
function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

--[[
    function: love.draw
        gstatemachine render
]]
function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
