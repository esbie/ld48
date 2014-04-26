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
  local totalRows = height/20
  local totalCols = width/20
  local result = {}

  if type.paths > 0 then
    map.generatePath(tiles, totalCols, totalRows)
  end
  if type.rooms > 0 then
    map.generateRoom(tiles, totalCols, totalRows)
  end

  for col=1, totalCols do
    ensureCol(tiles, col)
    for row=1, totalRows do
      if math.random() < type.density and tiles[col][row] ~= empty then
        tiles[col][row] = true
        result[#result+1] = love.physics.newRectangleShape(((col-1)*map.tileSize+map.tileSize/2), ((row-1)*map.tileSize), map.tileSize, map.tileSize, 0)
      end
    end
  end
  return result
end
