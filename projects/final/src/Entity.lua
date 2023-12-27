--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def) -- x, y, width, height, texture, stateMachine, level
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = 'left'

    -- reference to level so we can check collisions of platforms
    -- of entities and of objects
    self.level = def.level
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:collides(entity)
    return not (self.collideX > entity.x + entity.width or entity.x > self.collideX + self.width or
                self.collideY > entity.y + entity.height or entity.y > self.collideY + self.height)
end

function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x), math.floor(self.y))
end


-- whether there is a platform pixel in the line under the player
function Entity:isPlatformUnder()
    local checkLine = false

    for x = 1, self.width do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        checkLine = (checkLine or (self.level.platforms[xfloor + x - 1][yfloor + self.height + 1] == 1))
    end
    
    return checkLine
end

-- whether there is a platform pixel in the line left to the player
function Entity:isPlatformLeft()
    local checkLine = false

    for y = 1, self.height - 10 do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        checkLine = (checkLine or (self.level.platforms[xfloor - 1][yfloor + y] == 1))
    end
    
    return checkLine
end

-- whether there is a platform pixel in the bottom of line left to the player
function Entity:isPlatformGoUpLeft()
    local footHeight = 0

    for y = 1, 10 do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        if self.level.platforms[xfloor][yfloor + self.height - y] == 1 then
            footHeight = y
        end
    end
    
    return footHeight
end

function Entity:isPlatformRight()
    -- look at the pixel line below the player
    -- if any of the pixel is platform return true
    local checkLine = false

    for y = 1, self.height - 10 do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        checkLine = (checkLine or (self.level.platforms[xfloor + self.width + 1][yfloor + y] == 1))
    end
    
    return checkLine
end
    
-- whether there is a platform pixel in the bottom of line left to the player
function Entity:isPlatformGoUpRight()
    local footHeight = 0

    for y = 1, 10 do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        if self.level.platforms[xfloor + self.width][yfloor + self.height - y] == 1 then
            footHeight = y
        end
    end
    
    return footHeight
end
