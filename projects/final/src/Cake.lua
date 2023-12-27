--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Cake = Class{__includes = Entity}

function Cake:init(def)
    Entity.init(self, def)

    -- init from def
    self.width = def.width
    self.height = def.width

    -- init from constants
    self.speed = ENEMY_SPEED
    self.HP = 1
    self.scale = 0
    self.visible = true
    self.alive = true
    self.angle = 0

    self.alive = true
    self.mode = 'emerging'
    

    -- particle system belonging to the cake, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1.5)
    -- self.psystem:setParticleLifetime(0.5, 1.0)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-20, -20, 20, 80)
    -- self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setEmissionArea('normal', 20, 10)
    -- self.psystem:setEmissionArea('normal', 10, 10)

    
end


function Cake:update(dt)
    -- update movement
    Entity.update(self, dt)

    -- update position for detect collision
    self.collideX = self.x - self.width / 2
    self.collideY = self.y - self.height / 2

    -- update particle system
    self.psystem:update(dt)

end

function Cake:render()
    -- if the cake is visible
    if self.visible then
        -- display with parameter of scale, transparent.
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], math.floor(self.x), math.floor(self.y), self.angle, self.scale, self.scale, self.width / 2, self.height / 2)
    end
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Cake:renderParticles()
    love.graphics.draw(self.psystem, self.x, self.y)
end



function Cake:hit()
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.psystem:setColors(
        245 / 255,
        242 / 255,
        159 / 255,
        0.8,
        87 / 255,
        49 / 255,
        0 / 255,
        0.8
    )
    self.psystem:emit(64)

    -- sound
    gSounds['cakeHit']:stop()
    gSounds['cakeHit']:play()
end
