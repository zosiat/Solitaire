-- author: Zosia Trela
-- main.lua
-- 4/18/25
-- CMPM 121

-- main.lua

local Deck = require("deck")
local Pile = require("pile")
local Card = require("card")

local cards = {}
local tableauPiles = {}
local foundationPiles = {}
local stockPile = nil
local wastePile = nil

function love.load()
    love.graphics.setBackgroundColor(0, 0.5, 0)

    cards = Deck.createDeck()

    -- create piles
    stockPile = Pile:new(10, 10, "stock")
    wastePile = Pile:new(100, 10, "waste")

    for i = 1, 4 do
        foundationPiles[i] = Pile:new(300 + (i - 1) * 100, 10, "foundation")
    end

    -- tableau piles
    for i = 1, 7 do
        tableauPiles[i] = Pile:new(10 + (i - 1) * 100, 200, "tableau")
    end

    -- deal cards in tableau piles
    local cardIndex = 1
    for i = 1, 7 do
        for j = 1, i do
            tableauPiles[i]:addCard(cards[cardIndex])
            cardIndex = cardIndex + 1
        end
    end
end

function love.draw()
    -- drawing piles
    for _, pile in ipairs(tableauPiles) do
        pile:draw()
    end

    for _, pile in ipairs(foundationPiles) do
        pile:draw()
    end

    stockPile:draw()
    wastePile:draw()
end

