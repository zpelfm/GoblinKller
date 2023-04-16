--스프라이트 프레임 컷당 시간(n초당 1프레임씩 지나감)

local animation_frame = {
  ['player'] = {
    --1: 스톰트루퍼
    [1] = {
        ['idle'] = .1,
        ['jump'] = .1,
        ['run'] = .08,
        ['dodge_run'] = .08,

        ['skill'] = .075,
      },

    --2: 검신
    [2] = {
        ['idle'] = .1,
        ['jump'] = .1,
        ['run'] = .08,
        ['dodge_run'] = .08,

        ['attack1'] = .06,
        ['attack2'] = .06,
        ['attack3'] = .06,

        ['skill'] = .075,
        ['effect_skill'] = .06
      }

    },

  ['monster'] = {
    --1: 고블린
    [1] = {
        ['idle'] = .1,
        ['attack'] = .1,
        ['run'] = .1
      }
    },

  ['skill'] = {
    [1] = {
        ['effect'] = .075
      }
    }
}

function animation_frame:load(obj, i, motion)
  if animation_frame[obj][i][motion] == nil then return 0.1
  else return animation_frame[obj][i][motion]
  end
end




return animation_frame
