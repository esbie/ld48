layers = {}

function layers:new(w)
  local tileSize = 50
  local h = math.random(1,5)*tileSize

  local newLayer = {
    h = h,
    w = w
  }
  newLayer.r = math.random(130,150)
  newLayer.g = math.random(60,80)
  newLayer.b = math.random(10,25)

  local y = 300 -- default starting layer y position

  if #layers ~= 0 then
    local lastLayer = layers[#layers]
    y = lastLayer.body:getY() + lastLayer.h -- + h/2 + lastLayer.h/2
  end


  newLayer.body = love.physics.newBody(world, 0, y) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  newLayer.shape = love.physics.newRectangleShape(w/2, h/2, w, h, 0) --make a rectangle with a width of 650 and a height of 50
  newLayer.fixture = love.physics.newFixture(newLayer.body, newLayer.shape) --attach shape to body
  layers[#layers+1] = newLayer
  return newLayer
end

function layers:moveSelectedLayer(oldX)
  local sl = layers.selectedLayer
  if sl == nil then return end
  dX = love.mouse.getX() - oldX
  sl.body:setX(sl.body:getX() + dX)
end

function layers:selectLayer(x,y)
  for i, layer in ipairs(layers) do
    if layer.fixture:testPoint(x, y) then
      print("layer selected: " .. i)
      layers.selectedLayer = layer
      return layer
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
  love.graphics.setColor(layer.r, layer.g, layer.b)
  fillPhysicsRectangle(layer)
  love.graphics.setColor(10, 10, 10)
  linePhysicsRectangle(layer)
end