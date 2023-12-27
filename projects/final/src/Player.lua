--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    -- init from def
    Entity.init(self, def)
    self.gameLevel = def.gameLevel
    self.scores = def.scores

    -- init from constants
    self.direction = 'right'
    self.lastDirection = 'right'

    self.verticalDirection = 0
    self.alive = true
end

function Player:update(dt)
    -- update player's movement
    Entity.update(self, dt)

    -- prepare the shooting direction
        -- if no left or right key is pressed
    if not (love.keyboard.isDown(LEFT_KEY) or love.keyboard.isDown(RIGHT_KEY)) then
        -- determine the verdical direction of bullet
        if love.keyboard.isDown(UP_KEY) then
            self.verticalDirection = 1
            self.direction = 'center'
        elseif love.keyboard.isDown(DOWN_KEY) then
            self.verticalDirection = -1
            self.direction = 'center'
        else
            self.verticalDirection = 0
            self.direction = self.lastDirection
        end
    else
        -- if left or right key is pressed
        -- determine the horizon direction of bullet
        if love.keyboard.isDown(LEFT_KEY) then
            self.direction = 'left'
            self.lastDirection = 'left'
        elseif love.keyboard.isDown(RIGHT_KEY) then
            self.direction = 'right'
            self.lastDirection = 'right'
        end
        -- determine the verdical direction of bullet
        if love.keyboard.isDown(UP_KEY) then
            self.verticalDirection = 1
        elseif love.keyboard.isDown(DOWN_KEY) then
            self.verticalDirection = -1
        else
            self.verticalDirection = 0
        end
    end 

    -- trigger shooting 
    if love.keyboard.wasPressed(SHOOT_KEY) and gStateMachine.current.player.alive then

        -- sound
        gSounds['shoot']:stop()
        gSounds['shoot']:play()
        
        -- prepare the bullet
        local b = Bullet({
            x = self.x,
            y = self.y,
            horizonDirection = self.direction,
            verticalDirection = self.verticalDirection
        })

        -- add bullet to the bullets table of level
        table.insert(gStateMachine.current.level.bullets, b)
    end
end

function Player:render()
    Entity.render(self)
end

---- whether there is a platform pixel in the line under the player
--function Player:isPlatformUnder()
--    local checkLine = false
--
--    for x = 1, self.width do
--        local xfloor = math.floor(self.x)
--        local yfloor = math.floor(self.y)
--        checkLine = (checkLine or (self.level.platforms[xfloor + x - 1][yfloor + self.height + 1] == 1))
--    end
--    
--    return checkLine
--end
--
---- whether there is a platform pixel in the line left to the player
--function Player:isPlatformLeft()
--    local checkLine = false
--
--    for y = 1, self.height - 10 do
--        local xfloor = math.floor(self.x)
--        local yfloor = math.floor(self.y)
--        checkLine = (checkLine or (self.level.platforms[xfloor - 1][yfloor + y] == 1))
--    end
--    
--    return checkLine
--end
--
---- whether there is a platform pixel in the bottom of line left to the player
--function Player:isPlatformGoUpLeft()
--    local footHeight = 0
--
--    for y = 1, 10 do
--        local xfloor = math.floor(self.x)
--        local yfloor = math.floor(self.y)
--        if self.level.platforms[xfloor][yfloor + self.height - y] == 1 then
--            footHeight = y
--        end
--    end
--    
--    return footHeight
--end
--
--function Player:isPlatformRight()
--    -- look at the pixel line below the player
--    -- if any of the pixel is platform return true
--    local checkLine = false
--
--    for y = 1, self.height - 10 do
--        local xfloor = math.floor(self.x)
--        local yfloor = math.floor(self.y)
--        checkLine = (checkLine or (self.level.platforms[xfloor + self.width + 1][yfloor + y] == 1))
--    end
--    
--    return checkLine
--end
--    
---- whether there is a platform pixel in the bottom of line left to the player
--function Player:isPlatformGoUpRight()
--    local footHeight = 0
--
--    for y = 1, 10 do
--        local xfloor = math.floor(self.x)
--        local yfloor = math.floor(self.y)
--        if self.level.platforms[xfloor + self.width][yfloor + self.height - y] == 1 then
--            footHeight = y
--        end
--    end
--    
--    return footHeight
--end
--
function Player:isReachTheGoal()
    -- check the pixels around the cube, if touch the green
    local checkLine = false

    for i = 1, 10 do
        local xfloor = math.floor(self.x)
        local yfloor = math.floor(self.y)
        -- over
        checkLine = (checkLine or (self.level.platforms[xfloor + i - 1][yfloor] == 2))
        -- under
        checkLine = (checkLine or (self.level.platforms[xfloor + i - 1][yfloor + self.height] == 2))
        -- left
        checkLine = (checkLine or (self.level.platforms[xfloor][yfloor + i] == 2))
        -- right
        checkLine = (checkLine or (self.level.platforms[xfloor + self.width][yfloor + i] == 2))

    end
    
    return checkLine
end

-- collides detection
function Player:collides(target)
    return not ((target.x - target.width / 2) > self.x + self.width or self.x > (target.x + target.width / 2) or
            (target.y - target.height / 2) > self.y + self.height or self.y > (target.y + target.height / 2))
end

-- function Player:checkObjectCollisions()
--    local collidedObjects = {}
--
--    for k, object in pairs(self.level.objects) do
--        if object:collides(self) then
--            if object.solid then
--                table.insert(collidedObjects, object)
--            elseif object.consumable then
--                object.onConsume(self)
--                table.remove(self.level.objects, k)
--            end
--        end
--    end
--
--    return collidedObjects
-- end
