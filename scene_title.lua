-- 
--  scene_title.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-09-29.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'gamestate'

title = Gamestate.new()

function title.enter()
  love.graphics.setBackgroundColor(210, 231, 245)
  love.graphics.setFont(fonts.default)
  
end

function title.keypressed(self, key, unicode)
  if (key == "escape") then
    love.event.push('q')
  elseif (key == "g") then
    Gamestate.switch(chase)
  end
end

function title.draw()
  love.graphics.setColor(0, 0, 0, 150)

  love.graphics.setFont(fonts.title)
  love.graphics.print("arrow_chase", 
                      love.graphics.getWidth() - 400, 
                      100);

  love.graphics.setFont(fonts.default)
  love.graphics.print("Press the letter g", 
                      love.graphics.getWidth() / 2 - 100, 
                      love.graphics.getHeight() / 2);
end

