--[[
    GD50
    Final project: Cubes in my home

    Author: Jiong FAN
    jfadonf@gmail.com

]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    -- get params from Statistic
    self.lives = params.lives
    self.scores = params.scores
    self.gameLevel = params.gameLevel
    self.level = params.level
    self.theHighestScore = params.theHighestScore

    -- screen initiation
    self.camX = 0
    self.camY = 0
    self.screenWidth = 800
    self.screenHeight = 600

    -- Sounds:
    gSounds['music']:play()

    -- gravity conditions
    self.gravityOn = false
    self.gravityAmount = LEVEL_GRAVITY

    -- player initiation
    self.isPlayerWin = false

    -- todo: get initial player position
    local iPPx = self.level.width / 2
    local iPPy = self.level.height / 2

    if not (self.level.initialPlayerPosition[1] == 0) then
        iPPx = self.level.initialPlayerPosition[1]
        iPPy = self.level.initialPlayerPosition[2]
    end

    -- spawn player in level
    self.player = Player({
        -- initial postion of the player in the level
        x = iPPx,
        -- y = self.level.height - self.screenHeight / 2,
        y = iPPy,
        
        -- player
        width = CUBE_SIZE,
        height = CUBE_SIZE,
        texture = 'purple-cube',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['right'] = function() return PlayerRightState(self.player) end,
            ['left'] = function() return PlayerLeftState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end,
            ['die'] = function() return PlayerDieState(self.player) end,
            ['win'] = function() return PlayerWinState(self.player) end
        },
        -- gameLevel
        level = self.level
    })

    self.player:changeState('falling')

    -- a timer for bake
    self.bakeTimer = 0

    -- bakeTimes for forts
    self.bakeTimes = {}
    for i = 1, #self.level.forts do
        table.insert(self.bakeTimes, 0)
    end

    -- bakeTime intervals for forts
    self.bakeTimeInterval = {}
    for i = 1, #self.level.forts do
        table.insert(self.bakeTimeInterval, math.random(2, 9))
    end

    -- make cakes in cakes
--    self.level.forts = {
--        {400, 400}
--    }

end


function PlayState:update(dt)
    -- update timers
    Timer.update(dt)
    self.bakeTimer = self.bakeTimer + dt

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- for each enemy fort, set out cakes every x seconds
    for k, fort in pairs(self.level.forts) do
        -- if the bakeTime < bakeTimer then bake a cake
        if self.bakeTimes[k] < self.bakeTimer then
            self:fortSpawnCake(fort[1], fort[2])
            self.bakeTimes[k] = self.bakeTimes[k] + self.bakeTimeInterval[k]
        end
    end


    -- constrain player X no matter which state
    self.player.x = math.max(5, math.min(self.player.x, self.level.width - self.player.width - 5))

    -- check if the player is catched by cakes
    local isCatched = false
    if self.player.alive then
        for k, cake in pairs(self.level.cakes) do
            -- only collides with chasing mode cake
            if cake.mode == 'chasing' then
                isCatched = isCatched or self.player:collides(cake)
            end
        end
        if isCatched then
            gStateMachine.current.level.alive = false
            self.player:changeState('die')
        end 
    end
    
    -- check if the player reach the goal
    if self.player:isReachTheGoal() and not self.isPlayerWin then
        self.scores = self.scores + 1000
        self.player:changeState('win')
    end
end

function PlayState:render()
    love.graphics.push()
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    -- draw the background of level
    love.graphics.draw(gTextures['level' .. self.gameLevel .. 'Background'], 0, 0)

    -- draw the objects and entities of level
    self.level:render()

    -- draw player
    self.player:render()

    -- draw particle
    for k, cake in pairs(self.level.cakes) do
        cake:renderParticles()
    end

    love.graphics.pop()
    
    -- display the lives on the top-left of the screen
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('lives:', 20, 20, 200, 'left')
    for i = 1, self.lives do
        love.graphics.draw(gTextures['purple-cube'], gFrames['purple-cube'][1], 40 + 30 * i, 12, 0, 0.5, 0.5)
    end

    -- display the highest score on the top-right of the screen
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('the highest score: ' .. math.max(self.scores, self.theHighestScore), 530, 20, 300, 'left')

    -- display the scores on the top-right of the screen
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('score: ' .. self.scores, 635.5, 37, 200, 'left')

    -- display you die! notice in the middle of the screen
    if not self.player.alive then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf('You Die!', VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 - 10, 300, 'center')
    end

    -- display you win! notice in the middle of the screen
    if self.isPlayerWin then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf('Level Completed!', VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2 - 10, 300, 'center')
    end

end

function PlayState:updateCamera()
    -- keep the cube in the middle of the screen (3/8 < X < 5/8, 1/3 < Y < 2/3)
    if self.player.x < self.camX + 300
        then self.camX = self.player.x - 300
    end

    if  self.player.x + self.player.width > self.camX + 500
        then self.camX = self.player.x + self.player.width - 500
    end
     
    if  self.player.y < self.camY + 200
        then self.camY = self.player.y - 200
    end

    if self.player.y + self.player.height > self.camY + 400
        then self.camY = self.player.y + self.player.height - 400
    end

    -- clamp movement of the camera within level bounds
    self.camX = math.max(0, math.min(self.camX, self.level.width - self.screenWidth))
    self.camY = math.max(0, math.min(self.camY, self.level.height - self.screenHeight))
end

-- function to spawn cake from fort
function PlayState:fortSpawnCake(fortX, fortY)
    -- check if the fort is in screen
    if self.camX < fortX and fortX < self.camX + self.screenWidth and self.camY < fortY and fortY < self.camY + self.screenHeight then
        -- instantiate a cake
        local cake
        cake = Cake {
            x = fortX,
            y = fortY,
            width = CAKE_WIDTH,
            leight = CAKE_HEIGHT,
            texture = 'cake',
            stateMachine = StateMachine {
                ['emerging'] = function() return CakeEmergingState(cake) end,
                ['chasing'] = function() return CakeChasingState(cake) end,
                ['dying'] = function() return CakeDyingState(cake) end
            }  
        }

        -- change to emerging for this cake
        cake:changeState('emerging')

        -- add it into level.cakes
        table.insert(self.level.cakes, cake)
    end
end

--[[
    Adds a series of enemies to the level randomly.
]]
--function PlayState:spawnEnemies()
--    -- spawn snails in the level
--    for x = 1, self.tileMap.width do
--
--        -- flag for whether there's ground on this column of the level
--        local groundFound = false
--
--        for y = 1, self.tileMap.height do
--            if not groundFound then
--                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
--                    groundFound = true
--
--                    -- random chance, 1 in 20
--                    if math.random(20) == 1 then
--                        
--                        -- instantiate snail, declaring in advance so we can pass it into state machine
--                        local snail
--                        snail = Snail {
--                            texture = 'creatures',
--                            x = (x - 1) * TILE_SIZE,
--                            y = (y - 2) * TILE_SIZE + 2,
--                            width = 16,
--                            height = 16,
--                            stateMachine = StateMachine {
--                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
--                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
--                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
--                            }
--                        }
--                        snail:changeState('idle', {
--                            wait = math.random(5)
--                        })
--
--                        table.insert(self.level.entities, snail)
--                    end
--                end
--            end
--        end
--    end
--end
