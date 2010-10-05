-- 
--  scene_gameover.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-10-04.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'gamestate'

gameover = Gamestate.new()

function gameover.enter()
end

function gameover.update()
end

function gameover.keypressed(self, key, unicode)
  if key == "r" then
    Gamestate.switch(chase)
  elseif key == q or key == "escape" then
    Gamestate.switch(title)
  end
end


function gameover.draw()
  love.graphics.print('Press r to retry, press escape to quit', 300, 300)
end

function gameover.leave()
end

