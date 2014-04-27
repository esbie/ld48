items = {}

function items:new(layer, x, y)
  local newItem = {}
  newItem.body = love.physics.newBody(world, layer.body:getX() + x, layer.body:getY() + y)
  newItem.shape = love.physics.newRectangleShape(10, 10)
  newItem.fixture = love.physics.newFixture(newItem.body, newItem.shape, 1)
  newItem.fixture:setCategory(3)
  return newItem
end

function items:draw(item)
  love.graphics.setColor(255, 255, 14)
  fillPhysicsRectangle(item)
end

function items:collide(a, b, coll)
  if a:getCategory() == 3 then
    a:setUserData("removed")
  end
end