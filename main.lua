require("camera")
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
  levelHeight = 650

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, gravity*pixelPerMeter, true)
  world:setCallbacks(beginContact)

  layers:new()
  while layers[#layers].y < levelHeight do
    layers:new()
  end

  player.load(levelWidth)

  love.graphics.setBackgroundColor(30, 10, 5)
  love.window.setMode(levelWidth, levelHeight)
end

function beginContact(a, b, coll)
  items:collide(a, b, coll)
end

function love.update(dt)
  world:update(dt)
  player.update(dt)
  local updateDir = player.updateLayerIndex(dt)
  if updateDir then
    print("changed current layer to "..player.currentLayerIndex)
    camera:animateLayerChange(player.body, layers[player.currentLayerIndex], updateDir)
    if updateDir == "down" then
      layers:generateMoreLayers(camera.y)
    end
  end
  camera:update(dt)
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
  camera:set()
  layers:draw()
  player.draw()
  camera:unset()
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