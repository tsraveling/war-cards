-- This file creates returns a single table that can create spritesheets
-- that can then be used for drawing.

local Sheets = {}

-- imageFilename: the filename of the image containing the spritesheet.
-- cellWidth: the width of each cell in pixels.
-- cellHeight: the height of each cell in pixels.
function Sheets.make(imageFilename, cellWidth, cellHeight)

  -- Start with a blank object that will eventually contain our image and quads.
  local sheet = {}

  -- Load the image using the love.graphics library. This will give us a Love image object.
  sheet.image = love.graphics.newImage(imageFilename)

  -- Set up the blank array of quads that we will add to as we iterate over the spritesheet.
  sheet.quads = {}

  -- Divide the image size by the cell size to get the total number of cells horizontally and
  -- vertically.
  local numX = sheet.image:getWidth() / cellWidth
  local numY = sheet.image:getHeight() / cellHeight

  -- Now iterate in a grid over the sheet, moving horizontally ...
  for y = 1, numY do

    -- then vertically.
    for x = 1, numX do

      -- For each x,y coordinate, aka each cell in the sprite sheet, insert a new Quad
      -- using the love.graphics.newQuad method. this spritesheets
      table.insert(sheet.quads,
        love.graphics.newQuad(
          (x - 1) * cellWidth, (y - 1) * cellHeight, -- x,y are the upper left hand corner of the cell
          cellWidth,                                 -- use the cell size as is
          cellHeight,
          sheet.image:getDimensions()))              -- finally provide the quad with the size of
                                                     -- the base spreadsheet image.
    end
  end

  -- Finally, return the spritesheet we've assembled.
  return sheet
end

return Sheets
