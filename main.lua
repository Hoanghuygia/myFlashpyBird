push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WINDOW_WIDTH = 512
VIRTUAL_WINDOW_HEIGHT = 288

local background = love.graphics.newImage('rss/picture/background.png')
local ground = love.graphics.newImage('rss/picture/ground.png')

local xGround = 0
local xBackGround = 0
local spawTimer = 0
local score = 0
local colDistance = 250

GROUND_SPEED = 60
BACKGROUND_SPEED = 20
BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local firstPipe = Pipe()
local pipes = {firstPipe}


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Huy's Flashpy Bird")

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    flFontMedium = love.graphics.newFont('rss/font/flappy.ttf', 16)
    flFontBig = love.graphics.newFont('rss/font/flappy.ttf', 52)
    fontMedium = love.graphics.newFont('rss/font/font.ttf', 16)

    gameState = 'startState'

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
    
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'startState' then
            gameState = 'playState'
        else 
            gameState = 'startState'
        end
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- GROUND_SPEED = GROUND_SPEED + score
    if gameState == 'playState' then
        xGround = (xGround + GROUND_SPEED * dt) % VIRTUAL_WINDOW_WIDTH
        xBackGround = (xBackGround + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT--kiểu reset lại không cho toạ độ của xBackGround, xGround không bao giờ vượt qua một số
        --nếu không thì nó sẽ reset lại giá trị ban đầu

        -- spawTimer = spawTimer + dt
        -- if spawTimer > 3 then
        --     table.insert(pipes, Pipe())
        --     spawTimer = 0
        -- end

        if pipes[#pipes].x < (VIRTUAL_WINDOW_WIDTH - colDistance) then
            table.insert(pipes, Pipe())
        end

        bird:update(dt)
        -- bird:checkCollide()

        -- if bird.isCollide then
        --     gameState = 'loseState'
        -- end

        for i, pipe in pairs(pipes) do
            pipe:update(dt)

            if checkCollide(pipe) then
                gameState = 'loseState'
            end

            if (bird.x) > (pipe.x + pipe.width) and pipe.countable then 
                score = score + 1
                pipe.countable = false
            end

            -- if (bird.x) > (pipe.x) and pipe.countable then 
            --     score = score + 1
            --     pipe.countable = false
            -- end

            if pipe.x + pipe.width < 0 then
                table.remove(pipes, i)
            end
        end

        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:start()
    love.graphics.setFont(fontMedium)
    love.graphics.setFont(love.graphics.newFont())

    love.graphics.draw(background, -xBackGround, 0)
    love.graphics.draw(ground, -xGround, VIRTUAL_WINDOW_HEIGHT - 16)

    
    for i, pipe in pairs(pipes) do 
        pipe:render()
    end
    
    love.graphics.print('Game State: '..GROUND_SPEED, VIRTUAL_WINDOW_WIDTH / 2, 2)

    bird:render()

    if gameState == 'playState' or gameState == 'startState' then
        displayScore()
    else
        displayScoreScreen()
    end

    push:finish()
    
end

function displayScore()
    love.graphics.setFont(flFontMedium)
    love.graphics.printf('Score', 0, VIRTUAL_WINDOW_HEIGHT / 4 - 15, 512, 'center')
    love.graphics.printf(tostring(score), 0, VIRTUAL_WINDOW_HEIGHT / 4 + 5, 512, 'center')
end

function checkCollide(pipe)
    if bird.y < 0 or bird.y + bird.height > VIRTUAL_WINDOW_HEIGHT - 16 then
        return true
    end

    if bird.x + bird.width > pipe.x and bird.y + bird.height > pipe.y and pipe.countable == true or 
            bird.x + bird.width > pipe.x and bird.y < pipe.y - distance and pipe.countable == true then
        return true
    end

    return false
end

function displayScoreScreen()
    love.graphics.setColor(243/255, 182/255, 31/255, 255/255)
    love.graphics.setFont(flFontBig)
    love.graphics.printf('Game Over', 0, VIRTUAL_WINDOW_HEIGHT / 4, 512, 'center')  
end
