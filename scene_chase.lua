-- 
--  chase.lua
--  arrow_chase
--  
--  Created by Jay Roberts on 2010-09-29.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'gamestate'
require 'arrow'
require 'overlay'
require 'logger'
require 'vector'
require 'level'

chase = Gamestate.new()

function chase.enter(self, pre)
  chase.paused = false
  chase.points = 0
  chase.misses = 0
  chase.health = 100

  chase.level = Level()

  chase.directions = {
    'up',
    'down',
    'right',
    'left',
  }

  chase.seed = os.time()
  math.randomseed(chase.seed);
  math.random(); math.random(); math.random()  
  
  -- Set graphics options
  love.graphics.setBackgroundColor(210, 231, 245)
  love.graphics.setFont(fonts.default)
  
  chase.arrows = {}
  chase.inactive = {}
  
  chase.overlay = Overlay()
  
  chase.lastMouse = {
    x = love.mouse.getX(),
    y = love.mouse.getY(),
    l = false,
  }
  
  chase.sound = {
    good = love.audio.newSource("resources/sound/good.mp3"),
    bad = love.audio.newSource("resources/sound/bad.mp3"),
    click = love.audio.newSource("resources/sound/click.mp3"),
  }
  
  chase.logger = Logger(vector(30, 30))
  
  chase.duration = 0.00001
  
  love.audio.play(music.chase)
end

function chase.update(self, dt)
  chase.duration = chase.duration + dt
  
  if not chase.paused then
    
    chase.logger:update(dt)

    -- Loop through arrows and process them
    local toRemove = {}
    local activeArrowCount = 0
  
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

      -- Tally the number of active arrows
      if arrow.state == 'normal' or arrow.state == 'selected' then
        activeArrowCount = activeArrowCount + 1
      end
      
      arrow:update(dt)
    end

    -- Remove errors marked for deactivation
    for i, index in pairs(toRemove) do
      chase.deactivateArrow(index)
    end
    
    -- Should we spawn a new arrow?
    if activeArrowCount < chase.level.minArrows then
      chase.addArrow()
    elseif #chase.arrows < chase.level.maxArrows then
      if math.random() < chase.level.arrowSpawnChance then
        chase.addArrow()
      end
    end
  
    chase.overlay:update(dt)
  
    -- Store last mouse position
    chase.lastMouse = {
      x = love.mouse.getX(),
      y = love.mouse.getY(),
      l = love.mouse.isDown('l'),
    } 
    
    -- Add log lines
    chase.logger:addLine(string.format("FPS: %i", love.timer.getFPS()))
    -- chase.logger:addLine(string.format("X: %i Y: %i", love.mouse.getX(), love.mouse.getY()))
    -- chase.logger:addLine(string.format("Score: %i", chase.points - chase.misses))
    -- chase.logger:addLine(string.format("Misses: %i MPM: %f", chase.misses, chase.misses / chase.duration * 60))
    chase.logger:addLine(string.format("Points: %i", chase.points, chase.points / chase.duration * 60))
    chase.logger:addLine(string.format("minArrows: %i", chase.level.minArrows))
    chase.logger:addLine(string.format("maxArrows: %i", chase.level.maxArrows))
    chase.logger:addLine(string.format("activeArrowCount: %i", activeArrowCount))
    chase.logger:addLine(string.format("Time: %i:%i", chase.duration / 60, chase.duration % 60))
    chase.logger:addLine(string.format("Rating: %i", (chase.points / chase.duration * 60) - (chase.misses / chase.duration * 60)))
    chase.logger:addLine(string.format("Health: %i", chase.health))
  else -- Game is paused
  end
  
end


function chase.keypressed(self, key, unicode)
  if (key == "escape") then
    if chase.paused then
      chase.togglePaused()
    else
      Gamestate.switch(title)
    end
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
  local speed = math.random(chase.level.minSpeed, chase.level.maxSpeed)
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
  chase.points = chase.points + 1
  chase.health = chase.health + 1
  if (chase.health > 100) then
    chase.health = 100
  end
  
  chase.level:setPoints(chase.points)
  
  chase.overlay.opacity = 1 - (chase.health / 100)
  
  love.audio.play(chase.sound.good)
end

function chase.deductPoint()
  chase.misses = chase.misses + 1
  chase.health = chase.health - 10

  chase.overlay.opacity = 1.0 - (chase.health / 100)

  -- love.audio.play(chase.sound.bad)
  
  if chase.health <= 0 then
    chase.gameover()
  end
end

function chase.gameover()
  Gamestate.switch(gameover)
end

function chase.draw(self)
  for index, arrow in pairs(chase.arrows) do
    arrow:draw()
  end

  chase.logger:addLine()

  love.graphics.setFont(fonts.hud)

  -- Print time 
  love.graphics.setColor(0, 0, 0, 200)
  local time = string.format("%i:%02d", chase.duration / 60, chase.duration % 60)
  local timeWidth = fonts.hud:getWidth(time)
  
  love.graphics.print(time, 
                      love.graphics.getWidth() / 2 - timeWidth, 
                      love.graphics.getHeight() - 70);

  local score = string.format('%i', chase.points)
  local scoreWidth = fonts.hud:getWidth(score)

  -- Print score
  love.graphics.setColor(0, 0, 0, 200)
  love.graphics.print(score, 
                      love.graphics.getWidth() / 2 + scoreWidth, 
                      love.graphics.getHeight() - 70);

  
  chase.overlay:draw()
  
  if (chase.paused) then
    love.graphics.setColor(0, 0, 0, 120)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("paused_", 
                        love.graphics.getWidth() / 2 - 50, 
                        love.graphics.getHeight() / 2);
  end
  
  -- chase.logger:draw()
end

function chase.leave()
  love.audio.stop()
end
