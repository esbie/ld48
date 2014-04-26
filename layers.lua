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
  newLayer.shapes = { 
    love.physics.newRectangleShape(w/4, h/2, w/2, h, 0),
    love.physics.newRectangleShape(w*3/4+tileSize, h/2, w/2-tileSize, h, 0)
  }
  newLayer.fixtures = { 
    love.physics.newFixture(newLayer.body, newLayer.shapes[1]),
    love.physics.newFixture(newLayer.body, newLayer.shapes[2])
  }
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