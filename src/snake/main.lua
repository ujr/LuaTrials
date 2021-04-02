
local snake = require "snake"

local kioskmode = false
local didScreenshot = false
local oldwd, oldht, oldmode = 0, 0, {}
local offsetX, offsetY = 0, 0
local refit = true

function love.load()
  love.keyboard.setKeyRepeat(true)

  snake.init()
  refit = true
end

function love.update(dt)
  snake.update(dt)
end

function love.draw()
  if refit then fitSnake() refit = false end
  love.graphics.translate(offsetX, offsetY)
  snake.draw()
end

function fitSnake(w, h)
  w = w or love.graphics.getWidth()
  h = h or love.graphics.getHeight()
  local sx = w/snake.gridSizeX
  local sy = h/snake.gridSizeY
  local cellSize = math.floor(math.min(sx, sy))
  local gw = cellSize * snake.gridSizeX
  local gh = cellSize * snake.gridSizeY
  offsetX = (w - gw)/2
  offsetY = (h - gh)/2
  snake.cellSize = cellSize
  --print("fit (w,h,gw,gh,ox,oy):", w, h, gw, gh, offsetX, offsetY)
end

function love.resize(w, h)
  fitSnake(w, h)
  refit = true
end

function love.quit()
  if didScreenshot then
    local shotdir = love.filesystem.getSaveDirectory()
    print("Screenshot stored in " .. shotdir)
  end
  print("Goodbye snake!")
end

function love.keypressed(key, scancode, isrepeat)
  if (key == 'escape' or key == 'q') and not kioskmode then
    love.event.quit()
  elseif key == 'f' and not kioskmode then
    local fs, mode = love.window.getFullscreen()
    if not fs then oldwd, oldht, oldmode = love.window.getMode() end
    love.window.setFullscreen(not fs, "desktop")
    if not love.window.getFullscreen() then
      love.window.setMode(oldwd, oldht, oldmode) -- restore size and mode
    end
    refit = true
  elseif key == 'k' and not kioskmode then
    kioskmode = true
    love.window.setFullscreen(true, "desktop")
    refit = true
  elseif key == 's' then
    love.graphics.captureScreenshot("snakeshot.png")
    didScreenshot = true
  end
  snake.keyPressed(key)
end
