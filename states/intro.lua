local ts = -1

--[[ Time-cues:
 - Peace:
 1.0: bird chirp
 2.6: next state
 - Bomb:
 0.4: fling sound
 0.9: bomb starts falling
 2.3: impact, next state
 - Flash, AAaahh:
 0.1: boom sound
 0.8: start fadeout
 1.2: next state
 - Happiness:
 0.2: yaaaayy sounds
 1.4: fadeout
--]]

--[[ Colours:
 - Dark: (50, 50, 50)
 - Light: (233, 233, 233)
--]]

local images = {}
local sources = {}
local played = {}

hook.add("update", function(dt)
  if ts == -1 then ts = 0 end
  ts = ts + dt
  if not sources.chirp then
    sources.chirp = love.audio.newSource("sfx/chirp.ogg", "static")
  end
  if not images.bg then
    images.bg = love.graphics.newImage("gfx/bg.png")
    images.city = love.graphics.newImage("gfx/city.png")
    images.bomb = love.graphics.newImage("gfx/bomb.png")
  end
  if ts >= 1.0 and not played.chirp then
    love.audio.play(sources.chirp)
    played.chirp = true
  end
  if ts >= 1.5 and not sources.bombfall then
    sources.bombfall = love.audio.newSource("sfx/bombfall.ogg", "static")
  end
  if ts >= 2.6 then
    game.state = "i-bomb"
    ts = 0
  end
end, "intro-upd-peace", "i-peace")

hook.add("draw", function()
  love.graphics.draw(images.bg, 198, 224)
  love.graphics.draw(images.city, 243, 253)
end, "intro-dr-peace", "i-peace")

hook.add("update", function(dt)
  ts = ts + dt
  if not sources.impact then
    sources.impact = love.audio.newSource("sfx/impact.ogg", "static")
  end
  if ts >= 0.4 and not played.bombfall then
    love.audio.play(sources.bombfall)
    played.bombfall = true
  end
  if ts >= 2.3 then
    game.state = "i-flash"
    ts = 0
    love.audio.play(sources.impact)
  end
end, "intro-upd-bomb", "i-bomb")

hook.add("draw", function()
  love.graphics.draw(images.bg, 198, 224)
  love.graphics.draw(images.city, 243, 253)
  love.graphics.draw(images.bomb, 388, ts*170-100)
end, "intro-dr-bomb", "i-bomb")

hook.add("update", function(dt)
  ts = ts + dt
  if not images.city then
    images.city = love.graphics.newImage("gfx/city.png")
  end
  if ts >= 1.2 then
    game.state = "i-happiness"
  end
end, "intro-upd-flash", "i-flash")

hook.add("draw", function()
  love.graphics.draw(images.city, 243, 254)
  love.graphics.setColor(233, 233, 233, 233-(math.min(0, ts*-0.8)*250))
  love.graphics.rectangle(0, 0, 800, 600)
  love.graphics.setColor(255, 255, 255, 255)
end, "intro-dr-flash", "i-flash")