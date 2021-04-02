-- Simple Lua vector module, object-oriented style
-- Usage: local Vec = require "vec3"
--        v = Vec:new(10,10)
--        u = Vec:new(20,30)
--        w = u + v            invokes __add of u's metatable
--        w:norm()             invokes mt(w).norm(w)
--
-- Still using the environment module pattern. Use a metatable
-- and the colon operator to provide an object-oriented feel.

local Vec = {x=0, y=0}          -- prototype
local mt = {__index = Vec}      -- metatable, delegates to prototype
local sqrt = math.sqrt

function Vec:new (x, y)         -- Vec.new = function (self, x, y) ...
  local v = {x = x, y = y}
  setmetatable(v, mt)
  return v
end

function Vec:norm ()            -- Vec.norm = function (self) ... end
  return sqrt(self.x^2 + self.y^2)
end

function mt.__add (u, v)
  return Vec:new(u.x+v.x, u.y+v.y)
end

return Vec
