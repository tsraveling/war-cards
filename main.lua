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
  -- that sheet is 15 wide A, 1-10, J-K, hearts diamonds spades jokers
  -- which means the backs are 61-69 (nice)
  -- go through and programatically assemble our base deck, then make two of them
  -- for the two players
end

function love.update(dt)
  DeltaCounter = DeltaCounter + dt
  if DeltaCounter >= Duration then
    DeltaCounter = 0
    TempIndex = TempIndex + 1
    if TempIndex > #Cards then
      TempIndex = 1
    end
  end
end

function love.draw()
  love.graphics.print("Hello world", 400, 300)
  local frame = Cards[TempIndex].frame
  love.graphics.draw(CardSprites.image, CardSprites.quads[frame], 0, 0, 0, 4)
end
