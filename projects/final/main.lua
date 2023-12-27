--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com

]]

-- Graphic: filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- Dependencies
require 'src/Dependencies'

-- load block
function love.load()
    -- Graphic: font
    love.graphics.setFont(gFonts['medium'])
    -- window title
    love.window.setTitle('Cubes in my home')

    -- randomseed
    math.randomseed(os.time())
    
    -- Graphic: setup screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    -- StateMachine:
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['statistic'] = function() return StatisticState() end,
        ['play'] = function() return PlayState() end,
        ['end'] = function() return EndState() end
    }
    gStateMachine:change('start', {
        lives = 3,
        theHighestScore = 5000
    })


    -- Input: keyboard table
    love.keyboard.keysPressed = {}
end

-- Graphic: window resize 
function love.resize(w, h)
    push:resize(w, h)
end

-- Input: record keyboard input and define escape to quit
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

