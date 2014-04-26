player = {
  h = 10,
  w = 10,
  velocity = 300
}

function player.load(levelWidth)
  player.body = love.physics.newBody(world, levelWidth/4, levelWidth/2, "dynamic")
  player.shape = love.physics.newRectangleShape(player.h, player.w)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.fixture:setRestitution(0.1) --bounce
end

function player.update(dt)
  x, y = player.body:getLinearVelocity()

  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    player.body:setLinearVelocity(player.velocity, y)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    player.body:setLinearVelocity(-player.velocity, y)
  end
end

function player.keypressed(key)
  x, y = player.body:getLinearVelocity()
  if key == "up" and (y > -20 and y < 20) then
    player.body:setLinearVelocity(x, -player.velocity)
  end
end

function player.keyreleased(key)
  x, y = player.body:getLinearVelocity()
  if key == "right" then --press the right arrow key to push the ball to the right
    player.body:setLinearVelocity(x/2, y)
  elseif key == "left" then --press the left arrow key to push the ball to the left
    player.body:setLinearVelocity(x/2, y)
  end
end

function player.draw()
  love.graphics.setColor(47, 47, 14) --set the drawing color to red for the ball
  fillPhysicsRectangle(player)
end

