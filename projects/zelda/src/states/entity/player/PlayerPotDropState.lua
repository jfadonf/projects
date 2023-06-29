--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotDropState = Class{__includes = BaseState}

function PlayerPotDropState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- where the player is and facing
    local direction = self.player.direction

    -- change the animation to lift the pot
    self.player:changeAnimation('drop-pot-' .. self.player.direction)
end

function PlayerPotDropState:enter(params)

    -- restart pot lifting sound
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- drop the lifted pot to the facing direction
    if self.player.direction == 'left' then
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.lifted then
                Timer.tween(0.3, {
                    [object] = {x = self.player.x - 17, y = self.player.y + 22 - 16}
                })
                :finish(function()
                    self.player.havePot = false
                    object.lifted = false
                    object.type = 'projectile'
                    object.x0 = object.x
                    object.y0 = object.y
                    object.direction = self.player.direction
                end)
                break
            end
        end
    elseif self.player.direction == 'right' then
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.lifted then
                Timer.tween(0.3, {
                    [object] = {x = self.player.x + 17, y = self.player.y + 22 - 16}
                })
                :finish(function()
                    self.player.havePot = false
                    object.lifted = false
                    object.type = 'projectile'
                    object.x0 = object.x
                    object.y0 = object.y
                    object.direction = self.player.direction
                end)
                break
            end
        end
    elseif self.player.direction == 'up' then
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.lifted then
                Timer.tween(0.3, {
                    [object] = {x = self.player.x, y = self.player.y + 22 - 33}
                })
                :finish(function()
                    self.player.havePot = false
                    object.lifted = false
                    object.type = 'projectile'
                    object.x0 = object.x
                    object.y0 = object.y
                    object.direction = self.player.direction
                end)
                break
            end
        end
    else
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.lifted then
                Timer.tween(0.3, {
                    [object] = {x = self.player.x, y = self.player.y + 22 + 1}
                })
                :finish(function()
                    self.player.havePot = false
                    object.lifted = false
                    object.type = 'projectile'
                    object.x0 = object.x
                    object.y0 = object.y
                    object.direction = self.player.direction
                end)
                break
            end
        end
    end

    -- restart pot Droping animation
    self.player.currentAnimation:refresh()
end

function PlayerPotDropState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    Timer.update(dt)
end

function PlayerPotDropState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
