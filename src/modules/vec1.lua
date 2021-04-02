-- Simple Lua vector module.
-- Usage: local vec = require "vec1"
--
-- When the module is loaded, the module code runs
-- as the body of a function; therefore the module
-- returns a table with the exported functions.

local M = {}

function M.new (x, y)
  return { x = x, y = y }
end

function M.add (u, v)
  return M.new(u.x+v.x, u.y+v.y)
end

function M.norm (v)
  return math.sqrt(v.x*v.x + v.y*v.y)
end

return M
