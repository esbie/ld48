items = {}

function items:new(layer, x, y)
  local newItem = {}
  newItem.body = love.physics.newBody(world, layer.body:getX() + x, layer.body:getY() + y)
  newItem.body:setUserData("item")
  newItem.shapes = {}
  newItem.fixtures = {}
  items:addShapeAtOffset(newItem, 0)
  return newItem
end

function items:addShapeAtOffset(item, xOffset)
  local shape = love.physics.newRectangleShape(xOffset, 0, 10, 10)
  local fixture = love.physics.newFixture(item.body, shape, 1)
  table.insert(item.shapes, shape)
  table.insert(item.fixtures, fixture)
  return item
end

function items:draw(item)
  love.graphics.setColor(255, 255, 14)
  for i, shape in ipairs(item.shapes) do
    love.graphics.polygon("fill", item.body:getWorldPoints(shape:getPoints()))
  end
end

function items:collide(a, b, coll)
  if a:getBody():getUserData() == "item" then
    a:getBody():setUserData("removed")
  elseif b:getBody():getUserData() == "item" then
    b:getBody():setUserData("removed")
  end
end