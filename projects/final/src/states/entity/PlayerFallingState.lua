--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {1},
        interval = 1
    }
    self.player.currentAnimation = self.animation
end

function PlayerFallingState:update(dt)
    self.player.currentAnimation:update(dt)
    self.player.dy = math.min(300, self.player.dy + self.gravity)
    self.player.y = self.player.y + (self.player.dy * dt)

    -- if there is a platform under the player, stop falling
    if self.player:isPlatformUnder() then
        
        -- Note: the y position must be reset next to the origin
        -- otherwise, the platformUnder() can't be true
        -- the player can go left or right
        self.player.y = math.floor(self.player.y)
        self.player.dy = 0

        -- sound
        gSounds['playerLand']:play()

        self.player:changeState('idle')
         
    -- no platform under the player
    else
        -- player dies when it fall down of the screen
        if self.player.y > self.player.level.height then
            self.player:changeState('die')
        end

        -- moving left or right when falling
        if love.keyboard.isDown(LEFT_KEY) and not self.player:isPlatformLeft() then
            self.player.direction = 'left'
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        elseif love.keyboard.isDown(RIGHT_KEY) and not self.player:isPlatformRight() then
            self.player.direction = 'right'
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        end
    end
end
