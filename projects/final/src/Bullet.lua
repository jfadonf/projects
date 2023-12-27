--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Bullet = Class{}

function Bullet:init(def)
    -- init from def
    self.x = def.x
    self.y = def.y
    self.horizonDirection = def.horizonDirection
    self.verticalDirection = def.verticalDirection
    
    -- init from constants
    self.height = BULLET_HEIGHT
    self.width = BULLET_WIDTH
    self.speed = BULLET_SPEED
    self.diffX = 0
    self.diffY = 0
    self.kind = 1
    self.HP = 1

    -- calculate the vx and vy
    self.speed2 = (BULLET_SPEED^2/2)^(1/2)

    if self.verticalDirection == 1 then
        if self.horizonDirection == 'left' then
            self.vx = -self.speed2
            self.vy = -self.speed2
        elseif self.horizonDirection == 'right' then
            self.vx = self.speed2
            self.vy = -self.speed2
        elseif self.horizonDirection == 'center' then
            self.vx = 0
            self.vy = -self.speed
        end
    elseif self.verticalDirection == 0 then
        if self.horizonDirection == 'left' then
            self.vx = -self.speed
            self.vy = 0
        elseif self.horizonDirection == 'right' then
            self.vx = self.speed
            self.vy = 0
        end
    elseif self.verticalDirection == -1 then
        if self.horizonDirection == 'left' then
            self.vx = -self.speed2
            self.vy = self.speed2
        elseif self.horizonDirection == 'right' then
            self.vx = self.speed2
            self.vy = self.speed2
        elseif self.horizonDirection == 'center' then
            self.vx = 0
            self.vy = self.speed
        end
    end
end


function Bullet:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function Bullet:update(dt)
    -- update bullets position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- accumulate distance
    self.diffX = self.diffX + self.vx * dt
    self.diffY = self.diffY + self.vy * dt

    -- if bullets exceed the max distance, delete them.
    if math.abs(self.diffX) > gStateMachine.current.level.width or math.abs(self.diffY) > gStateMachine.current.level.height then
        self.HP = 0
    end
end

function Bullet:render()
    -- Set the color
    love.graphics.setColor(128/255, 0, 128/255)

    -- Draw a filled square at position (x, y) with a width and height of 100
    love.graphics.rectangle("fill", self.x + CUBE_SIZE / 2 - self.width / 2, self.y + CUBE_SIZE / 2 - self.height / 2, self.width, self.height)

    -- set color
    love.graphics.setColor(255/255, 223/255, 0)
    
    -- Draw a filled square at position (x, y) with a width and height of 100
    love.graphics.rectangle("line", self.x + CUBE_SIZE / 2 - self.width / 2, self.y + CUBE_SIZE / 2 - self.height / 2, self.width, self.height)
    
    -- set color
    love.graphics.setColor(1, 1, 1)
end
