--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerRightState = Class{__includes = BaseState}

function PlayerRightState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {2, 3, 2, 4},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
    self.player.direction = 'right'
end

function PlayerRightState:update(dt)
    self.player.currentAnimation:update(dt)

    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown(RIGHT_KEY) then self.player:changeState('idle')

    -- whether there is no platform under the player
    elseif not self.player:isPlatformUnder() then
        self.player.dy = 0
        self.player:changeState('falling')

    -- there is a platform under the player 
    elseif not self.player:isPlatformRight() then
            -- if go up at right side, lift player
            self.player.y = self.player.y - self.player:isPlatformGoUpRight()
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
    end

    -- if left is pressed
    if love.keyboard.isDown(LEFT_KEY) then
        self.player:changeState('left')
    end

    -- if space is pressed
    if love.keyboard.wasPressed(JUMP_KEY) then
        self.player:changeState('jump')
    end
end
