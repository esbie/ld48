prisons = {}

function prisons:new(body, x, y)
  local newPrison = {}
  newPrison.body = love.physics.newBody(world, body:getX() + x, body:getY() + y)
  newPrison.shape = love.physics.newRectangleShape(10, 10)
  newPrison.fixture = love.physics.newFixture(newPrison.body, newPrison.shape, 1)
  newPrison.fixture:setCategory(4)
  return newPrison
end

function prisons:draw(prison)
  love.graphics.setColor(250, 250, 250)
  fillPhysicsRectangle(prison)
end

function prisons:collide(a, b, coll)
  if a:getCategory() == 3 then
    a:setUserData("removed")
  end
end