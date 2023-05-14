local keyboard = {
  ['direction'] = {[1]='right', [-1]='left'},
  ['state'] = {
      attack = 'x',
      jump   = 'c',
      skill = 'a'
    }
}


d = 0

local function edit(st, v)
  if player.state == 'idle' and player.dead == false and player[st] ~= v then
    player[st]=v
  end
end

local function key_state(key)
  for k, v in pairs(keyboard.state) do
    if v == key then
      if k == 'jump' then edit('jump', true)
      elseif not player.jump then
        state_chain(k)
        edit('run', false)
        edit('state', k)
      end
    end
  end
end

local function key_move(key)
  local move_key = 0
  for k, v in pairs(keyboard.direction) do
    if v == key then move_key = k end
  end
  return move_key
end





function love.keypressed(key)
  if key == "escape" then love.event.push("quit") end

  key_state(key)
  if key_move(key) ~= 0 then
    edit('dir', key_move(key))
    edit('run', true)
  end
end

function love.keyreleased(key)
  if key_move(key) ~= 0 and key_move(key) == player.dir then
    edit('run', false)
  end
end

function check_key_move()
  for k, v in pairs(keyboard.direction) do
    if love.keyboard.isDown(v) then
      love.keypressed(v)
    end
  end
end


function debug_keyboard()
  lg.print(d, 0, 20)
  --lg.print(player.dir, 0, 20)
end
