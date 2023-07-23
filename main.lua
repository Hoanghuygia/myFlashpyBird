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
local againButton = love.graphics.newImage('rss/picture/undo1.png')

local xGround = 0
local xBackGround = 0
local spawTimer = 0
local score = 0
local colDistance = 250
local Timer = 3
local countTime = 0
local countDownTime = 1
count = 0

GROUND_SPEED = 120
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

    sounds = {
        ['jump'] = love.audio.newSource('rss/sound/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('rss/sound/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('rss/sound/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('rss/sound/score.wav', 'static'),
        ['ping'] = love.audio.newSource('rss/sound/beep.mp3', 'static'),

        ['music'] = love.audio.newSource('rss/sound/marios_way.mp3', 'static')
    }

    for i, sound in pairs(sounds) do
        sound:setVolume(0.5)
    end

    sounds['music']:setLooping(true)
    -- sounds['music']:setVolume(0.1)
    sounds['music']:play()
    

    flFontMedium = love.graphics.newFont('rss/font/flappy.ttf', 16)
    flFontBig = love.graphics.newFont('rss/font/flappy.ttf', 52)
    fontMedium = love.graphics.newFont('rss/font/font.ttf', 16)
    fontHuge = love.graphics.newFont('rss/font/font.ttf',72)

    gameState = 'startState'

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
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
            gameState = 'countDownState'
        elseif gameState == 'loseState' then
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

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
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

        count = count + 1
        if count == 30 then
            count = 0
        end

        if pipes[#pipes].x < (VIRTUAL_WINDOW_WIDTH - colDistance) then
            table.insert(pipes, Pipe())
        end

        bird:update(dt)

        for i, pipe in pairs(pipes) do
            pipe:update(dt)

            if checkCollide(pipe) then
                sounds['hurt']:play()
                gameState = 'loseState'
            end

            if (bird.x) > (pipe.x + pipe.width) and pipe.countable then 
                sounds['score']:play()
                score = score + 1
                setPipeScroll(-2)
                GROUND_SPEED = GROUND_SPEED - 2
                if colDistance > 150 then
                    colDistance = colDistance - 2
                end
                if distance > 90 then 
                    distance = distance - 2
                end
                -- distance = distance - 2
                pipe.countable = false
            end

            if pipe.x + pipe.width < 0 then
                table.remove(pipes, i)
            end
        end

        love.keyboard.keysPressed = {}
        love.mouse.buttonsPressed = {}
    elseif gameState == 'startState' then
        resetGame()
    elseif gameState == 'countDownState' then
        countTime = countTime + dt
        if countTime > countDownTime then
            countTime = countTime % countDownTime
            sounds['ping']:play()
            Timer = Timer - 1
        end
        if Timer == 0 then
            gameState = 'playState'
            Timer = 3
        end
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
    
    if gameState == 'countDownState' then
        love.graphics.print('Game State: '..gameState, VIRTUAL_WINDOW_WIDTH / 2, 2)
    end

    bird:render()

    if gameState == 'playState' then
        displayScore()
    elseif gameState == 'countDownState' then
        displayCountDowmState()
    elseif gameState == 'startState' then
        displayStartScreen()
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
    love.graphics.printf('Game Over', 0, VIRTUAL_WINDOW_HEIGHT / 4 - 20, 512, 'center')  

    --window score
    -- love.graphics.setColor(217/255, 194/255, 178/255, 200/255)
    -- love.graphics.rectangle("fill", 124, 105, 256, 144)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    love.graphics.setFont(flFontMedium)
    love.graphics.printf('Your score ', 0, VIRTUAL_WINDOW_HEIGHT / 4 + 50, 512, 'center')
    love.graphics.printf(tostring(score), 0, VIRTUAL_WINDOW_HEIGHT / 4 + 70, 512, 'center')

    love.graphics.draw(againButton, VIRTUAL_WINDOW_WIDTH / 2 - (againButton:getWidth() / 2), VIRTUAL_WINDOW_HEIGHT / 4 + 95)

end

function displayStartScreen()

    love.graphics.setColor(243/255, 182/255, 31/255, 255/255)
    love.graphics.setFont(flFontBig)
    love.graphics.printf('Start', 0, VIRTUAL_WINDOW_HEIGHT / 4 - 20, 512, 'center') 
    
end

function resetGame()
    bird = Bird()
    score = 0
    GROUND_SPEED = 120
    PIPE_SCROLL = -120
    colDistance = 250
    distance = 120
    firstPipe = Pipe()
    pipes = {firstPipe}
end

function displayCountDowmState()
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.setFont(fontMedium)
    love.graphics.printf('Right click or use space to jump', 0, VIRTUAL_WINDOW_HEIGHT / 2 - 50, 512, 'center')
    love.graphics.setFont(fontHuge)
    love.graphics.printf(tostring(Timer), 0, VIRTUAL_WINDOW_HEIGHT / 2, 512, 'center')
end
