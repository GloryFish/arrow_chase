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
require 'scene_title'
require 'scene_chase'
require 'scene_gameover'

function love.load()
  love.filesystem.setIdentity('arrow_chase')
  
  -- love.mouse.setGrab(true)
  
  -- Set graphics options
  love.graphics.setCaption("arrow_chase 0.1")
  
  -- Preload resources
  graphics = {
    arrowNormal = love.graphics.newImage('resources/textures/arrow-green.png'),
    arrowSelected = love.graphics.newImage('resources/textures/arrow-red.png'),
    arrowDying = love.graphics.newImage('resources/textures/arrow-grey.png'),
  }
  
  fonts = {
    default = love.graphics.newFont('resources/fonts/pixel.ttf', 15),
    title = love.graphics.newFont('resources/fonts/pixel.ttf', 45),
    hud = love.graphics.newFont('resources/fonts/pixel.ttf', 25),
  }
  
  music = {
    title = love.audio.newSource("resources/music/vibe-tth.it"),
    chase = love.audio.newSource("resources/music/vibe-ydb.it"),
  }
  
  music.title:setLooping(true)
  music.chase:setLooping(true)
  
  Gamestate.registerEvents()
  Gamestate.switch(title)
end


function love.update(dt)
end