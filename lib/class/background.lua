Background = {}
Background.__index = Background
ground_x = 0

function Background.new()
  local TB = {}
  local image = love.filesystem.getDirectoryItems('ImagePacks/background')

  for i, v in ipairs(image) do
    image[i] = lg.newImage('ImagePacks/background/'..v)
    image[i] = {
      [1] = {['img'] = image[i], ['left'] = 0, ['right'] = image[i]:getWidth(), ['width'] = image[i]:getWidth()},
      [2] = {['img'] = image[i], ['left'] = image[i]:getWidth(), ['right'] = image[i]:getWidth() * 2, ['width'] = image[i]:getWidth()}}
  end


  TB.image = image
  TB.w = 1600
  ground_x = Window.center - TB.w / 2
  setmetatable(TB, Background)

  return TB
end

local function background_Move(v, i)
  v['left'] = v['left'] - (player.dir * i)
  v['right'] = v['left'] + v['width']
  if v['right'] <= 0 then v['left'] = v['right'] + v['width'] end
  if v['left'] >= Window.right then v['left'] = v['left'] - v['width'] * 2 end
end

local function update_ground_x()
  if player.run and check_x() and player.dead == false then
    ground_x = ground_x - (player.dir * player.speed)
  end
end

function Background:draw(dt)
  for i, v in ipairs(self['image']) do
    for i2, v2 in ipairs(v) do
      if player.run and check_x() and player.dead == false then
        background_Move(v2, i)
      end
      lg.draw(v2['img'], v2['left'])
    end
  end

  update_ground_x()
end
