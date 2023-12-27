--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(level)
    local background = 'level' .. level .. 'Background'
    local backgrounddata = 'level' .. level .. 'Backgrounddata'
    local width = 0
    local height = 0
    local platforms = {}
    local entities = {}
    local bullets = {}
    local forts = {}

    local fortCoordinates = {}
    local fortGrid = {}
    local fortGridInterval = {
        ['x'] = 100,
        ['y'] = 100
    }
    local fortGridWidth = 0
    local fortGridHeight = 0

    local cakes = {}
    local objects = {}
    local initialPlayerPosition = {0, 0}

    -- get the width and height of background picture
    width = gTextures[background]:getWidth()
    height = gTextures[background]:getHeight()

    -- prepare fort grid table
    fortGridWidth = math.floor(width / fortGridInterval.x)
    fortGridHeight = math.floor(height / fortGridInterval.y)
    for x = 1, fortGridWidth do
        table.insert(fortGrid, {})
        for y = 1, fortGridHeight do
            table.insert(fortGrid[x], false)
        end
    end

    -- recognize the settings from the background picture
    local imagedata = gTextures[backgrounddata]
    for x = 1, width do
        table.insert(platforms, {})
        for y = 1, height do
            local r, g, b = imagedata:getPixel(x - 1, y - 1)

            -- 1,1,1 = 1 = platform
            if (r == 1 and g == 1 and b == 1) then
                table.insert(platforms[x], 1)
            
            -- 0,1,0 = 2 = goal
            elseif (r < 0.004 and g == 1 and 0.004 < b) then
                table.insert(platforms[x], 2)

            -- 1,0,0 = 3 = cake fort
            elseif (253 / 255 < r and g < 0.008 and b < 0.008) then
                table.insert(platforms[x], 3)
                fortGrid[math.floor(x / fortGridInterval.x) + 1][math.floor(y / fortGridInterval.y) + 1] = true

            -- 0,0.5,0 = 4 = initial player position 
            elseif (r < 0.004 and (128 / 255 - 0.002) < g and g < (128 / 255 + 0.002) and b < 0.004) then
                if initialPlayerPosition[1] == 0 then
                    initialPlayerPosition[1] = x
                    initialPlayerPosition[2] = y
                end

            -- x,x,x = 0 = normal pixel
            else
                table.insert(platforms[x], 0)
            end
        end
    end

    -- calculate coordinates and save into forts
    for x = 1, fortGridWidth do
        for y = 1, fortGridHeight do
            if fortGrid[x][y] then
                table.insert(forts, {
                    fortGridInterval.x * (x - 0.5),
                    fortGridInterval.y * (y - 0.5)
                })
            end
        end
    end

    -- recognize the objects from the back ground picture


    -- return the level with data
    return GameLevel({
        background = background,
        width = width,
        height = height,

        platforms = platforms,
        entities = entities,
        bullets = bullets,
        forts = forts,
        cakes = cakes,

        objects = objects,
        initialPlayerPosition = initialPlayerPosition
    })
end
