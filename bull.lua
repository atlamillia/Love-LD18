require "lib/SECS"
require "lib/AnAL"

local speed = 200
local capturedspeed = 600
local normalAnim
local caughtAnim

bull = class:new()

function bull:init(x, y, a, p)
  self.x = x or 0
  self.y = y or 0
  self.dir = math.random() * math.pi
  self.dirX = math.cos(self.dir)
  self.dirY = math.sin(self.dir)
  self.dur = math.random(1,3)
  self.r = 0
  self.caught = false
  self.arena = a
  self.player = p
  self.hitwall = false
  normalAnim = newAnimation(images.bulls, 76, 167, 0.1, 8)
  normalAnim:play()
  caughtAnim = newAnimation(images.bulls_caught, 76, 167, 0.1, 8)
  caughtAnim:play()
end

function bull:update(dt)
  self.dur = self.dur - dt
  normalAnim:update(dt)
  caughtAnim:update(dt)
  
  if not self.caught then
    if self.dur <= 0 or self.hitwall then
      local x, y, r
      if math.random(1, 7) > 4 then
        x, y = self.arena:center()
	r = math.atan2(y-self.y, x-self.x)
        self.dir = r + (math.random()-0.5)*math.pi
      else
        x, y = self.player.x, self.player.y
	r = math.atan2(y-self.y, x-self.x)
	self.dir = r + 0.05*math.random()
      end
      self.dirX = math.cos(self.dir)
      self.dirY = math.sin(self.dir)
      self.dur = math.random(3,7)
      self.hitwall = false
    end
  
    self.x = self.x + self.dirX*speed*dt
    self.y = self.y + self.dirY*speed*dt
    self.r = self.dir + (math.pi * 0.5)
  else
    local p = self.caught
    local angle = math.atan2(p.y-self.y, p.x-self.x)+0.5*math.pi
    local x, y = math.cos(angle), math.sin(angle)

    self.x = self.x + x*capturedspeed*dt
    self.y = self.y + y*capturedspeed*dt
    self.r = angle+0.5*math.pi
  end

  local x, y = self.x, self.y
  --constrain to arena
  self.x = math.max(self.x, self.arena:left()+38)
  self.x = math.min(self.x, self.arena:right()-38)
  self.y = math.max(self.y, self.arena:top()+70)
  self.y = math.min(self.y, self.arena:bottom()-70)
  if self.x ~= x or self.y ~= y then
    --we ran into a wall
    self.hitwall = true
    --player loses control now
    if self.caught then
      self.caught.gripping = false
      self.caught = false 
    end
  end
end

function bull:draw()
  local anim = normalAnim
  if self.caught then anim = caughtAnim end
  anim:draw(self.x, self.y, self.r, 1, 1, 25, 25)
end
