-- 
--  main.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-09-28.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

-- 
--  main.lua
--  lovetest
--  
--  Created by Jay Roberts on 2010-09-22.
--  Copyright 2010 DesignHammer. All rights reserved.
--

require 'arrow'

chase = {}

-- Some ui constants
chase.ui = {
  lineHeight = 15,
  logPosition = {
    x = 50,
    y = 50,
  }
}

chase.const = {
  topSpeed = 300,
  maxArrows = 20,
}


chase.directions = {
  'up',
  'down',
  'right',
  'left',
}

-- chase.directions = {
--   'down',
-- }

function love.load()
  chase.seed = os.time()

  math.randomseed(chase.seed);
  
  love.filesystem.setIdentity('arrow_chase')
  
  -- Set graphics options
  love.graphics.setCaption("arrow_chase 0.1")
  love.graphics.setBackgroundColor(210, 231, 245)
  chase.fontDefault = love.graphics.newFont('resources/fonts/pixel.ttf', 15)
  love.graphics.setFont(chase.fontDefault)
  
  chase.arrows = {}
  chase.inactive = {}
  
  chase.resume()
end

--  Override default callbacks
function love.update(dt) end
function love.draw() end
function love.keypressed(k) end
function love.keyreleased(k) end
function love.mousepressed(x, y, b) end
function love.mousereleased(x, y, b) end

function chase.update(dt)
  if #chase.arrows < chase.const.maxArrows then
    chase.addArrow()
  end
  
  local toRemove = {}
  
  for index, arrow in pairs(chase.arrows) do
    if arrow:isOffscreen() then
      table.insert(toRemove, index)
      break
    end
    
    if arrow:containsPoint( {x = love.mouse.getX(), y = love.mouse.getY()} ) then
      arrow:setState('selected')
    else
      arrow:setState('normal')
    end
    
    arrow:update(dt)

  end
  
  for i, index in pairs(toRemove) do
    chase.deactivateArrow(index)
  end
  
end


function chase.keypressed(key, unicode)
  if (key == "escape") then
    love.event.push('q')
  end
end


function chase.mousepressed(x, y, button)

end

function chase.addArrow()
  local dir = chase.directions[math.random(1, #chase.directions)]
  local position = chase.getRandomStart[dir]()
  local speed = math.random(20, chase.const.topSpeed)
  local arrow = {}

  --  Get an inactive arrow, or create a new one
  if #chase.inactive == 0 then
    arrow = Arrow(dir, position, speed)
  else
    arrow = table.remove(chase.inactive)    
    arrow:reset(dir, position, speed)
  end

  table.insert(chase.arrows, arrow)
end


function chase.deactivateArrow(index)
  arrow = table.remove(chase.arrows, index)    
  table.insert(chase.inactive, arrow)
end

-- Return an appropriate starting position for an arrow based on its direction
chase.getRandomStart = {
  ['up'] = function ()
      return {
        x = math.random(100, love.graphics.getWidth() - 100),
        y = love.graphics.getHeight() + 100,
      }
    end,
  ['down'] = function ()
      return {
        x = math.random(100, love.graphics.getWidth() - 100),
        y = -100,
      }
    end,
  ['left'] = function ()
      return {
        x = love.graphics.getWidth() + 100,
        y = math.random(100, love.graphics.getHeight() - 100),
      }
    end,
  ['right'] = function ()
      return {
        x = -100,
        y = math.random(100, love.graphics.getHeight() - 100),
      }
    end,
}
  


function chase.draw()
  love.graphics.setColor(255, 255, 255, 255);
  for index, arrow in pairs(chase.arrows) do
    arrow:draw()
  end

  --  Print log stuff
  love.graphics.setColor(0, 0, 0, 150);
  local currentLinePosition = 0
  love.graphics.print(string.format("arrow_chase"), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
  love.graphics.print(string.format("FPS: %i", love.timer.getFPS()), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
  love.graphics.print(string.format("X: %i  Y: %i", love.mouse.getX(), love.mouse.getY()), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
  love.graphics.print(string.format("Seed: %i", chase.seed), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
end

-- Reset values when returning to board list
function chase.resume()
  load = nil
  love.update = chase.update
  love.draw = chase.draw
  love.keypressed = chase.keypressed
  love.mousepressed = chase.mousepressed
end

