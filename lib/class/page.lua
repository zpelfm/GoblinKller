local Page = {
  ['enable'] = {splash = false},
  ['splash'] = love.filesystem.getDirectoryItems('ImagePacks/splash')
}
for i, v in ipairs(Page['splash']) do
  Page['splash'][i] = lg.newImage('ImagePacks/splash/'..v)
end

local hud = {
  ['hud'] = lg.newImage('ImagePacks/gui/hud.png'),
  ['HP'] = lg.newImage('ImagePacks/gui/hp.png'),
  ['MP'] = lg.newImage('ImagePacks/gui/mp.png')
}
hud.x = 3
hud.y = Window.bot - hud['hud']:getHeight() - 5




function Page:load(page)
  self['background'] = Background.new()
  self['isSide'] = false
  self['name'] = page
  self['fade'] = 0
  self['light'] = 0
  player:load(2)

  if page == 'select' then
    self['enable'].splash = true
    player.show = false
  end

  if page == 'play' then
    self['enable'].splash = false
    player.show = true
  end
end


function check_x()
  local x2 = page['background'].w - Window.center
  if player.x < x2 and player.x > Window.center then player.ani_x = 0
    return true
  else
    if player.x >= x2 then player.ani_x = player.x - x2 end
    if player.x <= Window.center then player.ani_x = player.x - Window.center end

    return false
  end
end


local function draw_HUD()

  local hp_w = player.HP / player.HP_max * 150
  local mp_w = player.MP / player.MP_max * 150
  lg.draw(hud.HP, hud.x + 93, hud.y + 11, 0, hp_w, 1)
  lg.draw(hud.MP, hud.x + 93, hud.y + 38, 0, mp_w, 1)
  lg.draw(hud.hud, hud.x, hud.y)
end

function Page:draw(dt)
  self['background']:draw(dt)
  if self.fade > 0 then
    lg.setColor(0,0,0,self.fade)
    lg.rectangle('fill', 0,0, Window.w, Window.h)
    if self.fade <= .75 then self.fade = self.fade + .025 end
    lg.setColor(1,1,1)
  end

  if self.light > 0 then
    lg.setColor(1,1,1,self.light)
    lg.rectangle('fill', 0,0, Window.w, Window.h)
    if self.light > 0 then self.light = self.light - .05 end
    lg.setColor(1,1,1)
  end

  if player.show then
    Monster:draw(dt)
    player:draw(dt)
   end
  if self['enable'].splash then lg.draw(self.splash[1]) end
  font_draw(dt)
  draw_HUD()
end

function Page:update(dt)
  if self['name'] == 'play' then
    Monster:spawn(dt)
  end
end

return Page
