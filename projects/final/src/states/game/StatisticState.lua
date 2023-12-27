--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

StatisticState = Class{__includes = BaseState}

function StatisticState:enter(params)
    self.lives = params.lives
    self.scores = params.scores
    self.gameLevel = params.gameLevel
    self.theHighestScore = params.theHighestScore

    -- LevelMaker.generate()
    self.level = LevelMaker.generate(self.gameLevel)

    -- gSound music pause
    gSounds['music']:pause()


    -- display the statistic for 2 seconds
    Timer.after(3, function()
        gStateMachine:change('play', {
            lives = self.lives - 1,
            scores = self.scores,
            gameLevel = self.gameLevel,
            level = self.level,
            theHighestScore = self.theHighestScore
        })
    end)
end


function StatisticState:update(dt)
    Timer.update(dt)


end

function StatisticState:render()
    -- display the lives on the top-left of the screen
    love.graphics.printf('lives:', 50, 50, 200, 'left')
    for i = 1, self.lives do
        love.graphics.draw(gTextures['purple-cube'], gFrames['purple-cube'][1], 100 + 60 * i, 35)
    end

    -- display the scores on the top-right of the screen
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('scores: ' .. self.scores, 450, 50, 300, 'left')

    -- display the gameLevel in the middle of the screen
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Level: ' .. self.gameLevel, VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 - 10, 300, 'center')
end
