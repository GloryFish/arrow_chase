-- 
--  flash.lua
--  arrow_chase
--  
--  Display a flash that fades out over time
--
--  Created by Jay Roberts on 2010-10-02.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'class'

Flash = class(function(flash, dir, pos, speed)
  flash.opacity = 0
  flash.decay = 1.0
  
end)

function Flash:update(dt)
  self.opacity = self.opacity - self.decay * dt
  
  if (self.opacity < 0) then
    self.opacity = 0
  end
  
end

function Flash:draw()
  love.graphics.setColor(255, 255, 255, self.opacity * 255)
  
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function Flash:trigger()
  self.opacity = 1.0
end