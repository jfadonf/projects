--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerDieState = Class{__includes = BaseState}

function PlayerDieState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {1, 3, 2, 4, 8, 7, 5, 6},
        interval = 0.05
    }
    self.player.currentAnimation = self.animation
    self.player.dy = -1000
    self.gravity = 15

    -- inform playstate that the player is dead
    self.player.alive = false

    -- sound
    gSounds['playerDies']:stop()
    gSounds['playerDies']:play()

    -- wait 2 seconds then change to statistic or end
    Timer.after(3, function()
        if gStateMachine.current.lives <= 0 then
            gStateMachine:change('end', {
                lives = gStateMachine.current.lives,
                scores = gStateMachine.current.scores,
                gameLevel = gStateMachine.current.gameLevel,
                theHighestScore = gStateMachine.current.theHighestScore
            })
        else
            gStateMachine:change('statistic', {
                lives = gStateMachine.current.lives,
                scores = gStateMachine.current.scores,
                gameLevel = gStateMachine.current.gameLevel,
                theHighestScore = gStateMachine.current.theHighestScore
            })
        end
    end)
end

function PlayerDieState:update(dt)
    -- timer update
    Timer.update(dt)

    -- animation update
    self.player.currentAnimation:update(dt)

    -- player position update
    self.player.dy = math.min(600, self.player.dy + self.gravity)
    self.player.y = self.player.y + (self.player.dy * dt)

end
