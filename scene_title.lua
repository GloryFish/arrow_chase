-- 
--  scene_title.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-09-29.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'gamestate'
require 'typeout'
require 'vector'

title = Gamestate.new()

function title.enter()
  love.graphics.setBackgroundColor(210, 231, 245)
  love.graphics.setFont(fonts.default)
  
  title.logo = Typeout('arrow_chase', vector(50, love.graphics.getHeight() - 70), 6, fonts.title, {r=0, g=0, b=0, a=200})
  
end

function title.keypressed(self, key, unicode)
  if (key == "escape") then
    love.event.push('q')
  elseif (key == "g") then
    Gamestate.switch(chase)
  end
end

function title.update(self, dt)
  title.logo:update(dt)
end

function title.draw()
  love.graphics.setColor(0, 0, 0, 150)

  title.logo:draw()

  love.graphics.setFont(fonts.default)
  love.graphics.print("Press the letter g", 
                      love.graphics.getWidth() / 2 - 100, 
                      love.graphics.getHeight() / 2);
end

