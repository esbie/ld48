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
    print(row .. " of total: " .. totalRows)
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

    -- assumes there is at least one possibleNextStep
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

function map.generateLayer(width, height, type)
  local tiles = {}
  local totalRows = math.floor(height/20)
  local totalCols = math.floor(width/20)
  local result = {}

  if type.paths > 0 then
    map.generateWalkabout(tiles, totalCols, totalRows)
  end
  if type.rooms > 0 then
    map.generateRoom(tiles, totalCols, totalRows)
  end

  for col=1, totalCols do
    ensureCol(tiles, col)
    for row=1, totalRows do
      if math.random() < type.density and tiles[col][row] ~= empty then
        tiles[col][row] = true
        result[#result+1] = map.generateShape(col, row)
        result[#result+1] = map.generateShape(col, row, totalCols*map.tileSize)
        result[#result+1] = map.generateShape(col, row, -totalCols*map.tileSize)
      end
    end
  end
  return result
end

function map.generateShape(col, row, colOffset, rowOffset)
  colOffset = colOffset or 0
  rowOffset = rowOffset or 0
  return love.physics.newRectangleShape(
    (colOffset + (col-1)*map.tileSize+map.tileSize/2), 
    (rowOffset + (row-1)*map.tileSize), 
    map.tileSize, 
    map.tileSize, 
    0)
end
