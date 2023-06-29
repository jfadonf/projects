--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(obj, direction)
    
    -- string identifying this object type
    self.type = obj.type

    self.texture = obj.texture
    self.frame = obj.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = obj.solid

    -- whether it is taken or not
    self.isTaken = obj.isTaken

    self.states = obj.states
    self.defaultState = obj.defaultState
    self.state = self.defaultState

    -- dimensions
    self.x0 = obj.x
    self.y0 = obj.y
    self.x = obj.x
    self.y = obj.y
    self.width = obj.width
    self.height = obj.height

    -- default empty collision callback
    self.onCollide = function(
        
    ) end

    -- throw action
    self.dirction = direction
    self.distance = 4 * 16
    self.damage = 1
    self.speed = 20
    self.lifted = false

    -- state of isbroken
    self.isTaken = false

    print('have a projectile')
end

function Projectile:update(dt)
    if math.abs(self.x0 - self.x) >= self.distance or math.abs(self.y0 - self.y) >= self.distance then
        self.isTaken = true
    else
        if self.direction == 'left' then
            self.x = self.x - self.speed * dt
        elseif self.direction == 'right' then
            self.x = self.x + self.speed * dt
        elseif self.direction == 'up' then
            self.y = self.y - self.speed * dt
        else
            self.y = self.y + self.speed * dt
        end
    end
end

function Projectile:render()
end
