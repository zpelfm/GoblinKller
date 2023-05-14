lg = love.graphics
la = love.audio
lm = love.mouse


require 'system'
require 'lib'


function love.load()
  math.randomseed(os.time())
  tick.framerate = 60
  tick.rate = .03
  page:load('play')
  --player = Animation.new('player', 1, .1)
end

function love.draw()
  --lg.print(player:draw('idle', 1, tick.dt))
  --player:draw('idle', 1, tick.dt)
  --system.draw()
  page:draw(tick.dt)
  --Debug()
end

function love.update()
  page:update(tick.dt)

end
