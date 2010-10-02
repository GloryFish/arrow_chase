-- 
--  overlay.lua
--  arrow_chase
--
--  Display a red overlay to indicate how close to losing the player is.
--
--  Created by Jay Roberts on 2010-10-02.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 


require 'class'
require 'vector'

Overlay = class(function(overlay, dir, pos, speed)
  overlay.image = love.graphics.newImage('resources/textures/overlay.png')
  overlay.opacity = 0
end)

function Overlay:update(dt)
end

function Overlay:draw()
  love.graphics.setColor(255,
                         255,
                         255,
                         self.opacity * 255);
  
  love.graphics.draw(self.image, 0, 0)
end


