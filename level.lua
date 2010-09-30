-- 
--  level.lua
--  arrow_chase
--
--  
--   
--  Created by Jay Roberts on 2010-09-30.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'class'

Level = class(function(level)
  level.points = 0
  level.minSpeed = 30
  level.maxSpeed = 50
  level.minArrows = 1
  level.maxArrows = 3
  level.arrowSpawnChance = 0.001
end)


function Level:setPoints(points)
  if points ~= self.points then
    -- Update level paramteres
    if points >= 3 and points < 10 then
      self.minSpeed = 30
      self.maxSpeed = 60
      self.minArrows = 1
      self.maxArrows = 5
      self.arrowSpawnChance = 0.005

    elseif points >= 10 and points < 15 then
      self.minSpeed = 35
      self.maxSpeed = 90
      self.minArrows = 2
      self.maxArrows = 6
      self.arrowSpawnChance = 0.009
      
    elseif points >= 15 and points < 30 then
      self.minSpeed = 40
      self.maxSpeed = 100
      self.minArrows = 4
      self.maxArrows = 8
      self.arrowSpawnChance = 0.0015

    elseif points >= 30 then
      self.minSpeed = 50
      self.maxSpeed = 125
      self.minArrows = 6
      self.maxArrows = 10
      self.arrowSpawnChance = 0.0015


    end
    
  end
end