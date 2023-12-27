--[[
    GD50
    Final project: Cube in home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

CakeEmergingState = Class{__includes = BaseState}

function CakeEmergingState:init(cake)
    self.cake = cake

    

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.cake.currentAnimation = self.animation

    self.scale = 0

    -- in 1 second, the cake emerges from the fort from 0 to full size.
    Timer.tween(3, {
        [self.cake] = {scale = 1}
    })

    -- sound
    gSounds['cakeEmerging']:stop()
    gSounds['cakeEmerging']:play()
    
    --after this 1 second procedure, change state to chasing

    Timer.after(3, function()
        self.cake:changeState('chasing')
        self.cake.mode = 'chasing'
    end)
end

function CakeEmergingState:update(dt)
    -- update timer
    Timer.update(dt)
end

