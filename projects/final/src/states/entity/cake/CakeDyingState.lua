--[[
    GD50
    Cube in home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

CakeDyingState = Class{__includes = BaseState}

function CakeDyingState:init(cake)
    self.cake = cake

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.cake.currentAnimation = self.animation

    self.cake.visible = false
    
    -- sound
    gSounds['cakeExplosion']:stop()
    gSounds['cakeExplosion']:play()

    -- flash cake
    Timer.after(0.5, function()
        self.cake.visible = true
    end)
    Timer.after(1, function()
        self.cake.visible = false
    end)
    Timer.after(1.5, function()
        self.cake.visible = true
    end)
    Timer.after(2, function()
        self.cake.visible = false
    end)
    Timer.after(2.5, function()
        self.cake.alive = false
    end)
end

function CakeDyingState:update(dt)
    -- update timer
    Timer.update(dt)
end

