--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(self.level == 1 and 1 or 6)))
        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end

    while not self:checkready() do

        -- ensure there will be a potential match
        self:initializeTiles()
    end

    -- make some tiles shiny
    local shinyTiles = getsubset(SHINYTILEQUANTITY, 64)
    for key, value in pairs(shinyTiles) do
        local x = value % 8  
        if x == 0 then
            x = 8
        end
        local y = (value - x) / 8 + 1
        self.tiles[y][x].shiny = true
    end
        
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- if there is a shiny tile in the matches, mark whole row tiles matches
    local shinyTileRow = {}
    for k, match in pairs(matches) do
        for k, tile in pairs(match) do
            if tile.shiny then
                table.insert(shinyTileRow, tile.gridY)
            end
        end
    end
    for k, gridY in pairs(shinyTileRow) do
        local match = {}
        for i = 1, 8 do
            table.insert(match, self.tiles[gridY][i])
        end
        table.insert(matches, match)
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(18), math.random(self.level == 1 and 1 or 6))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

-- check if there is a potential match in pattern
function Board:checkready()
    -- find all the double tiles
    local doubleTiles1 = {}
    local doubleTiles2 = {}
    local doubleTiles3 = {}
    local doubleTiles4 = {}

    -- double tile type 1
    for y = 1, 8 do
        for x = 1, 7 do
            if self.tiles[y][x].color == self.tiles[y][x + 1].color then
                table.insert(doubleTiles1, {y, x})
            end
        end
    end

    -- check is there a tile around could match the double
    for k, doubleT in pairs(doubleTiles1) do
        local potentials = getPotentials1(doubleT[1], doubleT[2])
        for k, potential in pairs(potentials) do
            if self.tiles[doubleT[1]][doubleT[2]].color == self.tiles[potential[1]][potential[2]].color then
                return true
            end
        end
    end
        

    -- double tile type 2
    for y = 1, 8 do
        for x = 1, 6 do
            if self.tiles[y][x].color == self.tiles[y][x + 2].color then
                table.insert(doubleTiles2, {y, x})
            end
        end
    end

    -- check is there a tile around could match the double
    for k, doubleT in pairs(doubleTiles2) do
        local potentials = getPotentials2(doubleT[1], doubleT[2])
        for k, potential in pairs(potentials) do
            if self.tiles[doubleT[1]][doubleT[2]].color == self.tiles[potential[1]][potential[2]].color then
                return true
            end
        end
    end
        
    -- double tile type 3
    for y = 1, 7 do
        for x = 1, 8 do
            if self.tiles[y][x].color == self.tiles[y + 1][x].color then
                table.insert(doubleTiles3, {y, x})
            end
        end
    end

    -- check is there a tile around could match the double
    for k, doubleT in pairs(doubleTiles3) do
        local potentials = getPotentials3(doubleT[1], doubleT[2])
        for k, potential in pairs(potentials) do
            if self.tiles[doubleT[1]][doubleT[2]].color == self.tiles[potential[1]][potential[2]].color then
                return true
            end
        end
    end
        

    -- double tile type 4
    for y = 1, 6 do
        for x = 1, 8 do
            if self.tiles[y][x].color == self.tiles[y + 2][x].color then
                table.insert(doubleTiles4, {y, x})
            end
        end
    end

    -- check is there a tile around could match the double
    for k, doubleT in pairs(doubleTiles4) do
        local potentials = getPotentials4(doubleT[1], doubleT[2])
        for k, potential in pairs(potentials) do
            if self.tiles[doubleT[1]][doubleT[2]].color == self.tiles[potential[1]][potential[2]].color then
                return true
            end
        end
    end

    return false
end


function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
