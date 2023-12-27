--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

EndState = Class{__includes = BaseState}

function EndState:enter(params)
    self.lives = params.lives
    self.scores = params.scores
    self.gameLevel = params.gameLevel
    self.theHighestScore = params.theHighestScore

    gSounds['music']:stop()

    self.flashScore = false

    self.notice = false

    -- update the highest score
    if self.theHighestScore < self.scores then
        self.theHighestScore = self.scores
        self.updateTheHighestScore = true
    end 

    -- display game over for 2 seconds
    Timer.after(2, function()
        -- desplay press enter to restart
        self.notice = true
    end)

    Timer.after(2, function()
        if self.updateTheHighestScore then
            -- sound
            gSounds['highScore']:stop()
            gSounds['highScore']:play()
        end
    end)
end


function EndState:update(dt)
    -- timer update
    Timer.update(dt)
 
    -- change to startstate when enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        -- sound
        gSounds['select']:play()

        gStateMachine:change('start', {
            lives = 3,
            theHighestScore = self.theHighestScore
        })
    end

        -- flash the highest score
    if self.updateTheHighestScore then
        Timer.every(0.5, function()
            self.flashScore = not self.flashScore
        end)
    end
end

function EndState:render()
    -- display the lives on the top-left of the screen
    love.graphics.printf('lives:', 50, 50, 200, 'left')
    for i = 1, self.lives do
        love.graphics.draw(gTextures['purple-cube'], gFrames['purple-cube'][1], 100 + 60 * i, 35)
    end

    -- display the scores on the top-right of the screen
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('scores: ' .. self.scores, 400, 50, 300, 'left')

    -- display the gameLevel in the middle of the screen
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Level: ' .. self.gameLevel, VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 - 10, 300, 'center')

    -- display the score and notice
    if self.notice then
        -- gameover
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf('Game Over', VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 - 80, 300, 'center')
       
        -- scores
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf('Scores: ' .. self.scores, VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 + 20, 300, 'center')

        -- the highest score
        if self.flashScore then
            love.graphics.setFont(gFonts['extralarge'])
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.printf('THE HIGHEST SCORE!', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
        end

        -- notice
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf('Press Enter to restart', 0, VIRTUAL_HEIGHT / 2 + 140, VIRTUAL_WIDTH, 'center')
    end
        
end
