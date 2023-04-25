--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), generate all of the
    quads for the different tiles therein, divided into tables for each set
    of tiles, since each color has 6 varieties.
]]
function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    -- 9 rows of tiles
    for row = 1, 9 do
        
        -- two sets of 6 cols, different tile varietes
        for i = 1, 2 do
            tiles[counter] = {}
            
            for col = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(
                    x, y, 32, 32, atlas:getDimensions()
                ))
                x = x + 32
            end

            counter = counter + 1
        end
        y = y + 32
        x = 0
    end

    return tiles
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

-- get random subset function
function getsubset(subsetq, setq)
    if subsetq > setq then
        return false
    end

    local set = {}
    for i = 1, setq do
        set[i] = i
    end

    local subset = {}
    for i = 1, subsetq do
        subset[i] = table.remove(set, math.random(setq + 1 - i))
    end

    return subset
end

-- get positions of potential tiles 
function getPotentials1(y, x)
    local potentials = {}
    if (y - 1) >= 1 and (x - 1) >= 1 then
        table.insert(potentials, {y - 1, x - 1})
    end

    if (x - 2) >= 1 then
        table.insert(potentials, {y, x - 2})
    end

    if (y + 1) <= 8 and (x - 1) >= 1 then
        table.insert(potentials, {y + 1, x - 1})
    end

    if (y - 1) >= 1 and (x + 2) <= 8 then
        table.insert(potentials, {y - 1, x + 2})
    end
    
    if (x + 3) <= 8 then
        table.insert(potentials, {y, x + 3})
    end
    
    if (y + 1) <= 8 and (x + 2) <= 8 then
        table.insert(potentials, {y + 1, x + 2})
    end

    return potentials
end

function getPotentials2(y, x)
    local potentials = {}
    if (y - 1) >= 1 and (x + 1) <= 7 then
        table.insert(potentials, {y - 1, x + 1})
    end

    if (y + 1) <= 8 and (x + 1) <= 7 then
        table.insert(potentials, {y + 1, x + 1})
    end

    return potentials
end

function getPotentials3(y, x)
    local potentials = {}
    if (y - 1) >= 1 and (x - 1) >= 1 then
        table.insert(potentials, {y - 1, x - 1})
    end

    if (y - 2) >= 1 then
        table.insert(potentials, {y - 2, x})
    end

    if (y - 1) >= 1 and (x + 1) <= 8 then
        table.insert(potentials, {y - 1, x + 1})
    end

    if (y + 2) <= 8 and (x - 1) >= 1 then
        table.insert(potentials, {y + 2, x - 1})
    end
    
    if (y + 3) <= 8 then
        table.insert(potentials, {y + 3, x})
    end
    
    if (y + 2) <= 8 and (x + 1) <= 8 then
        table.insert(potentials, {y + 2, x + 1})
    end

    return potentials
end

function getPotentials4(y, x)
    local potentials = {}
    if (y + 1) <= 7 and (x - 1) >= 1 then
        table.insert(potentials, {y + 1, x - 1})
    end

    if (y + 1) <= 7 and (x + 1) <= 8 then
        table.insert(potentials, {y + 1, x + 1})
    end

    return potentials
end
