layers = {}

layers.types = {
  {
    thickness = 1,
    density = 1.0,
    paths = 1,
    rooms = 0
  },
  {
    thickness = "medium",
    density = 0.8,
    paths = 2,
    rooms = 1
  },
  {
    thickness = "large",
    density = 0.8,
    paths = 10,
    rooms = 0
  }
}

function layers:new(w, type)
  type = type or layers.types[math.random(1,3)]
  local h = map.tileSize
  if type.thickness == "medium" then
    h = math.random(4,6)*map.tileSize  
  elseif type.thickness == "large" then
    h = math.random(10,12)*map.tileSize  
  else
    h = type.thickness*map.tileSize
  end
  
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

  local color = math.random(1,3)
  if color == 1 then
    newLayer.r = math.random(130,150)
    newLayer.g = math.random(60,80)
    newLayer.b = math.random(10,25)
  elseif color == 2 then
    newLayer.r = math.random(220,150)
    newLayer.g = math.random(40,60)
    newLayer.b = math.random(0,15)
  else
    newLayer.r = math.random(200,255)
    newLayer.g = math.random(200,255)
    newLayer.b = math.random(200,255)
  end


  newLayer.body = love.physics.newBody(world, 0, y)
  newLayer.tiles = map.generateTiles(w, h, type)
  newLayer.prisons = {}
  if h > 80 then
    table.insert(newLayer.prisons, map.generatePrison(newLayer.body, newLayer.tiles))
  end

  newLayer.shapes = map.generateShapes(newLayer.tiles)
  newLayer.items = map.generateItems(newLayer, newLayer.tiles)

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

  for i, item in ipairs(sl.items) do
    item.body:setX(item.body:getX() + dX)
  end

  for i, prison in ipairs(sl.prisons) do
    prison.body:setX(prison.body:getX() + dX)
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

  local toRemove = {}
  for i, item in ipairs(layer.items) do
    if item.fixture:getUserData() == "removed" then
      table.insert(toRemove, i)
      item.fixture:setUserData("destroyed")
    elseif item.fixture:getUserData() == "destroyed" then
      break;
    else
      items:draw(item)
    end
  end

  for i, item in ipairs(toRemove) do
    layer.items[item].fixture:destroy()
    table.remove(layer.items, item)
  end  

  for i, prison in ipairs(layer.prisons) do
    prisons:draw(prison)
  end
end

function layers:containsBody(layer, body)
  local y = body:getY()
  return layer ~= nil and y < (layer.y + layer.h) and y > layer.y
end


