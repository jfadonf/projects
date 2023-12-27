--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

StartState = Class{__includes = BaseState}

function StartState:enter(def)
    self.lives = def.lives
    self.scores = 0
    self.gameLevel = 1
    self.theHighestScore = def.theHighestScore

    -- Sounds:
    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        -- sound
        gSounds['select']:play()


        gStateMachine:change('statistic', {
            lives = self.lives,
            scores = self.scores,
            theHighestScore = self.theHighestScore,
            gameLevel = self.gameLevel
        })
    end
end

function StartState:render()
    love.graphics.draw(gTextures['startScreen'], 0, 0, 0, 0.3, 0.3)
--    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
--        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
--    self.map:render()

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Cubes in my home.', 1, VIRTUAL_HEIGHT / 3 * 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Cubes in my home.', 0, VIRTUAL_HEIGHT / 3 * 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 3 * 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 3 * 2 + 16, VIRTUAL_WIDTH, 'center')
end
