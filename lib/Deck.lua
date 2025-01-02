local Deck = {}

-- This method just makes an array of indices from 1 to 52.
function Deck.make()
  local deck = {}
  for i = 1, 52 do
    deck[i] = i
  end
  return deck
end

-- This method shuffles an array. Pass a seed if we are shuffling in the same frame.
function Deck.shuffle(deck, seed)
  math.randomseed(os.time() + seed)

  -- in Lua, the 3 args of a loop are start, end, and step. This starts at the end of the array
  -- and then counts down to 2. this is called the "Fisher-Yates shuffle algorithm." It switches
  -- each card starting at the 52nd with some other card randomly drawn from the unshuffled
  -- part of the deck, ie, if we are on the 40th card, it will draw randomly from the 39 cards
  -- underneath it. This is also why we stop at 2, because at that point there is only a single
  -- card underneath (which has probably already been swapped out). This algorithm ensures that
  -- every possible deck configuration is equally likely.
  for i = #deck, 2, -1 do
    local j = math.random(i)            -- pick a random number up to the current index
    deck[i], deck[j] = deck[j], deck[i] -- this is lua for "swap the items at i and j"
  end
end

return Deck
