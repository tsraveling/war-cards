CardSprites = {}
Cards = {}
TempIndex = 1
DeltaCounter = 0.0
Duration = 0.2

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") -- Do clear pixel art
  Sheets = require("lib.Sheets")
  CardSprites = Sheets.make("art/cards.png", 48, 64)
  Cards = require("game_data.Cards")

  -- next:
  -- the backs are 61-69 (nice), so
  -- 1. "shuffle" Cards into two player "decks"
  -- 2. for each round, show deck (ie the back frame), then when the player hits SPACE, show the "top"
  --    card next to the deck frame (ie, show the top card)
  -- 3. display status
  -- 4. mutate state
  -- 5. check for victory conditions
  -- for the two players
end

function love.update(dt)

  -- Temporarily loop through and show all of the cards in the deck.
  
  -- DeltaCounter is used to convert dt, aka delta, aka time passed per frame, e.g. 16ms for
  -- 60FPS (1000 / 60).
  --
  -- Delta is a key game programming concept, and is a part of every game engine. It gives you a
  -- surefire way to convert processor cycles (ie, every time love.update is called) into real time,
  -- to ensure that things happen smoothly regardless of how fast a player's processor is.
  --
  -- In older DOS games, they often used cycles directly, which is why those games are unplayable
  -- today without artificially throttling the emulator's processor cycle.
  DeltaCounter = DeltaCounter + dt

  -- This pattern basically just says "do something every {Duration}" in this case every 0.2s
  if DeltaCounter >= Duration then

    -- Reset the counter
    DeltaCounter = 0

    -- This is the index of the card to display
    TempIndex = TempIndex + 1

    -- In Lua, #{array} counts it, so this just loops through the 52 cards endlessly
    if TempIndex > #Cards then
      TempIndex = 1
    end
  end
end

function love.draw()
  love.graphics.print("Hello world", 400, 300)

  -- Get the current card
  local frame = Cards[TempIndex].frame

  -- Draw the current quad
  love.graphics.draw(CardSprites.image, CardSprites.quads[frame], 0, 0, 0, 4)
end
