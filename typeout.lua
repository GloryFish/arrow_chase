-- 
--  typeout.lua
--  arrow_chase
--
--  Types out the supplied text then continually blinks the cursor
--  
--  Created by Jay Roberts on 2010-09-29.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'class'

require 'class'
require 'vector'

Typeout = class(function(typeout, text, pos, rate, font, color)
  typeout.text     = text
  typeout.position = pos
  typeout.rate     = rate
  typeout.font     = font
  typeout.color    = color
  typeout.duration  = 0
end)

function Typeout:update(dt)
  self.duration = self.duration + dt
end

function Typeout:draw(dt)
  love.graphics.setFont(self.font)
  
  love.graphics.setColor(self.color.r,
                         self.color.g,
                         self.color.b,
                         self.color.a);

  love.graphics.print(self:getText(), 
                      self.position.x, 
                      self.position.y);
end

function Typeout:getText()
  chars = math.floor(self.duration * self.rate)
  if chars > string.len(self.text) then
    chars = string.len(self.text)
  end
  
  text = string.sub(self.text, 1, chars)

  local int, frac = math.modf(self.duration * 1) -- Adjust the final constant to change the blink speed of the cursor
  
  if (chars < string.len(self.text) or frac < 0.5) then
    text = text .. "_"
  end
  
  return text
end