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
require 'logger'
require 'vector'
require 'gamestate'
require 'scene_chase'

function love.load()
  love.filesystem.setIdentity('arrow_chase')
  
  -- love.mouse.setGrab(true)
  
  -- Set graphics options
  love.graphics.setCaption("arrow_chase 0.1")
  
  -- Preload graphics
  graphics = {
    arrowNormal = love.graphics.newImage('resources/textures/arrow-green.png'),
    arrowSelected = love.graphics.newImage('resources/textures/arrow-red.png'),
    arrowDying = love.graphics.newImage('resources/textures/arrow-grey.png'),
  }
  
  Gamestate.registerEvents()
  Gamestate.switch(chase)
end


function love.update(dt)
end