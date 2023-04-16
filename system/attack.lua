local attack_data = {
  ['player'] = {
    [1] = {10, 15},
    [2] = {15, 25},
    [3] = {20, 35},
    ['delay'] = 1.0},

  ['monster'] = {
    [1] = {10, 15},
    ['delay'] = 1.0}
}


--20%(=1/5) 확률로 크리티컬 데미지
local function critical(i)
  if math.random(5) == 5 then --1,2,3,4,5 중 5가 나오면 크리티컬
    return math.floor((i * 1.5) + .5), true
  else
    return i, false
  end
end



local function damage(type, int)
  local min, max = attack_data[type][int][1], attack_data[type][int][2]
  return critical(math.floor(math.random(min, max)))
end

local function collision(a, b)
  return  a[1] < b[1]+b[3] and
          b[1] < a[1]+a[3] and
          a[2] < b[2]+b[4] and
          b[2] < a[2]+a[4]
end


local function damaged(type, obj, x, dir)
  local int = 1
  local ix = x
  if type == 'player' then int = player.attack_num end
  if dir == -1 then ix = ix - 50 end

  if type == 'player' then
    if obj.damaged_delay > 0 and player.attack_num == obj.damage_int then return end
  else
    if obj.damaged_delay > 0 then return end
  end

  if type == 'player' then
    obj.damaged_move_timer = 0.5
    obj.damage_int = player.attack_num
  end

  local d, c  = damage(type, int)
  font_save(type, d, ix, c)
  obj.HP = obj.HP - d
  obj.damaged_delay = attack_data[type].delay

--3초간 체력 바 보임
  if obj.type == 'monster' then obj.HP_show = 3 end
end

function attack_collide(player)
  local p = {player.x, player.y+ 215, 100, 60}

  if player.dir == -1 then
    --총돌박스 위치 조정
    p[1] = p[1] - p[3]
  end

  for i, v in ipairs(Monster) do
    local m = {v.x-20, v.y+215, 40, 60}
    if collision(p, m) then
      damaged('player', v, v.ani_x, v.dir)
    end
  end
end



function damaged_collide(monster)
  local m = {monster.x, monster.y + 215, 50, 60}
  local p = {player.x - 25, player.y + 215, 50, 60}
  if monster.dir == -1 then
    m[1] = m[1] - m[3]
  end

  if collision(m,p) then
    damaged('monster', player, Window.center + player.ani_x, player.dir)
  end
end




function damaged_color(type, dt)
  if type.damaged_delay > 0 then
    type.damaged_delay = type.damaged_delay - dt
    return 1,0,0
  else
    return 1,1,1
  end
end
