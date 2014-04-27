player = {
  h = 10,
  w = 10,
  velocity = 200
}

function player.load(levelWidth)
  player.body = love.physics.newBody(world, levelWidth*3/4, 0, "dynamic")
  player.shape = love.physics.newRectangleShape(player.h, player.w)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.currentLayerIndex = 0
  player.fixture:setRestitution(0.1)
end

function player.currLayerUpdate( dt )
  local x, y = player.body:getPosition()
  local i = player.currentLayerIndex
  if i == 0 and layers:containsBody(layers[1], player.body) then 
    player.currentLayerIndex = 1
  elseif i > 0 and i < #layers+1 then
    local currLayer = layers[i]
    
    if  not layers:containsBody(currLayer, player.body) then
      if y < currLayer.y and i ~= 1 then
        player.currentLayerIndex = i - 1
        currLayer = layers[i-1]
        if y - camera.y < levelHeight/4 or (y - camera.y < levelHeight/2 and currLayer.h > levelHeight/4) then
          print(y+camera.y)
          camera:animate(-currLayer.h)
        end
      else
        player.currentLayerIndex = i + 1
        currLayer = layers[i+1]
        if y - camera.y > levelHeight*3/4 or (y - camera.y > levelHeight/2 and currLayer.h > levelHeight/4) then
          print(y+camera.y)
          camera:animate(currLayer.h)
        end
      end
      print("changed current layer to "..player.currentLayerIndex)
    end

    if love.keyboard.isDown("q") then
      layers:moveLayerLeft(currLayer)
    elseif love.keyboard.isDown("e") then
      layers:moveLayerRight(currLayer)
    end
  end
end

function player.update(dt)
  local x, y = player.body:getLinearVelocity()

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    player.body:setLinearVelocity(player.velocity, y)
  elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    player.body:setLinearVelocity(-player.velocity, y)
  end

  player.currLayerUpdate(dt)
end

function player.keypressed(key)
  player.body:setSleepingAllowed(false)
  x, y = player.body:getLinearVelocity()
  if (key == "up" or key == " " or key == "w") and (y > -20 and y < 20) then
    player.body:setLinearVelocity(x, -(player.velocity+100))
  end
end

function player.keyreleased(key)
  player.body:setSleepingAllowed(true)
  x, y = player.body:getLinearVelocity()
  if key == "right" or key == "d" then
    player.body:setLinearVelocity(x/3, y)
  elseif key == "left" or key == "a" then
    player.body:setLinearVelocity(x/3, y)
  end
end

function player.draw()
  love.graphics.setColor(100, 100, 100)
  fillPhysicsRectangle(player)
end

