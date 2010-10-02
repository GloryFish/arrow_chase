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
  
  title.logo = Typeout('arrow_chase', vector(65, love.graphics.getHeight() - 120), 7, fonts.title, {r=0, g=0, b=0, a=200})
  title.duration = 0

  title.fadeDelay = 1.8
  title.fadeTime = 3
  title.fadeAlpha = 0
  
  music.title:setVolume(1.0)
  love.audio.play(music.title)
  
  title.leaving = false
  title.leaveTime = 1.5
end

function title.keypressed(self, key, unicode)
  if (key == "escape") then
    love.event.push('q')
  end
end

function title.mousereleased(self, x, y, button)
  if button == "l" and not title.leaving then
    title.leaving = true
    title.leaveStart = title.duration
  end
end

function title.update(self, dt)
  title.duration = title.duration + dt
  title.logo:update(dt)
  
  if title.leaving and title.duration < title.leaveStart + title.leaveTime then
    music.title:setVolume(1.0 - (title.duration - title.leaveStart) / title.leaveTime)
  elseif title.leaving and title.duration > title.leaveStart + title.leaveTime then
    Gamestate.switch(chase)
  end
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
                      love.graphics.getHeight() - 60);

  love.graphics.print("<click> to begin", 
                      love.graphics.getWidth() / 2 - 70, 
                      love.graphics.getHeight() / 2);

  if title.leaving then
    local overlayAlpha = (title.duration - title.leaveStart) / title.leaveTime * 255
    love.graphics.setColor(255, 255, 255, overlayAlpha)
    
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end

end

function title.leave()
  love.audio.stop()
end
