function love.load()
    imagedata = love.image.newImageData('test.png')
    image = love.graphics.newImage('test.png')

    -- get the width and height of background picture
    width = image:getWidth()
    height = image:getHeight()

    -- recognize the platforms from the background picture
    local platforms = {}
    for y = 1, height do
        table.insert(platforms, {})
        for x = 1, width do
            local r, g, b = imagedata:getPixel(x - 1, y - 1)
            table.insert(platforms[y], (r == 1 and g == 1 and b == 1))
        end
    end

    for x = 1, width do
        print(platforms[3][x])
    end
end

function love.draw()
    love.graphics.draw(image, 0, 0)
end



