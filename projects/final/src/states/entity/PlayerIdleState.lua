--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown(LEFT_KEY) then
        self.player:changeState('left')
    elseif love.keyboard.isDown(RIGHT_KEY) then
        self.player:changeState('right')
    elseif love.keyboard.wasPressed(JUMP_KEY) then
        self.player:changeState('jump')
    elseif love.keyboard.isDown(DOWN_KEY) then
        if self.player:isPlatformUnder() then
            self.player.y = self.player.y + 80 * dt
        else
            self.player:changeState('falling')
        end  
    end

    -- check if we've collided with any entities and die if so
--    for k, entity in pairs(self.player.level.entities) do
--        if entity:collides(self.player) then
--            gSounds['death']:play()
--            gStateMachine:change('start')
--        end
--    end
end
