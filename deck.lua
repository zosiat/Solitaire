-- author: Zosia Trela
-- deck.lua

local Card = require("card")

-- shuffle from provided code in lecture slides
local function shuffle(deck)
    local cardCount = #deck
    for i = 1, cardCount do
        local randIndex = math.random(cardCount)
        deck[cardCount], deck[randIndex] = deck[randIndex], deck[cardCount]
        cardCount = cardCount - 1
    end
    return deck
end

local function createDeck()
    local suits = { "hearts", "diamonds", "clubs", "spades" }
    local ranks = {
        "A", "02", "03", "04", "05", "06", "07", "08", "09", "10", "J", "Q", "K"
    }

    local deck = {}
    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            local card = Card:new(suit, rank, false)
            table.insert(deck, card)
        end
    end

    return shuffle(deck)
end

return {
    createDeck = createDeck
}

