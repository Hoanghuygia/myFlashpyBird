Bird = Class{}

function Bird:init()
    self.image = love.graphics.newImage('rss/picture/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_WINDOW_HEIGHT / 2 - (self.height / 2)
end

function Bird:render()--mình hay bị mấy cái lỗi khi tạo function trong 
    love.graphics.draw(self.image, self.x, self.y)
end