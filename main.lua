
function love.load()
  -- pumpkin = love.graphics.newImage("assets/pumpkin.png")
  -- love.graphics.setNewFont(12)
  -- love.graphics.setColor(0,0,0)
  -- love.graphics.setBackgroundColor(255,255,255)
  -- if (love.graphics.isSupported("canvas")) then
  --   print("supports canvas!")
  -- else
  --   print("does not support canvas")
  -- end

  -- constants
  pixelPerMeter = 64
  gravity = 9.81
  levelWidth = 650
  groundHeight = 50
  playerHeight = 10

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, gravity*pixelPerMeter, true)


  ground = {}
  ground.body = love.physics.newBody(world, levelWidth/2, levelWidth-groundHeight/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  ground.shape = love.physics.newRectangleShape(levelWidth, groundHeight) --make a rectangle with a width of 650 and a height of 50
  ground.fixture = love.physics.newFixture(ground.body, ground.shape); --attach shape to body

  player = {}
  player.body = love.physics.newBody(world, levelWidth/2, levelWidth/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  player.shape = love.physics.newRectangleShape(playerHeight, playerHeight) --the ball's shape has a radius of 20
  player.fixture = love.physics.newFixture(player.body, player.shape, 1) -- Attach fixture to body and give it a density of 1.
  player.fixture:setRestitution(0.1) --let the ball bounce

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
  -- elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    -- player.body:setLinearVelocity(x, -velocity)
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
    -- love.graphics.print("Hello World", 400, 300)
    -- love.graphics.draw(pumpkin, 100, 100)

  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates


  love.graphics.setColor(47, 47, 14) --set the drawing color to red for the ball
  love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end