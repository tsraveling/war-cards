-- This file creates spritesheets

local Sheets = {}

function Sheets.make(image, cellWidth, cellHeight)
  local sheet = {}

  sheet.image = love.graphics.newImage(image)
  sheet.quads = {}

  local numX = sheet.image:getWidth() / cellWidth
  local numY = sheet.image:getHeight() / cellHeight

  for y = 1, numY do
    for x = 1, numX do
      table.insert(sheet.quads,
        love.graphics.newQuad((x - 1) * cellWidth, (y - 1) * cellHeight,
          cellWidth,
          cellHeight,
          sheet.image:getDimensions()))
    end
  end

  return sheet
end

return Sheets
