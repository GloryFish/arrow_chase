-- 
--  chase.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-09-29.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'gamestate'
require 'arrow'
require 'logger'
require 'vector'

chase = Gamestate.new()

function chase.enter(self, pre)
  chase.paused = false
  chase.score = 20
  chase.points = 0

  chase.const = {
    minSpeed = 20,
    maxSpeed = 200,
    maxArrows = 20,
  }

  chase.directions = {
    'up',
    'down',
    'right',
    'left',
  }

  chase.seed = os.time()
  math.randomseed(chase.seed);
  
  -- Set graphics options
  love.graphics.setBackgroundColor(210, 231, 245)
  love.graphics.setFont(fonts.default)
  
  chase.arrows = {}
  chase.inactive = {}
  
  chase.lastMouse = {
    x = love.mouse.getX(),
    y = love.mouse.getY(),
    l = false,
  }
  
  chase.music = love.audio.newSource("resources/music/vibe-ydb.it")
  chase.music:setLooping(true)
  
  chase.sound = {
    good = love.audio.newSource("resources/sound/good.mp3"),
    bad = love.audio.newSource("resources/sound/bad.mp3"),
    click = love.audio.newSource("resources/sound/click.mp3"),
  }
  
  chase.logger = Logger(vector(30, 30))
  
  love.audio.play(chase.music)
end

function chase.update(self, dt)
  val = dt * 2
  
  if not chase.paused then
    
    chase.logger:update(dt)
  
    if #chase.arrows < chase.const.maxArrows then
      chase.addArrow()
    end
  
    local toRemove = {}
  
    for index, arrow in pairs(chase.arrows) do
      if arrow.state == 'dead' then
        -- Remove arrows that died during the last update
        table.insert(toRemove, index)

      elseif arrow:isOffscreen() then
        -- remove arrows that moved offscreen
        table.insert(toRemove, index)

      elseif arrow:containsPoint( {x = love.mouse.getX(), y = love.mouse.getY()}) and arrow.state == 'normal' then
        -- Check for mouse hovers
        if arrow:isInFrontOfPoint(chase.lastMouse) then
          -- This is a new selection from behind the arrow
          arrow:setState('selected')
          love.audio.play(chase.sound.click)
        else
          -- This is a failed selection
          chase.deductPoint()
          arrow:setState('dying')
        end
      elseif arrow.state == 'selected' and not arrow:containsPoint( {x = love.mouse.getX(), y = love.mouse.getY()}) then
        --  Mouse has moved off arrow
        arrow:setState('normal')
      end

      -- Check for clicks
      if arrow.state == 'selected' and love.mouse.isDown('l') and not chase.lastMouse.l then
        chase.addPoint()
        arrow:setState('clicked')
      end
    
      arrow:update(dt)
    
    end
  
    for i, index in pairs(toRemove) do
      chase.deactivateArrow(index)
    end
  
    chase.lastMouse = {
      x = love.mouse.getX(),
      y = love.mouse.getY(),
      l = love.mouse.isDown('l'),
    } 
    
    -- Add log lines
    chase.logger:addLine(string.format("FPS: %i", love.timer.getFPS()))
    chase.logger:addLine(string.format("X: %i  Y: %i", love.mouse.getX(), love.mouse.getY()))
    chase.logger:addLine(string.format("Seed: %i", chase.seed))
    chase.logger:addLine(string.format("Score: %i", chase.score))
    chase.logger:addLine(string.format("Points: %i", chase.points))
    
  else -- Game is paused
  end
  
end


function chase.keypressed(self, key, unicode)
  if (key == "escape") then
    Gamestate.switch(title)
  elseif (key == "p") then
    chase.togglePaused()
  end
end


function chase.mousepressed(x, y, button)

end

function chase.togglePaused()
  chase.paused = not chase.paused
end

function chase.addArrow()
  local dir = chase.directions[math.random(1, #chase.directions)]
  local position = chase.getRandomStart[dir]()
  local speed = math.random(chase.const.minSpeed, chase.const.maxSpeed)
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
      return vector(math.random(100, love.graphics.getWidth() - 100), love.graphics.getHeight() + 100)
    end,
  ['down'] = function ()
      return vector(math.random(100, love.graphics.getWidth() - 100), -100)
    end,
  ['left'] = function ()
      return vector(love.graphics.getWidth() + 100, math.random(100, love.graphics.getHeight() - 100))
    end,
  ['right'] = function ()
      return vector(-100, math.random(100, love.graphics.getHeight() - 100))
    end,
}
  
function chase.addPoint()
  chase.score = chase.score + 1
  chase.points = chase.points + 1

  love.audio.play(chase.sound.good)
end

function chase.deductPoint()
  chase.score = chase.score - 1

  love.audio.play(chase.sound.bad)
end

function chase.draw(self)
  for index, arrow in pairs(chase.arrows) do
    arrow:draw()
  end
  
  chase.logger:draw()
end
