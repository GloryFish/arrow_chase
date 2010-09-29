-- 
--  arrow.lua
--  Arrowchase
--  
--  Created by Jay Roberts on 2010-09-28.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'class'

Arrow = class(function(arrow, dir, pos)
              arrow.direction = dir
              arrow.position = pos
              arrow.image = love.graphics.newImage('resources/textures/arrow-green.png')
              
              arrow.speed = 50
              
              if dir == 'down' then
                arrow.orientation = 0
              elseif dir == 'left' then
                arrow.orientation = math.rad(90)
              elseif dir == 'up' then 
                arrow.orientation = math.rad(180)
              elseif dir == 'right' then 
                arrow.orientation = math.rad(270)
              end
           end)

function Arrow:update(dt)
  self:move(dt)
end

function Arrow:move(dt)
  if (self.direction == 'up') then
    self.position.y = self.position.y - (self.speed * dt)
  elseif (self.direction == 'down') then
    self.position.y = self.position.y + (self.speed * dt)
  elseif (self.direction == 'left') then
    self.position.x = self.position.x - (self.speed * dt)
  elseif (self.direction == 'right') then
    self.position.x = self.position.x + (self.speed * dt)
  end
end

function Arrow:draw()
  love.graphics.draw(self.image, math.floor(self.position.x), math.floor(self.position.y), self.orientation)
end

-- can create an Account using call notation!
-- acc = Account(1000)
-- acc:withdraw(100)