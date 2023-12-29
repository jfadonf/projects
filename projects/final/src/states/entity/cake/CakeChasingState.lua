--[[
    GD50
    Cube in home

    Author: Jiong FAN
    jfadonf@gmail.com
]]

CakeChasingState = Class{__includes = BaseState}

function CakeChasingState:init(cake)
    self.cake = cake
    self.cake.alive = true

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.cake.currentAnimation = self.animation

    self.localTimer = 0
    self.targetX = 0
    self.targetY = 0

    if not (gStateMachine.current.player == nil) then
        -- get player's position for the frist time,
        self.targetX = gStateMachine.current.player.x + gStateMachine.current.player.width / 2
        self.targetY = gStateMachine.current.player.y + gStateMachine.current.player.height / 2

        -- calculate the angle towords player
        self.cake.angle = Atan2(self.cake.x, self.cake.y, self.targetX, self.targetY)

        -- calculate the dx and dy speed
        self.cake.dx = CAKE_SPEED * math.cos(self.cake.angle)
        self.cake.dy = CAKE_SPEED * math.sin(self.cake.angle)
    end
end

function CakeChasingState:update(dt)
    if not (gStateMachine.current.player == nil) then
        
        -- get player's position every 4 seconds,
        self.targetX = gStateMachine.current.player.x + gStateMachine.current.player.width / 2
        self.targetY = gStateMachine.current.player.y + gStateMachine.current.player.height / 2

        -- calculate the angle towords player
        self.cake.angle = Atan2(self.cake.x, self.cake.y, self.targetX, self.targetY)

        -- calculate the dx and dy speed
        self.cake.dx = CAKE_SPEED * math.cos(self.cake.angle)
        self.cake.dy = CAKE_SPEED * math.sin(self.cake.angle)
        
        if 0 < self.localTimer and self.localTimer < 2 then

            -- move along axis X and Y
            self.cake.x = self.cake.x + self.cake.dx * dt
            self.cake.y = self.cake.y + self.cake.dy * dt

        elseif 4 < self.localTimer then
        
            self.targetX = gStateMachine.current.player.x
            self.targetY = gStateMachine.current.player.y

            -- calculate the angle towords player
            self.cake.angle = Atan2(self.cake.x, self.cake.y, self.targetX, self.targetY)

            -- reset dx and dy to 0
            self.dx = 0
            self.dy = 0

            -- reset timer
            self.localTimer = 0

        end

        -- update timer
        self.localTimer = self.localTimer + dt

        -- check if it is hit by bullet
        for k, bullet in pairs(gStateMachine.current.level.bullets) do
            if self.cake:collides(bullet) then
                bullet.HP = bullet.HP - 1
                self.cake:hit()
                self.cake.HP = self.cake.HP - 1
                gStateMachine.current.scores = gStateMachine.current.scores + 50
            end
        end

        -- check if the cake is dead then change to dyingstate
        if self.cake.HP <= 0 then
            self.cake.mode = 'dying' 
            self.cake:changeState('dying')
            gStateMachine.current.scores = gStateMachine.current.scores + 100

        end
    end
end

