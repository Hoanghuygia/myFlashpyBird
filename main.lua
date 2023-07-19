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
local spawTimer = 2
local score = 0


GROUND_SPEED = 60
BACKGROUND_SPEED = 30
BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local pipes = {}



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Huy's Flashpy Bird")

    push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    flFontMedium = love.graphics.newFont('rss/font/flappy.ttf', 16)
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
    xGround = (xGround + GROUND_SPEED * dt) % VIRTUAL_WINDOW_WIDTH
    xBackGround = (xBackGround + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT--kiểu reset lại không cho toạ độ của xBackGround, xGround không bao giờ vượt qua một số
    --nếu không thì nó sẽ reset lại giá trị ban đầu

    spawTimer = spawTimer + dt
    
    if spawTimer > 3 then
        table.insert(pipes, Pipe())
        spawTimer = 0
    end

    bird:update(dt)


    for i, pipe in pairs(pipes) do
        pipe:update(dt)

        if (bird.x + bird.width / 2) > (pipe.x + pipe.width / 2) and pipe.countable then 
            score = score + 1
            pipe.countable = false
        end
        -- if (pipe.x + pipe.width / 2) > (VIRTUAL_WINDOW_WIDTH / 2 - 20) and (pipe.x + pipe.width / 2) > (VIRTUAL_WINDOW_WIDTH / 2 + 20) then
        --     score = score + 1
        -- end

        if pipe.x + pipe.width < 0 then
            table.remove(pipes, i)
        end
    end

     

    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start()
    love.graphics.setFont(fontMedium)
    love.graphics.setFont(love.graphics.newFont())

    love.graphics.draw(background, -xBackGround, 0)
    love.graphics.draw(ground, -xGround, VIRTUAL_WINDOW_HEIGHT - 16)

    love.graphics.print('Game State: '..gameState, VIRTUAL_WINDOW_WIDTH / 2, 2)

    for i, pipe in pairs(pipes) do 
        pipe:render()
    end
    
    bird:render()

    displayScore()

    push:finish()
    
end

function displayScore()
    love.graphics.setFont(flFontMedium)
    love.graphics.printf('Score', 0, VIRTUAL_WINDOW_HEIGHT / 4 - 15, 512, 'center')
    love.graphics.printf(tostring(score), 0, VIRTUAL_WINDOW_HEIGHT / 4 + 5, 512, 'center')
    -- love.graphics.printf()
end
