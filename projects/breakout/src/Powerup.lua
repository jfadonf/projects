--[[
    GD50
    Breakout remake

    -- Powerup Class --

    Author: Jiong
    jfadonf@gmail.com
    
    a kind of powerup that can drop and be touched by paddle. 
]]

Powerup = Class{}

function Powerup:init(x, y, kind)
    -- init position, kind of powerup type 
    self.x = x
    self.y = y
    self.dy = POWERUP_DROP_SPEED
    self.kind = kind
    self.inPlay = false
    self.active = false
end

function Powerup:collide(rectangle)
    if self.y > VIRTUAL_HEIGHT - 16 - 16 then
        if self.x + 16 > rectangle.x and rectangle.x + rectangle.width > self.x then
            return true
        else
            return false
        end
    else
        return false
    end
end



function Powerup:update(dt)
    -- drop through the gap above the paddle
    if self.active then
        self.y = self.y + self.dy * dt
    -- if sink under the screen then vanishes
        if self.y > VIRTUAL_HEIGHT then
            self.inPlay = false
            self.active = false
        end
    end
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.kind], self.x, self.y)
end
