require("player")
require("layers")

function love.load()
  pixelPerMeter = 64
  gravity = 9.81
  levelWidth = 650

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, gravity*pixelPerMeter, true)
  ground = layers:new(levelWidth-100, levelWidth, 100)
  otherGround = layers:new(levelWidth-200, levelWidth, 100)

  player.load(levelWidth)

  love.graphics.setBackgroundColor(200, 200, 248) --set the background color to a nice blue
  love.window.setMode(levelWidth, levelWidth) --set the window dimensions to 650 by 650
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
  player.update(dt)
  

  if love.mouse.isDown("l") then
    layers:moveSelectedLayer(prevMouseX)
    prevMouseX = love.mouse.getX()
  end
end

function love.keypressed(key)
  player.keypressed(key)
end

function love.keyreleased(key)
  if key == "escape" then
    love.event.quit()
  end
  player.keyreleased(key)
end

function love.mousepressed(x, y, button)
  prevMouseX = x
  layers:selectLayer(x, y)
end

function love.mousereleased(x, y, button)
  layers:deselectLayer()
end

function love.draw()
  layers:draw()
  player.draw()
end

function fillPhysicsRectangle(object)
  love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end