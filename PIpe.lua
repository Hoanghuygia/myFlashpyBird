Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('rss/picture/pipe.png')
local PIPE_SCROll = -60

function Pipe:init()
    self.x = VIRTUAL_WINDOW_WIDTH
    self.y = math.random(VIRTUAL_WINDOW_HEIGHT/4, VIRTUAL_WINDOW_HEIGHT - 10)
    self.width = PIPE_IMAGE.getWidth()
    
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROll * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end