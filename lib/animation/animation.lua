Animation = {}
Animation.__index = Animation

local frame = require 'lib.animation.frame'
local rep_ani = {'idle', 'run', 'dead'}


local function ani_repeat(tb)
  if tb.ani[tb.motion].rep then
    return true
  else
    return false
  end
end

local function set_scale(tb)
  return 2
--  if string.find(tb.type, 'effect') ~= nil then return 1
--  else return 2
--  end
end

local function set_x(tb, x)
  if tb.type == 'player' then return Window.center - tb.dir * tb.ani[tb.motion][1][1]:getWidth() + x end
  if tb.type == 'monster' then return x - tb.dir * tb.ani[tb.motion][1][1]:getWidth() end
  if tb.type == 'skill' then return x - tb.ani[tb.motion][1][1]:getWidth()/2 end
end

local function next_frame(ani)
  if ani.int < ani.max then
    return ani.int + 1
  else
    return 0
  end
end


function Animation:chain(m, i)
  local atk = self[m..i]
  if atk.int >= atk.max - 5 and atk.int < atk.max - 1 and i < 3 then
    return i + 1
  else
    return i
  end
end

function Animation.new(obj, num)
  local ani = {['info'] = {type = obj, num = num}}

  local motionPath = 'ImagePacks/sprites/'..obj..'/'..num
  local motionTB = love.filesystem.getDirectoryItems(motionPath)
  --motionTB : idle, attack, 등등...
  for i, m in ipairs(motionTB) do
    local imgPath = motionPath..'/'..m
    ani[m] = love.filesystem.getDirectoryItems(imgPath)
    for i2, v in ipairs(ani[m]) do
      ani[m][i2] = {lg.newImage(imgPath..'/'..v), v}
      ani[m][i2][1]:setFilter('nearest', 'nearest')
    end

    ani[m].int = 1
    ani[m].max = #ani[m]
    ani[m].timer = frame:load(obj, num, m)
    ani[m].timer_max = frame:load(obj, num, m)

    for i, v in ipairs(rep_ani) do
      if string.find(m, v) ~= nil then
        ani[m].rep = true
      else
        ani[m].rep = false
      end
    end

  end

  setmetatable(ani, Animation)
  return ani
end



--function Animation:draw(m, dir, x, y, dt)
function Animation:draw(tb, dt)
  local Ani = tb.ani
  local m = tb.motion
  local scale = set_scale(tb)
  local x = set_x(tb, tb.ani_x)
  local y = tb.y
  local dir = tb.dir

  if Ani[m].timer > 0 then
    Ani[m].timer = Ani[m].timer - dt
  else
    Ani[m].int = next_frame(Ani[m])
    Ani[m].timer = Ani[m].timer_max
  end

  if Ani[m].int == 0 then
    if not ani_repeat(tb) then
      state_reset(tb)
      check_key_move()
    end

    Ani[m].int = 1
  end

  lg.draw(Ani[m][Ani[m].int][1], x, y, 0, dir * scale, scale)
end

function Animation:skip(m)
  self[m].int = 1
end
