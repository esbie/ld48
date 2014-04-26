layers = {}

function layers:new(x, y, w, h)
  local newLayer = {
    h = h,
    w = w
  }
  newLayer.body = love.physics.newBody(world, x, y) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  newLayer.shape = love.physics.newRectangleShape(newLayer.w, newLayer.h) --make a rectangle with a width of 650 and a height of 50
  newLayer.fixture = love.physics.newFixture(newLayer.body, newLayer.shape) --attach shape to body
  table.insert(newLayer, layers)
  return newLayer
end
