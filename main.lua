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

chase.directions = {
  'up',
  'down',
  'right',
  'left',
}

function love.load()
  math.randomseed(os.time());
  
  love.filesystem.setIdentity('arrow_chase')
  
  -- Set graphics options
  love.graphics.setCaption("arrow_chase 0.1")
  love.graphics.setBackgroundColor(210, 231, 245)
  chase.fontDefault = love.graphics.newFont('resources/fonts/pixel.ttf', 15)
  love.graphics.setFont(chase.fontDefault)
  
  chase.arrows = {}
  
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
  if #chase.arrows < 10 then
    chase.addArrow()
  end
  
  for index, arrow in pairs(chase.arrows) do
    arrow:update(dt)
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
  
  local arrow = Arrow(dir, position)
  table.insert(chase.arrows, arrow)
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
  --  Print log stuff
  local currentLinePosition = 0
  love.graphics.print(string.format("arrow_chase"), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
  love.graphics.print(string.format("FPS: %i", love.timer.getFPS()), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;
  love.graphics.print(string.format("X: %i  Y: %i", love.mouse.getX(), love.mouse.getY()), chase.ui.logPosition.x, chase.ui.logPosition.y + currentLinePosition); currentLinePosition = currentLinePosition + chase.ui.lineHeight;

  for index, arrow in pairs(chase.arrows) do
    arrow:draw()
  end
end

-- Reset values when returning to board list
function chase.resume()
  load = nil
  love.update = chase.update
  love.draw = chase.draw
  love.keypressed = chase.keypressed
  love.mousepressed = chase.mousepressed
end

