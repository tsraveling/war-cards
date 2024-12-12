Cards = {}

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") -- Do clear pixel art
  Sheets = require("lib.Sheets")
  Cards = Sheets.make("art/cards.png", 48, 64)

  -- next:
  -- that sheet is 15 wide A, 1-10, J-K, hearts diamonds spades jokers
  -- which means the backs are 61-69 (nice)
  -- go through and programatically assemble our base deck, then make two of them
  -- for the two players
end

function love.draw()
  love.graphics.print("Hello world", 400, 300)
  love.graphics.draw(Cards.image, Cards.quads[1], 0, 0, 0, 4)
end
