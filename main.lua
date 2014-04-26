
function love.load()
  pixelPerMeter = 64
  gravity = 9.81
  levelWidth = 650

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, gravity*pixelPerMeter, true)

  ground = {
    h = 50,
    w = levelWidth
  }
  ground.body = love.physics.newBody(world, levelWidth/2, levelWidth-ground.h/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  ground.shape = love.physics.newRectangleShape(ground.w, ground.h) --make a rectangle with a width of 650 and a height of 50
  ground.fixture = love.physics.newFixture(ground.body, ground.shape); --attach shape to body

  player = {
    h = 10,
    w = 10
  }
  player.body = love.physics.newBody(world, levelWidth/2, levelWidth/2, "dynamic")
  player.shape = love.physics.newRectangleShape(player.h, player.w)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.fixture:setRestitution(0.1) --bounce

  love.graphics.setBackgroundColor(200, 200, 248) --set the background color to a nice blue
  love.window.setMode(levelWidth, levelWidth) --set the window dimensions to 650 by 650
end

function love.update(dt)
  world:update(dt) --this puts the world into motion

  x, y = player.body:getLinearVelocity()
  velocity = 300

  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    player.body:setLinearVelocity(velocity, y)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    player.body:setLinearVelocity(-velocity, y)
  end
end

function love.keypressed(key)
  x, y = player.body:getLinearVelocity()
  if key == "up" and (y > -10 and y < 10) then
    player.body:setLinearVelocity(x, -velocity)
  end
end

function love.keyreleased(key)
    
  if key == "escape" then
    love.event.quit()
  end

  x, y = player.body:getLinearVelocity()
  if key == "right" then --press the right arrow key to push the ball to the right
    player.body:setLinearVelocity(x/2, y)
  elseif key == "left" then --press the left arrow key to push the ball to the left
    player.body:setLinearVelocity(x/2, y)
  end
end

function love.draw()
  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  fillPhysicsRectangle(ground)

  love.graphics.setColor(47, 47, 14) --set the drawing color to red for the ball
  fillPhysicsRectangle(player)
end

function fillPhysicsRectangle(object)
  love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end