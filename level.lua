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
  level.maxMisses = 100
  level.arrowSpawnChance = 0.001
  level.healthRestoreRate = 1
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
      self.arrowSpawnChance = 0.002

    elseif points >= 30 and points < 40 then
      self.minSpeed = 50
      self.maxSpeed = 150
      self.minArrows = 8
      self.maxArrows = 12
      self.arrowSpawnChance = 0.009

    elseif points >= 40 and points < 50 then
      self.minSpeed = 60
      self.maxSpeed = 135
      self.minArrows = 10
      self.maxArrows = 15
      self.arrowSpawnChance = 0.03

    elseif points >= 50 and points < 60 then
      self.minSpeed = 70
      self.maxSpeed = 150
      self.minArrows = 12
      self.maxArrows = 20
      self.arrowSpawnChance = 0.05

    elseif points >= 60 and points < 70 then
      self.minSpeed = 80
      self.maxSpeed = 170
      self.minArrows = 14
      self.maxArrows = 22
      self.arrowSpawnChance = 0.07

    elseif points >= 70 and points < 80 then
      self.minSpeed = 100
      self.maxSpeed = 180
      self.minArrows = 16
      self.maxArrows = 25
      self.arrowSpawnChance = 0.1

    elseif points >= 90 and points < 100 then
      self.minSpeed = 100
      self.maxSpeed = 190
      self.minArrows = 18
      self.maxArrows = 100
      self.arrowSpawnChance = 0.1

    elseif points >= 100 then
      self.minSpeed = 100
      self.maxSpeed = 200
      self.minArrows = 20
      self.maxArrows = 30
      self.arrowSpawnChance = 0.0025

    end
    
  end
end