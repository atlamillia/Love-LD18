Gamestate.game = Gamestate.new()
local state = Gamestate.game
local player
local bull
local arena

function state:enter()
  arena = _G.arena:new(0,0,1024,1024)
  player = _G.player:new(400, 300, arena)
  bull = _G.bull:new(400, 300, arena)
end

function state:mousepressed(x, y, button)
  player:mousepressed(x, y, button)
end

function state:mousereleased(x, y, button)
  player:mousereleased(x, y, button)
end

function state:update(dt)
  player:update(dt)
  bull:update(dt)
end

function state:draw()
  player:center()
  arena:draw()
  bull:draw()
  player:draw()
end

