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

-- constants
local green = {0, 0.5, 0}
local lightgreen = {0.6, 1, 0.6}
local resetColor = {240, 248, 255}
local CARD_WIDTH = 71
local CARD_HEIGHT = 96
local PILE_SPACING = 100
local TABLEAU_START_Y = 200
local DECK_X = 10
local DECK_Y = 10
local WASTE_X = 100
local FOUNDATION_START_X = 300
local DRAWN_CARD_OFFSET = 15
local DRAWN_CARD_Y_OFFSET = 100

--reset button info
local resetButton = {
    x = 700,
    y = 550,
    width = 100,
    height = 40
}

function love.load()
    love.window.setTitle("Solitaire")
    love.graphics.setBackgroundColor(green)

    -- create deck
    cards = Deck.createDeck()

    -- create piles
    deckPile = Pile:new(DECK_X, DECK_Y, "deck")
    wastePile = Pile:new(WASTE_X, DECK_Y, "waste")

    -- suit piles
    local foundationStartX = FOUNDATION_START_X
    for i = 1, 4 do
        foundationPiles[i] = Pile:new(foundationStartX + (i - 1) * PILE_SPACING, DECK_Y, "foundation")
    end

    -- create tableau piles
    for i = 1, 7 do
        tableauPiles[i] = Pile:new(DECK_X + (i - 1) * PILE_SPACING, TABLEAU_START_Y, "tableau")
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

    for i, pile in ipairs(foundationPiles) do
        pile:draw()

        -- draw placeholder suit image if pile is empty
        if #pile.cards == 0 then
            local image = nil
            if i == 1 then image = diamondsImage
            elseif i == 2 then image = heartsImage
            elseif i == 3 then image = spadesImage
            elseif i == 4 then image = clubsImage end

            if image then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(image, pile.x, pile.y, 0, 2, 2) -- scale image smaller
            end
        end
    end

    -- draw deck pile (with placeholder if empty)
    if #deckPile.cards == 0 then
        --drawPlaceholder(deckPile.x, deckPile.y)  -- draw placeholder
    else
        local topCard = deckPile.cards[#deckPile.cards]
        topCard.faceUp = false  -- ensure the card is face down
        topCard:draw()
    end

    -- draw all cards in waste pile (with placeholder if empty)
    if #wastePile.cards == 0 then
        drawPlaceholder(wastePile.x, wastePile.y)  -- draw placeholder
    else
        for i, card in ipairs(wastePile.cards) do
            card.x = wastePile.x + (i) * 5 -- slight spread so they stack visibly
            card.y = wastePile.y
            card:draw()
        end
    end

    -- drawn cards under deck
    local offsetX = deckPile.x
    local offsetY = deckPile.y + DRAWN_CARD_Y_OFFSET
    for i, card in ipairs(drawnCards) do
        card.x = offsetX + (i - 1) * DRAWN_CARD_OFFSET
        card.y = offsetY
        card:draw()
    end

    -- draw the dragged card
    if draggedCard then
        draggedCard.x = love.mouse.getX() - mouseOffset.x
        draggedCard.y = love.mouse.getY() - mouseOffset.y
        draggedCard:draw()
    end

    -- draw reset button
    love.graphics.setColor(resetColor)
    love.graphics.rectangle("fill", resetButton.x, resetButton.y, resetButton.width, resetButton.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Reset", resetButton.x + 25, resetButton.y + 12)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- draw card logic now in grabber
        grabber:tryDrawFromDeck(x, y, deckPile, drawnCards)

        -- tableau check
        for _, pile in ipairs(tableauPiles) do
            for i, card in ipairs(pile.cards) do
                if card.faceUp and x >= card.x and x <= card.x + CARD_WIDTH and y >= card.y and y <= card.y + CARD_HEIGHT then
                    draggedCard = card
                    draggedCardOrigin = pile -- store where the card came from
                    mouseOffset.x = x - card.x
                    mouseOffset.y = y - card.y
                    break
                end
            end
        end
        
        for i, card in ipairs(drawnCards) do
            if card.faceUp and x >= card.x and x <= card.x + CARD_WIDTH and y >= card.y and y <= card.y + CARD_HEIGHT then
                draggedCard = card
                draggedCardOrigin = "drawn"
                mouseOffset.x = x - card.x
                mouseOffset.y = y - card.y
                break
            end
        end
    end
  -- reset button logic
  if x >= resetButton.x and x <= resetButton.x + resetButton.width and
     y >= resetButton.y and y <= resetButton.y + resetButton.height then
      resetGame()
  end


end

function love.mousereleased(x, y, button)
    if button == 1 then
        if draggedCard then
            local cardDropped = false

            -- drop on waste pile (optional, remove if you don't want this)
            if x >= wastePile.x and x <= wastePile.x + CARD_WIDTH and y >= wastePile.y and y <= wastePile.y + CARD_HEIGHT then
                table.insert(wastePile.cards, draggedCard)
                cardDropped = true
            end

            -- drop on tableau piles
            for _, pile in ipairs(tableauPiles) do
                if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT then
                    table.insert(pile.cards, draggedCard)
                    cardDropped = true
                    break
                end
            end

            -- drop on foundation piles
            for _, pile in ipairs(foundationPiles) do
                if x >= pile.x and x <= pile.x + CARD_WIDTH and y >= pile.y and y <= pile.y + CARD_HEIGHT then
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

function resetGame()
    -- move all drawn cards back to the deck
    for i = #drawnCards, 1, -1 do
        table.insert(deckPile.cards, drawnCards[i])
        table.remove(drawnCards, i)
    end

    -- reshuffle the deck
    math.randomseed(os.time())
    for i = #deckPile.cards, 2, -1 do
        local j = math.random(i)
        deckPile.cards[i], deckPile.cards[j] = deckPile.cards[j], deckPile.cards[i]
    end

    love.load()
end

-- placeholder rectangle for when deck/ waste pile is empty
function drawPlaceholder(x,y)
      love.graphics.setColor(lightgreen)
    local padding = 6
    local w, h = 71 - padding * 2, 96 - padding * 2
    love.graphics.rectangle("line", x + padding, y + padding, w, h, 8, 8)
    love.graphics.setColor(1, 1, 1)
end