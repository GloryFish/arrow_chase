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
  
  title.logo = Typeout('arrow_chase', vector(70, love.graphics.getHeight() - 70), 8, fonts.title, {r=0, g=0, b=0, a=200})
  title.duration = 0

  title.fadeDelay = 1.5
  title.fadeTime = 4
  title.fadeAlpha = 0
end

function title.keypressed(self, key, unicode)
  if (key == "escape") then
    love.event.push('q')
  elseif (key == "g") then
    Gamestate.switch(chase)
  end
end

function title.update(self, dt)
  title.duration = title.duration + dt
  title.logo:update(dt)
end

function title.draw()
  love.graphics.setColor(0, 0, 0, 150)

  title.logo:draw()
  
  if title.duration < title.fadeDelay then
    title.fadeAlpha = 0
  elseif title.duration > title.fadeDelay + title.fadeTime then
    title.fadeAlpha = 255
  else
    title.fadeAlpha = (title.duration - title.fadeDelay) / title.fadeTime * 255
  end
   
  love.graphics.setColor(0, 0, 0, title.fadeAlpha)
  
  love.graphics.setFont(fonts.default)

  love.graphics.print("by jay roberts", 
                      70, 
                      love.graphics.getHeight() - 50);

end

