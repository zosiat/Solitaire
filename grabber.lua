-- grabber.lua 

Grabber = {}
Grabber.__index = Grabber

function Grabber:new()
    local self = setmetatable({}, Grabber)
    self.heldObject = nil
    self.grabX = nil
    self.grabY = nil
    return self
end

function Grabber:update()
    local x, y = love.mouse.getX(), love.mouse.getY()

    if love.mouse.isDown(1) and not self.grabX then
        self:grab(x, y)
    end

    if not love.mouse.isDown(1) and self.grabX then
        self:release(x, y)
    end
end

function Grabber:grab(x, y)
    self.grabX = x
    self.grabY = y
    print("GRAB at", x, y)
end

function Grabber:release(x, y)
    print("RELEASE at", x, y)
    -- If needed, add logic here to revert position
    if self.heldObject then
        self.heldObject.state = 0
        self.heldObject = nil
    end
    self.grabX = nil
    self.grabY = nil
end

function Grabber:tryDrawFromDeck(x, y, deckPile, drawnCards)
    if x >= deckPile.x and x <= deckPile.x + 71 and y >= deckPile.y and y <= deckPile.y + 96 then
        if #deckPile.cards > 0 then
            for i = 1, 3 do
                local card = table.remove(deckPile.cards)
                if not card then break end
                card.faceUp = true
                table.insert(drawnCards, card)
            end
        end
        return true
    end
    return false
end

function Grabber:handleDropOnTableau(x, y, draggedCard, tableauPiles)
    for _, pile in ipairs(tableauPiles) do
        if x >= pile.x and x <= pile.x + 71 and y >= pile.y and y <= pile.y + 96 then
            for _, originPile in ipairs(tableauPiles) do
                for i, card in ipairs(originPile.cards) do
                    if card == draggedCard then
                        table.remove(originPile.cards, i)
                        local topCard = originPile.cards[#originPile.cards]
                        if topCard and not topCard.faceUp then
                            topCard.faceUp = true
                        end
                        break
                    end
                end
            end

            table.insert(pile.cards, draggedCard)
            return true
        end
    end
    return false
end

function Grabber:handleDropOnWaste(x, y, draggedCard, wastePile, drawnCards)
    if x >= wastePile.x and x <= wastePile.x + 71 and y >= wastePile.y and y <= wastePile.y + 96 then
        -- remove from drawn cards
        for i, card in ipairs(drawnCards) do
            if card == draggedCard then
                table.remove(drawnCards, i)
                break
            end
        end
        -- add to waste pile
        table.insert(wastePile.cards, draggedCard)
        return true
    end
    return false
end

return Grabber
