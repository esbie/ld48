layers = {}

layers.types = {
  {
    thickness = 2,
    density = 1.0,
    paths = 4,
    rooms = 0,
    itemDensity = 0.1
  },
  {
    thickness = "medium",
    density = 0.8,
    paths = 4,
    rooms = 2,
    itemDensity = 0.07
  },
  {
    thickness = "large",
    density = 0.8,
    paths = 15,
    rooms = 0,
    itemDensity = 0.01
  }
}

local addColor = function(newLayer)
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
end

function layers:new(type)
  local w = levelWidth*2
  type = type or layers.types[math.random(1,3)]
  local h = map.tileSize
  if type.thickness == "medium" then
    h = math.random(4,6)*map.tileSize  
  elseif type.thickness == "large" then
    h = math.random(10,12)*map.tileSize  
  else
    h = type.thickness*map.tileSize
  end
  
  local y = 100 -- default starting layer y position

  if #layers ~= 0 then
    local lastLayer = layers[#layers]
    y = lastLayer.body:getY() + lastLayer.h
  end

  local newLayer = {
    y = y,
    h = h,
    w = w
  }

  addColor(newLayer)

  newLayer.body = love.physics.newBody(world, 0, y)
  newLayer.tiles = map.generateTiles(w, h, type)
  newLayer.prisons = {}
  -- if h > 80 then
  --   table.insert(newLayer.prisons, map.generatePrison(newLayer.body, newLayer.tiles))
  -- end

  newLayer.shapes = map.generateShapes(newLayer.tiles)
  newLayer.shapes = map.generateShapes(newLayer.tiles, newLayer.shapes, 1)
  newLayer.shapes = map.generateShapes(newLayer.tiles, newLayer.shapes, -1)
  newLayer.items = map.generateItems(newLayer, newLayer.tiles, type.itemDensity)
  map.generateAdditionalItems(newLayer.tiles, newLayer.items, 1)
  map.generateAdditionalItems(newLayer.tiles, newLayer.items, -1)

  local fixtures = {}

  for i, shape in pairs(newLayer.shapes) do
    fixtures[#fixtures+1] = love.physics.newFixture(newLayer.body, shape)
  end

  newLayer.fixtures = fixtures

  layers[#layers+1] = newLayer
  return newLayer
end

local levelBottom = function(lastLayer, yOffset)
  return lastLayer.h + lastLayer.y - yOffset
end

function layers:generateMoreLayers(yOffset)
  local lastLayer = layers[#layers]
  local buffer = 200

  while levelBottom(lastLayer, yOffset) < levelHeight + buffer do
    print("adding a new layer!")
    lastLayer = layers:new()
  end
end

function layers:moveLayerLeft(sl)
  layers:moveLayer(sl, -5)
end

function layers:moveLayerRight(sl)
  layers:moveLayer(sl, 5)
end

function layers:moveLayer(sl, dX)
  if sl == nil then return end
  sl.body:setX(sl.body:getX() + dX)

  player.body:setLinearVelocity(0,0)
  player.body:setX(player.body:getX() + dX)

  for i, item in ipairs(sl.items) do
    item.body:setX(item.body:getX() + dX)
  end

  for i, prison in ipairs(sl.prisons) do
    prison.body:setX(prison.body:getX() + dX)
  end
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
  end

  local toRemove = {}
  for i, item in ipairs(layer.items) do
    if item.body:getUserData() == "removed" then
      table.insert(toRemove, i)
      item.body:setUserData("destroyed")
    elseif item.body:getUserData() == "destroyed" then
      break;
    else
      items:draw(item)
    end
  end

  for i, item in ipairs(toRemove) do
    layer.items[item].body:destroy()
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


