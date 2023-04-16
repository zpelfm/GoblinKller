Monster = {}

local spawn_timer = 2
local run_timer = {2, 3, 3, 5, 5, 5}

local function monster_spawn_x(num)
  local dir = {-1, 1}
  local sp = {100, 200, 300}

  return player.x + dir[math.random(#dir)] * sp[math.random(#sp)]
end

function Monster:spawn(dt)
  spawn_timer = spawn_timer - dt
  if spawn_timer <= 0 then
    spawn_timer = 2
    Monster:new(1)
  end
end


function Monster:new(num)
  local mon = {
    ['dead'] = false,

    ['type'] = 'monster',
    ['number'] = num,
    ['ani'] = Animation.new('monster', num),
    ['ani_x'] = ground_x,
    ['motion'] = 'idle',
    ['state'] = 'idle',

    ['isRunning'] = false,
    ['running_timer'] = run_timer[math.random(#run_timer)],
    ['running_wait'] = math.random(1,3)/2,


    ['damaged'] = false,
    ['damaged_delay'] = 0,
    ['damaged_move_timer'] = 0,

    ['get_skill'] = false,

    ['spawn_timer'] = 3,
    ['x'] = math.random(page['background'].w),
    ['y'] = Floor,
    ['speed'] = 2,
    ['dir']  = 1,

    ['HP_max'] = 200,
    ['HP'] = 200,
    ['dead_timer'] = 0,
    ['damage_int'] = 0,

  }
  if #Monster < 1 then table.insert(Monster, mon) end
end



local function run(v)
  v.motion = 'run'
  if v.running_timer > 0 then
    v.x = v.x + v.dir * v.speed
  else
    v.running_timer = 0
    v.motion = 'idle'
  end
end

local function monster_running_timer(v, dt)
  if v.running_timer <= 0 then
    if v.running_wait <= 0 then
      v.running_wait = math.random(1,3) / 2
      v.running_timer = run_timer[math.random(#run_timer)]
    else
      v.running_wait = v.running_wait - dt
    end
  else
    v.running_timer = v.running_timer - dt
  end
end

local function attack(v)
  if v.damaged_delay <= 0 then
    if player.dead == false and player.HP > 0 then
      if v.motion ~= 'attack' then v.motion = 'attack' end
    end
  else
    v.motion = 'damaged'
    v.ani:skip('attack')
    lg.setColor(1,0,0)
  end
end

local function monster_HP_bar(v)
  local bar = {x = v.ani_x-25, y = v.y+205, w = 50, h = 8}
  local hp = {x = bar.x+2, y = bar.y+2, w = bar.w-4, h = bar.h-4}

  hp.w = v.HP / v.HP_max * hp.w
  if hp.w < 0 then hp.w = 0 end

  lg.setColor(0,0,0, .5)
  lg.rectangle('fill', bar.x, bar.y, bar.w, bar.h)
  lg.setColor(1,0,0, .9)
  lg.rectangle('fill', hp.x, hp.y, hp.w, hp.h)
  lg.setColor(1,1,1)
end




function Monster:update(dt)

  local function monster_direction(x)
    if x > player.x then return -1 else return 1 end
  end

  for i, v in ipairs(Monster) do
    v.ani_x = ground_x + v.x
--플레이어 바라보게 방향 전환
    if monster_direction(v.x) ~= v.dir then v.dir = monster_direction(v.x) end

--플레이어와 일정거리 이상 떨어져 있으면 플레이어에게 이동한다
    if v.dead == false and v.motion ~= 'damaged' then
      if math.abs(v.x - player.x) > 70 then
        v.attack = false
        v.ani:skip('attack')
        v.isRunning = true
        monster_running_timer(v, dt)
      else        
        if player.dead == false and player.HP > 0 then
          v.attack = true
          damaged_collide(Monster[i])
        end
        v.isRunning = false
      end
    end

    if v.damaged_delay > 0 then
      v.damaged_delay = v.damaged_delay - dt
      v.damaged_move_timer = v.damaged_move_timer - dt
      if (v.damaged_move_timer > 0) then
        v.x = v.x + player.dir * dt * 30
      end
    else
      v.damage_int = 0
    end
    -- if v.HP > 0 then --디버깅용 
    --   v.HP = v.HP - dt
    -- end

    if v.HP > 0 and player.state == 'attack' and
    math.abs(v.x - player.x) <= 70 then
      attack_collide(player)
      -- v.damaged_delay = 2
      -- v.HP = v.HP - 2
    end

    if Monster[i].HP <= 0 then
      Monster[i].dead = true
    end

    if Monster[i].dead then
      Monster[i].dead_timer = Monster[i].dead_timer + dt
    end

    if v.get_skill then
        v.running_timer = 0
        v.attack = false
    end
  end

  for i = #Monster, 1, -1 do
    if Monster[i].dead and Monster[i].dead_timer > 0.8 then 
      Monster[i] = nil
      table.remove(Monster, i) end
  end
end


function Monster:draw(dt)
  Monster:update(dt)


  local get_skill_count = 0

  for i, v in ipairs(Monster) do
      monster_HP_bar(v)

--atk.png 이미지 지나가는 순간 충돌체크

    if v.isRunning then run(v)
    elseif v.attack then attack(v)
    end

    if v.ani['info'].attack then
      damaged_collide(v)
    end

    if v.dead then
      lg.setColor(1,1,1)
      v.motion = 'dead'
    end

    v.ani:draw(v, dt)
    lg.setColor(1,1,1)


    if v.get_skill then
      get_skill_count = get_skill_count + 1
    end
  end
  --lg.print(player.x, 0, 50)
end
