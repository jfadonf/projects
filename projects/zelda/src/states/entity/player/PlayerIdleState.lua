--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    -- change the animation to pot idle
    if self.entity.havePot then
        self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
    end
end

function PlayerIdleState:update(dt)
    if self.entity.havePot then
        -- directions
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
           love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('walk')
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            -- throw the pot and change the player state to idle without pot
        end

    else
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
           love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('walk')
        end

        if love.keyboard.wasPressed('space') and not self.entity.havePot then
            self.entity:changeState('swing-sword')
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            self.entity:changeState('pot-lift')
        end
    end
end
