map = {
  tileSize = 20
}

function map.generateLayer(width, height)
  local tiles = {}
  local totalRows = height/20
  local totalCols = width/20
  local result = {}
  local empty = "empty"

  --make at least one pathway
  local col = math.random(1, totalCols)
  local row = 1
  while row <= totalRows do
    if tiles[col] == nil then
      tiles[col] = {}
    end
    tiles[col][row] = empty
    row = row + 1
  end

  --make at least one "room"
  local roomColSize = totalCols/4
  local roomRowSize = totalRows/2
  
  for col = math.random(1, totalCols/2), col+roomColSize do
    if tiles[col] == nil then
      tiles[col] = {}
    end
    for row = math.random(1, totalRows/2), row+roomRowSize do
      tiles[col][row] = empty
    end
  end


  for col=1, totalCols do
    if tiles[col] == nil then
      tiles[col] = {}
    end
    for row=1, totalRows do
      if math.random() < 0.7 and tiles[col][row] ~= empty then
        tiles[col][row] = true
        result[#result+1] = love.physics.newRectangleShape(((col-1)*map.tileSize+map.tileSize/2), ((row-1)*map.tileSize), map.tileSize, map.tileSize, 0)
      end
    end
  end
  return result
end
