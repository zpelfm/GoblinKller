local Font = {}

local data = {
  player = love.filesystem.getDirectoryItems('ImagePacks/skin/player'),
  monster = love.filesystem.getDirectoryItems('ImagePacks/skin/monster'),
  critical = love.filesystem.getDirectoryItems('ImagePacks/skin/critical')
}

local width = {
  player = 14,
  monster = 14,
  critical = 18
}

for k, v in pairs(data) do
  for i, v in ipairs(data[k]) do
    local int = i - 1
    data[k][int] = lg.newImage('ImagePacks/skin/'..k..'/'..data[k][i])
  end
end

--자릿수
local function digit(dmg)
  local d = {math.floor(dmg/100)}
    d[2] = math.floor((dmg-d[1]*100)/10)
    d[3] = math.floor(dmg-(d[1]*100 + d[2]*10))
  if d[1] > 0 then
    return {d[1], d[2], d[3]}
  else
    return {d[2], d[3]}
  end
end


function font_save(type, dmg, x, critical)
  local f = {['type'] = type, ['dmg'] = digit(dmg), ['x'] = x, ['y'] = 190, ['timer'] = 1, ['alpha'] = 1}
  if critical then f.type = 'critical' end
  table.insert(Font, f)
end

function font_draw(dt)
  for n, v in ipairs(Font) do
    for i, v2 in ipairs(v.dmg) do
      lg.setColor(1,1,1,v.alpha)
      lg.draw(data[v.type][v.dmg[i]], v.x + width[v.type] * i, v.y)
    end
    lg.setColor(1,1,1)
  end

  for f = #Font, 1, -1 do
    if Font[f].timer <= 0 then
      table.remove(Font, f)
    else
      if Font[f].timer >= .5 then
        Font[f].y = Font[f].y-.25
      else
        Font[f].y = Font[f].y-2
        Font[f].alpha = Font[f].alpha -.15
      end
      Font[f].timer = Font[f].timer - dt
    end
  end
end





function damage_font(type, tb, dt)
  local dmg10= math.floor(tb.dmg / 10)
  local dmg1 = tb.dmg - dmg10
end
