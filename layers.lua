layers = {}

function layers:new(x, y, w, h)
  local newLayer = {
    h = h,
    w = w
  }
  newLayer.body = love.physics.newBody(world, x, y) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  newLayer.shape = love.physics.newRectangleShape(newLayer.w, newLayer.h) --make a rectangle with a width of 650 and a height of 50
  newLayer.fixture = love.physics.newFixture(newLayer.body, newLayer.shape) --attach shape to body
  layers[#layers+1] = newLayer
  return newLayer
end

function layers:moveSelectedLayer(oldX)
  if layers.selectedLayer == nil then return end
  dX = love.mouse.getX() - oldX
  layers.selectedLayer.body:setX(ground.body:getX() + dX)
end

function layers:selectLayer(x,y)
  for i, layer in ipairs(layers) do
    if layer.fixture:testPoint(x, y) then
      layers.selectedLayer = layer
      return layer
    end
  end

  return false
end

function layers:deselectLayer()
  layers.selectedLayer = nil
end