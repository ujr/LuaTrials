
function love.conf(t)
  t.version = "11.3" -- version of LÖVE this game was created with
  t.identity = "LoveSnakeGame" -- folder for save games

  t.window.title = "Snake"
  t.window.icon = "assets/icon.png"  -- file path to window icon image

  t.window.resizable = true
  t.window.minwidth = 320
  t.window.minheight = 200
end
