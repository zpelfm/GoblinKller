function state_chain(state)
  if state == 'attack' then
    player.attack_num = player.ani:chain(state, player.attack_num)
  end
end


function state_reset(type)
  if type.type == 'player' then
    type.attack_num = 1
  end
  type.state = 'idle'
end
