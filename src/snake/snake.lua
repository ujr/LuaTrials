-- Snake Game -- heavily refactored from a tutorial at
-- https://simplegametutorials.github.io/love/snake/

local Snake = {}

function Snake.init()
  Snake.cellSize = 20
  Snake.gridSizeX = 20
  Snake.gridSizeY = 15
  Snake.deadTime = 5 -- seconds
  Snake.speed = 1.0/6.0 -- seconds per step
  Snake.font = love.graphics.newFont(18)
  Snake.eatSound = love.audio.newSource("assets/eat.wav", "static")
  Snake.deadSound = love.audio.newSource("assets/dead.wav", "static")
  Snake.reset()
end

function Snake.reset()
  Snake.timer = 0
  Snake.alive = true
  Snake.directionQueue = {'right'}
  -- snake starts in the middle, going right
  local midy = math.floor(Snake.gridSizeY / 2)
  local midx = math.floor(Snake.gridSizeX / 2)
  Snake.segments = {
    {x = midx+1, y = midy},
    {x = midx,   y = midy},
    {x = midx-1, y = midy},
  }
  Snake.foodPosition = Snake.getRandomFoodPos()
end

local function isSnakePos(segments, x, y)
  for index, segment in ipairs(segments) do
    if x == segment.x and y == segment.y then return true end
  end
  return false
end

function Snake.getRandomFoodPos()
  -- random cell in grid, but not on the snake
  local feasible = {}
  for x = 1, Snake.gridSizeX do
    for y = 1, Snake.gridSizeY do
      if not isSnakePos(Snake.segments, x,y) then
        table.insert(feasible, {x=x, y=y})
      end
    end
  end
  return feasible[love.math.random(#feasible)]
end

function Snake.draw()
  local function drawCell(x, y)
    love.graphics.rectangle('fill',
      (x - 1) * Snake.cellSize,
      (y - 1) * Snake.cellSize,
      Snake.cellSize - 1,
      Snake.cellSize - 1)
  end

  love.graphics.setColor(.28, .28, .28);
  love.graphics.rectangle(
    "fill", 0, 0, Snake.gridSizeX*Snake.cellSize,
                  Snake.gridSizeY*Snake.cellSize)

  love.graphics.setColor(1, .3, .3)
  drawCell(Snake.foodPosition.x, Snake.foodPosition.y)

  love.graphics.setColor(.4, .7, .2)
  for segmentIndex, segment in ipairs(Snake.segments) do
    drawCell(segment.x, segment.y)
    if Snake.alive then
      love.graphics.setColor(.6, 1, .32)
    else
      love.graphics.setColor(.5, .5, .5)
    end
  end

  love.graphics.setColor(.8,.8,.8, .5)
  love.graphics.setFont(Snake.font)
  local msg
  if Snake.alive then
    msg = "snake len " .. #Snake.segments
  else
    msg = "snake dead"
  end
  love.graphics.print(msg, 10, 20)
end

local function wrap(idx, min, max)
  if idx < min then return max end
  if idx > max then return min end
  return idx
end

local function selfBitten(segments, x, y)
  for index, segment in ipairs(segments) do
    if index ~= #segments -- not last (snake creeps away)
    and x == segment.x and y == segment.y then
      return true
    end
  end
  return false
end

function Snake.update(dt)
  Snake.timer = Snake.timer + dt
  if Snake.alive then
    if Snake.timer >= Snake.speed then
      Snake.timer = 0

      if #Snake.directionQueue > 1 then
        table.remove(Snake.directionQueue, 1)
      end

      local direction = Snake.directionQueue[1]

      local nextX = Snake.segments[1].x
      local nextY = Snake.segments[1].y

      if direction == 'right' then
        nextX = wrap(nextX + 1, 1, Snake.gridSizeX)
      elseif direction == 'left' then
        nextX = wrap(nextX - 1, 1, Snake.gridSizeX)
      elseif direction == 'down' then
        nextY = wrap(nextY + 1, 1, Snake.gridSizeY)
      elseif direction == 'up' then
        nextY = wrap(nextY - 1, 1, Snake.gridSizeY)
      end

      if selfBitten(Snake.segments, nextX, nextY) then
        Snake.alive = false
        Snake.deadSound:play()
      else
        table.insert(Snake.segments, 1, {x = nextX, y = nextY})
        if Snake.segments[1].x == Snake.foodPosition.x
        and Snake.segments[1].y == Snake.foodPosition.y then
          Snake.foodPosition = Snake.getRandomFoodPos()
          Snake.eatSound:play()
        else
          table.remove(Snake.segments) -- remove tail
        end
      end
    end
  elseif Snake.timer >= Snake.deadTime then
    Snake.reset()
  end
end

local function queueDirection(queue, direction)
  -- direction must not be same as current direction
  local current = queue[#queue]
  if current == direction then return end
  -- nor the opposite direction (snake must properly turn around)
  if current == 'left' and direction == 'right' or
     current == 'right' and direction == 'left' or
     current == 'up' and direction == 'down' or
     current == 'down' and direction == 'up' then return end
  table.insert(queue, direction)
end

local function clamp(value, min, max)
  if value < min then return min end
  if value > max then return max end
  return value
end

local function adjustSpeed(delta)
  local stepsPerSec = 1/Snake.speed
  stepsPerSec = clamp(math.floor(stepsPerSec*2 + delta)/2, 1, 10)
  Snake.speed = 1/stepsPerSec
  print("Snake speed: " .. stepsPerSec .. " steps/s")
end

function Snake.keyPressed(key)
  if key == 'left' or key == 'right'
  or key == 'up' or key == 'down' then
    queueDirection(Snake.directionQueue, key)
  elseif key == 'pageup' then
    adjustSpeed(1)
  elseif key == 'pagedown' then
    adjustSpeed(-1)
  end
end

return Snake
