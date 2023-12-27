--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLeftState = Class{__includes = BaseState}

function PlayerLeftState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {5, 6, 5, 7},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
    self.direction = 'left'
end

function PlayerLeftState:update(dt)
    self.player.currentAnimation:update(dt)

    -- if we're not pressing left then change to idle
    if not love.keyboard.isDown(LEFT_KEY) then
        self.player:changeState('idle')

    -- left is pressed
    else

        -- if there is no platform under the player then falls
        if not self.player:isPlatformUnder() then
            self.player.dy = 0
            self.player:changeState('falling')
        
        -- there is a platform under the player 
        else

            -- if no barrier at the left the go left
            if not self.player:isPlatformLeft() then

                -- if go up at left side, lift player
                self.player.y = self.player.y - self.player:isPlatformGoUpLeft()
                self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            end

        end
    end

    -- if left is pressed
    if love.keyboard.isDown(RIGHT_KEY) then
        self.player:changeState('right')
    end

    -- if space is pressed
    if love.keyboard.wasPressed(JUMP_KEY) then
        self.player:changeState('jump')
    end
end
