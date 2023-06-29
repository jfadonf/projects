--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- where the player is and facing
    local direction = self.player.direction

    -- change the animation to lift the pot
    self.player:changeAnimation('lift-pot-' .. self.player.direction)
end

function PlayerPotLiftState:enter(params)

    -- assume the player is not adjacent to a pot
    self.player.havePot = false

    -- restart pot lifting sound
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- detect whether is adjacent to a pot
    if self.player.direction == 'left' then
        -- temporary shift the player 8 pixels to the left
        self.player.x = self.player.x - 8
        -- collision detection with the pots
        for k, object in pairs(gStateMachine.current.dungeon.currentRoom.objects) do
            if object.type == 'pot' and self.player:collides(object) then
                Timer.tween(0.6, {
                    [object] = {x = self.player.x, y = self.player.y + 22 - 32}
                })
                :finish(function()
                    gStateMachine.current.dungeon.currentRoom.objects[k].lifted = true
                    self.player.havePot = true
                end)
                break
            end
        end
        -- shift the player back
        self.player.x = self.player.x + 8

    elseif self.player.direction == 'right' then
        -- temporary shift the player 8 pixels to the right
        self.player.x = self.player.x + 8
        -- collision detection with the pots
        for k, object in pairs(gStateMachine.current.dungeon.currentRoom.objects) do
            if object.type == 'pot' and self.player:collides(object) then
                Timer.tween(0.6, {
                    [object] = {x = self.player.x, y = self.player.y + 22 - 32},
                })
                :finish(function()
                    gStateMachine.current.dungeon.currentRoom.objects[k].lifted = true
                    self.player.havePot = true
                end)
                break
            end
        end
        -- shift the player back
        self.player.x = self.player.x - 8
    
    elseif self.player.direction == 'up' then
        -- temporary shift the player 8 pixels to the up
        self.player.y = self.player.y - 8
        -- collision detection with the pots
        for k, object in pairs(gStateMachine.current.dungeon.currentRoom.objects) do
            if object.type == 'pot' and self.player:collides(object) then
                Timer.tween(0.6, {
                    [object] = {x = self.player.x, y = self.player.y + 22 - 32},
                })
                :finish(function()
                    gStateMachine.current.dungeon.currentRoom.objects[k].lifted = true
                    self.player.havePot = true
                end)
                break
            end
        end
        -- shift the player back
        self.player.y = self.player.y + 8

    else
        -- temporary shift the player 8 pixels to the down
        self.player.y = self.player.y + 8
        -- collision detection with the pots
        for k, object in pairs(gStateMachine.current.dungeon.currentRoom.objects) do
            if object.type == 'pot' and self.player:collides(object) then
                Timer.tween(0.6, {
                    [object] = {x = self.player.x, y = self.player.y + 22 - 32},
                })
                :finish(function()
                    gStateMachine.current.dungeon.currentRoom.objects[k].lifted = true
                    self.player.havePot = true
                end)
                break
            end
        end
        -- shift the player back
        self.player.y = self.player.y - 8
    end

    -- restart pot lifting animation
    self.player.currentAnimation:refresh()
end

function PlayerPotLiftState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    Timer.update(dt)
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
