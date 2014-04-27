camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.speed = 10

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:update(dt)
  if self.currentAnimation then
    dy = self.speed * self.currentAnimation.dir
    self.y = self.y + dy
    self.currentAnimation.traveled = self.currentAnimation.traveled + self.speed
    if self.currentAnimation.traveled >= self.currentAnimation.total then
      self.currentAnimation = nil
    end
  end
end

function camera:animate(dy, dir)
  self.currentAnimation = {
    total = dy,
    traveled = 0,
    dir = dir
  }
end

local isNearTopOfScreen = function (y)
  return y - camera.y < levelHeight/4
end

local isNearBottomOfScreen = function (y)
  return y - camera.y > levelHeight*3/4
end

local isInTopHalfOfScreen = function (y)
  return y - camera.y < levelHeight/2
end

local isInBottomHalfOfScreen = function (y)
  return y - camera.y > levelHeight/2
end

local isTall = function(layer)
  return layer.h > levelHeight/4
end

function camera:animateLayerChange(body, layer, dir)
  local y = body:getY()
  if dir == "up" and (isNearTopOfScreen(y) or isInTopHalfOfScreen(y) and isTall(layer)) then
    print("decided to animate up by "..layer.h)
    camera:animate(layer.h, -1)
  end
  if dir == "down" and (isNearBottomOfScreen(y) or isInBottomHalfOfScreen(y) and isTall(layer)) then
    print("decided to animate down by "..layer.h)
    camera:animate(layer.h, 1)
  end
end