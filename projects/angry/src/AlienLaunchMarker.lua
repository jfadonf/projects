--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

AlienLaunchMarker = Class{}

-- to init a alienlaunchmarker, a world must be given
function AlienLaunchMarker:init(world)
    self.world = world

    -- starting coordinates for launcher used to calculate launch vector
    self.baseX = 90
    self.baseY = VIRTUAL_HEIGHT - 100

    -- shifted coordinates when clicking and dragging launch alien
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    -- whether our arrow is showing where we're aiming
    self.aiming = false

    -- whether we launched the alien and should stop rendering the preview
    self.launched = false

    -- whether we split the alien
    self.split = false

    -- whether the player touched any thing
    self.touched = false

    -- our alien we will eventually spawn
    self.alien = nil

    -- splitted aliens
    self.alien_1 = nil
    self.alien_2 = nil
end

function AlienLaunchMarker:update(dt)
    
    -- perform everything here as long as we haven't launched yet
    if not self.launched then

        -- grab mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())
        
        -- if we click the mouse and haven't launched, show arrow preview
        if love.mouse.wasPressed(1) and not self.launched then
            self.aiming = true

        -- if we release the mouse, launch an Alien
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.launched = true

            -- spawn new alien in the world, passing in user data of player
            self.alien = Alien(self.world, 'round', self.shiftedX, self.shiftedY, 'Player')

            -- apply the difference between current X,Y and base X,Y as launch vector impulse
            -- apppy the speed of alien
            self.alien.body:setLinearVelocity((self.baseX - self.shiftedX) * 10, (self.baseY - self.shiftedY) * 10)

            -- make the alien pretty bouncy
            self.alien.fixture:setRestitution(0.4)
            self.alien.body:setAngularDamping(1)

            -- we're no longer aiming
            self.aiming = false

        -- re-render trajectory
        elseif self.aiming then
            
            self.shiftedX = math.min(self.baseX + 30, math.max(x, self.baseX - 30))
            self.shiftedY = math.min(self.baseY + 30, math.max(y, self.baseY - 30))
        end

    -- deal with the flight and split when player was launched
    else
        -- check if the space key was pressed
        if (not self.touched) and love.keyboard.wasPressed('space') and (not self.split) then
            self.split = true
            -- get the position of the player
            local posX, posY = self.alien.body:getPosition()
            -- get the velocity of the player
            local velX, velY = self.alien.body:getLinearVelocity()
            local velocity = math.sqrt(velX * velX + velY * velY)
            -- angle of the origin
            local angle_origin = math.atan2(velY, velX)
            -- angle of the split
            local angle_1 = angle_origin + math.rad(30)
            local angle_2 = angle_origin - math.rad(30)
            -- velx, vely of split1
            local velX1 = velocity * math.cos(angle_1)
            local velY1 = velocity * math.sin(angle_1)
            -- velx, vely of split2
            local velX2 = velocity * math.cos(angle_2)
            local velY2 = velocity * math.sin(angle_2)

            -- split the player
            self.alien_1 = Alien(self.world, 'round', posX, posY, 'Player')
            self.alien_2 = Alien(self.world, 'round', posX, posY, 'Player')
            self.alien_1.body:setLinearVelocity(velX1, velY1)
            self.alien_2.body:setLinearVelocity(velX2, velY2)

            -- make the alien pretty bouncy
            self.alien_1.fixture:setRestitution(0.4)
            self.alien_1.body:setAngularDamping(1)
            
            self.alien_2.fixture:setRestitution(0.4)
            self.alien_2.body:setAngularDamping(1)
        end
    end
end

function AlienLaunchMarker:render()
    if not self.launched then
        
        -- render base alien, non physics based
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], 
            self.shiftedX - 17.5, self.shiftedY - 17.5)

        if self.aiming then
            
            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * 10
            local impulseY = (self.baseY - self.shiftedY) * 10

            -- draw 18 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            -- http://www.iforce2d.net/b2dtut/projected-trajectory
            for i = 1, 90 do
                
                -- magenta color that starts off slightly transparent
                love.graphics.setColor(255/255, 80/255, 255/255, ((255 / 24) * i) / 255)
                
                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 then
                    love.graphics.circle('fill', trajX, trajY, 3)
                end
            end
        end
        
        love.graphics.setColor(1, 1, 1, 1)
    else
        self.alien:render()
        if self.alien_1 then
            self.alien_1:render()
        end
        if self.alien_2 then
            self.alien_2:render()
        end
    end
end
