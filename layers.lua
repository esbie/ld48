layers = {}

function layers:mapMaker(width, height)
  local tiles = {}
  local tileSize = 20
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
        result[#result+1] = love.physics.newRectangleShape(((col-1)*tileSize+tileSize/2), ((row-1)*tileSize), tileSize, tileSize, 0)
      end
    end
  end
  return result
end

function layers:new(w)
  local tileSize = 20
  local h = math.random(2,8)*tileSize
  local y = 300 -- default starting layer y position

  if #layers ~= 0 then
    local lastLayer = layers[#layers]
    y = lastLayer.body:getY() + lastLayer.h
  end

  local newLayer = {
    y = y,
    h = h,
    w = w
  }
  newLayer.r = math.random(130,150)
  newLayer.g = math.random(60,80)
  newLayer.b = math.random(10,25)


  newLayer.body = love.physics.newBody(world, 0, y)
  newLayer.shapes = layers:mapMaker(w, h)
  local fixtures = {}

  for i, shape in pairs(newLayer.shapes) do
    fixtures[#fixtures+1] = love.physics.newFixture(newLayer.body, shape)
  end

  newLayer.fixtures = fixtures

  layers[#layers+1] = newLayer
  return newLayer
end

function layers:moveSelectedLayer(oldX)
  local sl = layers.selectedLayer
  if sl == nil then return end
  dX = love.mouse.getX() - oldX
  sl.body:setX(sl.body:getX() + dX)

  if layers:containsBody(sl, player.body) then
    player.body:setLinearVelocity(0,0)
    player.body:setX(player.body:getX() + dX)
  end
end

function layers:selectLayer(x,y)
  for i, layer in ipairs(layers) do
    for j, fixture in ipairs(layer.fixtures) do
      if fixture:testPoint(x, y) then
        print("layer selected: " .. i)
        layers.selectedLayer = layer
        return layer
      end
    end
  end

  return false
end

function layers:deselectLayer()
  layers.selectedLayer = nil
  print("layer unselected")
end

function layers:draw()
  for i, layer in ipairs(layers) do
    layers:drawLayer(layer)
  end
end

function layers:drawLayer(layer)
  for i, shape in ipairs(layer.shapes) do
    love.graphics.setColor(layer.r, layer.g, layer.b)
    love.graphics.polygon("fill", layer.body:getWorldPoints(shape:getPoints()))
    love.graphics.setColor(10, 10, 10)
    love.graphics.polygon("line", layer.body:getWorldPoints(shape:getPoints()))
  end
end

function layers:containsBody(layer, body)
  local y = body:getY()
  return layer ~= nil and y < (layer.y + layer.h) and y > layer.y
end


