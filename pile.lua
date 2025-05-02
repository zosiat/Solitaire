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

    -- if it's a tableau pile, ensure the last card is face up
    if self.type == "tableau" then
        -- last card in the tableau should be face up
        local lastCard = self.cards[#self.cards]
        lastCard.faceUp = true

        -- if there are other cards, ensure the previous card is face down
        if #self.cards > 1 then
            local secondLastCard = self.cards[#self.cards - 1]
            secondLastCard.faceUp = false
        end
    end
end

function Pile:draw()
    if #self.cards == 0 then
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("line", self.x, self.y, 71, 96)
        love.graphics.setColor(1, 1, 1)
        return
    end

    for i, card in ipairs(self.cards) do
        if self.type == "waste" then
            card.x = self.x + (i - 1) * 15
            card.y = self.y
        elseif self.type == "stock" then
            if i == #self.cards then
                card.faceUp = false
                card.x = self.x
                card.y = self.y
                card:draw()
            end
        else
            -- for tableau: do NOT force faceUp/faceDown here
            card.x = self.x
            card.y = self.y + (i - 1) * 20
            -- just draw based on its current faceUp state
            card:draw()
        end
    end
end

return Pile
