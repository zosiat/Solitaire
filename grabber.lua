-- grabber.lua
local grabber = {}

-- for debugging
print("Loaded grabber module")

function grabber.tryDrawFromDeck(x, y, deckPile, drawnCards)
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

function grabber.handleDropOnTableau(x, y, draggedCard, tableauPiles)
    for _, pile in ipairs(tableauPiles) do
        if x >= pile.x and x <= pile.x + 71 and y >= pile.y and y <= pile.y + 96 then
            -- find the original pile containing the dragged card
            for _, originPile in ipairs(tableauPiles) do
                for i, card in ipairs(originPile.cards) do
                    if card == draggedCard then
                        table.remove(originPile.cards, i)

                        -- flip new top card face up if it's face down
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

return grabber