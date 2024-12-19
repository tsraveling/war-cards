
local cards = {}

-- set up our suits
local suits = {"hearts", "diamonds", "spades", "clubs"}

-- loop through the suits
for suitIndex, suitName in ipairs(suits) do

  -- For each suit, loop through the cards from 2 to king (aces high)
  for val=2, 13 do
    local card = {
      suit = suitName, -- add the suit
      value = val, -- card value is calculated directly (e.g. K > Q)
      frame = ((suitIndex - 1) * 15) + val -- my cropped spritesheet is 15 frames wide, so this gets the right frame for this card.
    }
    table.insert(cards, card)
  end

  -- Add the high ace
  table.insert(cards, {
    suit = suitName,
    value = 14,
    frame = ((suitIndex - 1) * 15) + 1
  })
end



return cards
