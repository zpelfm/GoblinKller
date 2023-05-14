Window = {left = 0, right = 700, top = 0, bot = 410, center = 340}
Window.w = 700
Window.h = 410
Floor = 0

function love.conf(t)
  t.window.borderless = true
  t.modules.joystick = false
  t.modules.physics = false
  t.window.width = Window.right
  t.window.height = Window.bot
end
