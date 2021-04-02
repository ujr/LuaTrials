-- coroutines offer cooperative multithreading
-- coroutines in Lua are also called threads
-- API: create(fun), yield(arg), resume(thread, arg)
-- games: each actor controlled by a script (loop) running in a coroutine
-- example below from "A Look at the Design of Lua" (Comm ACM, Nov 2018)

co = coroutine.create(function (x)
  print(x)                           --> 10
  x = coroutine.yield(20)
  print(x)                           --> 30
  return 40
end)

print(coroutine.resume(co, 10))      --> 20
print(coroutine.resume(co, 30))      --> 40
print(coroutine.resume(co, 50))      --> error (dead coroutine)

