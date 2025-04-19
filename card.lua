-- author: Zosia Trela
-- card.lua

local Card = {}
Card.__index = Card

function Card:new(suit, rank, faceUp)
    local this = {
        suit = suit,
        rank = rank,
        faceUp = faceUp or false,
        x = 0,
        y = 0,
        width = 80,
        height = 120,
        image = nil,
        backImage = nil
    }

    -- image path
    local imagePath = "assets/card_" .. suit .. "_" .. rank .. ".png"
    this.image = love.graphics.newImage(imagePath)
    this.backImage = love.graphics.newImage("assets/card_back.png")

    setmetatable(this, Card)
    return this
end

function Card:draw()
    love.graphics.setColor(1, 1, 1)
    if self.faceUp then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
    else
        love.graphics.draw(self.backImage, self.x, self.y, 0, 1, 1)
    end
end

return Card
