local Player = {
  ['show'] = false,
  ['type'] = 'player',

  ['motion'] = 'idle',
  ['state'] = 'idle',

  ['jump'] = false,
  ['run'] = false,

  ['attack'] = false,
  ['skill'] = false,
  ['dead'] = false,

  ['attack_num'] = 1,
  ['jumping'] = {floor = Floor, gravity = -1500, v = 0, h = -500}
}

local player_bool = {'jump', 'run', 'attack', 'skill', 'dead'}

local function anim(m)
  if m ~= player.motion then
    player.motion = m
    return false
  else return true
  end
end

function Player:load(num)
  self.number = num

  self.ani = Animation.new('player', num)
  self.ani_x = 0

  self.x = page['background'].w / 2
  self.y = Floor
  self.dir = 1

  self.speed = 3

  self.damaged_delay = 0

  self.use_skill = false
  self.skill = require 'system.skill'

  self.HP_max = 300
  self.HP = 300

  self.MP_max = 200
  self.MP = 200
end


--점프
local function jump(dt)
  anim('jump')
  local jump = player.jumping

  if jump.v == 0 then
    jump.v = jump.h
  end

  if jump.v ~= 0 then
    player.y = player.y + jump.v * dt
    jump.v = jump.v - jump.gravity * dt
  end

  if player.y > jump.floor then
    jump.v = 0
    player.y = jump.floor
    player.jump = false
  end
end

local function attack(dt)
  player.motion = 'attack'..player.attack_num
  local atk = player.ani[player.motion]

  if player.isRunning then player.isRunning = false end
end



local function run(dt)
  anim('run')
  local next = player.x + player.dir * player.speed

  if next > 0 and next < page['background'].w then
    player.x = next
  end
end

--스킬 애니메이션
local function skill(dt)
  local s = player.ani['skill']
--플레이어 화면에 보이는 범위
  local skill_range = {player.x - Window.w/2, player.x + Window.w/2}
  for i, v in ipairs(Monster) do
    if v.x > skill_range[1] and v.x < skill_range[2] then
      v.get_skill = true
    end
  end
end

local function dead()
  anim('dead')
  player.dead = true
  player.state = 'dead'
  player.HP = 0
  for i, v in ipairs(player_bool) do
    player[v] = false
  end
end


local function set_move(dt)
  local tb = {'run', 'jump'}
  local bool = true

  local function move_state(s, dt)
    if s == 'run' then run(dt) end
    if s == 'jump' then jump(dt) end
  end

  for i, v in ipairs(tb) do
    if player[v] then move_state(v, dt) bool = false end
  end

  return bool
end

--global function
--------------------------

function Player:draw(dt)
  if self.HP <= 0 and self.state ~= 'dead' then dead() end

  check_x()

  lg.setColor(damaged_color(player, dt))

  if self.state == 'idle' and set_move(dt) then anim('idle') end
  if self.state == 'attack' then attack(dt) end

  self.ani:draw(player, dt)
  lg.setColor(1,1,1)

  --lg.print(self.state)
  --lg.print(self.attack_num, 50, 0)
end



return Player
