-- pile.lua

local Pile = {}
Pile.__index = Pile

function Pile:new(x, y, type)
    local this = {
        x = x,
        y = y,
        type = type, -- type of pile
        cards = {}
    }

    setmetatable(this, Pile)
    return this
end

function Pile:addCard(card)
    table.insert(self.cards, card)
end

-- draw pile
function Pile:draw()
    if #self.cards == 0 then
        -- draw a placeholder rectangle if pile is empty
        love.graphics.setColor(0.2, 0.2, 0.2) -- dark grey
        love.graphics.rectangle("line", self.x, self.y, 71, 96)
        love.graphics.setColor(1, 1, 1)
        return
    end

    for i, card in ipairs(self.cards) do
        if self.type == "waste" then
            card.x = self.x + (i - 1) * 15
            card.y = self.y
        elseif self.type == "stock" then
            -- stock pile should draw only the top card, face down
            if i == #self.cards then
                card.faceUp = false
                card.x = self.x
                card.y = self.y
                card:draw()
            end
        else
            -- for tableau and foundation
            if i == #self.cards then
                card.faceUp = true
            else
                card.faceUp = false
            end
            card.x = self.x
            card.y = self.y + (i - 1) * 20
            card:draw()
        end
    end
end

return Pile
