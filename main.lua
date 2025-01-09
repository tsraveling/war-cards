CardSprites = {}
Cards = {}
Duration = 0.2

YourDeck = {}
EnemyDeck = {}

CurrentRound = 0
Status = "" -- This will be displayed in the center
Score = 0   -- negative if your enemy is winning, positive if you are winning
-- you lose if the score is greater than the remaining rounds

-- 1: Face down
-- 2: Revealed
-- 3: Game Over
Phase = 1

-- Check to see if anybody won
function CheckForWin()
  if Score > 52 - CurrentRound then -- If you are up by 5, and there are only 4 cards left in each hand, you will win for sure.
    Status = "You won -- score higher than cards left! (Space to restart)"
    Phase = 3
  elseif -Score > 52 - CurrentRound then -- if we flip the sign on score and that is more than remaining cards, that means we lost
    Status = "You LOSE! Score lower than cards left. (Space to restart)"
    Phase = 3
  elseif CurrentRound >= 52 and Score == 0 then -- if the score is even and we are out of cards, it's a draw
    Status = "It's a draw. Space to restart."
    Phase = 3
  end
end

-- This moves to the next round
function NextRound()
  -- Check to see if anybody won
  CheckForWin()
  if Phase == 3 then -- If they did, stop the roll
    return
  end

  -- Otherwise proceed as normal
  Phase = 1
  CurrentRound = CurrentRound + 1
  Status = "Spacebar to reveal!"
end

-- Increment score in my favor
function WinMe()
  Score = Score + 1
end

-- Increment score in enemy favor
function WinEnemy()
  Score = Score - 1
end

-- Return true if I win, false if enemy does. This method
-- only gets called if face value matches
-- Note: It would be much easier to just do an index comparison on an authoritative value array,
-- but that's a little trickier in Lua so I'm just being explicit here instead.
function ContestSuit(mySuit, enemySuit)
  if mySuit == "spades" then        -- If I have spades, I win, bc spades are the best
    return true
  elseif enemySuit == "spades" then -- If enemy has spades, they win tho
    return false
  elseif mySuit == "hearts" then    -- hearts is second highest
    return true
  elseif enemySuit == "hearts" then
    return false
  elseif mySuit == "clubs" then -- clubs is third highest
    return true
  else
    return false -- if you don't have spades, hearts, or clubs, you have diamonds, and YOU LOSE
  end
end

-- This does the actual scoring logic
function ShowCard()
  Phase = 2
  local myCard = Cards[YourDeck[CurrentRound]]
  local enemyCard = Cards[EnemyDeck[CurrentRound]]

  if myCard.value > enemyCard.value then
    WinMe()
    Status = "You win on face value!"
  elseif myCard.value < enemyCard.value then
    WinEnemy()
    Status = "Enemy wins on face value :("
  else
    local suitContest = ContestSuit(myCard.suit, enemyCard.suit)
    if suitContest then
      WinMe()
      Status = "You win! (" .. myCard.suit .. " beats " .. enemyCard.suit .. ")"
    else
      WinEnemy()
      Status = "You lose :( (" .. enemyCard.suit .. " beats " .. myCard.suit .. ")"
    end
  end
end

function RestartGame()
  -- shuffle the deck using our custom deck library
  YourDeck = Deck.make()
  Deck.shuffle(YourDeck, 1)

  -- do the same for the enemy
  EnemyDeck = Deck.make()
  Deck.shuffle(EnemyDeck, 2)

  CurrentRound = 0
  Status = ""
  Score = 0
  Phase = 1

  -- Kick us off
  NextRound()
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") -- Do clear pixel art
  Sheets = require("lib.Sheets")
  Deck = require("lib.Deck")
  CardSprites = Sheets.make("art/cards.png", 48, 64)
  Cards = require("game_data.Cards")

  RestartGame()
end

function love.update(dt)
  -- This game doesn't really have any real-time elements, so we are gonna leave this blank.
end

function love.keypressed(key)
  if key == "space" then
    if Phase == 1 then
      ShowCard()
    elseif Phase == 2 then
      NextRound()
    else
      RestartGame()
    end
  end
end

function love.draw()
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  local scale = 3
  local cardWidth = 48 * scale -- we know this from the sprites, then multiply by card scale
  local cardHeight = 64 * scale

  local statusWidth = 300

  -- Print the current round
  local scoreScale = 1.2
  love.graphics.print("Round " .. tostring(CurrentRound) .. " / 52. Remaining: " .. tostring(52 - CurrentRound), 20, 20,
    0, scoreScale, scoreScale)
  love.graphics.print("Score: " .. tostring(Score), 20, 40, 0, scoreScale, scoreScale)

  -- The last three arguments here are rotation and scale. I'm doubling the scale of the label, which means I
  -- need to double the "base" width  of the status label (ie, 300, above). Otherwise I would have subtracted only
  -- half of the statusWidth (statusWidth / 2) in order to center the element. This scale approach is kinda janky,
  -- so in a future game I would use Love's font system to make accurately-scaled fonts: https://www.love2d.org/wiki/Font
  love.graphics.printf(Status, (screenWidth / 2) - (statusWidth), screenHeight / 2, statusWidth, "center", 0,
    2, 2)

  -- Get the current card
  local topFrame = Phase == 1 and 61 or Cards[EnemyDeck[CurrentRound]].frame
  local bottomFrame = Phase == 1 and 61 or Cards[YourDeck[CurrentRound]].frame

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
