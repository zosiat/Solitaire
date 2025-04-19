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
    for i, card in ipairs(self.cards) do
        -- if top card
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

return Pile
