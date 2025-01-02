CardSprites = {}
Cards = {}
TempIndex = 1
DeltaCounter = 0.0
Duration = 0.2

YourDeck = {}
EnemyDeck = {}

CurrentRound = 1

-- 1: Face down
-- 2: Revealed
Phase = 1

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") -- Do clear pixel art
  Sheets = require("lib.Sheets")
  Deck = require("lib.Deck")
  CardSprites = Sheets.make("art/cards.png", 48, 64)
  Cards = require("game_data.Cards")

  -- now shuffle the deck using our custom deck library
  YourDeck = Deck.make()
  Deck.shuffle(YourDeck, 1)

  -- do the same for the enemy
  EnemyDeck = Deck.make()
  Deck.shuffle(EnemyDeck, 2)
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

function love.keypressed(key)
  if key == "space" then
    if Phase == 1 then
      Phase = 2
    else
      Phase = 1
      CurrentRound = CurrentRound + 1
    end
  end
end

function love.draw()
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  local scale = 3
  local cardWidth = 48 * scale -- we know this from the sprites, then multiply by card scale
  local cardHeight = 64 * scale

  love.graphics.print("Hello world", 400, 300)

  -- Get the current card
  local frame = Cards[TempIndex].frame

  local topFrame = Phase == 1 and 61 or Cards[YourDeck[CurrentRound]].frame
  local bottomFrame = Phase == 1 and 61 or Cards[EnemyDeck[CurrentRound]].frame

  -- Top card (centered horizontally, 50px from top)
  love.graphics.draw(
    CardSprites.image,
    CardSprites.quads[topFrame],
    (screenWidth - cardWidth) / 2, -- center horizontally
    50,                            -- 50px from top
    0,                             -- rotation
    scale
  )

  -- Bottom card (centered horizontally, 50px from bottom)
  love.graphics.draw(
    CardSprites.image,
    CardSprites.quads[bottomFrame],
    (screenWidth - cardWidth) / 2,
    screenHeight - (cardHeight + 50), -- 50px from bottom
    0,
    scale
  )
end
