layers = {}

layers.types = {
  thinAndImpassible = {
    thickness = 1,
    density = 1.0,
    paths = 1,
    rooms = 0
  },
  default = {
    thickness = "medium",
    density = 0.8,
    paths = 1,
    rooms = 1
  }
}

function layers:new(w, type)
  type = type or layers.types.default
  local h = map.tileSize
  if type.thickness == "medium" then
    h = math.random(2,8)*map.tileSize  
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
  newLayer.r = math.random(130,150)
  newLayer.g = math.random(60,80)
  newLayer.b = math.random(10,25)


  newLayer.body = love.physics.newBody(world, 0, y)
  newLayer.shapes = map.generateLayer(w, h, type)
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


