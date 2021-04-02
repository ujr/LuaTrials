-- Simple Lua vector module, using environments
-- Usage: local vec = require "vec2"
--
-- Module pattern using environments: Lua interprets
-- all free variables foo as _ENV.foo, where _ENV is
-- just a variable that can be assigned and returned.
-- With this pattern, the module (1) must import external
-- functions and modules explicitly, and (2) there is no
-- chance that the global space is polluted by accident.

local sqrt = math.sqrt    -- import globals while you can
local _ENV = {}           -- global space is our module

function new (x, y)
  return {x = x, y = y}
end

function add (u, v)
  return new(u.x+v.x, u.y+v.y)
end

function norm (v)
  return sqrt(v.x^2 + v.y^2)
end

return _ENV
