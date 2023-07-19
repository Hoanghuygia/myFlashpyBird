Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('rss/picture/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WINDOW_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_WINDOW_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    if gameState == 'playState' then
        self.dy = self.dy + GRAVITY * dt--chỗ này cực kì quan trọng, nó làm cho vẫn tốc thay đổi từ từ
        --công thức v = v0 + at thì cái này cũng vậy, khi có v0 = -5, trường hợp v0 = 0 thì không cần
        if love.keyboard.wasPressed('space') then
            self.dy = -5
        end
    end
    self.y = self.y + self.dy

end

function Bird:render()--mình hay bị mấy cái lỗi khi tạo function trong 
    love.graphics.draw(self.image, self.x, self.y)
end