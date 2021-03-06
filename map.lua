map = {
  tileSize = 20
}

local ensureCol = function(tiles, col)
  if tiles[col] == nil then
    tiles[col] = {}
  end
end

local empty = "empty"

function map.generatePath(tiles, totalCols, totalRows)
  local col = math.random(1, totalCols)
  local row = 1
  while row <= totalRows do
    ensureCol(tiles, col)
    tiles[col][row] = empty
    row = row + 1
  end
end

function map.generateWalkabout(tiles, totalCols, totalRows)
  local col = math.random(1, totalCols)
  local row = 1

  while row <= totalRows do
    ensureCol(tiles, col)
    tiles[col][row] = empty

    local possibleNextSteps = {}
    if row <= totalRows and tiles[col][row+1] ~= empty then
      table.insert(possibleNextSteps, "down")
    end
    -- if row > 1 and tiles[col][row-1] ~= empty then
    --   table.insert(possibleNextSteps, "up")
    -- end
    if col > 1 and (tiles[col-1] == nil or tiles[col-1][row] ~= empty) then
      table.insert(possibleNextSteps, "left")
    end
    if col <= totalCols and (tiles[col+1] == nil or tiles[col+1][row] ~= empty) then
      table.insert(possibleNextSteps, "right")
    end

    if #possibleNextSteps == 0 then
      return
    end

    local nextStep = math.random(1, #possibleNextSteps)

    if possibleNextSteps[nextStep] == "up" then
      row = row - 1
    elseif possibleNextSteps[nextStep] == "down" then
      row = row + 1
    elseif possibleNextSteps[nextStep] == "left" then
      col = col - 1
    elseif possibleNextSteps[nextStep] == "right" then
      col = col + 1
    end
  end
end

function map.generateRoom(tiles, totalCols, totalRows)
  local roomColSize = totalCols/4
  local roomRowSize = totalRows/2
  
  local col = math.random(1, totalCols/2)
  local row = math.random(1, totalRows/2)

  for col = col, col+roomColSize do
    ensureCol(tiles, col)
    for row = row, row+roomRowSize do
      tiles[col][row] = empty
    end
  end
end

--needs to happen before generating shapes
function map.generatePrison(parentBody, tiles)
  local roomColSize = 4
  local roomRowSize = 3

  local totalRows = tiles.totalRows
  local totalCols = tiles.totalCols
  
  local col = math.random(1, totalCols-roomColSize)
  local row = math.random(1, totalRows-roomRowSize)

  local prison = prisons:new(parentBody, (col-1)*map.tileSize, (row-1)*map.tileSize)

  for col = col, col+roomColSize+1 do
    ensureCol(tiles, col)
    for row = row, row+roomRowSize do
      tiles[col][row] = empty
    end
  end

  return prison
end

function map.generateTiles(width, height, type)
  local tiles = {}
  local totalRows = math.floor(height/20)
  local totalCols = math.floor(width/20)
  tiles.totalRows = totalRows
  tiles.totalCols = totalCols

  for paths=1, type.paths do
    map.generateWalkabout(tiles, totalCols, totalRows)
  end
  for rooms=1, type.rooms do
    map.generateRoom(tiles, totalCols, totalRows)
  end

  for col=1, totalCols do
    ensureCol(tiles, col)
    for row=1, totalRows do
      if math.random() < type.density and tiles[col][row] ~= empty then
        tiles[col][row] = true
      end
    end
  end
  return tiles
end

local createShape = function(col, row, colOffset, rowOffset)
  colOffset = colOffset or 0
  rowOffset = rowOffset or 0
  return love.physics.newRectangleShape(
    (colOffset + (col-1)*map.tileSize+map.tileSize/2), 
    (rowOffset + (row-1)*map.tileSize), 
    map.tileSize, 
    map.tileSize, 
    0)
end

function map.generateShapes(tiles, result, integerOffset)
  local totalCols = tiles.totalCols
  local totalRows = tiles.totalRows
  integerOffset = integerOffset or 0
  result = result or {}
  for col=1, totalCols do
    for row=1, totalRows do
      if tiles[col][row] == true then
        result[#result+1] = createShape(col, row, integerOffset*totalCols*map.tileSize)
      end
    end
  end
  return result
end

function map.generateBackgroundShapes(tiles)
  local totalCols = tiles.totalCols
  local totalRows = tiles.totalRows
  local result = {}
  for col=1, totalCols do
    for row=1, totalRows do
      if tiles[col][row] == true then
        result[#result+1] = love.physics.newRectangleShape(
          ((totalCols - (col-1))*map.tileSize-map.tileSize/2), 
          ((row-1)*map.tileSize), 
          map.tileSize, 
          map.tileSize, 
          0)
      end
    end
  end
  return result
end

function map.generateItems(layer, tiles, percentage)
  percentage = percentage or 0.1
  local result = {}
  local totalCols = tiles.totalCols
  local totalRows = tiles.totalRows
  for col=1, totalCols do
    for row=1, totalRows do
      if tiles[col][row] ~= true and tiles[col][row+1] == true and math.random() < percentage then
        result[#result+1] = items:new(layer, (col-1)*map.tileSize+map.tileSize/2, (row-1)*map.tileSize)
      end
    end
  end
  return result
end

function map.generateAdditionalItems(tiles, result, integerOffset)
  for i, item in ipairs(result) do
    items:addShapeAtOffset(item, integerOffset*tiles.totalCols*map.tileSize)
  end
end
