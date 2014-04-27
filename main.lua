require("player")
require("map")
require("prisons")
require("items")
require("layers")

function love.load()
  -- http://love2d.org/forums/viewtopic.php?t=76014&p=156747
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
  pixelPerMeter = 64
  gravity = 9.81
  levelWidth = 650

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, gravity*pixelPerMeter, true)
  world:setCallbacks(beginContact)

  for i=1, 5 do
    layers:new(levelWidth)
  end

  player.load(levelWidth)

  love.graphics.setBackgroundColor(30, 10, 5) --set the background color to a nice blue
  love.window.setMode(levelWidth, levelWidth) --set the window dimensions to 650 by 650
end

function beginContact(a, b, coll)
  items:collide(a, b, coll)
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
  player.update(dt)
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
end

function love.mousereleased(x, y, button)
end

function love.draw()
  layers:draw()
  player.draw()
end

function fillPhysicsRectangle(object)
  love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function linePhysicsRectangle(object)
  love.graphics.polygon("line", object.body:getWorldPoints(object.shape:getPoints()))
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end