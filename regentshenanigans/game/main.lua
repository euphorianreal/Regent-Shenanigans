local x, y
local originX, originY
local width, height
local playerImg

-- table to hold our collision boxes
local platforms = {}

local isOnGround = false
local isJumping = false

local speed = 300
local upVelo = 0
local gravity = 2000

function love.load()
    playerImg = love.graphics.newImage("assets/player.png")
    
    -- standard rendering scales your image by 0.1
    width = playerImg:getWidth() * 0.1
    height = playerImg:getHeight() * 0.1
    
    originX = width / 2
    originY = height / 2

    x = originX
    y = originY

    -- define modular boxes (x, y, width, height)
    table.insert(platforms, {x = 0, y = 500, w = 800, h = 100})
    table.insert(platforms, {x = 300, y = 350, w = 200, h = 40})
    table.insert(platforms, {x = 100, y = 200, w = 150, h = 40})

    love.graphics.setBackgroundColor(1.0, 1.0, 1.0, 1.0)
end

function love.update(dt)
    -- physics velocity loop
    if isJumping then
        upVelo = upVelo + (8000 * dt)
        if upVelo >= 500 then
            upVelo = 500
            isJumping = false 
        end
    else
        if not isOnGround then
            upVelo = upVelo - (gravity * dt)
        else
            upVelo = 0
        end
    end

    -- horizontal movement and box collision
    if love.keyboard.isDown("a") then x = x - speed * dt end
    if love.keyboard.isDown("d") then x = x + speed * dt end

    for _, box in ipairs(platforms) do
        -- check if player overlaps horizontally
        if x < box.x + box.w and x + width > box.x and
           y < box.y + box.h and y + height > box.y then
            -- push out left or right depending on center points
            if (x + width / 2) < (box.x + box.w / 2) then
                x = box.x - width
            else
                x = box.x + box.w
            end
        end
    end

    -- vertical movement and box collision
    y = y - (upVelo * dt)
    isOnGround = false

    for _, box in ipairs(platforms) do
        -- check if player overlaps vertically
        if x < box.x + box.w and x + width > box.x and
           y < box.y + box.h and y + height > box.y then
            -- falling down onto top of the box
            if upVelo <= 0 then
                local floorClipDist = (y + height) - box.y
                y = y - floorClipDist
                isOnGround = true
                upVelo = 0
            -- jumping up hitting bottom of the box
            elseif upVelo > 0 then
                y = box.y + box.h
                upVelo = 0
                isJumping = false
            end
        end
    end

    -- jump input handling
    if love.keyboard.isDown("w") and isOnGround then
        isJumping = true
    end
end

function love.draw()
    -- render platforms
    love.graphics.setColor(0.3, 0.3, 0.3)
    for _, box in ipairs(platforms) do
        love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
    end

    -- render player
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(playerImg, x, y, 0, .1, .1)

    -- text debug displays
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

    local mousex, mousey = love.mouse.getPosition()
    love.graphics.print(mousex, 500, 10)
    love.graphics.print(mousey, 600, 10)
end
