--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {8},
        interval = 1
    }
    self.player.currentAnimation = self.animation
end

function PlayerJumpState:enter(params)
    -- gSounds
    gSounds['playerJump']:play()

    self.player.dy = PLAYER_JUMP_VELOCITY
end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)
    self.player.dy = math.min(300, self.player.dy + self.gravity)
    self.player.y = self.player.y + (self.player.dy * dt)

    -- go into the falling state when y velocity is positive
    if self.player.dy >= 0 then
        self.player:changeState('falling')
    end

    -- moving left or right when jumping
    if love.keyboard.isDown(LEFT_KEY) and not self.player:isPlatformLeft() then
        self.player.direction = 'left'
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
    elseif love.keyboard.isDown(RIGHT_KEY) and not self.player:isPlatformRight() then
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player.direction = 'right'
    end

end
