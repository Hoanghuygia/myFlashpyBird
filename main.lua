push = require 'push'
Class = require 'class'

require 'Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WINDOW_WIDTH = 512
VIRTUAL_WINDOW_HEIGHT = 288

local background = love.graphics.newImage('rss/picture/background.png')
local ground = love.graphics.newImage('rss/picture/ground.png')

local xGround = 0
local xBackGround = 0

GROUND_SPEED = 60
BACKGROUND_SPEED = 30
BACKGROUND_LOOPING_POINT = 413

local bird = Bird()



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Huy's Flashpy Bird")

    push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

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

    bird:update(dt)
    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start()

    love.graphics.draw(background, -xBackGround, 0)
    love.graphics.draw(ground, -xGround, VIRTUAL_WINDOW_HEIGHT - 16)

    love.graphics.print('Game State: '..gameState, VIRTUAL_WINDOW_WIDTH / 2, 2)
    
    bird:render()

    push:finish()
    
end
