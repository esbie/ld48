prisons = {}

function prisons:new(body, x, y)
  local newPrison = {}
  newPrison.body = love.physics.newBody(world, body:getX() + x + 40, body:getY() + y + 20)
  newPrison.shape = love.physics.newRectangleShape(80, 60)
  newPrison.fixture = love.physics.newFixture(newPrison.body, newPrison.shape, 1)
  newPrison.fixture:setCategory(4)
  return newPrison
end

function prisons:draw(prison)
  love.graphics.setColor(250, 250, 250)
  linePhysicsRectangle(prison)
end
