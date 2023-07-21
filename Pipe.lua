Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('rss/picture/pipe.png')
local PITE_IMAGE_REVERSE = love.graphics.newImage('rss/picture/pipe_reverse.png')
PIPE_SCROLL = -120

local xPite
local yPite
distance = 120

function Pipe:init()
    self.x = VIRTUAL_WINDOW_WIDTH
    self.y = math.random(VIRTUAL_WINDOW_HEIGHT / 4 + distance / 2 + 10, VIRTUAL_WINDOW_HEIGHT - 25)
    self.width = PIPE_IMAGE:getWidth()
    self.countable = true
end

function Pipe:update(dt)
    if gameState == 'playState' then
        self.x = self.x + PIPE_SCROLL * dt
    end
end

function Pipe:render()
    xPite = math.floor(self.x + 0.5)
    yPite = math.floor(self.y)
    love.graphics.draw(PIPE_IMAGE, xPite, yPite)
    love.graphics.draw(PITE_IMAGE_REVERSE, xPite, yPite - distance - PITE_IMAGE_REVERSE:getHeight())
end

-- function getPipeScroll()
--     return PIPE_SCROLL
-- end
--settle for PITE_SCROll
function setPipeScroll(value)
    PIPE_SCROLL = PIPE_SCROLL + value
end