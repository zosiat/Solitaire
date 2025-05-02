-- author: Zosia Trela
-- main.lua
-- 4/18/25
-- CMPM 121

local Deck = require("deck")
local Pile = require("pile")
local Card = require("card")
local Grabber = require("grabber")
local grabber = Grabber:new()

local cards = {}
local tableauPiles = {}
local foundationPiles = {}
local deckPile = nil
local wastePile = nil
local drawnCards = {}
local draggedCard = nil
local mouseOffset = { x = 0, y = 0 }
local draggedCardOrigin = nil

function love.load()
    love.window.setTitle("Solitaire")
    love.graphics.setBackgroundColor(0, 0.5, 0)

    -- create deck
    cards = Deck.createDeck()

    -- create piles
    deckPile = Pile:new(10, 10, "deck")
    wastePile = Pile:new(100, 10, "waste")

    -- suit piles
    local foundationStartX = 800
    for i = 1, 4 do
        foundationPiles[i] = Pile:new(foundationStartX + (i - 1) * 100, 10, "foundation")
    end

    -- create tableau piles
    for i = 1, 7 do
        tableauPiles[i] = Pile:new(10 + (i - 1) * 100, 200, "tableau")
    end

    -- deal cards into tableau piles
    local cardIndex = 1
    for i = 1, 7 do
        for j = 1, i do
            tableauPiles[i]:addCard(cards[cardIndex])
            cardIndex = cardIndex + 1
        end
    end

    -- add remaining cards to the deck pile
    for i = cardIndex, #cards do
        deckPile:addCard(cards[i])
    end
end

function love.draw()
    -- drawing all piles
    for _, pile in ipairs(tableauPiles) do
        pile:draw()
    end

    for _, pile in ipairs(foundationPiles) do
        pile:draw()
    end

    -- draw deck pile
    if #deckPile.cards > 0 then
        local topCard = deckPile.cards[#deckPile.cards]
        topCard.faceUp = false  -- ensure the card is face down
        topCard:draw()
    end

    -- draw waste pile
    wastePile:draw()

    -- drawn cards under deck
    local offsetX = deckPile.x
    local offsetY = deckPile.y + 100
    for i, card in ipairs(drawnCards) do
        card.x = offsetX + (i - 1) * 15
        card.y = offsetY
        card:draw()
    end

    -- draw the dragged card
    if draggedCard then
        draggedCard.x = love.mouse.getX() - mouseOffset.x
        draggedCard.y = love.mouse.getY() - mouseOffset.y
        draggedCard:draw()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- draw card logic now in grabber
        grabber:tryDrawFromDeck(x, y, deckPile, drawnCards)

    -- tableau check
    for _, pile in ipairs(tableauPiles) do
        for i, card in ipairs(pile.cards) do
            if card.faceUp and x >= card.x and x <= card.x + 71 and y >= card.y and y <= card.y + 96 then
                draggedCard = card
                draggedCardOrigin = pile -- ✅ store where the card came from
                mouseOffset.x = x - card.x
                mouseOffset.y = y - card.y
                break
            end
        end
    end
    -- drawnCards check
    for i, card in ipairs(drawnCards) do
        if card.faceUp and x >= card.x and x <= card.x + 71 and y >= card.y and y <= card.y + 96 then
            draggedCard = card
            draggedCardOrigin = "drawn"
            mouseOffset.x = x - card.x
            mouseOffset.y = y - card.y
            break
        end
    end
end
end
function love.mousereleased(x, y, button)
    if button == 1 then
        if draggedCard then
            local cardDropped = false

            -- drop on waste pile (optional, remove if you don't want this)
            if x >= wastePile.x and x <= wastePile.x + 71 and y >= wastePile.y and y <= wastePile.y + 96 then
                table.insert(wastePile.cards, draggedCard)
                cardDropped = true
            end

            -- drop on tableau piles
            for _, pile in ipairs(tableauPiles) do
                if x >= pile.x and x <= pile.x + 71 and y >= pile.y and y <= pile.y + 96 then
                    table.insert(pile.cards, draggedCard)
                    cardDropped = true
                    break
                end
            end

            -- drop on foundation piles
            for _, pile in ipairs(foundationPiles) do
                if x >= pile.x and x <= pile.x + 71 and y >= pile.y and y <= pile.y + 96 then
                    table.insert(pile.cards, draggedCard)
                    cardDropped = true
                    break
                end
            end

            -- safely remove draggedCard from its origin
            if cardDropped then
                if type(draggedCardOrigin) == "table" then
                    -- it's a pile
                    for i = #draggedCardOrigin.cards, 1, -1 do
                        if draggedCardOrigin.cards[i] == draggedCard then
                            table.remove(draggedCardOrigin.cards, i)
                            break
                        end
                    end
                elseif draggedCardOrigin == "drawn" then
                    -- it's from drawnCards
                    for i = #drawnCards, 1, -1 do
                        if drawnCards[i] == draggedCard then
                            table.remove(drawnCards, i)
                            break
                        end
                    end
                end

                -- set final position
                draggedCard.x = x
                draggedCard.y = y
            end

            -- clear drag state
            draggedCard = nil
            draggedCardOrigin = nil
        end
    end
end

function love.mousemoved(x, y, dx, dy)

end

function love.update(dt)
      grabber:update()
end
