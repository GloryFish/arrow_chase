-- 
--  arrow.lua
--  Arrowchase
--  
--  Created by Jay Roberts on 2010-09-28.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'class'

Arrow = class(function(arrow, dir, pos, speed)
              arrow.direction = dir
              arrow.position = pos
              arrow.speed = speed
              arrow.state = 'normal'
              arrow.scale = {
                x = 1.0,
                y = 1.0,
              }

              arrow.image = love.graphics.newImage('resources/textures/arrow-green.png')
              arrow.imageSelected = love.graphics.newImage('resources/textures/arrow-red.png')

              arrow.offset = {
                x = arrow.image:getWidth() / 2,
                y = arrow.image:getHeight() / 2,
              }
              
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
           
function Arrow:reset(dir, pos, speed)
  self.direction = dir
  self.position = pos
  self.speed = speed
  self.state = 'normal'
  
  if dir == 'down' then
    self.orientation = 0
  elseif dir == 'left' then
    self.orientation = math.rad(90)
  elseif dir == 'up' then 
    self.orientation = math.rad(180)
  elseif dir == 'right' then 
    self.orientation = math.rad(270)
  end
end

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

function Arrow:isOffscreen()
  if self.direction == 'up' then
    return self.position.y + (self:getHeight() / 2) < 0

  elseif self.direction == 'down' then
    return self.position.y + (self:getHeight() / 2) > love.graphics.getHeight() + self:getHeight()

  elseif self.direction == 'left' then
    return self.position.x + (self:getWidth() / 2) < 0

  elseif self.direction == 'right' then
    return self.position.x - (self:getWidth() / 2) > love.graphics:getWidth()
  end
end

function Arrow:getWidth()
  return self.image:getWidth() * self.scale.x
end

function Arrow:getHeight()
  return self.image:getHeight() * self.scale.y
end

function Arrow:containsPoint(point)
  return point.x > self.position.x - (self:getWidth() / 2) and
         point.x < self.position.x + (self.image:getWidth() / 2) and
         point.y > self.position.y - (self:getHeight() / 2) and
         point.y < self.position.y + (self.image:getHeight() / 2)
end

function Arrow:setState(state)
  self.state = state
  
  if state == 'selected' then
    self.scale = {
      x = 1.2,
      y = 1.2,
    }
  else
    self.scale = {
      x = 1.0,
      y = 1.0,
    }
  end
end

function Arrow:draw()
  if (self.state == 'selected') then
    love.graphics.draw(
      self.imageSelected, 
      math.floor(self.position.x),
      math.floor(self.position.y), 
      self.orientation, 
      self.scale.x, 
      self.scale.y, 
      self.offset.x,
      self.offset.y
      )
  else
    love.graphics.draw(
      self.image, 
      math.floor(self.position.x),
      math.floor(self.position.y), 
      self.orientation, 
      self.scale.x, 
      self.scale.y, 
      self.offset.x,
      self.offset.y
      )
  end
end

-- can create an Account using call notation!
-- acc = Account(1000)
-- acc:withdraw(100)