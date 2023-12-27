--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWinState = Class{__includes = BaseState}

function PlayerWinState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {1, 3, 2, 4, 8, 7, 5, 6},
        interval = 0.05
    }
    self.player.currentAnimation = self.animation
    self.player.dy = 0
    self.gravity = -3

    -- inform playstate that the player is win
    gStateMachine.current.isPlayerWin = true

    -- sound
    gSounds['reachGoal']:play()

    -- wait 2 seconds then change to statistic or end
    Timer.after(3, function()
--        if gStateMachine.current.gameLevel == 3 then
--            gStateMachine:change('end', {
--                lives = gStateMachine.current.lives + 1,
--                scores = gStateMachine.current.scores,
--                gameLevel = gStateMachine.current.gameLevel,
--                theHighestScore = gStateMachine.current.theHighestScore
--            })
--        else
            gStateMachine:change('statistic', {
                lives = gStateMachine.current.lives + 1,
                scores = gStateMachine.current.scores,
                gameLevel = gStateMachine.current.gameLevel % NUMBER_OF_LEVEL + 1,
                theHighestScore = gStateMachine.current.theHighestScore
            })
--        end
    end)
end

function PlayerWinState:update(dt)
    -- timer update
    Timer.update(dt)

    -- animation update
    self.player.currentAnimation:update(dt)

    -- player position update
    self.player.dy = math.min(1000, self.player.dy + self.gravity)
    self.player.y = self.player.y + (self.player.dy * dt)

end
