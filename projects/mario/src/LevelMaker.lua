--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width - 2 do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }

                                    table.insert(objects, gem)
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    -- the last 2 columns for the flag
    for i = 1, 2 do
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(width - 2 + i, y, TILE_ID_EMPTY, nil, tileset, topperset))
        end

        for y = 7, height do
            table.insert(tiles[y],
                Tile(width - 2 + i, y, TILE_ID_GROUND, y == 7 and topper or nil, tileset, topperset))
        end
    end

    -- random a set of key and lock
    local keyAndLockFrame = math.random(#KEY_LOCK)

    -- choose a ground to place key
    local keyPosition = math.random(width / 3)
    while not (tiles[7][keyPosition].id == TILE_ID_GROUND and tiles[6][keyPosition].id == TILE_ID_EMPTY) do
        keyPosition = math.random(width / 3)
    end

    -- spawn a key
    table.insert(objects,

        -- key
        GameObject {
            texture = 'key-lock',
            x = (keyPosition - 1) * TILE_SIZE,
            y = 5 * TILE_SIZE,
            width = 16,
            height = 16,

            -- make it a random variant
            frame = keyAndLockFrame,
            collidable = true,
            consumable = true,
            solid = false,

            onConsume = function(player, object)
                gSounds['pickup']:play()
                player.score = player.score + 100
                player.key = true
                for k, object in pairs(objects) do
                    if object.texture == 'key-lock' and object.frame > 4 then
                        object.consumable = true
                        object.solid = false
                    end
                end
            end
        }
    )

    -- choose a ground to place lock
    local lockPosition = math.random(width / 3) + math.floor(width / 3)
    while not (tiles[4][lockPosition].id == TILE_ID_EMPTY) do
        lockPosition = math.random(width / 3) + math.floor(width / 3)
    end

    -- spawn a lock
    table.insert(objects,

        -- lock
        GameObject {
            texture = 'key-lock',
            x = (lockPosition - 1) * TILE_SIZE,
            y = 3 * TILE_SIZE,
            width = 16,
            height = 16,

            -- make it a random variant
            frame = keyAndLockFrame + 4,
            collidable = true,
            consumable = false,
            solid = true,

            onCollide = function(player, object)
                gSounds['empty-block']:play()
            end,

            onConsume = function(player, object)
                gSounds['pickup']:play()
                player.score = player.score + 100
                player.lock = true

                -- make the pole appear at the last column
                local pole = GameObject {
                    texture = 'poles',
                    x = (width - 2) * TILE_SIZE + 8,
                    y = 3 * TILE_SIZE,
                    width = 16,
                    height = 48,
                    frame = math.random(#POLES),
                    collidable = true,
                    consumable = false,
                    solid = false
                }

                table.insert(objects, pole)
                
                local flag = GameObject {
                    texture = 'flags',
                    x = (width - 1) * TILE_SIZE,
                    y = 3 * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = 7,
                    collidable = true,
                    consumable = true,
                    solid = false,

                    onConsume = function()
                        gSounds['powerup-reveal']:play()

                        -- go to next level
                        gStateMachine:change('play', {
                            gameLevel = 
                                gStateMachine.current.gameLevel + 1,
                            gameScore = 
                                gStateMachine.current.player.score + 1000
                        })
                    end
                }

                table.insert(objects, flag)

                -- make the flag floating
                Timer.every(0.1, function()
                    flag.frame = math.random(3) + 6
                end)
                gSounds['powerup-reveal']:play()

            end
        }
    )

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end
