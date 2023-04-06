--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.powerups = params.powerups
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = params.balls
    self.level = params.level

    self.recoverPoints = params.recoverPoints
    self.triggerPoints = TRIGGER_POINTS
    -- give ball random starting velocity
    for i = 1, #self.balls do
        self.balls[i].dx = math.random(-200, 200)
        self.balls[i].dy = math.random(-50, -60)
    end
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    for i = 1, #self.balls do
        self.balls[i]:update(dt)

        if self.balls[i]:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            self.balls[i].y = self.paddle.y - 8
            self.balls[i].dy = -self.balls[i].dy

                --
                -- tweak angle of bounce based on where it hits the paddle
                --

                -- if we hit the paddle on its left side while moving left...
            if self.balls[i].x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                self.balls[i].dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.balls[i].x))
            
                -- else if we hit the paddle on its right side while moving right...
            elseif self.balls[i].x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                self.balls[i].dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.balls[i].x))
            end

            gSounds['paddle-hit']:play()
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and self.balls[i]:collides(brick) then

                -- if the brick is not locked
                if brick.islocked then
                    -- if the paddle has a key then hit the locked brick, add scores
                    -- remove the key from the paddle
                    if self.paddle.haskey then
                        brick:hitlocked(true)
                        self.score = self.score + 1000
                        self.paddle.haskey = false
                    else
                        brick:hitlocked(false)
                    end
                else
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()

                    -- trigger the powerup to drop
                    if not brick.inPlay then
                        self.powerups[k].active = true
                    end
                end

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- each trigger points gained, enlarge the paddle
                if self.score > self.triggerPoints then
                    self.triggerPoints = self.triggerPoints + TRIGGER_POINTS
                    local newPaddleSize = math.min(4, self.paddle.size + 1)
                    self.paddle:resize(newPaddleSize)
                end

                -- go to our victory screen if there are no more bricks left
                brickLeft, brickLeftPosition, powerupLeft = self:checkVictory()
                -- if the last brick is locked and the paddle hasn't key then give an extra key powerup when hit
-- and self.bricks[brickLeftPosition].islocked
                    if brickLeft == 1 and powerupLeft == 0 then
                    -- provide a brick and a key powerup at the locked brick
                    local p = Powerup(
                        self.bricks[brickLeftPosition].x + 8,
                        self.bricks[brickLeftPosition].y,
                        10
                    )
                    p.inPlay = true
                    local b = Brick(
                        self.bricks[brickLeftPosition].x,
                        self.bricks[brickLeftPosition].y
                    )
                    b.inPlay = true
                    table.insert(self.bricks, 1, b)
                    table.insert(self.powerups, 1, p)
                end

                if brickLeft == 0 then
                    -- remove the key from paddle
                    self.paddle.haskey = false

                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        balls = self.balls,
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if self.balls[i].x + 2 < brick.x and self.balls[i].dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    self.balls[i].dx = -self.balls[i].dx
                    self.balls[i].x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif self.balls[i].x + 6 > brick.x + brick.width and self.balls[i].dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    self.balls[i].dx = -self.balls[i].dx
                    self.balls[i].x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif self.balls[i].y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    self.balls[i].dy = -self.balls[i].dy
                    self.balls[i].y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    self.balls[i].dy = -self.balls[i].dy
                    self.balls[i].y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(self.balls[i].dy) < 150 then
                    self.balls[i].dy = self.balls[i].dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end

        -- if ball goes below bounds mark live equals false.
        if self.balls[i].y >= VIRTUAL_HEIGHT then
            self.balls[i].inPlay = false
        end        
    end

    -- remove the dead ball from the balls
    for i = #self.balls, 1, -1 do
        if not self.balls[i].inPlay then
            table.remove(self.balls, i)
        end
    end

    -- if no ball in play
    local ballInplay = false
    for i = 1, #self.balls do
        ballInplay = self.balls[i].inPlay or ballInplay
    end

    -- if no ball left, revert to serve state
    if not ballInplay then
        self.health = self.health - 1
        gSounds['hurt']:play()
        -- shrink the paddle
        local newSize = math.max(1, self.paddle.size - 1)
        self.paddle:resize(newSize)
        -- remove the key when all balls lost
        self.paddle.haskey = false

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                powerups = self.powerups,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end

    -- for rendering powerups
    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
        -- check if the paddle touched the powerup
        if powerup.inPlay and powerup.active and powerup:collide(self.paddle) then
            powerup.inPlay = false
            if powerup.kind == 10 then
                self.paddle.haskey = true
            end
            if powerup.kind == 9 then
                local newBall1 = Ball(math.random(7))
                newBall1:add(self.balls[1].x, self.balls[1].y, self.balls[1].dx-20, self.balls[1].dy-5)
                local newBall2 = Ball(math.random(7))
                newBall2:add(self.balls[1].x, self.balls[1].y, self.balls[1].dx+20, self.balls[1].dy+5)
                table.insert(self.balls, newBall1)
                table.insert(self.balls, newBall2)
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    -- render all powerups
    for k, powerup in pairs(self.powerups) do
        if powerup.active and powerup.inPlay then
            powerup:render()
        end
    end

    -- render paddle
    self.paddle:render()

    -- render balls
    for i = 1, #self.balls do
        self.balls[i]:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    local brickLeft = 0
    local brickLeftPosition = 0
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            brickLeft = brickLeft + 1
            brickLeftPosition = k
        end 
    end

    local powerupLeft = 0
    for k, powerup in pairs(self.powerups) do
        if powerup.inPlay then
            powerupLeft = powerupLeft + 1
        end
    end

    return brickLeft, brickLeftPosition, powerupLeft
end
