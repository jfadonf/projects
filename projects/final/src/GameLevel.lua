--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(defs)
    self.background = defs.background
    self.width = defs.width
    self.height = defs.height

    self.platforms = defs.platforms
    self.entities = defs.entities
    self.bullets = defs.bullets
    self.forts = defs.forts
    self.cakes = defs.cakes

    self.objects = defs.objects
    self.alive = true
    self.initialPlayerPosition = defs.initialPlayerPosition
end


--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function GameLevel:clear()
--    for i = #self.entities, 1, -1 do
--        if not self.entities[i].alive then
--            table.remove(self.entities, i)
--        end
--    end

    for i = #self.bullets, 1, -1 do
        if self.bullets[i].HP <= 0 then
            table.remove(self.bullets, i)
        end
    end

    for i = #self.forts, 1, -1 do
        if self.forts[i].HP == -100 then
            table.remove(self.forts, i)
        end
    end

    for i = #self.cakes, 1, -1 do
        if not self.cakes[i].alive then
            table.remove(self.cakes, i)
        end
    end
--    for i = #self.objects, 1, -1 do
--        if not self.objects[i] then
--            table.remove(self.objects, i)
--        end
--    end

end

function GameLevel:update(dt)
    -- update entities
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end

    -- update bullets
    for k, bullet in pairs(self.bullets) do
        bullet:update(dt)
    end

    -- update cakes
    for k, cake in pairs(self.cakes) do
        cake:update(dt)
    end

--    -- update objects
--    for k, object in pairs(self.objects) do
--        object:update(dt)
--    end

end

function GameLevel:render()
    -- draw entities
    for k, entity in pairs(self.entities) do
        if not entity.texture == 'cake' then
            entity:render()
        end
    end
    
    -- draw bullets
    for k, bullet in pairs(self.bullets) do
        bullet:render()
    end

    -- draw cakes
    for k, cake in pairs(self.cakes) do
        cake:render()
    end
--    -- draw objects
--    for k, object in pairs(self.objects) do
--        object:render()
--    end

end
